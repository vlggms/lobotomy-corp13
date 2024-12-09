/mob/living/simple_animal/hostile/clan_npc
	name = "Citzen?"
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
	mob_biotypes = MOB_ROBOTIC
	move_resist = MOVE_FORCE_STRONG
	can_buckle_to = FALSE
	gender = NEUTER
	speech_span = SPAN_ROBOT
	emote_hear = list("creaks.", "emits the sound of grinding gears.")
	speak_chance = 1
	a_intent = "help"
	maxHealth = 300
	health = 300
	death_message = "falls to their knees as their lights slowly go out..."
	melee_damage_lower = 0
	melee_damage_upper = 4
	mob_size = MOB_SIZE_LARGE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 2, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/robot = 3)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/robot = 1)
	silk_results = list(/obj/item/stack/sheet/silk/azure_simple = 1)
	var/question1 = "Who are you?"
	var/question2 = "2"
	var/question3 = "3"
	var/list/answers1 = list("O-oh... I a-am [clan_name].", "Curre-ently, I-I and my fe-ellow cla-an memebers", "Emote: Emote", "Move: NORTH", "Goodbye", "Delay: 20")
	var/list/answers2 = list("Hello, 2", "This is a test.", "Emote: Emote", "Move: NORTH", "Goodbye", "Delay: 20")
	var/list/answers3 = list("Hello, 3", "This is a test.", "Emote: Emote", "Move: NORTH", "Goodbye", "Delay: 20")
	var/default_delay = 30
	var/clan_name = "Elliot"

/mob/living/simple_animal/hostile/clan_npc/examine(mob/user)
	. = ..()
	. += span_notice("You are able to speak to [src] when clicking on them with your bare hands!")

/mob/living/simple_animal/hostile/clan_npc/AttackingTarget()
	return

/mob/living/simple_animal/hostile/clan_npc/CanAttack(atom/the_target)
	return

/mob/living/simple_animal/hostile/clan_npc/attack_hand(mob/living/carbon/M)
	if(!stat && M.a_intent == INTENT_HELP && !client)
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
			Speech(answers3)
			return
		return
	return ..()


/mob/living/simple_animal/hostile/clan_npc/proc/Speech(speech)
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
