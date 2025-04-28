sub flush_title_certificates {
    my ($dbh, $template_id) = @_;
    
    log_info("Preparing to flush existing title certificates...");
    
    # We want to delete all certificates except our template
    my $query = "DELETE FROM items WHERE 
                (Name LIKE 'Prefix Title Certificate - %' OR 
                 Name LIKE 'Suffix Title Certificate - %') 
                AND id != ?";
    
    my $sth = $dbh->prepare($query);
    $sth->execute($template_id);
    
    my $rows_affected = $sth->rows;
    $sth->finish();
    
    if ($dry_run) {
        log_info("DRY RUN: Would delete $rows_affected title certificates");
    } else {
        log_success("Deleted $rows_affected title certificates");
    }
    
    return $rows_affected;
}#!/usr/bin/perl

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
my $suffix_file = "titles_suffix.txt";
my $prefix_file = "titles_prefix.txt";
my $template_id = 300000;
my $dry_run = 0;
my $verbose = 0;
my $help = 0;
my $db_host = "";
my $db_port = 3306;
my $db_name = "";
my $db_user = "";
my $db_pass = "";
my $use_config = 1;
my $title_max_length = 31;  # Max length for just the title
my $item_max_length = 64;   # Max length for the full item name
my $flush_certificates = 0; # Option to delete all existing certificates

GetOptions(
    "config=s"         => \$config_file,
    "suffix=s"         => \$suffix_file,
    "prefix=s"         => \$prefix_file,
    "template=i"       => \$template_id,
    "dry-run"          => \$dry_run,
    "verbose"          => \$verbose,
    "help"             => \$help,
    "db-host=s"        => \$db_host,
    "db-port=i"        => \$db_port,
    "db-name=s"        => \$db_name,
    "db-user=s"        => \$db_user,
    "db-pass=s"        => \$db_pass,
    "direct-db"        => sub { $use_config = 0 },
    "title-length=i"   => \$title_max_length,
    "item-length=i"    => \$item_max_length,
    "flush"            => \$flush_certificates
) or die "Error in command line arguments\n";

if ($help) {
    print_help();
    exit 0;
}

