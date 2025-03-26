--[[
 Plane of Earth  Ring Events written ## By Drogerin ##
 Did this on test, and here is how it's supposed to go for anyone who is able to fix this event.

 [Stone]
 Rock Monstrosity in middle (untarget)

2 x A Crumbling Stone Mass ( EAST )
- Killing these results spawning x12(3 rows of 4) A Stone fortification on top of the temple, facing the direction of the above(do not auto aggro.)

2 x A Rock Creation ( NORTH )
- Killing these results spawning x10(pinball formation) A Stone fortification on top of the temple, facing the direction of the above(do not auto aggro.)

2 x A Pile of Boulders ( SOUTH )
- Killing these results spawning x10(pinball formation)A Stone fortification on top of the temple, facing the direction of the above(do not auto aggro.)

2 x A Boulder Thrower ( WEST )
- Killing these results spawning x12(3 rows of 4) A Stone fortification on top of the temple, facing the direction of the above(do not auto aggro.)


Once these are all dead, 4x A Mound of Rubble spawns. Does not auto-aggro. Once they are down around 15-20% they will path back to their spawn point on top/middle of the temple.
- NOTE: They CAN be killed, which will gimp the event and it will have to reset. This happened to me. Not sure on reset time, but it was more than 4 hours and less than 12.

After all 4 path back to spawn...
[Thu Oct 13 12:28:44 2016] The mounds of rubble reform back into the Rock Monstrosity.
A Rock Monstrosity spawns and auto-aggro's.

Kill the A Rock Monstrosity to spawn 4x A Stone Heap. These spawn at the 4 corners on top of the temple, they will auto-aggro. Peregrin - laying down untarget

Killing the 4x A Stone Heap spawns 4 more. Repeat another 4 times. So that's 6 total waves of 4x "A Stone Heap".

After the heap waves, Peregrin Rockskull spawns top/middle of the temple and auto-aggro's.
After the heap waves, An Encrusted Dirt Cloud spawns top/middle of the temple and auto-agro's for PH.

[Dust]

Kill a dusty warder
37 Dust Devotee spawn immediately.  5 nearby and 32 at the temple, Inside 3 Triumvirate of Soil stand untargetable
after all 37 Dust devotee are down the Soils attack. After all 3 are dead  Perfected Warder of Earth spawns.  He has adds

80% 3x Protector
60% 4x Protector
50% 3x Protector
40% 6x Protector
30% 5x Protector
5%  5x Protector

If PH version  same deal, kill dusty warder, 37 devotee & 3 Soil,  except 3x Dust Follower spawn after, this ring seems  harder if you try to brute force
with 36 adds.

Each Follower has adds at following %

80 3x Protector
60 3x Protector
50 3x Protector
40 3x Protector

[Mud]

Kill all Earthen Mudwalker in the zone.  A Sludge Lurker spawns, kill it to 75% and 10x Muck Mudlet spawn, kill them, he respawns, at 50 Rinse repeat, at 25% Rinse repeat, at 10% Rinse Repeat
after Sludge is dead 4x Filth Gorger spawn, kill these and Monstrous Mudwalker Named spawns, at 50% he has 10 adds, 40% has 10 adds and 10% has 10 adds.


Ph version similar except Sludge Lurker does not split, kill him and follow rest of ring,  4x Filth, then Merciless Mudslinger spawns with same adds as his named version.


[Vine]

Kill 30 A tainted rock beast, 10 Bloodthirsty Vegerog come active, kill these 10,  Named spawns.

PH version exactly the same,  Bloodthirsty Vegerog PH instead of Named.


--]]


local rock_dead=0;  -- Count Rock Creation Deaths
local boulder_dead=0; -- Count Pile of Boulder Deaths
local stone_dead=0; -- Count Stone Fortification Deaths
local crumbling_dead=0; -- Count Crumbling Mass Deaths
local thrower_dead=0; -- Count Boulder Thrower Deaths
local rubble_done=0;  -- Count how many Rubbles we have brought to 20%
local heap_dead=0; -- Count the waves of heaps by 1
local stone_counter=0; -- was stone ring successful or not
local mud_counter=0; -- was mud ring successful or not
local dust_counter=0; -- was dust ring successful or not
local vine_counter=0; -- was vine ring successful or not
local mudlet_death=0; -- count Mudlet Deaths.
local Sludge_hitpoints=100; -- Keep track of Sludge HP on spawns 75, 50, 25, 10
local gorger_dead=0; -- Count these deaths
local gorgertwo=0; -- Count these deaths
local devotee_death=0; -- Count these deaths
local soil_dead=0; -- Count these deaths
local follower_dead=0; -- count my deaths
local bloodthirsty_dead=0; -- count my deaths
local tainted_dead=0; -- count my deaths

local box = require("aa_box")

local mud_box = box();
mud_box:add(341.07, -54.61);
mud_box:add(338.70, 234.46);
mud_box:add(481.98, 90.68);
mud_box:add(194.70, 90.90);

local rock_table = {
    [0] = {-597.67, -238.85, 85.75, 0.0}, 
    [1] = {-610.87, -239.87, 85.75, 1.3}, 
    [2] = {-622.58, -239.63, 85.75, 1.0}, 
    [3] = {-633.35, -239.09, 85.75, 5.3}, 
    [4] = {-627.90, -229.66, 85.75, 1.8}, 
    [5] = {-617.99, -228.00, 85.75, 1.5}, 
    [6] = {-607.09, -227.60, 85.75, 6.3}, 
    [7] = {-610.82, -218.26, 85.75, 1.5}, 
    [8] = {-621.35, -220.99, 85.75, 511.0}, 
    [9] = {-614.37, -213.40, 85.75, 1.0}, 
}

local boulder_table = {
    [0] = {-632.96, -286.16, 85.75, 258.5}, 
    [1] = {-624.01, -286.51, 85.75, 256.3}, 
    [2] = {-611.21, -285.47, 85.75, 257.0}, 
    [3] = {-598.59, -285.46, 85.75, 258.3}, 
    [4] = {-604.75, -293.35, 85.75, 258.3}, 
    [5] = {-619.32, -295.48, 85.75, 256.3}, 
    [6] = {-629.24, -295.47, 85.75, 258.5}, 
    [7] = {-623.82, -303.16, 85.75, 260.5}, 
    [8] = {-615.76, -303.35, 85.75, 257.0}, 
    [9] = {-622.79, -307.56, 85.75, 255.3}, 
}

local crumbling_table = {
    [0] = {-640.19, -244.11, 85.75, 386.3}, 
    [1] = {-640.40, -253.81, 85.75, 386.3}, 
    [2] = {-639.98, -264.83, 85.75, 388.5}, 
    [3] = {-639.67, -279.41, 85.75, 388.5}, 
    [4] = {-649.83, -279.38, 85.75, 386.5}, 
    [5] = {-649.83, -264.92, 85.75, 389.0}, 
    [6] = {-649.63, -255.97, 85.75, 384.0}, 
    [7] = {-649.62, -245.00, 85.75, 385.3}, 
    [8] = {-656.50, -245.00, 85.75, 384.5}, 
    [9] = {-656.48, -254.18, 85.75, 385.0}, 
    [10] = {-655.70, -263.76, 85.75, 384.8}, 
    [11] = {-655.76, -279.63, 85.75, 385.0}, 
}

local thrower_table = {
    [0] = {-592.13, -278.78, 85.75, 128.0}, 
    [1] = {-591.91, -266.20, 85.75, 127.0}, 
    [2] = {-591.75, -253.29, 85.75, 129.0}, 
    [3] = {-591.81, -244.42, 85.75, 130.3}, 
    [4] = {-584.14, -244.52, 85.75, 129.8}, 
    [5] = {-583.40, -255.27, 85.75, 127.8}, 
    [6] = {-583.40, -264.16, 85.75, 128.3}, 
    [7] = {-583.10, -279.72, 85.75, 129.3}, 
    [8] = {-574.32, -280.04, 85.75, 130.3}, 
    [9] = {-575.21, -271.35, 85.75, 132.0}, 
    [10] = {-575.24, -260.60, 85.75, 130.3}, 
    [11] = {-574.49, -245.75, 85.75, 128.8}
}


