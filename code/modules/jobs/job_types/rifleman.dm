/datum/job/agent/rifle
	title = "Agent Rifleman"
	department_head = list("Manager", "Agent Captain")
	total_positions = 4
	spawn_positions = 4
	selection_color = "#ccaaaa"

	outfit = /datum/outfit/job/agent/rifle
	display_order = JOB_DISPLAY_ORDER_WARDEN

	access = list(ACCESS_RIFLEMAN)
	minimal_access = list(ACCESS_RIFLEMAN)


/datum/outfit/job/agent/rifle
	name = "Agent Rifleman"
	jobtype = /datum/job/agent/rifle

	head = /obj/item/clothing/head/beret/sec
	backpack_contents = list()		//No baton



//Locker here, to prevent gear duping
/obj/structure/closet/secure_closet/rifleman
	name = "\proper rifleman's locker"
	req_access = list(ACCESS_RIFLEMAN)
	damage_deflection = 3000		//Fuck you.
	icon_state = "sec"

/obj/structure/closet/secure_closet/rifleman/PopulateContents()
	..()
	new /obj/item/gun/energy/e_gun/rifleman(src)

