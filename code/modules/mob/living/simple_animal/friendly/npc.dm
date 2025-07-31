/mob/living/simple_animal/npc
	name = "npc"
	desc = "You should not be able to see this!"
	icon = 'ModularTegustation/Teguicons/teaser_mobs2.dmi'
	//'ModularTegustation/Teguicons/teaser_mobs.dmi'
	//'ModularTegustation/Teguicons/teaser_mobs2.dmi'
	//'ModularTegustation/Teguicons/resurgence_64x96.dmi'
	icon_state = "priest_wings_closed"
	icon_living = "priest_wings_closed"
	icon_dead = "none"
	faction = list("hostile")
	turns_per_move = 1
	maxHealth = 10000
	health = 10000
	move_resist = MOVE_FORCE_STRONG // They kept stealing my npcs
	pull_force = MOVE_FORCE_STRONG
	can_buckle_to = FALSE // Please. I beg you. Stop stealing my vending machines.
	mob_size = MOB_SIZE_HUGE // No more lockers, Whitaker
	density = TRUE
	damage_coeff = list(BRUTE = 0, RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)
	var/pulse_cooldown
	var/pulse_cooldown_time = 1 SECONDS
	var/speaking = FALSE
	var/default_delay = 15
	var/list/speech = list("Hello", "This is a test.", "Emote: Emote", "Move: NORTH", "Goodbye", "Delay: 20", "Icon: priest_wings_open")
	wander = FALSE

/mob/living/simple_animal/npc/Life()
	. = ..()
	if(!. || speaking) // Dead
		return FALSE
	if(pulse_cooldown < world.time)
		LookForPlayer()

/mob/living/simple_animal/npc/proc/LookForPlayer()
	pulse_cooldown = world.time + pulse_cooldown_time
	for(var/mob/living/carbon/human/L in livinginview(5, src)) //TODO: Make it check if the mobs have a mind, if they do, Start the speech.
		if(L.ckey) //If they have a soul, do the speech and then leave.
			speaking = TRUE
			Speech()
			Leave()

/mob/living/simple_animal/npc/proc/Speech()
	for (var/S in speech)
		if (findtext(S, "Emote: ") == 1)
			manual_emote(copytext(S, 8, length(S) + 1))
		else if (findtext(S, "Move: ") == 1)
			step(src, text2dir(copytext(S, 7, length(S) + 1)))
		else if (findtext(S, "Icon: ") == 1)
			icon_state = copytext(S, 7, length(S) + 1)
		else if (findtext(S, "Delay: ") == 1)
			SLEEP_CHECK_DEATH(text2num(copytext(S, 8, length(S) + 1)))
		else
			say(S)
		SLEEP_CHECK_DEATH(default_delay)


/mob/living/simple_animal/npc/proc/Leave()
	animate(src, pixel_x = 100, time = 5 SECONDS, flags = ANIMATION_RELATIVE)
	animate(src, alpha = 0, time = 2 SECONDS)
	SLEEP_CHECK_DEATH(20)
	qdel(src)

/mob/living/simple_animal/npc/priest
	name = "Redeemed Star"
	desc = "Too young to be called a man, but too mature to be called a boy. He had white hair and white skin. His eyes are calm and he had stubborn lips."
	icon = 'ModularTegustation/Teguicons/teaser_mobs.dmi'
	icon_state = "priest"
	icon_living = "priest"
	icon_dead = "none"
	speech = list("Well, Well!", "I never expected guests around this time.", "Emote: bows", "You may call me the Redeemed Star, a humble priest.", "Feel free to rest here, As the church of the galaxy is open to all.", "Delay: 20")
	default_delay = 30

/mob/living/simple_animal/npc/priest/Leave()
	manual_emote("wings grow out of their back")
	icon = 'ModularTegustation/Teguicons/teaser_mobs2.dmi'
	pixel_x = -7
	icon_state = "priest_wings_closed"
	SLEEP_CHECK_DEATH(20)
	say("Now, Please give me a moment to check on the surrounding area.")
	animate(src, pixel_z = 5, time = 1 SECONDS, flags = ANIMATION_RELATIVE)
	SLEEP_CHECK_DEATH(10)
	animate(src, pixel_z = -5, time = 1 SECONDS, flags = ANIMATION_RELATIVE)
	SLEEP_CHECK_DEATH(10)
	animate(src, pixel_z = 5, time = 1 SECONDS, flags = ANIMATION_RELATIVE)
	SLEEP_CHECK_DEATH(10)
	animate(src, pixel_z = -5, time = 1 SECONDS, flags = ANIMATION_RELATIVE)
	SLEEP_CHECK_DEATH(10)
	playsound(loc, 'sound/abnormalities/crumbling/warning.ogg', vol = 75, vary = TRUE, extrarange = -3)
	animate(src, pixel_z = 300, time = 5 SECONDS, flags = ANIMATION_RELATIVE)
	animate(src, alpha = 0, time = 1 SECONDS)
	SLEEP_CHECK_DEATH(10)
	qdel(src)

