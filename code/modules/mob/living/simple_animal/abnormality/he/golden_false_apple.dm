#define STATUS_EFFECT_GOLDENSHEEN /datum/status_effect/stacking/golden_sheen
#define STATUS_EFFECT_MAGGOTS /datum/status_effect/stacking/maggots
/mob/living/simple_animal/hostile/abnormality/golden_apple
	name = "Golden Apple"
	desc = "A huge, grotesque apple with limbs."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "gold_inert"
	icon_living = "gold_inert"
	icon_dead = "gold_cracked"
	portrait = "golden_apple"
	var/list/golden_apple_lines = list(
		"I didn't want to die.",
		"None of us wanted to die.",
		"......",
		"What else am I supposed to do? Is it wrong that I survived?",
		"Nhh... Aah.",
	)
	pixel_x = -8
	base_pixel_x = -8
	pixel_y = 0
	del_on_death = FALSE
	death_message = "falls over."
	death_sound = 'sound/abnormalities/goldenapple/Gold_Attack2.ogg'
	maxHealth = 1200
	health = 1200
	light_color = "D4FAF37"
	light_range = 5
	light_power = 7
	move_to_delay = 4
	attack_verb_continuous = "tackles"
	attack_verb_simple = "tackle"
	attack_sound = "sound/abnormalities/goldenapple/Gold_Attack.ogg"
	stat_attack = HARD_CRIT
	melee_damage_lower = 10
	melee_damage_upper = 15
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
	speak_emote = list("states")
	vision_range = 14
	aggro_vision_range = 20

	start_qliphoth = 2
	can_breach = TRUE
	threat_level = HE_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(55, 55, 40, 45, 50),
		ABNORMALITY_WORK_INSIGHT = list(60, 60, 45, 45, 50),
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 15, 30, 45),
	)
	work_damage_amount = 12//decently high due to mechanics
	work_damage_type = RED_DAMAGE
	max_boxes = 18

	ego_list = list(
		/datum/ego_datum/weapon/legerdemain,
		/datum/ego_datum/armor/legerdemain,
	)
	gift_type = /datum/ego_gifts/legerdemain
	gift_message = "You feel a sense of kinship with the apple. Because you're both pests."
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/snow_whites_apple = 1.5,
		/mob/living/simple_animal/hostile/abnormality/ebony_queen = 1.5,
	)

	attack_action_types = list(/datum/action/cooldown/gapple_pulse)
	var/datum/action/innate/abnormality_attack/maggot_spread/maggot_attack
	var/datum/action/innate/abnormality_attack/maggot_spread2/maggot_attack2

	guaranteed_butcher_results = list(/obj/item/food/grown/apple/gold/abnormality = 1)
	chem_type = /datum/reagent/abnormality/ambrosia
	harvest_phrase = span_notice("You score %ABNO and it bleeds a golden syrup into %VESSEL.")
	harvest_phrase_third = "%PERSON scores %ABNO, dripping a golden syrup into %VESSEL."
	var/is_maggot = FALSE
	var/can_act = TRUE
	var/victim_name
	var/say_chance = 7//it's pretty talkative
	var/smash_cooldown
	var/smash_cooldown_time = 15
	var/smash_damage = 12
	var/pulse_cooldown
	var/pulse_cooldown_time = 30 SECONDS
	var/pulse_count = 0
	var/pulse_maximum = 5

/datum/action/cooldown/gapple_pulse
	name = "Golden sheen"
	icon_icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	button_icon_state = "golden_sheen_noBG"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = 15 SECONDS

/datum/action/innate/abnormality_attack/maggot_spread
	name = "Slam"
	icon_icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	button_icon_state = "maggots_noBG"
	chosen_message = span_colossus("You will now spread maggots within a wide vicinity.")
	chosen_attack_num = 1

/datum/action/innate/abnormality_attack/maggot_spread2
	name = "Lunge"
	icon_icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	button_icon_state = "maggots_noBG"
	chosen_message = span_colossus("You will now spread maggots within a narrow vicinity.")
	chosen_attack_num = 2

