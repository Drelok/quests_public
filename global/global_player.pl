sub EVENT_SIGNAL {
    # Signals;
    # 666 = EoM Dead Drop
    # 100 = Title Flags

    if ($signal == 666) {
        plugin::UpdateEoMAward($client);
        return;
    }

    if ($signal == 100) {
        my $semaphore_title = $client->GetBucket('flag-semaphore');
        if ($semaphore_title) {
            plugin::AddTitleFlag($semaphore_title, $client);
            $client->DeleteBucket('flag-semaphore');
        }
        plugin::EnableTitles($client);
    } 
}

#test commit please ignore

sub EVENT_ENTERZONE {
	plugin::CommonCharacterUpdate($client);

	if (!plugin::is_eligible_for_zone($client, $zonesn)) {
		$client->Message(4, "Your vision blurs. You lose conciousness and wake up in a familiar place.");
		$client->MovePC(151, 185, -835, 4, 390); # Bazaar Safe Location.
    }

    # Only THJ Stuff after this point
    if (!plugin::IsTHJ()) {
        return;
    }

    if (!$client->IsTaskCompleted(3) && !$client->IsTaskActive(3)) {
        $client->AssignTask(3);
    } elsif ($client->IsTaskCompleted(3) && (!$client->IsTaskCompleted(4) && !$client->IsTaskActive(4))) {
        $client->AssignTask(4);
    }

    my $entity_list = plugin::val('$entity_list');
    my @npcs = $entity_list->GetNPCList();
    if (plugin::IsTHJ() && $instanceid) {
        foreach my $npc (@npcs) {
            my $expedition = quest::get_expedition();
            if ($expedition) {
                plugin::ScaleInstanceNPC($npc, $expedition->GetMemberCount());
            }
        }
    }
}

