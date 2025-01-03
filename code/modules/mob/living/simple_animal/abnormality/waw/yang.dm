/mob/living/simple_animal/hostile/abnormality/yang
	name = "Yang"
	desc = "A floating white fish that seems to help everyone near it."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "yang"
	icon_living = "yang"
	var/icon_breach = "yang_breach"
	icon_dead = "yang_slain"
	portrait = "yang"
	is_flying_animal = TRUE
	maxHealth = 800	//It is helpful and therefore weak.
	health = 800
	move_to_delay = 7
	pixel_x = -16
	base_pixel_x = -16
	pixel_y = -8
	base_pixel_y = -8
	stat_attack = HARD_CRIT

	//work stuff
	can_breach = TRUE
	start_qliphoth = 2
	threat_level = WAW_LEVEL
	work_damage_amount = 11
	work_damage_type = WHITE_DAMAGE
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 0,
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 40, 40, 40),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 55, 55, 55),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 40, 40, 40),
		"Release" = 0,
	)
	max_boxes = 20
	success_boxes = 16
	neutral_boxes = 9

	ego_list = list(
		/datum/ego_datum/weapon/assonance,
		/datum/ego_datum/armor/assonance,
	)
	gift_type = /datum/ego_gifts/assonance
	abnormality_origin = ABNORMALITY_ORIGIN_ALTERED

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/yin = 5, // TAKE THE FISH. DO IT NOW.
	)

	//Melee
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 1.7, PALE_DAMAGE = 2)
	melee_damage_lower = 30
	melee_damage_upper = 30
	melee_damage_type = WHITE_DAMAGE
	faction = list("neutral")	//Doesn't attack until attacked.

	//Ranged. Simple AI to help it work
	ranged = 1
	retreat_distance = 2
	minimum_distance = 5
	projectiletype = /obj/projectile/beam/yang
	projectilesound = 'sound/weapons/sear.ogg'

	observation_prompt = "The Angel's Pendant was one half of a greater whole, but now they've been cleaved in half, forever wanting to reunite. <br>\
		The pendant laid upon the podium before you, even being in the same room as it seemed to fortify your body and soul."
	observation_choices = list(
		"Put it on" = list(TRUE, "The moment you put it on, you feel a radiance emanate out and mend pain you didn't even know was there. <br>\
			It doesn't intend to heal you, it's just the way it is. <br>\
			If there is darkness and evil in this world, shouldn't there be light and good too? <br>\
			The world is far more than darkness and cold."),
		"Don't put it on" = list(FALSE, "It is all that is bright given form, made to gather all the positivity in the world. <br>\
			If you can't accept the goodness in yourself, you're not ready to accept the goodness of the world."),
	)

	var/explosion_damage = 150
	var/explosion_timer = 7 SECONDS
	var/explosion_range = 15
	var/exploding = FALSE

	//slowly heals sanity over time
	var/heal_cooldown
	var/heal_cooldown_time = 3 SECONDS
	var/heal_amount = 5


/mob/living/simple_animal/hostile/abnormality/yang/New(loc, ...)
	. = ..()
	if(YinCheck())
		max_boxes = 25

/mob/living/simple_animal/hostile/abnormality/yang/Move()
	if(exploding || SSlobotomy_events.yang_downed)
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/yang/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if((heal_cooldown < world.time) && !(status_flags & GODMODE))
		HealPulse()

/mob/living/simple_animal/hostile/abnormality/yang/WorkChance(mob/living/carbon/human/user, chance, work_type)
	return YinCheck() ? chance + 10 : chance

/mob/living/simple_animal/hostile/abnormality/yang/proc/YinCheck()
	for(var/datum/abnormality/AD in SSlobotomy_corp.all_abnormality_datums)
		if(AD.abno_path == /mob/living/simple_animal/hostile/abnormality/yin)
			return TRUE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/yang/bullet_act(obj/projectile/P, def_zone, piercing_hit = FALSE)
	apply_damage(P.damage, P.damage_type)
	P.on_hit(src, 0, piercing_hit)
	if(!P.firer)
		return BULLET_ACT_HIT
	Reflect(P.firer, P.damage)
	return BULLET_ACT_HIT

/mob/living/simple_animal/hostile/abnormality/yang/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	Reflect(user, I.force)
	return

/mob/living/simple_animal/hostile/abnormality/yang/attack_hand(mob/living/carbon/human/M)
	. = ..()
	Reflect(M, 2)
	return

