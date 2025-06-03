//The Same thing as the mushroom punch, but now with the cuckoo bird infection.
/datum/martial_art/cuckoopunch
	name = "jiajiaren Brutality"
	id = MARTIALART_CUCKOOPUNCH
	var/datum/action/cuckoo_implant/implant = new/datum/action/cuckoo_implant()

/datum/martial_art/cuckoopunch/teach(mob/living/owner, make_temporary=FALSE)
	if(..())
		to_chat(owner, span_nicegreen("You know the arts of [name]!"))
		to_chat(owner, span_danger("Place your cursor over a move at the top of the screen to see what it does."))
		implant.Grant(owner)

/datum/martial_art/cuckoopunch/on_remove(mob/living/owner)
	to_chat(owner, span_userdanger("You suddenly forget the arts of [name]..."))
	implant.Remove(owner)

/datum/action/cuckoo_implant
	name = "Jiajiaren Implant - After a delay, knock the target back and if they are human, implant them with a Jiajiaren Parasite. If they are a mob, deal extra damage."
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "lungpunch"

/datum/action/cuckoo_implant/Trigger()
	if(owner.incapacitated())
		to_chat(owner, span_warning("You can't use [name] while you're incapacitated."))
		return
	if (owner.mind.martial_art.streak == "cuckoo_implant")
		owner.visible_message(span_danger("[owner] assumes a neutral stance."), "<b><i>Your next attack is cleared.</i></b>")
		owner.mind.martial_art.streak = ""
	else
		owner.visible_message(span_danger("[owner] assumes the threatening stance!"), "<b><i>Your next attack will be a Cuckoo Implant.</i></b>")
		owner.mind.martial_art.streak = "cuckoo_implant"

/datum/martial_art/cuckoopunch/proc/check_streak(mob/living/A, mob/living/D)
	switch(streak)
		if("cuckoo_implant")
			streak = ""
			cuckoo_implant(A,D)
			return TRUE
	return FALSE

//Copy of the krav_maga, however changed to fit LC13 and the cuckoo flavor
/datum/martial_art/cuckoopunch/harm_act(mob/living/A, mob/living/D)
	if(check_streak(A,D))
		return TRUE
	log_combat(A, D, "punched")
	var/obj/item/bodypart/affecting = D.get_bodypart(ran_zone(A.zone_selected))
	var/armor_block = D.run_armor_check(affecting, RED_DAMAGE)
	var/picked_hit_type = pick("punch", "kick")
	var/bonus_damage = 0
	if(D.body_position == LYING_DOWN)
		bonus_damage += 10
		picked_hit_type = "stomp"
	D.apply_damage(rand(24,27) + bonus_damage, RED_DAMAGE, affecting, armor_block)
	playsound(get_turf(D), 'sound/abnormalities/big_wolf/Wolf_Scratch.ogg', 50, TRUE, -1)
	if(picked_hit_type == "kick" || picked_hit_type == "stomp")
		A.do_attack_animation(D, ATTACK_EFFECT_KICK)
	else
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
	D.visible_message(span_danger("[A] [picked_hit_type]s [D]!"), \
					span_userdanger("You're [picked_hit_type]ed by [A]!"), span_hear("You hear a sickening sound of flesh hitting flesh!"), COMBAT_MESSAGE_RANGE, A)
	to_chat(A, span_danger("You [picked_hit_type] [D]!"))
	log_combat(A, D, "[picked_hit_type] with [name]")
	return TRUE

/datum/martial_art/cuckoopunch/proc/cuckoo_implant(mob/living/A, mob/living/D)
	to_chat(A, span_spiderbroodmother("You begin to wind up an attack..."))
	if(!do_after(A, 10, target = D))
		to_chat(A, span_spiderbroodmother("<b>Your attack was interrupted!</b>"))
		return TRUE //martial art code was a mistake
	var/atk_verb
	A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
	atk_verb = pick("punch", "smash", "crack")
	D.visible_message(span_danger("[A] [atk_verb]ed [D] with such inhuman strength that it sends [D.p_them()] flying backwards!"), \
					span_userdanger("You're [atk_verb]ed by [A] with such inhuman strength that it sends you flying backwards!"), span_hear("You hear a sickening sound of flesh hitting flesh!"), null, A)
	to_chat(A, span_danger("You [atk_verb] [D] with such inhuman strength that it sends [D.p_them()] flying backwards!"))
	D.apply_damage(rand(40, 50), RED_DAMAGE)
	playsound(D, 'sound/effects/meteorimpact.ogg', 25, TRUE, -1)
	var/throwtarget = get_edge_target_turf(A, get_dir(A, get_step_away(D, A)))
	D.throw_at(throwtarget, 4, 2, A)//So stuff gets tossed around at the same time.
	if(ishuman(D) && D.stat != DEAD)
		var/mob/living/carbon/human/human_target = D
		var/obj/item/bodypart/chest/LC = human_target.get_bodypart(BODY_ZONE_CHEST)
		if((!LC || LC.status != BODYPART_ROBOTIC) && !human_target.getorgan(/obj/item/organ/body_egg/cuckoospawn_embryo))
			to_chat(A, span_danger("You implant [D], soon a new jiajiaren bird shall grow..."))
			new /obj/item/organ/body_egg/cuckoospawn_embryo(human_target)
			var/turf/T = get_turf(human_target)
			log_game("[key_name(human_target)] was impregnated by a jiajiaren at [loc_name(T)]")
	if(isanimal(D))
		D.apply_damage(rand(150), RED_DAMAGE)
	if(atk_verb)
		log_combat(A, D, "[atk_verb] (Cuckoo Punch)")

/datum/martial_art/cuckoopunch/disarm_act(mob/living/A, mob/living/D)
	if(ishostile(D))
		var/mob/living/simple_animal/hostile/hostile_friend = D
		if(!A.faction_check_mob(hostile_friend, TRUE))
			to_chat(src, span_notice("They are dealing with their own thing, don't bother them."))
			return FALSE
