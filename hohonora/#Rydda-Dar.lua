function event_spawn(e)
	eq.set_timer("Spawn", 120 * 60 * 1000) -- 2 Hours
end

function event_timer(e)
	if e.timer == "Spawn" then
		eq.stop_timer("Spawn")
		eq.update_spawn_timer(44017, 1440 * 60 * 1000) -- 1 Day
		eq.depop()
	end
end

function event_death_complete(e)
	eq.spawn2(218068, 0, 0, e.self:GetX(), e.self:GetY(), e.self:GetZ(), e.self:GetHeading()) -- #A_Planar_Projection
	eq.update_spawn_timer(44017, 4320 * 60 * 1000) -- 3 Days
end

function event_killed_merit(e)
	local faye_bucket = tonumber(e.other:GetAccountBucket("pop.flags.faye")) or 0
	if faye_bucket == 0 then
		e.other:SetAccountBucket("pop.flags.faye", "1")
		e.other:Message(MT.LightBlue, "You receive a character flag!")
	end
end