function RestoreVariables()
    rock_dead=tonumber(eq.get_zone():GetVariable("rock_dead")) or 0;
    boulder_dead=tonumber(eq.get_zone():GetVariable("boulder_dead")) or 0;
    stone_dead=tonumber(eq.get_zone():GetVariable("stone_dead")) or 0;
    crumbling_dead=tonumber(eq.get_zone():GetVariable("crumbling_dead")) or 0;
    thrower_dead=tonumber(eq.get_zone():GetVariable("thrower_dead")) or 0;
    rubble_done=tonumber(eq.get_zone():GetVariable("rubble_done")) or 0;
    heap_dead=tonumber(eq.get_zone():GetVariable("heap_dead")) or 0;
    stone_counter=tonumber(eq.get_zone():GetVariable("stone_counter")) or 0;
    mud_counter=tonumber(eq.get_zone():GetVariable("mud_counter")) or 0;
    dust_counter=tonumber(eq.get_zone():GetVariable("dust_counter")) or 0;
    vine_counter=tonumber(eq.get_zone():GetVariable("vine_counter")) or 0;
    mudlet_death=tonumber(eq.get_zone():GetVariable("mudlet_death")) or 0;
    gorger_dead=tonumber(eq.get_zone():GetVariable("gorger_dead")) or 0;
    gorgertwo=tonumber(eq.get_zone():GetVariable("gorgertwo")) or 0;
    devotee_death=tonumber(eq.get_zone():GetVariable("devotee_death")) or 0;
    soil_dead=tonumber(eq.get_zone():GetVariable("soil_dead")) or 0;
    follower_dead=tonumber(eq.get_zone():GetVariable("follower_dead")) or 0;
    bloodthirsty_dead=tonumber(eq.get_zone():GetVariable("bloodthirsty_dead")) or 0;
    tainted_dead=tonumber(eq.get_zone():GetVariable("tainted_dead")) or 0;
end

function Rock_Death(e)   -- Count these, if 2 Spawn Fortification mobs at their assigned locations
    if not eq.is_npc_spawned({ 218032 }) then

        for _, position in pairs(rock_table) do
            eq.spawn2(218072, 0, 0, position[1], position[2], position[3], position[4]) -- NPC: A_Stone_Fortification
        end

    end
end

function Boulder_Death(e) -- Count these, if 2 Spawn Fortification mobs at their assigned locations
    if not eq.is_npc_spawned({ 218030 }) then

        for _, position in pairs(boulder_table) do
            eq.spawn2(218072, 0, 0, position[1], position[2], position[3], position[4]) -- NPC: A_Stone_Fortification
        end

    end
end

function Crumbling_Death(e) -- Count these, if 2 Spawn Fortification mobs at their assigned locations
    if not eq.is_npc_spawned({ 218031 }) then

        for _, position in pairs(crumbling_table) do
            eq.spawn2(218072, 0, 0, position[1], position[2], position[3], position[4]) -- NPC: A_Stone_Fortification
        end

    end
end

function Thrower_Death(e) -- Count these, if 2 Spawn Fortification mobs at their assigned locations
    if not eq.is_npc_spawned({ 218033 }) then

        for _, position in pairs(thrower_table) do
            eq.spawn2(218072, 0, 0, position[1], position[2], position[3], position[4]) -- NPC: A_Stone_Fortification
        end

    end
end

function Stone_Death(e) -- Count these mobs, if 44, spawn A Rock Monstrosity
        stone_dead=stone_dead+1;
        eq.get_zone():SetVariable("stone_dead",tostring(stone_dead));
        if stone_dead == 44 then
            --eq.zone_emote(15,"YAY");
            eq.depop_with_timer(218029);
            eq.spawn2(218089,0,0,-614.11,-263.43,89.75,45.8):AddToHateList(e.self:GetTarget(),1); -- NPC: #A_Rock_Monstrosity
            stone_dead=0;
            eq.get_zone():SetVariable("stone_dead",tostring(stone_dead));
        end
end

function Monstrosity_Death(e) -- After my Death - Spawn Peregin & FD him, set his actions to not agro, go invuln, immune to all forms of agro. Also spawn the waves of Stone Heaps.
        eq.spawn2(218049,0,0,-631.84,-277.58,89.75,64.3); -- NPC: Peregrin_Rockskull
        heap_dead=0;
        eq.get_zone():SetVariable("heap_dead",tostring(heap_dead));
        eq.spawn2(218079,0,0,-545.32,-331.85,85.75,448.3); -- NPC: A_Stone_Heap
        eq.spawn2(218079,0,0,-544.83,-189.64,85.75,327.5); -- NPC: A_Stone_Heap
        eq.spawn2(218079,0,0,-689.25,-188.92,85.75,196.0); -- NPC: A_Stone_Heap
        eq.spawn2(218079,0,0,-689.83,-336.55,85.75,67.5); -- NPC: A_Stone_Heap
        rubble_done=0;
        eq.get_zone():SetVariable("rubble_done",tostring(rubble_done));
end

function Pereginspawnone_Spawn(e) -- Perform these actions upon my spawn
        eq.set_timer("FD", 3000);
        e.self:SetSpecialAbility(SpecialAbility.immune_aggro_on, 1);
        e.self:SetSpecialAbility(SpecialAbility.immune_magic, 1);
        e.self:SetSpecialAbility(SpecialAbility.immune_melee, 1);
        e.self:SetSpecialAbility(SpecialAbility.immune_aggro, 1);
        e.self:SetSpecialAbility(SpecialAbility.no_harm_from_client, 1);
end

function Pereginspawnone_Timer(e)
        if e.timer == "FD" then
        eq.stop_timer('FD');
        e.self:SetAppearance(3);
        --eq.zone_emote(15,"Im FD NOW!");
        end
end

function Placeholder_Spawn(e)
	-- only execuite this if this is a non-respawning DZ
	if not e.self:CastToNPC():IsResumedFromZoneSuspend() then
		stone_counter=0; -- If this mob respawns (reset Stone_Counter to 0) [Fail] , you have taken too much time, we are using this as the timer.  ## This is the fail check ##
        	eq.get_zone():SetVariable("stone_counter",tostring(stone_counter));
        	heap_dead=0; -- Reset Heap count
        	eq.get_zone():SetVariable("heap_dead",tostring(heap_dead));
        	stone_dead=0; -- Reset Fortification count
        	eq.get_zone():SetVariable("stone_dead",tostring(stone_dead));
        	rubble_done=0; -- Reset Rubble Count
        	eq.get_zone():SetVariable("rubble_done",tostring(rubble_done));
        	rock_dead=0; -- Reset rock counter
        	eq.get_zone():SetVariable("rock_dead",tostring(rock_dead));
        	boulder_dead=0; -- Reset boulder counter
        	eq.get_zone():SetVariable("boulder_dead",tostring(boulder_dead));
        	thrower_dead=0; -- Reset thrower counter
        	eq.get_zone():SetVariable("thrower_dead",tostring(thrower_dead));
        	crumbling_dead=0; -- Reset crumbling counter
        	eq.get_zone():SetVariable("crumbling_dead",tostring(crumbling_dead));
        	eq.depop(218049); -- Depop Peregin(Fake)
        	eq.depop(218121); -- Depop Peregin(Real)
        	eq.depop_all(218079); -- Depop Heaps
        	eq.depop(218076); -- Depop Rubbles
        	eq.depop(218118); -- Depop Rubbles
        	eq.depop(218119); -- Depop Rubbles
        	eq.depop(218120); -- Depop Rubbles
        	eq.depop_all(218072); -- Depop Fortifications
        	eq.depop(218129); -- Depop Encrusted PH

	end
end

