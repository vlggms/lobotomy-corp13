/mob/living/simple_animal/hostile/abnormality/bald
	name = "You’re Bald..."
	desc = "A helpful sphere, you think."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "bald1"
	icon_living = "bald1"
	portrait = "bald"
	maxHealth = 50
	health = 50
	damage_coeff = list(RED_DAMAGE = 2, WHITE_DAMAGE = 0, BLACK_DAMAGE = 2, PALE_DAMAGE = 2)
	is_flying_animal = TRUE
	threat_level = ZAYIN_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 0,
		ABNORMALITY_WORK_INSIGHT = 0,
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = 0,
	)
	work_damage_amount = 4
	work_damage_type = BLACK_DAMAGE

	melee_damage_lower = -1
	melee_damage_upper = -1
	melee_damage_type = WHITE_DAMAGE
	attack_verb_continuous = "balds"
	attack_verb_simple = "bald"

	ranged = TRUE
	ranged_message = "balds"
	projectiletype = /obj/projectile/beam/yang/bald
	projectilesound = 'sound/weapons/sear.ogg'

	ego_list = list(
		/datum/ego_datum/weapon/tough,
		/datum/ego_datum/armor/tough,
	)
	gift_type =  /datum/ego_gifts/tough
	gift_chance = 10
	gift_message = "Now we're feeling awesome!"
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY
	harvest_phrase = span_notice("You squeeze %ABNO. Some juice drips into %VESSEL.")
	harvest_phrase_third = "%PERSON squeezes %ABNO. Some juice drips into %VESSEL."

	observation_prompt = "This abnormality is filled with dreams of bald people. Are you balding, or already bald?"
	observation_choices = list(
		"Yes" = list(TRUE, "Lobotomy Corporation welcomes you."),
		"No" = list(FALSE, "Come back after watching the fast and the furious 7 five more times."),
	)

	var/bald_users = list()
	chem_type = /datum/reagent/abnormality/bald

/mob/living/simple_animal/hostile/abnormality/bald/WorkChance(mob/living/carbon/human/user, chance)
	if(HAS_TRAIT(user, TRAIT_BALD))
		return 95
	return chance

/mob/living/simple_animal/hostile/abnormality/bald/WorktickSuccess(mob/living/carbon/human/user)
	if(HAS_TRAIT(user, TRAIT_BALD))
		user.adjustSanityLoss(-user.maxSanity * 0.05) // Half of sanity restored for bald people
	return ..()

/mob/living/simple_animal/hostile/abnormality/bald/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(pe >= datum_reference.max_boxes)
		user.apply_bald()

/mob/living/simple_animal/hostile/abnormality/bald/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(!do_bald(user)) // Already bald
		return
	bald_users |= user.ckey
	update_icon()
	switch(length(bald_users))
		if(2)
			for(var/mob/living/carbon/human/H in livinginrange(18, user))
				if(prob(35))
					do_bald(H)
		if(4)
			for(var/mob/living/carbon/human/H in livinginrange(36, user))
				if(prob(35))
					do_bald(H)
		if(6) // Everyone is bald! Awesome!
			for(var/mob/living/carbon/human/H in GLOB.human_list)
				if(H.z == z)
					do_bald(H)

/mob/living/simple_animal/hostile/abnormality/bald/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_PINK)
		can_breach = TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/bald/proc/do_bald(mob/living/carbon/human/victim)
	if(!HAS_TRAIT(victim, TRAIT_BALD))
		ADD_TRAIT(victim, TRAIT_BALD, "ABNORMALITY_BALD")
		victim.hairstyle = "Bald"
		victim.update_hair()
		victim.playsound_local(victim, 'sound/abnormalities/bald/bald_special.ogg', 50, FALSE)
		victim.add_overlay(icon('ModularTegustation/Teguicons/tegu_effects.dmi', "bald_blast"))
		addtimer(CALLBACK(victim, TYPE_PROC_REF(/atom, cut_overlay), \
								icon('ModularTegustation/Teguicons/tegu_effects.dmi', "bald_blast")), 20)
		to_chat(victim, span_notice("You feel awesome!"))
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/bald/update_icon_state()
	switch(length(bald_users))
		if(3 to 5)
			icon_state = "bald2"
		if(6 to INFINITY)
			icon_state = "bald3"
		else
			icon_state = "bald1"

/mob/living/simple_animal/hostile/abnormality/bald/ListTargets()
	. = ..()
	for(var/mob/living/carbon/human/not_bald in .)
		if(HAS_TRAIT(not_bald, TRAIT_BALD))
			. -= not_bald

/mob/living/simple_animal/hostile/abnormality/bald/AttackingTarget(atom/attacked_target)
	. = ..()
	if(ishuman(attacked_target))
		var/mob/living/carbon/human/H = attacked_target
		do_bald(H)

/mob/living/simple_animal/hostile/abnormality/bald/Login()
	. = ..()
	if(!.)
		return
	to_chat(src, span_userdanger("You do not do damage, your sole mission is to spread the glory of baldness to all."))

/datum/reagent/abnormality/bald
	name = "Essence of Baldness"
	description = "Some weird-looking juice..."
	color = "#ffffff"
	special_properties = list("substance may alter subject physiology")
	sanity_restore = 1

/datum/reagent/abnormality/bald/on_mob_metabolize(mob/living/L)
	if(ishuman(L))
		var/mob/living/carbon/human/balder = L
		if(balder.hairstyle != "Bald")
			balder.hairstyle = "Bald"
			balder.update_hair()
	return ..()

/obj/projectile/beam/yang/bald
	name = "bald beam"
	damage = 0

/obj/projectile/beam/yang/bald/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/victim = target
	if(!HAS_TRAIT(victim, TRAIT_BALD))
		to_chat(victim, span_notice("You feel awesome!"))
		ADD_TRAIT(victim, TRAIT_BALD, "ABNORMALITY_BALD")
		victim.hairstyle = "Bald"
		victim.update_hair()
	return

//status effect - BALD IS AWESOME
/datum/status_effect/bald_heal
	id = "bald_heal"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 30 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/bald_heal

/atom/movable/screen/alert/status_effect/bald_heal
	name = "Bald is Awesome!"
	desc = "The power of baldness is renerating HP and SP. Having more bald people around helps!"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "bald"

/datum/status_effect/bald_heal/tick()
	. = ..()
	var/mob/living/carbon/human/status_holder = owner
	var/heal_amount = 1
	for(var/mob/living/carbon/potentiallybaldperson in view(7, owner))
		if(HAS_TRAIT(potentiallybaldperson, TRAIT_BALD))
			heal_amount += 1
	heal_amount = clamp(heal_amount, 1, 5) // We don't want people somehow figuring out 1 billion healing
	status_holder.adjustBruteLoss(-heal_amount)
	status_holder.adjustSanityLoss(-heal_amount)

//Mob Proc
/mob/living/proc/apply_bald()
	var/datum/status_effect/bald_heal/B = src.has_status_effect(/datum/status_effect/bald_heal)
	if(!B)
		src.apply_status_effect(/datum/status_effect/bald_heal)
	else
		B.refresh()
