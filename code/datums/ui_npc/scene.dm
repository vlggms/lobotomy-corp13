// Enhanced scene structure for UI_NPC

// Scene action with multiple transitions and conditions
/datum/ui_npc/scene_action
	var/text = ""                        // Text shown to the player

	// Visibility conditions
	var/visibility_expression = ""       // Expression that must evaluate to TRUE for action to be visible
	var/datum/callback/visible_proc      // Callback to determine visibility

	// Enablement conditions
	var/enabled_expression = ""          // Expression that must evaluate to TRUE for action to be enabled
	var/datum/callback/enabled_proc      // Callback to determine if action is enabled

	// Execution
	var/list/proc_callbacks = list()     // List of callbacks to execute when action is selected
	var/list/var_updates = list()        // Variable updates when action is selected

	// Transitions - ordered list of conditions and destinations
	var/list/transitions = list()        // List of conditional transitions
	var/default_scene = ""               // Default scene if no transitions match

// Create a scene action from data
/datum/ui_npc/scene_action/New(list/data)
	if(!data)
		return

	// Basic text
	text = data["text"]

	// Visibility conditions
	visibility_expression = data["visibility_expression"]
	visible_proc = data["visible_proc"]

	// Enablement conditions
	enabled_expression = data["enabled_expression"]
	enabled_proc = data["enabled_proc"]

	// Callbacks and updates
	proc_callbacks = data["proc_callbacks"] || list()
	var_updates = data["var_updates"] || list()

	// Transitions
	transitions = data["transitions"] || list()
	default_scene = data["default_scene"] || ""

// Determine which scene to transition to based on conditions
/datum/ui_npc/scene_action/proc/get_next_scene(datum/ui_npc/scene_manager/manager, mob/user)
	// Check each transition in order
	for(var/list/transition in transitions)
		// Expression-based condition
		if(transition["expression"])
			if(manager.evaluate_condition(user, transition["expression"]))
				return transition["scene"]

		// Proc-based condition
		else if(transition["proc"])
			var/datum/callback/condition_proc = transition["proc"]
			if(condition_proc && condition_proc.Invoke())
				return transition["scene"]

	// Return default if no conditions matched
	return default_scene

// Scene definition with enhanced action structure
/datum/ui_npc/scene
	var/text = ""                         // Scene text
	var/list/on_enter = list()            // Variable updates when entering scene
	var/list/on_exit = list()             // Variable updates when leaving scene
	var/list/datum/ui_npc/scene_action/actions = list()  // Available actions

// Create a scene from data
/datum/ui_npc/scene/New(list/data)
	if(!data)
		return

	text = data["text"]
	on_enter = data["on_enter"] || list()
	on_exit = data["on_exit"] || list()

	if(data["actions"])
		for(var/action_key in data["actions"])
			var/list/action_data = data["actions"][action_key]
			actions[action_key] = new /datum/ui_npc/scene_action(action_data)
