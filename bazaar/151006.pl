sub EVENT_SAY {
    # Mangle the IP string to use safely as a key
    my $ip_string = $client->GetIPString();
    $ip_string =~ s/\./-/g;

    my $gnome_id = $npc->GetID();
    my $ip_key = "ExemptionRequest-$ip_string";    

    if ($text =~ /hail/i) {  
        if ($client->GetIPExemption() > 1) {
            quest::debug($client->GetIPExemption());
            plugin::NPCTell("Greetings, $name! I see you have an exemption already. Have fun! If you need more, please reach out to a GM or Guide on Discord.");
            return;
        }
        plugin::NPCTell("Greetings, $name! If you often have a companion struggling to meet up due to the restraints of the world, I can [help]!");
        return;
    }

    if ($text =~ /help/i) {
        plugin::NPCTell("Excellent. This service relies on your honesty. If used for multiboxing, all accounts from your IP will be banned when you are caught. When you're [ready], make sure your friend talks to the other gnome within a few seconds of you.");
        return;
    }

    if ($text =~ /ready/i) {
        my $existing = quest::get_data($ip_key);

        if ($existing && $existing != $gnome_id) {
            quest::delete_data($ip_key);
            plugin::NPCTell("Your IP exemption has been granted. You and your friend may now play together without restrictions for this session.");
            $client->SetIPExemption(2); # Temporary session-level exemption
        } else {
            quest::set_data($ip_key, $gnome_id, "6s");
            plugin::NPCTell("Understood. I'm waiting for your friend to confirm with the other gnome. Make sure they say 'ready' within a few seconds!");
        }
    }
}
