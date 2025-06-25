/mob/living/simple_animal/hostile/ui_npc/eric_t
	name = "Eric T."
	desc = "A fancy looking fellow wearing a mask; they look relaxed right now."
	health = 2500
	maxHealth = 2500
	typing_interval = 30
	portrait = "erik_bloodfiend_zoom.PNG"
	start_scene_id = "intro"
	icon = 'ModularTegustation/Teguicons/blood_fiends_32x32.dmi'
	icon_state = "b_boss"
	icon_living = "b_boss"
	icon_dead = "b_boss_dead"
	emote_delay = 2000
	random_emotes = "shuffles through some papers;flips a page in their notebook;sighs..."
	return_to_origin = TRUE

	// Combat-related variables
	var/blood_resistance = 250
	var/last_attacked_cooldown
	var/attacked_cooldown = 300
	var/shielded_line = "Yep, That will just be a waste of your time."
	var/attacked_amount = 0
	var/warning_line = "... You really don't want to mess with me, Child."
	var/last_warning_cooldown
	var/warning_cooldown = 50

	// Price for replacing lost parcels
	var/payback_price = 400

	// Stats for checking Grade
	var/list/stats = list(
		FORTITUDE_ATTRIBUTE,
		PRUDENCE_ATTRIBUTE,
		TEMPERANCE_ATTRIBUTE,
		JUSTICE_ATTRIBUTE,
	)
	var/quest_grade = 7

/mob/living/simple_animal/hostile/ui_npc/eric_t/Initialize()
	. = ..()

	// Initialize NPC-specific variables
	scene_manager.npc_vars.variables["briefcase_collected"] = FALSE
	scene_manager.npc_vars.variables["payback_price"] = payback_price

	// Load scenes
	scene_manager.load_scenes(get_eric_scenes())

/mob/living/simple_animal/hostile/ui_npc/eric_t/update_player_variables(mob/user)
	. = ..()
	if(!user)
		return

	// Initialize player-specific variables if they don't exist
	if(isnull(scene_manager.get_var(user, "player.has_parcel_job")))
		scene_manager.set_var(user, "player.has_parcel_job", FALSE)

	if(isnull(scene_manager.get_var(user, "player.is_worker")))
		scene_manager.set_var(user, "player.is_worker", FALSE)

	if(isnull(scene_manager.get_var(user, "player.collected_parcels")))
		scene_manager.set_var(user, "player.collected_parcels", 0)

	// Check if player has the briefcase
	var/has_briefcase = briefcase_check(user)
	scene_manager.set_var(user, "player.has_briefcase", has_briefcase)

	var/quest_grade = check_grade(user)
	scene_manager.set_var(user, "player.quest_grade", quest_grade)

