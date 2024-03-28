//Yeah so this midnight is supposed to be weak as shit.
/mob/living/simple_animal/hostile/ordeal/pink_midnight
	name = "A Party Everlasting"
	desc = "An overturned teacup, a party everlasting."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "party"
	icon_living = "party"
	faction = list("pink_midnight")
	layer = LARGE_MOB_LAYER
	pixel_x = -16
	base_pixel_x = -16
	maxHealth = 2000
	health = 2000
	melee_damage_type = PALE_DAMAGE
	rapid_melee = 2
	melee_damage_lower = 14
	melee_damage_upper = 14
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bashes"
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)

	var/list/blacklist = list(/mob/living/simple_animal/hostile/abnormality/melting_love,
				/mob/living/simple_animal/hostile/abnormality/distortedform,
				/mob/living/simple_animal/hostile/abnormality/white_night,
				/mob/living/simple_animal/hostile/abnormality/hatred_queen,
				/mob/living/simple_animal/hostile/abnormality/wrath_servant)


/mob/living/simple_animal/hostile/ordeal/pink_midnight/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(Breach_All)), 5 SECONDS)

/mob/living/simple_animal/hostile/ordeal/pink_midnight/death(gibbed)
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

//Funny drags everything to it
/mob/living/simple_animal/hostile/ordeal/pink_midnight/proc/Breach_All()
	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list)
		//These two abnormalities kill everything else no matter what faction we set them to
		if(A.type in blacklist)
			continue

		if(A.IsContained() && (A.z == z))
			if(!A.BreachEffect(null, BREACH_PINK)) // We try breaching them our way!
				continue // If they can't we just go home!
			if(A.status_flags & GODMODE)
				continue // Some special "breaches" don't stay breached!
			A.faction += "pink_midnight"
			/// This does a significant bit of trolling and fucks with the facility on a much wider range.
			/// By making them walk there, certain ones like Blue Star are less centralized and can become a background threat,
			/// While others like NT immediately are in the hallways being an active threat. Also solves the issue of wall-abnos.
			var/turf/destination = pick(get_adjacent_open_turfs(src))
			if(!destination)
				destination = get_turf(src)
			if(!A.patrol_to(destination))
				A.forceMove(destination)
			ordeal_reference.ordeal_mobs |= A
