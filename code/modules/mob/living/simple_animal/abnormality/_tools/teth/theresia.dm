//Coded by InsightfulParasite
/obj/structure/toolabnormality/theresia
	name = "windup music box"
	desc = "An old ornate music box with a ballerina ontop. Carved onto the side of the music box is the phrase 'Do you remember this melody? The professor used to play this song when the students were sleepy. Happy birthday.'"
	icon_state = "theresia"
	var/icon_active = "theresia_active"
	var/activated = 0
	var/song_cooldown
	var/song_cooldown_time = 10 SECONDS
	var/maxwinds = 6
	var/currentwinds = 1
	var/pulse_damage = 10

/obj/structure/toolabnormality/theresia/attack_hand(mob/user) //defines activator as user.
	if(activated == 1) //turnoff
		activated = 0
		currentwinds = 1
		icon_state = initial(icon_state)
		to_chat(user, "<span class='notice'>You deactivate the [src].</span>")
		visible_message("<span class='hear'>The calming music stops.</span>")
		playsound(get_turf(src), 'sound/effects/clock_tick.ogg', 50, 0, 4)
		STOP_PROCESSING(SSobj,src)
	else //turnon
		activated = 1
		icon_state = icon_active
		to_chat(user, "<span class='notice'>You begin to wind up [src].</span>")
		visible_message("<span class='hear'>[user] begins to wind up the [src].</span>") //user refers to the operator src refers to the item.
		START_PROCESSING(SSobj, src)
		playsound(get_turf(src), 'sound/effects/ordeals/pink_start.ogg', 50, 0, 4)
	update_icon()
	add_fingerprint(user)

/obj/structure/toolabnormality/theresia/process()
	if(activated == 1)
		if(currentwinds >= 7)
			song_cooldown = world.time + song_cooldown_time
			playsound(get_turf(src), 'sound/machines/clockcult/ark_scream.ogg', 50, 0, 4)
			new /obj/effect/temp_visual/fragment_song(get_turf(src))
			for(var/mob/living/M in range(80, get_turf(src)))
				M.apply_damage(pulse_damage, WHITE_DAMAGE, null, M.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
			activated = 0
		else
			song_cooldown = world.time + song_cooldown_time
			for(var/mob/living/carbon/human/L in range(7, get_turf(src)))
				if(L.stat == DEAD)
					continue
				L.adjustSanityLoss(pulse_damage)
			if(prob(10))
				visible_message("<span class='hear'>Despite the challenge, something reassures you that things will be okay.</span>")
		currentwinds = (currentwinds + 1)
