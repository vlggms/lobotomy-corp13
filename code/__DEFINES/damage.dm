// Ahead are a bunch of bitflags that can be sent in the "flags" argument for deal_damage() to customize the behaviour of damage.
/// Set this bitflag to prevent deal_damage from calling PreDamageReaction.
#define DAMAGE_FORCED (1 << 0)
/// Set this bitflag to make the source of the damage untrackable (thus, mobs do not aggro onto the target from it, and PostDamageReaction will not have a source when it runs)
#define DAMAGE_UNTRACKABLE (1 << 1)
/// Set this bitflag to prevent damage from being spread across the body. Irrelevant for anything but carbons.
#define DAMAGE_NO_SPREAD (1 << 2)
/// Set this bitflag to allow WHITE/BLACK damage to resane.
#define DAMAGE_WHITE_HEALABLE (1 << 3)
/// Set this bitflag to ignore the armour check and godmode (yes, for some reason you can ignore godmode. do not blame this on me)
#define DAMAGE_PIERCING (1 << 4)

/*
These flags are for the "attack_type" argument in deal_damage, so you can discern and act upon the difference between damage incoming from a melee hit or from a bullet and so on.
You can TECHNICALLY have "hybrid" damages by setting multiple of them. It makes sense, for example, for Blue Shepherd's autoattack to be exclusively ATTACK_TYPE_MELEE, but his spinning slash to
be both ATTACK_TYPE_MELEE and ATTACK_TYPE_SPECIAL.
*/
/// Set this bitflag to mark the attack as melee (EGO melee weapons, fisticuffs, an abnormality's basic attack...)
#define ATTACK_TYPE_MELEE (1 << 0)
/// Set this bitflag to mark the attack as ranged (firearms, bows, etc...)
#define ATTACK_TYPE_RANGED (1 << 1)
/// Set this bitflag to mark the attack as a thrown attack (javelins, boomerangs, something flung by Sirocco...)
#define ATTACK_TYPE_THROWING (1 << 2)
/// Set this bitflag to mark the attack as a special attack (Fragment of the Universe's song, Temperance Insanity pulse damage, EGO special abilities, most Abnormality unique attacks... Very broad definition)
#define ATTACK_TYPE_SPECIAL (1 << 3)
/// Set this bitflag to mark the attack as a status effect (Melting Love's DoT, damage from burning, etc...)
#define ATTACK_TYPE_STATUS (1 << 4)
/// Set this bitflag to mark the attack as coming from the environment (stepping on a fire turf, stepping on a Hypocrisy trap, drowning in the Great Lakes, etc...)
#define ATTACK_TYPE_ENVIRONMENT (1 << 5)
/// Set this bitflag when the attack is a "counter" or "riposte". (White Fixer's damage reflection, Sanguine Flame's deflect...)
#define ATTACK_TYPE_COUNTER (1 << 6)
/// This is for when the damage is coming from somewhere that doesn't easily fit one of the other categories, but you'd still like to mark its type...
#define ATTACK_TYPE_OTHER (1 << 7)
