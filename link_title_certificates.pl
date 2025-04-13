#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use DBD::mysql;
use JSON;
use Getopt::Long;
use Term::ANSIColor;
use File::Basename;

# ======================= Command Line Options =======================
my $config_file = "../eqemu_config.json";
my $dry_run = 0;
my $verbose = 0;
my $help = 0;
my $force_update = 0;
my $cleanup_mismatched = 0;

GetOptions(
    "config=s"         => \$config_file,
    "dry-run"          => \$dry_run,
    "verbose"          => \$verbose,
    "help"             => \$help,
    "force-update"     => \$force_update,
    "cleanup-mismatched" => \$cleanup_mismatched
) or die "Error in command line arguments\n";

if ($help) {
    print_help();
    exit 0;
}

# ======================= Helper Functions =======================
sub print_help {
    my $script_name = basename($0);
    print "\nTitle Certificate Linking Tool\n";
    print "===========================\n\n";
    print "Usage: $script_name [options]\n\n";
    print "Options:\n";
    print "  --config=FILE       Path to eqemu_config.json (default: '../eqemu_config.json')\n";
    print "  --dry-run           Show what would be done without making changes\n";
    print "  --verbose           Show detailed information\n";
    print "  --force-update      Force update all titles even if they haven't changed\n";
    print "  --cleanup-mismatched Remove title records that reference a certificate but with incorrect title values\n";
    print "  --help              Display this help message\n\n";
    
    print "Example usage:\n";
    print "  $script_name --dry-run               # Test run with default config\n";
    print "  $script_name --cleanup-mismatched    # Clean up mismatched title records\n";
    print "  $script_name --force-update          # Force update all titles\n";
}

sub log_info {
    my ($message) = @_;
    print "$message\n";
}

sub log_verbose {
    my ($message) = @_;
    print "$message\n" if $verbose;
}

sub log_success {
    my ($message) = @_;
    print colored(['green'], "✓ $message\n");
}

sub log_warning {
    my ($message) = @_;
    print colored(['yellow'], "⚠ $message\n");
}

sub log_error {
    my ($message) = @_;
    print colored(['red'], "✗ $message\n");
}

# ======================= Database Functions =======================
sub load_database_config {
    my ($config_path, $db_type) = @_;
    
    log_verbose("Loading $db_type database configuration from $config_path");
    
    # Check if config file exists
    unless (-e $config_path) {
        die "Config file '$config_path' not found. Please check the path.\n";
    }
    
    # Load Config
    my $content;
    open(my $fh, '<', $config_path) or die "Cannot open config file '$config_path': $!\n";
    {
        local $/;
        $content = <$fh>;
    }
    close($fh);
    
    # Decode JSON
    my $json = JSON->new->utf8;
    my $config = $json->decode($content);
    
    # Set DB section based on type
    my $db_section;
    
    if ($db_type eq 'content') {
        # For content DB, try content_database first, then fall back to regular database
        if (exists $config->{"server"}{"content_database"}) {
            $db_section = $config->{"server"}{"content_database"};
            log_verbose("Using content_database section for content database");
        } elsif (exists $config->{"server"}{"database"}) {
            $db_section = $config->{"server"}{"database"};
            log_verbose("Content database section not found, falling back to database section");
        } else {
            log_error("No database configuration found in config file");
            die "Could not find database configuration in eqemu_config.json\n";
        }
    } elsif ($db_type eq 'player') {
        if (exists $config->{"server"}{"database"}) {
            $db_section = $config->{"server"}{"database"};
            log_verbose("Using database section for player database");
        } else {
            log_error("Player database configuration not found in config file");
            die "Could not find database section in eqemu_config.json\n";
        }
    } else {
        die "Invalid database type '$db_type' specified\n";
    }
    
    # Set MySQL Connection vars with defaults if not defined
    my $db   = $db_section->{"db"} || "";
    my $host = $db_section->{"host"} || "localhost";
    my $user = $db_section->{"username"} || "";
    my $pass = $db_section->{"password"} || "";
    
    # Validate we have the minimum required fields
    unless ($db) {
        die "Database name not found in $db_type section of config file.\n";
    }
    
    unless ($user) {
        die "Database username not found in $db_type section of config file.\n";
    }
    
    return {
        db => $db,
        host => $host,
        user => $user,
        pass => $pass
    };
}

