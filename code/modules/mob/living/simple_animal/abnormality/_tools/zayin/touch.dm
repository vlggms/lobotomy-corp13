/obj/structure/toolabnormality/touch
	name = "don't touch me"
	desc = "You feel like you shouldn't touch this."
	icon_state = "touch"
	var/cooldown
	var/list/bastards = list()
	var/list/breaching_bastards = list()

/obj/structure/toolabnormality/touch/examine(mob/user)
	. = ..()
	. += span_info("Pressing it while on help intent will breach all abnormalities instead of ending the shift.")

//I had to.
/obj/structure/toolabnormality/touch/attack_hand(mob/living/carbon/human/user)
	if(cooldown > world.time)
		to_chat(user, span_notice("THE BUTTON CANNOT BE PRESSED RIGHT NOW."))
		return

	var/round_end = (user.a_intent != INTENT_HELP)
	if((user.ckey in bastards) || (!round_end && (user.ckey in breaching_bastards)) || (istype(user,/mob/living/carbon/human/species/pinocchio))) //If possible this istype check should be moved inside pinnochios code.
		to_chat(user, span_userdanger("THE BUTTON REJECTS YOU."))
		return

	cooldown = world.time + 45 SECONDS // Spam prevention
	for(var/mob/M in GLOB.player_list)
		to_chat(M, span_userdanger("[uppertext(user.real_name)] WILL PUSH DON'T TOUCH ME[round_end ? "" : " TO BREACH ABNORMALITIES"]."))

	if(round_end)
		RoundEndEffect(user)
	else
		BreachEffect(user)

/obj/structure/toolabnormality/touch/proc/RoundEndEffect(mob/living/carbon/human/user)
	bastards += user.ckey
	if(do_after(user, 45 SECONDS))
		SSticker.SetRoundEndSound('sound/abnormalities/donttouch/end.ogg')
		SSticker.force_ending = 1
		var/ending = pick(1,2)
		switch(ending)
			if(1)
				for(var/mob/M in GLOB.player_list)
					if(isnewplayer(M))
						continue
					flash_color(M, flash_color = COLOR_RED, flash_time = 150)
					M.playsound_local(M, pick('sound/abnormalities/donttouch/kill.ogg', 'sound/abnormalities/donttouch/kill2.ogg'), 50, FALSE)
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						H.gib()
			if(2)
				for(var/mob/M in GLOB.player_list)
					if(isnewplayer(M))
						continue
					flash_color(M, flash_color = COLOR_RED, flash_time = 150)
					M.playsound_local(M, 'sound/abnormalities/donttouch/panic.ogg', 50, FALSE)
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						H.apply_damage(5000, WHITE_DAMAGE, null, null, spread_damage = TRUE)//You cannot escape.
	else
		user.gib() //lol, idiot.

/obj/structure/toolabnormality/touch/proc/BreachEffect(mob/living/carbon/human/user)
	breaching_bastards += user.ckey
	if(do_after(user, 45 SECONDS))
		for(var/obj/structure/toolabnormality/clock/backclock in world.contents) //prevents an exploit
			backclock.clock_cooldown = backclock.clock_cooldown_time + world.time
		for(var/mob/M in GLOB.player_list)
			if(isnewplayer(M))
				continue
			flash_color(M, flash_color = COLOR_RED, flash_time = 30)
			M.playsound_local(M, 'sound/abnormalities/donttouch/breach.ogg', 50, FALSE)
		for(var/datum/abnormality/A in SSlobotomy_corp.all_abnormality_datums)
			A.qliphoth_change(-A.qliphoth_meter) // Down to 0
