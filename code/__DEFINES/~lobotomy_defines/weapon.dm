// Knockback defines
#define KNOCKBACK_LIGHT (1<<0)
#define KNOCKBACK_MEDIUM (1<<1)
#define KNOCKBACK_HEAVY (1<<2)

/// Charge defines
// Should be set on charge abilities that trigger when a weapon is attacking
#define ABILITY_ON_ATTACK (1<<0)
	// Should be set on charge abilities that trigger on special ATTACK circumstances, it disables ChargeAttack() as a proc
	#define ABILITY_UNIQUE (1<<1)
// Should be set on charge abilities that trigger when using the weapon itself
#define ABILITY_ON_ACTIVATION (1<<2)
