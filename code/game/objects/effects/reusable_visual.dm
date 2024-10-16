///Effects managed by /datum/reusable_visual_pool. Do not create instances manually.
/obj/effect/reusable_visual
	name = "nothing"
	icon_state = "nothing"
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	animate_movement = NO_STEPS
	set_dir_on_move = FALSE
	can_be_z_moved = FALSE
	invisibility = 101
	///Reference to the pool that created this object. Do not edit this.
	var/datum/reusable_visual_pool/pool
	///How long the effect will be in use. Only the pool datum should edit this.
	var/duration = 0
	///Only the pool datum should edit this.
	var/is_being_used = FALSE
	///How many DelayedReturn procs are currently existing for this object, it will only be returned by the last remaining DelayedReturn proc.
	var/delayed_return_count = 0

/obj/effect/reusable_visual/New(datum/reusable_visual_pool/creator_pool)
	pool = creator_pool
	return ..()

/obj/effect/reusable_visual/Destroy()
	pool = null
	return ..()

/obj/effect/reusable_visual/singularity_act()
	return

/obj/effect/reusable_visual/singularity_pull()
	return
