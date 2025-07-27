//Status effects are used to apply temporary or permanent effects to mobs. Mobs are aware of their status effects at all times.
//This file contains their code, plus code for applying and removing them.
//When making a new status effect, add a define to status_effects.dm in __DEFINES for ease of use!

/datum/status_effect
	var/id = "effect" //Used for screen alerts.
	var/duration = -1 //How long the status effect lasts in DECISECONDS. Enter -1 for an effect that never ends unless removed through some means.
	var/tick_interval = 10 //How many deciseconds between ticks, approximately. Leave at 10 for every second. Setting this to -1 will stop processing if duration is also unlimited.
	var/mob/living/owner //The mob affected by the status effect.
	var/status_type = STATUS_EFFECT_UNIQUE //How many of the effect can be on one mob, and what happens when you try to add another
	var/on_remove_on_mob_delete = FALSE //if we call on_remove() when the mob is deleted
	var/examine_text //If defined, this text will appear when the mob is examined - to use he, she etc. use "SUBJECTPRONOUN" and replace it in the examines themselves
	var/alert_type = /atom/movable/screen/alert/status_effect //the alert thrown by the status effect, contains name and description
	var/atom/movable/screen/alert/status_effect/linked_alert = null //the alert itself, if it exists

/datum/status_effect/New(list/arguments)
	on_creation(arglist(arguments))

/datum/status_effect/proc/on_creation(mob/living/new_owner, ...)
	if(new_owner)
		owner = new_owner
	if(owner)
		LAZYADD(owner.status_effects, src)
	if(!owner || !on_apply())
		qdel(src)
		return
	if(duration != -1)
		duration = world.time + duration
	tick_interval = world.time + tick_interval
	if(alert_type)
		var/atom/movable/screen/alert/status_effect/A = owner.throw_alert(id, alert_type)
		A.attached_effect = src //so the alert can reference us, if it needs to
		linked_alert = A //so we can reference the alert, if we need to
	if(duration > 0 || initial(tick_interval) > 0) //don't process if we don't care
		START_PROCESSING(SSfastprocess, src)
	return TRUE

/datum/status_effect/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	if(owner)
		linked_alert = null
		owner.clear_alert(id)
		LAZYREMOVE(owner.status_effects, src)
		on_remove()
		owner = null
	return ..()

/datum/status_effect/process()
	if(!owner)
		qdel(src)
		return
	if(tick_interval < world.time)
		tick()
		tick_interval = world.time + initial(tick_interval)
	if(duration != -1 && duration < world.time)
		qdel(src)

/datum/status_effect/proc/on_apply() //Called whenever the buff is applied; returning FALSE will cause it to autoremove itself.
	return TRUE
/datum/status_effect/proc/tick() //Called every tick.
/datum/status_effect/proc/on_remove() //Called whenever the buff expires or is removed; do note that at the point this is called, it is out of the owner's status_effects but owner is not yet null
/datum/status_effect/proc/be_replaced() //Called instead of on_remove when a status effect is replaced by itself or when a status effect with on_remove_on_mob_delete = FALSE has its mob deleted
	owner.clear_alert(id)
	LAZYREMOVE(owner.status_effects, src)
	owner = null
	qdel(src)

/datum/status_effect/proc/before_remove() //! Called before being removed; returning FALSE will cancel removal
	return TRUE

/datum/status_effect/proc/refresh()
	var/original_duration = initial(duration)
	if(original_duration == -1)
		return
	duration = world.time + original_duration

//LC13 Addition -IP
//This is for status effects that add a little box at the top of your character. These new procs sort those boxes.
//Its weird using defines as coder variables.
//The row will be one less than this number. Wrap 0-3 would be rows of 3 icons.
#define MINIMUM_ROW_NUMBER 0
#define MAXIMUM_ROW_NUMBER 4
//This is the width and height of the icon in pixels so that they dont overlap.
#define STATUS_ICON_WIDTH 10
#define STATUS_ICON_HEIGHT 10
//X axis offset for status effect icon, changing this to negative makes the icon appear farther to the left.
#define STATUS_ICON_OFFSET -5

/datum/status_effect/display
	var/display_name
	var/mutable_appearance/icon_overlay

/datum/status_effect/display/on_apply()
	. = ..()
	UpdateStatusDisplay()
	return TRUE

/datum/status_effect/display/on_remove()
	if(icon_overlay)
		owner.cut_overlay(icon_overlay)
	..()

	//This is the system for sorting the buff/debuff icons for display status effects.-IP
	//We can change this into a optional proc for normal status effects but display subtype is easier to find.
