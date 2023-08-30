//Index Proxy
/datum/job/proxy
	title = "Index Proxy"
	outfit = /datum/outfit/job/proxy
	department_head = list("the will of the prescript")
	faction = "Station"
	supervisors = "the will of the prescript"
	selection_color = "#aaaaaa"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_SYNDICATEVET
	access = list(ACCESS_SYNDICATE)
	minimal_access = list(ACCESS_SYNDICATE)
	paycheck = 200
	maptype = list("city")
	job_important = "You are a veteran in the Index syndicate. You are not inherently hostile. \
			Your goal is mainly to follow the will of prescripts you are given, your secondary goal is to follow the messenger. \
			Your base is hidden in the alleyway in the east behind the NO ENTRY Door."
	job_notice = "Avoid killing other players without a reason. Killing a player for stopping your prescripts is a valid reason."


	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 80,
								PRUDENCE_ATTRIBUTE = 80,
								TEMPERANCE_ATTRIBUTE = 80,
								JUSTICE_ATTRIBUTE = 80
								)

/datum/job/proxy/after_spawn(mob/living/carbon/human/H, mob/M)
	ADD_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE, JOB_TRAIT)
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)
	..()


/datum/outfit/job/proxy
	name = "Index Proxy"
	jobtype = /datum/job/proxy

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/syndicatecity
	uniform = /obj/item/clothing/under/suit/lobotomy/plain
	glasses = /obj/item/clothing/glasses/sunglasses
	backpack_contents = list()
	shoes = /obj/item/clothing/shoes/laceup
