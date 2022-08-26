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

/mob/living/simple_animal/hostile/ordeal/pink_midnight/Initialize()
	..()
	addtimer(CALLBACK(src, .proc/Breach_All), 5 SECONDS)

	//Funny drags everything to it
/mob/living/simple_animal/hostile/ordeal/pink_midnight/proc/Breach_All()
	for(var/mob/living/simple_animal/hostile/abnormality/A)
		if(A.can_breach && (A.status_flags & GODMODE))
			A.breach_effect()
			var/turf/orgin = get_turf(src)
			var/list/all_turfs = RANGE_TURFS(4, orgin)
			var/turf/open/Y = pick(all_turfs - orgin)
			A.forceMove(Y)
			A.faction += "pink_midnight"
