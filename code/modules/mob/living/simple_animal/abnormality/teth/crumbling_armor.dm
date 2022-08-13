/mob/living/simple_animal/hostile/abnormality/crumbling_armor
	name = "Crumbling Armor"
	desc = "A thoroughly aged suit of samurai style armor with a V shaped crest on the helmet. It appears desuetude."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "crumbling"
	maxHealth = 600
	health = 600
	threat_level = TETH_LEVEL
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

	var/buff_icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	var/foolish_samurai_warrior[0]

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/Initialize(mapload)
	. = ..()
	// Megalovania?
	if (prob(1))
		icon_state = "megalovania"

/mob/living/simple_animal/hostile/abnormality/crumbling_armor/proc/Cut_Head(datum/source, datum/abnormality/datum_sent, mob/living/carbon/human/user, work_type)
	SIGNAL_HANDLER
	if (work_type != ABNORMALITY_WORK_ATTACHMENT)
		return
	UnregisterSignal(user, COMSIG_WORK_STARTED)
	var/obj/item/bodypart/head/head = user.get_bodypart("head")
	//Thanks Red Queen
	if(!istype(head))
		return FALSE
	user.cut_overlay(mutable_appearance(buff_icon, "courage", -ABOVE_MOB_LAYER))
	user.cut_overlay(mutable_appearance(buff_icon, "recklessFirst", -ABOVE_MOB_LAYER))
	user.cut_overlay(mutable_appearance(buff_icon, "recklessSecond", -ABOVE_MOB_LAYER))
	user.cut_overlay(mutable_appearance(buff_icon, "foolish", -ABOVE_MOB_LAYER))
	head.dismember()
	foolish_samurai_warrior -= user
	user.adjustBruteLoss(500)
	return TRUE

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
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		if (user in foolish_samurai_warrior)
			switch (foolish_samurai_warrior[user])
				if(1) // From Courage to Recklessness
					playsound(get_turf(user), 'sound/machines/clockcult/stargazer_activate.ogg', 50, 0, 2)
					user.cut_overlay(mutable_appearance(buff_icon, "courage", -ABOVE_MOB_LAYER))
					user.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -5)
					user.add_overlay(mutable_appearance(buff_icon, "recklessFirst", -ABOVE_MOB_LAYER))
					to_chat(user, "<span class='userdanger'>Your muscles flex with strength!</span>")
					foolish_samurai_warrior[user] = 2
					return
				if(2) // From Recklessness to Foolishness
					playsound(get_turf(user), 'sound/machines/clockcult/stargazer_activate.ogg', 50, 0, 2)
					user.cut_overlay(mutable_appearance(buff_icon, "recklessFirst", -ABOVE_MOB_LAYER))
					user.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -5)
					user.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 5)
					user.add_overlay(mutable_appearance(buff_icon, "recklessSecond", -ABOVE_MOB_LAYER))
					to_chat(user, "<span class='userdanger'>You feel like you could take on the world!</span>")
					foolish_samurai_warrior[user] = 3
					return
				if(3) // From Foolishness to Suicidal
					playsound(get_turf(user), 'sound/machines/clockcult/stargazer_activate.ogg', 50, 0, 2)
					user.cut_overlay(mutable_appearance(buff_icon, "recklessSecond", -ABOVE_MOB_LAYER))
					user.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -10)
					user.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 5)
					user.add_overlay(mutable_appearance(buff_icon, "foolish", -ABOVE_MOB_LAYER))
					to_chat(user, "<span class='userdanger'>You are a God among men!</span>")
					foolish_samurai_warrior[user] = 4
					return
				if(4) // You can progress no further down this fool-hardy path
					return
		else // Give Courage
			playsound(get_turf(user), 'sound/machines/clockcult/stargazer_activate.ogg', 50, 0, 2)
			user.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 10)
			user.add_overlay(mutable_appearance(buff_icon, "courage", -ABOVE_MOB_LAYER))
			to_chat(user, "<span class='userdanger'>A strange power flows through you!</span>")
			RegisterSignal(user, COMSIG_WORK_STARTED, .proc/Cut_Head)
			foolish_samurai_warrior[user] = 1
	return
