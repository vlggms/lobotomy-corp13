/mob/living/simple_animal/hostile/abnormality/red_queen
	name = "Red Queen"
	desc = "A noble red abnormality sitting in her chair."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "redqueen"
	pixel_x = -8
	base_pixel_x = -8
	maxHealth = 650
	health = 650
	threat_level = HE_LEVEL
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.3, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.2)
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 65,
		ABNORMALITY_WORK_INSIGHT = 65,
		ABNORMALITY_WORK_ATTACHMENT = 65,
		ABNORMALITY_WORK_REPRESSION = 65
		)
	work_damage_amount = 20			//Unlikely to hurt you but if she ever does she'll fuck you
	work_damage_type = RED_DAMAGE

	ranged = TRUE
	minimum_distance = 2
	retreat_distance = 2
	move_to_delay = 5
	stat_attack = HARD_CRIT

	ego_list = list(
		/datum/ego_datum/weapon/fury,
		/datum/ego_datum/armor/fury
		)
	gift_type = /datum/ego_gifts/fury

	var/liked
	var/list/diamonds = list()
	var/diamond_cooldown = 2 SECONDS
	COOLDOWN_DECLARE(diamond)

/mob/living/simple_animal/hostile/abnormality/red_queen/Initialize(mapload)
	. = ..()
	//What does she like?
	//Pick it once so people can find out
	liked = pick(ABNORMALITY_WORK_INSTINCT, ABNORMALITY_WORK_INSIGHT, ABNORMALITY_WORK_ATTACHMENT, ABNORMALITY_WORK_REPRESSION)

/mob/living/simple_animal/hostile/abnormality/red_queen/Moved()
	. = ..()
	var/valid_turf = shuffle(view(2, src))
	for(var/obj/projectile/queen_diamond/QD in diamonds)
		for(var/turf/open/T in valid_turf)
			if(T == get_turf(src))
				continue
			var/filled = FALSE
			for(var/obj/projectile/P in T.contents)
				if(istype(P, /obj/projectile/queen_diamond))
					filled = TRUE
					break
			if(!filled)
				QD.forceMove(T)
				break

/mob/living/simple_animal/hostile/abnormality/red_queen/Life()
	. = ..()
	if(!.)
		return
	if(diamonds.len >= 8)
		return
	if(COOLDOWN_FINISHED(src, diamond))
		COOLDOWN_START(src, diamond, diamond_cooldown)
		for(var/turf/open/T in oview(1, src))
			if(T == get_turf(src))
				continue
			if(T.density)
				continue
			var/filled = FALSE
			for(var/obj/projectile/queen_diamond/QD in T.contents)
				filled = TRUE
				break
			if(filled)
				continue
			var/obj/projectile/queen_diamond/new_diamond = new /obj/projectile/queen_diamond(T)
			new_diamond.firer = src
			diamonds += new_diamond
			break
	if(status_flags & GODMODE)
		return

/mob/living/simple_animal/hostile/abnormality/red_queen/death(gibbed)
	for(var/obj/projectile/queen_diamond/QD in diamonds)
		QD.Destroy()
	return ..()

/mob/living/simple_animal/hostile/abnormality/red_queen/OpenFire()
	if(!LAZYLEN(diamonds))
		return
	for(var/obj/projectile/queen_diamond/QD in diamonds)
		QD.preparePixelProjectile(target, get_turf(QD))
		var/launch = TRUE
		for(var/turf/T in getline(QD, target))
			if(T.is_blocked_turf(TRUE, src))
				launch = FALSE
				break
		if(launch)
			addtimer(CALLBACK (QD, .obj/projectile/proc/fire), 3)
			diamonds -= QD

/mob/living/simple_animal/hostile/abnormality/red_queen/MeleeAction(patience)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/red_queen/work_complete(mob/living/carbon/human/user, work_type, pe)
	..()
	if(work_type != liked)
		if(prob(20))
			//The Red Queen is fickle, if you're unlucky, fuck you.
			user.visible_message("<span class='warning'>An invisible blade slices through [user]'s neck!</span>")
			user.apply_damage(200, RED_DAMAGE, null, user.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			new /obj/effect/temp_visual/slice(get_turf(user))

			//Fitting sound, I want something crunchy, and also very loud so everyone knows
			playsound(src, 'sound/weapons/guillotine.ogg', 75, FALSE, 4)

			if(user.health < 0)
				var/obj/item/bodypart/head/head = user.get_bodypart("head")
				//OFF WITH HIS HEAD!
				if(!istype(head))
					return FALSE
				head.dismember()
	return
