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
	turns_per_move = 1
	maxHealth = 10000
	health = 10000
	density = TRUE
	damage_coeff = list(BRUTE = 0, RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)
	var/pulse_cooldown
	var/pulse_cooldown_time = 1 SECONDS
	var/speaking = FALSE
	var/speech = list("Hello", "This is a test.", "Emote: Emote","Goodbye")


/mob/living/simple_animal/npc/Initialize()


/mob/living/simple_animal/npc/Move()
	return FALSE

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
		else
			say(S)
		SLEEP_CHECK_DEATH(20)


/mob/living/simple_animal/npc/proc/Leave()
	icon_state = "priest_wings_open"
	playsound(loc, 'sound/abnormalities/crumbling/warning.ogg', vol = 50, vary = TRUE, extrarange = -3)
	animate(src, pixel_z = 100, time = 5 SECONDS, flags = ANIMATION_RELATIVE)
	animate(src, alpha = 0, time = 1 SECONDS)
	SLEEP_CHECK_DEATH(10)
	qdel(src)


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
					new /mob/living/simple_animal/npc(get_turf(S))
					cooldown = world.time + cooldown_duration



/obj/effect/landmark/npc_reveal_spawn
	name = "NPC Reveal Spawn"
	var/sensor_id = "1"


