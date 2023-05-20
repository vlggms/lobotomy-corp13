
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
		to_chat(user, "<span class='notice'>The injector light flashes red. [error_message] Check the label before use.</span>")
		return
	InjectTrait(user)

/obj/item/trait_injector/proc/InjectTrait(mob/living/carbon/human/user)
	to_chat(user, "<span class='nicegreen'>The injector blinks green before it disintegrates. [success_message]</span>")
	if(trait)
		ADD_TRAIT(user, trait, JOB_TRAIT)
	qdel(src)
	return

/obj/item/trait_injector/officer_upgrade_injector
	name = "Officer Upgrade Injector"
	desc = "A strange liquid used to improve an officer's skills. Use in hand to activate. A small note on the injector states that 'officer' means Extraction Officer and Records Officer."
	icon_state = "oddity7_gween"
	roles = list("Records Officer", "Extraction Officer")
	error_message = "You aren't an officer."
	success_message = "You feel vigourous and stronger."

/obj/item/trait_injector/officer_upgrade_injector/InjectTrait(mob/living/carbon/human/user)
	user.adjust_all_attribute_levels(20)
	..()
	return

/obj/item/trait_injector/agent_workchance_trait_injector
	name = "Agent Work Chance Injector"
	desc = "An injector containing liquid that allows agents to view their chances before work. Use in hand to activate. A small note on the injector states that 'agent' means anyone under the security detail. Another note states that Officers aren't security detail."
	icon_state = "oddity7_orange"
	trait = TRAIT_WORK_KNOWLEDGE
	error_message = "You aren't an agent."
	success_message = "You feel enlightened and wiser."

/obj/item/trait_injector/agent_workchance_trait_injector/Initialize()
	. = ..()
	roles = GLOB.security_positions

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
		..()
		return
	to_chat(user,"<span class='userdanger'>The injector burns red before switching to green and dissapearing. You feel uneasy.</span>")
	qdel(src)
	sleep(rand(20, 50)) // 2 to 5 seconds
	if(prob(70))
		new /mob/living/simple_animal/hostile/shrimp(get_turf(user))
	else
		new /mob/living/simple_animal/hostile/shrimp_soldier(get_turf(user))
	user.gib()
