//The Same thing as the mushroom punch, but now with the cuckoo bird infection.
/datum/martial_art/cuckoopunch
	name = "Niaojia-ren Brutality"
	id = MARTIALART_CUCKOOPUNCH
	var/datum/action/cuckoo_implant/implant = new/datum/action/cuckoo_implant()
	var/datum/action/cuckoo_remember/remember = new/datum/action/cuckoo_remember()
	var/datum/action/cooldown/cuckoo_retreat/retreat = new/datum/action/cooldown/cuckoo_retreat()

/datum/martial_art/cuckoopunch/teach(mob/living/owner, make_temporary=FALSE)
	if(..())
		to_chat(owner, span_nicegreen("You know the arts of [name]!"))
		to_chat(owner, span_danger("Place your cursor over a move at the top of the screen to see what it does."))
		implant.Grant(owner)
		remember.Grant(owner)
		retreat.Grant(owner)

/datum/martial_art/cuckoopunch/on_remove(mob/living/owner)
	to_chat(owner, span_userdanger("You suddenly forget the arts of [name]..."))
	implant.Remove(owner)
	remember.Remove(owner)
	retreat.Remove(owner)

/datum/action/cuckoo_implant
	name = "Niaojia-ren Implant - After a delay, knock the target back and if they are human, implant them with a Niaojia-ren Parasite. If they are a mob, deal extra damage."
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

/datum/action/cuckoo_remember
	name = "Niaojia-ren Info - Remember info about how to play as the Niaojia-ren."
	icon_icon = 'icons/mob/cuckoospawn.dmi'
	button_icon_state = "bigolredeyes"

/datum/action/cuckoo_remember/Trigger()
	to_chat(owner, span_info("You are a Niaojia-ren, the vulture of the ruins.<br><br>\
		<b>OFFERINGS</b><br>\
		You have a statue in your nest, you are able to offer it meat to gain your god's favor, which you can then use to gather new items by touching the statue.<br>\
		You can also directly offer the bodies to your god, by draging them onto your statue. This will generate extra meat for your god.<br>\
		The 3 items that you can get from the statue are healing salves, banners, and boluses which and bring back fallen Niaojia-rens.<br>\
		However, you don't need to offer all of your meat. You should keep some, you do need to eat...<br>\
		<b>TERRITORY</b><br>\
		You are a territorial species, and you are stronger while within it. You are able to gather banners from your statue, which you can place down on your existing territory.<br>\
		You can tell if you are in your territory when your vision grows RED and you get a status effect called 'Hunter'<br>\
		<b>COMBAT</b><br>\
		You have a Niaojia-ren Implant skill which when activated, will cause your next attack to have a delay, but it will deal MASSIVE damage to non-humans.<br>\
		You can also tackle humans. You can initiate a tackle by entering throw mode and then clicking on a human with an empty hand. This will inflict tremor, which will build up to a stun.<br>\
		You can activate your Retreat skill, which will give you a burst of speed. At the cost of being slowed down if they are spotted by humans after the speed wears off.<br>\
		<b>INFECTION</b><br>\
		You are able to grow your numbers by infecting humans with your embryo. There are 3 ways of infecting humans.<br>\
		1. You can tackle humans for a decent chance (30%) of infecting them.<br>\
		2. You can melee attack humans for a low chance (5%) of infecting them.<br>\
		3. You are able to create bolus from your statue. If a human eats one of them, they will fully heal but have a chance at becoming infected.<br>\
		It takes 10 minutes for a person to birth a new niaojia-ren, and this timer stops while they are dead.<br>\
		<b>ORDERING</b><br>\
		You are able to order simple minded niaojia-ren to follow you around by touching them with your hand.<br>\
		You can also tell them to avoid attacking humans, allowing you to set up ambushes.<br>\
		<b>HUMANS</b><br>\
		Your prey, your job is to purely to hunt them down. Don't mess with their bodies, there is no need.<br>\
		DO NOT enter their home past the gates, the head is always watching and will kill you if you enter."))

/datum/action/cooldown/cuckoo_retreat
	cooldown_time = 40 SECONDS
	name = "Niaojia-ren - Retreat"
	desc = "Greatly increase movespeed for 5 seconds, if there are humans nearby after 5 seconds, become GREATLY slowed down."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "assault"

