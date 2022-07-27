#define STYLE_STANDARD 1
#define STYLE_BLUESPACE 2
#define STYLE_CENTCOM 3
#define STYLE_SYNDICATE 4
#define STYLE_BLUE 5
#define STYLE_CULT 6
#define STYLE_MISSILE 7
#define STYLE_RED_MISSILE 8
#define STYLE_BOX 9
#define STYLE_HONK 10
#define STYLE_FRUIT 11
#define STYLE_INVISIBLE 12
#define STYLE_GONDOLA 13
#define STYLE_SEETHROUGH 14

#define POD_SHAPE 1
#define POD_BASE 2
#define POD_DOOR 3
#define POD_DECAL 4
#define POD_GLOW 5
#define POD_RUBBLE_TYPE 6
#define POD_NAME 7
#define POD_DESC 8

#define RUBBLE_NONE 1
#define RUBBLE_NORMAL 2
#define RUBBLE_WIDE 3
#define RUBBLE_THIN 4

#define POD_SHAPE_NORML 1
#define POD_SHAPE_OTHER 2

#define POD_TRANSIT "1"
#define POD_FALLING "2"
#define POD_OPENING "3"
#define POD_LEAVING "4"

#define SUPPLYPOD_X_OFFSET -16

/// The baseline unit for cargo crates. Adjusting this will change the cost of all in-game shuttles, crate export values, bounty rewards, and all supply pack import values, as they use this as their unit of measurement.
#define CARGO_CRATE_VALUE 200

GLOBAL_LIST_EMPTY(supplypod_loading_bays)

GLOBAL_LIST_INIT(podstyles, list(\
	list(POD_SHAPE_NORML, "pod",         TRUE, "default",		"yellow",   RUBBLE_NORMAL,	"supply pod", 						    "An N-Corporation supply drop pod."),\
	list(POD_SHAPE_NORML, "advpod",      TRUE, "bluespace",	"blue",     RUBBLE_NORMAL,	"advanced supply pod" , 			    "An N-Corporation supply pod. Teleports back to District Fourteen after delivery."),\
	list(POD_SHAPE_NORML, "advpod",      TRUE, "centcom",		"blue",     RUBBLE_NORMAL,	"\improper wings of the world supply pod", 		"An N-Corporation supply pod, this one has been marked with The Head's designations. Teleports back to District Fourteen after delivery."),\
	list(POD_SHAPE_NORML, "darkpod",     TRUE, "syndicate",	"red",      RUBBLE_NORMAL,	"blood-red supply pod", 				"An intimidating supply pod, covered in the blood-red markings of a criminal syndicate. It's probably best to stand back from this."),\
	list(POD_SHAPE_NORML, "darkpod",     TRUE, "deathsquad",	"blue",     RUBBLE_NORMAL,	"\improper office drop pod", 	    "An N-Corporation drop pod. This one has been etched with the markings of District Fourteen's most trusted fixer office."),\
	list(POD_SHAPE_NORML, "pod",         TRUE, "cultist",		"red",      RUBBLE_NORMAL,	"bloody supply pod", 				    "An N-Corporation supply pod covered in scratch-marks, blood, and strange runes."),\
	list(POD_SHAPE_OTHER, "missile",     FALSE, FALSE,			FALSE,   RUBBLE_THIN,	    "cruise missile", 						"A big ass missile that didn't seem to fully detonate. It was likely launched from some ancient missile silo deep in the ruins. There appears to be an auxiliary payload hatch on the side, though manually opening it is likely impossible."),\
	list(POD_SHAPE_OTHER, "smissile",    FALSE, FALSE,	        FALSE,   RUBBLE_THIN,	    "\improper syndicate cruise missile", 	"A big ass, blood-red missile that didn't seem to fully detonate. It was likely launched from some ancient missile silo deep in the ruins. There appears to be an auxiliary payload hatch on the side, though manually opening it is likely impossible."),\
	list(POD_SHAPE_OTHER, "box",         TRUE, FALSE,            FALSE,   RUBBLE_WIDE,  	"\improper lost N-Corporation supply crate", 		"An incredibly sturdy supply crate, designed to withstand orbital re-entry. Has 'N-Corporation - Beyond the City' engraved on the side."),\
	list(POD_SHAPE_NORML, "clownpod",    TRUE, "clown",		"green",    RUBBLE_NORMAL,	"\improper carnival pod", 				    "A brightly-colored supply pod. It likely originated from some abnormal carnival with access to advanced technology."),\
	list(POD_SHAPE_OTHER, "orange",      TRUE, FALSE,			FALSE,   RUBBLE_NONE,	    "\improper evil fruit", 					"An abnormal fruit with severe anger issues, this should worry you."),\
	list(POD_SHAPE_OTHER, FALSE,         FALSE,    FALSE,            FALSE,   RUBBLE_NONE,	    "\improper stealth pod", 	"A supply pod that, under normal circumstances, is completely invisible to conventional methods of detection. How are you even seeing this?"),\
	list(POD_SHAPE_OTHER, "gondola",     FALSE, FALSE,			FALSE,   RUBBLE_NONE,	    "mystery abnormal", 							    "An abnormal yet peaceful creature, it appears to be here with a package for you."),\
	list(POD_SHAPE_OTHER, FALSE,         FALSE,    FALSE,            FALSE,   RUBBLE_NONE,	        FALSE,      FALSE,      "rl_click", "give_po")\
))