function Heap_Death(e)  -- Count waves of Heaps in 4's  it takes 24 to spawn the final named.
        local el = eq.get_entity_list();
        heap_dead=heap_dead+1;
        if heap_dead == 4 then -- Spawn Wave 1
            eq.spawn2(218079,0,0,-545.32,-331.85,85.75,448.3); -- NPC: A_Stone_Heap
            eq.spawn2(218079,0,0,-544.83,-189.64,85.75,327.5); -- NPC: A_Stone_Heap
            eq.spawn2(218079,0,0,-689.25,-188.92,85.75,196.0); -- NPC: A_Stone_Heap
            eq.spawn2(218079,0,0,-689.83,-336.55,85.75,67.5); -- NPC: A_Stone_Heap
        end
        if heap_dead == 8 then  -- Spawn Wave 2
            eq.spawn2(218079,0,0,-545.32,-331.85,85.75,448.3); -- NPC: A_Stone_Heap
            eq.spawn2(218079,0,0,-544.83,-189.64,85.75,327.5); -- NPC: A_Stone_Heap
            eq.spawn2(218079,0,0,-689.25,-188.92,85.75,196.0); -- NPC: A_Stone_Heap
            eq.spawn2(218079,0,0,-689.83,-336.55,85.75,67.5); -- NPC: A_Stone_Heap
        end
        if heap_dead == 12 then -- Spawn Wave 3
            eq.spawn2(218079,0,0,-545.32,-331.85,85.75,448.3); -- NPC: A_Stone_Heap
            eq.spawn2(218079,0,0,-544.83,-189.64,85.75,327.5); -- NPC: A_Stone_Heap
            eq.spawn2(218079,0,0,-689.25,-188.92,85.75,196.0); -- NPC: A_Stone_Heap
            eq.spawn2(218079,0,0,-689.83,-336.55,85.75,67.5); -- NPC: A_Stone_Heap
        end
        if heap_dead == 16 then -- Spawn Wave 4
            eq.spawn2(218079,0,0,-545.32,-331.85,85.75,448.3); -- NPC: A_Stone_Heap
            eq.spawn2(218079,0,0,-544.83,-189.64,85.75,327.5); -- NPC: A_Stone_Heap
            eq.spawn2(218079,0,0,-689.25,-188.92,85.75,196.0); -- NPC: A_Stone_Heap
            eq.spawn2(218079,0,0,-689.83,-336.55,85.75,67.5); -- NPC: A_Stone_Heap
        end
        if heap_dead == 20 then -- Spawn Wave 5
            eq.spawn2(218079,0,0,-545.32,-331.85,85.75,448.3); -- NPC: A_Stone_Heap
            eq.spawn2(218079,0,0,-544.83,-189.64,85.75,327.5); -- NPC: A_Stone_Heap
            eq.spawn2(218079,0,0,-689.25,-188.92,85.75,196.0); -- NPC: A_Stone_Heap
            eq.spawn2(218079,0,0,-689.83,-336.55,85.75,67.5); -- NPC: A_Stone_Heap
        end
        if heap_dead == 24 and el:IsMobSpawnedByNpcTypeID(218092) == true then -- ## Check to see if named can be spawned ##
            eq.depop_all(218049); -- Depop Fake Peregin
            eq.depop_with_timer(218092); -- Depop ##StoneTrigger## so we can spawn PHs next round.
            eq.spawn2(218121,0,0,-631.84,-277.58,89.75,64.3); -- Peregin Rockskull // with Loot
            heap_dead=0; -- Reset heap count back to 0.
        elseif heap_dead == 24 and el:IsMobSpawnedByNpcTypeID(218092) == false then -- ## Check to see if we should spawn Placeholder instead ##
            eq.depop_all(218049); -- Depop Fake Peregin
            eq.spawn2(218129,0,0,-631.84,-277.58,89.75,64.3); -- Spawn PH ## An Encrusted Dirt Cloud ##
            heap_dead=0; -- Reset heap count back to 0.
        end
        eq.get_zone():SetVariable("heap_dead",tostring(heap_dead));
end

function Peregin_Combat(e)
        if (e.joined == true) then
                eq.set_timer('Hardblur', 180 * 1000);
                eq.set_timer('Softblur', 6 * 1000);
        else
                eq.stop_timer('Hardblur');
                eq.stop_timer('Softblur');
        end
end

function Peregin_Timer(e)
        if (e.timer == 'Hardblur') then
        e.self:WipeHateList();
    elseif (e.timer == 'Softblur') then
        if (math.random(100)<=10) then
            e.self:WipeHateList();
        end
    end
end

function Peregin_Death(e) -- Named Death
                local el = eq.get_entity_list();
                stone_counter=1; -- If Peregin dies, set this to success.
                eq.get_zone():SetVariable("stone_counter",tostring(stone_counter));
                if stone_counter == 1 and vine_counter == 1 and mud_counter == 1 and dust_counter == 1 and el:IsMobSpawnedByNpcTypeID(218094) == true then -- Are Stone/Dust/Vine/Mud all complete & is the Final Trigger mob Up? If so spawn Arbitor.
                    eq.spawn2(218053,0,0,1520.9,-2745.2,6.1,376.4); -- Spawn Mystical Arbitor of Earth
                    --eq.zone_emote(15,"Arbitor has spawned!");
                    eq.depop_with_timer(218094); -- Despawn the Trigger mob ##Final_Trigger## so event can't be repeated multiple times.
                    stone_counter=0;
                    eq.get_zone():SetVariable("stone_counter",tostring(stone_counter));
                    vine_counter=0;
                    eq.get_zone():SetVariable("vine_counter",tostring(vine_counter));
                    mud_counter=0; -- Reset rings upon successful spawn
                    eq.get_zone():SetVariable("mud_counter",tostring(mud_counter));
                    dust_counter=0;
                    eq.get_zone():SetVariable("dust_counter",tostring(dust_counter));
                else
                --eq.zone_emote(15,"Sorry the Mystical Arbitor is in another Castle!");
                end
end

function Encrusted_Combat(e)
        if (e.joined == true) then
                eq.set_timer('Hardblur', 180 * 1000);
                eq.set_timer('Softblur', 6 * 1000);
        else
                eq.stop_timer('Hardblur');
                eq.stop_timer('Softblur');
        end
end

function Encrusted_Timer(e)
        if (e.timer == 'Hardblur') then
        e.self:WipeHateList();
    elseif (e.timer == 'Softblur') then
        if (math.random(100)<=10) then
            e.self:WipeHateList();
        end
    end
end

function Encrusted_Death(e) --PH Death
                local el = eq.get_entity_list();
                stone_counter=1; -- If Placeholder dies, set this to success.
                eq.get_zone():SetVariable("stone_counter",tostring(stone_counter));

                if stone_counter == 1 and vine_counter == 1 and mud_counter == 1 and dust_counter == 1 and el:IsMobSpawnedByNpcTypeID(218094) == true then -- Are Stone/Dust/Vine/Mud all complete & is the Final Trigger mob Up? If so spawn Arbitor.
                    eq.spawn2(218053,0,0,1520.9,-2745.2,6.1,376.4); -- Spawn Mystical Arbitor of Earth
                    --eq.zone_emote(15,"Arbitor has spawned!");
                    eq.depop_with_timer(218094); -- Despawn the Trigger mob ##Final_Trigger## so event can't be repeated multiple times.
                    stone_counter=0;
                    eq.get_zone():SetVariable("stone_counter",tostring(stone_counter));
                    vine_counter=0;
                    eq.get_zone():SetVariable("vine_counter",tostring(vine_counter));
                    mud_counter=0; -- Reset rings upon successful spawn
                    eq.get_zone():SetVariable("mud_counter",tostring(mud_counter));
                    dust_counter=0;
                    eq.get_zone():SetVariable("dust_counter",tostring(dust_counter));
                else
                --eq.zone_emote(15,"Sorry the Mystical Arbitor is in another Castle!");
                end
end

function UntargSludge_Spawn(e)
                mud_counter=0; -- If this mob spawns - Set ring to 0. [Fail]
                eq.get_zone():SetVariable("mud_counter",tostring(mud_counter));
                gorger_dead=0; -- reset gorger counter(1)
                eq.get_zone():SetVariable("gorger_dead",tostring(gorger_dead));
                gorgertwo=0; -- reset gorger counter(2)
                eq.get_zone():SetVariable("gorgertwo",tostring(gorgertwo));
                mudlet_death=0; -- reset mudlet counter
                eq.get_zone():SetVariable("mudlet_death",tostring(mudlet_death));
                eq.depop_all(218130); -- depop Filth Gorger(1)
                eq.depop_all(218042); -- depop Filth Gorger(2)
                eq.depop(218070); -- depop Sludge Lurker(1)
                eq.depop(218124); -- depop Sludge Lurker(2)
                eq.depop_all(218037); -- depop mudlings
                eq.depop_all(218084); -- depop mucklets
                eq.depop(218050); -- depop Monstrous Mudwalker
                eq.depop(218123); -- depop Merciless Mudslinger
end

function Mudwalker_Death(e)
                local el = eq.get_entity_list();
                if el:IsMobSpawnedByNpcTypeID(218013) == false and el:IsMobSpawnedByNpcTypeID(218090) == true then -- Are all ##Earthen Mudwalker's## down and is ##Mud_Trigger## up? If so start event for loot.
                eq.depop_with_timer(218125); -- Depop ##Sludge Lurker## Untargettable Version
                eq.spawn2(218070,0,0,339.58,84.85,71.75,511.0); -- Spawn ##Sludge Lurker##
                elseif el:IsMobSpawnedByNpcTypeID(218013) == false and el:IsMobSpawnedByNpcTypeID(218090) == false then -- Are all ##Earthen Mudwalker's## down and is ##Mud_Trigger## down? If so start event for PH.
                eq.depop_with_timer(218125); -- Depop ##Sludge Lurker## Untargettable Version
                eq.spawn2(218124,0,0,339.58,84.85,71.75,511.0); -- Spawn ##Sludge Lurker ## PH ring mode
                end
end

function Sludgetwo_Death(e)
        eq.spawn2(218130,0,0,303.93,128.79,71.75,134.3); -- spawn 4x ## Filth Gorger type two ##
        eq.spawn2(218130,0,0,380.18,130.47,71.75,266.5); -- NPC: A_Filth_Gorger
        eq.spawn2(218130,0,0,381.84,49.43,71.75,413.5); -- NPC: A_Filth_Gorger
        eq.spawn2(218130,0,0,303.67,49.65,71.75,61.5); -- NPC: A_Filth_Gorger
