#define STATUS_EFFECT_PRANKED /datum/status_effect/pranked
/mob/living/simple_animal/hostile/abnormality/laetitia
	name = "Laetitia"
	desc = "A wee witch."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "laetitia"
	portrait = "laetitia"
	maxHealth = 600
	health = 600
	threat_level = HE_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(40, 45, 50, 50, 50),
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = list(60, 60, 60, 65, 65),
		ABNORMALITY_WORK_REPRESSION = 0,
	)
	work_damage_amount = 8
	work_damage_type = BLACK_DAMAGE
	max_boxes = 16 // Accurate to base game

	ego_list = list(
		/datum/ego_datum/weapon/prank,
		/datum/ego_datum/armor/prank,
	)
	gift_type = /datum/ego_gifts/prank
	gift_message = "I hope you're pleased with this!"
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	attack_action_types = list(/datum/action/cooldown/laetitia_gift)

/datum/action/cooldown/laetitia_gift
	name = "Gift"
	icon_icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	button_icon_state = "prank_gift"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = 1 SECONDS
	var/view_distance = 3

/datum/action/cooldown/laetitia_gift/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/laetitia))
		return FALSE
	//give gift
	new /obj/item/laetitia_gift(owner.loc)
	// var/targets = view(view_distance, owner)
	// for(var/turf/T in targets)
	// 	if(T.density)
	// 		targets -= T
	// var/spawn_place = pick(targets)
	// new /obj/item/laetitia_gift(spawn_place)
	StartCooldown()

/obj/item/laetitia_gift
	name = "Laetitia's Gift"
	icon = 'icons/obj/storage.dmi'
	icon_state = "giftdeliverypackage3"
	var/opening = FALSE
	var/oneuse = TRUE

/obj/item/laetitia_gift/attack_self(mob/user)
	if(opening)
		to_chat(user, "<span class='warning'>You're already reading this!</span>")
		return FALSE
	opening = TRUE
	playsound(user, pick('sound/effects/pageturn1.ogg','sound/effects/pageturn2.ogg','sound/effects/pageturn3.ogg'), 30, TRUE)
	to_chat(owner, "Doing thing!")
	if(do_after(user, 5 SECONDS, src))
		// do thing
		to_chat(owner, "Thing done!")
	qdel(src)


/mob/living/simple_animal/hostile/abnormality/laetitia/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	var/datum/status_effect/pranked/P = user.has_status_effect(STATUS_EFFECT_PRANKED)
	if(P)
		if(prob(15)) //15% chance to remove prank
			user.remove_status_effect(STATUS_EFFECT_PRANKED)
		else if(prob(15)) //15% chance to trigger explosion
			P.TriggerPrank()
	else
		if(prob(70)) //not 100% of the time to be funny
			var/datum/status_effect/pranked/SE = user.apply_status_effect(STATUS_EFFECT_PRANKED)
			SE.laetitia_datum_reference = datum_reference
	return

/mob/living/simple_animal/hostile/abnormality/laetitia/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	var/datum/status_effect/pranked/P = user.has_status_effect(STATUS_EFFECT_PRANKED)
	if(P && prob(30)) //30% to remove prank
		user.remove_status_effect(STATUS_EFFECT_PRANKED)
	return

/mob/living/simple_animal/hostile/abnormality/laetitia/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	var/datum/status_effect/pranked/P = user.has_status_effect(STATUS_EFFECT_PRANKED)
	if(P && prob(70)) //70% to trigger explosion
		P.TriggerPrank()
	return

//Her friend
/mob/living/simple_animal/hostile/gift
	name = "Little Witch's Friend"
	desc = "It's a horrifying amalgamation of flesh and eyes."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "witchfriend"
	icon_living = "witchfriend"
	icon_dead = "witchfriend_dead"
	maxHealth = 800
	health = 800
	pixel_x = -16
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1)
	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT
	melee_damage_lower = 20
	melee_damage_upper = 30
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/abnormalities/laetitia/spider_attack.ogg'
	death_sound = 'sound/abnormalities/laetitia/spider_dead.ogg'

/mob/living/simple_animal/hostile/gift/Initialize()
	. = ..()
	playsound(get_turf(src), 'sound/abnormalities/laetitia/spider_born.ogg', 50, 1)

/mob/living/simple_animal/hostile/gift/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

//Given Prank Gift
//Explodes after 3 to 4 minutes
/datum/status_effect/pranked
	id = "pranked"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	var/laetitia_datum_reference
	var/obj/prank_overlay

/datum/status_effect/pranked/on_creation(mob/living/new_owner, ...)
	duration = rand(1800,2400)
	return ..()

/datum/status_effect/pranked/on_apply()
	if(get_attribute_level(owner, PRUDENCE_ATTRIBUTE) >= 80)
		to_chat(owner, span_warning("You feel something slipped into your pocket."))
	RegisterSignal(owner, COMSIG_WORK_STARTED, PROC_REF(WorkCheck))
	return ..()

/datum/status_effect/pranked/tick()
	if(!(duration - world.time) <= 100) //at most a 10 second warning
		return
	if(prank_overlay && (get_attribute_level(owner, PRUDENCE_ATTRIBUTE) < 60))
		return
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	//i swear this is all necessary
	prank_overlay = new
	prank_overlay.icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	prank_overlay.icon_state = "prank_gift"
	prank_overlay.layer = -BODY_FRONT_LAYER
	prank_overlay.plane = FLOAT_PLANE
	prank_overlay.mouse_opacity = 0
	prank_overlay.vis_flags = VIS_INHERIT_ID
	prank_overlay.alpha = 0
	to_chat(status_holder, span_danger("Your heart-shaped present begins to crack..."))
	animate(prank_overlay, alpha = 255, time = (duration - world.time))
	status_holder.vis_contents += prank_overlay

/datum/status_effect/pranked/on_remove()
	UnregisterSignal(owner, COMSIG_WORK_STARTED)
	if(prank_overlay in owner.vis_contents)
		owner.vis_contents -= prank_overlay
	if(!duration < world.time) //if prank removed due to it expiring
		return
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	to_chat(status_holder, span_userdanger("You feel something deep in your body explode!"))
	status_holder.vis_contents -= prank_overlay
	var/location = get_turf(status_holder)
	new /mob/living/simple_animal/hostile/gift(location)
	var/rand_dir = pick(NORTH, SOUTH, EAST, WEST)
	var/atom/throw_target = get_edge_target_turf(status_holder, rand_dir)
	if(!status_holder.anchored)
		status_holder.throw_at(throw_target, rand(1, 3), 7, status_holder)
	status_holder.deal_damage(200, RED_DAMAGE)//Usually a kill, you can block it if you're good

/datum/status_effect/pranked/proc/TriggerPrank()
	//immediately set to 10 seconds, don't shorten if less than 10 seconds remaining
	var/newduration = duration - world.time
	newduration = clamp(newduration, 0, 100)
	duration = world.time + newduration

//Half prank duration once if you work with another abnorm
/datum/status_effect/pranked/proc/WorkCheck(datum/source, datum/abnormality/datum_sent, mob/living/carbon/human/user, work_type)
	SIGNAL_HANDLER
	if(datum_sent == laetitia_datum_reference)
		return
	var/newduration = duration
	newduration = (newduration - world.time)/2
	duration = newduration + world.time
	UnregisterSignal(owner, COMSIG_WORK_STARTED)

#undef STATUS_EFFECT_PRANKED
