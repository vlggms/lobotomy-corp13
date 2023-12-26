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

	var/datum/ego_gifts/target_gift = new target.gift_type
	user.Apply_Gift(target_gift)
	to_chat(user, span_nicegreen("[target.gift_message]"))
	playsound(get_turf(user), 'sound/items/toysqueak2.ogg', 10, 3, 3)
	to_chat(user, span_nicegreen("You aquire the [target]'s gift type"))
