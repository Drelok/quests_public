-- NPC ID 223097

local charid_list
local entity_list
local instance_id = 0
local player_limit

local total_time = tonumber(eq.get_data(eq.get_zone_instance_id() .. "-total_time")) or 0

-- These Lockouts are Live Like
-- P1
local P1AIR				= 'Neimon of Air'
local P1EARTH				= 'Terlok of Earth'
local P1WATER				= 'Anar of Water'
local P1FIRE				= 'Kazrok of Fire'
local P1UNDEAD				= 'Rythor of the Undead'
-- P2
local P2AIR				= 'Windshapen Warlord of Air'
local P2EARTH				= 'Earthen Overseer'
local P2WATER				= 'War Shapen Emissary'
local P2FIRE				= 'Gutripping War Beast'
local P2UNDEAD				= 'Ralthos Enrok'
-- P3
local FEROCIOUSWARBOAR			= 'A Ferocious Warboar'
local BLACKHEART			= 'Deathbringer Blackheart'
local XEROAN				= 'Xeroan Xi`Geruonask'
local KRAKSMAAL				= 'Kraksmaal Fir`Dethsin'
local DEADLYWARBOAR			= 'A Deadly Warboar'
local SKULLSMASH			= 'Deathbringer Skullsmash'
local HERLSOAKIAN			= 'Herlsoakian'
local SINRUNAL				= 'Sinrunal Gorgedreal'
local NEEDLETUSK			= 'A Needletusk Warboar'
local RIANIT				= 'Deathbringer Rianit'
local DERSOOL				= 'Dersool Fal`Giersnaol'
local XERSKEL				= 'Xerskel Gerodnsal'
local SQUADLEADER			= 'Undead Squad Leader'
local DARKKNIGHT			= 'Dark Knight of Terris'
local TORMENT				= 'Champion of Torment'
local DREAMWARP				= 'Dreamwarp'
local AVATAR				= 'Avatar of the Elements'
local SUPGUARDIAN			= 'Supernatural Guardian'
-- P4
local TERRIS				= 'Terris-Thule'
local SARYRN				= 'Saryrn'
local TALLONZEK				= 'Tallon Zek'
local VALLONZEK				= 'Vallon Zek'
-- P5
-- local BERTOXXULOUOSTRASH	= 'Bertoxxulous Trash'
local BERTOXXULOUOS			= 'Bertoxxulous'
-- local CAZICTHULETRASH		= 'Cazic-Thule Trash'
local CAZICTHULE			= 'Cazic-Thule'
-- local INNORUUKTRASH			= 'Innoruuk Trash'
local INNORUUK				= 'Innoruuk'
-- local RALLOSZEKTRASH		= 'Rallos Zek Trash'
local RALLOSZEK				= 'Rallos Zek'
-- P6
local QUARM				= 'Quarm'

-- These are Custom Timers to help with tracking status
local PHASE1COMPLETE	= 'Phase 1 Complete'
local PHASE2COMPLETE	= 'Phase 2 Complete'
local PHASE3COMPLETE	= 'Phase 3 Complete'
local PHASE4COMPLETE	= 'Phase 4 Complete'
local PHASE5COMPLETE	= 'Phase 5 Complete'


local variables = {
	-- Phase 1
	[223170] = P1AIR,
	[223169] = P1EARTH,
	[223172] = P1WATER,
	[223173] = P1FIRE,
	[223171] = P1UNDEAD,

	-- Phase 2
	[223118] = P2AIR,
	[223134] = P2EARTH,
	[223096] = P2WATER,
	[223146] = P2FIRE,
	[223127] = P2UNDEAD,

	-- Named Enemies
	[223008] = FEROCIOUSWARBOAR,
	[223009] = BLACKHEART,
	[223016] = XEROAN,
	[223017] = KRAKSMAAL,
	[223022] = DEADLYWARBOAR,
	[223023] = SKULLSMASH,
	[223013] = HERLSOAKIAN,
	[223012] = SINRUNAL,
	[223010] = NEEDLETUSK,
	[223011] = RIANIT,
	[223015] = DERSOOL,
	[223014] = XERSKEL,
	[223021] = SQUADLEADER,
	[223020] = DARKKNIGHT,
	[223019] = TORMENT,
	[223018] = DREAMWARP,

	-- Major Bosses
	[223073] = AVATAR,
	[223074] = SUPGUARDIAN,
	[223075] = TERRIS,
	[223076] = SARYRN,
	[223077] = TALLONZEK,
	[223078] = VALLONZEK,
	[223201] = QUARM,

	-- Trash Mobs and Mini-Bosses
	-- [223098] = BERTOXXULOUOSTRASH,
	[223142] = BERTOXXULOUOS,
	-- [223165] = CAZICTHULETRASH,
	[223166] = CAZICTHULE,
	-- [223000] = INNORUUKTRASH,
	[223167] = INNORUUK,
	-- [223001] = RALLOSZEKTRASH,
	[223168] = RALLOSZEK,
}

