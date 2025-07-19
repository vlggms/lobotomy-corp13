# Villains of the Night - Implementation Checklist

## Major Update (Victory Point System) ✅
The game now uses a **victory point system** instead of player elimination:
- Players gain +1 point for correctly voting the villain
- Players lose -1 point for incorrect votes  
- **Only villains leave the round** (whether caught or not)
- **Innocent players who are voted STAY in the game**
- Game continues with a new villain if 5+ players remain
- Game ends when <5 players remain
- Winners are determined by having ≥1 victory points

## Core Systems

### Game Controller ✅
- [x] Phase management system
- [x] Player management (signup, character selection)
- [x] Room assignment system
- [x] Action queue and processing
- [x] Victory tracking
- [x] Map loading and cleanup
- [x] Debug/admin tools
- [x] Phase timers and transitions
- [x] **Win condition checking system** ✅
- [x] **Game end determination** ✅
- [x] **Victory point calculation display** ✅
- [ ] **Reconnection handling**
- [ ] **Save/load game state**

### Characters ✅ 
All 17 characters implemented with abilities:
- [x] Queen of Hatred
- [x] Forsaken Murder
- [x] All Round Cleaner
- [x] Funeral of the Dead Butterflies
- [x] Fairy Gentleman
- [x] Puss in Boots
- [x] Der Freischütz
- [x] Rudolta of the Sleigh
- [x] Judgement Bird
- [x] Shrimp Executive
- [x] Sunset Traveller
- [x] Fairy Long-Legs
- [x] Red Blooded American
- [x] Kikimora
- [x] Little Red Riding Hooded Mercenary (Red Hood)
- [x] Warden
- [x] Blue Shepherd

**⚠️ NEEDS TESTING: All character abilities need thorough testing in actual gameplay scenarios**

### Items
#### Implemented ✅
- [x] Enkephalin Detector (Investigative - Uncommon)
- [x] Forcefield Projector (Protective - Rare)
- [x] DEEPSCAN Kit (Investigative - Uncommon)
- [x] Handheld Taser (Suppressive - Uncommon)
- [x] Drain Monitor (Investigative - Uncommon)
- [x] Keen-Sense Rangefinder (Investigative - Uncommon)
- [x] W-Corp Teleporter (Suppressive - Uncommon)
- [x] Throwing Bola (Suppressive - Common)
- [x] Nitrile Gloves (Suppressive - Rare)
- [x] Binoculars (Investigative - Common)
- [x] Command Projector (Investigative - Common)
- [x] Fairy Wine (Special - Rare)
- [x] Guardian Drone (Protective - Rare)
- [x] Smoke Bomb (Protective - Uncommon)
- [x] Audio Recorder (Investigative - Common)
- [x] EMP Device (Suppressive - Rare)
- [x] Lucky Coin (Special - Uncommon)

**⚠️ NEEDS TESTING: All items need thorough testing in actual gameplay scenarios**

#### Missing ✅
- [x] **Additional protective items** ✅
- [x] **More item variety per category** ✅

### Action System ✅
- [x] Base action framework with priority
- [x] Talk/Trade sessions
- [x] Character ability actions
- [x] Item use actions
- [x] Elimination actions
- [x] Action prevention/blocking
- [x] **Enhanced trade UI for item exchanges** ✅
- [x] **Contract system UI for Der Freischütz** ✅
- [x] **Trade history tracking** ✅

## Game Phases

### Morning Phase ✅
- [x] Basic implementation
- [x] Item spawning
- [x] Player movement
- [x] Time extension voting
- [x] **Better item spawn distribution** ✅

### Evening Phase ✅
- [x] Room lockdown
- [x] Action selection UI
- [x] Action submission

### Nighttime Phase ✅
- [x] Action processing
- [x] Priority system
- [x] Action delays
- [ ] **Visual feedback for actions**
- [ ] **Sound effects**

