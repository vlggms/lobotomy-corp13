/obj/item/disk/nuclear/rcorp
	name = "r-corp command tracker"
	desc = "Hold this on your person to let any rabbits know your precise location."
	icon_state = "servo"

/obj/item/pinpointer/nuke/rcorp
	name = "r-corp command tracker"
	desc = "This tracks the current holder of the command tracker."

/obj/item/pinpointer/nuke/rcorp/Initialize()
	..()
	toggle_on()

//Shelters
/datum/map_template/shelter/command
	name = "Large Command Shelter"
	shelter_id = "shelter_command"
	description = "A little bit of requisitions, medical and command equipment is all here."
	mappath = "_maps/templates/shelter_command.dmm"

/obj/item/survivalcapsule/rcorpcommand
	name = "large command shelter capsule"
	desc = "A luxury command post in a capsule."
	template_id = "shelter_command"

/datum/map_template/shelter/smallcommand
	name = "Small Command Shelter"
	shelter_id = "shelter_smallcommand"
	description = "A little bit of requisitions, medical and command equipment is all here."
	mappath = "_maps/templates/shelter_smallcommand.dmm"

/obj/item/survivalcapsule/rcorpsmallcommand
	name = "small command shelter capsule"
	desc = "A small command post in a capsule."
	template_id = "shelter_smallcommand"

//Announcement machines
/obj/item/announcementmaker
	name = "r-corp announcement tablet"
	desc = "A special tablet used by R-Corp Ground Commanders to make rapid announcements during pack deployments."
	icon = 'icons/obj/modular_tablet.dmi'
	icon_state = "tablet-red"

/obj/item/announcementmaker/attack_self(mob/living/user)
	..()
	var/input = stripped_input(user,"What do you want announce?", ,"Test Announcement")
	minor_announce("[input]" , "Announcement from: [user.name]")

//Tablet variants
/obj/item/announcementmaker/wcorp
	name = "w-corp announcement tablet"
	desc = "A special tablet used by WARP Clean up L2-LT agents to make rapid announcements on the battlefield."
	icon_state = "tablet-blue"

/obj/item/announcementmaker/lcorp
	name = "l-corp announcement tablet"
	desc = "A special tablet used by L-Corp Agent Captains to make rapid announcements during ongoing breaches and meltdowns."
	icon_state = "tablet-brown"
