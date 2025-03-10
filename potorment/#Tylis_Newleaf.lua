function event_spawn(e)
	eq.set_timer("Depop", 1200 * 1000) -- 20 Minutes
end

function event_timer(e)
	if e.timer == "Depop" then
		eq.stop_timer("Depop")
		eq.depop()
	end
end

function event_say(e)
	if e.message:findi("Hail") then
		local newleaf_bucket = tonumber(e.other:GetAccountBucket("pop.flags.newleaf")) or 0
		if newleaf_bucket == 0 then
			local ready_link  = eq.silent_say_link("ready")
			e.self:Say(
				string.format(
					"I must thank you for your kind efforts friends. This place has laid claim to me for far too long. Please take care and offer the dark wench my best. I am off... and I suggest you not stray to far from that route yourselves. Please tell me when you are [%s] to return and may your blades strike true!",
					ready_link
				)
			)
			e.other:SetAccountBucket("pop.flags.newleaf", "1")
			e.other:Message(MT.LightBlue, "You receive a character flag!")
		else
			e.self:Say("It looks like we've already spoken.")
		end
	elseif e.message:findi("ready") then
		e.other:Message(MT.LightBlue, "Your tormented visions have ended.")
		e.other:MovePCInstance(207, eq.get_zone_instance_id(), -16, -49, 452, 0)
	end
end
