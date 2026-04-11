// Useful defines for handling the functionality of areas

// Area's mob_list indexes, for ease of navigating them on iterations.
// IMPORTANT: The lists are created dynamically (as they are needed), mobs should NOT have two indexes on them, they are mutually exclusive between one another. (Please do not make your mob appear multiple times in the mob_list of the area.)
#define FROZEN_INDEX				(1 << 0) // Any mob whose index includes this one is either: Dead or in the midst of Deletion
#define MOB_LIVING_INDEX			(1 << 1)
#define MOB_SIMPLEANIMAL_INDEX		(1 << 2)
#define MOB_HOSTILE_INDEX			(1 << 3)
#define MOB_ABNO_PASSIVE_INDEX      (1 << 4)
#define MOB_ABNORMALITY_INDEX		(1 << 5)
#define MOB_CARBON_INDEX			(1 << 6)
#define MOB_HUMAN_INDEX				(1 << 7)
