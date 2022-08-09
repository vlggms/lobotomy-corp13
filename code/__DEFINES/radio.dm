// Radios use a large variety of predefined frequencies.

//say based modes like binary are in living/say.dm

#define RADIO_CHANNEL_COMMON "Common"
#define RADIO_KEY_COMMON ";"

#define RADIO_CHANNEL_CONTROL "Control"
#define RADIO_KEY_CONTROL "r"
#define RADIO_TOKEN_CONTROL ":r"

#define RADIO_CHANNEL_INFORMATION "Information"
#define RADIO_KEY_INFORMATION "i"
#define RADIO_TOKEN_INFORMATION ":i"

#define RADIO_CHANNEL_SAFETY "Safety"
#define RADIO_KEY_SAFETY "f"
#define RADIO_TOKEN_SAFETY ":f"

#define RADIO_CHANNEL_TRAINING "Training"
#define RADIO_KEY_TRAINING "t"
#define RADIO_TOKEN_TRAINING ":t"

#define RADIO_CHANNEL_COMMAND "Command"
#define RADIO_KEY_COMMAND "c"
#define RADIO_TOKEN_COMMAND ":c"

#define RADIO_CHANNEL_WELFARE "Welfare"
#define RADIO_KEY_WELFARE "w"
#define RADIO_TOKEN_WELFARE ":w"

#define RADIO_CHANNEL_DISCIPLINE "Discipline"
#define RADIO_KEY_DISCIPLINE "s"
#define RADIO_TOKEN_DISCIPLINE ":s"

#define RADIO_CHANNEL_ARCHITECTURE "Architecture"
#define RADIO_KEY_ARCHITECTURE "a"
#define RADIO_TOKEN_ARCHITECTURE ":a"

#define RADIO_CHANNEL_HEAD "Head"
#define RADIO_KEY_HEAD "z"
#define RADIO_TOKEN_HEAD ":z"

#define RADIO_CHANNEL_AI_PRIVATE "AI Private"
#define RADIO_KEY_AI_PRIVATE "o"
#define RADIO_TOKEN_AI_PRIVATE ":o"


#define RADIO_CHANNEL_SYNDICATE "Syndicate"
#define RADIO_KEY_SYNDICATE "e"
#define RADIO_TOKEN_SYNDICATE ":e"

#define RADIO_CHANNEL_CENTCOM "CentCom"
#define RADIO_KEY_CENTCOM "y"
#define RADIO_TOKEN_CENTCOM ":y"

#define RADIO_CHANNEL_CTF_RED "Red Team"
#define RADIO_CHANNEL_CTF_BLUE "Blue Team"


#define MIN_FREE_FREQ 1201 // -------------------------------------------------
// Frequencies are always odd numbers and range from 1201 to 1599.

#define FREQ_SYNDICATE 1213  // Nuke op comms frequency, dark brown
#define FREQ_CTF_RED 1215  // CTF red team comms frequency, red
#define FREQ_CTF_BLUE 1217  // CTF blue team comms frequency, blue
#define FREQ_CENTCOM 1337  // CentCom comms frequency, gray
#define FREQ_HEAD 1339  // Head comms frequency, dark blue
#define FREQ_CONTROL 1347  // Control comms frequency, light brown
#define FREQ_INFORMATION 1349  // Information comms frequency, plum
#define FREQ_SAFETY 1351  // Safety comms frequency, green
#define FREQ_TRAINING 1353  // Training comms frequency, orange
#define FREQ_COMMAND 1355  // Command comms frequency, gold
#define FREQ_WELFARE 1357  // Welfare comms frequency, soft blue
#define FREQ_DISCIPLINE 1359  // Discipline comms frequency, red
#define FREQ_ARCHITECTURE 1365  // Architecture comms frequency, light grey

#define FREQ_HOLOGRID_SOLUTION 1433
#define FREQ_STATUS_DISPLAYS 1435
#define FREQ_ATMOS_ALARMS 1437  // air alarms <-> alert computers
#define FREQ_ATMOS_CONTROL 1439  // air alarms <-> vents and scrubbers

#define MIN_FREQ 1441 // ------------------------------------------------------
// Only the 1441 to 1489 range is freely available for general conversation.
// This represents 1/8th of the available spectrum.

#define FREQ_ATMOS_STORAGE 1441
#define FREQ_NAV_BEACON 1445
#define FREQ_AI_PRIVATE 1447  // AI private comms frequency, magenta
#define FREQ_PRESSURE_PLATE 1447
#define FREQ_AIRLOCK_CONTROL 1449
#define FREQ_ELECTROPACK 1449
#define FREQ_MAGNETS 1449
#define FREQ_LOCATOR_IMPLANT 1451
#define FREQ_SIGNALER 1457  // the default for new signalers
#define FREQ_COMMON 1459  // Common comms frequency, dark green

#define MAX_FREQ 1489 // ------------------------------------------------------

#define MAX_FREE_FREQ 1599 // -------------------------------------------------

// Transmission types.
#define TRANSMISSION_WIRE 0  // some sort of wired connection, not used
#define TRANSMISSION_RADIO 1  // electromagnetic radiation (default)
#define TRANSMISSION_SUBSPACE 2  // subspace transmission (headsets only)
#define TRANSMISSION_SUPERSPACE 3  // reaches independent (CentCom) radios only

// Filter types, used as an optimization to avoid unnecessary proc calls.
#define RADIO_TO_AIRALARM "to_airalarm"
#define RADIO_FROM_AIRALARM "from_airalarm"
#define RADIO_SIGNALER "signaler"
#define RADIO_ATMOSIA "atmosia"
#define RADIO_AIRLOCK "airlock"
#define RADIO_MAGNETS "magnets"

#define DEFAULT_SIGNALER_CODE 30

//Requests Console
#define REQ_NO_NEW_MESSAGE 				0
#define REQ_NORMAL_MESSAGE_PRIORITY 	1
#define REQ_HIGH_MESSAGE_PRIORITY 		2
#define REQ_EXTREME_MESSAGE_PRIORITY 	3

#define REQ_DEP_TYPE_ASSISTANCE 	(1<<0)
#define REQ_DEP_TYPE_SUPPLIES 		(1<<1)
#define REQ_DEP_TYPE_INFORMATION 	(1<<2)