end

function Gorgertwo_Death(e)
        gorgertwo=gorgertwo+1 -- Count every death
        if gorgertwo == 4 then -- If 4, Follow directions
            eq.spawn2(218123,0,0,339.24,89.08,71.75,384.5); -- Summon ## Merciless Mudslinger ##
            mudlet_death=0; -- Reset Mudlet for counting
            gorgertwo=0; -- Reset gorgertwo for counting.
        end
        eq.get_zone():SetVariable("gorgertwo",tostring(gorgertwo));
        eq.get_zone():SetVariable("mudlet_death",tostring(mudlet_death));
end

function Mudslinger_Combat(e)
        if (e.joined == true) then
                eq.set_timer('Hardblur', 180 * 1000);
                eq.set_timer('Softblur', 6 * 1000);
        else
                eq.stop_timer('Hardblur');
                eq.stop_timer('Softblur');
        end
end

function Mudslinger_HP(e)
        if (e.hp_event == 50) then
        eq.spawn2(218037,0,0,302.07,49.26,71.75,72.3); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,296.45,54.74,71.75,63.3); -- Spawn 10X ## Muck_Mudling ##
        eq.spawn2(218037,0,0,302.72,61.04,71.75,64.0); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,308.82,57.42,71.75,59.5); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,313.58,66.62,71.75,52.0); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,379.98,143.95,71.75,319.8); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,371.99,147.69,71.75,319.3); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,386.55,136.56,71.75,316.3); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,377.39,129.38,71.75,316.3); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,364.15,131.53,71.75,315.5); -- NPC: A_Muddite_Mudling
        eq.set_next_hp_event(40);
        elseif (e.hp_event == 40) then
        eq.spawn2(218037,0,0,302.07,49.26,71.75,72.3); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,296.45,54.74,71.75,63.3); -- Spawn 10X ## Muck_Mudling ##
        eq.spawn2(218037,0,0,302.72,61.04,71.75,64.0); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,308.82,57.42,71.75,59.5); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,313.58,66.62,71.75,52.0); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,379.98,143.95,71.75,319.8); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,371.99,147.69,71.75,319.3); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,386.55,136.56,71.75,316.3); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,377.39,129.38,71.75,316.3); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,364.15,131.53,71.75,315.5); -- NPC: A_Muddite_Mudling
        eq.set_next_hp_event(10);
        elseif (e.hp_event == 10) then
        eq.spawn2(218037,0,0,302.07,49.26,71.75,72.3); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,296.45,54.74,71.75,63.3); -- Spawn 10X ## Muck_Mudling ##
        eq.spawn2(218037,0,0,302.72,61.04,71.75,64.0); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,308.82,57.42,71.75,59.5); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,313.58,66.62,71.75,52.0); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,379.98,143.95,71.75,319.8); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,371.99,147.69,71.75,319.3); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,386.55,136.56,71.75,316.3); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,377.39,129.38,71.75,316.3); -- NPC: A_Muddite_Mudling
        eq.spawn2(218037,0,0,364.15,131.53,71.75,315.5); -- NPC: A_Muddite_Mudling
        end
end

function Mudslinger_Death(e)
        local el = eq.get_entity_list();
        mud_counter=1
        eq.get_zone():SetVariable("mud_counter",tostring(mud_counter));
        eq.stop_timer('mud_box');
        if stone_counter == 1 and vine_counter == 1 and mud_counter == 1 and dust_counter == 1 and el:IsMobSpawnedByNpcTypeID(218094) == true then -- Are Stone/Dust/Vine/Mud all complete & is the Final Trigger mob Up? If so spawn Arbitor.
                eq.spawn2(218053,0,0,1520.9,-2745.2,6.1,376.4); -- Spawn Mystical Arbitor of Earth
                --eq.zone_emote(15,"Arbitor has spawned!");
                eq.depop_with_timer(218094); -- Despawn the Trigger mob ##Final_Trigger## so event can't be repeated multiple times.
                stone_counter=0;
                eq.get_zone():SetVariable("stone_counter",tostring(stone_counter));
                vine_counter=0;
                eq.get_zone():SetVariable("vine_counter",tostring(vine_counter));
                mud_counter=0; -- Reset rings upon successful spawn
                eq.get_zone():SetVariable("mud_counter",tostring(mud_counter));
                dust_counter=0;
                eq.get_zone():SetVariable("dust_counter",tostring(dust_counter));
        else
        --eq.zone_emote(15,"Sorry the Mystical Arbitor is in another Castle!");
        end
end

function Sludge_Spawn(e)
        eq.set_timer("mud_box", 6000); -- Set timer for Leash
    e.self:SetHP(e.self:GetMaxHP() * (Sludge_hitpoints / 100.0));
    if (Sludge_hitpoints == 100) then
    eq.set_next_hp_event(75);
    elseif (Sludge_hitpoints == 75) then
    eq.set_next_hp_event(50);
    elseif (Sludge_hitpoints == 50) then
    eq.set_next_hp_event(25);
    elseif (Sludge_hitpoints == 25) then
    eq.set_next_hp_event(10);
    end
end

function Sludge_Timer(e)
    if not mud_box:contains(e.self:GetX(), e.self:GetY()) then
        e.self:GotoBind();
                e.self:WipeHateList();
        end
end

function Monstrous_Spawn(e)
        eq.set_timer("mud_box", 6000); -- Set timer for Leash
        eq.set_next_hp_event(50);
end

function Monstrous_Timer(e)
        if not mud_box:contains(e.self:GetX(), e.self:GetY()) then
        e.self:GotoBind();
                e.self:WipeHateList();
        elseif (e.timer == 'Hardblur') then
        e.self:WipeHateList();
    elseif (e.timer == 'Softblur') then
        if (math.random(100)<=50) then
            e.self:WipeHateList();
        end
    end
end

function Mudslinger_Spawn(e)
        eq.set_timer("mud_box", 6000); -- Set timer for Leash
        eq.set_next_hp_event(50);
end

function Mudslinger_Timer(e)
        if not mud_box:contains(e.self:GetX(), e.self:GetY()) then
        e.self:GotoBind();
                e.self:WipeHateList();
        elseif (e.timer == 'Hardblur') then
        e.self:WipeHateList();
    elseif (e.timer == 'Softblur') then
        if (math.random(100)<=50) then
            e.self:WipeHateList();
        end
    end
end

function Sludge_HP(e)
    Sludge_hitpoints = e.hp_event;
    mudlet_death=0;
    eq.get_zone():SetVariable("mudlet_death",tostring(mudlet_death));
    eq.depop(218070);
    eq.spawn2(218084,0,0,381.52,127.78,71.75,258.8); -- NPC: A_Muck_Mudlet
    eq.spawn2(218084,0,0,355.95,130.11,71.75,284.3); -- NPC: A_Muck_Mudlet
    eq.spawn2(218084,0,0,329.38,129.46,71.75,257.0); -- NPC: A_Muck_Mudlet
    eq.spawn2(218084,0,0,304.61,130.28,71.75,231.0); -- NPC: A_Muck_Mudlet
    eq.spawn2(218084,0,0,303.52,104.01,71.75,207.5); -- Depop myself @ 75% HP - spawn 10 X ##Muck Muddlet##
    eq.spawn2(218084,0,0,304.38,76.83,71.75,135.0); -- NPC: A_Muck_Mudlet
    eq.spawn2(218084,0,0,329.42,74.09,71.75,56.0); -- NPC: A_Muck_Mudlet
    eq.spawn2(218084,0,0,355.95,73.77,71.75,9.8); -- NPC: A_Muck_Mudlet
    eq.spawn2(218084,0,0,380.65,75.42,71.75,498.5); -- NPC: A_Muck_Mudlet
    eq.spawn2(218084,0,0,382.95,98.83,71.75,413.8); -- NPC: A_Muck_Mudlet
end

function Mudlet_Death(e)
    mudlet_death=mudlet_death+1;
    if mudlet_death == 10 then
      eq.spawn2(218070,0,0,339.58,84.85,71.75,511.0); -- Respawn ##Sludge Lurker## Keep HP% at which he despawned.
      mudlet_death=0;
    end
    eq.get_zone():SetVariable("mudlet_death",tostring(mudlet_death));
end