sub EVENT_DEATH {
    # Debug info remains unchanged
    quest::debug("killer_id " . $killer_id);
    quest::debug("killer_damage " . $killer_damage);
    quest::debug("killer_spell " . $killer_spell);
    quest::debug("killer_skill " . $killer_skill);
    quest::debug("killed_entity_id " . $killed_entity_id);
    quest::debug("combat_start_time " . $combat_start_time);
    quest::debug("combat_end_time " . $combat_end_time);
    quest::debug("damage_received " . $damage_received);
    quest::debug("healing_received " . $healing_received);
    quest::debug("killed_corpse_id " . $killed_corpse_id);
    quest::debug("killed_x " . $killed_x);
    quest::debug("killed_y " . $killed_y);
    quest::debug("killed_z " . $killed_z);
    quest::debug("killed_h " . $killed_h);
    quest::debug("killed_merc_id " . $killed_merc_id);
    quest::debug("killed_npc_id " . $killed_npc_id);

    if ($client->IsHardcore()) {
        my $player_name = $client->GetCleanName();
        my $player_class = plugin::GetPrettyClassString($client);
        
        # Check if player killed themselves
        if ($killer_id == $client->GetID()) {
            # Self-death flavor text options
            my @self_death_flavors = (
                "succumbed to their own folly",
                "met an untimely end by their own hand",
                "fell victim to their own miscalculation",
                "discovered the hard way that gravity still works",
                "became their own worst enemy",
                "made a fatal mistake",
                "perished from their own recklessness",
                "found out actions have consequences",
                "learned a harsh lesson too late",
                "took a risk that didn't pay off"
            );
            
            # Select random self-death flavor text
            my $random_index = int(rand(scalar @self_death_flavors));
            my $self_death_flavor = $self_death_flavors[$random_index];
            
            # Announce self-caused death
            my $announcement = "$player_name ($player_class) has been slain in Hardcore and $self_death_flavor!";
            plugin::WorldAnnounce($announcement);
        }
        else {
            my $killer_mob = $entity_list->GetMobID($killer_id);
            my $killer_name = $killer_mob ? $killer_mob->GetCleanName() : "Unknown";
            
            # Check if death was caused by a spell
            if ($killer_spell < 0xFFFF) {
                # Get the spell name
                my $spell_name = quest::getspellname($killer_spell);
                
                # Properly escape the possessive 's for the killer name
                $killer_name =~ s/'/'\\'/g; # Escape any single quotes
                
                # Announce spell-caused death using the actual spell name
                my $announcement = "$player_name ($player_class) has been slain in Hardcore by $killer_name\'s $spell_name!";
                plugin::WorldAnnounce($announcement);
            }
            else {
                # Death was caused by a skill - use existing code
                # Map skills to arrays of flavorful death descriptions
                my %death_flavors = (
                    # 1H Blunt (0)
                    0 => [
                        "crushing blow",
                        "skull-cracking mace",
                        "bone-shattering club",
                        "merciless hammer strike",
                        "brutal cudgel"
                    ],
                    
                    # 1H Slashing (1)
                    1 => [
                        "razor-sharp blade",
                        "deadly sword strike",
                        "vicious slash",
                        "precise cut",
                        "merciless blade"
                    ],
                    
                    # 2H Blunt (2)
                    2 => [
                        "mighty war hammer",
                        "devastating maul",
                        "earth-shaking smash",
                        "colossal club",
                        "bone-crushing staff"
                    ],
                    
                    # 2H Slashing (3)
                    3 => [
                        "massive cleaving strike",
                        "devastating great sword",
                        "whirling executioner's blade",
                        "sweeping death blow",
                        "merciless beheading strike"
                    ],
                    
                    # Archery (7)
                    7 => [
                        "perfectly aimed arrow",
                        "deadly bow shot",
                        "piercing shaft",
                        "whistling arrow to the heart",
                        "long-range precision shot"
                    ],
                    
                    # Backstab (8)
                    8 => [
                        "treacherous backstab",
                        "dagger from the shadows",
                        "assassin's blade",
                        "poisoned backstab",
                        "cowardly strike from behind"
                    ],
                    
                    # Bash (10)
                    10 => [
                        "thunderous shield bash",
                        "staggering blow",
                        "crushing shield edge",
                        "mighty slam",
                        "brutal body check"
                    ],
                    
                    # Dragon Punch (21)
                    21 => [
                        "devastating dragon punch",
                        "mystical fist strike",
                        "focused chi attack",
                        "legendary martial technique",
                        "deadly dragon's claw"
                    ],
                    
                    # Eagle Strike (23)
                    23 => [
                        "swift eagle strike",
                        "soaring talon strike",
                        "deadly hunting dive",
                        "piercing eagle claw",
                        "predator's pounce"
                    ],
                    
                    # Flying Kick (26)
                    26 => [
                        "devastating flying kick",
                        "airborne assault",
                        "hurricane kick",
                        "gravity-defying strike",
                        "leaping death blow"
                    ],
                    
                    # Hand to Hand (28)
                    28 => [
                        "fierce bare-handed attack",
                        "lightning-fast martial arts",
                        "deadly pressure-point strike",
                        "bare-knuckled fury",
                        "expert combat technique"
                    ],
                    
                    # Kick (30)
                    30 => [
                        "bone-shattering kick",
                        "deadly roundhouse",
                        "brutal stomp",
                        "crushing leg sweep",
                        "powerful heel strike"
                    ],
                    
                    # 1H Piercing (36)
                    36 => [
                        "precise rapier thrust",
                        "deadly dagger plunge",
                        "heart-seeking blade",
                        "surgical piercing strike",
                        "deep puncturing wound"
                    ],
                    
                    # Round Kick (38)
                    38 => [
                        "spinning round kick",
                        "whirlwind strike",
                        "circular death blow",
                        "tornado kick",
                        "deadly spinning heel"
                    ],
                    
                    # Throwing (51)
                    51 => [
                        "precisely thrown weapon",
                        "deadly airborne projectile",
                        "whistling thrown blade",
                        "expertly hurled dagger",
                        "fatal flying weapon"
                    ],
                    
                    # Tiger Claw (52)
                    52 => [
                        "deadly tiger claw",
                        "rending strike",
                        "savage ripping attack",
                        "ferocious martial technique",
                        "flesh-tearing claws"
                    ],
                    
                    # 2H Piercing (77)
                    77 => [
                        "impaling spear thrust",
                        "devastating pike charge",
                        "heart-piercing lance",
                        "massive puncture wound",
                        "skewering strike"
                    ]
                );
                
                # Default flavors for unknown skills
                my @default_flavors = (
                    "brutal attack",
                    "lethal strike",
                    "vicious assault",
                    "deadly blow",
                    "merciless onslaught",
                    "devastating technique",
                    "fierce combat prowess",
                    "relentless aggression",
                    "savage onslaught",
                    "overwhelming force"
                );
                
                # Get random flavor text from the appropriate array
                my $death_flavor;
                if (exists $death_flavors{$killer_skill}) {
                    my $flavor_options = $death_flavors{$killer_skill};
                    my $random_index = int(rand(scalar @$flavor_options));
                    $death_flavor = $flavor_options->[$random_index];
                } else {
                    # Select random default flavor
                    my $random_index = int(rand(scalar @default_flavors));
                    $death_flavor = $default_flavors[$random_index];
                }
                
                # Announce skill-caused death
                my $announcement = "$player_name ($player_class) has been slain in Hardcore by $killer_name using a $death_flavor!";
                plugin::WorldAnnounce($announcement);
            }
        }
    }
}

