function event_death_complete(e)
	eq.spawn2(222015, 0, 0, e.self:GetX(), e.self:GetY(), e.self:GetZ(), e.self:GetHeading()); -- #Essence_of_Earth
end

function event_killed_merit(e)
	local rathe_bucket = tonumber(e.other:GetAccountBucket("pop.flags.rathe")) or 0
	if rathe_bucket == 0 then
		e.other:SummonItem(29146) -- Item: Mound of Living Stone
		e.other:SetAccountBucket("pop.flags.rathe", "1")
		e.other:Message(MT.LightBlue, "You receive a character flag!")
	end
end