local p3TrashSpawns = {
	{ x=1150, y=1035, z=358, h=385 },
	{ x=1150, y=1085, z=358, h=385 },
	{ x=1150, y=1135, z=358, h=385 },
	{ x=1150, y=1185, z=358, h=385 },
	{ x=1200, y=1035, z=358, h=385 },
	{ x=1200, y=1085, z=358, h=385 },
	{ x=1200, y=1135, z=358, h=385 },
	{ x=1200, y=1185, z=358, h=385 }
}

local p3TrashByWave = {
	[1] = { 223005, 223006 },
	[2] = { 223026, 223027, 223028, 223029 },
	[3] = { 223033, 223034, 223035, 223036 },
	[4] = { 223039, 223040, 223041, 223042, 223043, 223044, 223045 },
	[5] = { 223048, 223049 },
	[6] = { 223052, 223053, 223054, 223055, 223056 },
	[7] = { 223059, 223060, 223061, 223062, 223063, 223064 },
	[8] = { 223067, 223068, 223069, 223070, 223071, 223072 }
}

function event_spawn(e)
	e.self:SetTimer("spawn",1)
end

function do_the_spawn(e)
	local phase_one_started = tonumber(eq.get_zone():GetVariable("Phase 1 Started")) or 0
	if phase_one_started == 0 then
		ResetVariables()
		-- turn off all the spawn conditions
		ResetSpawnConditions()
	end

	instance_id = eq.get_zone_instance_id()
	local expedition = eq.get_expedition()
	local entity_list = eq.get_entity_list()
	local phase_variable = tonumber(eq.get_zone():GetVariable("Phase")) or 0
	-- Check Lockouts to decide what phase
	if phase_variable == 0 then
		-- Spawn phase 1
		eq.spawn2(223169, 0, 0, 13.5, 1632.4, 492.3, 0) -- earth trigger
		eq.spawn2(223170, 0, 0, 10.1, 1350, 492.6, 0) -- air trigger
		eq.spawn2(223171, 0, 0, 18.0, 1107, 492.2, 0) -- undead trigger
		eq.spawn2(223172, 0, 0, 11.5, 857, 492.5, 0) -- water trigger
		eq.spawn2(223173, 0, 0, 13.2, 574.2, 492.3, 0) -- fire trigger
	elseif phase_variable == 1 then
		eq.get_zone():SetVariable("Current Phase", "Phase 2")
		-- sendsignal to flavor text NPC
		eq.signal(223227, 2) -- Emoter
		-- spawn phase 2 controller
		eq.unique_spawn(2231731, 0, 0, 190, 1070, 494, 0) --phase_two_controller (2231731)
	elseif phase_variable == 2 then
		eq.get_zone():SetVariable("Current Phase", "Phase 3")
		-- sendsignal to flavor text NPC
		eq.signal(223227, 3) -- Emoter
		-- begin Phase 3
		eq.set_timer("p3unsticker",10000)
		ControlPhaseThree()
	elseif phase_variable == 3 then
		eq.get_zone():SetVariable("Current Phase", "Phase 4")
		-- sendsignal to flavor text NPC
		eq.signal(223227, 4) -- Emoter
		SpawnPhaseFour()
	elseif phase_variable == 4 then
		eq.get_zone():SetVariable("Current Phase", "Phase 5")
		-- sendsignal to flavor text NPC
		eq.signal(223227, 5) -- Emoter
		SpawnPhaseFive()
	elseif phase_variable == 5 then
		eq.get_zone():SetVariable("Current Phase", "Phase 6")
		-- sendsignal to flavor text NPC
		eq.signal(223227, 6) -- Emoter
		-- spawn Quarm
		local quarm_variable = tonumber(eq.get_zone():GetVariable("Quarm")) or 0
		if quarm_variable == 0 and not eq.is_npc_spawned({223201}) then -- If left DZ and zone before P6 Complete lockout
			eq.spawn2(223201, 0, 0, -401, -1106, 32.5, 22)
			-- spawn #A_Servitor_of_Peace
			eq.spawn2(223101, 0, 0, 244, -1106, -1.125, 194.0625)
		end
		-- spawn untargetable Zebuxoruk's Cage
		if not not eq.is_npc_spawned({223228}) then
			eq.spawn2(223228, 0, 0, -579, -1119, 60.625, 0)
		end
	end
