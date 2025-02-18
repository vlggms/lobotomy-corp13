	//Designed to be a very forgiving and standard abnormality.
/mob/living/simple_animal/hostile/abnormality/forsaken_murderer
	name = "Forsaken Murderer"
	desc = "A unhealthy looking human bound in a full body straightjacket."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "forsakenmurdererinert"
	icon_living = "forsakenmurdererinert"
	icon_dead = "forsakenmurdererdead"
	portrait = "forsaken_murderer"
	del_on_death = FALSE
	/**
	 * Originally was 270.
	 * Fragment health is 800 with a original game health of 230 so techically forsaken murderer has more health than fragment?
	 * Ill round the numbers to 600 since 270 can be rounded to 300 and doubled.
	 * I was later told to make it 1100.
	 * We really dont have a Lobotomy Corp to LC13 health conversion calculator. - InsightfulParasite
	 * Turns out that 1100 is not enough. - Kirie/Kitsunemitsu
	 */
	maxHealth = 1300
	health = 1300
	//Attack speed modifier. 2 is twice the normal.
	rapid_melee = 1
	//If target is close enough start preparing to hit them if we have rapid_melee enabled. Originally was 4.
	melee_queue_distance = 2
	//How fast a creature is, lower is faster. Client controlled monsters instead use speed and are MUCH faster.
	move_to_delay = 3
	/**
	 * Red damage is applied to health.
	 * White damage is applied to sanity with only a few abnormalities using that to instantly kill the victim.
	 * Black damage is applied to both health and sanity 10 black damage would do 10 health damage and 10 sanity damage.
	 * Pale damage is a % of health. Weird i know.
	 */
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	//the lowest damage in regular attacks. Normal murderer is 2~4 so we double it.
	melee_damage_lower = 10
	/**
	 * Fragments Lobotomy Corp damage was 3~4 so im giving murderer a larger gap between his lower and upper damage.
	 * Unsure if i should be comparing Forsaken Murderer to Fragment of the Universe.
	 * Most HE level abnormalities do 20+ damange.
	 */
	melee_damage_upper = 18
	melee_damage_type = RED_DAMAGE
	//Used chrome to listen to the sound effects. In the chrome link was the file name i could copy paste in.
	attack_sound = 'sound/effects/hit_kick.ogg'
	attack_verb_continuous = "smashes"
	attack_verb_simple = "smash"
	friendly_verb_continuous = "bonks"
	friendly_verb_simple = "bonk"
	/**
	 * Leaving the faction list blank only attributes them to one faction and thats its own unique mob number.
	 * With this forsaken murderer will even attack duplicates of themselves.
	 */
	faction = list()
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 1
	// Work chance fluctuates based on level. left to right as level increase.
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(60, 60, 50, 50, 50),
		ABNORMALITY_WORK_INSIGHT = list(40, 40, 30, 30, 30),
		ABNORMALITY_WORK_ATTACHMENT = list(50, 50, 40, 40, 40),
		ABNORMALITY_WORK_REPRESSION = list(30, 20, 0, -80, -80),
	)
	work_damage_amount = 6
	work_damage_type = RED_DAMAGE

	/*
	* This is related to abnochem where a chemical can be harvested from abnormalities.
	* This is more for general flavor and will be randomly filled if left empty.
	* I placed this here because i felt like violence makes the most sense.
	*/
	chem_type = /datum/reagent/abnormality/violence

	//shows in chat when the creature is defeated. Default is "stops moving".
	death_message = "falls over."
	//Phrases that the creature will emote randomly based on speak chance.
	speak_chance = 2
	emote_see = list("shakes while mumbling...")
	//Makes the mob move in a random direction once in a while. I personally would rather them stay still.
	wander = FALSE
	/**
	 * ego_list is the things you can buy with its unique type of PE.
	 * Making these is a bit more complicated since the types listed
	 * here are datums that contain the cost and typepath of the accosiated object.
	 * You can find the files of these in: _ego_datum.dm
	 * The weapons and armor themselves are in _ego_gear.dm , ego_gun file and _ego_weapon.dm
	 */
	ego_list = list(
		/datum/ego_datum/weapon/regret,
		/datum/ego_datum/armor/regret,
	)
	/**
	 * Special employees get gifts from interacting with the abnormality.
	 * You can see the different types of gifts in ego_gifts.dm
	 */
	gift_type =  /datum/ego_gifts/regret
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	/**
	 * Final observation code.
	 * observation_prompt controls the text that the user sees when they start the observation
	 * observation_choices is made in the format of:
	 * "Choice" = list(TRUE or FALSE [depending on if the answer is correct], "Response"),
	 */
	observation_prompt = "Around his neck is a rope. It is up to you to cut his rope."
	observation_choices = list(
		"Don't cut the rope" = list(TRUE, "His neck snaps, granting him silence and eternal rest."),
		"Cut the rope" = list(FALSE, "\"You think I'm pathetic, huh? But is you people who are really pathetic. Because you get killed. By people like me.\""),
	)

	//Unique variable im defining for this abnormality. This is the timer for their during work emotes.
	var/work_emote_cooldown = 0

	attack_action_types = list(
		/datum/action/innate/change_icon_forsaken,
	)


/datum/action/innate/change_icon_forsaken
	name = "Toggle Icon"
	desc = "Toggle your icon between breached and contained. (Works only for Limbus Company Labratories)"

/datum/action/innate/change_icon_forsaken/Activate()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		owner.icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
		owner.icon_state = "forsakenmurdererinert"
		active = 1

