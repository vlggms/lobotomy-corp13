GLOBAL_LIST_EMPTY(marked_players)

/mob/living/simple_animal/hostile/clan_npc
	name = "Quiet Citzen?"
	desc = "A humanoid looking machine... It appears to have 'Resurgence Clan' etched on their back..."
	icon = 'ModularTegustation/Teguicons/resurgence_32x48.dmi'
	icon_state = "clan_citzen"
	icon_living = "clan_citzen"
	icon_dead = "clan_citzen_dead"
	faction = list("resurgence_clan", "hostile", "neutral")
	wander = 0
	simple_mob_flags = SILENCE_RANGED_MESSAGE
	obj_damage = 5
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	environment_smash = FALSE
	a_intent = INTENT_HARM
	mob_biotypes = MOB_ROBOTIC
	move_resist = MOVE_FORCE_STRONG
	pull_force = MOVE_FORCE_STRONG
	can_buckle_to = FALSE
	gender = NEUTER
	speech_span = SPAN_ROBOT
	emote_hear = list("creaks.", "emits the sound of grinding gears.")
	maxHealth = 300
	health = 300
	death_message = "falls to their knees as their lights slowly go out..."
	ranged = TRUE
	retreat_distance = 10
	minimum_distance = 10
	vision_range = 3
	ranged_message = null
	melee_damage_lower = 0
	melee_damage_upper = 4
	mob_size = MOB_SIZE_HUGE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 2, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/robot = 3)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 1)
	silk_results = list(/obj/item/stack/sheet/silk/azure_simple = 1)
	var/attacked_line = "Wha-at are you do-oing... GE-ET AWAY!"
	var/mark_once_attacked = TRUE
	density = FALSE

/mob/living/simple_animal/hostile/clan_npc/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_CRATE_LOOTING_STARTED, PROC_REF(on_seeing_looting_started))
	RegisterSignal(SSdcs, COMSIG_CRATE_LOOTING_ENDED, PROC_REF(on_seeing_looting_ended))

/mob/living/simple_animal/hostile/clan_npc/proc/on_seeing_looting_started(datum/source, mob/living/user, obj/crate)
	SIGNAL_HANDLER
	if (check_visible(user, crate) && stat != DEAD && !target)
		addtimer(CALLBACK(src, PROC_REF(Talk)), 0)

/mob/living/simple_animal/hostile/clan_npc/proc/on_seeing_looting_ended(datum/source, mob/living/user, obj/crate)
	SIGNAL_HANDLER
	if (check_visible(user, crate) && stat != DEAD && !target)
		addtimer(CALLBACK(src, PROC_REF(Theif_Talk)), 0)
		if (!(user in GLOB.marked_players ))
			GLOB.marked_players += user

/mob/living/simple_animal/hostile/clan_npc/proc/Talk()
	say("Um... What are you doing?")

/mob/living/simple_animal/hostile/clan_npc/proc/Theif_Talk()
	say("Guards! We got a theif here!")

/mob/living/simple_animal/hostile/clan_npc/proc/check_visible(mob/living/user, obj/crate)
	var/user_visible = (user in view(vision_range, src))
	var/crate_visible = (crate in view(vision_range, src))
	return user_visible && crate_visible

/mob/living/simple_animal/hostile/clan_npc/Destroy()
	UnregisterSignal(SSdcs, COMSIG_CRATE_LOOTING_STARTED)
	UnregisterSignal(SSdcs, COMSIG_CRATE_LOOTING_ENDED)
	return ..()


/mob/living/simple_animal/hostile/clan_npc/CanAttack(atom/the_target)
	if (the_target in GLOB.marked_players)
		if (istype(the_target, /mob/living))
			var/mob/living/L = the_target
			if (L.stat == DEAD)
				return FALSE
		return TRUE
	. = ..()

/mob/living/simple_animal/hostile/clan_npc/bullet_act(obj/projectile/P)
	. = ..()
	if(mark_once_attacked)
		if(P.firer && get_dist(src, P.firer) <= aggro_vision_range)
			if (!(P.firer in GLOB.marked_players ))
				GLOB.marked_players += P.firer
				say(attacked_line)

/mob/living/simple_animal/hostile/clan_npc/attack_hand(mob/living/carbon/M)
	if(!stat && M.a_intent == INTENT_HELP && !client)
		manual_emote("looks away, avoiding [M]'s gaze...")

/mob/living/simple_animal/hostile/clan_npc/attackby(obj/item/O, mob/user, params)
	. = ..()
	if(mark_once_attacked)
		if(ishuman(user))
			if (O.force > 0)
				if (!(user in GLOB.marked_players ))
					GLOB.marked_players += user
					say(attacked_line)
		else
			if (!(user in GLOB.marked_players ))
				GLOB.marked_players += user
				say(attacked_line)

