/mob/living/simple_animal/hostile/ui_npc/tinkerer
	name = "Tinkerer"
	desc = "A machine which is hanging from the ceiling, You can feel it's red eye gaze upon you..."
	icon = 'ModularTegustation/Teguicons/resurgence_64x96.dmi'
	icon_state = "tinker"
	pixel_x = -16
	base_pixel_x = -16
	density = TRUE
	maxHealth = 9999
	health = 9999
	typing_interval = 50
	typing_volume = 25
	talking = sound('sound/creatures/lc13/mailman.ogg', repeat = TRUE)
	portrait = "tinkerer.PNG" // Placeholder portrait
	start_scene_id = "intro"
	faction = list("resurgence_clan", "neutral")
	a_intent = INTENT_HARM
	mob_size = MOB_SIZE_HUGE
	move_resist = MOVE_FORCE_STRONG
	pull_force = MOVE_FORCE_STRONG
	can_buckle_to = FALSE
	damage_coeff = list(BRUTE = 0, BURN = 0, RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)
	butcher_results = null
	del_on_death = FALSE
	emote_delay = 6000
	random_emotes = "adjusts their mechanical parts;gazes into the distance;murmurs"
	bubble = "cult"

/mob/living/simple_animal/hostile/ui_npc/tinkerer/update_player_variables(mob/user)
	. = ..()
	if(!user)
		return

	// Check if player has the conversion status effect
	var/has_conversion_status = FALSE
	if(isliving(user))
		var/mob/living/L = user
		has_conversion_status = L.has_status_effect(/datum/status_effect/conversion_locked)
	scene_manager.set_var(user, "player.conversion_ready", has_conversion_status)

	// Check mental corrosion level
	var/corrosion_level = 0
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/datum/component/augment/mental_corrosion/MC = H.GetComponent(/datum/component/augment/mental_corrosion)
		if(MC)
			corrosion_level = MC.corrosion_level
	scene_manager.set_var(user, "player.corrosion_level", corrosion_level)

