// LOBOTOMYCORPORATION EDIT -- This whole un-modular monstrosity
GLOBAL_LIST_INIT(command_positions, list(
	"Manager",
	"Extraction Officer",
	"Records Officer",
	"Control Officer",
	"Training Officer",
	"Disciplinary Officer",
	"Sephirah",
	"Department Head",
	"Agent Captain",

	// City heads
	"Doctor",
	"Hana Administrator",
	"Association Section Director",
	"Index Messenger",
	"Blade Lineage Cutthroat",
	"Grand Inquisitor",
	"Thumb Sottocapo",
	"Kurokumo Kashira",

	// R-corp Fourth Pack
	"Ground Commander",
	"Lieutenant Commander",
	"Operations Officer",
	"Rabbit Squad Captain",
	"Reindeer Squad Captain",
	"Rhino Squad Captain",
	"Raven Squad Captain",

	// R-corp Fifth Pack
	"Assault Commander",
	"Base Commander",
	"Support Officer",
	"Rat Squad Leader",
	"Rooster Squad Leader",
	"Raccoon Squad Leader",
	"Roadrunner Squad Leader",

	// W-corp stuff
	"W-Corp Representative",
	"W-Corp L3 Squad Captain",

	// LCB Labs
	"District Manager",
	"LC Asset Protection",
	"Chief Medical Officer",
	"Lead Researcher",
	"High Security Commander",
	"Low Security Commander",
	))


GLOBAL_LIST_INIT(engineering_positions, list(
	"Containment Engineer", // LCB Labs
	))


GLOBAL_LIST_INIT(medical_positions, list(
	// LCB Labs
	"Chief Medical Officer",
	"Surgeon",
	"Nurse Practitioner",
	"Pharmacist",
	"Emergency Medical Technician",

	// City
	"Doctor",
	"Nurse",
	"Paramedic",
	"Medical Fixer Assistant",
	"Proshetics Surgeon",
	))


GLOBAL_LIST_INIT(science_positions, list(
	// LCB Labs
	"Lead Researcher",
	"Senior Researcher",
	"Information Systems Tech",
	"Research Archivist",
	"Researcher",
	"LC Staff",
	))


GLOBAL_LIST_INIT(supply_positions, list(
	))


GLOBAL_LIST_INIT(service_positions, list(
	"Clerk",
	"Agent Support Clerk",
	"Facility Support Clerk",

	"Proshetics Surgeon",
	"HHPP Chef",
	"Civilian",
	"Backstreets Butcher",
	"Carnival",
	"Workshop Attendant",
	"Main Office Representative",
	"Fishhook Office Fixer",

	// LCB Labs
	"LC Chef",
	"LC Janitor",
	))


GLOBAL_LIST_INIT(security_positions, list(
	"Department Head",
	"Department Captain",
	"Training Officer",

	"Disciplinary Officer",
	"Emergency Response Agent",

	"Agent Captain",
	"Agent Lieutenant",
	"Senior Agent",
	"Agent",
	"Agent Intern",

	// LCB Labs
	"High Security Commander",
	"Low Security Commander",
	"High Security Officer",
	"Low Security Officer",
	"Damage Mitigation Officer",
	"Damage Exasperation Officer",
	"Internal Police",
	))


GLOBAL_LIST_INIT(nonhuman_positions, list(
	))

// job categories for rendering the late join menu
GLOBAL_LIST_INIT(position_categories, list(
	// LOBOTOMYCORPORATION ADDITION START
	"W Corp" = list("jobs" = w_corp_positions, "color" = "#00b5ad"),
	"R Corp" = list("jobs" = r_corp_positions, "color" = "#f2711c"),
	"Hana" = list("jobs" = hana_positions, "color" = "#ffffff"),
	"Association" = list("jobs" = association_positions, "color" = "#5baa27"),
	"Syndicate" = list("jobs" = city_antagonist_positions, "color" = "#db2828"),
	"Fixers" = list("jobs" = fixer_positions, "color" = "#767676"),
	// LOBOTOMYCORPORATION ADDITION END
	EXP_TYPE_COMMAND = list("jobs" = command_positions, "color" = "#ccccff"),
	EXP_TYPE_ENGINEERING = list("jobs" = engineering_positions, "color" = "#ffeeaa"),
	EXP_TYPE_SUPPLY = list("jobs" = supply_positions, "color" = "#ddddff"),
	EXP_TYPE_SILICON = list("jobs" = nonhuman_positions - "pAI", "color" = "#ccffcc"),
	EXP_TYPE_SERVICE = list("jobs" = service_positions, "color" = "#bbe291"),
	EXP_TYPE_MEDICAL = list("jobs" = medical_positions, "color" = "#ffddf0"),
	EXP_TYPE_SCIENCE = list("jobs" = science_positions, "color" = "#ffddff"),
	EXP_TYPE_SECURITY = list("jobs" = security_positions, "color" = "#ffdddd"),
))