sub connect_to_database {
    my ($config, $db_type) = @_;
    
    log_verbose("Connecting to $db_type database '$config->{db}' on '$config->{host}'");
    
    # Map DSN - Handle both socket and TCP connections
    my $dsn;
    if ($config->{host} eq 'localhost' || $config->{host} eq '127.0.0.1') {
        # Try TCP first, which is more likely to work across different setups
        $dsn = "dbi:mysql:database=$config->{db};host=$config->{host};port=3306";
    } else {
        # For non-localhost hosts, always use TCP
        $dsn = "dbi:mysql:database=$config->{db};host=$config->{host};port=3306";
    }
    
    log_verbose("Connection string: $dsn (username: $config->{user})");
    
    # Connect with error handling
    my $dbh;
    eval {
        $dbh = DBI->connect($dsn, $config->{user}, $config->{pass}, {
            mysql_enable_utf8 => 1,
            RaiseError => 1,        # Changed from 0 to 1 to get better error reporting
            PrintError => 1,        # Changed from 0 to 1 to see errors
            AutoCommit => 1         # Changed from 0 to 1 for safer transaction management
        });
    };
    
    if ($@ || !$dbh) {
        my $error = $@ || $DBI::errstr || "Unknown error";
        my $advice = "";
        
        if ($error =~ /Can't connect to .* through socket/) {
            $advice = "MySQL may not be running or the socket path is incorrect.\n" .
                      "Try using a TCP connection instead by setting the host to '127.0.0.1' instead of 'localhost'.\n" .
                      "Make sure MySQL is running with: sudo systemctl status mysql";
        } elsif ($error =~ /Access denied/) {
            $advice = "Check your username and password in eqemu_config.json";
        } elsif ($error =~ /Unknown database/) {
            $advice = "The database '$config->{db}' does not exist. You may need to create it.";
        }
        
        die "Failed to connect to $db_type database: $error\n$advice\n";
    }
    
    # Turn off AutoCommit only after successful connection, when we need to manage our own transactions
    $dbh->{AutoCommit} = 0;
    $dbh->{RaiseError} = 1;
    
    log_success("$db_type database connection established");
    return $dbh;
}

