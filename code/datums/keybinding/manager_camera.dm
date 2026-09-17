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
	hotkey_keys = list("1")
	name = "manager_healing_switch"
	full_name = "Healing Bullet Quick Swap"
	description = "Healing Bullet Quick Swap"
	bullet_type = MANAGER_HP_BULLET
	keybind_signal = COMSIG_KB_MANAGER_HEALING

/datum/keybinding/manager/bullet/sanity
	hotkey_keys = list("2")
	name = "manager_sanity_switch"
	full_name = "Sanity Bullet Quick Swap"
	description = "Sanity Bullet Quick Swap"
	bullet_type = MANAGER_SP_BULLET
	keybind_signal = COMSIG_KB_MANAGER_SANITY

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