#define WORKBAR_ANIMATION_TIME 5

/obj/workbar
	icon = 'icons/effects/progessbar.dmi'
	icon_state = "prog_bar_0"
	alpha = 0
	plane = ABOVE_HUD_PLANE
	appearance_flags = APPEARANCE_UI_IGNORE_ALPHA

	///The bar border visual element.
	var/image/bar_border
	///The work icon visual element.
	var/image/work
	///The mob whos working
	var/mob/user
	///Effectively the number of steps the progress bar will need to do before reaching completion.
	var/goal = 1
	///Control check to see if the progress was interrupted before reaching its goal.
	var/last_progress = 0

/obj/workbar/New(loc, mob/User, goal_number, work_type)
	. = ..()
	if(QDELETED(User) || !istype(User))
		stack_trace("/obj/workbar created with [isnull(User) ? "null" : "invalid"] user")
		qdel(src)
		return
	if(!isnum(goal_number))
		stack_trace("/obj/workbar created with [isnull(User) ? "null" : "invalid"] goal_number")
		qdel(src)
		return
	goal = goal_number
	bar_border = image('icons/effects/progessbar_lobotomy.dmi', src, "bar", HUD_LAYER)
	bar_border.plane = ABOVE_HUD_PLANE
	bar_border.pixel_y = -2
	bar_border.pixel_x = -16
	add_overlay(bar_border)

	work = image('icons/effects/worktypes.dmi', src, get_work_type(work_type), HUD_LAYER)
	work.plane = ABOVE_HUD_PLANE
	work.pixel_y = 10
	add_overlay(work)

	user = User
	//Animate it
	animate(src, pixel_y = 32, alpha = 255, time = WORKBAR_ANIMATION_TIME, easing = SINE_EASING, flags = ANIMATION_PARALLEL)

///Updates the work bar icon state
/obj/workbar/proc/update(progress)
	progress = clamp(progress, 0, goal)
	if(progress == last_progress)
		return
	last_progress = progress
	icon_state = "prog_bar_[round(((progress / goal) * 100), 5)]"

///Called on progress end, be it successful or a failure. Wraps up things to delete the obj.
/obj/workbar/proc/end_progress()
	if(last_progress != goal)
		icon_state = "[icon_state]_fail"
	animate(src, alpha = 0, time = WORKBAR_ANIMATION_TIME)
	QDEL_IN(src, WORKBAR_ANIMATION_TIME)

///A global proc to return the work icon of a work type. Just incase we want to use this in the future for something else
proc/get_work_type(work_type)
	switch(work_type)
		if(ABNORMALITY_WORK_INSTINCT)
			return "instinct_work"
		if(ABNORMALITY_WORK_INSIGHT)
			return "insight_work"
		if(ABNORMALITY_WORK_ATTACHMENT)
			return "attachment_work"
		if(ABNORMALITY_WORK_REPRESSION)
			return "repression_work"
	return "unknown_work"

#undef WORKBAR_ANIMATION_TIME
