/obj/projectile/ego_bullet/ego_tough
	name = "9mm tough bullet"
	damage = 12 // Being bald is the optimal gameplay choice!
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/ego_soda
	name = "9mm soda bullet"
	damage = 11
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_clerk
	name = "9mm bullet"
	damage = 5
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_nostalgia
	name = "nostalgia"
	damage = 20
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_nightshade
	name = "nightshade dart"
	damage = 11
	damage_type = BLACK_DAMAGE

/obj/projectile/ego_bullet/ego_nightshade/healing

/obj/projectile/ego_bullet/ego_nightshade/healing/on_hit(atom/target, blocked = FALSE)
	if(isliving(firer) && isliving(target))
		var/mob/living/user = firer
		var/mob/living/victim = target
		if(firer == victim)
			return BULLET_ACT_BLOCK
		if(user.faction_check_mob(victim)) // Our faction
			if(ishuman(victim))
				var/mob/living/carbon/human/H = victim
				if(H.is_working)
					H.visible_message("<span class='warning'>[src] embeds itself in [H]... but nothing happens!</span>")
					qdel(src)
				H.adjustSanityLoss(-damage*0.15)
				H.adjustBruteLoss(-damage*0.15)
				return BULLET_ACT_BLOCK
			else
				victim.adjustBruteLoss(-damage*0.3)
			victim.visible_message("<span class='warning'>[src] embeds itself in [victim]!</span>")
			qdel(src)
			return BULLET_ACT_BLOCK
	..()

/obj/projectile/ego_bullet/ego_bucket
	name = "stone"
	icon_state = "wishing_rock"
	damage = 20
	damage_type = RED_DAMAGE


/obj/projectile/ego_bullet/ego_oceanic
	name = "oceanic"
	damage = 11		//Worse than tough lol
	damage_type = WHITE_DAMAGE

/obj/projectile/beam/ego_pinpoint
	name = "pinpoint"
	icon_state = "omnilaser"
	hitsound = null
	damage = 5
	damage_type = RED_DAMAGE
	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/muzzle/laser/white
	tracer_type = /obj/effect/projectile/tracer/laser/white
	impact_type = /obj/effect/projectile/impact/laser/white
	wound_bonus = -100
	bare_wound_bonus = -100

	//I couldn't get the laser to be red, so I settled for the white one Assonance uses instead. Feel free to fix this on the off-chance you care.

/obj/projectile/beam/ego_pinpoint/on_hit(target)
	. = ..()
	if(isliving(target))
		var/mob/living/simple_animal/M = target
		if(!ishuman(M) && !M.has_status_effect(/datum/status_effect/rend_red))
			new /obj/effect/temp_visual/cult/sparks(get_turf(M))
			M.apply_status_effect(/datum/status_effect/rend_red)