function Sludge_Death(e)
        Sludge_hitpoints = 100;
        eq.spawn2(218042,0,0,303.93,128.79,71.75,134.3); -- spawn 4x ## Filth Gorger ##
        eq.spawn2(218042,0,0,380.18,130.47,71.75,266.5); -- NPC: A_Filth_Gorger
        eq.spawn2(218042,0,0,381.84,49.43,71.75,413.5); -- NPC: A_Filth_Gorger
        eq.spawn2(218042,0,0,303.67,49.65,71.75,61.5); -- NPC: A_Filth_Gorger
        eq.stop_timer('mud_box');
end

function Gorger_Death(e)
        gorger_dead=gorger_dead+1

        if gorger_dead == 4 then
            eq.spawn2(218050,0,0,339.20,76.11,71.75,20.3); -- Summon ##Monstrous Mudwalker ##
            gorger_dead = 0;
        end
        eq.get_zone():SetVariable("gorger_dead",tostring(gorger_dead));
end

function Monstrous_Combat(e)
        if (e.joined == true) then
                eq.set_timer('Hardblur', 180 * 1000);
                eq.set_timer('Softblur', 6 * 1000);
        else
                eq.stop_timer('Hardblur');
                eq.stop_timer('Softblur');
        end
end

function Monstrous_HP(e)
        if (e.hp_event == 50) then
            eq.spawn2(218037,0,0,302.07,49.26,71.75,72.3); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,296.45,54.74,71.75,63.3); -- Spawn 10X ## Muck_Mudling ##
            eq.spawn2(218037,0,0,302.72,61.04,71.75,64.0); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,308.82,57.42,71.75,59.5); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,313.58,66.62,71.75,52.0); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,379.98,143.95,71.75,319.8); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,371.99,147.69,71.75,319.3); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,386.55,136.56,71.75,316.3); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,377.39,129.38,71.75,316.3); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,364.15,131.53,71.75,315.5); -- NPC: A_Muddite_Mudling
            eq.set_next_hp_event(40);
        elseif (e.hp_event == 40) then
            eq.spawn2(218037,0,0,302.07,49.26,71.75,72.3); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,296.45,54.74,71.75,63.3); -- Spawn 10X ## Muck_Mudling ##
            eq.spawn2(218037,0,0,302.72,61.04,71.75,64.0); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,308.82,57.42,71.75,59.5); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,313.58,66.62,71.75,52.0); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,379.98,143.95,71.75,319.8); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,371.99,147.69,71.75,319.3); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,386.55,136.56,71.75,316.3); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,377.39,129.38,71.75,316.3); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,364.15,131.53,71.75,315.5); -- NPC: A_Muddite_Mudling
            eq.set_next_hp_event(10);
        elseif (e.hp_event == 10) then
            eq.spawn2(218037,0,0,302.07,49.26,71.75,72.3); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,296.45,54.74,71.75,63.3); -- Spawn 10X ## Muck_Mudling ##
            eq.spawn2(218037,0,0,302.72,61.04,71.75,64.0); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,308.82,57.42,71.75,59.5); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,313.58,66.62,71.75,52.0); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,379.98,143.95,71.75,319.8); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,371.99,147.69,71.75,319.3); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,386.55,136.56,71.75,316.3); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,377.39,129.38,71.75,316.3); -- NPC: A_Muddite_Mudling
            eq.spawn2(218037,0,0,364.15,131.53,71.75,315.5); -- NPC: A_Muddite_Mudling
        end
end

function Monstrous_Death(e)
        local el = eq.get_entity_list();
        eq.depop_with_timer(218090); -- Depop with timer ## Mud Trigger ## So we can still do trial later with PHs
        mud_counter=1 -- Set Mud ring to Success
        eq.get_zone():SetVariable("mud_counter",tostring(mud_counter));
        eq.stop_timer('mud_box');
        if stone_counter == 1 and vine_counter == 1 and mud_counter == 1 and dust_counter == 1 and el:IsMobSpawnedByNpcTypeID(218094) == true then -- Are Stone/Dust/Vine/Mud all complete & is the Final Trigger mob Up? If so spawn Arbitor.
                eq.spawn2(218053,0,0,1520.9,-2745.2,6.1,376.4); -- Spawn Mystical Arbitor of Earth
                --eq.zone_emote(15,"Arbitor has spawned!");
                eq.depop_with_timer(218094); -- Despawn the Trigger mob ##Final_Trigger## so event can't be repeated multiple times.
                stone_counter=0;
                eq.get_zone():SetVariable("stone_counter",tostring(stone_counter));
                vine_counter=0;
                eq.get_zone():SetVariable("vine_counter",tostring(vine_counter));
                mud_counter=0; -- Reset rings upon successful spawn
                eq.get_zone():SetVariable("mud_counter",tostring(mud_counter));
                dust_counter=0;
                eq.get_zone():SetVariable("dust_counter",tostring(dust_counter));
        else
        --eq.zone_emote(15,"Sorry the Mystical Arbitor is in another Castle!");
        end
end

function Dusty_Spawn(e)
        dust_counter=0;  -- If I spawn [ Set success to failure]
        eq.get_zone():SetVariable("dust_counter",tostring(dust_counter));
        soil_dead=0;  -- reset soil to 0
        eq.get_zone():SetVariable("soil_dead",tostring(soil_dead));
        follower_dead=0; -- reset followers to 0
        eq.get_zone():SetVariable("follower_dead",tostring(follower_dead));
        devotee_death=0; -- reset devotee to 0
        eq.get_zone():SetVariable("devotee_death",tostring(devotee_death));
        eq.depop_all(218064);  -- depop devotees
        eq.depop_all(218122); -- depop followers
        eq.depop_all(218045); -- depop triumvirate of soils
        eq.depop_all(218061); -- depop triumvirate protectors
        eq.depop(218096); -- depop Perfected Warder of Earth
end

function Dusty_Death(e)
        eq.spawn2(218064,0,0,-250,04.-1373.41,-34.25,511); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,-200.04,-1297.00,-40.55,472.8); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,-217.44,-1238.85,-42.13,289.8); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,-296.53,-1238.57,-41.95,205.8); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,-312.43,-1292.49,-39.75,89.3); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,-29.89,-714.25,12.33,263.0); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,43.08,-714.61,11.75,264.5); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,42.37,-685.50,31.75,260.0); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,-32.22,-683.71,31.75,260.3); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,-116.48,-598.69,31.75,390.3); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,-117.19,-521.14,31.75,389.8); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,-148.32,-523.52,11.75,388.0); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,-148.06,-597.64,12.23,387.8); -- spawn 37 Dust Devotees in their designated locations. All 37 must be killed to proceed with ring.
        eq.spawn2(218064,0,0,-28.08,-407.61,13.28,0.0); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,41.71,-406.70,12.42,4.0); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,-31.09,-437.54,31.75,3.0); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,43.23,-435.46,31.75,1.0); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,126.44,-522.99,31.75,130.3); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,127.82,-599.10,31.75,128.0); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,161.22,-596.43,12.47,134.5); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,159.26,-523.12,11.75,132.5); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,105.94,-599.41,31.75,384.8); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,107.98,-631.19,31.75,387.0); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,90.23,-663.51,31.75,509.3); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,46.31,-665.34,31.75,2.0); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,-33.62,-663.61,31.75,1.5); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,-78.24,-667.44,31.75,1.5); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,-96.73,-630.52,31.75,134.3); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,-98.16,-599.28,31.75,125.8); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,-94.86,-522.43,31.75,125.5); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,-97.43,-490.13,31.75,129.5); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,-78.36,-456.75,31.75,255.3); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,-37.29,-456.79,31.75,256.0); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,46.84,-457.67,31.75,257.8); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,89.89,-455.10,31.75,257.5); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,110.92,-490.27,31.75,380.5); -- NPC: A_Dust_Devotee
        eq.spawn2(218064,0,0,108.52,-522.32,31.75,387.3); -- NPC: A_Dust_Devotee
        eq.spawn2(218131,0,0,-32.37,-560.45,31.75,127.8); -- NPC: Triumvirate_of_Soil
        eq.spawn2(218131,0,0,24.07,-581.69,31.75,456.0); -- Spawn 3x Triumvirate Of Soil in a Pyramid Formation Untargetable.
        eq.spawn2(218131,0,0,25.65,-527.70,31.75,332.5); -- NPC: Triumvirate_of_Soil
        soil_dead=0;
        eq.get_zone():SetVariable("soil_dead",tostring(soil_dead));
end

function Devotee_Death(e)
        devotee_death=devotee_death+1; -- Count my deaths
        if devotee_death == 37 then
            eq.depop_all(218131); -- Depop the Untarget Triumvirate of Soil
            eq.spawn2(218045,0,0,-32.37,-560.45,31.75,127.8); -- NPC: Triumvirate_of_Soil
            eq.spawn2(218045,0,0,24.07,-581.69,31.75,456.0); -- Respawn them - Agro
            eq.spawn2(218045,0,0,25.65,-527.70,31.75,332.5); -- NPC: Triumvirate_of_Soil
            devotee_death=0; -- Reset devotee death to 0.
        end
        eq.get_zone():SetVariable("devotee_death",tostring(devotee_death));
