#define STATUS_EFFECT_TALISMAN /datum/status_effect/stacking/talisman
#define STATUS_EFFECT_CURSETALISMAN /datum/status_effect/stacking/curse_talisman
/mob/living/simple_animal/hostile/abnormality/so_that_no_cry
	name = "So That No One Will Cry"
	desc = "An abnormality taking the form of a wooden doll, various strange paper talismans are attached to it's body."
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "so_that_no_cry"
	icon_living = "so_that_no_cry"
	portrait = "so_that_no_cry"
	maxHealth = 1200 //High health, can be stunned.
	health = 1200
	rapid_melee = 2
	move_to_delay = 3
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	melee_damage_lower = 6
	melee_damage_upper = 12
	melee_damage_type = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = 'sound/abnormalities/so_that_no_cry/attack.ogg'
	attack_verb_continuous = "smacks"
	attack_verb_simple = "smack"
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 30,
		ABNORMALITY_WORK_INSIGHT = list(45, 50, 55, 55, 55),
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = 60,
	)
	work_damage_amount = 8
	work_damage_type = BLACK_DAMAGE
	base_pixel_x = -12
	pixel_x = -12

	ego_list = list(
		/datum/ego_datum/weapon/red_sheet,
		/datum/ego_datum/armor/red_sheet,
	)
	gift_type = /datum/ego_gifts/red_sheet
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	var/can_act = TRUE
	/// When this reaches 400 - begins reflecting damage
	var/damage_taken = 0
	var/damage_reflection = FALSE
	var/talismans = 0

//Work Mechanics
/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/proc/Apply_Talisman(mob/living/carbon/human/user)
	var/datum/status_effect/stacking/curse_talisman/C = user.has_status_effect(/datum/status_effect/stacking/curse_talisman)
	var/datum/status_effect/stacking/talisman/G = user.has_status_effect(/datum/status_effect/stacking/talisman)
	playsound(src, 'sound/abnormalities/so_that_no_cry/talisman.ogg', 100, 1)
	if (!C)//cant take talismans if cursed already
		if(!G)//applying the buff for the first time (it lasts for four minutes)
			new /obj/effect/temp_visual/talisman(get_turf(user))
			user.apply_status_effect(STATUS_EFFECT_TALISMAN)
			to_chat(user, span_nicegreen("A talisman quietly dettaches from the abnormality and sticks to you."))
		else//if the employee already has the buff, add a stack and refresh
			to_chat(user, span_nicegreen("Another talisman sticks to you."))
			if (G.stacks == 5)
				playsound(src, 'sound/abnormalities/so_that_no_cry/curse_talisman.ogg', 100, 1)
			else
				new /obj/effect/temp_visual/talisman(get_turf(user))
			G.add_stacks(1)
			G.refresh()
	return

/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/proc/Remove_Talisman(mob/living/carbon/human/user)
	var/datum/status_effect/stacking/talisman/G = user.has_status_effect(/datum/status_effect/stacking/talisman)
	if(G)//remove the buff
		G.safe_removal = TRUE
		user.remove_status_effect(STATUS_EFFECT_TALISMAN)
		to_chat(user, span_nicegreen("You place all of your talismans back onto the abnormality."))
	return

/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	var/datum/status_effect/stacking/curse_talisman/G = user.has_status_effect(/datum/status_effect/stacking/curse_talisman)
	if(G)
		to_chat(user, span_userdanger("The abnormality gets up and starts moving - and you can't move a muscle!"))
		user.Stun(50)
		datum_reference.qliphoth_change(-1)
		return
	if(work_type == ABNORMALITY_WORK_INSTINCT)
		Remove_Talisman(user)
	if(work_type == ABNORMALITY_WORK_INSIGHT)
		Apply_Talisman(user)
	return

