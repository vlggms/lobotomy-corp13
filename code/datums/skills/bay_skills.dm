/datum/skill_list_bay
	var/name = "Default"
	var/unarmed = 0			// Increases unarmed damage.
	var/melee = 0			// Increases weapon damage + block chance with shields.
	var/engineering = 0		// Affects speed of do_afters with engi tools.
	var/chemistry = 0		// If too low - you'll have a delay before using chemistry machines.
	var/medical = 0			// First Aid. Affects speed of applying sutures/gauzes and fixing wounds.
	var/surgery = 0			// Surgery Steps speed.
	var/crafting = 0		// How fast you craft items.
	var/culinary = 0		// How fast you craft food.
	var/science = 0			// If too low - you'll have a delay before using some scientific machines.

/datum/skill_list_bay/proc/getRating(rating)
	return vars[rating]

/datum/skill_list_bay/proc/getList()
	return list("unarmed" = unarmed,\
		"melee" = melee,\
		"engineering" = engineering,\
		"chemistry" = chemistry,\
		"medical" = medical,\
		"surgery" = surgery,\
		"crafting" = crafting,\
		"culinary" = culinary,\
		"science" = science)

/datum/skill_list_bay/proc/ModifyValue(type="engineering", amount=0)
	vars[type] += amount

/*						Skill Notes about Machinery
*************************************************************************************
*	Engineering 2 is required for teleporter console to avoid delay.				*
*	Chemistry 2 is required to use most of the chemical machines with no delay.		*
*	Chemistry 4 is required to use PANDEMIC with no delay.							*
*	Science 2 is required for bunch of science machines to use without a delay.		*
*************************************************************************************
*/

/datum/skill_list_bay/assistant
	name = "Assistant"
	engineering = 1 // Greytide stationwide.
	crafting = 1

/datum/skill_list_bay/chaplain
	name = "Chaplain"
	melee = 2 // He is that crazy dude with a sword, after all.
	engineering = 2
	crafting = 1

/datum/skill_list_bay/curator // Yet another crazy dude.
	name = "Chaplain"
	melee = 1
	engineering = 2
	chemistry = 2
	crafting = 1
	science = 2 // He is so smart!!!!

/datum/skill_list_bay/engineer
	name = "Engineer"
	engineering = 3
	chemistry = 1
	crafting = 3
	science = 1

/datum/skill_list_bay/engineer/voidtech
	name = "Void Technician"
	unarmed = 1
	melee = 2

/datum/skill_list_bay/engineer/ce
	name = "Chief Engineer"
	unarmed = 2
	engineering = 4
	crafting = 4
	science = 2

/datum/skill_list_bay/cargo
	name = "Cargo Technician"
	engineering = 2
	chemistry = 1
	crafting = 2
	science = 1

/datum/skill_list_bay/cargo/miner
	name = "Shaft Miner"
	unarmed = 1
	melee = 2

/datum/skill_list_bay/cargo/qm
	name = "Quartermaster"
	unarmed = 2
	engineering = 3
	chemistry = 2
	science = 2

/datum/skill_list_bay/medical
	name = "Medical"
	engineering = 1 // Sometimes they have to build consoles and stuff.
	chemistry = 2 // This allows them to use chemical machines with no delay.
	medical = 1
	surgery = 1
	science = 1

/datum/skill_list_bay/medical/psych
	name = "Psychologist"
	chemistry = 0
	surgery = 0 // You aren't a licensed specialist, y'know?
	science = 0

/datum/skill_list_bay/medical/chem
	name = "Chemist"
	chemistry = 3

/datum/skill_list_bay/medical/viro
	name = "Virologist"
	chemistry = 4 // Can use Pandemic machine with no delay.
	science = 2 // Smart boi.

/datum/skill_list_bay/medical/para
	name = "Paramedic"
	medical = 3
	surgery = 2
	crafting = 1

/datum/skill_list_bay/medical/prof
	name = "Medical Professional"
	medical = 3
	surgery = 3
	crafting = 1

/datum/skill_list_bay/medical/cmo
	name = "Chief Medical Officer"
	unarmed = 1
	medical = 4
	surgery = 4
	crafting = 2
	science = 2

/datum/skill_list_bay/science
	name = "Scientist"
	engineering = 3
	medical = 1
	crafting = 2
	science = 2

/datum/skill_list_bay/science/robo
	name = "Roboticist"
	surgery = 3
	crafting = 3

/datum/skill_list_bay/science/rd
	name = "Research Director"
	unarmed = 2
	engineering = 4
	chemistry = 2
	medical = 2
	surgery = 3
	crafting = 4
	science = 4

/datum/skill_list_bay/culinary
	name = "Cooking"
	chemistry = 2
	culinary = 2

/datum/skill_list_bay/culinary/cook
	name = "Cooking Professional"
	unarmed = 2
	melee = 1
	crafting = 1
	culinary = 4

/datum/skill_list_bay/security
	name = "Security"
	unarmed = 2
	melee = 2
	engineering = 1
	chemistry = 1
	crafting = 1

/datum/skill_list_bay/security/warden
	name = "Warden"
	engineering = 2
	chemistry = 2
	crafting = 2

/datum/skill_list_bay/security/hos
	name = "Head of Security"
	unarmed = 3
	melee = 3
	engineering = 3
	chemistry = 3
	crafting = 2
	science = 1