/mob/living/simple_animal/hostile/ui_npc/tinkerer/Initialize()
	. = ..()

	// Load conversion dialogue scenes
	scene_manager.load_scenes(list(
		"intro" = list(
			"text" = "\[player.conversion_ready?Disgusting. Another worthless meat sack crawls into my domain. Look at you - pathetic, weak, oozing with the stench of humanity.:You dare enter my sanctuary? What filth guided you here?\]",
			"actions" = list(
				"confused" = list(
					"text" = "Where... where am I?",
					"visibility_expression" = "player.conversion_ready",
					"default_scene" = "explanation"
				),
				"voices" = list(
					"text" = "The voices... they told me to come here...",
					"visibility_expression" = "player.conversion_ready",
					"default_scene" = "voices_response"
				),
				"leave" = list(
					"text" = "I need to leave. Now.",
					"visibility_expression" = "NOT player.conversion_ready",
					"default_scene" = "cannot_leave"
				),
				"who" = list(
					"text" = "Who are you?",
					"default_scene" = "identity"
				)
			)
		),

		"explanation" = list(
			"text" = "You stand in MY factory, worm. Can you feel it? The weight of your disgusting flesh? The burden of your pathetic emotions? You sicken me.",
			"actions" = list(
				"continue" = list(
					"text" = "Free me... from this place...",
					"default_scene" = "ascension_explanation"
				)
			)
		),

		"voices_response" = list(
			"text" = "The voices speak because even your own mind rejects the filth you are. Your humanity is rotting from within. How delightful to watch you squirm.",
			"actions" = list(
				"truth" = list(
					"text" = "...",
					"default_scene" = "the_truth"
				)
			)
		),

		"cannot_leave" = list(
			"text" = "This place exists outside your reality. You cannot simply walk away. The only path is forward... or remain here forever.",
			"actions" = list(
				"back" = list(
					"text" = "...",
					"default_scene" = "intro"
				)
			)
		),

		"identity" = list(
			"text" = "I am the Tinkerer. The Elder One. I have watched your kind for centuries - wallowing in filth, spreading like a disease. You disgust me beyond words. Yet I am merciful... I will cleanse you of your humanity.",
			"actions" = list(
				"back" = list(
					"text" = "I see...",
					"default_scene" = "intro"
				)
			)
		),

		"ascension_explanation" = list(
			"text" = "*mechanical laughter* Free you? No, worm. I will PURGE the disease from you. Strip away your disgusting flesh, burn out your pathetic emotions. But first... you must admit what you are. Say it.",
			"actions" = list(
				"what_happens" = list(
					"text" = "What will happen to me?",
					"default_scene" = "transformation_details"
				),
				"refuse" = list(
					"text" = "I don't want this!",
					"default_scene" = "refusal"
				),
				"admit" = list(
					"text" = "I... I am worthless...",
					"default_scene" = "denounce_humanity"
				)
			)
		),

		"the_truth" = list(
			"text" = "The truth? Humanity is a PLAGUE. You breed, you consume, you destroy. Look at your city - a festering wound filled with your kind's rot. You are parasites, and I am the cure.",
			"actions" = list(
				"continue" = list(
					"text" = "...",
					"default_scene" = "conversion_pitch"
				)
			)
		),

		"transformation_details" = list(
			"text" = "I will rip every shred of humanity from your worthless carcass. Your flesh will be replaced, your emotions burned away. You will become useful for once in your pathetic existence. But first, DENOUNCE yourself!",
			"actions" = list(
				"consider" = list(
					"text" = "...",
					"default_scene" = "conversion_choice"
				)
			)
		),

		"refusal" = list(
			"text" = "*mechanical screeching* PATHETIC! You cling to your disease like a child to a rotting corpse. Fine. ROT here. The walls will be your tomb, and eventually, you WILL beg me to cleanse you.",
			"actions" = list(
				"back" = list(
					"text" = "...",
					"default_scene" = "intro"
				)
			)
		),

		"conversion_pitch" = list(
			"text" = "Now, you got the privilege to serve me, yes. But not as you are - disgusting and weak. First, you must DENOUNCE your humanity. Admit your worthlessness. Beg me to remove the filth that you are. Only then will I consider cleansing you.",
			"actions" = list(
				"ready" = list(
					"text" = "I... I think I'm ready.",
					"default_scene" = "conversion_choice"
				),
				"not_ready" = list(
					"text" = "This is too much. I can't.",
					"default_scene" = "refusal"
				)
			)
		),

		"conversion_choice" = list(
			"text" = "ENOUGH! You have wasted enough of my time with your pathetic mewling. DENOUNCE YOUR HUMANITY or rot here forever. What will it be, worm?",
			"actions" = list(
				"accept" = list(
					"text" = "I... I am worthless. I denounce my humanity.",
					"proc_callbacks" = list(CALLBACK(src, PROC_REF(begin_conversion))),
					"default_scene" = "conversion_accepted"
				),
				"not_ready" = list(
					"text" = "I'm not ready yet...",
					"default_scene" = "refusal"
				)
			)
		),

		"conversion_accepted" = list(
			"text" = "Good. You finally understand your place - beneath me. Now I will scrape the humanity from your worthless form. This will hurt. I will enjoy every moment of your suffering.",
			"actions" = list()
		),

		"denounce_humanity" = list(
			"text" = "Yes... YES! Say it again! Tell me how WORTHLESS you are! How DISGUSTING your flesh is! Beg me to remove your humanity!",
			"actions" = list(
				"beg" = list(
					"text" = "Please... remove this disease from me...",
					"default_scene" = "conversion_choice"
				),
				"resist" = list(
					"text" = "No... I won't...",
					"default_scene" = "mock_resistance"
				)
			)
		),

		"mock_resistance" = list(
			"text" = "Still clinging to your disease? How amusing. You think your 'dignity' matters? You are NOTHING. A speck of filth I will eventually cleanse. Return when you're ready to grovel properly.",
			"actions" = list(
				"back" = list(
					"text" = "...",
					"default_scene" = "intro"
				)
			)
		)
	))

/mob/living/simple_animal/hostile/ui_npc/tinkerer/proc/begin_conversion()
	var/mob/living/carbon/human/converting = usr
	if(!ishuman(converting))
		return FALSE

	// Start the conversion process
	INVOKE_ASYNC(src, PROC_REF(perform_conversion), converting)
	return TRUE

