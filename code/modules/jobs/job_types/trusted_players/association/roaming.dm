//Associate fixer
/datum/job/associateroaming
	title = "Roaming Association Fixer"
	outfit = /datum/outfit/job/associate
	department_head = list("Hana association")
	faction = "Station"
	supervisors = "hana association"
	selection_color = "#e09660"
	total_positions = 0
	spawn_positions = 0
	display_order = JOB_DISPLAY_ORDER_FIXER
	trusted_only = TRUE
	access = list(ACCESS_NETWORK)
	minimal_access = list(ACCESS_NETWORK)
	departments = DEPARTMENT_HANA | DEPARTMENT_FIXERS
	paycheck = 700
	maptype = list("fixers", "city")

	//They actually need this for their weapons
	roundstart_attributes = list(
								FORTITUDE_ATTRIBUTE = 100,
								PRUDENCE_ATTRIBUTE = 100,
								TEMPERANCE_ATTRIBUTE = 100,
								JUSTICE_ATTRIBUTE = 100
								)
	job_important = "This is a role to assist existing offices in getting a foothold in the city. You are not to enter the backstreets alone."
	job_notice = "You are to assist the offices in their backstreet endeavors. Cryoing to re-roll your association is not allowed and will result in a de-trusting. \
		You are a fixer that recently blew into town to assist the local offices in their endeavors."

	var/list/associations = list("zwei","shi5", "liu5", "seven")
	var/list/uncommon_associations = list("shi2", "cinq", "liu1")
	var/list/rare_associations = list("hana", "liu2")

/datum/job/associateroaming/after_spawn(mob/living/carbon/human/H, mob/M)
	//Not fear immune you're basically some goober
	ADD_TRAIT(H, TRAIT_WORK_FORBIDDEN, JOB_TRAIT)	//My guy you aren't even from this corporation
	H.set_attribute_limit(100)
	. = ..()

	//Weight it a little
	var/chosen_asso = pick(associations)
	if(prob(30))
		chosen_asso = pick(uncommon_associations)
	if(prob(10))
		chosen_asso = pick(rare_associations)

	var/armor
	var/weapon

	//So these are big because I want there to be an even distribution between them
	switch(chosen_asso)
		if("hana")
			armor = /obj/item/clothing/suit/armor/ego_gear/city/hanacombat
			weapon = /obj/item/ego_weapon/city/hana

		if("zwei")
			armor = /obj/item/clothing/suit/armor/ego_gear/city/zwei
			weapon = /obj/item/ego_weapon/city/zweihander

		if("shi2")
			armor = /obj/item/clothing/suit/armor/ego_gear/city/shi
			weapon = /obj/item/ego_weapon/city/shi_assassin

		if("shi5")
			armor = /obj/item/clothing/suit/armor/ego_gear/city/shilimbus
			weapon = /obj/item/ego_weapon/city/shi_assassin

		if("cinq")
			armor = /obj/item/clothing/suit/armor/ego_gear/city/cinq
			weapon = /obj/item/ego_weapon/city/cinq

		if("liu1")
			armor = /obj/item/clothing/suit/armor/ego_gear/city/liu
			weapon = /obj/item/ego_weapon/city/liu/fire/fist

		if("liu2")
			armor = /obj/item/clothing/suit/armor/ego_gear/city/liuvet/section2
			weapon = /obj/item/ego_weapon/city/liu/fire/spear

		if("liu5")
			armor = /obj/item/clothing/suit/armor/ego_gear/city/liu/section5
			weapon = /obj/item/ego_weapon/city/liu/fist

		if("seven")
			armor = /obj/item/clothing/suit/armor/ego_gear/city/seven
			weapon = /obj/item/ego_weapon/city/seven

	H.equip_to_slot_or_del(new armor(H),ITEM_SLOT_HANDS)
	H.equip_to_slot_or_del(new weapon(H),ITEM_SLOT_HANDS)
