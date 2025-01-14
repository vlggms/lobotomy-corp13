#define STATUS_EFFECT_PRANKED /datum/status_effect/pranked
/mob/living/simple_animal/hostile/abnormality/laetitia
	name = "Laetitia"
	desc = "A wee witch."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "laetitia"
	portrait = "laetitia"
	maxHealth = 1500
	health = 1500
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
	melee_damage_type = WHITE_DAMAGE
	melee_damage_lower = 1
	melee_damage_upper = 5
	attack_verb_continuous = "slaps"
	attack_verb_simple = "slap"

	ego_list = list(
		/datum/ego_datum/weapon/prank,
		/datum/ego_datum/armor/prank,
	)
	gift_type = /datum/ego_gifts/prank
	gift_message = "I hope you're pleased with this!"
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "This place is so gloomy, everyone always seems so sad and they don't smile. <br>\
		It's lonely to be sad, so, this little lady has been secretly giving them all presents filled with friends! <br>\
		Did they like the surprise?"
	observation_choices = list(
		"Tell the truth" = list(TRUE, "Oh, that's sad... <br>Even if they're my friends, that doesn't mean they're your friends as well. <br>\
			I won't give you a present, but, could you stay and play with me some more today?"),
		"Lie and say they did" = list(FALSE, "I'm glad! <br>I wish I could have seen their faces, I bet they were so surprised! <br>\
			You look lonely too, I hope my present will make you laugh as well!"),
	)

	attack_action_types = list(/datum/action/cooldown/laetitia_gift, /datum/action/cooldown/laetitia_summon)

/datum/action/cooldown/laetitia_summon
	name = "Call for Friends"
	icon_icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	button_icon_state = "prank_gift"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = 40 SECONDS
	var/delete_timer
	var/delete_cooldown = 30 SECONDS
	var/mob/living/simple_animal/hostile/gift/G1
	var/mob/living/simple_animal/hostile/gift/G2

/datum/action/cooldown/laetitia_summon/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/laetitia))
		return FALSE

	StartCooldown()
	G1 = new /mob/living/simple_animal/hostile/gift(owner.loc)
	G2 = new /mob/living/simple_animal/hostile/gift(owner.loc)
	delete_timer = addtimer(CALLBACK(src, PROC_REF(delete)), delete_cooldown, TIMER_STOPPABLE)
	// send poll to all ghosts and wait
	var/list/candidates = pollGhostCandidates("Laetitia is calling for help! Are you willing to protect her?", poll_time=100)
	if (LAZYLEN(candidates) > 0)
		var/mob/dead/observer/C = pick(candidates)
		G1.key = C.key
		candidates -= C
	if (LAZYLEN(candidates) > 0)
		var/mob/dead/observer/C = pick(candidates)
		G2.key = C.key
		candidates -= C

/datum/action/cooldown/laetitia_summon/proc/delete()
	if (!G1.ckey)
		qdel(G1)
	if (!G2.ckey)
		qdel(G2)

/datum/action/cooldown/laetitia_gift
	name = "Gift"
	icon_icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	button_icon_state = "prank_gift"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = 10 SECONDS
	var/view_distance = 3

/datum/action/cooldown/laetitia_gift/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/laetitia))
		return FALSE
	var/kind = tgui_alert(owner, "What kind of gift?", "Custom Speech", list("Good", "Bad"))
	var/strength = text2num(tgui_alert(owner, "What is the strength of the gift?", "Custom Speech", list("1", "2", "3")))
	if (strength == null)
		strength = 2
	var/obj/item/laetitia_gift/g = new /obj/item/laetitia_gift(owner.loc)
	g.strength = strength
	if (strength == 1)
		g.color = "#F48FB1"
		g.name = "small laetitia's gift"
	else if (strength == 3)
		g.color = "#C2185B"
		g.name = "big laetitia's gift"
	if (kind == "Good")
		g.strength *= -1
	StartCooldown()

/obj/item/laetitia_gift
	name = "laetitia's gift"
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "prank_gift"
	var/opening = FALSE
	var/oneuse = TRUE
	var/basepower = 25
	var/strength = 1

/obj/item/laetitia_gift/attack_self(mob/user)
	if(opening)
		to_chat(user, span_warning("You're already opening this gift!"))
		return FALSE
	opening = TRUE
	to_chat(user, "Opening the gift!")
	if(do_after(user, 5 SECONDS, src))
		playsound(get_turf(src), 'sound/abnormalities/laetitia/spider_born.ogg', 50, 1)
		if (istype(user, /mob/living))
			var/mob/living/L = user
			L.apply_damage((basepower*strength), RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), FALSE, TRUE)
		for(var/turf/T in range(2, user))
			new /obj/effect/temp_visual/smash_effect(T)
			user.HurtInTurf(T, list(), (basepower*strength), RED_DAMAGE, check_faction = FALSE, hurt_mechs = TRUE)
		to_chat(user, "You opened the gift!")
		qdel(src)
	opening = FALSE


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

/mob/living/simple_animal/hostile/gift/AttackingTarget(atom/attacked_target)
	if (istype(target, /mob/living/simple_animal/hostile/abnormality/laetitia))
		manual_emote("pats Laetitia")
		return FALSE
	return ..()

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
