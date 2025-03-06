function event_death_complete(e)
	eq.spawn2(202368,0,0,2380,-2,444,387); -- NPC: A_Planar_Projection
	eq.depop_with_timer(220016); -- depop the trigger
end

function event_killed_merit(e)
	local marr_bucket = tonumber(e.other:GetAccountBucket("pop.flags.marr")) or 0
	if marr_bucket == 0 then
		e.other:SetAccountBucket("pop.flags.marr", "1")
		e.other:Message(MT.LightBlue, "You receive a character flag!")
	end
end