/mob/living/simple_animal/hostile/ui_npc/eric_t/proc/get_eric_scenes()
	var/list/scenes = list()

	// Intro scenes
	scenes["intro"] = list(
		"text" = "... *The bloodfiend is simply sitting down and reading their notepad. It appears they have not noticed you.*",
		"actions" = list(
			"hi" = list(
				"text" = "Hello?",
				"default_scene" = "greeting1"
			),
			"stare" = list(
				"text" = "*Stand here and stare at him*",
				"default_scene" = "greeting2"
			),
			"loud" = list(
				"text" = "HELLO!!!",
				"default_scene" = "greeting3"
			)
		)
	)

	scenes["greeting1"] = list(
		"text" = "Hm... *The bloodfiend glances in your direction.* Greetings customer. Man, It's opening hours already?",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "main_screen"
			)
		)
	)

	scenes["greeting2"] = list(
		"text" = "... *The bloodfiend slightly glances in your direction, before looking back down.*",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "greeting2_2"
			)
		)
	)

	scenes["greeting2_2"] = list(
		"text" = "... Oh, Are you here for our services? <i>You should of said something...</i>",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "main_screen"
			)
		)
	)

	scenes["greeting3"] = list(
		"text" = "SHOOT, WHATS HAPPING-...    Dammit, Is this how you greet people?!?",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "greeting3_2"
			)
		)
	)

	scenes["greeting3_2"] = list(
		"text" = "Kids these days, lacking any kind of respect...",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "main_screen"
			)
		)
	)

	// Main menu
	scenes["main_screen"] = list(
		"text" = "Anyways, What are you looking for today at the Clinic?",
		"actions" = list(
			"jobs" = list(
				"text" = "\[player.is_worker?About the job.:I am looking for a job!\]",
				"default_scene" = "job_1",
				"transitions" = list(
					list(
						"expression" = "player.is_worker",
						"scene" = "job"
					)
				)
			),
			"bloodfiend?" = list(
				"text" = "You are a bloodfiend?",
				"default_scene" = "bloodfiend_1"
			),
			"arrival" = list(
				"text" = "Why are you here?",
				"default_scene" = "arrival_1"
			),
			"who" = list(
				"text" = "Who are you?",
				"default_scene" = "who_1"
			)
		)
	)

	// Job dialogue
	scenes["job_1"] = list(
		"text" = "Well, Lucky you. Your talking to the manager of this establishment.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"var_updates" = list(
					"player.is_worker" = TRUE
				),
				"default_scene" = "job_2"
			)
		)
	)

	scenes["job_2"] = list(
		"text" = "With us establishing a new clinic in this area, we are looking for some deliverymen.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "job_extra_1"
			)
		)
	)

	scenes["job_extra_1"] = list(
		"text" = "Some of our deliveries are within the town, they are no problem. However...",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "job_3"
			)
		)
	)

	scenes["job_3"] = list(
		"text" = "Often we have syndicates and other factions ordering medical supplies and they want their stuff get delivered discreetly. We obviously accept them, you would surprised how much they are paying.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "job_4"
			)
		)
	)

	scenes["job_4"] = list(
		"text" = "So, we started using the backstreets as a way to deliver them, but it can be quite deadly in there.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "job_extra_2"
			)
		)
	)

	scenes["job_extra_2"] = list(
		"text" = "That's why we are looking for deliverymen who have some combat expertise, so they can insure that our products get delivered safely.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "job_extra_3"
			)
		)
	)

	scenes["job_extra_3"] = list(
		"text" = "Also, I have an extra job. But I am only offering it to fellows of grade 7 or higher. It is quite a dangerous job...",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"var_updates" = list(
					"player.is_worker" = TRUE
				),
				"default_scene" = "job"
			)
		)
	)

	scenes["job"] = list(
		"text" = "Are you willing to take on some orders?",
		"actions" = list(
			"parcel" = list(
				"text" = "Accept the Job",
				"enabled_expression" = "NOT player.has_parcel_job",
				"proc_callbacks" = list(CALLBACK(src, PROC_REF(OrderParcel))),
				"var_updates" = list(
					"player.has_parcel_job" = TRUE
				),
				"default_scene" = "job_5"
			),
			"lost_parcel" = list(
				"text" = "About that...",
				"visibility_expression" = "player.has_parcel_job",
				"default_scene" = "job_6"
			),
			"later" = list(
				"text" = "Maybe not right now.",
				"default_scene" = "main_screen"
			),
			"quest" = list(
				"text" = "\[dialog.intro_quest_shown?About the Contract...:Any other jobs? I am a high grade now.\]",
				"visibility_expression" = "player.quest_grade",
				"default_scene" = "quest_1",
				"transitions" = list(
					list(
						"expression" = "npc.briefcase_collected",
						"scene" = "quest_late"
					),
					list(
						"expression" = "dialog.intro_quest_shown",
						"scene" = "quest_main"
					)
				)
			),
		)
	)

	scenes["job_5"] = list(
		"text" = "Very well, here's the parcel with the ordered supplies. I also would recommend buying one of those coordinate pinpointers in the fixer vending machines, they should make the job easier.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"var_updates" = list(
					"player.collected_parcels" = "{player.collected_parcels++}",
				),
				"proc_callbacks" = list(CALLBACK(src, PROC_REF(check_parcel_achievement))),
				"default_scene" = "job"
			)
		)
	)

	scenes["job_6"] = list(
		"text" = "Lost it? *sighs*, I guess I should've expected this would happen eventually... Just pay 400 ahn to make up for the lost parcel.",
		"actions" = list(
			"payback" = list(
				"text" = "Hand over 400 ahn",
				"enabled_expression" = "player.money >= 400",
				"proc_callbacks" = list(CALLBACK(src, PROC_REF(Payback))),
				"var_updates" = list(
					"player.has_parcel_job" = FALSE,
				),
				"default_scene" = "job_7",
				"transitions" = list(
					list(
						"expression" = "player.money < 400",
						"scene" = "job_6_failed"
					)
				)
			),
			"backaway" = list(
				"text" = "I will get that money soon...",
				"default_scene" = "main_screen"
			)
		)
	)

	scenes["job_6_failed"] = list(
		"text" = "*takes a look at your ID card*, Oh, It appears that you don't have enough ahn to pay me back... Please return when you DO have enough so we don't waste each other's time.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "job_6"
			)
		)
	)

	scenes["job_7"] = list(
		"text" = "*takes a look at your ID card*, Very well, Thanks for paying back your loss, please don't lose it again.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "job"
			)
		)
	)

	// Bloodfiend dialogue
	scenes["bloodfiend_1"] = list(
		"text" = "Yep, I am one of those \"big bad bloodfiends\" you must have heard of.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "bloodfiend_2"
			)
		)
	)

	scenes["bloodfiend_2"] = list(
		"text" = "If you are worried about me, bringing harm to you in any way, you can drop that worry.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "bloodfiend_3"
			)
		)
	)

	scenes["bloodfiend_3"] = list(
		"text" = "I am paid well at this company, and if I ever happend to need a burst of blood there plenty of bodies in the back alley.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "main_screen"
			)
		)
	)

	// Arrival dialogue
	scenes["arrival_1"] = list(
		"text" = "I guess it must be a bit surprising to see me here, with me arriving without much of an announcement.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "arrival_2"
			)
		)
	)

	scenes["arrival_2"] = list(
		"text" = "Higher up wanted some more information on how well the clinic is doing in this town. So the offered another job to me to watch over this clinic.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "arrival_3"
			)
		)
	)

	scenes["arrival_3"] = list(
		"text" = "It pays quite well, and I basically don't need to do anything other then watch over the docters and nurses.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "arrival_4"
			)
		)
	)

	scenes["arrival_4"] = list(
		"text" = "Plus, Thanks to all of the good work that Sana put into improving our reputation. This town is safe enough to keep my identity as a bloodfiend open.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "main_screen"
			)
		)
	)

	// Who are you dialogue
	scenes["who_1"] = list(
		"text" = "*sighs*, I still haven't made a public introduction of my sudden appearance. I really needed to work on getting that sorted out.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "who_2"
			)
		)
	)

	scenes["who_2"] = list(
		"text" = "Well, Let's get this introduction done and over with... *flips through their notepad...*",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "who_3"
			)
		)
	)

	scenes["who_3"] = list(
		"text" = "Ahm, I am Eric T. The manager and newly employed health inspector of this clinic.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "who_4"
			)
		)
	)

	scenes["who_4"] = list(
		"text" = "Some responsibilities of a clinic manager/health inspector include assignments like rating the clinic's efficiency, giving employees direct orders, - and yada yada...",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "who_5"
			)
		)
	)

	scenes["who_5"] = list(
		"text" = "Long story short, I am the guy who keeps the clinic on track.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "main_screen"
			)
		)
	)

	// Quest dialogue
	scenes["quest_1"] = list(
		"text" = "Hm... Matter of a fact, I do have a new job for you.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"var_updates" = list(
					"dialog.intro_quest_shown" = TRUE
				),
				"default_scene" = "quest_2"
			)
		)
	)

	scenes["quest_2"] = list(
		"text" = "You may have heard of this tale, but I used to work in another town.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "quest_3"
			)
		)
	)

	scenes["quest_3"] = list(
		"text" = "However 'small' incident has occurred in that place.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "quest_4"
			)
		)
	)

	scenes["quest_4"] = list(
		"text" = "And by small incident I mean one of the Bong Bong sisters triggered a nuclear detonation, eviscerating everything.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "quest_5"
			)
		)
	)

	scenes["quest_5"] = list(
		"text" = "... You know, it was so annoying to move all of my operations here!",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "quest_6"
			)
		)
	)

	scenes["quest_6"] = list(
		"text" = "Anyways, There is one thing that I could not recover in time.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "quest_7"
			)
		)
	)

	scenes["quest_7"] = list(
		"text" = "It should be in a black briefcase marked by my name, I know for a fact it is still out there.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "quest_8"
			)
		)
	)

	scenes["quest_8"] = list(
		"text" = "If you could recover the briefcase, I could pay you around... 3000 ahn.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "quest_9"
			)
		)
	)

	scenes["quest_9"] = list(
		"text" = "How does that sound for a contract? Go into the ruined town and recover my breifcase in one piece, and I shall pay you 3000 ahn.",
		"actions" = list(
			"ready_quest" = list(
				"text" = "I am ready to take this contract!",
				"proc_callbacks" = list(CALLBACK(src, PROC_REF(give_ticket))),
				"default_scene" = "quest_start"
			),
			"later_quest" = list(
				"text" = "Give me some time to think about it...",
				"default_scene" = "quest_leave"
			)
		)
	)

	scenes["quest_leave"] = list(
		"text" = "Sure, return to me once you are more informed.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"var_updates" = list(
					"dialog.intro_quest_shown" = TRUE
				),
				"default_scene" = "job"
			)
		)
	)

	scenes["quest_start"] = list(
		"text" = "Great, Here is the ticket to that town. Use it at the ticket reader down on bottem right side of the town. It will add it's location to the bus.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"var_updates" = list(
					"dialog.intro_quest_shown" = TRUE,
					"dialog.quest_accepted" = TRUE
				),
				"default_scene" = "job"
			)
		)
	)

	scenes["quest_main"] = list(
		"text" = "Hm, Got anything to say or ask?",
		"actions" = list(
			"return_main" = list(
				"text" = "Nevermind, I don't anything to ask.",
				"default_scene" = "job"
			),
			"ready_quest" = list(
				"text" = "I am ready to take this contract!",
				"visibility_expression" = "NOT dialog.quest_accepted",
				"proc_callbacks" = list(CALLBACK(src, PROC_REF(give_ticket))),
				"default_scene" = "quest_start"
			),
			"later_quest" = list(
				"text" = "Give me some time to think about it...",
				"visibility_expression" = "NOT dialog.quest_accepted",
				"default_scene" = "quest_leave"
			),
			"objective_quest" = list(
				"text" = "About the breifcase...",
				"visibility_expression" = "dialog.quest_accepted",
				"default_scene" = "quest_breifcase",
				"transitions" = list(
					list(
						"expression" = "npc.briefcase_collected",
						"scene" = "quest_late"
					)
				)
			)
		)
	)

	scenes["quest_breifcase"] = list(
		"text" = "Well, Did you find it at last?",
		"actions" = list(
			"got_breif" = list(
				"text" = "I have it right here.",
				"visibility_expression" = "player.has_briefcase",
				"proc_callbacks" = list(CALLBACK(src, PROC_REF(briefcase_buy))),
				"var_updates" = list(
					"npc.briefcase_collected" = TRUE
				),
				"default_scene" = "quest_done",
				"transitions" = list(
					list(
						"expression" = "NOT player.has_briefcase",
						"scene" = "quest_juke"
					)
				)
			),
			"missing_breif" = list(
				"text" = "Nevermind... I don't have it yet.",
				"default_scene" = "quest_juke"
			)
		)
	)

	scenes["quest_done"] = list(
		"text" = "Great work, Thanks for collecting it for me. It would of been a real hassle if I hand to go there... Anyways, Here is the promised payment of 3000 ahn.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "main_screen"
			)
		)
	)

	scenes["quest_juke"] = list(
		"text" = "... You know that you need to keep holding it? *sighs*",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "quest_main"
			)
		)
	)

	scenes["quest_late"] = list(
		"text" = "Sorry to let you know, but someone has already completed my contract. The reward has already been claimed.",
		"actions" = list(
			"..." = list(
				"text" = "...",
				"default_scene" = "main_screen"
			)
		)
	)

	return scenes

