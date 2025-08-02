# Villains of the Night - Code Reference Guide

This guide provides a quick reference to the Villains gamemode codebase, explaining what each file contains and providing examples.

## Core Files Overview

### `/code/modules/villains/_defines.dm`
**Purpose:** Contains all constants and defines used throughout the gamemode.

**Key Defines:**
```dm
// Character IDs
#define VILLAIN_CHAR_QUEENOFHATRED "queen_of_hatred"
#define VILLAIN_CHAR_DERFREISCHUTZ "der_freischutz"

// Game phases
#define VILLAIN_PHASE_SETUP 0
#define VILLAIN_PHASE_MORNING 1
#define VILLAIN_PHASE_EVENING 2

// Action types
#define VILLAIN_ACTION_TYPELESS 1
#define VILLAIN_ACTION_PROTECTIVE 2
#define VILLAIN_ACTION_ELIMINATION 5

// Item rarities
#define VILLAIN_ITEM_COMMON 1
#define VILLAIN_ITEM_UNCOMMON 2
#define VILLAIN_ITEM_RARE 3
```

### `/code/modules/villains/controller.dm`
**Purpose:** Main game controller that manages phases, players, and game flow.

**Key Components:**
- `datum/villains_controller` - Main controller
- Phase management (`change_phase()`)
- Player tracking (living/dead/spectators)
- Victory conditions
- Action queue processing

**Example Usage:**
```dm
GLOB.villains_game = new /datum/villains_controller()
GLOB.villains_game.add_player(player)
GLOB.villains_game.change_phase(VILLAIN_PHASE_MORNING)
```

### `/code/modules/villains/characters.dm`
**Purpose:** Defines all 17 playable characters with their abilities.

**Structure:**
```dm
/datum/villains_character/[character_name]
    name = "Display Name"
    character_id = VILLAIN_CHAR_ID
    desc = "Character description"
    active_ability_name = "Ability Name"
    active_ability_type = VILLAIN_ACTION_TYPE
    passive_ability_desc = "Passive description"
```

**Characters Include:**
- Queen of Hatred - Tests actions and gains info
- Der Freischütz - Contract-based elimination
- Rudolta - Silent observer
- Puss in Boots - Blessing protector
- And 13 more...

### `/code/modules/villains/actions.dm`
**Purpose:** Action system implementation and trading/contract UI.

**Key Classes:**
- `datum/villains_action` - Base action class
- `datum/villains_action/talk_trade` - Trading sessions
- `datum/villains_action/eliminate` - Villain elimination
- `datum/villains_action/character_ability` - Character abilities
- `datum/villains_trade_session` - Trading UI backend
- `datum/villains_contract_ui` - Contract management

**Example Action:**
```dm
var/datum/villains_action/eliminate/E = new(performer, target, game)
game.action_queue.add_action(E)
```

### `/code/modules/villains/items.dm`
**Purpose:** All game items with various effects.

**Base Structure:**
```dm
/obj/item/villains/[item_name]
    name = "Item Name"
    desc = "Description"
    action_type = VILLAIN_ACTION_TYPE
    rarity = VILLAIN_ITEM_RARITY
    freshness = VILLAIN_ITEM_FRESH // if fresh spawn
```

**Item Categories:**
- **Protective:** Forcefield Projector, Guardian Drone, Smoke Bomb
- **Investigative:** DEEPSCAN Kit, Binoculars, Audio Recorder
- **Suppressive:** Handheld Taser, EMP Device, Throwing Bola
- **Special:** Fairy Wine, Lucky Coin

### `/code/modules/villains/mob.dm`
**Purpose:** The villains character mob that players control.

**Key Features:**
```dm
/mob/living/simple_animal/hostile/villains_character
    var/datum/villains_character/character_data
    var/is_villain = FALSE
    var/list/fresh_items = list()
    var/mob/trading_with = null
    var/contract_target = null // Der Freischütz target
```

**Important Procs:**
- `setup_character()` - Initializes character
- `pickup_item()` - Handles item collection
- `start_observing()` - Rudolta's ability
- `apply_protection()` - Protection mechanics

### `/code/modules/villains/rooms.dm`
**Purpose:** Room management and assignment system.

**Structure:**
```dm
/datum/villains_room
    var/room_id
    var/obj/effect/landmark/villains_room_spawn/spawn_landmark
    var/mob/living/simple_animal/hostile/villains_character/owner
```

## UI Files

### `/tgui/packages/tgui/interfaces/VillainsPanel.js`
**Purpose:** Main game panel showing phase, players, and admin controls.

**Key Features:**
- Phase display and timer
- Player list with status
- Character selection
- Admin phase controls

### `/tgui/packages/tgui/interfaces/VillainsCharacterSheet.js`
**Purpose:** Individual character information display.

**Shows:**
- Character portrait and description
- Active/passive abilities
- Inventory items
- Win condition

### `/tgui/packages/tgui/interfaces/VillainsTradeUI.js`
**Purpose:** Trading interface between players.

**Features:**
- Side-by-side inventories
- Item rarity display
- Offer/accept system
- 2-minute timer

### `/tgui/packages/tgui/interfaces/VillainsContractUI.js`
**Purpose:** Contract management for Der Freischütz.

**Tabs:**
- Pending - Contracts awaiting response
- Active - Current contracts
- Offer - Create new contracts (Der Freischütz only)

### `/tgui/packages/tgui/interfaces/VillainsSimpleActionSelection.js`
**Purpose:** Evening phase action selection.

**Shows:**
- Available actions (main/secondary)
- Target selection
- Action confirmation

## Common Code Patterns

### Adding a New Character
1. Add character ID to `_defines.dm`
2. Create character datum in `characters.dm`
3. Add to `setup_characters()` in `controller.dm`

### Adding a New Item
1. Create item class in `items.dm`
2. Add to spawn tables in `controller.dm`
3. Implement `use_item()` proc

### Creating a New Action
1. Extend `/datum/villains_action` in `actions.dm`
2. Set action_type and priority
3. Override `perform()` proc

### Phase Transitions
```dm
// In controller.dm
proc/change_phase(new_phase)
    current_phase = new_phase
    switch(new_phase)
        if(VILLAIN_PHASE_MORNING)
            spawn_items()
            unlock_all_rooms()
        if(VILLAIN_PHASE_EVENING)
            lock_all_rooms()
```

## Key Global Variables
- `GLOB.villains_game` - Current game controller
- `GLOB.villains_signup` - Players signed up
- `GLOB.villains_bad_signup` - Villain signups

## Signal System
```dm
// Protection signal
SEND_SIGNAL(target, COMSIG_VILLAIN_ELIMINATION) & VILLAIN_PREVENT_ELIMINATION

// Action prevention
SEND_SIGNAL(performer, COMSIG_VILLAIN_ACTION_PERFORMED, src) & VILLAIN_PREVENT_ACTION
```

## Testing Commands
In `controller.dm`:
- `debug_spawn_items()` - Force item spawns
- `debug_give_item()` - Give specific item
- `force_phase_change()` - Skip to phase
- `debug_make_villain()` - Set villain

## Common Issues & Solutions

### Trade Session Not Opening
Check if `active_trade_session` is set on both mobs and UI objects are properly created.

### Action Not Executing
Verify:
1. Action priority is correct
2. `can_perform()` returns TRUE
3. No blocking signals
4. Action added to queue

### Character Ability Not Working
Check:
1. Character data properly set
2. `perform_active_ability()` implemented
3. Correct action type/cost