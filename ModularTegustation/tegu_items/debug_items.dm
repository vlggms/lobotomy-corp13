/**
 * This file is dedicated to items used in debugging things as an admin/developer
 * Remember that they are not meant to be balanced, they are meant to assist in development
 * Give it to players at your own risk
 */

/**
 * A basic box that spawns every subtype of /obj/item/lc_debug
 * This way we dont have to EVER edit when adding new debug items
 * ...unless we mess something up
 */
/obj/item/storage/box/lc_debugtools
	name = "box of LC13 debug tools"
	icon_state = "syndiebox"

/obj/item/storage/box/lc_debugtools/PopulateContents()
	for(var/item as anything in subtypesof(/obj/item/lc_debug))
		new item(src)

/**
 * The parent to all LC13 debug items
 * We use this to spawn all the debug items in a single box used for debugging
 * This box gets automatically placed within the inventory of the 'DEBUG' pre-set equipment (/datum/outfit/debug)
 * No player or admin should ever see this item, if they do. We fucked up with spawning ONLY subtypes of the items
 * That or the developer forgot to give an item a proper name/description
 */
/obj/item/lc_debug
	name = "basic LC debug item"
	desc = "This item is used for LC13 debug items to be a subtype of it. If you see this in-game as eighter an admin or a player without spawning this in, please contact coders"
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	w_class = WEIGHT_CLASS_SMALL

/**
 * A simple item that gives anyone whom uses it injection_amount attributes
 * You can set the amount of attributes injected by clicking on the item
 * That way you can add or remove however many attributes you need for your testing
 */
/obj/item/lc_debug/attribute_injector
	name = "attribute injector"
	desc = "A fluid used to drastically change an employee for tests. Use onto humans to activate."
	icon_state = "oddity7"
	var/injection_amount = 130

/obj/item/lc_debug/attribute_injector/examine(mob/user)
	. = ..()
	. += span_mind_control("When used in hand it will let you choose the amount of attributes injected, currently injecting [injection_amount]")
	. += span_mind_control("When used it will add [injection_amount] attributes of all types to whomever you hit it with, for testing level specific tresholds")
	. += span_mind_control("The injector accepts both positive and negative values")

/obj/item/lc_debug/attribute_injector/attack_self(mob/living/carbon/human/user)
	injection_amount = input(user, "Select the attribute injection amount", "Attribute injector", "[injection_amount]") as num|null

/obj/item/lc_debug/attribute_injector/attack(mob/living/carbon/human/target, mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("Attributes injected"))
	to_chat(target, span_danger("You feel a tiny prick"))
	target.adjust_all_attribute_levels(injection_amount)

/**
 * Very similar to /obj/item/trait_injector/agent_workchance_trait_injector
 * except this one has no safeties in terms of who can use it
 */
/obj/item/lc_debug/work_chance_injector
	name = "Agent Work Chance Injector"
	desc = "An injector containing liquid that allows agents to view their chances before work. Use in hand to activate."
	icon_state = "oddity7_orange"

/obj/item/lc_debug/work_chance_injector/examine(mob/user)
	. = ..()
	. += span_mind_control("When used it will give you the TRAIT_WORK_KNOWLEDGE trait, making you able to see work chances on consoles")

/obj/item/lc_debug/work_chance_injector/attack_self(mob/living/carbon/human/user)
	ADD_TRAIT(user, TRAIT_WORK_KNOWLEDGE, JOB_TRAIT)
	to_chat(user, span_nicegreen("Trait injected"))

/obj/item/lc_debug/work_chance_injector/attack(mob/living/carbon/human/target, mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("Trait injected"))
	to_chat(target, span_danger("You feel a tiny prick"))
	ADD_TRAIT(target, TRAIT_WORK_KNOWLEDGE, JOB_TRAIT)

/**
 * Again, similar to /obj/item/trait_injector/clerk_fear_immunity_injector
 * and to everyone's suprise, this one is also un-restricted
 */
/obj/item/lc_debug/fear_immunity_injector
	name = "C-Fear Protection Injector"
	desc = "Contains fire water that protects clerks from the downsides of witnessing dangerous abnormalities. Use in hand to activate."
	icon_state = "oddity7_firewater"

/obj/item/lc_debug/fear_immunity_injector/examine(mob/user)
	. = ..()
	. += span_mind_control("When used it will give you the TRAIT_COMBATFEAR_IMMUNE trait, making you immune to fear from breached abnormalities and people dying")