/mob/living/simple_animal/hostile/abnormality/yang/attack_animal(mob/living/simple_animal/M)
	. = ..()
	Reflect(M, M.melee_damage_upper)
	return

/mob/living/simple_animal/hostile/abnormality/yang/proc/Reflect(mob/living/attacker, damage)
	if(ishuman(attacker))
		var/mob/living/carbon/human/H = attacker
		var/justice_mod = 1 + (get_attribute_level(H, JUSTICE_ATTRIBUTE)/100)
		damage *= justice_mod
	attacker.deal_damage(damage, WHITE_DAMAGE)
	return

/mob/living/simple_animal/hostile/abnormality/yang/death()
	//Make sure we didn't get cheesed, and blow up.
	if(health > 0)
		return
	if(YinCheck() && SSlobotomy_events.yin_downed)
		SSlobotomy_events.yang_downed = TRUE
		return ..()
	if(SSlobotomy_events.yin_downed) // This is always true unless Yin exists and modifies it.
		icon_state = "yang_blow"
		exploding = TRUE
		SSlobotomy_events.yang_downed = TRUE
		addtimer(CALLBACK(src, PROC_REF(explode)), explosion_timer)
		return
	if(SSlobotomy_events.yang_downed)
		return
	INVOKE_ASYNC(src, PROC_REF(BeDead))

/mob/living/simple_animal/hostile/abnormality/yang/proc/BeDead()
	icon_state = icon_dead
	playsound(src, 'sound/effects/magic.ogg', 60)
	SSlobotomy_events.yang_downed = TRUE
	ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))
	for(var/i = 1 to 12)
		SLEEP_CHECK_DEATH(5 SECONDS)
		if(SSlobotomy_events.yin_downed)
			death()
			return
	adjustBruteLoss(-maxHealth, forced = TRUE)
	ChangeResistances(list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 1.7, PALE_DAMAGE = 2))
	SSlobotomy_events.yang_downed = FALSE
	icon_state = icon_breach

/mob/living/simple_animal/hostile/abnormality/yang/proc/explode()
	exploding = TRUE
	new /obj/effect/temp_visual/explosion/fast(get_turf(src))
	var/turf/orgin = get_turf(src)
	var/list/all_turfs = RANGE_TURFS(explosion_range, orgin)
	alpha = 0

	for(var/i = 0 to explosion_range)
		for(var/turf/T in all_turfs)
			if(T.density)
				continue
			if(get_dist(src, T) > i)
				continue
			new /obj/effect/temp_visual/dir_setting/speedbike_trail(T)
			HurtInTurf(T, list(), explosion_damage, WHITE_DAMAGE, hurt_mechs = TRUE)
			all_turfs -= T
		SLEEP_CHECK_DEATH(1)

	QDEL_NULL(src)


/mob/living/simple_animal/hostile/abnormality/yang/proc/HealPulse()
	heal_cooldown = world.time + heal_cooldown_time

	for(var/mob/living/carbon/human/H in livinginview(15, src))
		if(H.stat == DEAD)
			continue
		H.adjustSanityLoss(-heal_amount) // It's healing
		new /obj/effect/temp_visual/emp/pulse(get_turf(H))


/obj/projectile/beam/yang
	name = "yang beam"
	icon_state = "omnilaser"
	hitscan = TRUE
	damage = 70
	damage_type = WHITE_DAMAGE
	muzzle_type = /obj/effect/projectile/muzzle/laser/white
	tracer_type = /obj/effect/projectile/tracer/laser/white
	impact_type = /obj/effect/projectile/impact/laser/white

/obj/effect/projectile/muzzle/laser/white
	name = "white flash"
	icon_state = "muzzle_white"

/obj/effect/projectile/tracer/laser/white
	name = "white beam"
	icon_state = "beam_white"

/obj/effect/projectile/impact/laser/white
	name = "white impact"
	icon_state = "impact_white"


/mob/living/simple_animal/hostile/abnormality/yang/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/yang/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	icon_state = icon_breach
	SSlobotomy_events.yang_downed = FALSE

/mob/living/simple_animal/hostile/abnormality/yang/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(work_type == "Release")
		datum_reference.qliphoth_change(-2)
	if(work_time >= (30 SECONDS))
		for(var/datum/abnormality/AD in SSlobotomy_corp.all_abnormality_datums)
			if(AD.abno_path != /mob/living/simple_animal/hostile/abnormality/yin)
				continue
			AD.qliphoth_change(-1, user)
			break
	return
