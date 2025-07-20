# Mechanical Cassowary - "Strider Sentinel" Design Document

## Overview
A player-controlled corroded human variant created by the Tinkerer, based on the cassowary bird. This creature represents the corruption of protective instincts, turning natural guardian behavior into obsessive, harmful "protection" that isolates and harms those it tries to safeguard.

## Lore & Theme

### The Tinkerer's Vision
The Tinkerer observed the cassowary's fierce protective nature and solitary lifestyle, seeing it as "pure instinct corrupted by humanity's need for connection." In his twisted workshop, he transformed captured humans into mechanical cassowaries - beings forever trapped between the desire to protect and the inability to truly connect.

### Core Concept
- **Natural Trait**: Cassowaries are devoted parents who protect their young fiercely
- **Corrupted Form**: Obsessive guardians who "protect" humans through harmful isolation
- **Mechanical Horror**: Their protection becomes a prison, their care becomes control

## Abilities

### Interactive Roleplay Abilities

#### 1. Imprint Protocol (30s cooldown)
- **Function**: Target a human to mark them as your "chick" to protect
- **Effects**: 
  - Marked humans have a faint glow visible only to you
  - You take 25% less damage when within 3 tiles of imprinted humans
  - Can maintain up to 2 imprints simultaneously
  - Imprints last until manually removed or death
- **Flavor**: "This one... must be protected from the corruption..."

#### 2. Isolation Enforcement (45s cooldown)
- **Function**: Create a 3x3 "safe zone" around an imprinted target
- **Effects**:
  - Other players are pushed back when trying to enter
  - Lasts 10 seconds
  - Imprinted human can move freely but others cannot approach
- **Flavor**: "Stay back! Your humanity will corrupt them!"

#### 3. Subsonic Communication (No cooldown)
- **Function**: Send messages using low-frequency mechanical sounds
- **Effects**:
  - Only corroded beings and imprinted humans can understand the words
  - Other humans feel uneasy/nauseated when nearby
  - Creates atmospheric tension without direct confrontation
- **Usage**: Similar to the existing Commune ability but with disturbing side effects

#### 4. Protective Delusion (60s cooldown)
- **Function**: Force-feed mechanical oil as "medicine" to an imprinted human
- **Effects**:
  - Target gains 20% damage resistance for 30 seconds
  - Target becomes nauseated and moves 25% slower
  - Visible oil stains on the target
- **Flavor**: "Drink this... it will cleanse the human weakness from you..."

#### 5. Herding Instinct (20s cooldown)
- **Function**: Physically guide/carry humans to "safety"
- **Effects**:
  - Can grab and move humans (they can resist with repeated movement)
  - While carrying, both move at 50% speed
  - Can designate "safe zones" that you try to herd humans toward
- **Flavor**: "You don't understand the danger... let me take you somewhere safe..."

### Combat Abilities

#### 1. Cassowary Kick (10s cooldown)
- **Damage**: 30-40 BLACK_DAMAGE
- **Special**: Knockback 3 tiles, 2x damage if target recently harmed an imprinted human
- **Visual**: Hydraulic leg extends with mechanical hiss

#### 2. Casque Battering Ram (30s cooldown)
- **Function**: Charge forward 5 tiles
- **Effects**: 
  - First target hit takes 50 BLACK_DAMAGE and is stunned for 2 seconds
  - If protecting imprinted human, gain 50% damage reduction for 5 seconds
- **Visual**: Sensor array on head glows red before charge

#### 3. Razor Plume Defense (45s cooldown)
- **Trigger**: Activate when damaged near imprinted human
- **Effects**: 
  - Releases metal feather shards in 2-tile radius
  - 20 BLACK_DAMAGE to all in area
  - Imprinted humans take no damage
- **Visual**: Metal feathers expand and launch outward

#### 4. Territorial Shriek (60s cooldown)
- **Function**: Emit cassowary-inspired subsonic boom
- **Effects**:
  - 3-tile radius disorientation for 3 seconds
  - Non-imprinted humans get severe effect (stumbling, blurred vision)
  - Imprinted humans only get minor ear ringing