end

function Soil_Death(e)
        local el = eq.get_entity_list();
        soil_dead=soil_dead+1; -- Count my deaths
        eq.get_zone():SetVariable("soil_dead",tostring(soil_dead));
        if soil_dead == 3 and el:IsMobSpawnedByNpcTypeID(218093) == true then -- Did 3 soils die? Is Dust Trigger up?  If so spawn Perfected Warder of Earth
            eq.spawn2(218096,0,0,5.88,-583.60,31.75,1.0); -- Spawn A Perfected Warder of Earth
            soil_dead=0; -- Reset soil counter
            eq.get_zone():SetVariable("soil_dead",tostring(soil_dead));
            eq.depop_with_timer(218093); -- Depop ## Dust Trigger ## so we can pop PH if needed
        elseif soil_dead == 3 and el:IsMobSpawnedByNpcTypeID(218093) == false then
            eq.spawn2(218122,0,0,-32.37,-560.45,31.75,127.8):AddToHateList(e.self:GetTarget(),1); -- NPC: A_Dust_Follower
            eq.spawn2(218122,0,0,24.07,-581.69,31.75,456.0):AddToHateList(e.self:GetTarget(),1); -- Spawn the PH ring ## Dust Follower x 3 ##
            eq.spawn2(218122,0,0,25.65,-527.70,31.75,332.5):AddToHateList(e.self:GetTarget(),1); -- NPC: A_Dust_Follower
            follower_dead=0; -- Set follower counter to 0.
            eq.get_zone():SetVariable("follower_dead",tostring(follower_dead));
        end
end

function Soil_Combat(e)
        if (e.joined == true) then
                eq.set_timer('Hardblur', 180 * 1000);
                eq.set_timer('Softblur', 6 * 1000);
        else
                eq.stop_timer('Hardblur');
                eq.stop_timer('Softblur');
        end
end

function Soil_Timer(e)
        if (e.timer == 'Hardblur') then
        e.self:WipeHateList();
    elseif (e.timer == 'Softblur') then
        if (math.random(100)<=10) then
            e.self:WipeHateList();
        end
    end
end

function Follower_Death(e)
        local el = eq.get_entity_list();
        follower_dead=follower_dead+1;
        eq.get_zone():SetVariable("follower_dead",tostring(follower_dead));
        if follower_dead == 3 then
            dust_counter=1; -- Set ring to success
            eq.get_zone():SetVariable("dust_counter",tostring(dust_counter));
            follower_dead=0; -- Reset count
            eq.get_zone():SetVariable("follower_dead",tostring(follower_dead));
            if stone_counter == 1 and vine_counter == 1 and mud_counter == 1 and dust_counter == 1 and el:IsMobSpawnedByNpcTypeID(218094) == true then -- Are Stone/Dust/Vine/Mud all complete & is the Final Trigger mob Up? If so spawn Arbitor.
                    eq.spawn2(218053,0,0,1520.9,-2745.2,6.1,376.4); -- Spawn Mystical Arbitor of Earth
                    --eq.zone_emote(15,"Arbitor has spawned!");
                    eq.depop_with_timer(218094); -- Despawn the Trigger mob ##Final_Trigger## so event can't be repeated multiple times.
                    ResetCounters();
            else
            --eq.zone_emote(15,"Sorry the Mystical Arbitor is in another Castle!");
            end
        end
end

function Follower_Spawn(e)
        eq.set_next_hp_event(80);
end

function Follower_Combat(e)
        if (e.joined == true) then
                eq.set_timer('Hardblur', 180 * 1000);
                eq.set_timer('Softblur', 6 * 1000);
        else
                eq.stop_timer('Hardblur');
                eq.stop_timer('Softblur');
        end
end

function Follower_Timer(e)
        if (e.timer == 'Hardblur') then
        e.self:WipeHateList();
    elseif (e.timer == 'Softblur') then
        if (math.random(100)<=10) then
            e.self:WipeHateList();
        end
    end
end

