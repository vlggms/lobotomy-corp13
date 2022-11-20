/obj/structure/toolabnormality/touch
	name = "don't touch me"
	desc = "You feel like you shouldn't touch this."
	icon_state = "touch"
	var/cooldown
	var/list/bastards = list()
	var/list/breaching_bastards = list()

/obj/structure/toolabnormality/touch/examine(mob/user)
	. = ..()
	. += "<span class='info'>Pressing it while on help intent will breach all abnormalities instead of ending the shift.</span>"

//I had to.
/obj/structure/toolabnormality/touch/attack_hand(mob/living/carbon/human/user)
	if(cooldown > world.time)
		to_chat(user, "<span class='notice'>THE BUTTON CANNOT BE PRESSED RIGHT NOW.</span>")
		return

	var/round_end = (user.a_intent != INTENT_HELP)
	if((user.ckey in bastards) || (!round_end && (user.ckey in breaching_bastards)))
		to_chat(user, "<span class='userdanger'>THE BUTTON REJECTS YOU.</span>")
		return

	cooldown = world.time + 45 SECONDS // Spam prevention
	for(var/mob/M in GLOB.player_list)
		if(M.client)
			to_chat(M, "<span class='userdanger'>[uppertext(user.real_name)] WILL PUSH DON'T TOUCH ME[round_end ? "" : " TO BREACH ABNORMALITIES"].</span>")

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
				for(var/mob/living/carbon/human/M in GLOB.player_list)
					flash_color(M, flash_color = COLOR_RED, flash_time = 150)
					M.playsound_local(M, pick('sound/abnormalities/donttouch/kill.ogg', 'sound/abnormalities/donttouch/kill2.ogg'), 50, FALSE)
					M.gib()
			if(2)
				for(var/mob/living/carbon/human/M in GLOB.player_list)
					flash_color(M, flash_color = COLOR_RED, flash_time = 150)
					M.playsound_local(M, 'sound/abnormalities/donttouch/panic.ogg', 50, FALSE)
					M.apply_damage(5000, WHITE_DAMAGE, null, null, spread_damage = TRUE)//You cannot escape.
	else
		user.gib() //lol, idiot.

/obj/structure/toolabnormality/touch/proc/BreachEffect(mob/living/carbon/human/user)
	if(do_after(user, 45 SECONDS))
		breaching_bastards += user.ckey
		for(var/mob/living/carbon/human/M in GLOB.player_list)
			flash_color(M, flash_color = COLOR_RED, flash_time = 30)
			M.playsound_local(M, 'sound/abnormalities/donttouch/breach.ogg', 50, FALSE)
		for(var/datum/abnormality/A in SSlobotomy_corp.all_abnormality_datums)
			A.qliphoth_change(-A.qliphoth_meter) // Down to 0
