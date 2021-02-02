// TRAITS
#define TRAIT_COLDBLOODED		"coldblooded"	// Your body is literal room temperature. Does not make you immune to the temp.
#define TRAIT_NOMARROW			"nomarrow"		// You don't make blood.

// RECIPES
#define CAT_STRUCTURE	"Structures"

// MARTIAL ARTS
#define MARTIALART_HUNTER "hunter-fu"

// KEYBINDS
#define COMSIG_KB_ADMIN_MSAY_DOWN "keybinding_mentor_msay_down"

// RADIO CHANNELS
#define RADIO_CHANNEL_TERRAGOV "TerraGov"
#define RADIO_KEY_TERRAGOV "z"
#define RADIO_TOKEN_TERRAGOV ":z"
#define FREQ_TERRAGOV 1345

// MISSING REF
/obj/item/circuitboard/machine/vr_sleeper
	var/whydoesthisexist = "because somebody fucked up putting this on TG, and vr_sleeper.dm is pointing to an object that was never defined. Here it is as a temp ref, so we can compile."


// Names
GLOBAL_LIST_INIT(russian_names, world.file2list("strings/names/tegu_russian.txt")) // Backtracked from names.dm
GLOBAL_LIST_INIT(experiment_names, world.file2list("strings/names/tegu_experiment.txt")) // Backtracked from names.dm

// Taken from flavor_misc.dm, as used by ethereals  (color_list_ethereal)
GLOBAL_LIST_INIT(color_list_beefman, list("Very Rare" = "d93356", "Rare" = "da2e4a", "Medium Rare" = "e73f4e", "Medium" = "f05b68", "Medium Well" = "e76b76", "Well Done" = "d36b75" ))

// Taken from _HELPERS/mobs.dm, and assigned in global_lists.dm! (This is where we assign sprite_accessories(.dm) to the list, by name)
GLOBAL_LIST_EMPTY(eyes_beefman)//, list( "Peppercorns", "Capers", "Olives" ))
GLOBAL_LIST_EMPTY(mouths_beefman)//, list( "Smile1", "Smile2", "Frown1", "Frown2", "Grit1", "Grit2" ))


//sec stuff for surreal
#define SEC_RECORD_BAD_CLEARANCE "ACCESS DENIED: User ID has inadequate clearance."

#define SEC_RECORD_BOT_COOLDOWN 60 SECONDS

//Chaplain Starter Sith Traitor Item

#define FORCETRAINING_BLOCKCHANCE	30

#define MARTIALART_STARTERSITH "starter sith"

//MEDBORG UPDATE -Surrealistik Feb 2020

#define SYNTHFLESH_HUSKFIX_THRESHOLD 40 //For instabitaluri/synthflesh; allows maxed patches to heal burn husking.
