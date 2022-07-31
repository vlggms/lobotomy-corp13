/// Security
/datum/job/agent
	alt_titles = list("Newbie Agent")
	senior_title = "Senior Agent"
	ultra_senior_title = "Veteran Agent"

/datum/job/agent/captain
	alt_titles = list()
	senior_title = null
	ultra_senior_title = null

/// Service
/datum/job/assistant
	alt_titles = list("Control Department Clerk", "Information Department Clerk",
			"Training Department Clerk", "Safety Department Clerk",
			"Welfare Department Clerk", "Disciplinary Department Clerk",
			"Command Department Clerk", "Extraction Department Clerk", "Record Department Clerk")

/datum/outfit/job/assistant/controldepartmentclerk
	name = "Clerk (Control)"
	uniform = /obj/item/clothing/under/suit/lobotomy/control


/datum/outfit/job/assistant/informationdepartmentclerk
	name = "Clerk (Information)"
	uniform = /obj/item/clothing/under/suit/lobotomy/information


/datum/outfit/job/assistant/trainingdepartmentclerk
	name = "Clerk (Training)"
	uniform = /obj/item/clothing/under/suit/lobotomy/training


/datum/outfit/job/assistant/safetydepartmentclerk
	name = "Clerk (Safety)"
	uniform = /obj/item/clothing/under/suit/lobotomy/safety


/datum/outfit/job/assistant/welfaredepartmentclerk
	name = "Clerk (Welfare)"
	uniform = /obj/item/clothing/under/suit/lobotomy/welfare


/datum/outfit/job/assistant/disciplinarydepartmentclerk
	name = "Clerk (Discipline)"
	uniform = /obj/item/clothing/under/suit/lobotomy/discipline


/datum/outfit/job/assistant/commanddepartmentclerk
	name = "Clerk (Command)"
	uniform = /obj/item/clothing/under/suit/lobotomy/command

/datum/outfit/job/assistant/extractiondepartmentclerk
	name = "Clerk (Extraction)"
	uniform = /obj/item/clothing/under/suit/lobotomy/extraction

/datum/outfit/job/assistant/recorddepartmentclerk
	name = "Clerk (Record)"
	uniform = /obj/item/clothing/under/suit/lobotomy/records
