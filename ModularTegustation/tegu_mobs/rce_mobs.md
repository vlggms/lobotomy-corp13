# Resurgence Clan Enemy Mobs

## Demolisher
**Role:** Heavy siege unit specializing in structure destruction  
**Status:** ✅ Implemented (needs balancing)

### Mechanics:
- **Target Priority:** Actively seeks and destroys barricades, turrets, and defensive structures
- **Demolish Protocol:** At max charge, performs 3x3 AoE explosion dealing massive damage to structures
- **Reactive Shield:** Upon taking damage, activates 0.5s invulnerability shield (costs 1 charge per hit blocked)
- **Death Bomb:** Drops timed explosive on death
  - 10-second countdown with audio warnings at 10s, 5s, 3s, 2s, 1s
  - 7x7 AoE explosion with distance-based damage falloff
  - Faction-friendly (doesn't damage other Resurgence Clan units)
  - Bonus damage to dense objects

## Assassin  
**Role:** Stealth ambusher targeting isolated enemies  
**Status:** ✅ Implemented

### Mechanics:
- **Stealth Mode:** Activated at max charge
  - Reduced visibility (alpha 25)
  - 30% movement speed reduction
  - Taking damage causes 3 charge loss + 1.5s stun
- **Backstab:** High-damage sneak attack (150 RED damage, costs 2 charge)
- **Parkour:** Can vault over tables/barricades while stealthed
- **Target Selection:** Prioritizes isolated targets (fewer allies nearby)
- **Behavior:** Retreats when not in stealth, maintains distance
- **Z-Level Hunt Mode:** Optional ability to search entire floor for isolated humans

## Solo Teleporter
**Role:** Hit-and-run skirmisher  
**Status:** 📝 Planned

### Mechanics:
- Low charge gain rate
- Low charge requirement (3-4 max)
- Short-range teleport (2 tiles forward) costs 1-2 charge
- Used for gap-closing or escaping

## Group Teleporter
**Role:** Tactical repositioning specialist  
**Status:** 📝 Planned

### Mechanics:
- Low charge gain rate
- Requires nearby allies (3+ within 2 tiles)
- At max charge, teleports self and allies to target's last known position
- 2-second channel time with visual warning
- All teleported units arrive slightly spread out

## Tinkerer
**Role:** RTS-style commander unit  
**Status:** ✅ Implemented

### Mechanics:
- **Dual Modes:**
  - **Viewing Mode:** Fast movement, semi-invisible (alpha 30), cannot use abilities
  - **Command Mode:** Normal speed, can issue orders
- **Factory System:**
  - Starts with one factory
  - Engineers can build more at resource points
  - Each factory has unit capacity (10 points)
  - Unit costs: Scout (2), Soldier (3), Engineer (4)
  - Factory destruction kills all associated units
- **Unit Control:**
  - Select up to 5 units
  - Selected units have visual indicator
- **Orders:**
  - **Move (2 charge):** Light mode allows target acquisition, Rush mode ignores enemies
  - **Attack (3 charge):** Direct all selected units to attack target
  - **Overclock (5 charge):** Heal + double charge capacity, unit dies after 10s

## Implementation Notes
- All clan units share charge mechanic (varies by unit type)
- Faction: "resurgence_clan", "hostile"
- Icon requirements: 32x48 for most units, 48x48 for Demolisher, 64x64 for factory
- Balance considerations: Charge gain rates, ability costs, cooldowns need testing