/mob/living/simple_animal/npc/electic
	name = "Amber Knight"
	desc = "Feminine guy, dressed in mainly black with neon accents, with bright amber eyes."
	icon = 'ModularTegustation/Teguicons/teaser_mobs.dmi'
	icon_state = "electic"
	icon_living = "electic"
	icon_dead = "none"
	speech = list("Oh! Another comrade has arived!", "I have been clearing out this area of those filthy sweepers!", "Emote: wipes their daggers clean", "You may call me the Amber Knight, Noblest of Knights!", "Now with your presence here, may I trust you finish clearing up this area?", "Only a few sweepers remain here, So they should be no problem.")
	default_delay = 30

/mob/living/simple_animal/npc/electic/Leave()
	manual_emote("steps back and forth")
	animate(src, pixel_x = 5, time = 1 SECONDS, flags = ANIMATION_RELATIVE)
	dir = 4
	SLEEP_CHECK_DEATH(10)
	animate(src, pixel_x = -10, time = 1 SECONDS, flags = ANIMATION_RELATIVE)
	say("I still have other errands to run!")
	dir = 8
	SLEEP_CHECK_DEATH(10)
	animate(src, pixel_x = 10, time = 1 SECONDS, flags = ANIMATION_RELATIVE)
	dir = 4
	SLEEP_CHECK_DEATH(10)
	animate(src, pixel_x = -10, time = 1 SECONDS, flags = ANIMATION_RELATIVE)
	say("Aser-, The Sanguine Flame must be wating for me!")
	dir = 8
	SLEEP_CHECK_DEATH(10)
	new /obj/effect/temp_visual/dir_setting/ninja/phase/out (get_turf(src))
	playsound(src, 'sound/effects/contractorbatonhit.ogg', 100, FALSE, 9)
	qdel(src)

/mob/living/simple_animal/npc/tinkerer
	name = "'Tinkerer'"
	desc = "A machine which is hanging from the ceiling, You can feel it's red eye gaze upon you..."
	icon = 'ModularTegustation/Teguicons/resurgence_64x96.dmi'
	icon_state = "none"
	icon_living = "none"
	icon_dead = "none"
	turns_per_move = 1
	default_delay = 13
	speech = list("Icon: tinker_d", "Icon: tinker", "Delay: 22", "Icon: tinker_u")
	speech_span = SPAN_ROBOT
	pixel_x = -16
	base_pixel_x = -16

/mob/living/simple_animal/npc/tinkerer/Life()
	. = ..()
	if(!.)
		return FALSE
	AwardTinkererAchievement() // Always check for new players to award achievement
	if(!speaking && pulse_cooldown < world.time)
		LookForPlayer() // Only trigger speech if not already speaking

/mob/living/simple_animal/npc/tinkerer/proc/AwardTinkererAchievement()
	for(var/mob/living/carbon/human/L in livinginview(5, src))
		if(L.ckey && L.client)
			L.client.give_award(/datum/award/achievement/lc13/city/tinkerer_encounter, L)

/mob/living/simple_animal/npc/tinkerer/Move()
	return FALSE

/mob/living/simple_animal/npc/tinkerer/Leave()
	qdel(src)

/mob/living/simple_animal/npc/tinkerer_speech
	name = "'Tinkerer'"
	desc = "A machine which is hanging from the ceiling, You can feel it's red eye gaze upon you..."
	icon = 'ModularTegustation/Teguicons/resurgence_64x96.dmi'
	icon_state = "none"
	icon_living = "none"
	icon_dead = "none"
	turns_per_move = 1
	default_delay = 13
	speech = list("Icon: tinker_d", "Icon: tinker", "What strange traveler...", "Delay: 22", "Entering my hideout, and slaying my guards...", "Delay: 22", "That is quite rude, I would say.", "Delay: 22", "To do to someone who is trying to fix the City...", "Delay: 22", "But, Humans will always be humans. Slaying anything they don't understand...", "Delay: 22", "Yet, Worry not as I can forgive.", "Delay: 22", "I understand the cruel nature of humanity, It's desire for ruin...", "Delay: 22", "For that reason, I promise...", "Delay: 22", "...I will fix you...")
	speech_span = SPAN_ROBOT
	pixel_x = -16
	base_pixel_x = -16

/mob/living/simple_animal/npc/tinkerer_speech/Life()
	. = ..()
	if(!.)
		return FALSE
	AwardTinkererAchievement() // Always check for new players to award achievement
	if(!speaking && pulse_cooldown < world.time)
		LookForPlayer() // Only trigger speech if not already speaking

