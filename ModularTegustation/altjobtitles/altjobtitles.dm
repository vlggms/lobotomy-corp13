/datum/job
	var/list/alt_titles = list()
	var/senior_title
	var/ultra_senior_title // A god-like position of power!

/// Command
/datum/job/captain
	senior_title = "Commodore"
	ultra_senior_title = "Rear Admiral"

/// Security
/datum/job/hos
	alt_titles = list("Security Commander", "Chief of Security")

/datum/job/warden
	alt_titles = list("Brig Chief", "Master at Arms")

/datum/job/detective
	alt_titles = list("Forensics Specialist", "Investigator")
	senior_title = "Intelligence Officer"

/datum/job/officer
	alt_titles = list("Security Guard")
	senior_title = "Security Sergeant"

/datum/job/tegu/deputy
	alt_titles = list("Cadet")

/// Science
/datum/job/rd
	alt_titles = list("Research Supervisor", "Research Manager")

/datum/job/scientist
	alt_titles = list("Xenobiologist", "Researcher", "Cytologist")
	senior_title = "Professor"

/datum/job/roboticist
	alt_titles = list("Biomechanical Engineer", "Mechatronic Engineer")
	senior_title = "Robotics Expert"

/// Medical
/datum/job/cmo
	alt_titles = list("Medical Director")

/datum/job/doctor
	alt_titles = list("Nurse", "Surgeon")
	senior_title = "Physician"

/datum/job/paramedic
	alt_titles = list("Corpsman")

/datum/job/chemist
	alt_titles = list("Pharmacist", "Pharmacologist")
	senior_title = "Senior Chemist"

/datum/job/virologist
	alt_titles = list("Pathologist")

/// Engineering
/datum/job/chief_engineer
	alt_titles = list("Chief Atmospheric Technician")

/datum/job/engineer
	alt_titles = list("Maintenance Technician", "Engine Technician", "Electrician", "Telecommunications Specialist")
	senior_title = "Senior Engineer"

/datum/job/atmos
	alt_titles = list("Firefighter", "Life Support Specialist")
	senior_title = "Senior Atmospheric Technician"

/// Supply

/datum/job/qm
	alt_titles = list("Supply Chief", "Requisitions Officer")

/datum/job/mining
	alt_titles = list("Explorer", "Prospector")
	senior_title = "Senior Miner"

/datum/job/cargo_tech
	alt_titles = list("Mailroom Technician", "Deliveries Officer")

/// Service
/datum/job/assistant
	alt_titles = list("Visitor", "Businessman", "Trader", "Entertainer")
	ultra_senior_title = "Assistinator"

/datum/job/cook
	alt_titles = list("Butcher", "Grillmaster")
	senior_title = "Chef"

/datum/job/bartender
	alt_titles = list("Barkeep")
	senior_title = "Master Mixologist"

/datum/job/hydro
	alt_titles = list("Herbalist", "Hydroponicist", "Beekeeper")
	senior_title = "Master Gardener"

/datum/job/curator
	alt_titles = list("Journalist", "Librarian")

/datum/job/janitor
	alt_titles = list("Sanitation Technician")

/datum/job/lawyer
	alt_titles = list("Attorney")
	senior_title = "Ace Attorney"

/datum/job/chaplain
	alt_titles = list("Counselor")
	senior_title = "Priest"
	ultra_senior_title = "Paladin"

/datum/job/clown
	alt_titles = list("Jester", "Comedian")
	senior_title = "Master Prankster"

/datum/job/mime
	alt_titles = list("Performer")
	senior_title = "Silent Artist"

/datum/job/prisoner
	alt_titles = list("Protected Custody")
