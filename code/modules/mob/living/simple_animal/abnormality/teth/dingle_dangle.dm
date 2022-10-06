/mob/living/simple_animal/hostile/abnormality/dingledangle
	name = "Dingle-Dangle"
	desc = "A giant, disgusting creature."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "dangle"
	maxHealth = 600
	health = 600
	threat_level = TETH_LEVEL
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.4, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 1)
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(70, 60, 40, 40, 40),
		ABNORMALITY_WORK_INSIGHT = list(30, 40, 70, 70, 70),
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 40
			)
	pixel_x = -16
	base_pixel_x = -16
	work_damage_amount = 8
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/lutemia,
		/datum/ego_datum/armor/lutemia
		)
	gift_type = /datum/ego_gifts/lutemis

	var/dangle_area = 1
	var/list/danglers = list()

/mob/living/simple_animal/hostile/abnormality/dingledangle/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/dingledangle/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/dingledangle/Life()
	. = ..()
	if(status_flags & GODMODE) // Contained
		return
	for(var/mob/living/carbon/human/target in oview(7, src))
		if(target.sanity_lost)
			var/turf/target_turf = null
			var/turf/potential_area
			while(isnull(target_turf))
				potential_area = view(dangle_area, src)
				potential_area -= get_turf(src)
				potential_area -= view(dangle_area-1, src)
				for(var/turf/open/potential_turf in potential_area)
					var/found_dingle = FALSE
					for(var/obj/structure/dangler/dangle in potential_turf.contents)
						found_dingle = TRUE
					if(found_dingle)
						continue
					if(potential_turf.density)
						continue
					target_turf = potential_turf
					break
				if(isnull(target_turf))
					dangle_area += 1
			var/obj/structure/dangler/new_dangler = new /obj/structure/dangler(target_turf)
			new_dangler.name = target.real_name
			danglers += new_dangler
			target.dust()
			if(fear_level < 8) // WELCOME TO THE FOREST OF BODIES
				fear_level += 1
				threat_level += 1

/mob/living/simple_animal/hostile/abnormality/dingledangle/work_complete(mob/living/carbon/human/user, work_type, pe)
	..()
	if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) >= 60)
		//I mean it does this in wonderlabs
		user.dust()

		//But here's the twist: You get a better ego.
		var/location = get_turf(user)
		new /obj/item/clothing/suit/armor/ego_gear/lutemis(location)

/mob/living/simple_animal/hostile/abnormality/dingledangle/failure_effect(mob/living/carbon/human/user, work_type, pe)
	if(prob(50))
		//Yeah dust them too. No ego this time tho
		user.dust()

/mob/living/simple_animal/hostile/abnormality/dingledangle/death(gibbed)
	for(var/obj/structure/dangler/dangle in danglers)
		dangle.Destroy()
	new /obj/item/clothing/suit/armor/ego_gear/lutemis(get_turf(src))
	. = ..()

/mob/living/simple_animal/hostile/abnormality/dingledangle/breach_effect(mob/living/carbon/human/user)
	. = ..()
	forceMove(pick(GLOB.department_centers))

/obj/structure/dangler
	name = "\improper Dangler"
	desc = "Let's all dangle down~"
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "dingledangler"
	layer = 4.1
	density = FALSE
	armor = list(MELEE = 100, BULLET = 100, LASER = 100, ENERGY = 100, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100, RED_DAMAGE = 100, WHITE_DAMAGE = 100, BLACK_DAMAGE = 100, PALE_DAMAGE = 100)
	move_resist = MOVE_FORCE_STRONG
	pull_force = MOVE_FORCE_STRONG

/obj/structure/dangler/can_be_pulled(user, grab_state, force)
	return FALSE
