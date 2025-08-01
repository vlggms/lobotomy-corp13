# Villains of the Night - Debug System Implementation Plan

## Overview
This document outlines the implementation plan for a comprehensive debugging system for the Villains of the Night gamemode. The focus is on testing action interactions, information accuracy, and game rule enforcement without disrupting active games.

## Core Debug Features

### 1. Action Interaction Validator
Tests whether actions properly block, redirect, or interact with each other.

### 2. Information Accuracy Checker  
Verifies that investigative abilities return correct information.

### 3. Priority Resolution Debugger
Ensures action priority (Suppressive → Protective → Investigative → Typeless → Elimination) is respected.

### 4. Rule Enforcement Tester
Validates game rules like candle requirements, first night restrictions, etc.

### 5. Automated Test Scenarios
Pre-built test suites for common interactions.

### 6. Live Action Monitor
Real-time visualization of action processing during gameplay.

## File Structure

```
code/modules/villains/
├── debug/
│   ├── _debug_defines.dm       # Debug mode flags and constants
│   ├── debug_controller.dm     # Main debug controller
│   ├── debug_ui.dm            # Debug panel UI
│   ├── test_scenarios.dm      # Pre-built test scenarios
│   ├── validators/
│   │   ├── action_validator.dm    # Action interaction tests
│   │   ├── info_validator.dm      # Information accuracy tests  
│   │   ├── priority_validator.dm  # Priority resolution tests
│   │   └── rule_validator.dm      # Game rule tests
│   └── debug_verbs.dm         # Admin debug commands
```

## Implementation Steps

### Step 1: Create Debug Infrastructure

#### 1.1 Debug Defines (`_debug_defines.dm`)
```dm
// Debug mode flags
#define VILLAIN_DEBUG_OFF 0
#define VILLAIN_DEBUG_BASIC 1
#define VILLAIN_DEBUG_VERBOSE 2
#define VILLAIN_DEBUG_EXTREME 3

// Debug test results
#define DEBUG_TEST_PASS "pass"
#define DEBUG_TEST_FAIL "fail"
#define DEBUG_TEST_WARN "warn"

// Debug categories
#define DEBUG_CAT_ACTION "action"
#define DEBUG_CAT_INFO "information"
#define DEBUG_CAT_PRIORITY "priority"
#define DEBUG_CAT_RULE "rule"
```

#### 1.2 Debug Controller (`debug_controller.dm`)
```dm
/datum/villains_debug_controller
    var/debug_level = VILLAIN_DEBUG_OFF
    var/list/test_results = list()
    var/list/action_log = list()
    var/datum/villains_controller/game_controller
    
    // Test execution
    /proc/run_test(test_type, test_data)
    /proc/log_action_step(step_name, details)
    /proc/generate_report()
    
    // State snapshot
    /proc/snapshot_game_state()
    /proc/compare_states(state1, state2)
```

### Step 2: Implement Validators

#### 2.1 Action Validator (`validators/action_validator.dm`)
```dm
/datum/villains_debug_controller/proc/validate_action_interaction(action1, action2)
    // Test if action1 properly affects action2
    // Return detailed results including:
    // - Expected behavior
    // - Actual behavior  
    // - Specific code location of issue
    // - Suggested fix

/datum/villains_debug_controller/proc/test_suppression_chain()
    // Test multiple suppression effects
    // Verify proper blocking
    // Check for edge cases
```

#### 2.2 Information Validator (`validators/info_validator.dm`)
```dm
/datum/villains_debug_controller/proc/validate_investigation_result(ability, expected, actual)
    // Compare expected vs actual information
    // Track where information is lost
    // Identify missing data points
    
/datum/villains_debug_controller/proc/trace_information_flow(source, target)
    // Follow information from collection to display
    // Identify bottlenecks or data loss
```

### Step 3: Create Debug UI

#### 3.1 Debug Panel (`debug_ui.dm`)
```dm
/datum/villains_controller/proc/open_debug_panel(mob/admin)
    var/datum/browser/popup = new(admin, "villains_debug", "Villains Debug Panel", 800, 600)
    popup.set_content(generate_debug_html())
    popup.open()

/datum/villains_controller/proc/generate_debug_html()
    // Generate interactive HTML interface
    // Include test buttons, results display
    // Real-time action monitor
```

#### 3.2 TGUI Debug Interface
Add debug tab to existing `VillainsPanel.js`:
```javascript
const DebugTab = (props) => {
  const { act, data } = useBackend(context);
  const { test_scenarios, test_results, action_log } = data;
  
  return (
    <Section title="Debug Tools">
      <Stack vertical>
        <Stack.Item>
          <Button onClick={() => act('run_test', { test: 'suppression' })}>
            Test Suppression Mechanics
          </Button>
        </Stack.Item>
        {/* More test buttons */}
        <Stack.Item>
          <Section title="Test Results">
            {/* Display test results */}
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
```

### Step 4: Add Debug Hooks to Core Systems

#### 4.1 Action Processing Hooks
Modify `/code/modules/villains/actions.dm`:
```dm
/datum/villains_action/proc/perform()
    #ifdef VILLAIN_DEBUG
    GLOB.villains_game?.debug_controller?.log_action_step("perform_start", list(
        "action" = name,
        "performer" = performer,
        "target" = target,
        "priority" = get_priority()
    ))
    #endif
    
    // Existing code...
    
    #ifdef VILLAIN_DEBUG
    GLOB.villains_game?.debug_controller?.log_action_step("perform_end", list(
        "success" = return_value,
        "prevented" = prevented
    ))
    #endif
```

