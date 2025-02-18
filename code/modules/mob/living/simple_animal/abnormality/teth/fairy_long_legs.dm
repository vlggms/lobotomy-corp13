/mob/living/simple_animal/hostile/abnormality/fairy_longlegs
	name = "Fairy-Long-Legs"
	desc = "An tall fairy-like abnormality with an arm resembling a paddle, it never stops holding a clover as if it was an umbrella. The leaves seem damp."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "fairy_longlegs"
	icon_living = "fairy_longlegs"
	icon_dead = "fairy_longlegs_dead"
	core_icon = "fairy_longlegs_dead"
	portrait = "fairy_long_legs"
	del_on_death = FALSE
	pixel_x = -16
	base_pixel_x = -16
	maxHealth = 900
	health = 900
	rapid_melee = 0.5
	move_to_delay = 4
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	melee_damage_lower = 12
	melee_damage_upper = 16
	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = 'sound/abnormalities/fairy_longlegs/attack.ogg'
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(90, 60, 55, 50, 45),
		ABNORMALITY_WORK_INSIGHT = 45,
		ABNORMALITY_WORK_ATTACHMENT = 30,
		ABNORMALITY_WORK_REPRESSION = 0,
		"Take cover" = 0,
	)
	work_damage_amount = 5
	work_damage_type = RED_DAMAGE
	death_message = "coalesces into a primordial egg."
	death_sound = 'sound/abnormalities/fairy_longlegs/death.ogg'
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/fairy_gentleman = 1.5,
		/mob/living/simple_animal/hostile/abnormality/fairy_festival = 1.5,
		/mob/living/simple_animal/hostile/abnormality/faelantern = 1.5,
	)

	ego_list = list(
		/datum/ego_datum/weapon/fourleaf_clover,
		/datum/ego_datum/armor/fourleaf_clover,
	)
	gift_type =  /datum/ego_gifts/fourleaf_clover

	observation_prompt = "Come on, why don'cha stay under the umbrella with me? <br>\
		Just for old times sake?"
	observation_choices = list(
		"No" = list(TRUE, "You'd think that you'd have learned your lesson by now. <br>\
			You leave the cell, having narrowly dodged the imminent attack. <br>\
			This guy will always be a crook."),
		"Yes" = list(FALSE, "Ouch! <br>\
			The moment you get in striking range of fairy long legs, you are attacked. <br>\
			\"Heh. You really think you could be one of us, pal?\" <br>\
			\"You aint part of the family, chump.\" <br>\
			You walk away, and bandage the bleeding wound."),
	)

	var/finishing = FALSE //cant move/attack when it's TRUE
	var/work_count = 0
	var/raining = FALSE
	var/ignored = 0 //stores the agent's choice: 0 - disabled/1- refused cover


/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/death(gibbed)
	icon = 'ModularTegustation/Teguicons/abno_cores/teth.dmi'
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/CanAttack(atom/the_target)
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/Move()
	if(finishing)
		return FALSE
	return ..()

/*** Work Proc ***/
/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/WorkComplete(user, work_type, pe, work_time, canceled)
	. = ..()
	work_count++
	if(work_count < 3)
		return
	if(!raining && (IsContained(src)))
		for(var/turf/open/O in view(3, src))
			new /obj/effect/rainy_effect(O)
	say("Oh dear, i'd advise against being hit by this rain.") //tries to trick people into getting cover
	sleep(1 SECONDS)
	say("Care to join me under my umbrella?")
	raining = TRUE
	to_chat(user, span_notice("You feel the rain seep into your clothes, perhaps it would be best to find shelter...."))
	return

/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/AttemptWork(mob/living/carbon/human/user, work_type)
	if((work_type != "Take cover")&& !raining)
		return TRUE
	if((work_type == "Take cover") && !raining) //dumbass
		to_chat(user, span_notice("There's no reason, the skies are clear."))
		return FALSE
	if((work_type == "Take cover") && raining) //Uh oh, you goofed up
		to_chat(user, span_danger("You decide to take cover under the fairy's clover."))
		work_count = 0
		raining = FALSE
		Execute(user)
		return FALSE
	if((work_type != "Take cover") && raining)
		for(var/obj/effect/rainy_effect/rain in range(3, src))
			rain.End(TRUE) //The rain actually heals you, lying bastard...
		work_count = 0
		ignored = TRUE
		raining = FALSE
		return TRUE


/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 40)
		datum_reference.qliphoth_change(-2)
	if (ignored) //refused his offer to take cover
		say("Tch, this damn rain robs me of my food all the time.")
		ignored = FALSE
		datum_reference.qliphoth_change(-2)

/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/proc/Execute(mob/living/carbon/human/user)
	raining = FALSE
	user.Stun(3 SECONDS)
	step_towards(user, src)
	sleep(0.5 SECONDS)
	if(QDELETED(user))
		return
	step_towards(user, src)
	sleep(1.5 SECONDS)
	if(QDELETED(user))
		return
	user.visible_message(span_warning("You feel a stinging pain in your chest, is that...blood?!"))
	icon_state = "fairy_longlegs_healing"
	playsound(get_turf(src), 'sound/abnormalities/fairy_longlegs/heal.ogg', 50, 1)
	user.deal_damage(100, RED_DAMAGE)
	for(var/obj/effect/rainy_effect/rain in range(3, src))
		rain.End(FALSE)
	sleep(1.5 SECONDS)
	icon_state = "fairy_longlegs"

//Breach Stuff
/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/AttackingTarget(atom/attacked_target)
	if(finishing)
		return FALSE
	if(!istype(attacked_target, /mob/living/carbon/human))
		return ..()
	finishing = TRUE
	icon_state = "fairy_longlegs_healing"
	playsound(get_turf(src), 'sound/abnormalities/fairy_longlegs/heal.ogg', 50, 1)
	adjustBruteLoss(-(maxHealth*0.04)) //recovers 38 health per hit
	..()
	SLEEP_CHECK_DEATH(15)
	icon_state = "fairy_longlegs"
	finishing = FALSE

/mob/living/simple_animal/hostile/abnormality/fairy_longlegs/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	if(raining)
		for(var/obj/effect/rainy_effect/rain in range(3, src))
			rain.End(TRUE)

//Misc. Objects
/obj/effect/rainy_effect
	name = "rain"
	desc = "It's pouring."
	icon = 'icons/effects/weather_effects.dmi'
	icon_state = "acid_rain"
	layer = POINT_LAYER //want this high but not above warnings
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE

/obj/effect/rainy_effect/proc/End(healing)
	if(healing)
		for(var/mob/living/carbon/human/H in get_turf(src))
			to_chat(H, span_nicegreen("The rain is oddly reinvigorating."))
			H.adjustBruteLoss(-80)
	QDEL_IN(src, 50)
