#define STATUS_EFFECT_SCULPTOR /datum/status_effect/sculptor
/mob/living/simple_animal/hostile/abnormality/pygmalion
	name = "Pygmalion"
	desc = "A tall statue of a humanoid abnormality in a pink dress holding a bouquet of light blue flowers."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "pygmalion"
	icon_living = "pygmalion"
	portrait = "pygmalion"
	faction = list("neutral")

	pixel_x = -8
	base_pixel_x = -8

	ranged = TRUE
	ranged_cooldown_time = 2 SECONDS
	minimum_distance = 2

	maxHealth = 2000
	health = 2000
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	stat_attack = HARD_CRIT
	can_breach = TRUE
	vision_range = 7

	del_on_death = FALSE

	move_to_delay = 4
	threat_level = WAW_LEVEL

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 50, 55, 55, 60),
		ABNORMALITY_WORK_INSIGHT = 45,
		ABNORMALITY_WORK_ATTACHMENT = 50,
		ABNORMALITY_WORK_REPRESSION = list(40, 40, 40, 35, 30),
	)
	work_damage_amount = 10
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/my_own_bride,
		/datum/ego_datum/armor/my_own_bride,
	)
	gift_type =  /datum/ego_gifts/bride
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	observation_prompt = "The King Pygmalion prayed earnestly to the Goddess Aphrodite, wishing for the marble statue he had made and fallen in love to come to life. <br>\
		She answered his prayer, bringing Galatea to life and united them in matrinomy. <br>\
		What is the real name of the abnormality before you?"
	observation_choices = list(
		"Galatea" = list(TRUE, "Perhaps they sculpted each other."),
		"Pygmalion" = list(TRUE, "Perhaps they sculpted each other."),
	)

	var/missing_prudence = 0
	var/mob/living/carbon/human/sculptor = null
	var/protect_cooldown_time = 30 SECONDS
	var/protect_cooldown
	var/retaliation = 10
	var/PRUDENCE_CAP = 60

/mob/living/simple_animal/hostile/abnormality/pygmalion/CanAllowThrough(atom/movable/mover, turf/target)
	if(sculptor && ishuman(mover))
		return TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/pygmalion/CanAttack(atom/target)
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		if (human_target.sanity_lost)
			return FALSE

	return ..()

/mob/living/simple_animal/hostile/abnormality/pygmalion/AttackingTarget(atom/attacked_target)
	return OpenFire()

/mob/living/simple_animal/hostile/abnormality/pygmalion/OpenFire()
	if(ranged_cooldown > world.time)
		return FALSE
	ranged_cooldown = world.time + ranged_cooldown_time
	for(var/i = 1 to 4)
		var/turf/T = get_step(get_turf(src), pick(1,2,4,5,6,8,9,10))
		if(T.density)
			i -= 1
			continue
		var/obj/projectile/P = sculptor ?  new /obj/projectile/bride_bolts/(T) : new /obj/projectile/bride_bolts_enraged/(T)
		P.starting = T
		P.firer = src
		P.fired_from = T
		P.yo = target.y - T.y
		P.xo = target.x - T.x
		P.original = target
		P.preparePixelProjectile(target, T)
		addtimer(CALLBACK (P, TYPE_PROC_REF(/obj/projectile, fire)), 3)
	return