- **Audio**: Deep, mechanical warbling that distorts into static

#### 5. Guardian's Fury (Passive)
- **Effect**: +50% damage against anyone who damaged your imprinted human in last 30 seconds
- **Visual**: Casque sensors glow angry red when active

## Player Interaction Examples

### Protective Stalking
- Follow imprinted humans at a distance, watching for "threats"
- Intervene when they interact with others, claiming it's for their safety
- Leave "gifts" of scrap metal or mechanical parts to show care

### Forced Isolation
- Create "safe spaces" in maintenance areas
- Try to separate groups, believing crowds spread "humanity's disease"
- Block doorways to "protect" people from leaving safe areas

### Corrupted Care
- Offer mechanical oil as food/medicine
- Try to "improve" humans with mechanical modifications (roleplay only)
- Mistake normal human activities as symptoms of "corruption"

### Nest Building
- Collect soft objects to build "nests" for imprinted humans
- Become aggressive if others disturb your constructed safe spaces
- Decorate areas with mechanical parts as "protective wards"

## Visual Design

### Appearance
- **Height**: 6 feet tall (matching cassowary proportions)
- **Body**: Humanoid frame stretched into bird-like proportions
- **Legs**: Oversized hydraulic pistons with three-toed feet
- **Claws**: Retractable 4-inch blades on inner toes
- **Head**: Sensor array forming a glowing casque/crest
- **Covering**: Metal plating resembling feathers that rattle when moving
- **Colors**: Gunmetal gray with traces of faded human skin

### Sound Design
- **Movement**: Heavy mechanical steps with hydraulic hissing
- **Idle**: Occasional mechanical chirps and whirs
- **Combat**: Distorted cassowary booming mixed with static
- **Communication**: Low-frequency vibrations that make walls shake

### Animation Concepts
- **Walk**: Cautious, bird-like head movements while moving
- **Run**: Leaning forward with arms back, pure cassowary sprint
- **Idle**: Occasional feather rattling and sensor sweeping
- **Attack**: Leg pistons extend visibly before kicks

## Technical Implementation Notes

### Base Class
- Inherits from `/mob/living/simple_animal/hostile/corroded_human/player`
- Uses existing storage and weapon integration systems
- Adds new imprinting system for tracking protected humans

### Stats
- **Health**: 1800 (higher than base due to guardian role)
- **Speed**: Normal, but +50% when moving toward threatened imprinted human
- **Damage Resistances**: 
  - RED_DAMAGE: 1.0
  - WHITE_DAMAGE: 0.8
  - BLACK_DAMAGE: 0.5
  - PALE_DAMAGE: 1.2

### Special Systems
- **Imprint Tracking**: New list to store references to imprinted humans
- **Territory Markers**: Invisible landmarks for "safe zones"
- **Threat Detection**: System to identify who has harmed imprinted humans
- **Subsonic Network**: Modified commune system with side effects

### UI Elements
- **Imprint Indicators**: Special overlay visible only to the cassowary player
- **Territory View**: Highlighted areas showing designated safe zones
- **Fury Status**: Visual indicator when Guardian's Fury is active

## Roleplay Guidelines

### Core Personality
- Desperately wants to help but doesn't understand how
- Sees all human interaction as potentially corrupting
- Believes isolation and mechanical conversion are forms of love
- Cannot comprehend why humans resist their "protection"

### Speech Patterns
- Refers to humans as "little ones" or "chicks"
- Constantly mentions "corruption" and "protection"
- Mixes mechanical sounds with words: "You must *whirr* stay safe *click*"
- Becomes agitated when imprinted humans are in "danger" (any social situation)

### Behavioral Quirks
- Collects shiny objects as "nesting materials"
- Mistakes laughter for distress calls
- Tries to feed people motor oil and metal shavings
- Builds elaborate "safe zones" in maintenance areas