/mob/living/simple_animal/hostile/clan_npc/info
	name = "Talkative Citzen?"
	var/question1 = "Who are you?"
	var/question2 = "Why are you here?"
	var/question3 = "What is this faction?"
	var/list/answers1 = list("O-oh... I a-am James.", "A ci-itizen of the resu-urgence clan...", "For no-ow, I am ju-ust o-off duty.")
	var/list/answers2 = list("Curre-ently, I-I and my fe-ellow cla-an members are sco-outing this area...", "The Hi-istorian wants use to study hu-umans.", "And thi-is is the closest we co-ould get to them...", "So-o we are wa-aiting here until further orders.")
	var/list/answers3 = list("The-e clan is just one of ma-any villages in the O-outskirts...", "All of the me-embers of the clan are ma-achines...", "Like me...", "Delay: 20", "One day, We-e dream to be hu-uman...", "Just li-ike you, We ju-ust need to learn mo-ore...")
	var/default_delay = 30
	var/speaking = FALSE
	var/greeting_cooldown = 45 SECONDS
	var/last_greeting_cooldown = 0
	var/greeting_line = "Oh! He-ello Huma-an!"

/mob/living/simple_animal/hostile/clan_npc/info/examine(mob/user)
	. = ..()
	. += span_notice("You are able to speak to [src] when clicking on them with your bare hands!")

/mob/living/simple_animal/hostile/clan_npc/info/proc/CanTalk()
	return !target && !speaking

/mob/living/simple_animal/hostile/clan_npc/info/attack_hand(mob/living/carbon/M)
	if(!stat && M.a_intent == INTENT_HELP && !client && CanTalk())
		dir = get_dir(src, M)
		if (last_greeting_cooldown < world.time - greeting_cooldown)
			say(greeting_line)
			last_greeting_cooldown = world.time
		speaking = TRUE
		var/robot_ask = alert("ask them", "[src] is listening to you.", "[question1]", "[question2]", "[question3]", "Cancel")
		if(robot_ask == "[question1]")
			M.say("[question1]")
			SLEEP_CHECK_DEATH(default_delay)
			Speech(answers1)
		else if(robot_ask == "[question2]")
			M.say("[question2]")
			SLEEP_CHECK_DEATH(default_delay)
			Speech(answers2)
		else if(robot_ask == "[question3]")
			M.say("[question3]")
			SLEEP_CHECK_DEATH(default_delay)
			Speech(answers3)
		speaking = FALSE
		return
	return ..()


/mob/living/simple_animal/hostile/clan_npc/info/proc/Speech(speech)
	for (var/S in speech)
		if (findtext(S, "Emote: ") == 1)
			manual_emote(copytext(S, 8, length(S) + 1))
		else if (findtext(S, "Move: ") == 1)
			step(src, text2dir(copytext(S, 7, length(S) + 1)))
		else if (findtext(S, "Icon: ") == 1)
			icon_state = copytext(S, 7, length(S) + 1)
		else if (findtext(S, "Delay: ") == 1)
			SLEEP_CHECK_DEATH(text2num(copytext(S, 8, length(S) + 1)))
		else
			say(S)
		SLEEP_CHECK_DEATH(default_delay)

/mob/living/simple_animal/hostile/clan_npc/info/trader
	name = "Trader Citzen?"

	//Vars that should not be edited
	var/trading = FALSE
	var/successful_sale = FALSE

	//Vars that effect the traders dialogue
	var/selling_question = "What are you selling?"
	var/selling_answer = list("Sure!", "I got some good things in store today...")

	var/buying_say = "Good Deal!"

	var/sold_say = "Sold!"
	var/poor_say = "Aw... Looks like you still need "
	var/selling_end = "Got it, We are always open if you need anything!"
	var/no_cash = "Oh... Yo-ou are holding no cash..."

	//Vars that effect what the trader is selling
	var/can_sell = TRUE
	var/selling_item_1 = /obj/item/reagent_containers/hypospray/medipen/salacid
	var/selling_item_1_name = "HP Pen"
	var/cost_1 = 50
	var/selling_item_2 = /obj/item/reagent_containers/hypospray/medipen/mental
	var/selling_item_2_name = "SP Pen"
	var/cost_2 = 200

	//Vars that effect what the traders is buying
	var/can_buy = TRUE
	var/list/level_1 = list(
		/obj/item/rawpe,
		/obj/item/food/meat/slab/robot,
	)
	var/list/level_2 = list(
		/obj/item/refinedpe,
		/obj/item/clothing/suit/armor/ego_gear/city,
		/obj/item/ego_weapon/city,
		/obj/item/ego_weapon/ranged,
	)
	var/list/level_3 = list(
		/obj/item/raw_anomaly_core,
		/obj/item/documents,
		/obj/item/folder/syndicate,
		/obj/item/folder/documents,
	)

/mob/living/simple_animal/hostile/clan_npc/info/trader/Initialize()
	. = ..()
	SetSellables()