end

function event_signal(e)
	local expedition = eq.get_expedition()
	instance_id = eq.get_zone_instance_id()

	if variables[e.signal] then
		eq.get_zone():SetVariable(variables[e.signal], "1")
	end

	-- grab the entity_list
	local entity_list = eq.get_entity_list()
	local phase_one_started = tonumber(eq.get_zone():GetVariable("Phase 1 Started")) or 0 == 1;
	-- signal 1 comes from the phase 1 trigger mobs
	if e.signal == 1 and not phase_one_started then
		eq.get_zone():SetVariable("Phase", "Phase 2")
		eq.get_zone():SetVariable("Phase 1 Started", "1")
		-- npc global for status tracking.
		eq.get_zone():SetVariable("Current Phase", "Phase 1")
		-- sendsignal to flavor text NPC
		eq.signal(223227, 1) -- Emoter
	-- signal 2 comes from the mobs in the final wave of each phase 1 event
	elseif e.signal == 2 then
		-- check that all 5 phase 1 events are down.
		local p1Complete = 0;
		local p1FireComplete = tonumber(eq.get_zone():GetVariable("Kazrok of Fire")) or 0
		local p1UndeadComplete = tonumber(eq.get_zone():GetVariable("Rythor of the Undead")) or 0
		local p1WaterComplete = tonumber(eq.get_zone():GetVariable("Anar of Water")) or 0
		local p1EarthComplete = tonumber(eq.get_zone():GetVariable("Terlok of Earth")) or 0
		local p1AirComplete = tonumber(eq.get_zone():GetVariable("Neimon of Air")) or 0
		p1Complete = p1FireComplete + p1UndeadComplete + p1WaterComplete + p1EarthComplete + p1AirComplete

		if p1Complete >= 5 then
			local phase_variable = tonumber(eq.get_zone():GetVariable("Phase")) or 0
			if phase_variable == 0 then -- Moving to Phase 2
				eq.get_zone():SetVariable("Phase", "1")
				eq.get_zone():SetVariable("Counter", "0")
				eq.unique_spawn(2231731, 0, 0, 190, 1070, 494, 0) --phase_two_controller (2231731)
				eq.signal(223227, 2) -- Emoter
			elseif phase_variable == 2 then -- Moving to Phase 3
				SetupPhaseThree()
			elseif phase_variable == 3 then -- Moving to Phase 4
				SetupPhaseFour()
			elseif phase_variable == 4 then -- Moving to Phase 5
				eq.signal(223097, 5)
				eq.signal(223227, 5) -- Emoter
			elseif phase_variable == 5 then -- Moving to Phase 6
				eq.signal(223097, 6)
				eq.signal(223227, 6) -- Emoter
			end
		end
	elseif e.signal == 3 then -- signal 3 comes from the phase 2 mobs.
		local bosses_are_dead = not eq.is_npc_spawned({223096, 223118, 223127, 223134, 223146})
		if bosses_are_dead then
			eq.get_zone():SetVariable("Phase", "2");
			ControlPhaseTwo()
		end
	-- signal 4 comes from the phase 3 mobs.
	elseif e.signal == 4 then
		ControlPhaseThree()
	-- signal 5 comes from the phase 4 gods.
	elseif e.signal == 5 then
		local saryrn_variable = tonumber(eq.get_zone():GetVariable(SARYRN)) or 0
		local tallon_variable = tonumber(eq.get_zone():GetVariable(TALLONZEK)) or 0
		local terris_variable = tonumber(eq.get_zone():GetVariable(TERRIS)) or 0
		local vallon_variable = tonumber(eq.get_zone():GetVariable(VALLONZEK)) or 0
		if (
			saryrn_variable == 1 and
			tallon_variable == 1 and
			terris_variable == 1 and
			vallon_variable == 1
		) then -- If all Phase 4 gods are dead
			local phase_variable = tonumber(eq.get_zone():GetVariable("Phase")) or 0
			eq.get_zone():SetVariable("Phase", "4")
			eq.get_zone():SetVariable("Current Phase", "Phase 5")
			-- sendsignal to flavor text NPC
			eq.signal(223227, 5) -- Emoter
			-- reset counter for later use
			-- event_counter = 0
			-- spawn phase 5
			SpawnPhaseFive()
		end
	-- signal 6 comes from the phase 5 gods.
	elseif e.signal == 6 then
		instance_id = eq.get_zone_instance_id()
		local bertox_variable = tonumber(eq.get_zone():GetVariable(BERTOXXULOUOS)) or 0
		local cazic_variable = tonumber(eq.get_zone():GetVariable(CAZICTHULE)) or 0
		local innoruuk_variable = tonumber(eq.get_zone():GetVariable(INNORUUK)) or 0
		local rallos_variable = tonumber(eq.get_zone():GetVariable(RALLOSZEK)) or 0

		if (
			bertox_variable == 1 and
			cazic_variable == 1 and
			innoruuk_variable == 1 and
			rallos_variable == 1
		) then -- If all Phase 5 gods are dead
			local phase_variable = tonumber(eq.get_zone():GetVariable("Phase")) or 0
			eq.get_zone():SetVariable("Phase", "5")
			eq.spawn_condition("potimeb", instance_id, 11, 0)
			eq.spawn_condition("potimeb", instance_id, 12, 0)
			eq.spawn_condition("potimeb", instance_id, 13, 0)
			eq.spawn_condition("potimeb", instance_id, 14, 0)
			local quarm_variable = tonumber(eq.get_zone():GetVariable(QUARM)) or 0
			if quarm_variable == 0 or phase_variable < 6 then
				eq.get_zone():SetVariable("Current Phase", "Phase 6")
				-- sendsignal to flavor text NPC
				eq.signal(223227, 6) -- Emoter
				-- spawn Quarm
				eq.spawn2(223201, 0, 0, -401, -1106, 32.5, 185.625)
				-- spawn #A_Servitor_of_Peace
				eq.spawn2(223101, 0, 0, 244, -1106, -1.125, 194.0625)
				-- spawn untargetable Zebuxoruk's Cage
				eq.spawn2(223228, 0, 0, -579, -1119, 60.625, 0)
			end
		end	
	-- signal 7 comes from Quarm
	elseif e.signal == 7 then
		eq.get_zone():SetVariable("Current Phase", "Quarm Dead")
		eq.set_timer("lockout", 50 * 60 * 1000)
	end