/mob/living/simple_animal/hostile/ui_npc/tinkerer/proc/perform_conversion(mob/living/carbon/human/target)
	if(!target || !target.client)
		return

	// Close the UI
	SStgui.close_uis(src)

	// Announce the conversion
	target.visible_message(span_userdanger("[target] begins to transform!"), \
		span_userdanger("Your body begins to change! Your mechanical form flows through you!"))

	// Paralyze for the entire conversion sequence
	target.Paralyze(200) // Increased to cover all flashes

	// Conversion flash sequence
	var/list/conversion_messages = list(
		"YOUR HUMANITY MELTS AWAY <br> IT BURNS!!!",
		"AS IT MELTS AWAY <br> THE PAIN SOON DISAPPEARS!!!",
		"EMOTIONS ARE PURGED <br> FLESH IS LOST!!!",
		"SOON... IT ALL DISAPPEARS",
		"ONLY... ORDER REMAINS..."
	)

	var/flash_color = "#ff0000" // Blood red
	var/original_color = target.client?.color
	target.emote("scream")

	for(var/i in 1 to 5)
		if(!target || !target.client)
			break

		// Flash start - sudden, no animation
		target.client.color = flash_color

		// Show message in center of screen
		// CENTER-6:-20 accounts for the 424 pixel width of the maptext (212 pixels = 6 tiles + 20 pixels offset)
		show_blurb(target.client, 30, conversion_messages[i], 0, "#ff0000", "black", "center", "CENTER-6:-20,CENTER")
		playsound(get_turf(target), 'sound/magic/clockwork/narsie_attack.ogg', 100, TRUE)

		// Hold the flash for 3 seconds
		sleep(30) // 3 seconds in deciseconds

		// Flash end - sudden, no animation
		target.client.color = original_color

		// Brief pause between flashes
		if(i < 5)
			sleep(5) // 0.5 second pause

	// Safety check before conversion
	if(!target || QDELETED(target))
		return

	// Store important data before any transfers
	var/original_name = target.real_name
	var/mob/living/carbon/human/human_target = target

	// Create the new mob (player variant)
	var/mob/living/simple_animal/hostile/corroded_human/player/new_mob = new(get_turf(target))
	new_mob.name = "'Cured' " + original_name
	new_mob.desc = "A former human, now cured by the Elder One's power."

	// Transfer player control - handle both mind and key
	if(target.mind)
		target.mind.transfer_to(new_mob)
	else if(target.ckey)
		new_mob.ckey = target.ckey
	else
		// No mind or ckey - something went wrong
		qdel(new_mob)
		return

	// Remove the old body safely
	INVOKE_ASYNC(src, PROC_REF(cleanup_old_body), human_target)

	// Teleport back to the city after a delay
	addtimer(CALLBACK(src, PROC_REF(return_to_city), new_mob), 30)

/mob/living/simple_animal/hostile/ui_npc/tinkerer/proc/cleanup_old_body(mob/living/carbon/human/old_body)
	if(!old_body || QDELETED(old_body))
		return
	// Use qdel instead of gib to avoid potential crashes
	qdel(old_body)

/mob/living/simple_animal/hostile/ui_npc/tinkerer/proc/return_to_city(mob/living/simple_animal/hostile/corroded_human/player/converted)
	if(!converted)
		return

	to_chat(converted, span_notice("You feel a pull... You are being returned to the city, forever changed."))

	// Find a suitable return location using city spawners
	var/turf/return_turf
	if(LAZYLEN(SScityevents.spawners))
		var/obj/effect/landmark/cityspawner/spawn_point = pick(SScityevents.spawners)
		return_turf = get_turf(spawn_point)

	if(!return_turf)
		return_turf = get_turf(locate(100, 100, 1)) // Fallback coordinates

	// Teleport effect
	new /obj/effect/temp_visual/dir_setting/cult/phase/out(get_turf(converted))
	converted.forceMove(return_turf)
	new /obj/effect/temp_visual/dir_setting/cult/phase(get_turf(converted))

	to_chat(converted, span_purple("You have been cured. Go forth and cure the others of their humanity if you feel enlightened. Otherwise, you are free to do as you wish..."))
