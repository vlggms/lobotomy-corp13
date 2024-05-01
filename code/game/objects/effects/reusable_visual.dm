///Effects managed by /datum/reusable_visual_pool. Do not create instances manually.
/obj/effect/reusable_visual
	name = "nothing"
	icon_state = "nothing"
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	animate_movement = NO_STEPS
	set_dir_on_move = FALSE
	invisibility = 101
	///Reference to the pool that created this object. Do not edit this.
	var/datum/reusable_visual_pool/pool
	///How long the effect will be in use. 0 means until manually returned to pool. Only the pool datum should edit this.
	var/duration = 0
	///Only the pool datum should edit this.
	var/timer_id = null
	///Only the pool datum should edit this.
	var/is_being_used = FALSE

/obj/effect/reusable_visual/New(datum/reusable_visual_pool/creator_pool)
	pool = creator_pool
	return ..()

/obj/effect/reusable_visual/Destroy()
	deltimer(timer_id)
	timer_id = null
	pool = null
	return ..()

/obj/effect/reusable_visual/singularity_act()
	return

/obj/effect/reusable_visual/singularity_pull()
	return