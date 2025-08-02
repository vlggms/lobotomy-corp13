# Villains UI Signup Troubleshooting Plan

## Problem Description
The `villains_signup()` function in `code/modules/mob/dead/observer/observer.dm` is supposed to open a UI for game signup, but the UI is not opening when the button is clicked.

## Investigation Steps

### 1. Verify the UI Chain
- [ ] Check that the ghost HUD button is properly created and added to the screen
- [ ] Verify the button click handler is calling `villains_signup()`
- [ ] Ensure `villains_signup()` is properly calling `ui_interact()`

### 2. Check UI Implementation
- [ ] Verify that the controller has proper `ui_interact()`, `ui_data()`, and `ui_act()` implementations
- [ ] Check if the UI interface name ("VillainsPanel") matches what's expected
- [ ] Ensure the TGUI interface file exists in `tgui/packages/tgui/interfaces/`

### 3. Debug the Controller Creation
- [ ] Verify GLOB.villains_game is being created properly
- [ ] Check if the controller is being destroyed prematurely
- [ ] Ensure the controller's New() proc completes successfully

### 4. Check for Runtime Errors
- [ ] Add debug logging to track the execution flow
- [ ] Check for any runtime errors in the game logs
- [ ] Verify all required variables are initialized

## Implementation Plan

### Step 1: Add Debug Logging
Add logging statements to track the execution:
```dm
/mob/dead/observer/proc/villains_signup()
    log_game("DEBUG: villains_signup() called for [src]")
    if(!client)
        log_game("DEBUG: No client found")
        return
    if(!isobserver(src))
        log_game("DEBUG: Not an observer")
        return
    
    var/datum/villains_controller/game = GLOB.villains_game
    log_game("DEBUG: GLOB.villains_game = [game]")
    if(!game)
        log_game("DEBUG: Creating new villains controller")
        game = new /datum/villains_controller()
        GLOB.villains_game = game
    
    log_game("DEBUG: Calling ui_interact")
    game.ui_interact(usr)
```

### Step 2: Implement Missing UI Methods
The controller needs these methods for TGUI to work:
```dm
/datum/villains_controller/ui_state(mob/user)
    return GLOB.always_state

/datum/villains_controller/ui_data(mob/user)
    var/list/data = list()
    data["phase"] = current_phase
    data["signup_count"] = length(GLOB.villains_signup)
    data["min_players"] = VILLAINS_MIN_PLAYERS
    data["max_players"] = VILLAINS_MAX_PLAYERS
    data["signed_up"] = (user.ckey in GLOB.villains_signup)
    // Add more data as needed
    return data

/datum/villains_controller/ui_act(action, params)
    . = ..()
    if(.)
        return
    
    switch(action)
        if("signup")
            // Handle signup
            return TRUE
        if("leave")
            // Handle leaving
            return TRUE
```

### Step 3: Create TGUI Interface File
Create `tgui/packages/tgui/interfaces/VillainsPanel.js`:
```javascript
import { useBackend } from '../backend';
import { Button, Section, Box } from '../components';
import { Window } from '../layouts';

export const VillainsPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    phase,
    signup_count,
    min_players,
    max_players,
    signed_up,
  } = data;

  return (
    <Window title="Villains of the Night" width={400} height={300}>
      <Window.Content>
        <Section title="Game Status">
          <Box>
            Players signed up: {signup_count} / {max_players}
          </Box>
          <Box>
            Minimum players needed: {min_players}
          </Box>
          <Box>
            Current phase: {phase}
          </Box>
        </Section>
        <Section title="Actions">
          {!signed_up ? (
            <Button
              content="Sign Up"
              onClick={() => act('signup')}
            />
          ) : (
            <Button
              content="Leave Game"
              onClick={() => act('leave')}
            />
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
```

### Step 4: Fix Timer Issue
The controller starts a 1-minute timer immediately on creation, which might cause issues:
```dm
/datum/villains_controller/New()
    // Don't start the game timer immediately
    // phase_timer = addtimer(CALLBACK(src, .proc/setup_game), 1 MINUTES, TIMER_STOPPABLE)
    map_deleter = new
    
/datum/villains_controller/proc/start_signup_timer()
    if(!phase_timer)
        phase_timer = addtimer(CALLBACK(src, .proc/setup_game), 1 MINUTES, TIMER_STOPPABLE)
```

### Step 5: Add Signup Management
Implement proper signup handling:
```dm
/datum/villains_controller/ui_act(action, params)
    . = ..()
    if(.)
        return
    
    var/mob/user = usr
    if(!user.ckey)
        return
    
    switch(action)
        if("signup")
            if(length(GLOB.villains_signup) >= VILLAINS_MAX_PLAYERS)
                to_chat(user, span_warning("The game is full!"))
                return TRUE
            if(!(user.ckey in GLOB.villains_signup))
                GLOB.villains_signup += user.ckey
                to_chat(user, span_notice("You have signed up for Villains of the Night!"))
                // Start timer when first player signs up
                if(length(GLOB.villains_signup) == 1)
                    start_signup_timer()
            return TRUE
            
        if("leave")
            if(user.ckey in GLOB.villains_signup)
                GLOB.villains_signup -= user.ckey
                to_chat(user, span_notice("You have left the Villains of the Night signup."))
                // Cancel timer if no players left
                if(!length(GLOB.villains_signup) && phase_timer)
                    deltimer(phase_timer)
                    phase_timer = null
            return TRUE
```

## Testing Checklist
1. [ ] Click the Villains signup button as a ghost
2. [ ] Verify the UI window opens
3. [ ] Test signing up for the game
4. [ ] Test leaving the game
5. [ ] Verify the game starts after 1 minute with enough players
6. [ ] Check that the UI updates properly when other players join/leave

## Common Issues and Solutions

### UI Not Opening
- Missing TGUI interface file
- Runtime errors in ui_interact()
- Controller not being created properly

### Signup Not Working
- Missing ui_act() implementation
- GLOB lists not initialized
- Permission/state issues

### Game Not Starting
- Timer not being set properly
- Not enough players
- Controller being destroyed

## Final Notes
The key is to ensure the entire UI chain is properly implemented:
1. Ghost HUD button → Click handler
2. villains_signup() → Controller creation
3. ui_interact() → TGUI system
4. TGUI interface → User interaction
5. ui_act() → Game state changes