/obj/item/lc_debug/fear_immunity_injector/attack_self(mob/living/carbon/human/user)
	ADD_TRAIT(user, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	to_chat(user, span_nicegreen("Trait injected"))

/obj/item/lc_debug/fear_immunity_injector/attack(mob/living/carbon/human/target, mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("Trait injected"))
	to_chat(target, span_danger("You feel a tiny prick"))
	ADD_TRAIT(target, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)

/**
 * An item used to get gifts of a particular abnormality by hitting it
 * It will not work on non-abnormalities or abnormalities without gifts
 */
/obj/item/lc_debug/gift_extractor
	name = "gift extractor"
	desc = "Unpopular due to its excessive energy use, this device extracts gifts from an entity on demand."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "nanoimplant"

/obj/item/lc_debug/gift_extractor/examine(mob/user)
	. = ..()
	. += span_mind_control("You can hit any abnormality with this item to get its gift, if it has one")

/obj/item/lc_debug/gift_extractor/attack(mob/living/simple_animal/hostile/abnormality/target, mob/living/carbon/human/user)
	if(!isabnormalitymob(target))
		to_chat(user, span_warning("\"[target]\" doesn't classify as an Abnormality."))
		playsound(get_turf(user), 'sound/items/toysqueak2.ogg', 10, 3, 3)
		return
	if(!target.gift_type)
		to_chat(user, span_notice("\"[target]\" has no gift type."))
		playsound(get_turf(user), 'sound/items/toysqueak2.ogg', 10, 3, 3)
		return

	var/datum/ego_gifts/target_gift
	if(target.secret_abnormality && target.secret_gift)
		target_gift = new target.secret_gift
	else
		target_gift = new target.gift_type

	user.Apply_Gift(target_gift)
	to_chat(user, span_nicegreen("[target.gift_message]"))
	playsound(get_turf(user), 'sound/items/toysqueak2.ogg', 10, 3, 3)
	to_chat(user, span_nicegreen("You aquire the [target]'s gift type"))

/**
 * An item used to test debugging features with work consoles of abnormalities
 * REALLY usefull when trying to test something out
 * This from all the other items, is a REAL problem if it gets to players
 * So give it at your own discretion, once again <3
 */

/obj/item/lc_debug/console_manipulator
	name = "Abnormality work console manipulator"
	desc = "A strange device that interacts with abnormality consoles in curious ways, banned by L-corp for its extremelly dangerous use cases"
	icon_state = "watch_cobalt"
	///The action you perform on the console itself in attack_obj()
	var/selected_action = "Start a cell meltdown"
	///The actions you can pick in the menu during attack_self()
	var/avaible_actions = list(
		"Start a cell meltdown",
		"Force a cell meltdown",
		"Scramble work types",
		"Force work result",
	)

/obj/item/lc_debug/console_manipulator/examine(mob/user)
	. = ..()
	. += span_mind_control("When used in hand it will let you select an action to perform on an abnormality console")
	. += span_mind_control("\"Start a cell meltdown\" will simulate what happens if a random meltdown targets the console")
	. += span_mind_control("\"Force a cell meltdown\" will simulate what happens at the end of a meltdown")
	. += span_mind_control("\"Scramble work types\" will simulate the control supression's scramble")
	. += span_mind_control("\"Force work result\" Will force a work result (for example: Good 12/12 PE)")
	. += span_mind_control("Current action: [selected_action]")

/obj/item/lc_debug/console_manipulator/attack_self(mob/living/carbon/human/user)
	selected_action = input(user, "Select the action you want to perform on the console", "Console manipulator") as null|anything in avaible_actions

/obj/item/lc_debug/console_manipulator/attack_obj(obj/machinery/computer/abnormality/targeted_console, mob/living/carbon/human/user)
	if(!istype(targeted_console, /obj/machinery/computer/abnormality))
		to_chat(user, span_danger("ERROR: this manipulator only works on consoles"))
		return

	switch(selected_action)
		if("Start a cell meltdown")
			targeted_console.start_meltdown()

		if("Force a cell meltdown")
			targeted_console.qliphoth_meltdown_effect()

		if("Scramble work types")
			targeted_console.Scramble()

		if("Force work result")
			var/avaible_works = targeted_console.datum_reference.available_work
			var/work_type = input(user, "Select what work type do you wish to simulate", "Console manipulator") as null|anything in avaible_works
			var/success_boxes = input(user, "Select how many boxes did you \"make\"", "Console manipulator") as num|null
			var/work_speed = input(user, "Select how long did it take for you to finish the work in seconds", "Console manipulator") as num|null
			work_speed = work_speed * 10 // convert it into seconds

			if(work_type == null || success_boxes == null) // they cancelled one of the prompts ;-;
				to_chat(user, span_danger("ERROR: Work simulation failed, please select proper variables"))
				return

			targeted_console.meltdown = FALSE // Reset meltdown, without this the meltdown would instantly trigger
			targeted_console.finish_work(user, work_type, success_boxes, work_speed)

	to_chat(user, span_nicegreen("Console manipulated"))

/**
 * A simple item to grant the sephirah TGUI action panel
 * relevant files:
 * code/modules/jobs/job_types/trusted_player/sephirah.dm -- The panel's button and data
 * tgui/packages/tgui/interfaces/SephirahPanel.js -- The panel's JS counterpart
 */
/obj/item/lc_debug/sephirah_action_granter
	name = "debug sephirah action granter"
	desc = "A strange wooden sign with the words \"THE ROBITS GRIFF ME!!!\" inscribed upon it"
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "picket"

/obj/item/lc_debug/sephirah_action_granter/examine(mob/user)
	. = ..()
	. += span_mind_control("When used in hand it gives you a special button on the top-left of your screen to open the sephirah game panel.")

/obj/item/lc_debug/sephirah_action_granter/attack_self(mob/living/user)
	. = ..()
	var/datum/action/sephirah_game_panel/new_action = new(user.mind || user)
	new_action.Grant(user)

//Test dummy and spawner
/obj/item/lc_debug/debugdummyspawner
	name = "dummy spawner"
	desc = "Summons an immortal test dummy to your location."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "skub"

/obj/item/lc_debug/debugdummyspawner/attack_self(mob/living/carbon/human/user)
	playsound(get_turf(user), 'sound/items/toysqueak2.ogg', 10, 3, 3)
	new /mob/living/simple_animal/hostile/debugdummy(get_turf(src))
	qdel(src)

/mob/living/simple_animal/hostile/debugdummy
	name = "Test Dummy"
	desc = "Records damage dealt."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "training_rabbit"
	icon_living = "training_rabbit"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	maxHealth = 99999999
	health = 99999999
	var/dps_mode = FALSE
	var/interval = null
	var/dps_timer
	var/accumulated_damage = 0
	pet_bonus = "beeps" //saves a few lines of code by allowing funpet() to be called by attack_hand()

/mob/living/simple_animal/hostile/debugdummy/Initialize()
	. = ..()
	toggle_ai(AI_OFF)

/mob/living/simple_animal/hostile/debugdummy/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	return FALSE

/mob/living/simple_animal/hostile/debugdummy/adjustBruteLoss(amount, updating_health = TRUE, forced = FALSE)
	var/damage_dealt
	if(forced)
		damage_dealt = amount * CONFIG_GET(number/damage_multiplier)
	else
		damage_dealt = amount * damage_coeff.brute * CONFIG_GET(number/damage_multiplier)
	if(!dps_mode)
		say("Ow! That dealt [damage_dealt] brute damage!")
	accumulated_damage += damage_dealt

/mob/living/simple_animal/hostile/debugdummy/adjustFireLoss(amount, updating_health = TRUE, forced = FALSE)
	var/damage_dealt
	if(forced)
		damage_dealt = amount * CONFIG_GET(number/damage_multiplier)
	else
		damage_dealt = amount * damage_coeff.fire * CONFIG_GET(number/damage_multiplier)
	if(!dps_mode)
		say("Ow! That dealt [damage_dealt] fire damage!")
	accumulated_damage += damage_dealt

/mob/living/simple_animal/hostile/debugdummy/adjustRedLoss(amount, updating_health = TRUE, forced = FALSE)
	var/damage_dealt
	if(forced)
		damage_dealt = amount * CONFIG_GET(number/damage_multiplier)
	else
		damage_dealt = amount * damage_coeff.red * CONFIG_GET(number/damage_multiplier)
	if(!dps_mode)
		say("Ow! That dealt [damage_dealt] red damage!")
	accumulated_damage += damage_dealt

/mob/living/simple_animal/hostile/debugdummy/adjustWhiteLoss(amount, updating_health = TRUE, forced = FALSE, white_healable = FALSE)
	var/damage_dealt
	if(forced)
		damage_dealt = amount * CONFIG_GET(number/damage_multiplier)
	else
		damage_dealt = amount * damage_coeff.white * CONFIG_GET(number/damage_multiplier)
	if(!dps_mode)
		say("Ow! That dealt [damage_dealt] white damage!")
	accumulated_damage += damage_dealt

/mob/living/simple_animal/hostile/debugdummy/adjustBlackLoss(amount, updating_health = TRUE, forced = FALSE, white_healable = FALSE)
	var/damage_dealt
	if(forced)
		damage_dealt = amount * CONFIG_GET(number/damage_multiplier)
	else
		damage_dealt = amount * damage_coeff.black * CONFIG_GET(number/damage_multiplier)
	if(!dps_mode)
		say("Ow! That dealt [damage_dealt] black damage!")
	accumulated_damage += damage_dealt

/mob/living/simple_animal/hostile/debugdummy/adjustPaleLoss(amount, updating_health = TRUE, forced = FALSE)
	var/damage_dealt
	if(forced)
		damage_dealt = amount * CONFIG_GET(number/damage_multiplier)
	else
		damage_dealt = amount * damage_coeff.pale * CONFIG_GET(number/damage_multiplier)
	if(!dps_mode)
		say("Ow! That dealt [damage_dealt] pale damage!")
	accumulated_damage += damage_dealt

/mob/living/simple_animal/hostile/debugdummy/Move()
	return FALSE

/mob/living/simple_animal/hostile/debugdummy/funpet(mob/petter)
	switch(tgui_alert(petter, "Would you like to test DPS?", "DPS TESTING MODE", list("Yes", "No thanks"), timeout = 0))
		if("Yes")
			var/userinput
			userinput = input(petter, "For how long, in seconds? Be aware that low durations tend to be less accurate.", "DPS TESTING MODE ENABLED")
			if(!text2num(userinput))
				say("ERROR - Not a number!")
				return
			var/newvalue = text2num(userinput)
			if(newvalue <= 0)
				say("ERROR - Too low of a number!")
				return
			interval = (newvalue *= 10)
		if("No thanks")
			if(dps_mode)
				say("DPS mode has been turned off!")
				if(dps_timer)
					deltimer(dps_timer)
					dps_timer = null
			dps_mode = FALSE
			return
	dps_mode = TRUE
	DeepsCheckStart()

/mob/living/simple_animal/hostile/debugdummy/proc/DeepsCheckStart()
	if(!dps_mode)
		return
	if(dps_timer)
		return
	say("DPS check will start in three seconds!")
	SLEEP_CHECK_DEATH(5)
	say("3!")
	SLEEP_CHECK_DEATH(10)
	say("2!")
	SLEEP_CHECK_DEATH(10)
	say("1!")
	SLEEP_CHECK_DEATH(10)
	if(!dps_mode) //We check again here in case it was turned off during the countdown
		return
	dps_timer = addtimer(CALLBACK(src, PROC_REF(DeepsCheck)), interval, TIMER_STOPPABLE)
	say("Go!")

/mob/living/simple_animal/hostile/debugdummy/proc/DeepsCheck()
	if(dps_timer)
		deltimer(dps_timer)
		dps_timer = null
	if(!dps_mode)
		accumulated_damage = 0
		return
	if(!accumulated_damage)
		say("You didn't deal any damage at all!")
	else
		say("Ow! That dealt [accumulated_damage / (interval / 10)] damage per second for a total of [accumulated_damage] damage!")
	accumulated_damage = 0
	SLEEP_CHECK_DEATH(10)
	say("Restarting...")
	SLEEP_CHECK_DEATH(10)
	DeepsCheckStart()

//breach tester
/obj/item/lc_debug/breachtester//for testing many abnormalities very quickly
	name = "Breach tester"
	desc = "For testing use only, DO NOT DISTRIBUTE! Breach types can be checked under _DEFINES/abnormalities.dm"
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "nanoimplant"
	var/breach_type = BREACH_NORMAL
	var/list/breach_list = list(
			BREACH_NORMAL, BREACH_PINK, BREACH_MINING,
	)

/obj/item/lc_debug/breachtester/attack_self(mob/user)
	breach_type = input(user, "Which breach will you test?") as null|anything in breach_list

/obj/item/lc_debug/breachtester/attack(mob/living/simple_animal/hostile/abnormality/target, mob/living/carbon/human/user)
	if(!isabnormalitymob(target))
		to_chat(user, span_warning("\"[target]\" isn't an Abnormality."))
		return
	target.BreachEffect(user, breach_type)
	to_chat(user, span_nicegreen("You triggered a [breach_type] breach!"))


