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