/datum/action/innate/change_icon_forsaken/Deactivate()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		owner.icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
		owner.icon_state = "forsakenmurdererbreach"
		active = 0


//When work type is bad the qliphoth counter lowers with no chance.
/mob/living/simple_animal/hostile/abnormality/forsaken_murderer/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	/**
	 * Each abnormality has a variable called datum_refrence.
	 * The Qliphoth Counter, the thing that keeps abnormalities contained
	 * It's defined in this datum so we have to refrence it in order to manually change its counter.
	 * Remember this because this opens the way for coders to call procs on things that are outside this entitiy.
	 */
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

//This is additional text that appears when examining. Not very important.
/mob/living/simple_animal/hostile/abnormality/forsaken_murderer/examine(mob/user)
	. = ..()
	if(IsContained())
		. += "His neck is broken and in the middle of his forehead is a old wound that refuses to heal."
	else
		. += "Their head has become a large chunk of metal."

//So people see him fall.
/mob/living/simple_animal/hostile/abnormality/forsaken_murderer/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/**
 * This is #define, it functions like a macro, paraphrasing repeating code.
 * The main usage of define is to make the code easier to read.
 * There isnt much point placing it here instead of at the top of the file but i want to make a example of how to use it.
 * The phrase placed after define is the word that is always replaced with the code after it.
 * Im going to use this to shorten the cooldown change.
 * Please check the bottom of the file to see #undef where you undefine the word so that it isnt replaced every time its written in the codebase.
 */

#define FORSAKEN_MURDERER_EMOTE work_emote_cooldown = world.time + (10 SECONDS)
//For more general defines like SECONDS or QDEL_IN() check the _DEFINES or _HELPERS file.

//Worktick is a proc that activates every time part of a work has been preformed.
/mob/living/simple_animal/hostile/abnormality/forsaken_murderer/Worktick(mob/living/carbon/human/user)
	// . = ..() means if the code already in this proc has finished then preform what is listed after this.
	. = ..()
	/**
	 * Sort of self explanatory, this is if the cooldown variable is less than the current time in the world.
	 * prob is a percent chance probability of 50.
	 * I placed the 50% chance here because i want it to be sort of unpredictable.
	 */
	if(!client && work_emote_cooldown <= world.time && prob(35))
		/**
		 * Roll is a proc from the offical Dream Maker Guide.
		 * 1 is the amount of dice and 6 is the sides of those dice.
		 * I tried to put the link to the guide here but the codebase got upset so just try to find it at the byond website.
		 */
		switch(roll(1, 6))
		//Switch only allows one of the ifs within it to proc, this is helpful with sorting number effects.
			if(1 to 3)
				//Pick returns one of its options. This can also be used with a list by doing pick(list_name).
				emote(pick("twitches", "mumbles"))
			if(4 to 5)
				//This text shows up in the textbox of the defined creature or player
				to_chat(user, span_notice("You smell an unbearable odor of despair."))
			if(6)
				//This text shows up for all entities who can see this creature.
				visible_message("[src] suddenly screams and struggles against their restraints!")
				/**
				 * Playsound is a unique proc that... plays a sound at the defined location.
				 * The first slot is location.
				 * Second spot is the sound that is played.
				 * Third is the volume of the sound.
				 * Four is if it has a random pitch.
				 * Five is sound range.
				 * So i guess something can be quiet but heard normally if its sound range is high?
				 */
				playsound(get_turf(src), 'sound/voice/human/malescream_6.ogg', 35, 3, 3)
		FORSAKEN_MURDERER_EMOTE
/**
 * This happens when the abnormality breaches.
 * If your abnormality doesnt Breach then the proc you want is ZeroQliphoth.
 * Other abnormality procs can be found in the _abnormality.dm file.
 */
/mob/living/simple_animal/hostile/abnormality/forsaken_murderer/BreachEffect(mob/living/carbon/human/user, breach_type) //causes breach?
	. = ..()
	update_icon()
	//Flick replaces the icon_state with the one defined until all the frames in the animation are done.
	flick("forsakenmurderertransform", src)
	/**
	 * When i first heard about sleep being a proc that delays code progression until it is done it was said in hushed tones as if it was a taboo to use it.
	 * Also i set it to 13 because there is 12 frames in the flick icon and i wanted a additional 0.1 second for it to show.
	 * Just so you know most things without SECONDS or MINUTES after it are in deciseconds
	 */
	sleep(13)
	/**
	 * This made forsaken murderer waddle.
	 * Im supprised it was this easy to do this.
	 * Elements and Components are special non object code that you can attach to things.
	 * Element Variables are shared amongst all instances of it but component are individualand able to be altered without changing all the other instances of it.
	 */
	AddElement(/datum/element/waddling)
	/**
	 * 1 is distance thrown.
	 * False is if it can throw anchored objects.
	 * True if doesnt apply damage or stun when hits a wall.
	 */
	AddComponent(/datum/component/knockback, 1, FALSE, TRUE)
/**
 * This proc updates the icon state and is part of update_icon().
 * If your abnormality has multiple visual forms then you can define them here.
 */
/mob/living/simple_animal/hostile/abnormality/forsaken_murderer/update_icon_state()
	if(status_flags & GODMODE)
		// Not breaching
		icon_living = initial(icon)
		icon_state = icon_living
	else if(stat == DEAD)
		icon_state = icon_dead
	else
		icon_living = "forsakenmurdererbreach"
		icon_state = icon_living

//#undef undefines the definition at the end of this file so that it doesnt spread to the whole codebase.
#undef FORSAKEN_MURDERER_EMOTE
