/obj/item/ego_weapon/template/fishing
	name = "harpoon template"
	desc = "A blank harpoon workshop template."
	icon_state = "harpoontemplate"
	force = 20
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'

	finishedicon = list("finishedharpoon", "finishedharpoon2")
	finishedname = list("harpoon")
	finisheddesc = "A finished harpoon, ready for use. Deals less damage to non-aquatic enemies."

	//Update with aquatic enemies
	var/list/aquatic_enemies = list(
		/mob/living/simple_animal/hostile/shrimp,
		/mob/living/simple_animal/hostile/distortion/shrimp_rambo/easy,
		/mob/living/simple_animal/hostile/shrimp_soldier,
		/mob/living/simple_animal/hostile/shrimp_rifleman,
		/mob/living/simple_animal/hostile/senior_shrimp,
	)



/obj/item/ego_weapon/template/fishing/attack(mob/living/target, mob/living/user)
	var/storelive = FALSE
	if(!(target.status_flags & GODMODE) && target.stat != DEAD)
		storelive = TRUE

	if(user.god_aligned == FISHGOD_MARS)
		force *= 1.3

	if(SSfishing.IsAligned(/datum/planet/mars)) //Big-air bonus for mars being in alignment
		force *= 1.3

	if(!(target.type in aquatic_enemies))
		force *= 0.7
	..()
	if(target.stat == DEAD && storelive)
		if(user.god_aligned == FISHGOD_JUPITER)
			user.adjustBruteLoss(-user.maxHealth*0.1)	//Healing for your kill
			new /obj/effect/temp_visual/heal(get_turf(user), "#FF4444")

		if(SSfishing.IsAligned(/datum/planet/jupiter))
			user.adjustBruteLoss(-user.maxHealth*0.05)	//Healing for your kill
			new /obj/effect/temp_visual/heal(get_turf(user), "#FF4444")

/obj/item/ego_weapon/template/fishing/spear
	name = "fishing spear template"
	desc = "A blank fishing spear workshop template."
	icon_state = "fishspeartemplate"
	force = 18
	reach = 2		//Has 2 Square Reach.
	attack_speed = 1.4
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'

	finishedicon = list("finishedfishspear")
	finishedname = list("fishing spear")
	finisheddesc = "A finished fishing spear, ready for use. Deals less damage to non-aquatic enemies."

/obj/item/ego_weapon/template/fishing/knife
	name = "fillet knife template"
	desc = "A blank fillet knife workshop template."
	icon_state = "fillettemplate"
	force = 18
	attack_speed = 0.7
	attack_verb_continuous = list("rends", "tears", "lacerates", "rips", "cuts")
	attack_verb_simple = list("rend", "tear", "lacerate", "rip", "cut")

	finishedicon = list("finishedfillet")
	finishedname = list("fillet")
	finisheddesc = "A finished fillet knife., ready for use. Deals less damage to non-aquatic enemies."