# ======================= Helper Functions =======================
sub print_help {
    my $script_name = basename($0);
    print "\nTitle Certificate Generator\n";
    print "==========================\n\n";
    print "Usage: $script_name [options]\n\n";
    print "Options:\n";
    print "  --config=FILE       Path to eqemu_config.json (default: '../eqemu_config.json')\n";
    print "  --suffix=FILE       File containing suffix titles (default: 'titles_suffix.txt')\n";
    print "  --prefix=FILE       File containing prefix titles (default: 'titles_prefix.txt')\n";
    print "  --template=ID       Template item ID to use (default: 300000)\n";
    print "  --dry-run           Show what would be done without making changes\n";
    print "  --verbose           Show detailed information\n";
    print "  --title-length=NUM  Maximum length for titles (default: 32)\n";
    print "  --item-length=NUM   Maximum length for full item names (default: 64)\n";
    print "  --flush             Delete all existing title certificates before creating new ones\n";
    print "  --help              Display this help message\n\n";
    
    print "Database Connection Options (bypasses config file):\n";
    print "  --direct-db         Use direct database connection instead of config file\n";
    print "  --db-host=HOST      Database hostname (default: localhost)\n";
    print "  --db-port=PORT      Database port (default: 3306)\n";
    print "  --db-name=NAME      Database name\n";
    print "  --db-user=USER      Database username\n";
    print "  --db-pass=PASS      Database password\n\n";
    
    print "Length Limits:\n";
    print "  - Title Length: Individual title (e.g., 'Grandmaster') must not exceed $title_max_length characters\n";
    print "  - Item Length: Full item name (e.g., 'Prefix Title Certificate - 'Grandmaster'') must not exceed $item_max_length characters\n\n";
    
    print "Example usage:\n";
    print "  $script_name --dry-run                        # Test run with default config\n";
    print "  $script_name --config=./myconfig.json         # Use custom config file\n";
    print "  $script_name --title-length=50 --item-length=80 # Increase length limits\n";
    print "  $script_name --flush --dry-run                # Test deleting all existing certificates\n";
    print "  $script_name --direct-db --db-host=127.0.0.1 --db-name=eqemu --db-user=eqemu --db-pass=password\n";
    print "                                                # Connect directly to database\n";
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
sub load_mysql_config {
    my ($config_path) = @_;
    
    log_verbose("Loading database configuration from $config_path");
    
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
    
    # Try to find database config - check both content_database and database
    my $db_section;
    my $db_section_name;
    
    if (exists $config->{"server"}{"content_database"}) {
        $db_section = $config->{"server"}{"content_database"};
        $db_section_name = "content_database";
    } elsif (exists $config->{"server"}{"database"}) {
        $db_section = $config->{"server"}{"database"};
        $db_section_name = "database";
    } else {
        die "Could not find database configuration in config file. Please check your eqemu_config.json.\n";
    }
    
    log_verbose("Using database configuration from '$db_section_name' section");
    
    # Set MySQL Connection vars with defaults if not defined
    my $db   = $db_section->{"db"} || "";
    my $host = $db_section->{"host"} || "localhost";
    my $user = $db_section->{"username"} || "";
    my $pass = $db_section->{"password"} || "";
    
    # Validate we have the minimum required fields
    unless ($db) {
        die "Database name not found in config file. Please check your eqemu_config.json.\n";
    }
    
    unless ($user) {
        die "Database username not found in config file. Please check your eqemu_config.json.\n";
    }
    
    return {
        db => $db,
        host => $host,
        user => $user,
        pass => $pass
    };
}

sub connect_to_database {
    my ($config) = @_;
    
    log_verbose("Connecting to database '$config->{db}' on '$config->{host}'");
    
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
            RaiseError => 0,
            PrintError => 0,
            AutoCommit => 0
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
        
        die "Failed to connect to database: $error\n$advice\n";
    }
    
    log_success("Database connection established");
    return $dbh;
}

sub get_template_item {
    my ($dbh, $id) = @_;
    
    log_verbose("Fetching template item with ID $id");
    
    my $query = "SELECT * FROM items WHERE id = ?";
    my $sth = $dbh->prepare($query);
    $sth->execute($id);
    my $row = $sth->fetchrow_hashref();
    $sth->finish();
    
    unless ($row) {
        die "Template item with ID $id not found in the database.";
    }
    
    log_success("Found template: $row->{Name}");
    return $row;
}

sub find_next_available_id {
    my ($dbh, $start_id) = @_;
    
    log_verbose("Searching for available ID starting from $start_id");
    
    my $search_range = 1000;  # Look in a range of 1000 IDs
    my $end_id = $start_id + $search_range;
    
    # Find the first available ID within our desired range
    my $query = "SELECT a.id + 1 AS next_id
                FROM items a
                LEFT JOIN items b ON a.id + 1 = b.id
                WHERE a.id >= ? AND a.id < ? AND b.id IS NULL
                ORDER BY a.id
                LIMIT 1";
    my $sth = $dbh->prepare($query);
    $sth->execute($start_id, $end_id);
    my $row = $sth->fetchrow_hashref();
    $sth->finish();
    
    my $next_id;
    if ($row && $row->{next_id}) {
        $next_id = $row->{next_id};
        log_verbose("Found available ID: $next_id");
    } else {
        # If we couldn't find a gap, start at the template ID + 1
        $next_id = $start_id + 1;
        log_verbose("No gaps found, starting with ID: $next_id");
    }
    
    return $next_id;
}

sub item_exists {
    my ($dbh, $name) = @_;
    
    my $query = "SELECT id FROM items WHERE `Name` = ?";
    my $sth = $dbh->prepare($query);
    $sth->execute($name);
    my $row = $sth->fetchrow_hashref();
    $sth->finish();
    
    return $row ? $row->{id} : 0;
}

