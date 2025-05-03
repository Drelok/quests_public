-- PoTimeA/B

local expedition_info = {
    expedition = { name = "The Prison of the Forsaken", min_players = 1, max_players = 72 },
    instance   = { zone = "potimeb", version = 255, duration = 50400 }, -- 14 Hours
    safereturn = { zone = "potimea", x = -37, y = -110, z = 6.08, h = 0.0 },
    zonein     = { x = -9, y = -2466, z = -79, h = 0 }
}

function event_click_door(e)
	local door_id = e.door:GetDoorID()
	if door_id >= 8 and door_id <= 12 then
		e.self:Message(MT.Yellow, "The portal, dim at first, begins to glow brighter.")

		local expedition = e.self:GetExpedition()
		if expedition.valid then -- In a valid expedition
			local instance_id = tonumber(expedition:GetInstanceID()) or 0 -- Assign expedition Instance to Variable

			if instance_id == 0 then -- Found a expedition but did not find an instance
				e.self:Message(MT.Red, "Unable to find an instance but Expedition is valid, yell at a GM")
			end

			-- Expedition and instance are valid - Start the port query
			e.self:Message(MT.NPCQuestSay, "The portal flashes briefly, then glows steadily.")

			--local expedition_identifier = string.format("potime-%d-phase", expedition:GetID())
			--local phase_bucket = tonumber(eq.get_data(expedition_identifier)) or 0

			--handles porting player to specified area if raid is currently in Phase 3 or further
			--if phase_bucket == 2 then
			--	e.self:MovePCInstance(223, instance_id, 585, 1110, 496, 127)
			--	return
			--elseif phase_bucket == 3 then
			--	e.self:MovePCInstance(223, instance_id, -395, 0, 350, 127)
			--	return
			--elseif phase_bucket == 4 then
			--	e.self:MovePCInstance(223, instance_id, -410, 0, 5, 127)
			--	return
			--elseif phase_bucket == 5 then
			--	e.self:MovePCInstance(223, instance_id, 330, 0, 5, 127)
			--	return
			--end

			-- Phase 1/2
			if door_id > 7 and door_id < 13 then
				-- Move to potimeb graveyard
				e.self:MovePCInstance(223, instance_id, 851, -141, 396.06, 0)
				-- GetDoorID =  8 : Air Trial
				--e.self:MovePCInstance(223, instance_id, -36, 1352, 496, 124)
			--elseif door_id == 9 then
				-- GetDoorID =  9 : Water Trial
				--e.self:MovePCInstance(223, instance_id, -51, 857, 496, 124)
			--elseif door_id == 10 then
				-- GetDoorID = 10 : Earth Trial
				--e.self:MovePCInstance(223, instance_id, -35, 1636, 496, 124)
			--elseif door_id == 11 then
				-- GetDoorID = 11 : Fire Trial
				--e.self:MovePCInstance(223, instance_id, -55, 569, 496, 124)
			--elseif door_id == 12 then
				-- GetDoorID = 12 : Undead Trial
				--e.self:MovePCInstance(223, instance_id, -27, 1103, 496, 124)
			end
		else -- If not in an expedition, create one
			if not e.self:HasExpeditionLockout("The Prison of the Forsaken", "Plane of Time") then
				expedition = e.self:CreateExpedition(expedition_info)
				if expedition.valid then
					local instance_id = expedition:GetInstanceID()
					if instance_id == 0 then
						e.self:Message(MT.Red, "Instance failed to be created, yell at a GM")
						return
					end
					expedition:AddReplayLockout(60)
					--expedition:AddReplayLockout(14 * 60 * 60)

					local expedition_identifier = string.format("potime-%d-phase", expedition:GetID())
					eq.set_data(expedition_identifier, "0", "1M")
				end
			else
				e.self:Message(MT.Red, "You are currently locked out, try again once your lockout is over.")
			end
		end
	end
end