sub EVENT_EXP_GAIN {
    plugin::CustomEventExpGainEntry();
}

sub EVENT_AA_EXP_GAIN {
    plugin::CustomEventAAExpGainEntry();
}

sub EVENT_EQUIP_ITEM_CLIENT {
    plugin::CustomEventItemEquipEntry();

    if ($slot_id == 21) {
        # Simple Ring of the Hero, for Tutorial Quest 2
        if ($client->IsTaskActivityActive(4, 0) && $item_id == 150000) {
            $client->UpdateTaskActivity(4, 0, 1);
            return;
        }
        if ($client->IsTaskActivityActive(4, 1) && $item_id == 1150000) {
            $client->UpdateTaskActivity(4, 01, 1);
            return;
        }
        if ($client->IsTaskActivityActive(4, 2) && $item_id == 2150000) {
            $client->UpdateTaskActivity(4, 2, 1);
            return;
        }
        if ($item_id == 2150000) {
            plugin::dispatch_popup("symp_tutorial");
        } {
            plugin::dispatch_popup("power_source");
        }
    }

    symp_proc_tutorial_helper($item_id, $client);
}

sub EVENT_UNEQUIP_ITEM_CLIENT {
    plugin::CustomEventItemUnequipEntry();
}

sub EVENT_DESTROY_ITEM_CLIENT {
    if ($item_id == 2827) {
        my $account_key 	= $client->AccountID() . "-ess-items-destroyed";
        quest::set_data($account_key, (quest::get_data($account_key) || 0) + 1);
    }

    plugin::CustomEventDestroyEntry($item, $quantity);
}

sub EVENT_CONNECT {
    if (plugin::GetSoulmark($client)) {
        plugin::DisplayWarning($client);
    }
   
    plugin::CommonCharacterUpdate($client);
    plugin::OnLoginUpdate($client);

    if (!$client->GetBucket("First-Login")) {
        quest::settimer("first-login", 5);
    }

    if (plugin::MultiClassingEnabled()) {
        if (!$client->IsTaskCompleted(3) && !$client->IsTaskActive(3)) {
            $client->AssignTask(3);
        } elsif ($client->IsTaskCompleted(3) && (!$client->IsTaskCompleted(4) && !$client->IsTaskActive(4))) {
            $client->AssignTask(4);
        }

        plugin::dispatch_popup("welcome");
    }

    if (!plugin::is_eligible_for_zone($client, $zonesn)) {
		$client->Message(4, "Your vision blurs. You lose conciousness and wake up in a familiar place.");
		$client->MovePC(151, 185, -835, 4, 390); # Bazaar Safe Location.
	}
}