/mob/living/simple_animal/npc/tinkerer_speech/proc/AwardTinkererAchievement()
	for(var/mob/living/carbon/human/L in view(5, src))
		if(L.ckey && L.client)
			L.client.give_award(/datum/award/achievement/lc13/city/tinkerer_encounter, L)

/mob/living/simple_animal/npc/tinkerer_speech/Move()
	return FALSE

/mob/living/simple_animal/npc/tinkerer_speech/Leave()
	icon_state = "tinker_u"
	manual_emote("drops a small tape and a screwdriver on the ground...")
	new /obj/item/tape/resurgence/temple_of_motus (get_turf(src))
	new /obj/item/screwdriver (get_turf(src))
	SLEEP_CHECK_DEATH(15)
	qdel(src)

/mob/living/simple_animal/npc/archsage
	name = "Arch Sage"
	desc = "A strange figure wearing a white dress..."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "archsage"
	icon_living = "archsage"
	icon_dead = "archsage"
	turns_per_move = 1
	speech = list("...", "It appears you are approaching him...", "Emote: gazes at the ash rocks", "If you press on, you will find a man who is far gone...", "Broken by their decision...", "To survive this harrowing, collapse...", "At the cost of their beloved...", "Delay: 10", "Now, You are the judge of his fate...", "Will you follow his pleads to end his story...", "Or will you leave him here, to let him melt in their own grief...", "The choice, is yours...")
	default_delay = 30
	pixel_x = -8
	base_pixel_x = -8

/mob/living/simple_animal/npc/archsage/Leave()
	manual_emote("slowly starts fading away...")
	animate(src, alpha = 0, time = 2 SECONDS)
	SLEEP_CHECK_DEATH(20)
	qdel(src)

/mob/living/simple_animal/npc/joey
	name = "Misguiding Light"
	desc = "A figure holding a lantern, his light is blinding."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "lantern"
	icon_living = "lantern"
	icon_dead = "lantern"
	turns_per_move = 1
	speech = list("Emote: looks up, at their visitors", "I knew it would come eventually...", "I can't stay hidding away like this...", "I can't live this life, at peace...", "Not after what I did to her...", "Delay: 20", "Please...", "Delay: 10", "Just end me here, Only then I might just be able to see her...", "For one last time...")
	default_delay = 30
	light_color = COLOR_YELLOW
	light_range = 5
	light_power = 7

/mob/living/simple_animal/npc/joey/Leave()
	manual_emote("falls on their knees, opening themselves to a fatal blow...")
	maxHealth = 1
	health = 1
	ChangeResistances(list(BRUIT = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1))
	SLEEP_CHECK_DEATH(100)
	say("Are you not, Going to end me?")
	SLEEP_CHECK_DEATH(20)
	say("Then... I shall make things right...")
	SLEEP_CHECK_DEATH(10)
	manual_emote("slowly stands up...")
	ChangeResistances(list(BRUIT = 0, RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))
	SLEEP_CHECK_DEATH(20)
	say("Please, Forgive me... Marisa...")
	SLEEP_CHECK_DEATH(20)
	new /mob/living/simple_animal/hostile/distortion/lantern (get_turf(src))
	qdel(src)

/mob/living/simple_animal/npc/joey/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 15 SECONDS)
	QDEL_IN(src, 15 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(TalkAfterDeath)), 5)
	..()

/mob/living/simple_animal/npc/joey/proc/TalkAfterDeath()
	var/mob/living/carbon/human/dummy/D = new /mob/living/carbon/human/dummy(get_turf(src))
	D.name = "Misguiding Light"
	D.alpha = 0
	D.manual_emote("crumbles to the floor...")
	sleep(40)
	D.say("Marisa... Can you forgive me?")
	sleep(40)
	D.manual_emote("drops a single tear, as it falls from their face...")
	sleep(50)
	D.manual_emote("drops a small letter, right before they disappear...")
	new /obj/item/paper/fluff/joey/letter (get_turf(src))
	sleep(20)
	qdel(D)


/obj/effect/landmark/npc_reveal_sensor
	name = "NPC Reveal Sensor"
	var/sensor_id = "1"
	var/cooldown
	var/cooldown_duration = 5 SECONDS

/obj/effect/landmark/npc_reveal_sensor/Crossed(atom/movable/AM)
	. = ..()
	if (isliving(AM) && cooldown < world.time)
		var/mob/living/L = AM
		if (L.ckey)
			for(var/obj/effect/landmark/npc_reveal_spawn/S in GLOB.landmarks_list)
				if(S.sensor_id == sensor_id)
					//spawn NPC
					new S.mobtype(get_turf(S))
					cooldown = world.time + cooldown_duration



/obj/effect/landmark/npc_reveal_spawn
	name = "NPC Reveal Spawn"
	var/sensor_id = "1"
	var/mobtype = /mob/living/simple_animal/npc


