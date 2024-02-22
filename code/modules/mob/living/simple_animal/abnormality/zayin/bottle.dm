#define STATUS_EFFECT_TEARS /datum/status_effect/tears
#define STATUS_EFFECT_TEARS_LESS /datum/status_effect/tears/less
/mob/living/simple_animal/hostile/abnormality/bottle
	name = "Bottle of Tears"
	desc = "A bottle filled with water with a cake on top"
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "bottle1"
	icon_living = "bottle1"
	portrait = "bottle"
	maxHealth = 800
	health = 800
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
	threat_level = ZAYIN_LEVEL
	work_chances = list( //In the comic they work on it. They say you can do any work as long as you don't eat the cake
		ABNORMALITY_WORK_INSTINCT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_INSIGHT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_ATTACHMENT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_REPRESSION = list(50, 40, 30, 30, 30), //How the fuck do you beat up a cake?
		"Dining" = 100, //You can instead decide to eat the cake.
		"Drink" = 100, //Or Drink the water
	)
	work_damage_amount = 6
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/little_alice,
		/datum/ego_datum/armor/little_alice,
	)
	gift_type = /datum/ego_gifts/alice
	gift_message = "Welcome to your very own Wonderland~"
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	max_boxes = 10
	verb_say = "begs"
	move_to_delay = 5

	melee_damage_lower = 4
	melee_damage_upper = 8
	melee_damage_type = WHITE_DAMAGE

	attack_verb_continuous = "begs"
	attack_verb_simple = "beg"

	var/cake = 5 //How many cake charges are there (4)
	var/speak_cooldown_time = 5 SECONDS
	var/speak_damage = 8
	var/eating = FALSE
	COOLDOWN_DECLARE(speak_damage_aura)

	chem_type = /datum/reagent/abnormality/bottle
	harvest_phrase = span_notice("You sweep up some crumbs from around %ABNO into %VESSEL.")
	harvest_phrase_third = "%PERSON sweeps up crumbs from around %ABNO into %VESSEL."

/mob/living/simple_animal/hostile/abnormality/bottle/Life()
	. = ..()
	if(!.)
		return
	if(COOLDOWN_FINISHED(src, speak_damage_aura) && !eating)
		COOLDOWN_START(src, speak_damage_aura, speak_cooldown_time)
		if(!client)
			say("Drink Me.")
		for(var/mob/living/L in view(vision_range, src))
			if(L == src)
				continue
			if(faction_check_mob(L, FALSE))
				continue
			L.apply_damage(speak_damage, BLACK_DAMAGE, null, run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
		adjustBruteLoss(-speak_damage) // It falls further into desperation
		if(speak_damage < 40)
			speak_damage += 4

/mob/living/simple_animal/hostile/abnormality/bottle/Move()
	if(!eating)
		return ..()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/bottle/AttackingTarget(atom/attacked_target)
	if(eating)
		return
	if(isliving(target))
		var/mob/living/L = target
		if(faction_check_mob(L))
			L.visible_message(span_danger("[src] feeds [L]... [L] seems heartier!"), span_nicegreen("[src] feeds you, you feel heartier!"))
			L.adjustBruteLoss(-speak_damage/2)
			return
	return ..()

/mob/living/simple_animal/hostile/abnormality/bottle/AttemptWork(mob/living/carbon/human/user, work_type)
	if(!cake)
		if(work_type == "Dining")
			return FALSE

	if(work_type == "Drink")
		//it's just work speed
		var/consume_speed = 2 SECONDS / (1 + ((get_attribute_level(user, TEMPERANCE_ATTRIBUTE) + datum_reference.understanding) / 100))
		to_chat(user, span_warning("You begin to drink the water..."))
		datum_reference.working = TRUE
		if(!do_after(user, consume_speed * max_boxes, target = user))
			to_chat(user, span_warning("You decide to not drink the water."))
			datum_reference.working = FALSE
			return null
		playsound(get_turf(user), 'sound/machines/synth_yes.ogg', 25, FALSE, -4)
		user.apply_status_effect(STATUS_EFFECT_TEARS)
		datum_reference.working = FALSE
		return null

	return TRUE

/mob/living/simple_animal/hostile/abnormality/bottle/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	if(work_type == "Dining" && !canceled)
		cake -= 1 //Eat some cake
		if(cake > 0)
			user.adjustBruteLoss(-500) // It heals you to full if you eat it
			to_chat(user, span_nicegreen("You consume the cake. Delicious!"))
			icon_state = "bottle2" //cake looks eaten
		else
			//Drowns you like Wellcheers does, so I mean the code checks out
			for(var/turf/open/T in view(7, src))
				new /obj/effect/temp_visual/water_waves(T)
			playsound(get_turf(user), 'sound/abnormalities/bottle/bottledrown.ogg', 80, 0)
			icon_state = "bottle3" //cake all gone

			/* "I get it now. There's no reason to have any emotions or a heart."
			"Abandon reason and protect Catt! That's how you survive in this wonderland!"
			Catt was a low level agent with temperance and fortitude. She sought to abandon that temperance in exchange for justice.
			Thus, bottle will check for those. Overall low level, high temperance, high fortitude.
			Keep in mind that this event can happen ONCE PER ROUND. The spoon is already jokingly called the protagonist weapon, so it can bend the rules a bit, right?*/

			new /obj/item/ego_weapon/eyeball(get_turf(user))

			var/fortitude = get_attribute_level(user, FORTITUDE_ATTRIBUTE)
			var/prudence = get_attribute_level(user, PRUDENCE_ATTRIBUTE)
			var/temperance = get_attribute_level(user, TEMPERANCE_ATTRIBUTE)
			var/justice = get_attribute_level(user, JUSTICE_ATTRIBUTE)
			var/goal_damage = 0
			if(temperance >= (fortitude + prudence + justice) / 1.5) // If your temperance is at least twice your average stat, you aren't hurt, but lose temperance.
				to_chat(user, span_userdanger("The room is filling with water... but you feel oddly unconcerned."))
				user.adjust_attribute_level(TEMPERANCE_ATTRIBUTE, 20 - temperance)
				// This is a PERMANENT stat change, VERY significant. But it can happen only once per round. You're The Protagonist, after all.
				var/stat_change = 0
				stat_change = temperance - 20
				user.adjust_attribute_buff(JUSTICE_ATTRIBUTE, stat_change) // Gain benefit from what you lost.
				addtimer(CALLBACK(src, PROC_REF(DecayProtagonistBuff), user, stat_change), 20 SECONDS) // Short grace period. 10s of this happens while you're asleep.
			else
				to_chat(user, span_userdanger("The room is filling with water! Are you going to drown?!"))
				goal_damage = 99999 // DIE.
				if(fortitude >= (prudence + justice)) // Like the temperance calculation, but high temperance doesn't actively hurt your odds.
					goal_damage = 120 + fortitude // Hurt bad, but never lethally.

			user.AdjustSleeping(10 SECONDS)
			user.adjustBruteLoss(goal_damage)
			if(user.stat == DEAD)
				animate(user, alpha = 0, time = 2 SECONDS)
				QDEL_IN(user, 3.5 SECONDS)
			else
				user.adjustBruteLoss(-(goal_damage * 0.25)) // If you didn't die instantly, heal up some.
	return

/mob/living/simple_animal/hostile/abnormality/bottle/proc/DecayProtagonistBuff(mob/living/carbon/human/buffed, justice = 0)
	// Goes faster when the buff is higher, so you don't have an overwhelming buff for an overwhelming length of time.
	if(justice <= 0 || !buffed)
		return FALSE
	var/factor = justice / 10
	var/timing = 10 + max(0, (100 - factor * factor))
	buffed.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -1)
	if(prob(10))
		buffed.adjust_attribute_level(JUSTICE_ATTRIBUTE, 1) // 10% chance for justice buff to become real justice as it decays.
	addtimer(CALLBACK(src, PROC_REF(DecayProtagonistBuff), buffed, justice - 1), timing)

