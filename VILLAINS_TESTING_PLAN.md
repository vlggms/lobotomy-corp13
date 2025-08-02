# Villains of the Night - Critical Testing Plan

This document outlines all critical features and scenarios that must be tested to ensure the Villains gamemode functions correctly. Each test case includes expected behavior and common failure points.

## Table of Contents
1. [Core Systems Testing](#core-systems-testing)
2. [Action Priority Testing](#action-priority-testing)
3. [Character Ability Testing](#character-ability-testing)
4. [Item Interaction Testing](#item-interaction-testing)
5. [Information Flow Testing](#information-flow-testing)
6. [Edge Case Testing](#edge-case-testing)
7. [Candle System Testing](#candle-system-testing)
8. [Trading System Testing](#trading-system-testing)

## Core Systems Testing

### 1.1 Game Setup and Initialization
- [ ] **Test**: Start game with exactly 5 players
  - **Expected**: Game starts successfully, one villain randomly selected
  - **Common Issues**: Villain not selected, multiple villains selected

- [ ] **Test**: Start game with maximum players (12)
  - **Expected**: All players spawn in correct rooms, no overlap
  - **Common Issues**: Players spawning in same room, missing spawn points

- [ ] **Test**: Character selection phase
  - **Expected**: Each character can only be selected once
  - **Common Issues**: Duplicate character selection, UI not updating

### 1.2 Phase Transitions
- [ ] **Test**: Morning → Evening transition
  - **Expected**: All players locked in rooms, doors close
  - **Common Issues**: Players can still move, doors remain open

- [ ] **Test**: Evening → Nighttime transition
  - **Expected**: Actions process in correct order, delays between actions
  - **Common Issues**: Actions process simultaneously, missing actions

- [ ] **Test**: Investigation phase trigger
  - **Expected**: Only triggers when someone dies
  - **Common Issues**: Triggers without death, doesn't trigger with death

## Action Priority Testing

### 2.1 Priority Order Verification
Test that actions resolve in correct order: Suppressive → Protective → Investigative → Typeless → Elimination

- [ ] **Test**: Taser vs All Other Actions
  - **Setup**: Player A uses Taser on Player B, Player B uses any main action
  - **Expected**: Player B's main action fails completely
  - **Common Issues**: Action still executes, partial execution

- [ ] **Test**: Protection vs Elimination
  - **Setup**: Player A protects Player B, Villain eliminates Player B
  - **Expected**: Player B survives
  - **Common Issues**: Protection ignored, elimination happens first

- [ ] **Test**: Multiple Suppressions
  - **Setup**: Multiple players suppress same target
  - **Expected**: All suppressions apply, target's action fails
  - **Common Issues**: Only first suppression applies

### 2.2 Complex Priority Chains
- [ ] **Test**: Redirect + Suppression
  - **Setup**: Player A redirects Player B to C, Player D suppresses Player B
  - **Expected**: Player B's action fails (suppression happens first)
  - **Common Issues**: Redirect happens before suppression

- [ ] **Test**: Protect Self + Get Eliminated
  - **Setup**: Player uses Forcefield Projector, Villain eliminates them
  - **Expected**: Player survives
  - **Common Issues**: Self-protection not applying

## Character Ability Testing

### 3.1 Protective Characters

#### Queen of Hatred
- [ ] **Test**: Arcana Beats protection
  - **Expected**: Target immune to direct elimination for the night
  - **Common Issues**: Protection not applying, affecting non-elimination actions

- [ ] **Test**: Villain selection probability
  - **Expected**: 50% less likely to be selected as villain
  - **Common Issues**: Normal selection rate, never selected

#### Puss in Boots
- [ ] **Test**: Blessing transfer
  - **Setup**: Bless Player A, then bless Player B
  - **Expected**: Player A loses protection, Player B gains it
  - **Common Issues**: Both protected, neither protected

- [ ] **Test**: Inheritance ability with candles
  - **Expected**: Can only talk/trade with blessed player, costs 1 candle
  - **Common Issues**: Can target anyone, doesn't consume candle

#### Red Blooded American
- [ ] **Test**: Patriotic Fervor redirect
  - **Setup**: Protect Player A, multiple players target Player A
  - **Expected**: All actions redirect to Red Blooded American
  - **Common Issues**: Some actions not redirected, self-targeting creates loop

- [ ] **Test**: Military Instincts passive
  - **Expected**: Learn count of suppressive/elimination actions during investigation
  - **Common Issues**: Wrong count, includes other action types

### 3.2 Investigative Characters

#### Funeral Butterflies
- [ ] **Test**: Guidance visitor tracking
  - **Setup**: Multiple players visit target
  - **Expected**: See all visitors including Talk/Trade
  - **Common Issues**: Missing visitors, seeing non-visitors

- [ ] **Test**: Mercy passive on elimination
  - **Expected**: Learn visitor count to eliminated player
  - **Common Issues**: Wrong count, doesn't trigger

#### Judgement Bird
- [ ] **Test**: Judge ability (Secondary Action)
  - **Expected**: Correctly identifies Innocent/Guilty based on action type
  - **Common Issues**: Wrong judgement, can't use as secondary

- [ ] **Test**: Blind Eye immunity
  - **Expected**: Immune to investigation/suppression while judging
  - **Common Issues**: Still affected by items

#### Shrimp Executive
- [ ] **Test**: Corporate Connections
  - **Expected**: See target's inventory AND who they visited
  - **Common Issues**: Only shows one or neither

- [ ] **Test**: Impatient Executive trigger
  - **Expected**: If no visitors, learn random item user
  - **Common Issues**: Triggers with visitors, doesn't reveal anyone

### 3.3 Suppressive Characters

#### Forsaken Murderer
- [ ] **Test**: Restrained Violence trap
  - **Setup**: Target self, wait for someone to target you
  - **Expected**: First action against you fails
  - **Common Issues**: All actions fail, no actions fail

- [ ] **Test**: Paranoid passive count
  - **Expected**: Accurate count of targeters
  - **Common Issues**: Includes self, misses some targeters

#### Fairy-Long-Legs
- [ ] **Test**: Deceptive Invitation redirect
  - **Expected**: Target's main action redirected to Fairy
  - **Common Issues**: Secondary actions affected, no redirect

- [ ] **Test**: False Shelter item steal
  - **Expected**: Steal item when someone redirected to you
  - **Common Issues**: No item stolen, crashes if no items

#### Kikimora
- [ ] **Test**: Cursed Words spreading
  - **Expected**: Target can only say "kiki/mora", spreads to listeners
  - **Common Issues**: Curse doesn't spread, persists past morning

### 3.4 Special Characters

#### All-Around Cleaner
- [ ] **Test**: Room Cleaning with candles
  - **Expected**: Costs 1 candle, allows trade then steals item
  - **Common Issues**: Doesn't consume candle, steal happens immediately

- [ ] **Test**: Night Cleaner passive
  - **Expected**: Gain random used item after night
  - **Common Issues**: Gets unused items, gets specific item

#### Der Freischütz
- [ ] **Test**: Elimination Contract mechanics
  - **Setup**: Offer contract during night trade
  - **Expected**: Can only offer once per game, not at ≤5 players
  - **Common Issues**: Multiple contracts, works at endgame

- [ ] **Test**: Villain status transfer
  - **Expected**: After successful elimination, contract holder becomes villain
  - **Common Issues**: Transfer happens on contract sign, both are villains

#### Rudolta
- [ ] **Test**: Observe ability
  - **Expected**: Physically follow target, see their actions
  - **Common Issues**: Can't move, target not visible

- [ ] **Test**: Cannot observe same person twice
  - **Expected**: Each person can only be observed once per game
  - **Common Issues**: Can re-observe, observation history lost

## Item Interaction Testing

### 4.1 Investigative Items

- [ ] **Test**: Items blocked by suppression
  - **Setup**: Use investigation item while suppressed
  - **Expected**: Item use fails, no information gained
  - **Common Issues**: Still get information, partial information

- [ ] **Test**: Items on EMP'd player
  - **Setup**: EMP player, they use investigation item
  - **Expected**: Item disabled, no information
  - **Common Issues**: Item works normally

- [ ] **Test**: Stolen investigation items
  - **Setup**: Steal item mid-use
  - **Expected**: Original user gets no info
  - **Common Issues**: Info still delivered

### 4.2 Protective Items

- [ ] **Test**: Smoke Bomb total protection
  - **Expected**: ALL actions on user fail
  - **Common Issues**: Some actions succeed, only blocks certain types

- [ ] **Test**: Guardian Drone other-protection
  - **Expected**: Can't target self, target immune to elimination
  - **Common Issues**: Can self-target, doesn't prevent elimination

### 4.3 Suppressive Items

- [ ] **Test**: Nitrile Gloves item steal + cancel
  - **Expected**: Steal item AND cancel action using that item
  - **Common Issues**: Only steals, only cancels, neither

- [ ] **Test**: W-Corp Teleporter randomization
  - **Expected**: Target's target becomes random living player
  - **Common Issues**: Targets dead players, always same target

### 4.4 Special Items

- [ ] **Test**: Lucky Coin blocking
  - **Expected**: Blocks ONE negative effect as secondary action
  - **Common Issues**: Blocks multiple, blocks positive effects

- [ ] **Test**: Candle item consumption
  - **Expected**: Consumed at evening phase, grants candle resource
  - **Common Issues**: Not consumed, consumed at wrong time

## Information Flow Testing

### 5.1 Information Accuracy

- [ ] **Test**: Multi-visitor scenarios
  - **Setup**: 3+ players visit same target
  - **Expected**: Abilities show all visitors accurately
  - **Common Issues**: Missing visitors, duplicate entries

- [ ] **Test**: Self-targeting information
  - **Expected**: Shows when players target themselves
  - **Common Issues**: Self-targets not tracked

- [ ] **Test**: No-action information
  - **Expected**: Correctly shows when someone took no action
  - **Common Issues**: Shows false actions

### 5.2 Information Blocking

- [ ] **Test**: Suppressed information gathering
  - **Expected**: No information gained when suppressed
  - **Common Issues**: Partial information leaks

- [ ] **Test**: Blue Shepherd false information
  - **Expected**: 20% false villain info, 50% false morning info
  - **Common Issues**: Always accurate, always false

## Edge Case Testing

### 6.1 Timing Edge Cases

- [ ] **Test**: Simultaneous deaths
  - **Setup**: Multiple eliminations same night
  - **Expected**: Only first death counts, others fail
  - **Common Issues**: Multiple deaths, game breaks

- [ ] **Test**: Action on dying player
  - **Expected**: Actions on eliminated player fail
  - **Common Issues**: Actions still process

### 6.2 State Edge Cases

- [ ] **Test**: Disconnect during action
  - **Expected**: Action cancelled, player removed safely
  - **Common Issues**: Action hangs, breaks phase

- [ ] **Test**: Reconnect scenarios
  - **Expected**: Player can resume if still in game
  - **Common Issues**: Duplicate player, lost progress

### 6.3 Boundary Conditions

- [ ] **Test**: Zero items in inventory
  - **Expected**: Steal abilities handle gracefully
  - **Common Issues**: Null reference errors

- [ ] **Test**: Maximum items (5 for Warden)
  - **Expected**: Can't pick up more items
  - **Common Issues**: Exceeds limit, items deleted

## Candle System Testing

### 7.1 Candle Resource Management

- [ ] **Test**: Starting candle count
  - **Expected**: Everyone starts with exactly 1 candle
  - **Common Issues**: Wrong starting amount, some have 0

- [ ] **Test**: Candle consumption for Talk/Trade
  - **Expected**: Costs 1 candle, action fails if 0 candles
  - **Common Issues**: Doesn't consume, works without candles

- [ ] **Test**: Candle item → resource conversion
  - **Expected**: Evening phase converts all candle items to resources
  - **Common Issues**: Items not consumed, resources not added

### 7.2 Candle-Dependent Abilities

- [ ] **Test**: All-Around Cleaner candle requirement
  - **Expected**: Room Cleaning requires and consumes 1 candle
  - **Common Issues**: Works without candles

- [ ] **Test**: Puss in Boots Inheritance
  - **Expected**: Secondary trade requires 1 candle
  - **Common Issues**: Free trading with blessed

- [ ] **Test**: UI candle display
  - **Expected**: Shows accurate candle count in character sheet
  - **Common Issues**: Doesn't update, shows wrong amount

## Trading System Testing

### 8.1 Basic Trading

- [ ] **Test**: 2-minute trade timer
  - **Expected**: Trade lasts exactly 2 minutes
  - **Common Issues**: Instant trade, never ends

- [ ] **Test**: Simultaneous trade requests
  - **Expected**: Can't trade with someone already trading
  - **Common Issues**: Multiple simultaneous trades

### 8.2 Special Trade Interactions

- [ ] **Test**: Der Freischütz contract during trade
  - **Expected**: Can offer contract only during night trade
  - **Common Issues**: Can offer anytime, during day

- [ ] **Test**: All-Around Cleaner steal after trade
  - **Expected**: Steals item AFTER trade completes
  - **Common Issues**: Steals during trade, no steal

- [ ] **Test**: Sunset Traveller trade protection
  - **Expected**: Trade partner immune to suppression rest of night
  - **Common Issues**: No immunity granted

## First Night Restriction Testing

- [ ] **Test**: Villain eliminate disabled first night
  - **Expected**: Eliminate option unavailable/disabled
  - **Common Issues**: Can still eliminate

- [ ] **Test**: First night flag clears
  - **Expected**: Second night allows elimination
  - **Common Issues**: Always restricted, never restricted

## Test Execution Guidelines

1. **Test Order**: Execute tests in listed order as later tests may depend on earlier systems
2. **Reset Between Tests**: Always start fresh game for each major test category
3. **Document Failures**: Note exact error messages and unexpected behaviors
4. **Regression Testing**: Re-test affected systems after any code changes
5. **Performance Notes**: Document any lag or delays during complex scenarios

## Critical Failure Points

These scenarios MUST work correctly or the game is unplayable:

1. **Action Processing**: All actions must resolve in correct priority order
2. **Elimination Protection**: Protected players must survive elimination attempts
3. **Information Accuracy**: Investigation abilities must return correct information
4. **Candle System**: Players must not be soft-locked without candles
5. **Phase Transitions**: Game must progress through phases without hanging
6. **Villain Selection**: Exactly one villain must exist at all times (until endgame)

## Automated Test Suggestions

Consider implementing automated tests for:
- Action priority resolution
- Information gathering accuracy  
- Candle resource tracking
- Phase transition states
- Character ability effects

This testing plan should be executed before any major release and after significant code changes to ensure game stability.