sub id_is_available {
    my ($dbh, $id) = @_;
    
    my $query = "SELECT id FROM items WHERE id = ?";
    my $sth = $dbh->prepare($query);
    $sth->execute($id);
    my $row = $sth->fetchrow_hashref();
    $sth->finish();
    
    return !$row;
}

sub insert_certificate {
    my ($dbh, $template_row, $id, $name) = @_;
    
    # Double-check that the ID is not already in use
    if (!id_is_available($dbh, $id)) {
        log_error("ID collision detected! ID $id is already in use, skipping this item.");
        return 0;
    }
    
    # Create a copy of the template row
    my %new_row = %$template_row;
    
    # Update the ID and name
    $new_row{id} = $id;
    $new_row{Name} = $name;
    
    # Prepare the INSERT statement
    my @columns = sort keys %new_row;
    my $placeholders = join ", ", map {"?"} @columns;
    my $columns_str = join ", ", map {"`$_`"} @columns;
    my $query = "INSERT INTO items ($columns_str) VALUES ($placeholders)";
    
    my $sth = $dbh->prepare($query);
    
    # Bind parameters
    my $i = 1;
    foreach my $column (@columns) {
        $sth->bind_param($i++, $new_row{$column});
    }
    
    if ($dry_run) {
        log_info("DRY RUN: Would create certificate '$name' with ID $id");
    } else {
        $sth->execute();
        log_success("Created certificate '$name' with ID $id");
    }
    
    $sth->finish();
    return $id;
}

