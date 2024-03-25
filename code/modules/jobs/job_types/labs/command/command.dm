/datum/job/district_manager
	title = "District Manager"
	faction = "Station"
	supervisors = "LCB Executive Manager"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#aabbcc"

	outfit = /datum/outfit/job/district_manager

	access = list(ACCESS_ARMORY, ACCESS_SECURITY, ACCESS_RND, ACCESS_MEDICAL, ACCESS_COMMAND, ACCESS_MANAGER)
	minimal_access = list(ACCESS_ARMORY, ACCESS_SECURITY, ACCESS_RND, ACCESS_MEDICAL, ACCESS_COMMAND, ACCESS_MANAGER)

	job_attribute_limit = 0

	display_order = 1
	alt_titles = list()
	maptype = "limbus_labs"
	job_important = "You are the District Manager. Your job is to ensure everybody is following proper procedure."



/datum/outfit/job/district_manager
	name = "District Manager"
	jobtype = /datum/job/district_manager

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/heads/manager/alt
	uniform = /obj/item/clothing/under/suit/lobotomy
	suit = /obj/item/clothing/suit/toggle/labcoat
	shoes = /obj/item/clothing/shoes/laceup
	l_pocket = /obj/item/radio



/datum/job/asset_protection
	title = "LC Asset Protection"
	faction = "Station"
	supervisors = "Limbus Company Executives"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#aabbcc"
	trusted_only = TRUE
	outfit = /datum/outfit/job/asset_protection

	access = list(ACCESS_ARMORY, ACCESS_SECURITY, ACCESS_RND, ACCESS_MEDICAL, ACCESS_COMMAND, ACCESS_MANAGER)
	minimal_access = list(ACCESS_ARMORY, ACCESS_SECURITY, ACCESS_RND, ACCESS_MEDICAL, ACCESS_COMMAND, ACCESS_MANAGER)

	job_attribute_limit = 0

	display_order = 1.5
	alt_titles = list()
	maptype = "limbus_labs"
	job_important = "You are the LC Asset Protection. Your job is to make sure that all assets are taken care of, and that no abnormalites are suppressed. Report to the Executives (Admins) as needed."



/datum/outfit/job/asset_protection
	name = "LC Asset Protection"
	jobtype = /datum/job/asset_protection

	belt = /obj/item/pda/security
	ears = /obj/item/radio/headset/heads/manager/alt
	uniform = /obj/item/clothing/under/suit/lobotomy
	suit = /obj/item/clothing/suit/toggle/labcoat
	shoes = /obj/item/clothing/shoes/laceup
	l_pocket = /obj/item/radio

