/mob/living/simple_animal/hostile/abnormality/big_bird
	name = "Big bird"
	desc = "A large, many-eyed bird that patrols the dark forest with an everlasting lamp. \
	Unlike regular birds, it lacks wings and has long arms instead with which it can pick things up."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "big_bird"
	icon_living = "big_bird"
	faction = list("hostile")
	speak_emote = list("chirps")

	pixel_x = -16
	base_pixel_x = -16

	maxHealth = 1500
	health = 1500
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5)
	see_in_dark = 10

	speed = 5
	threat_level = WAW_LEVEL
	can_breach = TRUE
	start_qliphoth = 5
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 50,
						ABNORMALITY_WORK_INSIGHT = 35,
						ABNORMALITY_WORK_ATTACHMENT = 50,
						ABNORMALITY_WORK_REPRESSION = 0
						)
	work_damage_amount = 8
	work_damage_type = BLACK_DAMAGE

	var/bite_cooldown
	var/bite_cooldown_time = 10 SECONDS

/mob/living/simple_animal/hostile/abnormality/big_bird/ListTargets()
	return hearers(vision_range, targets_from) - src

/mob/living/simple_animal/hostile/abnormality/big_bird/CanAttack(atom/the_target)
	if(bite_cooldown > world.time)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/big_bird/AttackingTarget()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/obj/item/bodypart/head/head = H.get_bodypart("head")
		head.dismember()
		QDEL_NULL(head)
		H.regenerate_icons()
		visible_message("<span class='danger'>\The [src] bites [H]'s head off!</span>")
		new /obj/effect/gibspawner/generic/silent(get_turf(H))
		playsound(get_turf(src), 'sound/abnormalities/bigbird/bite.ogg', 50, 1, 2)
		bite_cooldown = world.time + bite_cooldown_time
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/big_bird/success_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(1)
	return

/mob/living/simple_animal/hostile/abnormality/big_bird/failure_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return
