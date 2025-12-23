
/obj/item/trait_injector
	name = "Trait Injector"
	desc = "A blank trait injector that imbues certain roles with a specific trait."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "oddity7_firewater"
	var/list/roles = list()
	var/trait
	var/error_message = ""
	var/success_message = ""

/obj/item/trait_injector/attack_self(mob/living/carbon/human/user)
	if(!istype(user) || !(user.mind?.assigned_role in roles))
		to_chat(user, span_notice("The injector light flashes red. [error_message] Check the label before use."))
		return
	InjectTrait(user)

/obj/item/trait_injector/proc/InjectTrait(mob/living/carbon/human/user)
	if(trait)
		if(HAS_TRAIT(user, trait)) // we need to check for if there is a trait in the first place
			to_chat(user, span_notice("You wouldn't double-dip, would you?"))
			return
		ADD_TRAIT(user, trait, JOB_TRAIT)
	to_chat(user, span_nicegreen("The injector blinks green before it disintegrates. [success_message]"))
	qdel(src)
	return

/obj/item/trait_injector/agent_workchance_trait_injector
	name = "Agent Work Chance Injector"
	desc = "An injector containing liquid that allows agents to view their chances before work. Use in hand to activate. A small note on the injector states that 'agent' means anyone under the security detail. Another note states that Officers aren't security detail."
	icon_state = "oddity7_orange"
	trait = TRAIT_WORK_KNOWLEDGE
	error_message = "You aren't an agent."
	success_message = "You feel enlightened and wiser."

/obj/item/trait_injector/agent_workchance_trait_injector/attack_self(mob/living/carbon/human/user)
	if(!istype(user) || HAS_TRAIT(user, TRAIT_WORK_FORBIDDEN))
		to_chat(user, span_notice("The injector light flashes red. [error_message] Check the label before use."))
		return
	InjectTrait(user)

/obj/item/trait_injector/clerk_fear_immunity_injector
	name = "C-Fear Protection Injector"
	desc = "Contains fire water that protects clerks from the downsides of witnessing dangerous abnormalities. Use in hand to activate. A small note on the injector states that 'clerk' means anyone with a job under service positions."
	icon_state = "oddity7_firewater"
	trait = TRAIT_COMBATFEAR_IMMUNE
	error_message = "You aren't a clerk."
	success_message = "You feel emboldened and braver."

/obj/item/trait_injector/clerk_fear_immunity_injector/Initialize()
	. = ..()
	roles = GLOB.service_positions

/obj/item/trait_injector/shrimp_injector
	name = "Shrimp Injector"
	desc = "The injector contains a pink substance, is this really worth it? Usable by only clerks. Use in hand to activate. A small note on the injector states that 'clerk' means anyone with a job under service positions."
	icon_state = "oddity7_pink"
	error_message = "You aren't a clerk."
	success_message = "You feel pink? A catchy song about shrimp comes to mind."

/obj/item/trait_injector/shrimp_injector/Initialize()
	. = ..()
	roles = GLOB.service_positions

/obj/item/trait_injector/shrimp_injector/InjectTrait(mob/living/carbon/human/user)
	if(!faction_check(user.faction, list("shrimp")))
		user.faction |= "shrimp"
		return ..()
	to_chat(user, span_userdanger("The injector burns red before switching to green and dissapearing. You feel uneasy."))
	qdel(src)
	sleep(rand(2 SECONDS, 5 SECONDS))
	if(prob(30) || is_species(user, /datum/species/shrimp))
		new /mob/living/simple_animal/hostile/shrimp_soldier(get_turf(user))
	else
		new /mob/living/simple_animal/hostile/shrimp(get_turf(user))
	user.gib()
