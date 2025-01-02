#define DEPARTMENT_W_CORP (1<<10)
#define DEPARTMENT_R_CORP (1<<11)
#define DEPARTMENT_HANA (1<<12)
#define DEPARTMENT_ASSOCIATION (1<<13)
#define DEPARTMENT_SYNDICATE (1<<13)

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
	"Ground Commander",
	"Lieutenant Commander",
	"Operations Officer",
	"Rabbit Squad Captain",
	"Reindeer Squad Captain",
	"Rhino Squad Captain",
	"Raven Squad Captain",

	// R-Corp Fourth Pack
	"R-Corp Suppressive Rabbit",
	"R-Corp Assault Rabbit",
	"R-Corp Medical Reindeer",
	"R-Corp Berserker Reindeer",
	"R-Corp Gunner Rhino",
	"R-Corp Hammer Rhino",
	"R-Corp Scout Raven",
	"R-Corp Support Raven",

	// Fifth Pack
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

GLOBAL_LIST_INIT(association_positions, list(
	"Association Section Director",
	"Association Veteran",
	"Association Fixer",
	"Roaming Association Fixer",
))

GLOBAL_LIST_INIT(syndicate_positions, list(
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
