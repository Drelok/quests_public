function event_say(e)
	local flags = {
		hedge = {
			set_message = "You have spoken to Jezith within the Plane of Tranquility for the Hedge preflag by saying tormented by nightmares.",
			unset_message = "You have NOT spoken to Jezith within the Plane of Tranquility for the Hedge preflag by saying tormented by nightmares."
		},
		construct = {
			set_message = "You have killed the Construct of Nightmares.",
			unset_message = "You have NOT killed the Construct of Nightmares."
		},
		terris = {
			set_message = "You have killed Terris Thule.",
			unset_message = "You have NOT killed Terris Thule."
		},
		poxbourne = {
			set_message = "You have talked to Poxbourne in the Plane of Tranquility after defeating Terris Thule.",
			unset_message = "You have NOT talked to Poxbourne in the Plane of Tranquility after defeating Terris Thule."
		},
		xanamech = {
			set_message = "You have killed the dragon within the Plane of Innovation.",
			unset_message = "You have NOT killed the dragon within the Plane of Innovation."
		},
		behemoth = {
			set_message = "You have talked to the Gnome within the Plane of Innovation factory.",
			unset_message = "You have NOT talked to the Gnome within the Plane of Innovation factory."
		},
		behemoth = {
			required = 2,
			set_message = "You have defeated the Behemoth within the Plane of Innovation and then QUICKLY hailed the Gnome in the factory.",
			unset_message = "You have NOT defeated the Behemoth within the Plane of Innovation and then QUICKLY hailed the Gnome in the factory."
		},
		adler = {
			set_message = "You have talked to Adler Fuirstel outside of the Plane of Disease.",
			unset_message = "You have NOT talked to Adler Fuirstel outside of the Plane of Disease."
		},
		grummus = {
			set_message = "You have defeated Grummus.",
			unset_message = "You have NOT defeated Grummus."
		},
		elder = {
			set_message = "You have talked to Elder Fuirstel in the Plane of Tranquility.",
			unset_message = "You have NOT talked to Elder Fuirstel in the Plane of Tranquility."
		},
		mavuin = {
			set_message = "You have talked to Mavuin, and have agreed to plea his case to The Tribunal.",
			unset_message = "You have NOT talked to Mavuin, and agreed to plea his case to The Tribunal."
		},
		tribunal = {
			set_message = "You have shown the Tribunal the mark from the trial you have completed.",
			unset_message = "You have NOT shown the Tribunal the mark from the trial you have completed."
		},
		valor = {
			set_message = "You have returned to Mavuin, letting him know the tribunal will hear his case.",
			unset_message = "You have NOT returned to Mavuin to tell him the tribunal will hear his case."
		},
		execution = {
			set_message = "You have completed the Trial of Execution.",
			unset_message = "You have NOT completed the Trial of Execution."
		},
		flame = {
			set_message = "You have completed the Trial of Flame.",
			unset_message = "You have NOT completed the Trial of Flame."
		},
		hanging = {
			set_message = "You have completed the Trial of Hanging.",
			unset_message = "You have NOT completed the Trial of Hanging."
		},
		lashing = {
			set_message = "You have completed the Trial of Lashing.",
			unset_message = "You have NOT completed the Trial of Lashing."
		},
		stoning = {
			set_message = "You have completed the Trial of Stoning.",
			unset_message = "You have NOT completed the Trial of Stoning."
		},
		torture = {
			set_message = "You have completed the Trial of Torture.",
			unset_message = "You have NOT completed the Trial of Torture."
		},
		aerin = {
			set_message = "You have defeated the prismatic dragon, Aerin`Dar, within the Plane of Valor.",
			unset_message = "You have NOT defeated the prismatic dragon, Aerin`Dar, within the Plane of Valor."
		},
		askr = {
			set_message = "You have completed part one of Askr's task within the Plane of Storms.",
			unset_message = "You have NOT completed part one of Askr's task within the Plane of Storms.",
			required_value = 3
		},
		askr = {
			set_message = "You have killed the giants within the Plane of Storms and completed Askr's task.",
			unset_message = "You have NOT killed the giants within the Plane of Storms to complete Askr's task.",
			required_value = 4
		},
		codecay = {
			set_message = "You have completed the Carprin cycle within Ruins of Lxanvom.",
			unset_message = "You have NOT completed the Carprin Cycle within Ruins of Laxanvom."
		},
		bertox = {
			set_message = "You have killed Bertox and hailed the planar projection.",
			unset_message = "You have NOT killed Bertox and hailed the planar projection."
		},
		codecay = {
			set_message = "You have killed Bertox and talked to Adler Fuirstel.",
			unset_message = "You have NOT talked to Adler Fuirstel after killing Bertox.",
			required_value = 2
		},
		shadyglade = {
			set_message = "You have talked to Shadyglade within the Plane of Tranquility.",
			unset_message = "You have NOT talked to Shadyglade within the Plane of Tranquility."
		},
		newleaf = {
			set_message = "You have killed the Keeper of Sorrows.",
			unset_message = "You have NOT killed the Keeper of Sorrows."
		},
		saryrn = {
			set_message = "You have killed Saryrn and hailed the planar projection.",
			unset_message = "You have NOT killed Saryrn and hailed the planar projection."
		},
		saryrn = {
			set_message = "You have killed Saryrn, hailed the planar projection, and then talked to Shadyglade once more.",
			unset_message = "You have NOT talked to Shadyglade after killing Saryrn.",
			required_value = 2
		},
		faye = {
			set_message = "You have completed the Halls of Honor trial given by Faye.",
			unset_message = "You have NOT completed the Halls of Honor trial given by Faye."
		},
		trell = {
			set_message = "You have completed the Halls of Honor trial given by Rhaliq Trell.",
			unset_message = "You have NOT completed the Halls of Honor trial given by Rhaliq Trell."
		},
		garn = {
			set_message = "You have completed the Halls of Honor trial given by Alekson Garn.",
			unset_message = "You have NOT completed the Halls of Honor trial given by Alekson Garn."
		},
		marr = {
			set_message = "You have defeated Lord Marr within his temple.",
			unset_message = "You have NOT defeated Lord Marr within his Temple."
		},
		agnarr = {
			set_message = "You have defeated Agnarr, the Storm Lord.",
			unset_message = "You have NOT defeated Agnarr, the Storm Lord."
		},
		tallon = {
			set_message = "You have killed Tallon Zek.",
			unset_message = "You have NOT killed Tallon Zek."
		},
		vallon = {
			set_message = "You have killed Vallon Zek.",
			unset_message = "You have NOT killed Vallon Zek."
		},
		rallos = {
			set_message = "You have killed Rallos Zek the Warlord.",
			unset_message = "You have NOT killed Rallos Zek the Warlord."
		},
		librarian = {
			set_message = "You have spoken with the grand librarian to receive access to the Elemental Planes.",
			unset_message = "You have NOT spoken with the grand librarian to receive access to the Elemental Planes."
		},
		arlyxir = {
			set_message = "You have defeated Arlyxir within the Tower of Solusek Ro.",
			unset_message = "You have NOT defeated Arlyxir within the Tower of Solusek Ro."
		},
		dresolik = {
			set_message = "You have defeated The Protector of Dresolik within the Tower of Solusek Ro.",
			unset_message = "You have NOT defeated The Protector of Dresolik within the Tower of Solusek Ro."
		},
		jiva = {
			set_message = "You have defeated Jiva within the Tower of Solusek Ro.",
			unset_message = "You have NOT defeated Jiva within the Tower of Solusek Ro."
		},
		rizlona = {
			set_message = "You have defeated Rizlona within the Tower of Solusek Ro.",
			unset_message = "You have NOT defeated Rizlona within the Tower of Solusek Ro."
		},
		xuzl = {
			set_message = "You have defeated Xuzl within the Tower of Solusek Ro.",
			unset_message = "You have NOT defeated Xuzl within the Tower of Solusek Ro."
		},
		solusek = {
			set_message = "You have defeated Solusek Ro within his own tower.",
			unset_message = "You have NOT defeated Solusek Ro within the Tower of Solusek Ro."
		},
		fennin = {
			set_message = "You have defeated Fennin Ro, the Tyrant of Fire.",
			unset_message = "You have NOT defeated Fennin Ro, the Tyrant of Fire."
		},
		xegony = {
			set_message = "You have defeated Xegony, the Queen of Air.",
			unset_message = "You have NOT defeated Xegony, the Queen of Air."
		},
		coirnav = {
			set_message = "You have defeated Coirnav, the Avatar of Water.",
			unset_message = "You have NOT defeated Coirnav, the Avatar of Water."
		},
		arbitor = {
			set_message = "You have defeated the arbitor within Plane of Earth A.",
			unset_message = "You have NOT defeated the Arbitor of Earth within Plane of Earth A."
		},
		rathe = {
			set_message = "You have defeated the Rathe Council within Plane of Earth B.",
			unset_message = "You have NOT defeated the Rathe Council within Plane of Earth B."
		},
		maelin = {
			set_message = "You have completed the Plane of Time flag.",
			unset_message = "You have NOT completed your Plane of Time flag."
		}
	}

	for key, data in pairs(flags) do
		local bucket_value = tonumber(e.other:GetAccountBucket(key)) or 0
		local required_value = data.required_value or 1

		if bucket_value == required_value then
			e.other:Message(MT.Tell, data.set_message)
		else
			e.other:Message(MT.Tell, data.unset_message)
		end
	end
end