### Investigation Phase ✅
- [x] Basic implementation
- [x] Evidence item system
- [x] **Proper evidence scattering** ✅
  - Evidence spawns only in hallway turfs
  - No overlapping evidence items
  - Items cannot be picked up, only marked as found
  - Found items are sent to main room for all to examine
- [x] **Evidence list display in main room** ✅
  - UI shows all evidence found during investigation
  - List updates to show who found each item
  - Different display for investigation vs briefing phase
- [x] **2-minute discussion period** ✅
  - Trial briefing phase after investigation
  - All players teleported to main room
  - 2-minute timer before alibis begin
  - Chat notifications implemented

**⚠️ NEEDS TESTING: Investigation Phase evidence collection mechanics need real game testing**

### Alibi Phase ✅
- [x] Basic framework
- [x] Turn-based speaking system
- [x] 30-second timer per player
- [x] Force whisper for non-speakers

### Discussion Phase ✅
- [x] Basic implementation

### Final Voting Phase ✅
- [x] Voting UI
- [x] Vote submission

### Final Results Phase ✅
- [x] Basic framework
- [x] **Vote tallying logic** ✅
- [x] **Villain reveal animation** ✅
- [x] **Victory/defeat determination** ✅
- [x] **3-4 minute post-game discussion** ✅
- [x] **Victory point system** ✅
  - Players gain/lose points based on voting correctly
  - No one dies from voting
  - Game continues with new villain if 5+ players remain
  - Final winner based on victory points (≥1 = win)

**⚠️ NEEDS TESTING: Final Results Phase with new victory point system needs thorough testing**

## UI Components

### Implemented ✅
- [x] Main game panel (VillainsPanel.js)
- [x] Character sheet (VillainsCharacterSheet.js)
- [x] Action selection (VillainsSimpleActionSelection.js)
- [x] Basic voting interface
- [x] Admin controls
- [x] **Victory points display** ✅
- [x] **Results phase UI** ✅

### Missing ❌
- [ ] **Action log/history viewer**
- [ ] **Phase-specific UI overlays**
- [ ] **Tutorial/help system**

## Maps ✅
- [x] One map template (lc13_mafia.dmm)

## Polish & QoL

### Visual/Audio ❌
- [ ] **Phase change sound effects**
- [ ] **Action sound effects**
- [ ] **Elimination animations**
- [ ] **Visual effects for abilities**
- [ ] **Background music**

### Game Features ❌
- [ ] **Statistics tracking**
- [ ] **Achievement system**
- [ ] **Practice/tutorial mode**

### Technical ❌
- [ ] **Robust error handling**
- [ ] **Performance optimization**
- [ ] **Logging system for debugging**

## Priority Implementation Order

1. **Critical (Game Breaking)** ✅
   - [x] Win condition checking ✅
   - [x] Game end determination ✅
   - [x] Vote tallying logic ✅
   - [x] Villain reveal system ✅

2. **High Priority (Core Features)**
   - [x] Alibi phase turn-based speaking ✅
   - [x] Trade UI for item exchanges ✅
   - [x] Evidence scattering in investigation ✅
   - [x] Spectator mode ✅

3. **Medium Priority (Polish)**
   - [ ] Additional maps
   - [ ] Sound effects
   - [ ] Chat system
   - [ ] Visual feedback

4. **Low Priority (Nice to Have)**
   - [ ] Tutorial system
   - [ ] Statistics tracking
   - [ ] Replay system
   - [ ] Achievement system

## Testing Checklist

- [ ] Full game flow from start to finish
- [ ] All character abilities work correctly
- [ ] All items function as intended
- [ ] Phase transitions are smooth
- [ ] UI is responsive and intuitive
- [ ] Edge cases handled (disconnects, etc.)
- [ ] Balance testing with different player counts
- [ ] Performance testing with max players

## Notes

- The core framework is solid with most characters and basic systems implemented
- Main focus should be on completing the game flow and win conditions
- UI polish and additional content can come after core functionality
- Consider playtesting early to identify balance issues