# ======================= Main Function =======================
sub main {
    # Print banner
    print "\n";
    print "╔═══════════════════════════════════════════════╗\n";
    print "║           Title Certificate Linker             ║\n";
    print "╚═══════════════════════════════════════════════╝\n\n";
    
    if ($dry_run) {
        log_info("Running in DRY RUN mode - no changes will be made");
    }
    
    # Load database configurations
    my $content_db_config = load_database_config($config_file, 'content');
    my $player_db_config = load_database_config($config_file, 'player');
    
    # Connect to both databases
    my $content_db = connect_to_database($content_db_config, 'content');
    my $player_db = connect_to_database($player_db_config, 'player');
    
    # Create a fresh connection for verification that will be used later
    my $verify_db = connect_to_database($player_db_config, 'verification');
    
    # Find all title certificates in content database
    log_verbose("Querying all title certificates from content database");
    my $cert_query = "SELECT id, `Name` FROM items WHERE `Name` LIKE 'Suffix Title Certificate - %' OR `Name` LIKE 'Prefix Title Certificate - %'";
    my $cert_sth = $content_db->prepare($cert_query);
    $cert_sth->execute();
    
    # Prepare insert query for player database - set all other fields to -1
    # Using the actual schema from the DDL
    my $insert_query = "INSERT INTO titles (prefix, suffix, title_set, skill_id, min_skill_value, max_skill_value, 
                        min_aa_points, max_aa_points, class, gender, char_id, status, item_id) 
                        VALUES (?, ?, ?, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1)";
    my $insert_sth = $player_db->prepare($insert_query);
    
    # Prepare check query to see if a title already exists
    my $check_query = "SELECT id, prefix, suffix, title_set, skill_id, min_skill_value, max_skill_value, 
                      min_aa_points, max_aa_points, class, gender, char_id, status, item_id 
                      FROM titles WHERE title_set = ?";
    my $check_sth = $player_db->prepare($check_query);
    
    # Prepare update query for existing title records - set all other fields to -1
    my $update_query = "UPDATE titles 
                       SET prefix = ?, 
                           suffix = ?, 
                           skill_id = -1,
                           min_skill_value = -1,
                           max_skill_value = -1,
                           min_aa_points = -1,
                           max_aa_points = -1,
                           class = -1,
                           gender = -1,
                           char_id = -1, 
                           status = -1, 
                           item_id = -1
                       WHERE id = ?";
    my $update_sth = $player_db->prepare($update_query);
    
    # Prepare delete query for removing duplicate title records
    my $delete_query = "DELETE FROM titles WHERE title_set = ? AND id != ?";
    my $delete_sth = $player_db->prepare($delete_query);
    
    # Track statistics
    my $inserted = 0;
    my $updated = 0;
    my $verified = 0;
    my $deleted = 0;
    my $skipped = 0;
    my $total = 0;
    my $mismatched_deleted = 0;
    my %certificate_ids = ();
    
    # Track IDs for verification
    my @sample_ids = ();
    
    # Process each certificate
    while (my $row = $cert_sth->fetchrow_hashref()) {
        my $item_id = $row->{id};
        my $name = $row->{Name};
        $total++;
        
        # Keep track of all certificate IDs for orphan cleanup later
        $certificate_ids{$item_id} = 1;
        
        # Add to sample IDs for verification (first 10)
        push @sample_ids, $item_id if scalar(@sample_ids) < 10;
        
        # Extract the title and determine if prefix or suffix
        my ($prefix, $suffix) = ('', '');
        
        if ($name =~ /Prefix Title Certificate - '(.*?)'/) {
            $prefix = $1;
            # Strip any trailing whitespace
            $prefix =~ s/\s+$//;
        } elsif ($name =~ /Suffix Title Certificate - '(.*?)'/) {
            $suffix = $1;
            # Strip any trailing whitespace
            $suffix =~ s/\s+$//;
        } else {
            log_warning("Could not parse title from '$name', skipping");
            $skipped++;
            next;
        }
        
        # Check if this title already exists in the titles table based on title_set
        $check_sth->execute($item_id);
        my @existing_titles = ();
        
        log_verbose("Checking for existing title with title_set = $item_id");
        
        while (my $title_row = $check_sth->fetchrow_hashref()) {
            push @existing_titles, $title_row;
            log_verbose("Found existing title ID $title_row->{id} with title_set = $item_id");
        }
        
        if (@existing_titles) {
            # Title record(s) exist for this title_set
            
            # Update the first record with correct values
            my $first_title = $existing_titles[0];
            my $title_id = $first_title->{id};
            
            # Check if the content needs updating
            my $needs_update = $force_update || 
                               $first_title->{prefix} ne $prefix || 
                               $first_title->{suffix} ne $suffix ||
                               $first_title->{skill_id} != -1 ||
                               $first_title->{min_skill_value} != -1 ||
                               $first_title->{max_skill_value} != -1 ||
                               $first_title->{min_aa_points} != -1 ||
                               $first_title->{max_aa_points} != -1 ||
                               $first_title->{class} != -1 ||
                               $first_title->{gender} != -1 ||
                               $first_title->{char_id} != -1 ||
                               $first_title->{status} != -1 ||
                               $first_title->{item_id} != -1;
            
            if ($needs_update) {
                if ($dry_run) {
                    log_info("DRY RUN: Would update title ID $title_id for certificate ID $item_id with " . 
                           ($prefix ? "Prefix '$prefix'" : "Suffix '$suffix'") . " and reset all other fields to -1");
                } else {
                    eval {
                        $update_sth->execute($prefix, $suffix, $title_id);
                    };
                    if ($@) {
                        log_error("Failed to update title ID $title_id: $@");
                    } else {
                        log_success("Updated: Title ID $title_id for certificate ID $item_id with " . 
                                  ($prefix ? "Prefix '$prefix'" : "Suffix '$suffix'") . " and reset all other fields to -1");
                        $updated++;
                    }
                }
            } else {
                log_verbose("Verified: Title ID $title_id already has correct values for certificate ID $item_id");
                $verified++;
            }
            
            # Delete any additional records (duplicates) for this title_set
            if (scalar(@existing_titles) > 1) {
                for (my $i = 1; $i < scalar(@existing_titles); $i++) {
                    if ($dry_run) {
                        log_info("DRY RUN: Would delete duplicate title record for certificate ID $item_id");
                    } else {
                        eval {
                            $delete_sth->execute($item_id, $first_title->{id});
                        };
                        if ($@) {
                            log_error("Failed to delete duplicate title record: $@");
                        } else {
                            log_warning("Deleted: Duplicate title record for certificate ID $item_id");
                            $deleted++;
                        }
                    }
                }
            }
        } else {
            # No existing record - insert new one
            if ($dry_run) {
                log_info("DRY RUN: Would create new title record for certificate ID $item_id with " . 
                       ($prefix ? "Prefix '$prefix'" : "Suffix '$suffix'"));
            } else {
                eval {
                    $insert_sth->execute($prefix, $suffix, $item_id);
                };
                if ($@) {
                    log_error("Failed to insert new title record for certificate ID $item_id: $@");
                } else {
                    log_success("Created: New title record for certificate ID $item_id with " . 
                              ($prefix ? "Prefix '$prefix'" : "Suffix '$suffix'"));
                    $inserted++;
                }
            }
        }
        
        # Commit after every 100 records to avoid large transactions
        if (!$dry_run && ($inserted + $updated + $deleted) % 100 == 0) {
            eval {
                $player_db->commit();
                log_verbose("Committed batch of changes (processed $total certificates so far)");
            };
            if ($@) {
                log_error("Failed to commit batch: $@");
                eval { $player_db->rollback(); };
                log_error("Transaction rolled back due to commit failure");
            }
        }
    }
    
    # Cleanup mismatched title records if requested
    if ($cleanup_mismatched) {
        log_info("Looking for mismatched title records...");
        
        # First, get all title certificates from the content database
        my $cert_map_query = "SELECT id, `Name` FROM items WHERE `Name` LIKE 'Suffix Title Certificate - %' OR `Name` LIKE 'Prefix Title Certificate - %'";
        my $cert_map_sth = $content_db->prepare($cert_map_query);
        $cert_map_sth->execute();
        
        # Build a map of certificate ID to expected title values
        my %cert_map = ();
        while (my $cert = $cert_map_sth->fetchrow_hashref()) {
            my $item_id = $cert->{id};
            my $name = $cert->{Name};
            my $expected_prefix = '';
            my $expected_suffix = '';
            
            if ($name =~ /Prefix Title Certificate - '(.*?)'/) {
                $expected_prefix = $1;
                $expected_prefix =~ s/\s+$//; # Trim trailing whitespace
            } elsif ($name =~ /Suffix Title Certificate - '(.*?)'/) {
                $expected_suffix = $1;
                $expected_suffix =~ s/\s+$//; # Trim trailing whitespace
            }
            
            $cert_map{$item_id} = {
                prefix => $expected_prefix,
                suffix => $expected_suffix
            };
        }
        $cert_map_sth->finish();
        
        # Get all titles that reference a certificate
        my $titles_query = "SELECT id, title_set, prefix, suffix, skill_id, min_skill_value, max_skill_value, 
                          min_aa_points, max_aa_points, class, gender, char_id, status, item_id 
                          FROM titles WHERE title_set IS NOT NULL AND title_set > 0";
        my $titles_sth = $player_db->prepare($titles_query);
        $titles_sth->execute();
        
        # Reset the counter to avoid double-counting
        $mismatched_deleted = 0;
        
        while (my $title = $titles_sth->fetchrow_hashref()) {
            my $title_id = $title->{id};
            my $title_set = $title->{title_set};
            my $prefix = $title->{prefix} || '';
            my $suffix = $title->{suffix} || '';
            
            # Check if this title_set corresponds to a title certificate we know about
            if (exists $cert_map{$title_set}) {
                my $expected = $cert_map{$title_set};
                
                # Check if the title values match what we expect from the certificate
                # and that all other fields are properly set to -1
                my $mismatch = $prefix ne $expected->{prefix} || 
                               $suffix ne $expected->{suffix} ||
                               $title->{skill_id} != -1 ||
                               $title->{min_skill_value} != -1 ||
                               $title->{max_skill_value} != -1 ||
                               $title->{min_aa_points} != -1 ||
                               $title->{max_aa_points} != -1 ||
                               $title->{class} != -1 ||
                               $title->{gender} != -1 ||
                               $title->{char_id} != -1 ||
                               $title->{status} != -1 ||
                               $title->{item_id} != -1;
                
                if ($mismatch) {
                    my $expected_str = $expected->{prefix} ? "prefix '$expected->{prefix}'" : "suffix '$expected->{suffix}'";
                    my $actual_str = $prefix ? "prefix '$prefix'" : "suffix '$suffix'";
                    
                    if ($dry_run) {
                        log_info("DRY RUN: Would delete mismatched title ID $title_id ($actual_str) - " .
                                "References certificate ID $title_set which should be $expected_str with all other fields -1");
                    } else {
                        my $delete_query = "DELETE FROM titles WHERE id = ?";
                        my $delete_sth = $player_db->prepare($delete_query);
                        
                        eval {
                            $delete_sth->execute($title_id);
                            $delete_sth->finish();
                        };
                        if ($@) {
                            log_error("Failed to delete mismatched title ID $title_id: $@");
                        } else {
                            log_warning("Deleted mismatched title ID $title_id ($actual_str) - " .
                                       "References certificate ID $title_set which should be $expected_str with all other fields -1");
                            $mismatched_deleted++;
                        }
                    }
                }
            }
            # We don't touch titles that reference items that aren't title certificates
        }
        
        $titles_sth->finish();
        
        if ($mismatched_deleted > 0) {
            log_info("Found and " . ($dry_run ? "would delete" : "deleted") . " $mismatched_deleted mismatched title records");
        } else {
            log_success("No mismatched title records found");
        }
    }
    
    # Commit changes if not in dry-run mode
    if ($dry_run) {
        log_info("DRY RUN: No changes made to databases");
        $content_db->rollback();
        $player_db->rollback();
    } else {
        # Make sure we commit the final transaction
        eval {
            $player_db->commit();
            log_success("Committed all changes to player database");
        };
        if ($@) {
            log_error("Failed to commit final changes: $@");
            eval { $player_db->rollback(); };
            log_error("Transaction rolled back due to commit failure");
            die "Database commit failed. Changes have been rolled back.\n";
        }
        
        # Extra check to ensure commit worked correctly
        log_verbose("Verifying commit was successful...");
        eval {
            # Sleep for a moment to ensure database consistency
            sleep(1);
            
            # Verify a few records
            my $verify_query = "SELECT COUNT(*) AS count FROM titles WHERE title_set = ?";
            my $verify_sth = $player_db->prepare($verify_query);
            
            foreach my $cert_id (@sample_ids[0..2]) {
                $verify_sth->execute($cert_id);
                my $row = $verify_sth->fetchrow_hashref();
                my $count = $row ? $row->{count} : 0;
                
                if ($count <= 0) {
                    log_error("Immediate verification failed: Certificate ID $cert_id not found in database after commit!");
                    # Try to force another commit
                    $player_db->commit();
                    log_warning("Forced an additional commit due to verification failure");
                } else {
                    log_verbose("Immediate verification passed: Certificate ID $cert_id found in database after commit");
                }
            }
            $verify_sth->finish();
        };
        if ($@) {
            log_error("Post-commit verification failed: $@");
        }
    }
    
    # Clean up
    $cert_sth->finish();
    $check_sth->finish();
    $insert_sth->finish();
    $update_sth->finish();
    $delete_sth->finish();
    
    # Display summary
    print "\n";
    print "╔═══════════════════════════════════════════════╗\n";
    print "║               Summary Report                   ║\n";
    print "╚═══════════════════════════════════════════════╝\n\n";
    
    log_info("Total certificates processed: $total");
    log_info("New title records created: $inserted");
    log_info("Existing title records updated: $updated");
    log_info("Existing title records verified (unchanged): $verified");
    log_info("Duplicate title records deleted: $deleted");
    log_info("Skipped certificates with parsing issues: $skipped");
    
    if ($cleanup_mismatched) {
        log_info("Mismatched title records cleaned up: $mismatched_deleted");
    }
    
    # Database verification - Use a separate connection to verify the state after processing
    print "\n";
    print "╔═══════════════════════════════════════════════╗\n";
    print "║             Database Verification              ║\n";
    print "╚═══════════════════════════════════════════════╝\n\n";
    
    # Sample a few certificate IDs to verify using the separate verification connection
    if (@sample_ids) {
        log_info("Verifying database state for a sample of certificates:");
        
        foreach my $cert_id (@sample_ids) {
            my $verify_query = "SELECT COUNT(*) as count FROM titles WHERE title_set = ?";
            my $verify_sth = $verify_db->prepare($verify_query);
            $verify_sth->execute($cert_id);
            my $row = $verify_sth->fetchrow_hashref();
            $verify_sth->finish();
            
            my $count = $row ? $row->{count} : 0;
            if ($count > 0) {
                log_success("Certificate ID $cert_id: Found $count title record(s) in database");
            } else {
                log_error("Certificate ID $cert_id: No title records found in database!");
            }
        }
        
        # Get overall counts
        my $total_count_query = "SELECT COUNT(*) as count FROM titles WHERE title_set IS NOT NULL AND title_set > 0";
        my $total_count_sth = $verify_db->prepare($total_count_query);
        $total_count_sth->execute();
        my $total_row = $total_count_sth->fetchrow_hashref();
        $total_count_sth->finish();
        
        my $total_db_count = $total_row ? $total_row->{count} : 0;
        log_info("Total title records with title_set in database: $total_db_count");
        
        # Get count of specific certificate IDs we processed
        my $cert_ids_list = join(",", keys %certificate_ids);
        if ($cert_ids_list) {
            my $cert_count_query = "SELECT COUNT(*) as count FROM titles WHERE title_set IN ($cert_ids_list)";
            my $cert_count_sth = $verify_db->prepare($cert_count_query);
            $cert_count_sth->execute();
            my $cert_row = $cert_count_sth->fetchrow_hashref();
            $cert_count_sth->finish();
            
            my $cert_db_count = $cert_row ? $cert_row->{count} : 0;
            log_info("Title records for certificates we processed: $cert_db_count");
            
            if ($cert_db_count < scalar(keys %certificate_ids)) {
                log_warning("Not all certificates have corresponding title records!");
            }
        }
    } else {
        log_warning("No certificates were processed to verify");
    }
    
    # Close database connections
    $content_db->disconnect();
    $player_db->disconnect();
    $verify_db->disconnect();
    
    log_success("Title linking process complete.");
}

# ======================= Program Entry =======================
main();