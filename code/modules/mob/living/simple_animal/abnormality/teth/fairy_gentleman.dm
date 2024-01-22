/mob/living/simple_animal/hostile/abnormality/fairy_gentleman
	name = "Fairy Gentleman"
	desc = "A very wide humanoid with long arms made of green, dripping slime."
	icon = 'ModularTegustation/Teguicons/96x64.dmi'
	icon_state = "fairy_gentleman"
	portrait = "fairy_gentleman"
	maxHealth = 900
	health = 900
	ranged = TRUE
	rapid_melee = 1
	melee_queue_distance = 2
	move_to_delay = 5
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.7, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	melee_damage_lower = 6
	melee_damage_upper = 12
	melee_damage_type = WHITE_DAMAGE  //Low damage - makes you drunk on a hit
	stat_attack = HARD_CRIT
	attack_sound = 'sound/abnormalities/fairygentleman/ego_sloshing.ogg'
	attack_verb_continuous = "slaps"
	attack_verb_simple = "slap"
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = 45,
		ABNORMALITY_WORK_ATTACHMENT = list(50, 50, 55, 55, 60),
		ABNORMALITY_WORK_REPRESSION = list(30, 25, 25, 20, 15),
	)
	pixel_x = -34
	base_pixel_x = -34
	work_damage_amount = 8
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/sloshing,
		/datum/ego_datum/armor/sloshing,
	)
	gift_type = /datum/ego_gifts/sloshing
	gift_message = "This wine tastes quite good..."
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/fairy_festival = 1.5,
		/mob/living/simple_animal/hostile/abnormality/fairy_longlegs = 1.5,
		/mob/living/simple_animal/hostile/abnormality/faelantern = 1.5,
	)

	var/can_act = TRUE
	var/jump_cooldown = 0
	var/jump_cooldown_time = 8 SECONDS
	var/jump_damage = 30
	var/jump_sound = 'sound/abnormalities/fairygentleman/jump.ogg'
	var/jump_aoe = 1

	var/list/give_drink = list(
		"You quite an interesting one, Feel free to take this drink! It is on the house!",
		"Attaboy, I think you deserve this! Drink! Drink 'til you're half seas over!",
		"HA HA HA HA!!! You can really talk an earful! Here, have one on me!",
		"Come on now, no need to worry. Try some of this giggle water, it's the bee's knees!",
		"Plum outta luck for eatery, I've already had all the food. Would ya care for a drink?",
	)
	var/list/disappointed = list(
		"Pipe down, pinko. I don't think this will help any of us if you continue like this.",
		"Come on now, what did I ever do to you? A little hootch never hurt nobody.",
		"This is how you treat me after giving you all of you my finest drinks?",
		"I have to go see a man about a dog.",
		"Are you okay? A big shot like yourself has no need to hold back.",
	)

	var/list/angry = list(
		"I'll wring you out!",
		"Come on, I'm taking you for a ride!",
		"This is all I got!",
		"I'll be havin' this!",
		"Scram!",
	)

//Action Buttons
	attack_action_types = list(/datum/action/innate/abnormality_attack/toggle/FairyJump)

/datum/action/innate/abnormality_attack/toggle/FairyJump
	name = "Toggle Jump"
	button_icon_state = "generic_toggle0"
	chosen_attack_num = 2
	chosen_message = span_colossus("You won't jump anymore.")
	button_icon_toggle_activated = "generic_toggle1"
	toggle_attack_num = 1
	toggle_message = span_colossus("You will now jump with your next attack when possible.")
	button_icon_toggle_deactivated = "generic_toggle0"

//Work mechanics
/mob/living/simple_animal/hostile/abnormality/fairy_gentleman/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(pe >= 11) // Almost perfect work
		var/turf/dispense_turf = get_step(src, pick(1,2,4,5,6,8,9,10))
		new/obj/item/reagent_containers/food/drinks/fairywine(dispense_turf)
		visible_message(span_notice("[src] gives out some fairy wine."))
		say(pick(give_drink))
	return