//Breach Mechanics
// All damage reflection stuff is down here
/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/proc/ReflectDamage(mob/living/attacker, attack_type = RED_DAMAGE, damage)
	if(damage < 1)
		return
	if(!damage_reflection)
		return
	var/turf/jump_turf = get_step(attacker, pick(GLOB.alldirs))
	if(jump_turf.is_blocked_turf(exclude_mobs = TRUE))
		jump_turf = get_turf(attacker)
	forceMove(jump_turf)
	playsound(src, 'sound/abnormalities/so_that_no_cry/counter.ogg', min(15 + damage, 100), TRUE, 4)
	attacker.visible_message(span_danger("[src] hits [attacker] with a barrage of punches!"), span_userdanger("[src] counters your attack!"))
	do_attack_animation(attacker)
	attacker.apply_damage(damage, attack_type, null, attacker.getarmor(null, attack_type))
	new /obj/effect/temp_visual/revenant(get_turf(attacker))

/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/attack_hand(mob/living/carbon/human/M)
	..()
	if(!.)
		return
	if(damage_reflection && M.a_intent == INTENT_HARM)
		ReflectDamage(M, M?.dna?.species?.attack_type, M?.dna?.species?.punchdamagehigh)
	if(ishuman(M))
		TryAttachTalisman(M)

/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/attack_paw(mob/living/carbon/human/M)
	..()
	if(damage_reflection && M.a_intent != INTENT_HELP)
		ReflectDamage(M, M?.dna?.species?.attack_type, 5)
	if(ishuman(M))
		TryAttachTalisman(M)

/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(!damage_reflection)
		return
	if(.)
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		if(damage > 0)
			ReflectDamage(M, M.melee_damage_type, damage)

/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/bullet_act(obj/projectile/Proj, def_zone, piercing_hit = FALSE)
	..()
	if(damage_reflection && Proj.firer)
		if(get_dist(Proj.firer, src) < 5)
			ReflectDamage(Proj.firer, Proj.damage_type, Proj.damage)

/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/attackby(obj/item/I, mob/living/user, params)
	..()
	if(ishuman(user))
		TryAttachTalisman(user)
	if(!damage_reflection)
		return
	var/damage = I.force
	if(ishuman(user))
		damage *= 1 + (get_attribute_level(user, JUSTICE_ATTRIBUTE)/100)
	ReflectDamage(user, I.damtype, damage)

//Reflect Code
/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0)
		damage_taken += .
	if(health < 0)
		damage_reflection = FALSE
		return
	if(!can_act)
		return
	if(damage_taken > 400 && !damage_reflection)
		StartReflecting()

/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/proc/StartReflecting()
	can_act = FALSE
	damage_reflection = TRUE
	damage_taken = 0
	playsound(src, 'sound/abnormalities/so_that_no_cry/prepare.ogg', 50, TRUE, 7)
	visible_message(span_warning("[src] assumes a stance!"))
	icon_state = "so_that_no_cry_guard"
	ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))
	SLEEP_CHECK_DEATH(10 SECONDS)
	icon_state = icon_living
	ChangeResistances(list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 2))
	damage_reflection = FALSE
	can_act = TRUE

//Talisman Stuff
/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/AttackingTarget()
	if(!can_act)
		return
	if(!ishuman(target))
		return ..()
	var/mob/living/carbon/human/H = target
	Apply_Talisman(H)
	return ..()

/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/proc/TryAttachTalisman(mob/living/carbon/human/H)
	var/datum/status_effect/stacking/curse_talisman/G = H.has_status_effect(/datum/status_effect/stacking/curse_talisman)
	var/datum/status_effect/stacking/talisman/T = H.has_status_effect(/datum/status_effect/stacking/talisman)
	if(G)
		G.add_stacks(-1)
	else if(T)
		T.add_stacks(-1)
	else
		return
	AttachTalisman()

/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/proc/AttachTalisman(mob/living/attacker)
	visible_message(span_notice("A talisman is attached to [src]!"))
	talismans += 1
	if(talismans > 10)
		TalismanStun()
		move_to_delay = initial(move_to_delay)
		return
	new /obj/effect/temp_visual/talisman(get_turf(src))
	move_to_delay = (3 + (talismans / 10))
	UpdateSpeed()