sub EVENT_TIMER {
    if (!$client->GetBucket("First-Login")) {
        quest::settimer("first-login", 10);

        $client->SetBucket("First-Login", 1);
        $client->SummonItem(18471); #A Faded Writ
        $client->Message(263, "You find a small note in your pocket.");
        
        my $name = $client->GetCleanName();
        my $full_class_name = plugin::GetPrettyClassString($client);

        my $solo = $client->IsSolo();
        my $hardcore = $client->IsHardcore();
        my $self_found = $client->IsSelfFound();
        
        # Build the announcement with status flags in a single set of parentheses
        my $announcement = "$name ($full_class_name) has logged in for the first time!";
        
        # Create a status string with all applicable statuses
        my @statuses;
        if ($solo) {
            push(@statuses, "Solo");
        }
        if ($self_found) {
            push(@statuses, "Self Found");
        }
        if ($hardcore) {
            push(@statuses, "Hardcore");
        }
        
        # Only add the status parentheses if there are any statuses to show
        if (scalar @statuses > 0) {
            $announcement .= " (" . join(", ", @statuses) . ")";
        }

        plugin::WorldAnnounce($announcement);
        plugin::AwardSeasonalItems($client);
    }

}

sub EVENT_DISCONNECT {
    # Removes invulnerability effects when disconnecting from the server.
    $client->BuffFadeByEffect(40);
}

sub EVENT_POPUPRESPONSE {
    plugin::check_tutorial_popup_response($popupid, $client);  
       
    if ($popupid == 58240) {        
        my $x = $client->GetEntityVariable("bazaar_x") + int(rand(11)) - 5;
        my $y = $client->GetEntityVariable("bazaar_y") + int(rand(11)) - 5;
        my $z = $client->GetEntityVariable("bazaar_z");
        my $h = $client->GetEntityVariable("bazaar_h");
        my $bind_loc = $client->GetEntityVariable("bazaar_zone");

        $client->SetBucket("Return-X", $client->GetX());
        $client->SetBucket("Return-Y", $client->GetY());
        $client->SetBucket("Return-Z", $client->GetZ());
        $client->SetBucket("Return-H", $client->GetHeading());
        $client->SetBucket("Return-Zone", $zoneid);
        $client->SetBucket("Return-Instance", $instanceid);

        $client->SpellEffect(218,1);
        $client->MovePC($bind_loc, $x, $y, $z, rand(512));
    }
}

sub EVENT_TASK_COMPLETE {
    if ($task_id == 3 && !$client->IsTaskCompleted(4)) {
        $client->AssignTask(4);
    }
}

sub EVENT_LEVEL_UP {
    plugin::CommonCharacterUpdate($client);

    if ($client->GetGM()) {
        return;
    }
    
    my $new_level = $client->GetLevel();
    if ($new_level == $client->GetBucket("CharMaxLevel")) {
        my $name = $client->GetCleanName();
        my $full_class_name = plugin::GetPrettyClassString($client);

        plugin::WorldAnnounce("$name ($full_class_name) has reached Level $new_level!");
    }
}

sub EVENT_CLICKDOOR {
	my $target_zone = plugin::get_target_door_zone($zonesn, $doorid, $version);

    if (!plugin::is_eligible_for_zone($client, $target_zone, 1)) {		
		return 1;
    }
}

