/obj/projectile/ego_bullet/ego_tough
	name = "9mm tough bullet"
	damage = 12 // Being bald is the optimal gameplay choice!
	damage_type = WHITE_DAMAGE
	flag = WHITE_DAMAGE

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
	if(ishuman(target) && isliving(firer))
		var/mob/living/carbon/human/H = target
		var/mob/living/user = firer
		if(firer==target)
			return BULLET_ACT_BLOCK
		if(user.faction_check_mob(H)) // Our faction
			if(H.is_working)
				H.visible_message("<span class='warning'>[src] embeds itself in [H]... but nothing happens!</span>")
				qdel(src)
				return BULLET_ACT_BLOCK
			H.adjustSanityLoss(-damage*0.15)
			H.adjustBruteLoss(-damage*0.15)
			H.visible_message("<span class='warning'>[src] embeds itself in [H]!</span>")
			qdel(src)
			return BULLET_ACT_BLOCK
	..()
