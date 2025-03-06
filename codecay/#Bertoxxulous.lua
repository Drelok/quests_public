function event_death_complete(e)
	eq.spawn2(218068, 0, 0, e.self:GetX(), e.self:Get(), e.self:GetZ() + 10, e.self:GetHeading()) -- A Planar Projection
end

function event_killed_merit(e)
	local bertox_bucket = tonumber(e.other:GetAccountBucket("pop.flags.bertox")) or 0
	if bertox_bucket == 0 then
		e.other:SetAccountBucket("pop.flags.bertox", "1")
		e.other:Message(MT.LightBlue, "You receive a character flag!")
	end
end