/datum/status_effect/display/proc/UpdateStatusDisplay()
	if(owner.status_effects.len <= 1)
		AddDisplayIcon(MINIMUM_ROW_NUMBER)
		return FALSE
	var/tally = 0
	for(var/datum/status_effect/display/SE in owner.status_effects)
		if(SE.icon_overlay)
			owner.cut_overlay(SE.icon_overlay)
			SE.icon_overlay = null
		SE.AddDisplayIcon(tally)
		tally++

	//This is the code that UpdateStatusDisplay calls for each display status effect every time a display status effect is added. -IP
/datum/status_effect/display/proc/AddDisplayIcon(position)
	icon_overlay = mutable_appearance('ModularTegustation/Teguicons/tegu_effects10x10.dmi', display_name, -MUTATIONS_LAYER)
	TweakDisplayIcon(position)
	owner.add_overlay(icon_overlay)

	//This is for altering the display icon. If you want the icon to be different color you would add onto this like in parasite tree. -IP
/datum/status_effect/display/proc/TweakDisplayIcon(our_slot)
	//at 0 our x should be -2
	var/column = (WRAP(our_slot, MINIMUM_ROW_NUMBER, MAXIMUM_ROW_NUMBER ) * STATUS_ICON_WIDTH ) + STATUS_ICON_OFFSET
	//at 0 our slot should be 30
	var/row = 33 + (round(our_slot * (1/ MAXIMUM_ROW_NUMBER )) * STATUS_ICON_HEIGHT )
	icon_overlay.pixel_x = column
	icon_overlay.pixel_y = row

#undef MINIMUM_ROW_NUMBER
#undef MAXIMUM_ROW_NUMBER
#undef STATUS_ICON_WIDTH
#undef STATUS_ICON_HEIGHT
#undef STATUS_ICON_OFFSET

//clickdelay/nextmove modifiers!
/datum/status_effect/proc/nextmove_modifier()
	return 1

/datum/status_effect/proc/nextmove_adjust()
	return 0

////////////////
// ALERT HOOK //
////////////////

/atom/movable/screen/alert/status_effect
	name = "Curse of Mundanity"
	desc = "You don't feel any different..."
	var/datum/status_effect/attached_effect

/atom/movable/screen/alert/status_effect/Destroy()
	attached_effect = null //Don't keep a ref now
	return ..()

//////////////////
// HELPER PROCS //
//////////////////

/mob/living/proc/apply_status_effect(effect, ...) //applies a given status effect to this mob, returning the effect if it was successful
	. = FALSE
	var/datum/status_effect/S1 = effect
	LAZYINITLIST(status_effects)
	var/our_id = initial(S1.id)
	for(var/datum/status_effect/S in status_effects)
		if(S.id == our_id)
			switch(S.status_type)
				if(STATUS_EFFECT_MULTIPLE)
					// check the rest of the matching effects in case they have a different status_type somehow
					continue
				if(STATUS_EFFECT_UNIQUE)
					// leave the original untouched and don't add this one
					return
				if(STATUS_EFFECT_REPLACE)
					// used for behavior where the newly-applied effect takes over
					// and the old effect is deleted
					S.be_replaced()
				if(STATUS_EFFECT_REFRESH)
					// used for behavior where the old effect is updated with stats from the new one
					// and the new one is deleted
					S.refresh()
					return
	var/list/arguments = args.Copy()
	arguments[1] = src
	S1 = new effect(arguments)
	. = S1

/mob/living/proc/remove_status_effect(effect, ...) //removes all of a given status effect from this mob, returning TRUE if at least one was removed
	. = FALSE
	var/list/arguments = args.Copy(2)
	if(status_effects)
		var/datum/status_effect/S1 = effect
		var/our_id = initial(S1.id)
		for(var/datum/status_effect/S in status_effects)
			if(our_id == S.id && S.before_remove(arguments))
				qdel(S)
				. = TRUE

/mob/living/proc/has_status_effect(effect) //returns the effect if the mob calling the proc owns the given status effect
	. = FALSE
	if(status_effects)
		var/datum/status_effect/S1 = effect
		var/our_id = initial(S1.id)
		for(var/datum/status_effect/S in status_effects)
			if(our_id == S.id)
				return S

/mob/living/proc/has_status_effect_list(effect) //returns a list of effects with matching IDs that the mod owns; use for effects there can be multiple of
	. = list()
	if(status_effects)
		var/datum/status_effect/S1 = effect
		var/our_id = initial(S1.id)
		for(var/datum/status_effect/S in status_effects)
			if(our_id == S.id)
				. += S

//////////////////////
// STACKING EFFECTS //
//////////////////////