sub EVENT_WARP {
    my $name = $client->GetCleanName();
    my $current_x = $client->GetX();
    my $current_y = $client->GetY();
    my $current_z = $client->GetZ();
    my $distance = sqrt(($current_x - $from_x) ** 2 + ($current_y - $from_y) ** 2 + ($current_z - $from_z) ** 2);
    my $account_key = $client->AccountID() . "-WarpCount";
    my $soulmark = quest::get_data($client->AccountID() . "-CheaterFlag");

    my @warp_events = plugin::DeserializeList(quest::get_data($account_key));

    # Enqueue the current warp event with timestamp
    push @warp_events, time();

    # Clean up array elements older than 30 days
    my $thirty_days_in_seconds = 30 * 24 * 60 * 60;
    @warp_events = grep { time() - $_ <= $thirty_days_in_seconds } @warp_events;

    # Count recent warp events
    my $recent_warp_count = scalar(@warp_events);

    my $enforcement = 0;

    quest::set_data($account_key, plugin::SerializeList(@warp_events));

    if ($distance > 100 || $soulmark) {
        my $admin_message = "Large Warp Detected. Character: $name Zone: $zonesn From: $from_x, $from_y, $from_z To: $current_x, $current_y, $current_z Distance: $distance";

        if ($soulmark) {
            $admin_message .= "\nAccount has Soulmark. Reason: $soulmark";            
        }

        if ($recent_warp_count) {
            $admin_message .= "\nPrevious 30-day Warp Count: $recent_warp_count";
        }

        if ($soulmark && $recent_warp_count > 10) {
            $admin_message .= "\nHigh 30-day Warp Count. Enforcement Engaged.";
            $enforcement = 1;
        }

        # Send the admin message
        quest::discordsend("monitor", $admin_message);
        quest::debug($admin_message);

        if ($enforcement) {
            $client->WorldKick();
        }
    }
}

sub EVENT_ALT_CURRENCY_MERCHANT_BUY {

    if ($item_id == 24151) {
        $client->AddAlternateCurrencyValue(1, 10);
        $client->RemoveAlternateCurrencyValue($currency_id, $item_cost);
        $client->RemoveItem(24151);
        plugin::YellowText("You unpack the bundle of Delivery Vouchers");
        return 1;
    }
}

sub EVENT_DISCOVER_ITEM {
    my $name = $client->GetCleanName();
    
    # Only announce upgraded items
    if ($itemid >= 700000) {        
        plugin::WorldAnnounceItem("$name has discovered: {item}.",$itemid);  
    }  
}

sub symp_proc_tutorial_helper {
    my $item_id = shift;
    my $client = shift;

    if ($item_id) {
        #pre-computed list of symp proc item ID bases
        my @sym_clicks = (
            6307, 6309, 6313, 7305, 900012, 900014, 1113, 1117, 1156, 1173, 
            1904, 2404, 5203, 5214, 5730, 5764, 6017, 6020, 6024, 6036, 
            6310, 6315, 6323, 6324, 6332, 6335, 6343, 6350, 6359, 6382, 
            6383, 6402, 6404, 6408, 6616, 6626, 7036, 7318, 7372, 7405, 
            10333, 10383, 10404, 10994, 11028, 11906, 11973, 12375, 13168, 
            13380, 13400, 13500, 13743, 13744, 13815, 13987, 13988, 13991, 
            14338, 14746, 14762, 20627, 21798, 21863, 21885, 21886, 21892, 
            22819, 22890, 23498, 24745, 24779, 24789, 24793, 25566, 25577, 
            25980, 25998, 26000, 26001, 26009, 26553, 27280, 27717, 28812, 
            28813, 28814, 28815, 28817, 28908, 29248, 29430, 29442, 30511, 
            31210, 31212, 31373, 62269, 68444, 68744, 68775, 68837, 69044, 
            69047, 69049, 69051, 69054, 69055, 69095, 69112, 69113, 69116, 
            69155
        );

        my $item_root = ($item_id % 1000000);

        if (grep { $_ == $item_root } @sym_clicks) {
            plugin::dispatch_popup("symp_tutorial", $client);
        }
    }
}

