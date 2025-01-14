#define DEPARTMENT_W_CORP (1<<10)
#define DEPARTMENT_R_CORP (1<<11)
#define DEPARTMENT_HANA (1<<12)
#define DEPARTMENT_ASSOCIATION (1<<13)
#define DEPARTMENT_CITY_ANTAGONIST (1<<13)
#define DEPARTMENT_FIXERS (1<<14)

GLOBAL_LIST_INIT(w_corp_positions, list(
	"W-Corp Representative",
	"W-Corp L3 Squad Captain",
	"W-Corp L2 Type A Lieutenant",
	"W-Corp L2 Type B Support Agent",
	"W-Corp L2 Type C Weapon Specialist",
	"W-Corp L2 Type D Spear Agent",
	"W-Corp L1 Cleanup Agent",
))

GLOBAL_LIST_INIT(r_corp_positions, list(
	// 4th Pack Command
	"Ground Commander",
	"Lieutenant Commander",
	"Operations Officer",
	"Rabbit Squad Captain",
	"Reindeer Squad Captain",
	"Rhino Squad Captain",
	"Raven Squad Captain",

	// 5th Pack Command
	"Assault Commander",
	"Base Commander",
	"Support Officer",
	"Rat Squad Leader",
	"Rooster Squad Leader",
	"Raccoon Squad Leader",
	"Roadrunner Squad Leader",

	// 4th Pack troops
	"R-Corp Suppressive Rabbit",
	"R-Corp Assault Rabbit",
	"R-Corp Medical Reindeer",
	"R-Corp Berserker Reindeer",
	"R-Corp Gunner Rhino",
	"R-Corp Hammer Rhino",
	"R-Corp Scout Raven",
	"R-Corp Support Raven",

	// 5th Pack troops
	"R-Corp Rat",
	"R-Corp Rooster",
	"R-Corp Raccoon Spy",
	"R-Corp Raccoon Sniper",
	"R-Corp Roadrunner",
))

GLOBAL_LIST_INIT(hana_positions, list(
	"Hana Administrator",
	"Hana Representative",
	"Hana Intern",
))

GLOBAL_LIST_INIT(fixer_positions, list(
	"East Office Director",
	"East Office Fixer",
	"North Office Director",
	"North Office Fixer",

	"Association Section Director",
	"Association Veteran",
	"Association Fixer",
	"Roaming Association Fixer",

	"Medical Fixer Assistant",
	"Fixer",
	"Rat", // most fitting, somehow
))

GLOBAL_LIST_INIT(association_positions, list(
	"Association Section Director",
	"Association Veteran",
	"Association Fixer",
	"Roaming Association Fixer",
))

GLOBAL_LIST_INIT(city_antagonist_positions, list(
	"Index Messenger",
	"Index Proxy",
	"Index Proselyte",

	"Blade Lineage Cutthroat",
	"Blade Lineage Salsu",
	"Blade Lineage Ronin",
	"Blade Lineage Roaming Salsu",

	"Grand Inquisitor",
	"N Corp Grosshammer",
	"N Corp Mittlehammer",
	"N Corp Kleinhammer",

	"Thumb Sottocapo",
	"Thumb Capo",
	"Thumb Soldato",

	"Kurokumo Kashira",
	"Kurokumo Hosa",
	"Kurokumo Wakashu",
))