end

function ResetVariables()
	eq.get_zone():SetVariable("Current Phase", "Phase 0")
	eq.get_zone():SetVariable("Counter", "0")
	eq.get_zone():SetVariable("Phase One Started", "0")
	instance_id = 0
	total_time = 0
end

function ResetSpawnConditions()
	instance_id = eq.get_zone_instance_id()
	-- reset all spawn conditions to 0 we want nothing up at zone boot or repop
	for i = 1, 14, 1 do
		eq.spawn_condition("potimeb", instance_id, i, 0)
	end
end

function ControlPhaseTwo()
	local expedition = eq.get_expedition()
	if expedition.valid then
		local phase_variable = tonumber(eq.get_zone():GetVariable("Phase")) or 0
		if phase_variable == 2 then
			eq.get_zone():SetVariable("Current Phase", "Phase 3")
			ControlPhaseThree()
			-- sendsignal to flavor text NPC
			eq.signal(223227, 3) -- Emoter
		end
	end
end

function SetupPhaseThree()
	eq.signal(223227, 3) -- Emoter
	ControlPhaseThree()
end

function SpawnPhaseThreeTrash(wave)
	for i, sp in ipairs(p3TrashSpawns) do
		eq.spawn2(p3TrashByWave[wave][math.random(#p3TrashByWave[wave])],0,0,sp.x, sp.y, sp.z, sp.h);	
	end
end

function ControlPhaseThree()
	instance_id = eq.get_zone_instance_id()
	local expedition = eq.get_expedition()
	local p3wave = tonumber(eq.get_zone():GetVariable("p3wave")) or 0
	--local event_counter = tonumber(eq.get_zone():GetVariable("P3Counter")) or 0
	locs = {[1] = {1250, 1085, 360}, [2] = {1250, 1135, 360} }
	if p3wave == 0 then
		--spawn phase 3
		SpawnPhaseThreeTrash(1);
		-- spawn the untargetable version of the phase 3 named
		eq.spawn2(223010, 0, 0, 1280, 1010, 359.38, 390) -- A_Needletusk_Warboar --
		eq.spawn2(223011, 0, 0, 1280, 1030, 359.38, 390) -- Deathbringer_Rianit --
		eq.spawn2(223012, 0, 0, 1260, 1250, 359.38, 390) -- Sinrunal_Gorgedreal --
		eq.spawn2(223013, 0, 0, 1260, 1270, 359.38, 390) -- Herlsoakian --
		eq.spawn2(223014, 0, 0, 1280, 1210, 359.38, 390) -- Xerskel_Gerodnsal --
		eq.spawn2(223015, 0, 0, 1280, 1190, 359.38, 390) -- Dersool_Fal`Giersnaol --
		eq.spawn2(223016, 0, 0, 1260, 970, 359.38, 390) -- Xeroan_Xi`Geruonask --
		eq.spawn2(223017, 0, 0, 1260, 950, 359.38, 390) -- Kraksmaal_Fir`Dethsin --
		eq.spawn2(223018, 0, 0, 1300, 1070, 359.38, 390) -- Dreamwarp --
		eq.spawn2(223019, 0, 0, 1300, 1090, 359.38, 390) -- Champion_of_Torment --
		eq.spawn2(223020, 0, 0, 1300, 1130, 359.38, 390) -- Dark_Knight_of_Terris --
		eq.spawn2(223021, 0, 0, 1300, 1150, 359.38, 390) -- Undead_Squad_Leader --
		eq.spawn2(223022, 0, 0, 1230, 1330, 359.38, 350) -- A_Deadly_Warboar --
		eq.spawn2(223023, 0, 0, 1230, 1310, 359.38, 350) -- Deathbringer_Skullsmash --
		eq.spawn2(223155, 0, 0, 1250, 1135, 359.5, 384) -- A_Ferocious_Warboar --
		eq.spawn2(223156, 0, 0, 1250, 1085, 359.5, 384) -- Deathbringer_Blackheart --
		eq.get_zone():SetVariable("p3wave", "1")
	elseif p3wave == 1 then
		if not eq.is_npc_spawned(p3TrashByWave[1]) then
			eq.get_zone():SetVariable("p3wave", "1.5")
			-- depop untargetable and pop targetable versions
			BossChange(223155, 223008, 1) -- A_Ferocious_Warboar
			BossChange(223156, 223009, 2) -- Deathbringer_Blackheart
		end
	elseif p3wave == 1.5 then
		-- This is expected to be hit twice, once per wave 1 boss
		if not eq.is_npc_spawned({ 223008, 223009 }) then
			-- Both wave 1 bosses are dead, spawn wave 2 trash
			eq.get_zone():SetVariable("p3wave", "2")
			-- spawn phase 3 wave 2 trash
			SpawnPhaseThreeTrash(2)
		end
	elseif p3wave == 2 then
		if not eq.is_npc_spawned(p3TrashByWave[2]) then
			eq.get_zone():SetVariable("p3wave", "2.5")
			-- depop untargetable and pop targetable versions
			BossChange(223017, 223024, 1) -- Kraksmaal_Fir`Dethsin
			BossChange(223016, 223025, 2) -- Xeroan_Xi`Geruonask
		end
	elseif p3wave == 2.5 then
		-- This is expected to be hit twice, once per wave 2 boss
		if not eq.is_npc_spawned({ 223024, 223025 }) then
			-- Both wave 2 bosses are dead, spawn wave 3 trash
			eq.get_zone():SetVariable("p3wave", "3")
			-- spawn phase 3 wave 3
			SpawnPhaseThreeTrash(3)
		end
	elseif p3wave == 3 then
		if not eq.is_npc_spawned(p3TrashByWave[3]) then
			eq.get_zone():SetVariable("p3wave", "3.5")
			-- Depop untargetable and pop targetable versions
			BossChange(223022, 223032, 1) -- A_Deadly_Warboar
			BossChange(223023, 223031, 2) -- Deathbringer_Skullsmash
		end
	elseif p3wave == 3.5 then
		-- This is expected to be hit twice, once per wave 3 boss
		if not eq.is_npc_spawned({ 223032, 223031 }) then
			-- Both wave 3 bosses are dead, spawn wave 4 trash
			eq.get_zone():SetVariable("p3wave", "4")
			-- spawn phase 3 wave 4
			SpawnPhaseThreeTrash(4)
		end
	elseif p3wave == 4 then
		if not eq.is_npc_spawned(p3TrashByWave[4]) then
			eq.get_zone():SetVariable("p3wave", "4.5")
			-- Depop untargetable and pop targetable versions
			BossChange(223012, 223038, 1) -- Sinrunal_Gorgedreal
			BossChange(223013, 223037, 2) -- Herlsoakian
		end
	elseif p3wave == 4.5 then
		-- This is expected to be hit twice, once per wave 4 boss
		if not eq.is_npc_spawned({ 223038, 223037 }) then
			-- Both wave 4 bosses are dead, spawn wave 5 trash
			eq.get_zone():SetVariable("p3wave", "5")
			-- spawn phase 3 wave 5
			SpawnPhaseThreeTrash(5)
		end
	elseif p3wave == 5 then
		if not eq.is_npc_spawned(p3TrashByWave[5]) then
			eq.get_zone():SetVariable("p3wave", "5.5")
			-- Depop untargetable and pop targetable versions
			BossChange(223011, 223046, 1) -- Deathbringer_Rianit
			BossChange(223010, 223047, 2) -- A_Needletusk_Warboar
		end
	elseif p3wave == 5.5 then
		-- This is expected to be hit twice, once per wave 5 boss
		if not eq.is_npc_spawned({ 223046, 223047 }) then
			-- Both wave 5 bosses are dead, spawn wave 6 trash
			eq.get_zone():SetVariable("p3wave", "6")
			-- spawn phase 3 wave 6
			SpawnPhaseThreeTrash(6)
		end
	elseif p3wave == 6 then
		if not eq.is_npc_spawned(p3TrashByWave[6]) then
			eq.get_zone():SetVariable("p3wave", "6.5")
			-- Depop untargetable and pop targetable versions
			BossChange(223014, 223051, 1) -- Xerskel_Gerodnsal
			BossChange(223015, 223050, 2) -- Dersool_Fal`Giersnaol
		end
	elseif p3wave == 6.5 then
		-- This is expected to be hit twice, once per wave 6 boss
		if not eq.is_npc_spawned({ 223051, 223050 }) then
			-- Both wave 6 bosses are dead, spawn wave 7 trash
			eq.get_zone():SetVariable("p3wave", "7")
			-- spawn phase 3 wave 7 trash
			SpawnPhaseThreeTrash(7);
		end
	elseif p3wave == 7 then
		if not eq.is_npc_spawned(p3TrashByWave[7]) then
			eq.get_zone():SetVariable("p3wave", "7.5")
			-- Depop untargetable and pop targetable versions
			BossChange(223021, 223057, 1) -- Undead_Squad_Leader
			BossChange(223020, 223058, 2) -- Dark_Knight_of_Terris
		end
	elseif p3wave == 7.5 then
		-- This is expected to be hit twice, once per wave 7 boss
		if not eq.is_npc_spawned({ 223057, 223058 }) then
			-- Both wave 7 bosses are dead, spawn wave 8 trash
			eq.get_zone():SetVariable("p3wave", "8")
			-- spawn phase 3 wave 8 trash
			SpawnPhaseThreeTrash(8);
		end
	elseif p3wave == 8 then
		if not eq.is_npc_spawned(p3TrashByWave[8]) then
			eq.get_zone():SetVariable("p3wave", "8.5")
			-- Depop untargetable and pop targetable versions
			BossChange(223019, 223065, 1) -- Champion_of_Torment
			BossChange(223018, 223066, 2) -- Dreamwarp
		end
	elseif p3wave == 8.5 then
		-- This is expected to be hit twice, once per wave 8 boss
		if not eq.is_npc_spawned({ 223065, 223066 }) then
			-- Both wave 8 bosses are dead, spawn golems
			eq.get_zone():SetVariable("p3wave", "9")
			eq.spawn2(223073, 0, 0, 1492, 1110, 374.1, 391) -- Avatar_of_the_Elements
			eq.spawn2(223074, 0, 0, 1563, 1110, 374.1, 391) -- Supernatural_Guardian
		end
	elseif p3wave == 9 then
		if not eq.is_npc_spawned({ 223073, 223074 }) then
			eq.get_zone():SetVariable("Phase", "3")
			local phase_variable = tonumber(eq.get_zone():GetVariable("Phase")) or 0
			eq.get_zone():SetVariable("Counter", "0")
			eq.stop_timer("p3unsticker")
			if expedition.valid and phase_variable == 3 then
				eq.get_zone():SetVariable("Current Phase", "Phase 4")
				-- sendsignal to flavor text NPC
				eq.signal(223227, 4) -- Emoter
				-- spawn phase 4
				SpawnPhaseFour()
			end
		end
	end
end

function BossChange(mob_id, targetable_id, num)
	old_boss = eq.get_entity_list():GetMobByNpcTypeID(mob_id)
	boss = eq.unique_spawn(targetable_id, 0, 0, old_boss:GetX(), old_boss:GetY(), old_boss:GetZ(), 385)
	boss:SetRunning(true)
	boss:CastToNPC():MoveTo(locs[num][1], locs[num][2], locs[num][3], 385, true)
	old_boss:Depop(false)
end

function SetupPhaseFour()
	eq.signal(223227, 4) -- Emoter
	SpawnPhaseFour()
end

function SpawnPhaseFour()
	local expedition = eq.get_expedition()

	local saryrn_variable = tonumber(eq.get_zone():GetVariable("Saryrn")) or 0
	local tallon_variable = tonumber(eq.get_zone():GetVariable("Tallon")) or 0
	local terris_variable = tonumber(eq.get_zone():GetVariable("Terris")) or 0
	local vallon_variable = tonumber(eq.get_zone():GetVariable("Vallon")) or 0

	if expedition.valid then
		if saryrn_variable == 0 and not eq.is_npc_spawned({223076}) then
			eq.spawn2(223076, 0, 0, -320, -316, 358, 65) -- Saryrn
		end

		if tallon_variable == 0 and not eq.is_npc_spawned({223077}) then
			eq.spawn2(223077, 0, 0, 405, -84, 358, 384) -- Tallon Zek
		end

		if terris_variable == 0 and not eq.is_npc_spawned({223075}) then
			eq.spawn2(223075, 0, 0, -310, 307, 365, 190) -- Terris Thule
		end

		if vallon_variable == 0 and not eq.is_npc_spawned({223078}) then
			eq.spawn2(223078, 0, 0, 405, 75, 358, 384) -- Vallon Zek
		end
	end
end

function SetupPhaseFive()
	eq.signal(223227, 5) -- Emoter
	SpawnPhaseFive()
end

function SpawnPhaseFive()
	instance_id = eq.get_zone_instance_id()
	local expedition = eq.get_expedition()

	local bertox_variable = tonumber(eq.get_zone():GetVariable(BERTOXXULOUOS)) or 0
	local cazic_variable = tonumber(eq.get_zone():GetVariable(CAZICTHULE)) or 0
	local innoruuk_variable = tonumber(eq.get_zone():GetVariable(INNORUUK)) or 0
	local rallos_variable = tonumber(eq.get_zone():GetVariable(RALLOSZEK)) or 0

	if expedition.valid then
		if bertox_variable == 0 and not eq.is_npc_spawned({223142}) then
			eq.spawn2(223142, 0, 0, -299, -297, 23.3, 62); -- Real Bertoxxulous - 223098 - swapped
		end

		if cazic_variable == 0 and not eq.is_npc_spawned({223166}) then
			eq.spawn2(223166, 0, 0, -257, 255, 6, 203); -- Real Cazic
		end
		
		if innoruuk_variable == 0 and not eq.is_npc_spawned({223167}) then
			eq.spawn2(223167, 0, 0, 303.3, 306, 13.3, 323) -- Real Innoruuk
		end
		
		if rallos_variable == 0 and not eq.is_npc_spawned({223168}) then
			eq.spawn2(223168, 0, 0, 264, -279, 18.75, 435) -- Real Rallos
		end
	end
end

function event_timer(e)
	if e.timer == "spawn" then
		eq.stop_timer("spawn")
		do_the_spawn(e)
	elseif e.timer == "p3unsticker" then
		ControlPhaseThree()
	end
end