function Follower_HP(e)
        if (e.hp_event == 80) then
        eq.spawn2(218061,0,0, e.self:GetX()     - 30, e.self:GetY() - 10, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 25, e.self:GetY() - 25, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 30, e.self:GetY() + 40, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
        eq.set_next_hp_event(60);
        end
        if (e.hp_event == 60) then
        eq.spawn2(218061,0,0, e.self:GetX()     - 30, e.self:GetY() - 10, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 25, e.self:GetY() - 25, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 30, e.self:GetY() + 40, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
        eq.spawn2(218061,0,0, e.self:GetX(), e.self:GetY(), e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
        eq.set_next_hp_event(50);
        end
        if (e.hp_event == 50) then
        eq.spawn2(218061,0,0, e.self:GetX()     - 30, e.self:GetY() - 10, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 25, e.self:GetY() - 25, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 30, e.self:GetY() + 40, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
        eq.set_next_hp_event(40);
        end
        if (e.hp_event == 40) then
        eq.spawn2(218061,0,0, e.self:GetX()     - 30, e.self:GetY() - 10, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 25, e.self:GetY() - 25, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 30, e.self:GetY() + 40, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
        eq.spawn2(218061,0,0, e.self:GetX()     - 30, e.self:GetY() - 40, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 25, e.self:GetY() - 5, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 35, e.self:GetY() + 10, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
        end
end

function Warder_Spawn(e)
        eq.set_next_hp_event(80);
end

function Warder_Combat(e)
        if (e.joined == true) then
                eq.set_timer('Hardblur', 180 * 1000);
                eq.set_timer('Softblur', 6 * 1000);
        else
                eq.stop_timer('Hardblur');
                eq.stop_timer('Softblur');
        end
end

function Warder_Timer(e)
        if (e.timer == 'Hardblur') then
        e.self:WipeHateList();
    elseif (e.timer == 'Softblur') then
        if (math.random(100)<=10) then
            e.self:WipeHateList();
        end
    end
end

function Warder_HP(e)
        if (e.hp_event == 80) then
        eq.spawn2(218061,0,0, e.self:GetX()     - 30, e.self:GetY() - 10, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 25, e.self:GetY() - 25, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 30, e.self:GetY() + 40, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
        eq.set_next_hp_event(60);
        end
        if (e.hp_event == 60) then
        eq.spawn2(218061,0,0, e.self:GetX()     - 30, e.self:GetY() - 10, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 25, e.self:GetY() - 25, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 30, e.self:GetY() + 40, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
        eq.spawn2(218061,0,0, e.self:GetX(), e.self:GetY(), e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
        eq.set_next_hp_event(50);
        end
        if (e.hp_event == 50) then
        eq.spawn2(218061,0,0, e.self:GetX()     - 30, e.self:GetY() - 10, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 25, e.self:GetY() - 25, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 30, e.self:GetY() + 40, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
        eq.set_next_hp_event(40);
        end
        if (e.hp_event == 40) then
        eq.spawn2(218061,0,0, e.self:GetX()     - 30, e.self:GetY() - 10, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 25, e.self:GetY() - 25, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 30, e.self:GetY() + 40, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
        eq.spawn2(218061,0,0, e.self:GetX()     - 30, e.self:GetY() - 40, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 25, e.self:GetY() - 5, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 35, e.self:GetY() + 10, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
        eq.set_next_hp_event(30);
        end
        if (e.hp_event == 30) then
        eq.spawn2(218061,0,0, e.self:GetX()     - 30, e.self:GetY() - 10, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 25, e.self:GetY() - 25, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 30, e.self:GetY() + 40, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
        eq.spawn2(218061,0,0, e.self:GetX()     - 30, e.self:GetY() - 40, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 25, e.self:GetY() - 5, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
        eq.set_next_hp_event(5);
        end
        if (e.hp_event == 5) then
        eq.spawn2(218061,0,0, e.self:GetX()     - 30, e.self:GetY() - 10, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 25, e.self:GetY() - 25, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 30, e.self:GetY() + 40, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
        eq.spawn2(218061,0,0, e.self:GetX()     - 30, e.self:GetY() - 40, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
    eq.spawn2(218061,0,0, e.self:GetX() - 25, e.self:GetY() - 5, e.self:GetZ(), e.self:GetHeading()); -- NPC: A_Triumvirate_Protector
        end
end

function Warder_Death(e)
        local el = eq.get_entity_list();
        dust_counter=1; -- Set this ring to success.
        eq.get_zone():SetVariable("dust_counter",tostring(dust_counter));
        if stone_counter == 1 and vine_counter == 1 and mud_counter == 1 and dust_counter == 1 and el:IsMobSpawnedByNpcTypeID(218094) == true then -- Are Stone/Dust/Vine/Mud all complete & is the Final Trigger mob Up? If so spawn Arbitor.
                eq.spawn2(218053,0,0,1520.9,-2745.2,6.1,376.4); -- Spawn Mystical Arbitor of Earth
                --eq.zone_emote(15,"Arbitor has spawned!");
                eq.depop_with_timer(218094); -- Despawn the Trigger mob ##Final_Trigger## so event can't be repeated multiple times.
                ResetCounters();
        else
        --eq.zone_emote(15,"Sorry the Mystical Arbitor is in another Castle!");
        end
end

function Deruph_Spawn(e)
    vine_counter=0;  -- If I spawn set vine ring to [Failure]
    eq.get_zone():SetVariable("vine_counter",tostring(vine_counter));
    bloodthirsty_dead=0; -- set bloodthirsty back to 0
    eq.get_zone():SetVariable("bloodthirsty_dead",tostring(bloodthirsty_dead));
    tainted_dead=0; -- set tainted back to 0
    eq.get_zone():SetVariable("tainted_dead",tostring(tainted_dead));
    eq.depop_all(218040); -- depop bloodthirsty(1) (Targetable version)
    eq.depop(218128); -- depop Bloodsoaked Vegerog
    eq.depop(218058); -- depop Deru Named
    eq.spawn2(218126,0,0,447.24,-868.75,37.75,68.8); -- Spawn all 10 Bloodthirsty Vegerog
    eq.spawn2(218126,0,0,484.89,-872.28,37.75,510.8); -- NPC: A_Bloodthirsty_Vegerog
    eq.spawn2(218126,0,0,521.35,-870.67,37.75,455.8); -- NPC: A_Bloodthirsty_Vegerog
    eq.spawn2(218126,0,0,521.84,-831.45,37.75,387.0); -- NPC: A_Bloodthirsty_Vegerog
    eq.spawn2(218126,0,0,523.63,-795.69,37.75,336.8); -- NPC: A_Bloodthirsty_Vegerog
    eq.spawn2(218126,0,0,483.41,-793.68,37.75,258.8); -- NPC: A_Bloodthirsty_Vegerog
    eq.spawn2(218126,0,0,446.91,-793.18,37.75,197.3); -- NPC: A_Bloodthirsty_Vegerog
    eq.spawn2(218126,0,0,443.52,-834.30,37.75,130.8); -- NPC: A_Bloodthirsty_Vegerog
    eq.spawn2(218126,0,0,461.58,-855.27,33.75,67.0); -- NPC: A_Bloodthirsty_Vegerog
    eq.spawn2(2181265,0,0,509.08,-806.73,33.75,313.0);
end

function Tainted_Death(e)
    local el = eq.get_entity_list();
    tainted_dead=tainted_dead+1; -- Count deaths
    if tainted_dead == 30 and el:IsMobSpawnedByNpcTypeID(218127) == true then
        eq.depop_with_timer(218127); -- Depop ring timer mob.
        eq.depop_all(218126); -- Depop Bloodthirsty Vegerog & Repop them to agro
        tainted_dead=0; -- Reset count on tainted.
        eq.spawn2(218040,0,0,447.24,-868.75,37.75,68.8); -- Spawn all 10 Bloodthirsty Vegerog
        eq.spawn2(218040,0,0,484.89,-872.28,37.75,510.8); -- NPC: A_Bloodthirsty_Vegerog
        eq.spawn2(218040,0,0,521.35,-870.67,37.75,455.8); -- NPC: A_Bloodthirsty_Vegerog
        eq.spawn2(218040,0,0,521.84,-831.45,37.75,387.0); -- NPC: A_Bloodthirsty_Vegerog
        eq.spawn2(218040,0,0,523.63,-795.69,37.75,336.8); -- NPC: A_Bloodthirsty_Vegerog
        eq.spawn2(218040,0,0,483.41,-793.68,37.75,258.8); -- NPC: A_Bloodthirsty_Vegerog
        eq.spawn2(218040,0,0,446.91,-793.18,37.75,197.3); -- NPC: A_Bloodthirsty_Vegerog
        eq.spawn2(218040,0,0,443.52,-834.30,37.75,130.8); -- NPC: A_Bloodthirsty_Vegerog
        eq.spawn2(218040,0,0,461.58,-855.27,33.75,67.0); -- NPC: A_Bloodthirsty_Vegerog
        eq.spawn2(218040,0,0,509.08,-806.73,33.75,313.0); -- NPC: A_Bloodthirsty_Vegerog
    end
    eq.get_zone():SetVariable("tainted_dead",tostring(tainted_dead));
end

function Bloodthirsty_Death(e)
    local el = eq.get_entity_list();
    bloodthirsty_dead=bloodthirsty_dead+1;  -- Count these
    if bloodthirsty_dead == 10 and el:IsMobSpawnedByNpcTypeID(218091) == true then
        eq.spawn2(218058,0,0,484.89,-835.89,34.05,9.3); -- Spawn Named
        bloodthirsty_dead=0; -- Reset counter
        eq.depop_with_timer(218091); -- Depop ## Vine Trigger ## so we can pop PH next time.
    elseif bloodthirsty_dead == 10 and el:IsMobSpawnedByNpcTypeID(218091) == false then
        eq.spawn2(218128,0,0,484.89,-835.89,34.05,9.3); -- Spawn Placeholder
        bloodthirsty_dead=0; -- Reset counter
    end
    eq.get_zone():SetVariable("bloodthirsty_dead",tostring(bloodthirsty_dead));
end

function Deru_Death(e)
        local el = eq.get_entity_list();
        vine_counter=1; -- Reset counter
        eq.get_zone():SetVariable("vine_counter","1");
        if stone_counter == 1 and vine_counter == 1 and mud_counter == 1 and dust_counter == 1 and el:IsMobSpawnedByNpcTypeID(218094) == true then -- Are Stone/Dust/Vine/Mud all complete & is the Final Trigger mob Up? If so spawn Arbitor.
                eq.spawn2(218053,0,0,1520.9,-2745.2,6.1,376.4); -- Spawn Mystical Arbitor of Earth
                --eq.zone_emote(15,"Arbitor has spawned!");
                eq.depop_with_timer(218094); -- Despawn the Trigger mob ##Final_Trigger## so event can't be repeated multiple times.
                ResetCounters();
        else
        --eq.zone_emote(15,"Sorry the Mystical Arbitor is in another Castle!");
        end
end

function Deru_Combat(e)
        if (e.joined == true) then
                eq.set_timer('Hardblur', 180 * 1000);
                eq.set_timer('Softblur', 6 * 1000);
        else
                eq.stop_timer('Hardblur');
                eq.stop_timer('Softblur');
        end
end

function Deru_Timer(e)
        if (e.timer == 'Hardblur') then
        e.self:WipeHateList();
    elseif (e.timer == 'Softblur') then
        if (math.random(100)<=50) then
            e.self:WipeHateList();
        end
    end
end

function Bloodsoaked_Combat(e)
                if (e.joined == true) then
                        eq.set_timer('Hardblur', 180 * 1000);
                        eq.set_timer('Softblur', 6 * 1000);
                else
                        eq.stop_timer('Hardblur');
                        eq.stop_timer('Softblur');
                end
end

function Bloodsoaked_Timer(e)
                if (e.timer == 'Hardblur') then
                        e.self:WipeHateList();
                elseif (e.timer == 'Softblur') then
                        if (math.random(100)<=50) then
            e.self:WipeHateList();
        end
    end
end

function Bloodsoaked_Death(e)
        local el = eq.get_entity_list();
        vine_counter=1; -- Set vine ring to success
        eq.get_zone():SetVariable("vine_counter","1");
        if stone_counter == 1 and vine_counter == 1 and mud_counter == 1 and dust_counter == 1 and el:IsMobSpawnedByNpcTypeID(218094) == true then -- Are Stone/Dust/Vine/Mud all complete & is the Final Trigger mob Up? If so spawn Arbitor.
                eq.spawn2(218053,0,0,1520.9,-2745.2,6.1,376.4); -- Spawn Mystical Arbitor of Earth
                --eq.zone_emote(15,"Arbitor has spawned!");
                eq.depop_with_timer(218094); -- Despawn the Trigger mob ##Final_Trigger## so event can't be repeated multiple times.
                ResetCounters();
        else
        --eq.zone_emote(15,"Sorry the Mystical Arbitor is in another Castle!");
        end
end

function Mystical_Arbitorspawn(e)
    if tostring(eq.get_zone_instance_version()) ~= eq.get_rule("Custom:StaticInstanceVersion") then -- Only depop in open world
        eq.set_timer("Mystical", 3600000); -- Start 1 Hour timer to kill.
    end
end

function Mystical_Combat(e)
        if (e.joined == true) then
                eq.set_timer('Hardblur', 180 * 1000);
                eq.set_timer('Softblur', 6 * 1000);
        else
                eq.stop_timer('Hardblur');
                eq.stop_timer('Softblur');
        end
end

function Mystical_Timer(e)
        if e.timer == "Mystical" then -- If 1 hour has passed
                eq.stop_timer('Mystical'); -- Stop timer
                eq.depop(); -- Depop myself
        elseif (e.timer == "Hardblur") then
                e.self:WipeHateList();
        elseif (e.timer == "Softblur") then
                if(math.random(100)<=25) then
                        e.self:WipeHateList();
                end
        end
end

function Mystical_Death(e)
        if tostring(eq.get_zone_instance_version()) == eq.get_rule("Custom:StaticInstanceVersion") then -- Only flag in non-respawning dz
                eq.spawn2(218068,0,0,1562.11,-2741.93,6.97,386.5); -- Spawn Planar Projection
        end
end

function ResetCounters()
    stone_counter=0;
    eq.get_zone():SetVariable("stone_counter","0");
    vine_counter=0;
    eq.get_zone():SetVariable("vine_counter","0");
    mud_counter=0; -- Reset rings upon successful spawn
    eq.get_zone():SetVariable("mud_counter","0");
    dust_counter=0;
    eq.get_zone():SetVariable("dust_counter","0");
end

function event_encounter_load(e)
        eq.register_npc_event('Rings', Event.death_complete,                218032,             Rock_Death);
        eq.register_npc_event('Rings', Event.death_complete,                218030,             Boulder_Death);
        eq.register_npc_event('Rings', Event.death_complete,                218031,             Crumbling_Death);
        eq.register_npc_event('Rings', Event.death_complete,                218033,             Thrower_Death);

        eq.register_npc_event('Rings', Event.death_complete,                218121,             Peregin_Death);
        eq.register_npc_event('Rings', Event.combat,                        218121,             Peregin_Combat);
        eq.register_npc_event('Rings', Event.timer,                         218121,             Peregin_Timer);

        eq.register_npc_event('Rings', Event.death_complete,                218089,             Monstrosity_Death);
        eq.register_npc_event('Rings', Event.death_complete,                218079,             Heap_Death);
        eq.register_npc_event('Rings', Event.death_complete,                218072,             Stone_Death);

        eq.register_npc_event('Rings', Event.death_complete,                218129,             Encrusted_Death);
        eq.register_npc_event('Rings', Event.combat,                        218129,             Encrusted_Combat);
        eq.register_npc_event('Rings', Event.timer,                         218129,             Encrusted_Timer);

        eq.register_npc_event('Rings', Event.spawn,                         218049,             Pereginspawnone_Spawn);
        eq.register_npc_event('Rings', Event.spawn,                         218029,             Placeholder_Spawn);

        eq.register_npc_event('Rings', Event.timer,                         218049,             Pereginspawnone_Timer);

        eq.register_npc_event('Rings', Event.hp,                            218076,             Rubble_HP);
        eq.register_npc_event('Rings', Event.death_complete,                218076,             Rubble_Death);
        eq.register_npc_event('Rings', Event.death_complete,                218118,             Rubble_Death);
        eq.register_npc_event('Rings', Event.death_complete,                218119,             Rubble_Death);
        eq.register_npc_event('Rings', Event.death_complete,                218120,             Rubble_Death);
        eq.register_npc_event('Rings', Event.hp,                            218118,             Rubbletwo_HP);
        eq.register_npc_event('Rings', Event.hp,                            218119,             Rubblethree_HP);
        eq.register_npc_event('Rings', Event.hp,                            218120,             Rubblefour_HP);

        eq.register_npc_event('Rings', Event.combat,                        218076,             Rubble_Combat);
        eq.register_npc_event('Rings', Event.combat,                        218118,             Rubbletwo_Combat);
        eq.register_npc_event('Rings', Event.combat,                        218119,             Rubblethree_Combat);
        eq.register_npc_event('Rings', Event.combat,                        218120,             Rubblefour_Combat);

        eq.register_npc_event('Rings', Event.death_complete,                218013,             Mudwalker_Death);
        eq.register_npc_event('Rings', Event.death_complete,                218084,             Mudlet_Death);
        eq.register_npc_event('Rings', Event.spawn,                         218125,             UntargSludge_Spawn);

        eq.register_npc_event('Rings', Event.hp,                            218070,             Sludge_HP);
        eq.register_npc_event('Rings', Event.spawn,                         218070,             Sludge_Spawn);
        eq.register_npc_event('Rings', Event.timer,                         218070,             Sludge_Timer);
        eq.register_npc_event('Rings', Event.death_complete,                218070,             Sludge_Death);
        eq.register_npc_event('Rings', Event.death_complete,                218124,             Sludgetwo_Death);

        eq.register_npc_event('Rings', Event.death_complete,                218042,             Gorger_Death);
        eq.register_npc_event('Rings', Event.death_complete,                218130,             Gorgertwo_Death);

        eq.register_npc_event('Rings', Event.combat,                        218050,             Monstrous_Combat);
        eq.register_npc_event('Rings', Event.death_complete,                218050,             Monstrous_Death);
        eq.register_npc_event('Rings', Event.hp,                            218050,             Monstrous_HP);
        eq.register_npc_event('Rings', Event.spawn,                         218050,             Monstrous_Spawn);
        eq.register_npc_event('Rings', Event.timer,                         218050,             Monstrous_Timer);

        eq.register_npc_event('Rings', Event.combat,                        218123,             Mudslinger_Combat);
        eq.register_npc_event('Rings', Event.hp,                            218123,             Mudslinger_HP);
        eq.register_npc_event('Rings', Event.death_complete,                218123,             Mudslinger_Death);
        eq.register_npc_event('Rings', Event.spawn,                         218123,             Mudslinger_Spawn);
        eq.register_npc_event('Rings', Event.timer,                         218123,             Mudslinger_Timer);

        eq.register_npc_event('Rings', Event.death_complete,                218022,             Dusty_Death);
        eq.register_npc_event('Rings', Event.spawn,                         218022,             Dusty_Spawn);
        eq.register_npc_event('Rings', Event.death_complete,                218064,             Devotee_Death);

        eq.register_npc_event('Rings', Event.death_complete,                218045,             Soil_Death);
        eq.register_npc_event('Rings', Event.combat,                        218045,             Soil_Combat);
        eq.register_npc_event('Rings', Event.timer,                         218045,             Soil_Timer);

        eq.register_npc_event('Rings', Event.combat,                        218096,             Warder_Combat);
        eq.register_npc_event('Rings', Event.hp,                            218096,             Warder_HP);
        eq.register_npc_event('Rings', Event.death_complete,                218096,             Warder_Death);
        eq.register_npc_event('Rings', Event.timer,                         218096,             Warder_Timer);
        eq.register_npc_event('Rings', Event.spawn,                         218096,             Warder_Spawn);

        eq.register_npc_event('Rings', Event.death_complete,                218122,             Follower_Death);
        eq.register_npc_event('Rings', Event.combat,                        218122,             Follower_Combat);
        eq.register_npc_event('Rings', Event.hp,                            218122,             Follower_HP);
        eq.register_npc_event('Rings', Event.timer,                         218122,             Follower_Timer);
        eq.register_npc_event('Rings', Event.spawn,                         218122,             Follower_Spawn);

        eq.register_npc_event('Rings', Event.spawn,                         218127,             Deruph_Spawn);
        eq.register_npc_event('Rings', Event.death_complete,                218019,             Tainted_Death);

        eq.register_npc_event('Rings', Event.death_complete,                218040,             Bloodthirsty_Death);

        eq.register_npc_event('Rings', Event.combat,                        218058,             Deru_Combat);
        eq.register_npc_event('Rings', Event.timer,                         218058,             Deru_Timer);
        eq.register_npc_event('Rings', Event.death_complete,                218058,             Deru_Death);

        eq.register_npc_event('Rings', Event.death_complete,                218128,             Bloodsoaked_Death);
        eq.register_npc_event('Rings', Event.combat,                        218128,             Bloodsoaked_Combat);
        eq.register_npc_event('Rings', Event.timer,                         218128,             Bloodsoaked_Timer);

        eq.register_npc_event('Rings', Event.spawn,                         218053,             Mystical_Arbitorspawn);
        eq.register_npc_event('Rings', Event.timer,                         218053,             Mystical_Timer);
        eq.register_npc_event('Rings', Event.death_complete,                218053,             Mystical_Death);
        eq.register_npc_event('Rings', Event.combat,                        218053,             Mystical_Combat);

        RestoreVariables();
end
