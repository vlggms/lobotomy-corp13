/obj/effect/custom_mine
	name = "mine"
	desc = "Better stay away from that thing"
	density = FALSE
	anchored = TRUE
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "uglymine"
	var/triggered = FALSE
	var/trigger_on_flying = FALSE
	var/obj/effect/held_effect
	var/stay_after_trigger = FALSE
	var/silent = FALSE
	var/retrigger_cooldown = 1
	var/human_only = FALSE

/obj/effect/custom_mine/Initialize(obj/effect/E)
	. = ..()
	if(E)
		held_effect = E

/obj/effect/custom_mine/proc/mineEffect(mob/victim)
	if(!silent)
		to_chat(victim, span_danger("*click*"))
	if(ispath(held_effect, /obj/effect/adminbus/targeted))
		new held_effect(get_turf(src), victim)
	else
		new held_effect(get_turf(src))

/obj/effect/custom_mine/proc/safety_check(atom/movable/on_who)
	if(triggered || !isturf(loc) || on_who && iseffect(on_who))
		return TRUE
	return FALSE

/obj/effect/custom_mine/proc/trigger_mine(atom/movable/triggerer)
	if(triggered)
		return
	if(human_only && !ispath(triggerer, /mob/living/carbon/human))
		return
	if(!silent)
		if(triggerer)
			visible_message(span_danger("[triggerer] sets off [icon2html(src, viewers(src))] [src]!"))
		else
			visible_message(span_danger("[icon2html(src, viewers(src))] [src] detonates!"))

		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(3, 1, src)
		s.start()
	if(ismob(triggerer))
		mineEffect(triggerer)
	triggered = TRUE
	SEND_SIGNAL(src, COMSIG_MINE_TRIGGERED, triggerer)
	if(!stay_after_trigger)
		qdel(src)
	else
		addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/effect/custom_mine, untrigger), retrigger_cooldown))

/obj/effect/custom_mine/proc/untrigger()
	triggered = FALSE

/obj/effect/custom_mine/Crossed(atom/movable/AM)
	if(safety_check(AM))
		return
	. = ..()

	if(!trigger_on_flying && AM.movement_type & FLYING)
		return

	if(!ismob(AM))
		return

	trigger_mine(AM)

/obj/effect/custom_mine/take_damage(damage_amount, damage_type, sound_effect, attack_dir)
	if(safety_check())
		return
	. = ..()
	trigger_mine()

/obj/effect/custom_mine/gravitychaos
	held_effect = /obj/effect/adminbus/gravitychaos

/obj/effect/custom_mine/gravitychaos_targeted
	held_effect = /obj/effect/adminbus/targeted/gravitychaos
