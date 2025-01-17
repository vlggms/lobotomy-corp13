//BL Cutthroat
/datum/job/cutthroat
	title = "Blade Lineage Cutthroat"
	outfit = /datum/outfit/job/cutthroat
	department_head = list("the code of honor")
	faction = "Station"
	supervisors = "the code of honor"
	selection_color = "#59578a"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_SYNDICATEHEAD
	trusted_only = TRUE
	access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)
	minimal_access = list(ACCESS_SYNDICATE, ACCESS_SYNDICATE_LEADER)
	departments = DEPARTMENT_COMMAND | DEPARTMENT_CITY_ANTAGONIST
	paycheck = 700
	maptype = list("city")
	job_important = "This is a roleplay role. You are the leader of this band of wandering swordsmen. \
			Your group structure is loose, but you provide guidance. \
			In an honorable duel, the loser should be brought to a doctor, out of courtesy to their skill. \
			Seek honor, seek to kill the strong, and take money for your slaughter if the opportunity arrives. \
			Using a disguise is dishonorable, as is using ranged weapons and stun weapons, and attacking someone that is not significantly stronger than you while not in an agreed duel. \
			If anyone uses cheese tactics against you, or attacks you for no reason while not in a duel, they are dishonorable. \
			You, or anyone in blade lineage may kill anyone dishonorable in any way, without hesitation, or remorse. \
			Your base is hidden in the alleyway in the east behind the NO ENTRY Door."
	job_notice = "Avoid killing other players without a reason. Killing weak players not in self-defense is cowardly."


	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 100,
								PRUDENCE_ATTRIBUTE = 100,
								TEMPERANCE_ATTRIBUTE = 100,
								JUSTICE_ATTRIBUTE = 100
								)

/datum/job/cutthroat/after_spawn(mob/living/carbon/human/H, mob/M)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	//Don't spawn these goobers without a director.
	for(var/datum/job/processing in SSjob.occupations)
		if(istype(processing, /datum/job/salsu))
			processing.total_positions = 2

	//Someone for them to fight, and give the fixers a scare.
		if(istype(processing, /datum/job/butcher))
			processing.total_positions = 2
	. = ..()


/datum/outfit/job/cutthroat
	name = "Blade Lineage Cutthroat"
	jobtype = /datum/job/cutthroat

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/syndicatecity/heads
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	backpack_contents = list(/obj/item/structurecapsule/syndicate/bladelineage)
	shoes = /obj/item/clothing/shoes/laceup