sub EVENT_COMBINE_VALIDATE {
	if ($recipe_id == 10344) {
		if ($validate_type =~/check_zone/i) {
			if ($zone_id != 289 && $zone_id != 290) {
				return 1;
			}
		}
	}

    if ($recipe_id == 927863) {
        my $name = $client->GetCleanName();
        plugin::WorldAnnounceItem("$name has forged the {item} within the Crucible of the Elements! Hail the Prismatic Conquerer!", 2017730);
        plugin::AddTitleFlag(678, $client);
    }

    if ($recipe_id == 927864) {
        my $name = $client->GetCleanName();
        plugin::WorldAnnounceItem("$name has claimed the {item} from the grasp of history! Hail the Truthbearer!", 2017731);
        plugin::AddTitleFlag(679, $client);
    }
	
	return 0;
}

sub EVENT_COMBINE_SUCCESS {
    if ($recipe_id =~ /^1090[4-7]$/) {
        $client->Message(1,
            "The gem resonates with power as the shards placed within glow unlocking some of the stone's power. ".
            "You were successful in assembling most of the stone but there are four slots left to fill, ".
            "where could those four pieces be?"
        );
    }
    elsif ($recipe_id =~ /^10(903|346|334)$/) {
        my %reward = (
            melee  => {
                10903 => 67665,
                10346 => 67660,
                10334 => 67653
            },
            hybrid => {
                10903 => 67666,
                10346 => 67661,
                10334 => 67654
            },
            priest => {
                10903 => 67667,
                10346 => 67662,
                10334 => 67655
            },
            caster => {
                10903 => 67668,
                10346 => 67663,
                10334 => 67656
            }
        );
        my $type = plugin::ClassType($class);
        quest::summonfixeditem($reward{$type}{$recipe_id});
        quest::summonfixeditem(67704); # Item: Vaifan's Clockwork Gemcutter Tools
        $client->Message(1,"Success");
    }
}

sub EVENT_ITEM_CLICK_CAST_CLIENT {
    if (plugin::CustomEventItemClickCastEntry()) {
        return;
    }

    if ($spell_id == 36878) {
        plugin::AddTitleFlag($item_id, $client);
    }

    plugin::swap_items($client, $item_id, $slot_id);

    if ($spell_id == 36874) {
        plugin::cycle_time_items($client, $item_id, $slot_id);
    }
}

sub EVENT_CAST_ON {
    # Check for mutually-exclusive elemental form spells.
    my @spell_ids = (
        2789, 2790, 2791, 2792, 2793, 2794, 2795, 2796, 2797, 2798, 2799, 2800,
        38329, 38330, 38331, 38333, 38334, 38335, 38336, 38337, 38338, 38340, 38341, 38342
    );
    if (grep { $_ == $spell_id } @spell_ids) {
        foreach my $id (@spell_ids) {
            next if $id == $spell_id; # Skip the matched spell_id
            $client->BuffFadeBySpellID($id);
        }
    }

    if ($caster_id && $spell) {
        my @global_buffs = ( 43002, 43003, 43004, 43005, 43006, 43007, 43008, 17779 );
        # Check if spell_id IS in @global_buffs array
        if (grep { $_ == $spell_id } @global_buffs) {
            # no operation
        } elsif ($caster_id == $client->GetID() && $spell->GetBuffDuration() > 0) {
            plugin::dispatch_popup("self_buff", $client);
        }
    }
}

sub EVENT_CAST_BEGIN {
    if ($spell_id == 2931 && $zoneid != 159) {
        $client->Message(289, "This may only be used inside Sanctus Seru.");
        $client->InterruptSpell();
        return 1;
    }
}