/mob/living/simple_animal/hostile/ui_npc/eric_t/proc/briefcase_check(mob/user)
	if(!user)
		user = usr

	if(isliving(user))
		var/mob/living/L = user
		var/B = L.is_holding_item_of_type(/obj/item/eric_briefcase)
		if(B)
			var/obj/item/eric_briefcase/brief = B
			if(brief && istype(brief))
				return TRUE
	return FALSE

/mob/living/simple_animal/hostile/ui_npc/eric_t/proc/give_ticket()
	if(isliving(usr))
		var/mob/living/L = usr
		new /obj/item/quest_ticket (get_turf(L))
		if(L.client)
			L.client.give_award(/datum/award/achievement/lc13/city/eric_quest_accept, L)
		for(var/obj/machinery/computer/communications/C in GLOB.machines)
			if(!(C.machine_stat & (BROKEN|NOPOWER)) && is_station_level(C.z))
				C.say(L.name + " has accepted the 'Dilapidated Town', breifcase retrieval contract.")

/mob/living/simple_animal/hostile/ui_npc/eric_t/proc/check_grade(mob/user)
	if(!user)
		user = usr

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/stattotal
		var/grade
		for(var/attribute in stats)
			stattotal+=get_attribute_level(H, attribute)
		stattotal /= 4	//Potential is an average of stats
		grade = round((stattotal)/20)	//Get the average level-20, divide by 20
		if(10-grade <= quest_grade) //Ex. Quest grade
			return TRUE
	return FALSE

