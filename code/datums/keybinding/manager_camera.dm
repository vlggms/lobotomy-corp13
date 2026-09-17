#define MANAGER_HP_BULLET 1
#define MANAGER_SP_BULLET 2
#define MANAGER_RED_BULLET 3
#define MANAGER_WHITE_BULLET 4
#define MANAGER_BLACK_BULLET 5
#define MANAGER_PALE_BULLET 6
#define MANAGER_YELLOW_BULLET 7
#define MANAGER_DUAL_BULLET 8
#define MANAGER_QUAD_BULLET 9
#define MANAGER_KILL_BULLET 10

/datum/keybinding/manager
	category = CATEGORY_MANAGER
	weight = WEIGHT_CLIENT

/datum/keybinding/manager/quick_activate
	var/command_type

/datum/keybinding/manager/quick_activate/down(client/user)
	. = ..()
	if(.)
		return
	if (!istype(user.mob, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/M = user.mob
	for(var/datum/action/innate/A in M.actions)
		if(istype(A, command_type))
			A.Activate()
			return TRUE
	return

/datum/keybinding/manager/quick_activate/camera
	hotkey_keys = list("Alt1")
	name = "manager_camera"
	full_name = "Quick Jump To Camera"
	description = "Quick Jump To Camera"
	command_type = /datum/action/innate/camera_jump
	keybind_signal = COMSIG_KB_MANAGER_CAMERA

/datum/keybinding/manager/quick_activate/follow
	hotkey_keys = list("Alt2")
	name = "manager_follow"
	full_name = "Quick Follow Creature"
	description = "Quick Follow Creature"
	command_type = /datum/action/innate/manager_track
	keybind_signal = COMSIG_KB_MANAGER_FOLLOW

/datum/keybinding/manager/quick_activate/cycle
	hotkey_keys = list("Alt3")
	name = "manager_cycle"
	full_name = "Quick Cycle Command"
	description = "Quick Cycle Command"
	command_type = /datum/action/innate/cyclecommand
	keybind_signal = COMSIG_KB_MANAGER_CYCLE

/datum/keybinding/manager/bullet
	var/bullet_type

/datum/keybinding/manager/bullet/down(client/user)
	. = ..()
	if(.)
		return
	if (!istype(user.mob, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/M = user.mob
	for(var/datum/action/A in M.actions)
		if(istype(A, /datum/action/innate/cyclemanagerbullet))
			var/datum/action/innate/cyclemanagerbullet/C = A
			C.Quick_Swap(bullet_type)
			return TRUE
	return

/datum/keybinding/manager/bullet/healing
	hotkey_keys = list("Ctrl1")
	name = "manager_healing_switch"
	full_name = "Healing Bullet Quick Swap"
	description = "Healing Bullet Quick Swap"
	bullet_type = MANAGER_HP_BULLET
	keybind_signal = COMSIG_KB_MANAGER_HEALING

/datum/keybinding/manager/bullet/sanity
	hotkey_keys = list("Ctrl2")
	name = "manager_sanity_switch"
	full_name = "Sanity Bullet Quick Swap"
	description = "Sanity Bullet Quick Swap"
	bullet_type = MANAGER_SP_BULLET
	keybind_signal = COMSIG_KB_MANAGER_SANITY

/datum/keybinding/manager/bullet/red
	hotkey_keys = list("Ctrl3")
	name = "manager_red_switch"
	full_name = "R Shield Bullet Quick Swap"
	description = "R Shield Bullet Quick Swap"
	bullet_type = MANAGER_RED_BULLET
	keybind_signal = COMSIG_KB_MANAGER_RED

/datum/keybinding/manager/bullet/white
	hotkey_keys = list("Ctrl4")
	name = "manager_white_switch"
	full_name = "W Shield Bullet Quick Swap"
	description = "W Shield Bullet Quick Swap"
	bullet_type = MANAGER_WHITE_BULLET
	keybind_signal = COMSIG_KB_MANAGER_WHITE

/datum/keybinding/manager/bullet/black
	hotkey_keys = list("Ctrl5")
	name = "manager_black_switch"
	full_name = "B Shield Bullet Quick Swap"
	description = "B Shield Bullet Quick Swap"
	bullet_type = MANAGER_BLACK_BULLET
	keybind_signal = COMSIG_KB_MANAGER_BLACK

/datum/keybinding/manager/bullet/pale
	hotkey_keys = list("Ctrl6")
	name = "manager_pale_switch"
	full_name = "P Shield Bullet Quick Swap"
	description = "P Shield Bullet Quick Swap"
	bullet_type = MANAGER_PALE_BULLET
	keybind_signal = COMSIG_KB_MANAGER_PALE

/datum/keybinding/manager/bullet/slow
	hotkey_keys = list("Ctrl7")
	name = "manager_slow_switch"
	full_name = "Slow Bullet Quick Swap"
	description = "Slow Bullet Bullet Quick Swap"
	bullet_type = MANAGER_YELLOW_BULLET
	keybind_signal = COMSIG_KB_MANAGER_SLOW

/datum/keybinding/manager/bullet/kill
	hotkey_keys = list("Ctrl8")
	name = "manager_kill_switch"
	full_name = "Execution Bullet Quick Swap"
	description = "Execution Bullet Bullet Quick Swap"
	bullet_type = MANAGER_KILL_BULLET
	keybind_signal = COMSIG_KB_MANAGER_KILL

/datum/keybinding/manager/bullet/dual
	hotkey_keys = list("CtrlShift1")
	name = "manager_dual_switch"
	full_name = "Dual Bullet Quick Swap"
	description = "Dual Bullet Quick Swap"
	bullet_type = MANAGER_DUAL_BULLET
	keybind_signal = COMSIG_KB_MANAGER_DUAL

/datum/keybinding/manager/bullet/quad
	hotkey_keys = list("CtrlShift2")
	name = "manager_quad_switch"
	full_name = "Quad Shield Bullet Quick Swap"
	description = "Quad Shield Bullet Quick Swap"
	bullet_type = MANAGER_QUAD_BULLET
	keybind_signal = COMSIG_KB_MANAGER_QUAD

#undef MANAGER_HP_BULLET
#undef MANAGER_SP_BULLET
#undef MANAGER_RED_BULLET
#undef MANAGER_WHITE_BULLET
#undef MANAGER_BLACK_BULLET
#undef MANAGER_PALE_BULLET
#undef MANAGER_YELLOW_BULLET
#undef MANAGER_DUAL_BULLET
#undef MANAGER_QUAD_BULLET
#undef MANAGER_KILL_BULLET