/mob/living/simple_animal/hostile/abnormality/pygmalion/WorkComplete(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	var/temp_gift_chance = gift_chance
	if(user == sculptor)
		gift_chance = 10
	. = ..()
	gift_chance = temp_gift_chance


/mob/living/simple_animal/hostile/abnormality/pygmalion/WorkChance(mob/living/carbon/human/user, chance, work_type)
	chance = ..()
	if(user == sculptor)
		chance += 10
	return chance

/mob/living/simple_animal/hostile/abnormality/pygmalion/proc/GoToSculptor()
	if(!sculptor)
		return
	var/turf/origin = get_turf(sculptor)
	var/list/all_turfs = RANGE_TURFS(2, origin)
	for(var/turf/T in all_turfs)
		if(T == origin)
			continue
		var/available_turf
		var/list/sculptor_line = getline(T, sculptor)
		for(var/turf/line_turf in sculptor_line)
			if(line_turf.is_blocked_turf(exclude_mobs = TRUE))
				available_turf = FALSE
				break
			available_turf = TRUE
		if(!available_turf)
			continue
		forceMove(T)
		LoseTarget()
		for(var/mob/living/simple_animal/hostile/abnormality/enemy in oview(src, vision_range))
			if(enemy.stat != DEAD)
				GiveTarget(enemy)
				break
		return

/mob/living/simple_animal/hostile/abnormality/pygmalion/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(user.stat != DEAD && !sculptor && istype(user))
		sculptor = user
		RegisterSignal(user, COMSIG_LIVING_DEATH, PROC_REF(SculptorDeathOrInsane))
		RegisterSignal(user, COMSIG_HUMAN_INSANE, PROC_REF(SculptorDeathOrInsane))
		user.apply_status_effect(STATUS_EFFECT_SCULPTOR)
		to_chat(user, span_nicegreen("You feel attached to this abnormality."))

/mob/living/simple_animal/hostile/abnormality/pygmalion/proc/SculptorDeathOrInsane(datum/source, gibbed)
	SIGNAL_HANDLER
	UnregisterSignal(sculptor, COMSIG_LIVING_DEATH)
	UnregisterSignal(sculptor, COMSIG_HUMAN_INSANE)
	remove_status_effect(STATUS_EFFECT_SCULPTOR)
	threat_level = WAW_LEVEL
	if (sculptor)
		sculptor.remove_status_effect(STATUS_EFFECT_SCULPTOR)
	if (missing_prudence)
		restorePrudence()
	faction = list()
	sculptor = null
	if(client)
		to_chat(src, span_userdanger("The sculptor has fallen. It is now your duty to avenge this tragedy!"))
	return TRUE

/mob/living/simple_animal/hostile/abnormality/pygmalion/Life()
	. = ..()
	if (IsContained() && sculptor && (sculptor.health/sculptor.maxHealth < 0.5 || sculptor.sanityhealth/sculptor.maxSanity < 0.5) )
		BreachEffect()
		if(client)
			to_chat(src, span_userdanger("The sculptor is in danger. It is now your duty to protect them!"))

		fear_level = TETH_LEVEL
		var/datum/attribute/user_attribute = sculptor.attributes[PRUDENCE_ATTRIBUTE]
		var/user_attribute_level = max(1, user_attribute.level)
		if (user_attribute_level > PRUDENCE_CAP)
			missing_prudence = user_attribute_level - PRUDENCE_CAP
			src.sculptor.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, (missing_prudence) * -1)
			to_chat(sculptor, span_red("You feel like your mind grows weaker as it has come out to protect you..."))

	if (!IsContained() && protect_cooldown < world.time)
		protect_cooldown = world.time + protect_cooldown_time
		if(!can_see(src, sculptor, vision_range))
			GoToSculptor()

	if (IsContained() && threat_level == TETH_LEVEL)
		threat_level = WAW_LEVEL

	if (IsContained() && missing_prudence && sculptor)
		restorePrudence()

/mob/living/simple_animal/hostile/abnormality/pygmalion/proc/restorePrudence()
	sculptor.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, missing_prudence)
	missing_prudence = null
	to_chat(sculptor, span_nicegreen("As soon as Pygmalion has fallen, You feel like your mind is back on track."))

/mob/living/simple_animal/hostile/abnormality/pygmalion/death(gibbed)
	if (sculptor)
		sculptor.remove_status_effect(STATUS_EFFECT_SCULPTOR)
		if (missing_prudence)
			restorePrudence()
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/pygmalion/attackby(obj/item/W, mob/user, params)
	. = ..()
	CounterAttack(user)

/mob/living/simple_animal/hostile/abnormality/pygmalion/bullet_act(obj/projectile/P)
	. = ..()
	CounterAttack(P.firer)

/mob/living/simple_animal/hostile/abnormality/pygmalion/proc/CounterAttack(mob/living/attacker)
	if (attacker == sculptor)
		attacker.deal_damage(retaliation, PALE_DAMAGE)
		to_chat(attacker, span_userdanger("You feel your heart break!"))

/datum/status_effect/sculptor
	id = "Sculptor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1		//Lasts basically forever
	alert_type = /atom/movable/screen/alert/status_effect/sculptor

/atom/movable/screen/alert/status_effect/sculptor
	name = "Sculptor"
	desc = "You feel attached to Pygmalion, Does it feel the same way towards me?"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "sculptor"

#undef STATUS_EFFECT_SCULPTOR
