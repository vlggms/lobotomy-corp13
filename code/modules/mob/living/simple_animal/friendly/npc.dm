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

/mob/living/simple_animal/npc/Life()
	. = ..()

/mob/living/simple_animal/npc/proc/LookForPlayer()
	pulse_cooldown = world.time + pulse_cooldown_time
	for(var/mob/living/carbon/human/L in livinginview(48, src)) //TODO: Make it check if the mobs have a mind, if they do, Start the speech.
		L.deal_damage(pulse_damage, RED_DAMAGE) //This is just from Firebird code.
		if(L.ckey) //If they have a soul, do the speech and then leave.
			Speech()
			Leave()

/mob/living/simple_animal/npc/proc/Speech()
	say("Hello")
	SLEEP_CHECK_DEATH(20)
	say("This is a test.")
	SLEEP_CHECK_DEATH(20)
	say("Goodbye")
	Leave()


/mob/living/simple_animal/npc/proc/Leave()
	icon_state = "priest_wings_open"
	playsound(holder_obj.loc, 'sound/abnormalities/crumbling/warning.ogg', vol = 50, vary = TRUE, extrarange = -3)
	animate(holder_obj, pixel_z = 1000, time = 5 SECONDS, flags = ANIMATION_RELATIVE)
	animate(holder_obj, alpha = 0, time = 1 SECONDS, flags = ANIMATION_RELATIVE)
	SLEEP_CHECK_DEATH(10)
	qdel()
