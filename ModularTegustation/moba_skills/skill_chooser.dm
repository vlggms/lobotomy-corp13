/obj/item/class_chooser
	name = "L-Corp agent class chooser accelerator"
	desc = "A device used to choose your agent class."
	icon = 'icons/obj/device.dmi'
	icon_state = "nanite_comm_remote"

/obj/item/class_chooser/Initialize()
	. = ..()
	if(SSmaptype.chosen_trait != FACILITY_TRAIT_MOBA_AGENTS)
		qdel(src)
	QDEL_IN(src, 60 SECONDS)	//You MUST pick within 60 seconds

/obj/item/class_chooser/attack_self(mob/living/carbon/human/user)
	//Let you pick your agent class
	var/list/can_class = list(
		//Only Agents specifically and Dept Captains get this.
		//Might be good for Interns to not have this option
		//Captains belong to the "Command" Class
			"Agent",
			"Department Captain",
			)

	if(!(user?.mind?.assigned_role in can_class))
		return ..()


	var/list/classes = list(	//Classes that are JRPG Classes
			"Defensive",
			"Healing",
			"Ranged",
			"Skirmisher",
			)

	var/list/rare = list(	//Classes that are "Weird Shit"
			"Artificer",
			"Intelligence",
			"Officer"
			)

	var/list/available_classes = list(
			"Standard",
			//"Random",			Currently bugged
			)

	for(var/i in 1 to 2)		//You should only get to pick 1-3 of these.
		available_classes += pick_n_take(classes)
	available_classes += pick_n_take(rare)	//One rare class

	qdel(src)//Delete it here so you can't re-roll your class.

	var/choice = input(user, "Which Agent class will you choose?", "Select a class") as null|anything in available_classes
	if(!choice || !user.canUseTopic(get_turf(user), BE_CLOSE, FALSE, NO_TK))
		to_chat(user, span_notice("You decide to choose the 'Standard' class."))
		return

	classes-= "Random"
	if(choice == "Random")
		choice = pick(classes)

	switch(choice)


	//Standard Classes
		if("Defensive")
			to_chat(user, span_greenannounce("You have chosen the Defensive Agent class. In exchange for -10 Work rate and speed, you get 2 Defensive skills."))
			user.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, -10)

			var/datum/action/G = new /datum/action/cooldown/hunkerdown_agent
			G.Grant(user)
			G = new /datum/action/cooldown/parry
			G.Grant(user)

		if("Healing")
			to_chat(user, span_greenannounce("You have chosen the Healing Agent class. In exchange for -10 melee damage and movement speed, you get 2 Healing skills."))
			user.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, -10)

			var/datum/action/G = new /datum/action/cooldown/agent_healing
			G.Grant(user)
			G = new /datum/action/cooldown/agent_soothing
			G.Grant(user)

		if("Ranged")
			to_chat(user, span_greenannounce("You have chosen the Ranged Agent class. In exchange for 20% slower melee, you get a movement skill, a gun skill, and all guns scale justice 50%."))
			ADD_TRAIT(user, TRAIT_WEAK_MELEE, JOB_TRAIT)
			ADD_TRAIT(user, TRAIT_BETTER_GUNS, JOB_TRAIT)

			var/datum/action/G = new /datum/action/cooldown/agent_smokedash
			G.Grant(user)
			G = new /datum/action/cooldown/autoloader
			G.Grant(user)

		if("Skirmisher")
			to_chat(user, span_greenannounce("You have chosen the Skirmisher Agent class. In exchange for 25 lower HP and SP, you get 3 skills to increase movement speed."))
			user.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, -25)
			user.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, -25)

			var/datum/action/G = new /datum/action/cooldown/dash/agent
			G.Grant(user)
			G = new /datum/action/cooldown/blitz
			G.Grant(user)
			G = new /datum/action/cooldown/assault_agent
			G.Grant(user)



	//Weird shit
		if("Artificer")
			to_chat(user, span_greenannounce("You have chosen the Artificer Agent class. In exchange for -5 attack damage and movespeed, you get the ability to recharge all tools on your person."))
			user.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, -5)

			var/datum/action/G = new /datum/action/cooldown/charge
			G.Grant(user)

		if("Intelligence")
			to_chat(user, span_greenannounce("You have chosen the Intelligence Agent class. In exchange for -20 attack damage and movespeed, you get the ability to see all Health bars."))
			user.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, -20)
			var/datum/atom_hud/medsensor = GLOB.huds[DATA_HUD_MEDICAL_ADVANCED]
			medsensor.add_hud_to(user)


		if("Officer")
			to_chat(user, span_greenannounce("You have chosen the Officer Agent class. In exchange for -10 HP/SP, you get the ability to give agents around you major buffs."))
			user.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, -10)
			user.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, -10)

			var/datum/action/G = new /datum/action/cooldown/warbanner/captain
			G.Grant(user)

			G = new /datum/action/cooldown/warcry/captain
			G.Grant(user)


	return ..()
