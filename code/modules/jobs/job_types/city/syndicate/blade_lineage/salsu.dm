//Index salsus
/datum/job/salsu
	title = "Blade Lineage Salsu"
	outfit = /datum/outfit/job/salsu
	department_head = list("the code of honor")
	faction = "Station"
	supervisors = "the code of honor"
	selection_color = "#72718a"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_SYNDICATEGOON
	access = list(ACCESS_SYNDICATE)
	minimal_access = list(ACCESS_SYNDICATE)
	departments = DEPARTMENT_CITY_ANTAGONIST
	paycheck = 150
	maptype = list("city")
	job_important = "You belong to the Blade Lineage, a band of wandering swordsmen. \
			Seek honor, seek to kill the strong, and take money for your slaughter if the opportunity arrives. \
			In an honorable duel, the loser should be brought to a doctor, out of courtesy to their skill. \
			Using a disguise is dishonorable, as is using ranged weapons and stun weapons, and attacking someone that is not significantly stronger than you while not in an agreed duel. \
			If anyone uses cheese tactics against you, or attacks you for no reason while not in a duel, they are dishonorable. \
			You, or anyone in blade lineage may kill anyone dishonorable in any way, without hesitation, or remorse."
	job_notice = "Avoid killing other players without a reason. Killing weak players not in self-defense is cowardly."


	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 60,
								PRUDENCE_ATTRIBUTE = 60,
								TEMPERANCE_ATTRIBUTE = 60,
								JUSTICE_ATTRIBUTE = 60
								)

/datum/job/salsu/after_spawn(mob/living/carbon/human/H, mob/M)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	. = ..()


/datum/outfit/job/salsu
	name = "Blade Lineage Salsu"
	jobtype = /datum/job/salsu

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/syndicatecity
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/laceup