sub EVENT_SAY {
    if ($client->GetGM()) {
        if ($text=~/#awardtitle\s*(.*)/i) {
            $client->Message(13, "Disregard the command not recognized error.");
            my $arguments = $1; # Captures everything after #awardtitle
            
            my $tar_client = $client->GetTarget();
            if ($tar_client && $tar_client->IsClient()) {
                $tar_client = $tar_client->CastToClient();
            } else {
                return;
            }

            # Validate that there is exactly one argument which is a number
            if ($arguments =~ /^\s*(\d+)\s*$/) {
                my $number = $1; # Captures the number
                # Proceed with awarding the title using $number
                    
                $client->Message(13, "Awarding TitleSet $number to " . $tar_client->GetName());
                plugin::AddTitleFlag($number, $tar_client->CastToClient());
                plugin::CommonCharacterUpdate($tar_client->CastToClient());
                $tar_client->Signal(1);
            } else {
                $client->Message(13, "Invalid input. Please provide a single numeric argument.");
            }
        } elsif ($text=~/#setpopflag\s+(\S+)(?:\s+(\d))?/i) {
            my ($flag, $number) = ($1, $2 // 1);  # Default $number to 1 if not provided

            my $tar_client = $client->GetTarget();
            if ($tar_client && $tar_client->IsClient()) {
                $tar_client = $tar_client->CastToClient();
            } else {
                return;
            }

            if ($number >= 0 && $number <= 9) {
                my $client_name = $tar_client->GetCleanName();
                $tar_client->SetAccountBucket("pop.flags.$flag", "$number");
                $tar_client->Message(4, "You receive a character flag!");
                $client->Message(4, "'$flag' flag set to '$number' for $client_name.");
            } else {
                $client->Message(13, "Invalid number. Please provide a number between 0 and 9.");
            }
        } elsif ($text=~/#resetpopflags/i) {
            my $tar_client = $client->GetTarget();
            if ($tar_client && $tar_client->IsClient()) {
                $tar_client = $tar_client->CastToClient();
            } else {
                return;
            }

            my @zoneflags = POPZoneFlags();
            foreach my $zoneflag (@zoneflags) {
                $tar_client->ClearZoneFlag($zoneflag);
            }
    
            my $client_name = $tar_client->GetCleanName();
            $tar_client->DeleteAccountBucket("pop");
            $tar_client->Message(4, "Your Planes of Power flags have been reset.");
            $client->Message(4, "Planes of Power flags reset for $client_name.");
        } elsif ($text=~/#pop/i) {
            my @flags = POPFlags();
            my $tar_client = $client->GetTarget() ? $client->GetTarget() : $client;
	    my $client_name = $tar_client->GetCleanName();
            if ($tar_client && $tar_client->IsClient()) {
                $tar_client = $tar_client->CastToClient();
            } else {
                return;
            }
            quest::message(315, "Target's Planes of Power flags are as follows:");

            foreach my $flag (sort {$a cmp $b} @flags) {
                my $current_value = $tar_client->GetAccountBucket("pop.flags.$flag");
                if ($current_value eq "") {
                    $current_value = 0;
                    #resetpopf
                }

                $flag =~ s/pop\.flags\.//ig;

                quest::message(315, "Flag: $flag Current: $current_value");
            }
        }
    }
}


sub POPFlags {
	my @flags = (
		"aerin",
		"adler",
		"agnarr",
		"arbitor",
		"arlyxir",
		"askr",
		"behemoth",
		"bertox",
		"codecay",
		"coirnav",
		"construct",
		"dresolik",
		"elder",
		"faye",
		"fennin",
		"garn",
		"grummus",
		"hedge",
		"jiva",
		"karana",
		"librarian",
		"maelin",
		"marr",
		"mavuin",
		"newleaf",
		"poxbourne",
		"rallos",
		"rathe",
		"saryrn",
		"shadyglade",
		"story",
		"tallon",
		"terris",
	 	"tribunal",
		"trell",
		"vallon",
	  	"valor",
		"xanamech"
	);

 	return @flags;
}

sub POPZoneFlags {
    my @zoneflags = (
        200,
        207,
        208,
        209,
        210,
        211,
        212,
        214,
        215,
        216,
        217,
        218,
        219,
        220,
        221,
        222,
        223
    );

    return @zoneflags;
}