/mob/living/simple_animal/hostile/ui_npc/eric_t/proc/briefcase_buy()
	if(scene_manager.npc_vars.variables["briefcase_collected"])
		return FALSE

	if(isliving(usr))
		var/mob/living/L = usr
		var/B = L.is_holding_item_of_type(/obj/item/eric_briefcase)
		if(B)
			var/obj/item/eric_briefcase/brief = B
			if(brief && istype(brief))
				qdel(brief)
				new /obj/item/stack/spacecash/c1000 (get_turf(L))
				new /obj/item/stack/spacecash/c1000 (get_turf(L))
				new /obj/item/stack/spacecash/c1000 (get_turf(L))
				playsound(get_turf(src), 'sound/effects/cashregister.ogg', 35, 3, 3)
				if(L.client)
					L.client.give_award(/datum/award/achievement/lc13/city/eric_quest_complete, L)
				for(var/obj/machinery/computer/communications/C in GLOB.machines)
					if(!(C.machine_stat & (BROKEN|NOPOWER)) && is_station_level(C.z))
						C.say(L.name + " has completed the 'Dilapidated Town', breifcase retrieval contract. Remember this for their grading.")
				return TRUE
	return FALSE

/mob/living/simple_animal/hostile/ui_npc/eric_t/proc/Payback()
	var/obj/item/card/id/C
	if(isliving(usr))
		var/mob/living/L = usr
		C = L.get_idcard(TRUE)
		if(!C)
			return FALSE
		else if(!C.registered_account)
			return FALSE

		var/datum/bank_account/account = C.registered_account
		if(payback_price && !account.adjust_money(-payback_price))
			return FALSE
		else
			L.playsound_local(get_turf(src), 'sound/effects/cashregister.ogg', 25, 3, 3)
			return TRUE
	return FALSE