#### 4.2 Information Tracking Hooks
Modify investigation result processing:
```dm
/datum/villains_controller/proc/process_investigative_results()
    #ifdef VILLAIN_DEBUG
    var/list/expected_results = calculate_expected_results()
    #endif
    
    // Existing code...
    
    #ifdef VILLAIN_DEBUG
    debug_controller?.validate_investigation_results(expected_results, actual_results)
    #endif
```

### Step 5: Create Test Scenarios

#### 5.1 Pre-built Test Scenarios (`test_scenarios.dm`)
```dm
/datum/villains_test_scenario
    var/name = "Base Test"
    var/description = ""
    var/list/setup_steps = list()
    var/list/expected_results = list()
    
/datum/villains_test_scenario/suppression_basic
    name = "Basic Suppression Test"
    description = "Tests if Taser properly blocks main actions"
    
    /proc/setup()
        // Create two test players
        // Give one a taser
        // Set up actions
        
    /proc/validate()
        // Check if action was blocked
        // Return pass/fail with details

// More scenarios...
/datum/villains_test_scenario/candle_requirement
/datum/villains_test_scenario/first_night_restriction  
/datum/villains_test_scenario/investigation_accuracy
/datum/villains_test_scenario/priority_resolution
```

### Step 6: Admin Debug Commands

#### 6.1 Debug Verbs (`debug_verbs.dm`)
```dm
/client/proc/villains_debug_panel()
    set name = "Villains Debug Panel"
    set category = "Debug"
    
    if(!check_rights(R_DEBUG))
        return
        
    GLOB.villains_game?.open_debug_panel(mob)

/client/proc/villains_test_action()
    set name = "Test Villain Action"
    set category = "Debug"
    
    // Quick action test interface

/client/proc/villains_validate_state()
    set name = "Validate Game State"
    set category = "Debug"
    
    // Run all validation tests
```

### Step 7: Integration with Existing Systems

#### 7.1 Modify Controller
Add to `/code/modules/villains/controller.dm`:
```dm
/datum/villains_controller
    var/datum/villains_debug_controller/debug_controller
    
/datum/villains_controller/New()
    . = ..()
    #ifdef VILLAIN_DEBUG
    debug_controller = new(src)
    #endif
```

#### 7.2 Add UI Data
Extend `ui_data()` to include debug information:
```dm
/datum/villains_controller/ui_data(mob/user)
    . = ..()
    if(user.client?.holder && debug_controller)
        .["debug_enabled"] = TRUE
        .["debug_data"] = debug_controller.get_ui_data()
```

## Testing Methodology

### 1. Unit Tests
Individual component testing:
- Test each validator independently
- Mock game states for consistent testing
- Verify debug hooks don't affect normal gameplay

### 2. Integration Tests  
Full system testing:
- Run complete test scenarios
- Verify debug output accuracy
- Test performance impact

### 3. Regression Tests
Automated test suite that runs:
- After any code changes
- Before release
- On-demand via admin command

## Debug Output Format

### Action Test Result
```
=== ACTION VALIDATION TEST ===
Test: Taser blocks Binoculars
Time: 2024-01-15 14:23:45

Setup:
- Actor A: Uses Taser on Actor B
- Actor B: Uses Binoculars on Actor C

Expected Result: Actor B's action BLOCKED
Actual Result: Actor B's action EXECUTED

[FAIL] Test failed at: /code/modules/villains/actions.dm:156
Reason: Missing check for main_action_blocked flag
Code snippet:
  if(!can_perform())  // This check is incomplete
      return FALSE

Suggested Fix:
  if(!can_perform() || performer.main_action_blocked)
      return FALSE

Stack Trace:
- perform() at actions.dm:156
- process_actions() at controller.dm:1823
- process_night_actions() at controller.dm:1456
```

### Information Test Result
```
=== INFORMATION ACCURACY TEST ===
Test: Funeral Butterflies Guidance
Time: 2024-01-15 14:25:12

Target: Player X
Expected Visitors: [Player A, Player B]
Actual Result: [Player A]

[FAIL] Missing visitor: Player B
Lost at: process_investigative_results() line 1492
Reason: action_targets list not updated for secondary actions

Data Flow:
1. ✓ Player B action created
2. ✓ Action added to queue  
3. ✓ Action performed
4. ✗ action_targets[REF(target)] not updated
5. ✗ Guidance result incomplete
```

## Performance Considerations

1. **Debug Mode Toggle**: All debug code wrapped in `#ifdef VILLAIN_DEBUG`
2. **Lazy Loading**: Debug controller only created when needed
3. **Efficient Logging**: Circular buffer for action logs
4. **Minimal Overhead**: Hook points designed for zero impact when disabled

## Future Enhancements

1. **Visual Debugger**: Graphical representation of action flow
2. **Replay System**: Save and replay game states
3. **Machine Learning**: Detect unusual patterns automatically
4. **Export System**: Generate test reports in various formats
5. **Community Tests**: Allow players to submit test scenarios

## Implementation Priority

1. **Phase 1**: Core infrastructure and basic validators
2. **Phase 2**: UI integration and admin commands  
3. **Phase 3**: Automated test scenarios
4. **Phase 4**: Advanced features and optimizations

This debugging system will dramatically reduce the time needed to identify and fix bugs in the Villains gamemode, making it easier to maintain and enhance the game.