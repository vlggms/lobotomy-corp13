#define STATUS_EFFECT_TEARS /datum/status_effect/tears
#define STATUS_EFFECT_TEARS_LESS /datum/status_effect/tears_less
/mob/living/simple_animal/hostile/abnormality/bottle
	name = "Bottle of Tears"
	desc = "A bottle filled with water with a cake on top"
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "bottle1"
	icon_living = "bottle1"
	maxHealth = 400
	health = 400
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
	threat_level = ZAYIN_LEVEL
	work_chances = list(		//In the comic they work on it. They say you can do any work as long as you don't eat the cake
		ABNORMALITY_WORK_INSTINCT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_INSIGHT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_ATTACHMENT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_REPRESSION = list(50, 40, 30, 30, 30),	//How the fuck do you beat up a cake?
		"Dining" = 100,		//You can instead decide to eat the cake.
		"Drink" = 100			//Or Drink the water
		)
	work_damage_amount = 6
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/little_alice,
		/datum/ego_datum/armor/little_alice
		)
	gift_type =  /datum/ego_gifts/alice
	gift_message = "Welcome to your very own Wonderland~"

	max_boxes = 10
	verb_say = "begs"
	move_to_delay = 5

	var/cake = 5	//How many cake charges are there (4)
	var/speak_cooldown_time = 5 SECONDS
	var/speak_damage = 8
	var/eating = FALSE
	COOLDOWN_DECLARE(speak_damage_aura)

/mob/living/simple_animal/hostile/abnormality/bottle/Initialize(mapload)
	. = ..()
	COOLDOWN_START(src, speak_damage_aura, speak_cooldown_time)

/mob/living/simple_animal/hostile/abnormality/bottle/Life()
	. = ..()
	if(status_flags & GODMODE)
		return
	if(COOLDOWN_FINISHED(src, speak_damage_aura) && !eating)
		COOLDOWN_START(src, speak_damage_aura, speak_cooldown_time)
		say("Drink Me.")
		for(var/mob/living/L in view(vision_range, src))
			if(L == src)
				continue
			if(faction_check_mob(L, FALSE))
				continue
			L.apply_damage(speak_damage, BLACK_DAMAGE, null, run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
		adjustBruteLoss(-speak_damage) // It falls further into desperation
		if(speak_damage < 40)
			speak_damage++

/mob/living/simple_animal/hostile/abnormality/bottle/Move()
	if(!eating)
		return ..()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/bottle/AttackingTarget(atom/attacked_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/bottle/attempt_work(mob/living/carbon/human/user, work_type)
	if(cake)
		if(work_type == "Drink")
			return FALSE
	else
		if(work_type == "Dining")
			return FALSE
		if(work_type == "Drink")
			//it's just work speed
			var/consume_speed = 2 SECONDS / (1 + ((get_attribute_level(user, TEMPERANCE_ATTRIBUTE) + datum_reference.understanding) / 100))
			to_chat(user, "<span class='warning'>You begin to drink the water...</span>")
			datum_reference.working = TRUE
			if(!do_after(user, consume_speed * max_boxes, target = user))
				to_chat(user, "<span class='warning'>You decide to not drink the water.</span>")
				datum_reference.working = FALSE
				return null
			playsound(get_turf(user), 'sound/machines/synth_yes.ogg', 25, FALSE, -4)
			user.apply_status_effect(STATUS_EFFECT_TEARS)
			datum_reference.working = FALSE
			return null
	return TRUE

/mob/living/simple_animal/hostile/abnormality/bottle/work_complete(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	if(work_type == "Dining" && !canceled)
		cake -= 1		//Eat some cake
		if(cake > 0)
			user.adjustBruteLoss(-500) // It heals you to full if you eat it
			to_chat(user, "<span class='nicegreen'>You consume the cake. Delicious!</span>")
			icon_state = "bottle2"	//cake looks eaten
		else
			//Drowns you like Wellcheers does, so I mean the code checks out
			for(var/turf/open/T in view(7, src))
				new /obj/effect/temp_visual/water_waves(T)
			to_chat(user, "<span class='userdanger'>The room is filling with water! You're going to drown!</span>")
			playsound(get_turf(user), 'sound/abnormalities/bottle/bottledrown.ogg', 80, 0)
			icon_state = "bottle3"	//cake all gone

			var/location = get_turf(user)
			new /obj/item/ego_weapon/eyeball(location)

			user.AdjustSleeping(10 SECONDS)
			animate(user, alpha = 0, time = 2 SECONDS)
			QDEL_IN(user, 3.5 SECONDS)
	return ..()

/mob/living/simple_animal/hostile/abnormality/bottle/breach_effect(mob/living/carbon/human/user)
	. = ..()
	ADD_TRAIT(src, TRAIT_MOVE_FLYING, INNATE_TRAIT)
	icon_state = "bottle_breach"

/mob/living/simple_animal/hostile/abnormality/bottle/attack_hand(mob/living/carbon/human/M)
	if(M.a_intent != "help" || (status_flags & GODMODE))
		return ..()
	eating = TRUE
	to_chat(M, "<span class='notice'>You start drinking from the bottle.</span>")
	if(do_after(M, 3 SECONDS, src, IGNORE_HELD_ITEM, interaction_key = src, max_interact_count = 1))
		M.adjustSanityLoss(speak_damage*2) // Heals the mind
		speak_damage = initial(speak_damage)
		to_chat(M, "<span class='nicegreen'>Isn't it wonderful? Your very own Wonderland!</span>")
		M.apply_status_effect(STATUS_EFFECT_TEARS_LESS)
	else
		to_chat(M, "<span class='notice'>You decide against drinking from the bottle...</span>")
		M.apply_damage(speak_damage, WHITE_DAMAGE, null, run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
	eating = FALSE

/datum/status_effect/tears
	id = "tears"
	status_type = STATUS_EFFECT_MULTIPLE	//You should be able to stack this, I hope
	duration = 6000		//Lasts 10 minutes.
	alert_type = /atom/movable/screen/alert/status_effect/tears

/atom/movable/screen/alert/status_effect/tears
	name = "Tearful"
	desc = "You are weakened for a short period of time."
	icon_state = "tearful"

/datum/status_effect/tears/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		to_chat(owner, "<span class='danger'>Something once important to you is gone now. You feel like crying.</span>")
		L.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -20)
		L.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -20)
		L.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -20)
		L.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -20)

/datum/status_effect/tears/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		to_chat(owner, "<span class='nicegreen'>You feel your strength returned to you.</span>")
		L.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 20)
		L.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 20)
		L.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 20)
		L.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 20)

/datum/status_effect/tears_less // Just a sip
	id = "tears"
	status_type = STATUS_EFFECT_MULTIPLE	//You should be able to stack this, I hope
	duration = 3 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/tears

/datum/status_effect/tears_less/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		to_chat(owner, "<span class='userdanger'>You feel your strength sapping away...</span>")
		L.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -10)
		L.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -10)
		L.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -10)
		L.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -10)

/datum/status_effect/tears_less/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		to_chat(owner, "<span class='nicegreen'>You feel your strength returned to you.</span>")
		L.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 10)
		L.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 10)
		L.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 10)
		L.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 10)

#undef STATUS_EFFECT_TEARS
#undef STATUS_EFFECT_TEARS_LESS
