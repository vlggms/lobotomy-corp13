/obj/projectile/ego_bullet/ego_correctional
	name = "correctional"
	damage = 10
	damage_type = BLACK_DAMAGE

/obj/projectile/ego_bullet/ego_hornet
	name = "hornet"
	damage = 40
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_hatred
	name = "magic beam"
	icon_state = "qoh1"
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE
	damage = 50
	spread = 10

/obj/projectile/ego_bullet/ego_hatred/on_hit(atom/target, blocked = FALSE)
	if(ishuman(target) && isliving(firer))
		var/mob/living/carbon/human/H = target
		var/mob/living/user = firer
		if(user.faction_check_mob(H)) // Our faction
			switch(damage_type)
				if(WHITE_DAMAGE)
					H.adjustSanityLoss(damage*0.2)
				if(BLACK_DAMAGE)
					H.adjustBruteLoss(-damage*0.1)
					H.adjustSanityLoss(damage*0.1)
				else // Red or pale
					H.adjustBruteLoss(-damage*0.2)
			H.visible_message("<span class='warning'>[src] vanishes on contact with [H]!</span>")
			qdel(src)
			return BULLET_ACT_BLOCK
	..()

/obj/projectile/ego_bullet/ego_hatred/Initialize()
	. = ..()
	icon_state = "qoh[pick(1,2,3)]"
	damage_type = pick(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	flag = damage_type