/datum/action/cooldown/cuckoo_retreat/Trigger()
	. = ..()
	if(!.)
		return FALSE
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		human.add_movespeed_modifier(/datum/movespeed_modifier/cuckoo_retreat)
		to_chat(human, span_nicegreen("You get a burst of adrenaline... You better retreat now!"))
		addtimer(CALLBACK(human, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/cuckoo_retreat), 4 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		addtimer(CALLBACK(src, PROC_REF(slowdown_check)), 4.1 SECONDS)
		StartCooldown()

/datum/action/cooldown/cuckoo_retreat/proc/slowdown_check()
	var/spotted = FALSE
	for(var/mob/living/carbon/human/nearby_human in range(5, owner))
		if(istype(nearby_human, /mob/living/carbon/human/species/cuckoospawn))
			continue
		else
			if(nearby_human.stat != DEAD)
				spotted = TRUE
				break
	if(spotted)
		if(ishuman(owner))
			to_chat(owner, span_danger("There are nearby humans after your retreat, you are now slowed down..."))
			var/mob/living/carbon/human/human = owner
			human.add_movespeed_modifier(/datum/movespeed_modifier/cuckoo_spotted)
			addtimer(CALLBACK(human, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/cuckoo_spotted), 4 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
			human.adjustStaminaLoss(150)

/datum/movespeed_modifier/cuckoo_retreat
	variable = TRUE
	multiplicative_slowdown = -1.5

/datum/movespeed_modifier/cuckoo_spotted
	variable = TRUE
	multiplicative_slowdown = 1

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
	if(A.has_status_effect(/datum/status_effect/hunter))
		D.apply_damage(rand(25,30) + bonus_damage, RED_DAMAGE, affecting, armor_block)
		if(ishuman(D) && D.stat != DEAD && prob(5))
			var/mob/living/carbon/human/human_target = D
			var/obj/item/bodypart/chest/LC = human_target.get_bodypart(BODY_ZONE_CHEST)
			if((!LC || LC.status != BODYPART_ROBOTIC) && !human_target.getorgan(/obj/item/organ/body_egg/cuckoospawn_embryo) && !HAS_TRAIT(human_target, TRAIT_XENO_IMMUNE))
				to_chat(A, span_danger("You implant [D], soon a new niaojia-ren bird shall grow..."))
				new /obj/item/organ/body_egg/cuckoospawn_embryo(human_target)
				var/turf/T = get_turf(human_target)
				log_game("[key_name(human_target)] was infected by a niaojia-ren at [loc_name(T)]")
	else
		to_chat(A, span_warning("You attack pathetically, re-enter your territory!"))
		D.apply_damage(rand(10,14) + bonus_damage, RED_DAMAGE, affecting, armor_block)
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
	if(!isanimal(D))
		to_chat(A, span_spiderbroodmother("You wish to not kill this prey..."))
		return TRUE
	else
		to_chat(A, span_spiderbroodmother("You begin to wind up an attack..."))
		if(!do_after(A, 10, target = D))
			to_chat(A, span_spiderbroodmother("<b>Your attack was interrupted!</b>"))
			return TRUE
		var/atk_verb
		A.do_attack_animation(D, ATTACK_EFFECT_PUNCH)
		atk_verb = pick("punch", "smash", "crack")
		D.visible_message(span_danger("[A] [atk_verb]ed [D] with such inhuman strength!"), \
						span_userdanger("You're [atk_verb]ed by [A] with such inhuman strength!"), span_hear("You hear a sickening sound of flesh hitting flesh!"), null, A)
		to_chat(A, span_danger("You [atk_verb] [D] with such inhuman strength!"))
		playsound(D, 'sound/effects/meteorimpact.ogg', 25, TRUE, -1)
		if(A.has_status_effect(/datum/status_effect/hunter))
			D.apply_damage(150, RED_DAMAGE)
		else
			D.apply_damage(75, RED_DAMAGE)
			to_chat(A, span_warning("You attack pathetically, re-enter your territory!"))
		if(atk_verb)
			log_combat(A, D, "[atk_verb] (Cuckoo Punch)")

/datum/martial_art/cuckoopunch/grab_act(mob/living/A, mob/living/D)
	if(ishuman(D) && D.stat == DEAD)
		to_chat(A, span_warning("They are already dead, they are of no use to you."))
		return TRUE
	. = ..()

/datum/martial_art/cuckoopunch/disarm_act(mob/living/A, mob/living/D)
	if(ishuman(D) && D.stat == DEAD)
		to_chat(A, span_warning("They are already dead, they are of no use to you."))
		return TRUE
	. = ..()
