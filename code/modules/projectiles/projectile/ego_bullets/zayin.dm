/obj/projectile/ego_bullet/ego_tough
	name = "9mm tough bullet"
	damage = 8
	damage_type = WHITE_DAMAGE
	flag = WHITE_DAMAGE

/obj/projectile/ego_bullet/ego_soda
	name = "9mm soda bullet"
	damage = 8
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_clerk
	name = "9mm bullet"
	damage = 4
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_clerk/on_hit(atom/target, blocked = FALSE)
	if(ishuman(target) && isliving(firer))
		var/mob/living/carbon/human/H = target
		var/mob/living/user = firer
		if(user == target) // Themselves
			var/obj/item/bodypart/head/head = user.get_bodypart("head")
			if(!istype(head))
				return
			head.dismember()
			QDEL_NULL(head)
			user.regenerate_icons()
			new /obj/effect/gibspawner/generic/silent(get_turf(user))
			H.visible_message("<span class='userdanger'>[user] shoots themself with [src]!</span>")
			qdel(src)
			return BULLET_ACT_BLOCK
	..()