/mob/living/simple_animal/hostile/abnormality/bottle/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_PINK)
		ADD_TRAIT(src, TRAIT_MOVE_FLYING, INNATE_TRAIT)
		COOLDOWN_START(src, speak_damage_aura, speak_cooldown_time)
		icon_state = "bottle_breach"
		desc = "A floating bottle, leaking tears.\nYou can use an empty hand to drink from it."
		can_breach = TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/bottle/attack_hand(mob/living/carbon/human/M)
	if(M.a_intent != "help" || (status_flags & GODMODE))
		return ..()
	if(eating)
		to_chat(M, span_notice("Someone else is already drinking from [src], it'd be kinda weird to join them..."))
		return
	eating = TRUE
	to_chat(M, span_notice("You start drinking from the bottle.</span>"))
	if(do_after(M, 2 SECONDS, src, IGNORE_HELD_ITEM, interaction_key = src, max_interact_count = 1))
		M.adjustSanityLoss(speak_damage*4) // Heals the mind
		speak_damage = initial(speak_damage)
		to_chat(M, span_nicegreen("Isn't it wonderful? Your very own Wonderland!"))
		M.apply_status_effect(STATUS_EFFECT_TEARS_LESS)
	else
		to_chat(M, span_notice("You decide against drinking from the bottle..."))
		M.apply_damage(speak_damage, WHITE_DAMAGE, null, run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
	eating = FALSE

/mob/living/simple_animal/hostile/abnormality/bottle/ListTargets()
	. = ..()
	for(var/mob/living/carbon/human/H in .)
		if(H.sanity_lost)
			. -= H
			continue

/datum/status_effect/tears
	id = "tears"
	status_type = STATUS_EFFECT_MULTIPLE	//You should be able to stack this, I hope
	duration = 5 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/tears
	var/scaling = 20

/atom/movable/screen/alert/status_effect/tears
	name = "Tearful"
	desc = "Your attributes are weakened for a short period of time."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "tearful"

/datum/status_effect/tears/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	to_chat(owner, span_danger("Something once important to you is gone now. You feel like crying."))
	status_holder.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -scaling)
	status_holder.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -scaling)
	status_holder.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -scaling)
	status_holder.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -scaling)

/datum/status_effect/tears/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	to_chat(owner, span_nicegreen("You feel your strength return to you."))
	status_holder.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, scaling)
	status_holder.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, scaling)
	status_holder.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, scaling)
	status_holder.adjust_attribute_buff(JUSTICE_ATTRIBUTE, scaling)

/datum/status_effect/tears/less
	duration = 2 MINUTES
	scaling = 10

#undef STATUS_EFFECT_TEARS
#undef STATUS_EFFECT_TEARS_LESS

/datum/reagent/abnormality/bottle
	name = "Crumbs"
	description = "A small pile of slightly soggy crumbs."
	reagent_state = SOLID
	color = "#ad8978"
	health_restore = 2
	stat_changes = list(-4, -4, -4, -4)