/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/proc/TalismanStun()
	if(!can_act)
		return
	can_act = FALSE
	new /obj/effect/temp_visual/talisman/curse(get_turf(src))
	var/stun_duration = talismans * 5
	icon_state = "so_that_no_cry_stunned"
	visible_message(span_notice("[src] freezes entirely as a talisman is attached to its body!"))
	SLEEP_CHECK_DEATH(stun_duration)
	icon_state = "so_that_no_cry"
	can_act = TRUE
	talismans = 0

//**   STATUS EFFECTS  **//
//TALISMAN
/datum/status_effect/stacking/talisman //Justice increasing talismans
	id = "talisman"
	status_type = STATUS_EFFECT_MULTIPLE
	duration = 4 MINUTES
	stack_decay = 0 //Without this the stacks were decaying after 1 sec
	max_stacks = 6 //actual max is 5 for +25 Justice, 6 instantly curses you
	stacks = 1
	stack_threshold = 6 //instacurse
	alert_type = /atom/movable/screen/alert/status_effect/talisman
	consumed_on_threshold = TRUE
	var/safe_removal = FALSE

/datum/status_effect/stacking/talisman/on_apply()
	if(!ishuman(owner))
		return ..()
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, 5)
	return ..()

/datum/status_effect/stacking/talisman/add_stacks(stacks_added)
	if(!ishuman(owner))
		return ..()
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, 5 * stacks_added) //max of 25
	return ..()

/datum/status_effect/stacking/talisman/threshold_cross_effect()
	var/mob/living/carbon/human/status_holder = owner
	safe_removal = TRUE
	status_holder.apply_status_effect(STATUS_EFFECT_CURSETALISMAN)
	new /obj/effect/temp_visual/talisman/curse(get_turf(status_holder))
	var/datum/status_effect/stacking/curse_talisman/talismans = status_holder.has_status_effect(/datum/status_effect/stacking/curse_talisman)
	talismans.add_stacks(5)
	return ..()

/datum/status_effect/stacking/talisman/on_remove()
	if(!ishuman(owner))
		return ..()
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, -5 * stacks)
	if(safe_removal == TRUE)
		safe_removal = FALSE
		return ..()
	if(stacks > 0)
		safe_removal = FALSE
		status_holder.apply_status_effect(STATUS_EFFECT_CURSETALISMAN)
		var/datum/status_effect/stacking/curse_talisman/talismans = status_holder.has_status_effect(/datum/status_effect/stacking/curse_talisman)
		talismans.add_stacks(stacks-1)
	return ..()

/atom/movable/screen/alert/status_effect/talisman
	name = "Talisman"
	desc = "These feel oddly soothing, as if they gave you strength."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "talisman"

//CURSE TALISMAN
/datum/status_effect/stacking/curse_talisman //Justice DECREASING talismans
	id = "curse_talisman"
	status_type = STATUS_EFFECT_MULTIPLE
	duration = 6 MINUTES
	stack_decay = 0 //Without this the stacks were decaying after 1 sec
	max_stacks = 6 // -7 per stack, up to -42 Justice
	stacks = 1
	alert_type = /atom/movable/screen/alert/status_effect/curse_talisman
	consumed_on_threshold = FALSE

/datum/status_effect/stacking/curse_talisman/on_apply()
	if(!ishuman(owner))
		return ..()
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, -7 * stacks)
	return ..()

/datum/status_effect/stacking/curse_talisman/add_stacks(stacks_added)
	if(!ishuman(owner))
		return ..()
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, -7 * stacks_added) //max of -42
	return ..()

/datum/status_effect/stacking/curse_talisman/on_remove()
	if(!ishuman(owner))
		return ..()
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, 7 * stacks)
	return ..()

/atom/movable/screen/alert/status_effect/curse_talisman
	name = "Curse Talisman"
	desc = "You feel your strength being sapped away..."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "curse_talisman"

#undef STATUS_EFFECT_TALISMAN
#undef STATUS_EFFECT_CURSETALISMAN
