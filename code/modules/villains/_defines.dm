// Villains of the Night gamemode defines

// Player limits
#define VILLAINS_MIN_PLAYERS 6
#define VILLAINS_MAX_PLAYERS 12

// Game phases
#define VILLAIN_PHASE_SETUP 1
#define VILLAIN_PHASE_MORNING 2
#define VILLAIN_PHASE_EVENING 3
#define VILLAIN_PHASE_NIGHTTIME 4
#define VILLAIN_PHASE_INVESTIGATION 5
#define VILLAIN_PHASE_ALIBI 6
#define VILLAIN_PHASE_DISCUSSION 7
#define VILLAIN_PHASE_VOTING 8
#define VILLAIN_PHASE_RESULTS 9
#define VILLAIN_PHASE_VICTORY_LAP 10

// Player states
#define VILLAIN_ALIVE 1
#define VILLAIN_DEAD 2
#define VILLAIN_SPECTATOR 3

// Action types (priority order)
#define VILLAIN_ACTION_SUPPRESSIVE 1
#define VILLAIN_ACTION_PROTECTIVE 2
#define VILLAIN_ACTION_INVESTIGATIVE 3
#define VILLAIN_ACTION_TYPELESS 4
#define VILLAIN_ACTION_ELIMINATION 5

// Action costs
#define VILLAIN_ACTION_MAIN "Main Action"
#define VILLAIN_ACTION_SECONDARY "Secondary Action"
#define VILLAIN_ACTION_FREE "Free Action"

// Action types for submission
#define VILLAIN_ACTION_TALK_TRADE "talk_trade"
#define VILLAIN_ACTION_CHARACTER_ABILITY "character_ability"
#define VILLAIN_ACTION_USE_ITEM "use_item"
#define VILLAIN_ACTION_ELIMINATE "eliminate"

// Teams
#define VILLAIN_TEAM_INNOCENT "innocent"
#define VILLAIN_TEAM_VILLAIN "villain"

// Item freshness
#define VILLAIN_ITEM_FRESH "fresh"
#define VILLAIN_ITEM_USED "used"

// Signals
#define COMSIG_VILLAIN_PHASE_CHANGE "dangan_phase_change"
#define COMSIG_VILLAIN_ACTION_PERFORMED "dangan_action_performed"
#define COMSIG_VILLAIN_ELIMINATION "dangan_elimination"
#define COMSIG_VILLAIN_GAME_END "dangan_game_end"

// Action prevention returns
#define VILLAIN_PREVENT_ACTION 1
#define VILLAIN_PREVENT_ELIMINATION 1

// Phase timers (in seconds)
#define VILLAIN_TIMER_MORNING_MIN 30 // 5 minutes
#define VILLAIN_TIMER_MORNING_MAX 600 // 10 minutes
#define VILLAIN_TIMER_EVENING 60 // 1 minute
#define VILLAIN_TIMER_NIGHTTIME 480 // 8 minutes
#define VILLAIN_TIMER_INVESTIGATION 300 // 5 minutes
#define VILLAIN_TIMER_ALIBI_PER_PLAYER 30 // 30 seconds per player
#define VILLAIN_TIMER_DISCUSSION_MIN 480 // 8 minutes
#define VILLAIN_TIMER_DISCUSSION_MAX 840 // 14 minutes
#define VILLAIN_TIMER_VOTING 60 // 1 minute
#define VILLAIN_TIMER_RESULTS 60 // 1 minute

// Victory points
#define VILLAIN_VICTORY_CORRECT_VOTE 1
#define VILLAIN_VICTORY_INCORRECT_VOTE -1
#define VILLAIN_VICTORY_MINIMUM 0

// Item limits
#define VILLAIN_MAX_FRESH_ITEMS 2

// Character IDs
#define VILLAIN_CHAR_QUEENOFHATRED "queen_of_hatred"
#define VILLAIN_CHAR_FORSAKENMURDER "forsaken_murder"
#define VILLAIN_CHAR_ALLROUNDCLEANER "all_round_cleaner"
#define VILLAIN_CHAR_FUNERALBUTTERFLIES "funeral_butterflies"
#define VILLAIN_CHAR_FAIRYGENTLEMAN "fairy_gentleman"
#define VILLAIN_CHAR_PUSSINBOOTS "puss_in_boots"
#define VILLAIN_CHAR_DERFREISCHUTZ "der_freischutz"
#define VILLAIN_CHAR_RUDOLTA "rudolta"
#define VILLAIN_CHAR_JUDGEMENTBIRD "judgement_bird"
#define VILLAIN_CHAR_SHRIMPEXEC "shrimp_executive"
#define VILLAIN_CHAR_SUNSETTRAVELLER "sunset_traveller"
#define VILLAIN_CHAR_FAIRYLONGLEGS "fairy_long_legs"
#define VILLAIN_CHAR_REDBLOODEDAMERICAN "red_blooded_american"
#define VILLAIN_CHAR_KIKIMORA "kikimora"
#define VILLAIN_CHAR_REDHOOD "red_hood"
#define VILLAIN_CHAR_WARDEN "the_warden"
#define VILLAIN_CHAR_BLUESHEPHERD "blue_shepherd"

// Global variables
GLOBAL_LIST_EMPTY(villains_signup)
GLOBAL_LIST_EMPTY(villains_bad_signup)
GLOBAL_DATUM(villains_game, /datum/villains_controller)

// Landmark globals
GLOBAL_LIST_EMPTY(villains_room_spawns)
GLOBAL_LIST_EMPTY(villains_door_spawns)
GLOBAL_VAR_INIT(villains_main_room_spawn, null)
GLOBAL_VAR_INIT(villains_game_area_spawn, null)
