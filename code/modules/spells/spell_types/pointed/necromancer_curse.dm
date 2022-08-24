/obj/effect/proc_holder/spell/pointed/necromancer_curse
	name = "Necromantic Curse"
	desc = "A spell that will heavily damage the undead. Use against your ungrateful 'servants'."
	school = "transmutation"
	charge_type = "recharge"
	charge_max = 40
	charge_counter = 0
	clothes_req = TRUE
	stat_allowed = TRUE
	invocation = "D'thi U'n Ye!"
	invocation_type = INVOCATION_SHOUT
	range = 7
	cooldown_min = 15
	ranged_mousepointer = 'icons/effects/mouse_pointers/cult_target.dmi'
	action_icon_state = "zap"
	active_msg = "You prepare to curse a target..."
	deactive_msg = "You dispel the curse..."
	sound = 'sound/effects/curseattack.ogg'

/obj/effect/proc_holder/spell/pointed/necromancer_curse/cast(list/targets, mob/user)
	if(!targets.len)
		to_chat(user, "<span class='warning'>No target found in range!</span>")
		return FALSE
	if(!can_target(targets[1], user))
		return FALSE

	var/mob/living/carbon/human/target = targets[1]
	if(target.anti_magic_check())
		to_chat(user, "<span class='warning'>The spell had no effect!</span>")
		target.visible_message("<span class='danger'>[target] was unaffected by the curse!</span>", \
						"<span class='danger'>You feel sharp pain in your bones, but it stops soon enough.</span>")
		return FALSE

	target.visible_message("<span class='danger'>Shadows grow onto [target]!</span>", \
						   "<span class='danger'>You feel sharp pain coming from your bones as shadows grow larger!</span>")

	// Death upon you
	target.Paralyze(25)
	target.Jitter(25)
	target.adjustBruteLoss(20)
	target.adjustFireLoss(20)
	playsound(target, 'sound/effects/curseattack.ogg', 70, 1)
	new /obj/effect/temp_visual/cult/sparks(get_turf(target))

/obj/effect/proc_holder/spell/pointed/necromancer_curse/can_target(atom/target, mob/user, silent)
	. = ..()
	if(!.)
		return FALSE
	if(isskeleton(target) || isvampire(target) || iszombie(target))
		return TRUE
	if(!silent)
		to_chat(user, "<span class='warning'>You are unable to curse [target]!</span>")
	return FALSE