/mob/living/simple_animal/hostile/ui_npc/eric_t/proc/OrderParcel()
	var/door = pick(GLOB.delivery_doors)
	if(istype(door, /obj/structure/delivery_door))
		var/obj/structure/delivery_door/D = door
		var/mob/user = usr
		D.OrderParcel(user.loc)
		user.playsound_local(get_turf(src), 'sound/effects/cashregister.ogg', 25, 3, 3)

		// Set up signal handling for parcel delivery
		RegisterSignal(D, COMSIG_PARCEL_DELIVERED, PROC_REF(ParcelDelivered))
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/ui_npc/eric_t/proc/ParcelDelivered(door, mob/user)
	SIGNAL_HANDLER

	// Clear the parcel job flag for this user when delivered
	if(user)
		scene_manager.set_var(user, "player.has_parcel_job", FALSE)

	// Unregister the signal
	UnregisterSignal(door, COMSIG_PARCEL_DELIVERED)

/mob/living/simple_animal/hostile/ui_npc/eric_t/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	if(amount > 0)
		amount = amount - blood_resistance
		if(amount < 0)
			amount = 0
	. = ..()
	if(amount == 0)
		new /obj/effect/temp_visual/blood_shield(src.loc)
		if(last_attacked_cooldown < world.time - attacked_cooldown)
			say(shielded_line)
			last_attacked_cooldown = world.time