/mob/living/simple_animal/hostile/abnormality/fairy_gentleman/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(work_type == ABNORMALITY_WORK_INSTINCT)
		user.reagents.add_reagent(/datum/reagent/consumable/ethanol/fairywine, 10)
		visible_message(span_notice("You take a drink with the fairy gentleman."))
		say("Ha! Easy on the good stuff, hot shot!")
	return

/mob/living/simple_animal/hostile/abnormality/fairy_gentleman/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	say(pick(disappointed))

/mob/living/simple_animal/hostile/abnormality/fairy_gentleman/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

//Breach Mechanics
/mob/living/simple_animal/hostile/abnormality/fairy_gentleman/BreachEffect(mob/living/carbon/human/user, breach_type) //he flies
	. = ..()
	AddComponent(/datum/component/knockback, 1, FALSE, TRUE)
	say(pick(angry))
	is_flying_animal = TRUE
	ADD_TRAIT(src, TRAIT_MOVE_FLYING, INNATE_TRAIT)

/mob/living/simple_animal/hostile/abnormality/fairy_gentleman/AttackingTarget()
	if(!can_act)
		return
	melee_damage_type = WHITE_DAMAGE
	if(jump_cooldown <= world.time && prob(10) && !client)
		FairyJump(target)
		return
	if(!ishuman(target))
		return ..()
	var/mob/living/carbon/human/H = target
	H.drunkenness += 5
	to_chat(H, span_warning("Yuck, some of it got in your mouth!"))
	if(H.sanity_lost)
		melee_damage_type = RED_DAMAGE
	return ..()


/mob/living/simple_animal/hostile/abnormality/fairy_gentleman/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/fairy_gentleman/OpenFire()
	if(!can_act)
		return FALSE
	if(client)
		if(chosen_attack != 1)
			return
		FairyJump(target)
		return

	var/dist = get_dist(target, src)
	if(jump_cooldown <= world.time)
		var/chance_to_jump = 25
		if(dist > 3)
			chance_to_jump = 100
		if(prob(chance_to_jump))
			FairyJump(target)
		return

// Attacks
/mob/living/simple_animal/hostile/abnormality/fairy_gentleman/proc/FairyJump(mob/living/target)
	if(!istype(target) || !can_act)
		return
	var/dist = get_dist(target, src)
	if(dist > 1 && jump_cooldown < world.time)
		say(pick(angry))
		jump_cooldown = world.time + jump_cooldown_time
		can_act = FALSE
		SLEEP_CHECK_DEATH(0.25 SECONDS)
		animate(src, alpha = 1, pixel_z = 16, time = 0.1 SECONDS)
		src.pixel_z = 16
		playsound(src, 'sound/abnormalities/ichthys/jump.ogg', 50, FALSE, 4)
		var/turf/target_turf = get_turf(target)
		SLEEP_CHECK_DEATH(1 SECONDS)
		forceMove(target_turf) //look out, someone is rushing you!
		playsound(src, jump_sound, 50, FALSE, 4)
		animate(src, alpha = 255, pixel_z = -16, time = 0.1 SECONDS)
		src.pixel_z = 0
		SLEEP_CHECK_DEATH(0.1 SECONDS)
		var/target_drunk
		for(var/turf/T in view(jump_aoe, src))
			var/obj/effect/temp_visual/small_smoke/halfsecond/FX =  new(T)
			FX.color = "#b52e19"
			for(var/mob/living/L in T)
				if(faction_check_mob(L))
					continue
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					if(H.drunkenness > 50) // easter egg - being drunk makes you stagger him
						target_drunk = TRUE
						jump_damage = 0
					else
						jump_damage = initial(jump_damage)
				L.apply_damage(jump_damage, BLACK_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
				if(L.health < 0)
					L.gib()
		var/wait_time = 0.5 SECONDS
		if(target_drunk)
			wait_time += 3.5 SECONDS
			visible_message(span_boldwarning("[src] staggers around, exposing a weak point!"), span_nicegreen("You feel dizzy!"))
		SLEEP_CHECK_DEATH(wait_time)
		can_act = TRUE
