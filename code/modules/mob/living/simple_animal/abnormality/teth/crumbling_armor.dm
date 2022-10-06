/mob/living/simple_animal/hostile/abnormality/crumbling_armor
	name = "Crumbling Armor"
	desc = "A thoroughly aged suit of samurai style armor with a V shaped crest on the helmet. It appears desuetude."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "crumbling"
	maxHealth = 600
	health = 600
	threat_level = TETH_LEVEL
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 0)
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 50, 55, 55, 60),
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = list(60, 60, 65, 65, 70)
			)
	work_damage_amount = 5
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/daredevil,
		/datum/ego_datum/armor/daredevil
		)
	gift_type = null
	gift_chance = 100
	var/buff_icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	var/buff_cooldown = 30 SECONDS
	var/buff_cooldown_time
	var/sound_cooldown = 14 SECONDS // Double sound duration
	var/sound_cooldown_time

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/Initialize(mapload)
	. = ..()
	// Megalovania?
	if (prob(1))
		icon_state = "megalovania"

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/proc/Cut_Head(datum/source, datum/abnormality/datum_sent, mob/living/carbon/human/user, work_type)
	SIGNAL_HANDLER
	if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/courage) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/recklessCourage) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/recklessFoolish) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/foolish) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase1) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase2) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase3) || istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase4))
		if (work_type != ABNORMALITY_WORK_ATTACHMENT)
			return
		var/obj/item/bodypart/head/head = user.get_bodypart("head")
		//Thanks Red Queen
		if(!istype(head))
			return FALSE
		if(!isnull(user.ego_gift_list[HAT]) && istype(user.ego_gift_list[HAT], /datum/ego_gifts))
			var/datum/ego_gifts/removed_gift = user.ego_gift_list[HAT]
			removed_gift.Remove(user)
			//user.ego_gift_list[HAT].Remove(user)
		head.dismember()
		user.adjustBruteLoss(500)
		return TRUE
	UnregisterSignal(user, COMSIG_WORK_STARTED)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/work_complete(mob/living/carbon/human/user, work_type, pe)
	..()
	if (get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 40)
		var/obj/item/bodypart/head/head = user.get_bodypart("head")
		//Thanks Red Queen
		if(!istype(head))
			return
		head.dismember()
		user.adjustBruteLoss(500)
		return
	if(user.stat != DEAD && work_type == ABNORMALITY_WORK_REPRESSION)
		if (src.icon_state == "megalovania")
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase1)) // From Courage to Recklessness
				playsound(get_turf(user), 'sound/abnormalities/crumbling/megalovania.ogg', 50, 0, 2)
				user.Apply_Gift(new /datum/ego_gifts/phase2)
				to_chat(user, "<span class='userdanger'>How much more will it take?</span>")
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase2)) // From Recklessness to Foolishness
				playsound(get_turf(user), 'sound/abnormalities/crumbling/megalovania.ogg', 50, 0, 2)
				user.Apply_Gift(new /datum/ego_gifts/phase3)
				to_chat(user, "<span class='userdanger'>You need more strength!</span>")
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase3)) // From Foolishness to Suicidal
				playsound(get_turf(user), 'sound/abnormalities/crumbling/megalovania.ogg', 50, 0, 2)
				user.Apply_Gift(new /datum/ego_gifts/phase4)
				to_chat(user, "<span class='userdanger'>DETERMINATION.</span>")
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/phase4)) // You can progress no further down this fool-hardy path
				return
			playsound(get_turf(user), 'sound/abnormalities/crumbling/megalovania.ogg', 50, 0, 2)
			user.Apply_Gift(new /datum/ego_gifts/phase1)
			RegisterSignal(user, COMSIG_WORK_STARTED, .proc/Cut_Head)
			to_chat(user, "<span class='userdanger'>Just a drop of blood is what it takes...</span>")
		else
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/courage)) // From Courage to Recklessness
				playsound(get_turf(user), 'sound/machines/clockcult/stargazer_activate.ogg', 50, 0, 2)
				user.Apply_Gift(new /datum/ego_gifts/recklessCourage)
				to_chat(user, "<span class='userdanger'>Your muscles flex with strength!</span>")
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/recklessCourage)) // From Recklessness to Foolishness
				playsound(get_turf(user), 'sound/machines/clockcult/stargazer_activate.ogg', 50, 0, 2)
				user.Apply_Gift(new /datum/ego_gifts/recklessFoolish)
				to_chat(user, "<span class='userdanger'>You feel like you could take on the world!</span>")
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/recklessFoolish)) // From Foolishness to Suicidal
				playsound(get_turf(user), 'sound/machines/clockcult/stargazer_activate.ogg', 50, 0, 2)
				user.Apply_Gift(new /datum/ego_gifts/foolish)
				to_chat(user, "<span class='userdanger'>You are a God among men!</span>")
				return
			if(istype(user.ego_gift_list[HAT], /datum/ego_gifts/foolish)) // You can progress no further down this fool-hardy path
				return
			playsound(get_turf(user), 'sound/machines/clockcult/stargazer_activate.ogg', 50, 0, 2)
			user.Apply_Gift(new /datum/ego_gifts/courage)
			RegisterSignal(user, COMSIG_WORK_STARTED, .proc/Cut_Head)
			to_chat(user, "<span class='userdanger'>A strange power flows through you!</span>")
	return

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/breach_effect(mob/living/carbon/human/user)
	. = ..()
	forceMove(pick(GLOB.department_centers))

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/Life()
	. = ..()
	if(status_flags & GODMODE) // Contained
		return
	if(buff_cooldown_time < world.time)
		buff_cooldown_time = buff_cooldown + world.time
		for(var/mob/living/simple_animal/hostile/potential in view(vision_range, src))
			potential.apply_status_effect(/datum/status_effect/great_war)

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/bullet_act(obj/projectile/P)
	if(!isliving(P.firer))
		return
	var/mob/living/shooter = P.firer
	to_chat(shooter, "<span class='warning'>You feel a sharp pain in your neck!</span>")
	shooter.apply_damage(5, RED_DAMAGE, null, shooter.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
	if(sound_cooldown_time < world.time)
		sound_cooldown_time = world.time + sound_cooldown
		playsound(get_turf(src), 'sound/abnormalities/crumbling/blocked.ogg', 75, 0, 7)
		visible_message("<span class='userdanger'>You hope to defeat me while hiding behind your guns? COME. FACE ME!</span>")
	P.Destroy()

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/CanAttack(atom/the_target)
	return FALSE

/datum/ego_gifts/courage
	name = "Inspired Courage"
	icon_state = "courage"
	justice_bonus = 10
	slot = HAT
/datum/ego_gifts/recklessCourage
	name = "Reckless Courage"
	icon_state = "recklessFirst"
	fortitude_bonus = -5
	justice_bonus = 10
	slot = HAT
/datum/ego_gifts/recklessFoolish
	name = "Reckless Foolishness"
	icon_state = "recklessSecond"
	fortitude_bonus = -10
	justice_bonus = 15
	slot = HAT
/datum/ego_gifts/foolish
	name = "Reckless Foolishness"
	icon_state = "foolish"
	fortitude_bonus = -20
	justice_bonus = 20
	slot = HAT
/datum/ego_gifts/phase1
	name = "Lv 4"
	icon_state = "phase1"
	justice_bonus = 10
	slot = HAT
/datum/ego_gifts/phase2
	name = "Lv 10"
	icon_state = "phase2"
	fortitude_bonus = -5
	justice_bonus = 10
	slot = HAT
/datum/ego_gifts/phase3
	name = "Lv 15"
	icon_state = "phase3"
	fortitude_bonus = -10
	justice_bonus = 15
	slot = HAT
/datum/ego_gifts/phase4
	name = "Lv 19"
	icon_state = "phase4"
	fortitude_bonus = -20
	justice_bonus = 20
	slot = HAT

/datum/status_effect/great_war
	id = "crumbling_buff"
	status_type = STATUS_EFFECT_REPLACE
	duration = 30 SECONDS

/datum/status_effect/great_war/on_apply()
	. = ..()
	if(ishostile(owner))
		var/mob/living/simple_animal/hostile/angry_owner = owner
		angry_owner.move_to_delay *= 0.85
		angry_owner.speed *= 0.85

/datum/status_effect/great_war/on_remove()
	. = ..()
	if(ishostile(owner))
		var/mob/living/simple_animal/hostile/angry_owner = owner
		angry_owner.move_to_delay /= 0.85
		angry_owner.speed /= 0.85