/datum/status_effect/stacking
	id = "stacking_base"
	duration = -1 //removed under specific conditions
	alert_type = null
	var/stacks = 0 //how many stacks are accumulated, also is # of stacks that target will have when first applied
	var/delay_before_decay //deciseconds until ticks start occuring, which removes stacks (first stack will be removed at this time plus tick_interval)
	tick_interval = 10 //deciseconds between decays once decay starts
	var/stack_decay = 1 //how many stacks are lost per tick (decay trigger)
	var/stack_threshold //special effects trigger when stacks reach this amount
	var/max_stacks //stacks cannot exceed this amount
	var/consumed_on_threshold = TRUE //if status should be removed once threshold is crossed
	var/threshold_crossed = FALSE //set to true once the threshold is crossed, false once it falls back below
	var/overlay_file
	var/underlay_file
	var/overlay_state // states in .dmi must be given a name followed by a number which corresponds to a number of stacks. put the state name without the number in these state vars
	var/underlay_state // the number is concatonated onto the string based on the number of stacks to get the correct state name
	var/mutable_appearance/status_overlay
	var/mutable_appearance/status_underlay

/datum/status_effect/stacking/proc/threshold_cross_effect() //what happens when threshold is crossed

/datum/status_effect/stacking/proc/stacks_consumed_effect() //runs if status is deleted due to threshold being crossed

/datum/status_effect/stacking/proc/fadeout_effect() //runs if status is deleted due to being under one stack

/datum/status_effect/stacking/proc/stack_decay_effect() //runs every time tick() causes stacks to decay

/datum/status_effect/stacking/proc/on_threshold_cross()
	threshold_cross_effect()
	if(consumed_on_threshold)
		stacks_consumed_effect()
		qdel(src)

/datum/status_effect/stacking/proc/on_threshold_drop()

/datum/status_effect/stacking/proc/can_have_status()
	return owner.stat != DEAD

/datum/status_effect/stacking/proc/can_gain_stacks()
	return owner.stat != DEAD

/datum/status_effect/stacking/tick()
	if(!can_have_status())
		qdel(src)
	else
		add_stacks(-stack_decay)
		stack_decay_effect()

/datum/status_effect/stacking/proc/add_stacks(stacks_added)
	if(stacks_added > 0 && !can_gain_stacks())
		return FALSE
	owner.cut_overlay(status_overlay)
	owner.underlays -= status_underlay
	stacks += stacks_added
	if(stacks > 0)
		if(stacks >= stack_threshold && !threshold_crossed) //threshold_crossed check prevents threshold effect from occuring if changing from above threshold to still above threshold
			threshold_crossed = TRUE
			on_threshold_cross()
			if(consumed_on_threshold)
				return
		else if(stacks < stack_threshold && threshold_crossed)
			threshold_crossed = FALSE //resets threshold effect if we fall below threshold so threshold effect can trigger again
			on_threshold_drop()
		if(stacks_added > 0)
			tick_interval += delay_before_decay //refreshes time until decay
		stacks = min(stacks, max_stacks)
		status_overlay.icon_state = "[overlay_state][stacks]"
		status_underlay.icon_state = "[underlay_state][stacks]"
		owner.add_overlay(status_overlay)
		owner.underlays += status_underlay
	else
		fadeout_effect()
		qdel(src) //deletes status if stacks fall under one

/datum/status_effect/stacking/on_creation(mob/living/new_owner, stacks_to_apply)
	. = ..()
	if(.)
		add_stacks(stacks_to_apply)

/datum/status_effect/stacking/on_apply()
	if(!can_have_status())
		return FALSE
	status_overlay = mutable_appearance(overlay_file, "[overlay_state][stacks]")
	status_underlay = mutable_appearance(underlay_file, "[underlay_state][stacks]")
	var/icon/I = icon(owner.icon, owner.icon_state, owner.dir)
	var/icon_height = I.Height()
	status_overlay.pixel_x = -owner.pixel_x
	status_overlay.pixel_y = FLOOR(icon_height * 0.25, 1)
	status_overlay.transform = matrix() * (icon_height/world.icon_size) //scale the status's overlay size based on the target's icon size
	status_underlay.pixel_x = -owner.pixel_x
	status_underlay.transform = matrix() * (icon_height/world.icon_size) * 3
	status_underlay.alpha = 40
	owner.add_overlay(status_overlay)
	owner.underlays += status_underlay
	return ..()

/datum/status_effect/stacking/Destroy()
	if(owner)
		owner.cut_overlay(status_overlay)
		owner.underlays -= status_underlay
	QDEL_NULL(status_overlay)
	return ..()

/// Status effect from multiple sources, when all sources are removed, so is the effect
/datum/status_effect/grouped
	status_type = STATUS_EFFECT_MULTIPLE //! Adds itself to sources and destroys itself if one exists already, there are never multiple
	var/list/sources = list()

/datum/status_effect/grouped/on_creation(mob/living/new_owner, source)
	var/datum/status_effect/grouped/existing = new_owner.has_status_effect(type)
	if(existing)
		existing.sources |= source
		qdel(src)
		return FALSE
	else
		sources |= source
		return ..()

/datum/status_effect/grouped/before_remove(source)
	sources -= source
	return !length(sources)
