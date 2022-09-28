/obj/structure/toolabnormality/touch
	name = "don't touch me"
	desc = "You feel like you shouldn't touch this."
	icon_state = "touch"
	var/list/bastards = list()

//I had to.
/obj/structure/toolabnormality/touch/attack_hand(mob/living/carbon/human/user)
	if(user.ckey in bastards)
		to_chat(user, "<span class='userdanger'>THE BUTTON REJECTS YOU.</span>")
		user.gib()

	bastards += user.ckey
	for(var/mob/M in GLOB.player_list)
		if(M.z == z && M.client)
			to_chat(M, "<span class='userdanger'>[user] WILL PUSH DON'T TOUCH ME.</span>")

	if(do_after(user, 45 SECONDS))
		SSticker.force_ending = 1
		var/ending = pick(1,2)
		switch(ending)
			if(1)
				for(var/mob/living/carbon/human/M in GLOB.player_list)
					M.gib()
			if(2)
				for(var/mob/living/carbon/human/M in GLOB.player_list)
					M.apply_damage(5000, WHITE_DAMAGE, null, null, spread_damage = TRUE)//You cannot escape.
	else
		user.gib() //lol, idiot.