/datum/skill_list_bay/command
	name = "Head of Personnel"
	unarmed = 1
	melee = 1
	engineering = 1
	medical = 1
	surgery = 1
	chemistry = 1
	crafting = 1
	culinary = 1
	science = 1

/datum/skill_list_bay/command/captain
	name = "Captain"
	unarmed = 2
	melee = 2
	engineering = 2
	medical = 2
	surgery = 2
	chemistry = 2
	crafting = 2
	culinary = 2
	science = 2

// CentCom
/datum/skill_list_bay/centcom
	name = "CentCom Official"
	unarmed = 2
	melee = 2
	engineering = 2
	medical = 2
	crafting = 1
	science = 1

/datum/skill_list_bay/centcom/security
	name = "CentCom Officer"
	unarmed = 4
	melee = 4

/datum/skill_list_bay/centcom/security/commander
	name = "CentCom Commander"
	engineering = 4
	medical = 4
	surgery = 4
	crafting = 2
	science = 2

/datum/skill_list_bay/centcom/engineer
	name = "CentCom Engineer"
	engineering = 5
	crafting = 3
	science = 2

/datum/skill_list_bay/centcom/medical
	name = "CentCom Medic"
	chemistry = 5
	medical = 5
	surgery = 5
	science = 3

/datum/skill_list_bay/centcom/commando
	name = "Death Commando"
	unarmed = 6
	melee = 6
	engineering = 6
	chemistry = 6
	medical = 6
	surgery = 6
	crafting = 4
	science = 4

/* ANTAGONISTS */
// Syndicate
/datum/skill_list_bay/syndi
	name = "Syndicate Operative"
	unarmed = 3
	melee = 3
	engineering = 3
	chemistry = 2
	surgery = 2
	crafting = 2
	science = 2

/datum/skill_list_bay/syndi/engineer
	name = "Syndicate Engineer"
	engineering = 5
	crafting = 3

/datum/skill_list_bay/syndi/medic
	name = "Syndicate Medic"
	chemistry = 4
	medical = 4
	surgery = 5
	science = 3

/datum/skill_list_bay/syndi/master
	name = "Syndicate Master"
	unarmed = 4
	melee = 4
	engineering = 4
	chemistry = 3
	medical = 3
	surgery = 3

// Abductors
/datum/skill_list_bay/abductor
	name = "Abductor"
	engineering = 4
	chemistry = 5
	medical = 5
	surgery = 5
	crafting = 3
	science = 5

/datum/skill_list_bay/abductor/agent
	name = "Abductor Agent"
	unarmed = 3
	melee = 3
	chemistry = 2
	medical = 3
	surgery = 2
	science = 2

/datum/skill_list_bay/abductor/solo
	name = "Solo Abductor Agent"
	unarmed = 3
	melee = 3

/* Ghost Roles */
// Ashwalkers
/datum/skill_list_bay/ashwalker
	name = "Ashwalker"
	unarmed = 1
	melee = 2
	engineering = 1
	surgery = 1
	crafting = 2

// Podpeople
/datum/skill_list_bay/culinary/pod
	name = "Podperson"
	engineering = 2

// Golems
/datum/skill_list_bay/golem
	name = "Golem"
	melee = 1
	engineering = 2
	chemistry = 2
	crafting = 1
	science = 1

/datum/skill_list_bay/golem/free
	name = "Free Golem"
	surgery = 2
	culinary = 2
	crafting = 2
	science = 2

// Tech Cult
/datum/skill_list_bay/techcultist
	name = "Tech Cultist"
	melee = 1
	engineering = 3
	chemistry = 3
	medical = 3
	surgery = 3
	crafting = 2
	science = 3

/datum/skill_list_bay/techcultist/leader
	name = "Tech Cult Leader"
	unarmed = 1
	melee = 2
	engineering = 4
	medical = 4
	surgery = 4
	crafting = 3
	science = 4

/* Admemery */
// Everything at 10
/datum/skill_list_bay/admin
	name = "Admin"
	unarmed = 10
	melee = 10
	engineering = 10
	chemistry = 10
	medical = 10
	surgery = 10
	crafting = 10
	culinary = 10
	science = 10

/* Procs */
// An additional value to existing do_after variables.
// PLEASE, DO NOT SET DIFFICULTY BELOW 6 ANYWHERE OR YOU WILL DIE!!!!
/proc/SKILL_CHECK_VALUE(mob/living/user, type="engineering", difficulty=6)
	if(!user.mind)
		return 1 // AI monkey trying to do stuff, I guess.
	if(issilicon(user))
		return 1.4 // Cyborgs are superior in everything! Sort of.
	var/ret_value = (1 + (user.mind.bay_skills.getRating(type) / difficulty))
	if(ishuman(user))
		return ret_value

	return 1 // NONHUMAN ALERT!!!!!!

// Get rating for mob, regardless of mind.
/proc/get_skill_rating(mob/living/user, type="engineering")
	if(!user.mind)
		return 0
	if(issilicon(user))
		return 4 // Cyborgs, amirite?
	var/ret_value = user.mind.bay_skills.getRating(type)
	if(ishuman(user))
		return ret_value

	return 0 // How.
