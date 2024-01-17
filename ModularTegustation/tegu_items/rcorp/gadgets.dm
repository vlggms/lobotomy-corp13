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