GLOBAL_LIST_INIT(exp_jobsmap, list(
// LOBOTOMYCORPORATION EDIT START
//	EXP_TYPE_CREW = list("titles" = command_positions | engineering_positions | medical_positions | science_positions | supply_positions | security_positions | service_positions | list("AI","Cyborg")), // crew positions
//	EXP_TYPE_COMMAND = list("titles" = command_positions),
	EXP_TYPE_CREW = list("titles" = command_positions | engineering_positions | medical_positions | science_positions | supply_positions | security_positions | service_positions | w_corp_positions | r_corp_positions | hana_positions | association_positions | city_antagonist_positions | list("AI","Cyborg")), // crew positions
	EXP_TYPE_COMMAND = list("titles" = command_positions | hana_positions),
// LOBOTOMYCORPORATION EDIT END
	EXP_TYPE_ENGINEERING = list("titles" = engineering_positions),
	EXP_TYPE_MEDICAL = list("titles" = medical_positions),
	EXP_TYPE_SCIENCE = list("titles" = science_positions),
	EXP_TYPE_SUPPLY = list("titles" = supply_positions),
//	EXP_TYPE_SECURITY = list("titles" = security_positions), // LOBOTOMYCORPORATION EDIT OLD
	EXP_TYPE_SECURITY = list("titles" = security_positions | city_antagonist_positions | association_positions | w_corp_positions | r_corp_positions | fixer_positions), // LOBOTOMYCORPORATION EDIT NEW
	EXP_TYPE_SILICON = list("titles" = list("AI","Cyborg")),
	EXP_TYPE_SERVICE = list("titles" = service_positions)
))

GLOBAL_LIST_INIT(exp_specialmap, list(
	EXP_TYPE_LIVING = list(), // all living mobs
	EXP_TYPE_ANTAG = list(),
	EXP_TYPE_SPECIAL = list("Lifebringer","Ash Walker","Exile","Servant Golem","Free Golem","Hermit","Translocated Vet","Escaped Prisoner","Hotel Staff","SuperFriend","Space Syndicate","Ancient Crew","Space Doctor","Space Bartender","Beach Bum","Skeleton","Zombie","Space Bar Patron","Lavaland Syndicate","Ghost Role"), // Ghost roles
	EXP_TYPE_GHOST = list() // dead people, observers
))
GLOBAL_PROTECT(exp_jobsmap)
GLOBAL_PROTECT(exp_specialmap)

//this is necessary because antags happen before job datums are handed out, but NOT before they come into existence
//so I can't simply use job datum.department_head straight from the mind datum, laaaaame.
/proc/get_department_heads(job_title)
	if(!job_title)
		return list()

	for(var/datum/job/J in SSjob.occupations)
		if(J.title == job_title)
			return J.department_head //this is a list

/proc/get_full_job_name(job)
	var/static/regex/cap_expand = new("cap(?!tain)")
	var/static/regex/cmo_expand = new("cmo")
	var/static/regex/hos_expand = new("hos")
	var/static/regex/hop_expand = new("hop")
	var/static/regex/rd_expand = new("rd")
	var/static/regex/ce_expand = new("ce")
	var/static/regex/qm_expand = new("qm")
	var/static/regex/sec_expand = new("(?<!security )officer")
	var/static/regex/engi_expand = new("(?<!station )engineer")
	var/static/regex/atmos_expand = new("atmos tech")
	var/static/regex/doc_expand = new("(?<!medical )doctor|medic(?!al)")
	var/static/regex/mine_expand = new("(?<!shaft )miner")
	var/static/regex/chef_expand = new("chef")
	var/static/regex/borg_expand = new("(?<!cy)borg")

	job = lowertext(job)
	job = cap_expand.Replace(job, "captain")
	job = cmo_expand.Replace(job, "chief medical officer")
	job = hos_expand.Replace(job, "head of security")
	job = hop_expand.Replace(job, "head of personnel")
	job = rd_expand.Replace(job, "research director")
	job = ce_expand.Replace(job, "chief engineer")
	job = qm_expand.Replace(job, "quartermaster")
	job = sec_expand.Replace(job, "security officer")
	job = engi_expand.Replace(job, "station engineer")
	job = atmos_expand.Replace(job, "atmospheric technician")
	job = doc_expand.Replace(job, "medical doctor")
	job = mine_expand.Replace(job, "shaft miner")
	job = chef_expand.Replace(job, "cook")
	job = borg_expand.Replace(job, "cyborg")
	return job
