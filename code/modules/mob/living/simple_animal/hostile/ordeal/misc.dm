//Yeah so this midnight is supposed to be weak as shit.
/mob/living/simple_animal/hostile/ordeal/pink_midnight
	name = "A Party Everlasting"
	desc = "An overturned teacup, a party everlasting."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "party"
	icon_living = "party"
	faction = list("pink_midnight")
	pixel_x = -16
	base_pixel_x = -16
	maxHealth = 2000
	health = 2000
	melee_damage_type = PALE_DAMAGE
	armortype = PALE_DAMAGE
	rapid_melee = 2
	melee_damage_lower = 14
	melee_damage_upper = 14
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bashes"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	var/spawning = TRUE

/mob/living/simple_animal/hostile/ordeal/pink_midnight/Initialize()
	..()
	addtimer(CALLBACK(src, .proc/Breach_All), 5 SECONDS)

/mob/living/simple_animal/hostile/ordeal/pink_midnight/Move(atom/newloc, dir, step_x, step_y)
	if(spawning)
		return FALSE
	return ..()

	//Funny drags everything to it
/mob/living/simple_animal/hostile/ordeal/pink_midnight/proc/Breach_All()
	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.mob_list)
		//These two abnormalities kill everything else no matter what faction we set them to
		// But what if they don't have to?
		/*
		if(istype(A, /mob/living/simple_animal/hostile/abnormality/hatred_queen) || istype(A, /mob/living/simple_animal/hostile/abnormality/white_night))
			return
		*/
		if(A.pinkable && (A.status_flags & GODMODE))
			if(istype(A, /mob/living/simple_animal/hostile/abnormality/training_rabbit)) // Training Rabbit properly breaches
				var/mob/living/simple_animal/hostile/abnormality/training_rabbit/TR = A
				TR.pinked = TRUE
			if(istype(A, /mob/living/simple_animal/hostile/abnormality/scaredy_cat))
				var/mob/living/simple_animal/hostile/abnormality/scaredy_cat/SC = A
				SC.pinked = TRUE
			if(istype(A, /mob/living/simple_animal/hostile/abnormality/white_night))
				var/mob/living/simple_animal/hostile/abnormality/white_night/WN = A
				WN.pinked = TRUE
			if(istype(A, /mob/living/simple_animal/hostile/abnormality/hatred_queen))
				var/mob/living/simple_animal/hostile/abnormality/hatred_queen/HQ = A
				HQ.pinked = TRUE
			A.breach_effect()
			var/turf/orgin = get_turf(src)
			var/list/all_turfs = RANGE_TURFS(4, orgin)
			var/turf/open/Y = pick(all_turfs - orgin)
			if(!(A.status_flags & GODMODE))
				A.forceMove(Y)
			A.faction += "pink_midnight"
	spawning = FALSE