/mob/living/simple_animal/hostile/clan_npc/info/trader/attack_hand(mob/living/carbon/M)
	if(!stat && M.a_intent == INTENT_HELP && !client && CanTalk())
		dir = get_dir(src, M)
		speaking = TRUE
		if (!trading)
			if (last_greeting_cooldown < world.time - greeting_cooldown)
				say(greeting_line)
				last_greeting_cooldown = world.time
			var/robot_ask
			if (can_sell)
				robot_ask = alert("ask them", "[src] is listening to you.", "[question1]", "[question2]", "[selling_question]", "Cancel")
			else
				robot_ask = alert("ask them", "[src] is listening to you.", "[question1]", "[question2]", "[question3]", "Cancel")

			if(robot_ask == "[question1]")
				M.say("[question1]")
				SLEEP_CHECK_DEATH(default_delay)
				Speech(answers1)
			if(robot_ask == "[question2]")
				M.say("[question2]")
				SLEEP_CHECK_DEATH(default_delay)
				Speech(answers2)
			if(robot_ask == "[question3]")
				M.say("[question3]")
				SLEEP_CHECK_DEATH(default_delay)
				Speech(answers3)
			if(robot_ask == "[selling_question]")
				M.say("[selling_question]")
				SLEEP_CHECK_DEATH(default_delay)
				trading = TRUE
				Speech(selling_answer)
			speaking = FALSE
			return
		else
			speaking = TRUE
			var/robot_ask = alert("ask them", "[src] is offering to you.", "[selling_item_1_name]", "[selling_item_2_name]", "I am done buying.", "Cancel")
			if(robot_ask == "[selling_item_1_name]")
				SellingItem(selling_item_1, cost_1, M)
			if(robot_ask == "[selling_item_2_name]")
				SellingItem(selling_item_2, cost_2, M)
			if(robot_ask == "I am done buying.")
				say(selling_end)
				trading = FALSE
			speaking = FALSE
			return
	return

/mob/living/simple_animal/hostile/clan_npc/info/trader/proc/SetSellables()
	var/list/temp = list()
	for(var/T in level_1)
		temp.Add(typecacheof(T))
	level_1 = temp.Copy()
	temp.Cut()
	for(var/T in level_2)
		temp.Add(typecacheof(T))
	level_2 = temp.Copy()
	level_2.Remove(typecacheof(/obj/item/clothing/suit/armor/ego_gear/city/misc))
	level_2.Remove(typecacheof(/obj/item/clothing/suit/armor/ego_gear/city/indigo_armor))
	level_2.Remove(typecacheof(/obj/item/clothing/suit/armor/ego_gear/city/steel_armor))
	level_2.Remove(typecacheof(/obj/item/clothing/suit/armor/ego_gear/city/amber_armor))
	level_2.Remove(typecacheof(/obj/item/clothing/suit/armor/ego_gear/city/green_armor))
	level_2.Remove(typecacheof(/obj/item/clothing/suit/armor/ego_gear/city/azure_armor))
	temp.Cut()
	for(var/T in level_3)
		temp.Add(typecacheof(T))
	level_3 = temp.Copy()
	level_3[/obj/item/documents/photocopy] = FALSE
	temp.Cut()
	return

/mob/living/simple_animal/hostile/clan_npc/info/trader/attackby(obj/item/O, mob/user, params)
	if(stat == DEAD)
		to_chat(user, span_warning("[src] is dead!"))
		return
	else
		if(user.a_intent == INTENT_HELP && can_buy)
			if(istype(O, /obj/item/storage)) // Code for storage dumping
				var/obj/item/storage/S = O
				for(var/obj/item/IT in S)
					ManageSales(IT, user)
				to_chat(user, span_notice("You show [src] your [S]..."))
				playsound(O, "rustle", 50, TRUE, -5)
				if (successful_sale == TRUE)
					playsound(get_turf(src), 'sound/effects/cashregister.ogg', 35, 3, 3)
					say(buying_say)
					successful_sale = FALSE
				return TRUE
			ManageSales(O, user)
			if (successful_sale == TRUE)
				playsound(get_turf(src), 'sound/effects/cashregister.ogg', 35, 3, 3)
				say(buying_say)
				successful_sale = FALSE
			return
	. = ..()

/mob/living/simple_animal/hostile/clan_npc/info/trader/proc/ManageSales(obj/item/O, mob/living/user)
	var/spawntype
	if(is_type_in_typecache(O, level_3))
		spawntype = /obj/item/stack/spacecash/c1000
	else if(is_type_in_typecache(O, level_2))
		spawntype = /obj/item/stack/spacecash/c200
	else if(is_type_in_typecache(O, level_1))
		spawntype = /obj/item/stack/spacecash/c100
	else
		to_chat(user, span_warning("[src] doesn't want to buy the [O]."))
		return FALSE

	if(spawntype)
		new spawntype (get_turf(user))
		qdel(O)
		successful_sale = TRUE
	return TRUE

/mob/living/simple_animal/hostile/clan_npc/info/trader/proc/SellingItem(obj/item/O, var/price, mob/living/carbon/M)
	var/sold_item = O
	var/held_cash = M.is_holding_item_of_type(/obj/item/holochip)
	if(held_cash)
		var/obj/item/holochip/C = held_cash
		if(C && istype(C))
			var/credits = C.get_item_credit_value()
			var/amount = C.spend(price)
			if (amount > 0)
				new sold_item (get_turf(M))
				say(sold_say)
				playsound(get_turf(src), 'sound/effects/cashregister.ogg', 35, 3, 3)
			else
				say(poor_say + "[(price - credits)] more ahn...")
	else
		say(no_cash)