/datum/action/cooldown/gapple_pulse/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/golden_apple))
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/golden_apple/apple = owner
	if(apple.IsContained()) // No more using cooldowns while contained
		return FALSE
	if(apple.is_maggot == TRUE || !apple.IsCombatMap())//False apple shouldn't have this ability, and it should not be usable outside RCA
		return FALSE
	if(apple.pulse_count == 0)
		to_chat(owner, span_warning("You cannot activate this due to a lack of charges. Attack a hostile target to gain more charges."))
		return FALSE
	apple.pulse_count -= 1
	StartCooldown()
	apple.HealPulse(TRUE)
	to_chat(owner, span_warning("You have [apple.pulse_count] charges remaining."))
	return TRUE

//***Simple Mob Procs***
/mob/living/simple_animal/hostile/abnormality/golden_apple/Initialize()
	if(IsCombatMap())//Is it R corp assault? Hit 'em with the nerf bat!
		pulse_cooldown_time = 130 SECONDS//The duraction of the buff is 60 seconds; you can't build stacks at this rate.
	maggot_attack = new /datum/action/innate/abnormality_attack/maggot_spread
	maggot_attack2 = new /datum/action/innate/abnormality_attack/maggot_spread2
	..()

/mob/living/simple_animal/hostile/abnormality/golden_apple/Life()
	. = ..()
	if(!.)
		return
	if((pulse_cooldown < world.time) && !(status_flags & GODMODE) && !is_maggot)//First form's regular heal pulse
		HealPulse()
		return
	if(!victim_name || client)//Automated speech if it's killed someone while tranforming
		return
	if(!prob(say_chance))
		return
	var/line = pick(golden_apple_lines)
	say(line)

/mob/living/simple_animal/hostile/abnormality/golden_apple/say(message as text, language, ignore_spam, forced, sanitize, spans)//UNDER CONSIDERATION: give it access to comms for R corp assault
	if(!victim_name)//Has it killed anyone while transforming?
		return ..()
	name = victim_name
	..()
	name = "False Apple"

/mob/living/simple_animal/hostile/abnormality/golden_apple/proc/HealPulse(manual = FALSE)
	if(manual == FALSE)//Only triggers the cooldown if it's called from life() ticks
		pulse_cooldown = world.time + pulse_cooldown_time
	playsound(src, 'sound/abnormalities/goldenapple/Gold_Sparkle.ogg', 50, 1)
	for(var/mob/living/L in livinginview(12, src))
		var/datum/status_effect/stacking/golden_sheen/G = L.has_status_effect(/datum/status_effect/stacking/golden_sheen)
		if(!faction_check_mob(L))
			continue
		if(!G)
			L.apply_status_effect(STATUS_EFFECT_GOLDENSHEEN)
		else
			G.add_stacks(1)
			G.refresh()

//***Work Mechanics***
//special Yuri interaction
/mob/living/simple_animal/hostile/abnormality/golden_apple/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(status_flags & GODMODE)
		if(istype(I, /obj/item/toy/plush/yuri))
			if(do_after(user, 2 SECONDS, target = user))
				datum_reference.qliphoth_change(-2)
				DigestPerson()//becomes its "berserk" form; without an argument it defaults to "Yuri"
				qdel(I)
				return
			to_chat(user, span_notice("You feel relieved, as if something weird and terrible was about to happen."))

/mob/living/simple_animal/hostile/abnormality/golden_apple/proc/Apply_Sheen(mob/living/carbon/human/user)
	var/datum/status_effect/stacking/golden_sheen/G = user.has_status_effect(/datum/status_effect/stacking/golden_sheen)
	playsound(src, 'sound/abnormalities/goldenapple/Gold_Sparkle.ogg', 100, 1)
	if(!G)//applying the buff for the first time (it lasts for one minute)
		user.apply_status_effect(STATUS_EFFECT_GOLDENSHEEN)
		to_chat(user, span_nicegreen("Your body is engulfed with a warm glow, numbing your injuries."))
	else//if the employee already has the buff
		to_chat(user, span_nicegreen("The glow surrounding your body brightens."))
		G.add_stacks(1)
		G.refresh()
	return

/mob/living/simple_animal/hostile/abnormality/golden_apple/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	Apply_Sheen(user)
	return

