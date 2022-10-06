/mob/living/simple_animal/hostile/abnormality/spider
	name = "Spider Bud"
	desc = "An abnormality that resembles a massive spider. Tread carefully"
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "spider_closed"
	maxHealth = 400
	health = 400
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(60, 60, 65, 65, 65),
		ABNORMALITY_WORK_INSIGHT = list(-50, -50, -50, -50, -50),
		ABNORMALITY_WORK_ATTACHMENT = list(50, 50, 55, 55, 55),
		ABNORMALITY_WORK_REPRESSION = list(40, 40, 45, 45, 45)
		)
	pixel_x = -8
	base_pixel_x = -8

	work_damage_amount = 7
	work_damage_type = RED_DAMAGE
	ego_list = list(
		/datum/ego_datum/weapon/eyes,
		/datum/ego_datum/armor/eyes
		)
	gift_type =  /datum/ego_gifts/redeyes

/mob/living/simple_animal/hostile/abnormality/spider/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
	// If you do insight or have low prudence, fuck you and die for stepping on a spider
	if((get_attribute_level(user, PRUDENCE_ATTRIBUTE) < 40 || work_type == ABNORMALITY_WORK_INSIGHT) && !(GODMODE in user.status_flags))
		icon_state = "spider_open"
		var/obj/structure/spider/cocoon/casing = new(src.loc)
		casing.Move(get_step(casing, pick(GLOB.alldirs)))
		user.death()
		user.forceMove(casing)
		casing.icon_state = pick("cocoon_large1","cocoon_large2","cocoon_large3")
		casing.density = FALSE
		SLEEP_CHECK_DEATH(50)
		icon_state = "spider_closed"
		return

/mob/living/simple_animal/hostile/abnormality/spider/breach_effect(mob/living/carbon/human/user)

	var/mob/living/simple_animal/hostile/ordeal/pink_midnight/pink = null
	for(var/mob/living/simple_animal/hostile/ordeal/pink_midnight/target in GLOB.mob_living_list)
		pink = target
		break
	for(var/i = 1 to 3)
		if(!isnull(pink))
			var/turf/target_turf = get_turf(pink)
			var/mob/living/simple_animal/hostile/spiderbud_small/new_spider = new /mob/living/simple_animal/hostile/spiderbud_small(target_turf)
			new_spider.faction += "pink_midnight"
		else
			new /mob/living/simple_animal/hostile/spiderbud_small(get_turf(src))
	return

/mob/living/simple_animal/hostile/spiderbud_small
	name = "\improper Spiderling"
	desc = "Their red eyes gleam in the darkness."
	icon = 'icons/effects/effects.dmi'
	icon_state = "spiderling"
	icon_living = "spiderling"
	maxHealth = 200
	health = 200
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 1)
	faction = list("hostile", "spider")
	melee_damage_lower = 8
	melee_damage_upper = 12
	melee_damage_type = RED_DAMAGE
	rapid_melee = 1.5
	attack_sound = 'sound/abnormalities/mountain/bite.ogg'
	density = FALSE
	move_to_delay = 2.5
	del_on_death = TRUE
	stat_attack = DEAD

/mob/living/simple_animal/hostile/spiderbud_small/Initialize()
	. = ..()
	AddComponent(/datum/component/swarming)
	summon_backup()

/mob/living/simple_animal/hostile/spiderbud_small/summon_backup(distance = 6)
	for(var/mob/living/simple_animal/hostile/M in oview(distance, targets_from))
		if(faction_check_mob(M, TRUE))
			if(M.AIStatus == AI_OFF)
				return
			else
				M.Goto(src,M.move_to_delay,M.minimum_distance)
