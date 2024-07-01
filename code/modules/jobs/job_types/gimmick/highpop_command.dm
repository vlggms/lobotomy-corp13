//This is a temporary file as more maps get access to these roles.

//Control
/datum/job/command/control
	title = "Control Officer"
	outfit = /datum/outfit/job/command/control
	exp_requirements = 360
	job_important = "\
		You are the Control Officer. Your job is to manage PE refining, representative interactions, and the sales of PE. \
		Manage clerks to create PE for you, and make sure that they are properly assisting the facility. \
		Once you gather Refined PE, sell it in your office, the Representative, or send to the Extraction Officer. \
	"
	job_abbreviation = "CO"
	maptype = "highpop"

/datum/outfit/job/command/control
	name = "Control Officer"
	jobtype = /datum/job/command/control
	suit =  /obj/item/clothing/suit/armor/control
	ears = /obj/item/radio/headset/heads/headset_control