/mob/living/simple_animal/hostile/abnormality/golden_apple/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(50))
		Apply_Sheen(user)
	else
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/golden_apple/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/golden_apple/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	..()
	var/datum/status_effect/stacking/golden_sheen/G = user.has_status_effect(/datum/status_effect/stacking/golden_sheen)
	if (G.stacks >= 3)//Kills the employee if you already have 2 stacks of golden sheen and instantly breaches in phase 2
		datum_reference.qliphoth_change(-2)
		DigestPerson(user)//becomes its "berserk" form; the user is assimilated into it

//***Breach Mechanics***//
/mob/living/simple_animal/hostile/abnormality/golden_apple/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	icon_state = "gold_apple"
	icon_living = "gold_apple"

//switch to the second form if var is_maggot is 0
/mob/living/simple_animal/hostile/abnormality/golden_apple/death()
	if(health > 0)
		return
	if(!is_maggot)
		playsound(src, 'sound/abnormalities/goldenapple/Gold_Attack.ogg', 100, 1)
		addtimer(CALLBACK(src, PROC_REF(EatEmployees)), 15 SECONDS)
		return ..()
	density = FALSE
	for(var/atom/movable/AM in src) //morph code
		AM.forceMove(loc)
	playsound(src, 'sound/abnormalities/goldenapple/False_Dead.ogg', 100, 1)
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/golden_apple/proc/HandleAbiltyButtons()
	for(var/action_type in actions)
		var/datum/action/dostuff = action_type
		dostuff.Remove(src)
	maggot_attack.Grant(src)
	maggot_attack2.Grant(src)
	if(small_sprite_type)
		var/datum/action/small_sprite/small_action = new small_sprite_type()
		small_action.Grant(src)

/mob/living/simple_animal/hostile/abnormality/golden_apple/proc/BecomeRotten()//phase 2
	if(QDELETED(src))
		return
	if(is_maggot)//prevents the proc from being spammed
		return
	//I dont know why but for some reason revive resets move_to_delay -IP
	HandleAbiltyButtons()
	revive(full_heal = TRUE, admin_revive = FALSE)
	playsound(src, 'sound/abnormalities/goldenapple/Gold_Falsify.ogg', 50, 1)//it's very loud
	icon = 'ModularTegustation/Teguicons/96x48.dmi'
	icon_state = "false_apple"
	icon_living = "false_apple"
	icon_dead = "false_egg"
	death_message = "is reduced to a primordial egg."
	name = "False Apple"
	desc = "The apple ruptured and a swarm of maggots crawled inside, metamorphosing into a hideous face."
	pixel_x = -32
	pixel_y = 0
	light_range = 0
	light_power = 0
	attack_sound = "sound/abnormalities/goldenapple/False_Attack3.ogg"
	melee_damage_lower = 30
	melee_damage_upper = 45
	melee_reach = 2
	attack_verb_continuous = "pummels"
	attack_verb_simple = "pummel"
	ChangeResistances(list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.5))
	melee_damage_type = BLACK_DAMAGE
	fear_level = WAW_LEVEL
	is_maggot = TRUE
	SpeedChange(-1)

