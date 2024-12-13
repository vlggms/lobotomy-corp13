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
	speak_chance = 1
	maxHealth = 300
	health = 300
	death_message = "falls to their knees as their lights slowly go out..."
	ranged = TRUE
	retreat_distance = 10
	minimum_distance = 10
	vision_range = 7
	melee_damage_lower = 0
	melee_damage_upper = 4
	mob_size = MOB_SIZE_HUGE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 2, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/robot = 3)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 1)
	silk_results = list(/obj/item/stack/sheet/silk/azure_simple = 1)

/mob/living/simple_animal/hostile/clan_npc/CanAttack(atom/the_target)
	if (the_target in GLOB.marked_players)
		return TRUE
	. = ..()

/mob/living/simple_animal/hostile/clan_npc/bullet_act(obj/projectile/P)
	. = ..()
	if(P.firer && get_dist(src, P.firer) <= aggro_vision_range)
		if (!(P.firer in GLOB.marked_players ))
			GLOB.marked_players += P.firer

/mob/living/simple_animal/hostile/clan_npc/attack_hand(mob/living/carbon/M)
	if(!stat && M.a_intent == INTENT_HELP && !client)
		manual_emote("looks away, avoiding [M]'s gaze...")

/mob/living/simple_animal/hostile/clan_npc/attackby(obj/item/O, mob/user, params)
	. = ..()
	if (!(user in GLOB.marked_players ))
		GLOB.marked_players += user



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

/mob/living/simple_animal/hostile/clan_npc/info/examine(mob/user)
	. = ..()
	. += span_notice("You are able to speak to [src] when clicking on them with your bare hands!")

/mob/living/simple_animal/hostile/clan_npc/info/proc/CanTalk()
	return !target && !speaking

/mob/living/simple_animal/hostile/clan_npc/info/attack_hand(mob/living/carbon/M)
	if(!stat && M.a_intent == INTENT_HELP && !client && CanTalk())
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
	question1 = "Who are you?"
	question2 = "Why are you here?"
	question3 = "What are you selling?"
	answers1 = list("O-oh... I a-am James.", "A ci-itizen of the resu-urgence clan...", "For no-ow, I am ju-ust o-off duty.")
	answers2 = list("Curre-ently, I-I and my fe-ellow cla-an members are sco-outing this area...", "The Hi-istorian wants use to study hu-umans.", "And thi-is is the closest we co-ould get to them...", "So-o we are wa-aiting here until further orders.")
	answers3 = list("Sure!", "I got some good things in store today...")
	default_delay = 30
	var/trading = FALSE
	var/successful_sale = FALSE
	var/buying_say = "Good Deal!"
	var/selling_say = "Sold!"
	var/poor_say = "Aw... Looks like you still need "
	var/selling_end = "Got it, We are always open if you need anything!"
	var/sold
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
	if(!stat && M.a_intent == INTENT_HELP && !client)
		if (!trading)
			var/robot_ask = alert("ask them", "[src] is listening to you.", "[question1]", "[question2]", "[question3]", "Cancel")
			if(robot_ask == "[question1]")
				M.say("[question1]")
				SLEEP_CHECK_DEATH(default_delay)
				Speech(answers1)
				return
			if(robot_ask == "[question2]")
				SLEEP_CHECK_DEATH(default_delay)
				M.say("[question2]")
				Speech(answers2)
				return
			if(robot_ask == "[question3]")
				M.say("[question3]")
				SLEEP_CHECK_DEATH(default_delay)
				trading = TRUE
				Speech(answers3)
				return
			return
		else
			var/robot_ask = alert("ask them", "[src] is offering to you.", "Item 1 (50 ahn)", "Item 2 (200 ahn)", "I am done buying.", "Cancel")
			if(robot_ask == "Item 1 (50 ahn)")
				SellingItem(/obj/item/reagent_containers/hypospray/medipen/salacid, 50, M)
				return
			if(robot_ask == "Item 2 (200 ahn)")
				SellingItem(/obj/item/reagent_containers/hypospray/medipen/mental, 200, M)
				return
			if(robot_ask == "I am done buying.")
				say(selling_end)
				trading = FALSE
				return

	return ..()

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
		if(user.a_intent == INTENT_HELP)
			if(istype(O, /obj/item/storage)) // Code for storage dumping
				var/obj/item/storage/S = O
				for(var/obj/item/IT in S)
					ManageSales(IT, user)
				to_chat(user, span_notice("You show [src] your [S]..."))
				playsound(O, "rustle", 50, TRUE, -5)
				if (successful_sale == TRUE)
					say(buying_say)
					successful_sale = FALSE
				return TRUE
			ManageSales(O, user)
			if (successful_sale == TRUE)
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
	var/obj/item/holochip/C = M.is_holding_item_of_type(/obj/item/holochip)
	if(C && istype(C))
		var/credits = C.get_item_credit_value()
		var/amount = C.spend(price)
		if (amount > 0)
			new sold_item (get_turf(M))
			say(selling_say)
		else
			say(poor_say + "[(price - credits)] more ahn...")
