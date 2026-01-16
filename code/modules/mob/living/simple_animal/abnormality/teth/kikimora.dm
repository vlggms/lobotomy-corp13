/mob/living/simple_animal/hostile/abnormality/kikimora
	name = "Kikimora"
	desc = "A beaked woman with one leg idly sweeping the floor with a broom."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "kikimora"
	icon_living = "kikimora"
	icon_dead = "kikimora"
	portrait = "kikimora"
	maxHealth = 300
	health = 300
	rapid_melee = 1
	melee_queue_distance = 2
	move_to_delay = 3
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	threat_level = TETH_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(60, 60, 50, 50, 50),
		ABNORMALITY_WORK_INSIGHT = 50,
		ABNORMALITY_WORK_ATTACHMENT = list(50, 50, 40, 40, 40),
		ABNORMALITY_WORK_REPRESSION = list(30, 20, 0, -80, -80),
	)
	work_damage_upper = 4
	work_damage_lower = 2
	work_damage_type = WHITE_DAMAGE
	death_message = "falls over."
	ego_list = list(
		/datum/ego_datum/weapon/kikimora,
		/datum/ego_datum/armor/kikimora,
		)
	gift_type = /datum/ego_gifts/kikimora
	//envy due to being a curse
	chem_type = /datum/reagent/abnormality/sin/envy
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL

	observation_prompt = "Kikimora? <br> Kikimora. <br>\
	Kikimora Kikimora Kikimora Kikimora <br>\
	Kikimora Kikimora Kikimora Kikimora <br>\
	Kikimora Kikimora Kikimora Kikimora <br>\
	Kikimora Kikimora Kikimora Kikimora <br>"
	observation_choices = list(
		"Kikimora?" = list(TRUE, "Kikimora."),
	)

/mob/living/simple_animal/hostile/abnormality/kikimora/ZeroQliphoth(mob/living/carbon/human/user)
	. = ..()
	if(GLOB.department_centers.len)
		var/turf/W = pick(GLOB.department_centers)
		W = locate(W.x + rand(1,3), W.y + rand(1,3), W.z)
		var/obj/effect/decal/cleanable/crayon/cognito/kikimora/K = new (get_turf(W))
		K.dir = pick(WEST, EAST)
	datum_reference.qliphoth_change(2)

/mob/living/simple_animal/hostile/abnormality/kikimora/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.apply_status_effect(/datum/status_effect/kikimora)
		to_chat(H, span_mind_control("Kikimora."))

//Graffiti
/obj/effect/decal/cleanable/crayon/cognito/kikimora
	name = "graffiti"
	desc = "Kikimora?"
	icon_state = "kikimora"
	mergeable_decal = TRUE
	inflicted_effect = /datum/status_effect/kikimora

//Status Effect
/datum/status_effect/kikimora
	id = "kikimora"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null
	on_remove_on_mob_delete = TRUE
	var/words_per_say = 1
	var/static/spread_cooldown = 0
	var/spread_cooldown_delay = 5 SECONDS
	var/static/words_taken = list()

/datum/status_effect/kikimora/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(CorruptWords))
	RegisterSignal(owner, COMSIG_LIVING_STATUS_SLEEP, PROC_REF(Bedtime))

/datum/status_effect/kikimora/proc/Bedtime()
	SIGNAL_HANDLER
	var/turf/T = get_turf(owner)
	var/obj/item/food/offering = locate(/obj/item/food) in T
	if(offering)
		if(!(offering.foodtypes & JUNKFOOD) && !(offering.foodtypes & RAW) && !(offering.foodtypes & GROSS) && !(offering.foodtypes & TOXIC))
			playsound(get_turf(owner),'sound/items/eatfood.ogg', 50, TRUE)
			qdel(offering)
			qdel(src)
		else
			to_chat(owner, span_notice("You sense something examined your offering of food."))

/datum/status_effect/kikimora/proc/CorruptWords(datum/source, list/speech_args)
	SIGNAL_HANDLER
	var/words_to_take = words_per_say
	var/words_said = 0

	var/message = speech_args[SPEECH_MESSAGE]
	var/list/split_message = splittext(message, " ") //List each word in the message
	for (var/i in 1 to length(split_message))
		if(findtext(split_message[i], "*") || findtext(split_message[i], ";") || findtext(split_message[i], ":") || findtext(split_message[i], "kiki") || findtext(split_message[i], "mora"))
			continue
		var/standardize_text = uppertext(split_message[i])
		if(standardize_text in words_taken)
			split_message[i] = pick("kiki", "mora")
			//Higher chance of spreading if the user said kiki or mora alot.
			words_said++
			continue
		//Unsure if this is processor intensive.
		if(prob(25) && words_to_take > 0)
			words_taken += standardize_text
			words_to_take--

	message = jointext(split_message, " ")
	speech_args[SPEECH_MESSAGE] = message

	//Infection Mechanic
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		var/mouth = L.ego_gift_list[MOUTH_1]
		if(istype(mouth, /datum/ego_gifts/kikimora))
			qdel(src)
			return

		if(spread_cooldown <= world.time)
			for(var/mob/living/carbon/human/H in hearers(7, L))
				if(prob(5 * words_said))
					H.apply_status_effect(/datum/status_effect/kikimora)
			spread_cooldown = world.time + spread_cooldown_delay