/mob/living/simple_animal/hostile/abnormality/golden_apple/AttackingTarget()//regular attacks or AOE. Determines the outcome for both players and the AI behavior
	if(!can_act)
		return FALSE
	if(!is_maggot)//Is it still in the first form? Start building sheen pulses
		if(pulse_count < pulse_maximum)
			if(isliving(target))
				var/mob/living/hit = target
				if((hit.stat == DEAD) ||!ishuman(hit))//if the target is dead or not human
					return ..()
				pulse_count += 1
		return ..()
	if(client && smash_cooldown < world.time)//playable behavior is nested under here
		switch(chosen_attack)
			if(1)
				Smash(target)
			if(2)
				Smash(target, wide = FALSE)
		return
	if(prob(50) && (smash_cooldown < world.time))//AI behavior goes here
		Smash(target, wide = pick(TRUE, FALSE))
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/golden_apple/proc/EatEmployees()
	var/last_target
	var/target_hit
	can_act = FALSE
	playsound(get_turf(src), 'sound/abnormalities/goldenapple/False_Attack2.ogg', 100, 0, 5)
	for(var/turf/T in view(1, src))
		new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/carbon/L in HurtInTurf(T, list(), 200, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE))
			if(L.stat >= SOFT_CRIT)
				if(!last_target)//only the last person killed counts
					L.forceMove(src)
					last_target = TRUE
					target_hit = TRUE
					addtimer(CALLBACK(src, PROC_REF(DigestPerson), L), 5 SECONDS)
				else
					L.gib(TRUE, TRUE, TRUE)
		if (!target_hit)
			addtimer(CALLBACK(src, PROC_REF(BecomeRotten)), 5 SECONDS)//if nobody got killed
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/golden_apple/proc/DigestPerson(mob/living/carbon/human/H)//berserk mode
	victim_name = "Yuri"
	maxHealth = 1500
	BecomeRotten()
	SpeedChange(-0.5)
	ChangeResistances(list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.3))
	if(H)
		victim_name = H.real_name
		NestedItems(src, H.get_item_by_slot(ITEM_SLOT_SUITSTORE))
		NestedItems(src, H.get_item_by_slot(ITEM_SLOT_BELT))
		NestedItems(src, H.get_item_by_slot(ITEM_SLOT_BACK))
		NestedItems(src, H.get_item_by_slot(ITEM_SLOT_OCLOTHING))
		var/obj/item/bodypart/head/myhead = H.get_bodypart(BODY_ZONE_HEAD)
		if(myhead)
			myhead.dismember()
			NestedItems(src, myhead)
		QDEL_IN(H, 1)
	desc = "The apple ruptured and a swarm of maggots crawled inside.. wait a minute, that's [victim_name]'s face."
	med_hud_set_health()//took a page from smock to update medhuds
	med_hud_set_status()
	update_health_hud()

/mob/living/simple_animal/hostile/abnormality/golden_apple/proc/NestedItems(mob/living/simple_animal/hostile/nest, obj/item/nested_item)
	if(nested_item)
		nested_item.forceMove(nest)

//AoE attack taken from woodsman, applies maggots DOT
/mob/living/simple_animal/hostile/abnormality/golden_apple/proc/Smash(target, wide = TRUE)
	if (!client && (get_dist(src, target) > 4))
		return
	smash_cooldown = world.time + smash_cooldown_time
	var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
	var/turf/source_turf = get_turf(src)
	var/turf/area_of_effect = list()
	var/turf/middle_line = list()
	var/upline = NORTH
	var/downline = SOUTH
	var/smash_length = 2
	var/smash_width = 2
	if(wide)
		playsound(get_turf(src), 'sound/abnormalities/goldenapple/False_Attack.ogg', 50, 0, 5)
	else
		playsound(get_turf(src), 'sound/abnormalities/goldenapple/False_Attack2.ogg', 50, 0, 5)
		smash_length = 4
		smash_width = 1
	middle_line = getline(source_turf, get_ranged_target_turf(source_turf, dir_to_target, smash_length))
	if(dir_to_target == NORTH || dir_to_target == SOUTH)
		upline = EAST
		downline = WEST
	for(var/turf/T in middle_line)
		if(T.density)
			break
		for(var/turf/Y in getline(T, get_ranged_target_turf(T, upline, smash_width)))
			if (Y.density)
				break
			if (Y in area_of_effect)
				continue
			area_of_effect += Y
		for(var/turf/U in getline(T, get_ranged_target_turf(T, downline, smash_width)))
			if (U.density)
				break
			if (U in area_of_effect)
				continue
			area_of_effect += U
	if(!dir_to_target)
		for(var/turf/TT in view(1, src))
			if (TT.density)
				break
			if (TT in area_of_effect)
				continue
			area_of_effect |= TT
	if (!LAZYLEN(area_of_effect))
		return
	can_act = FALSE
	dir = dir_to_target
	for(var/turf/T in area_of_effect)
		new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/L in HurtInTurf(T, list(), smash_damage, BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE))
			var/datum/status_effect/stacking/maggots/G = L.has_status_effect(/datum/status_effect/stacking/maggots)
			if(!G)
				L.apply_status_effect(STATUS_EFFECT_MAGGOTS)
			else
				G.add_stacks(1)
				G.refresh()
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	can_act = TRUE