/mob/living/simple_animal/hostile/ui_npc/eric_t/attackby(obj/item/I, mob/living/user, params)
	..()
	attacked_amount++
	if(attacked_amount >= 5 && attacked_amount != 10)
		if(last_warning_cooldown < world.time - warning_cooldown)
			say(warning_line)
			last_warning_cooldown = world.time
	if(attacked_amount == 10)
		say("Well, You asked for this... [user.name]")
		visible_message(span_warning("[src] drains all of [user.name]'s blood!"))
		new /obj/effect/temp_visual/cult/sparks(get_turf(user))
		user.adjustBruteLoss(300)
		user.playsound_local(get_turf(src), 'sound/magic/disintegrate.ogg', 60, 3, 3)
		attacked_amount = 0
		afterkill()

/mob/living/simple_animal/hostile/ui_npc/eric_t/proc/afterkill()
	sleep(25)
	manual_emote("wipes their gloves clean...")
	sleep(45)
	say("Anyone else wants to bother me?")

/mob/living/simple_animal/hostile/ui_npc/eric_t/proc/check_parcel_achievement()
	if(!usr || !usr.client)
		return

	var/parcels = scene_manager.get_var(usr, "player.collected_parcels")
	if(parcels >= 10)
		usr.client.give_award(/datum/award/achievement/lc13/city/parcel_delivery, usr)

// The briefcase item remains the same
/obj/item/eric_briefcase
	name = "secure briefcase"
	desc = "It's made of AUTHENTIC faux-leather. It has a name writen on it's back which says 'Eric.T'."
	icon = 'icons/obj/storage.dmi'
	icon_state = "briefcase"
	lefthand_file = 'icons/mob/inhands/equipment/briefcase_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/briefcase_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY

// Blood shield effect remains the same
/obj/effect/temp_visual/blood_shield
	name = "blood shield"
	desc = "A shimmering forcefield protecting the bloodfiend."
	icon = 'icons/effects/cult_effects.dmi'
	icon_state = "shield-cult"
	layer = FLY_LAYER
	light_system = MOVABLE_LIGHT
	light_range = 2
	duration = 6