# ======================= Title Functions =======================
sub read_titles_from_file {
    my ($filename, $title_type) = @_;
    my @titles = ();
    
    # Check if file exists
    unless (-e $filename) {
        log_warning("Title file '$filename' not found! Skipping...");
        return @titles;
    }
    
    log_verbose("Reading $title_type titles from file '$filename'");
    
    # Open and read the file
    open(my $fh, '<', $filename) or die "Cannot open file '$filename': $!\n";
    
    my $total_titles = 0;
    my $filtered_title_length = 0;
    my $filtered_item_length = 0;
    
    while (my $line = <$fh>) {
        chomp($line);
        # Skip empty lines and comments
        next if $line =~ /^\s*$/;
        next if $line =~ /^\s*#/;
        
        $total_titles++;
        
        # Remove any quotes if they're in the file
        $line =~ s/^['"](.*)['"]$/$1/;
        
        # Strip leading and trailing whitespace
        $line =~ s/^\s+|\s+$//g;
        
        # Check title length (just the title itself)
        my $title_length = length($line);
        
        # Check item name length (full certificate name)
        my $full_item_name = "$title_type Title Certificate - '$line'";
        my $item_length = length($full_item_name);
        
        log_verbose("Title: '$line', Title length: $title_length/$title_max_length, Item length: $item_length/$item_max_length");
        
        # First check title length
        if ($title_length > $title_max_length) {
            log_warning("Filtered out: '$line' (title length: $title_length, exceeds title limit of $title_max_length)");
            $filtered_title_length++;
            next;
        }
        
        # Then check full item length
        if ($item_length > $item_max_length) {
            log_warning("Filtered out: '$line' (item length: $item_length, exceeds item limit of $item_max_length)");
            $filtered_item_length++;
            next;
        }
        
        # Title passed both checks, add it
        push @titles, $line;
    }
    close($fh);
    
    # Report how many titles were loaded and filtered
    log_info("Loaded " . scalar(@titles) . " $title_type titles from '$filename'");
    
    my $total_filtered = $filtered_title_length + $filtered_item_length;
    if ($total_filtered > 0) {
        if ($filtered_title_length > 0) {
            log_warning("Filtered out $filtered_title_length titles that exceeded title length limit of $title_max_length");
        }
        if ($filtered_item_length > 0) {
            log_warning("Filtered out $filtered_item_length titles that would create items exceeding length limit of $item_max_length");
        }
    }
    
    return @titles;
}

# ======================= Main Function =======================
sub main {
    # Print banner
    print "\n";
    print "╔═══════════════════════════════════════════════╗\n";
    print "║           Title Certificate Generator          ║\n";
    print "╚═══════════════════════════════════════════════╝\n\n";
    
    if ($dry_run) {
        log_info("Running in DRY RUN mode - no changes will be made");
    }
    
    # Set up database connection
    my $dbh;
    if ($use_config) {
        # Load database configuration from config file
        my $db_config = load_mysql_config($config_file);
        $dbh = connect_to_database($db_config);
    } else {
        # Use direct database connection parameters
        unless ($db_name && $db_user) {
            die "When using --direct-db, you must specify at least --db-name and --db-user\n";
        }
        
        $db_host = "127.0.0.1" unless $db_host; # Default to TCP localhost
        
        my $db_config = {
            db => $db_name,
            host => $db_host,
            user => $db_user,
            pass => $db_pass,
            port => $db_port
        };
        
        $dbh = connect_to_database($db_config);
    }
    
    # Get template item
    my $template_row = get_template_item($dbh, $template_id);
    
    # Flush existing certificates if requested
    if ($flush_certificates) {
        flush_title_certificates($dbh, $template_id);
    }
    
    # Find a suitable starting ID for new certificates
    my $next_id = find_next_available_id($dbh, $template_id);
    
    # Read titles from files
    my @suffix_titles = read_titles_from_file($suffix_file, "Suffix");
    my @prefix_titles = read_titles_from_file($prefix_file, "Prefix");
    
    # Combine titles with their types
    my @titles_with_types = ();
    foreach my $title (@suffix_titles) {
        push @titles_with_types, { title => $title, type => "Suffix" };
    }
    foreach my $title (@prefix_titles) {
        push @titles_with_types, { title => $title, type => "Prefix" };
    }
    
    # Verify we got at least one title
    unless (@titles_with_types) {
        log_error("No valid titles found in either file!");
        exit 1;
    }
    
    log_info("Total titles to process: " . scalar(@titles_with_types));
    
    my $created_count = 0;
    my $skipped_count = 0;
    my $error_count = 0;
    
    foreach my $title_data (@titles_with_types) {
        my $title = $title_data->{title};
        my $type = $title_data->{type};
        
        # Format the certificate name
        my $display_title = "'$title'";
        my $certificate_name = "$type Title Certificate - $display_title";
        
        # Check if this certificate already exists
        my $existing_id = item_exists($dbh, $certificate_name);
        if ($existing_id) {
            log_warning("Skipping: $certificate_name (already exists with ID: $existing_id)");
            $skipped_count++;
            next;
        }
        
        # Find the next available ID
        my $id_to_use = $next_id;
        
        # Keep looking for an available ID
        while (!id_is_available($dbh, $id_to_use)) {
            log_verbose("ID $id_to_use is already taken, trying next ID...");
            $id_to_use++;
        }
        
        # Insert the new certificate
        my $result = insert_certificate($dbh, $template_row, $id_to_use, $certificate_name);
        if ($result) {
            $created_count++;
            # Update the next ID
            $next_id = $id_to_use + 1;
        } else {
            $error_count++;
        }
    }
    
    # Commit changes if not in dry run mode
    if ($dry_run) {
        log_info("DRY RUN: Would create $created_count certificates (skipped $skipped_count, errors $error_count)");
        $dbh->rollback();
    } else {
        $dbh->commit();
        log_success("Successfully created $created_count certificates (skipped $skipped_count, errors $error_count)");
    }
    
    # Close database connection
    $dbh->disconnect();
    log_info("Database connection closed cleanly.");
}

# ======================= Program Entry =======================
main();