//***Buff Definitions***
//For now, just a notification. If we ever want to do anything with it, it's here.
/datum/status_effect/stacking/golden_sheen
	id = "sheen"
	status_type = STATUS_EFFECT_MULTIPLE
	duration = 60 SECONDS	//Lasts for a minute
	max_stacks = 5
	stacks = 1
	on_remove_on_mob_delete = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/golden_sheen
	consumed_on_threshold = FALSE
	var/obj/item/glow_object/glowstuff

/atom/movable/screen/alert/status_effect/golden_sheen
	name = "Golden Sheen"
	desc = "Your body radiates the very same glow as the Golden Apple."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "golden_sheen"

/datum/status_effect/stacking/golden_sheen/on_apply()
	glowstuff = new /obj/item/glow_object(owner)
	return ..()

/datum/status_effect/stacking/golden_sheen/on_remove()
	qdel(glowstuff)
	return ..()

/datum/status_effect/stacking/golden_sheen/add_stacks()
	glowstuff.set_light(3, (stacks * 2), "D4FAF37")
	return ..()

/datum/status_effect/stacking/golden_sheen/tick()//TODO:change this to golden apple's life tick for less lag
	if(isanimal(owner))
		owner.adjustBruteLoss(stacks * -5)
		return
	owner.adjustBruteLoss(stacks * -0.5)
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjustSanityLoss(stacks * -0.5)

/obj/item/glow_object
	name = "golden apple core"
	desc = "You shouldn't be able to see this."
	light_range = 3
	light_power = 2
	light_color = "D4FAF37"
	light_on = TRUE

//debuff definition

/datum/status_effect/stacking/maggots
	id = "maggots"
	status_type = STATUS_EFFECT_MULTIPLE
	duration = 15 SECONDS	//Lasts for 15 seconds and refreshes when reapplied
	max_stacks = 10
	stacks = 1
	on_remove_on_mob_delete = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/maggots
	consumed_on_threshold = FALSE

/atom/movable/screen/alert/status_effect/maggots
	name = "Maggots"
	desc = "Eugh! Get them off!"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "maggots"

/datum/status_effect/stacking/maggots/on_apply()
	to_chat(owner, span_warning("You're covered in squirming maggots!"))
	return ..()

/datum/status_effect/stacking/maggots/tick()//change this to golden apple's life tick for less lag
	var/mob/living/carbon/human/status_holder = owner
	status_holder.apply_damage(stacks * 1, BLACK_DAMAGE, null, status_holder.run_armor_check(null, BLACK_DAMAGE))
	if(status_holder.stat < HARD_CRIT)
		return
	var/obj/structure/spider/cocoon/casing = new(status_holder.loc)
	status_holder.forceMove(casing)
	casing.name = "pile of maggots"
	casing.desc = "They're wriggling and writhing over something."
	casing.icon_state = pick(
		"cocoon_large1",
		"cocoon_large2",
		"cocoon_large3",
	)
	casing.density = FALSE
	casing.color = "#01F9C6"
	qdel(src)

/obj/item/food/grown/apple/gold/abnormality
	food_reagents = list(/datum/reagent/abnormality/ambrosia = 10)
	desc = "There's something moving underneath the skin, but it still looks delicious."

/datum/reagent/abnormality/ambrosia
	name = "Ambrosia"
	description = "A powerful serum extracted from an abnormality."
	color = "#03FCD3"
	taste_description = "apple juice"
	glass_name = "glass of ambrosia"
	glass_desc = "A glass of apple juice."
	metabolization_rate = 3 * REAGENTS_METABOLISM//metabolizes at 24u/minute

/datum/reagent/abnormality/ambrosia/on_mob_add(mob/living/L)
	..()
	if(L.has_status_effect(/datum/status_effect/stacking/golden_sheen))//this fixes a runtime
		return
	L.apply_status_effect(STATUS_EFFECT_GOLDENSHEEN)
	to_chat(L, span_nicegreen("Your body glows warmly."))

/datum/reagent/abnormality/ambrosia/on_mob_life(mob/living/L)
	var/datum/status_effect/stacking/golden_sheen/G = L.has_status_effect(/datum/status_effect/stacking/golden_sheen)
	if(prob(10))
		to_chat(L, span_nicegreen("Your glow shimmers!"))
		G.add_stacks(1)
		G.refresh()
	return ..()

#undef STATUS_EFFECT_GOLDENSHEEN
#undef STATUS_EFFECT_MAGGOTS
