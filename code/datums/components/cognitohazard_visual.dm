/datum/component/cognitohazard_visual
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/last_blink = 0
	var/check_every = 20 SECONDS
	/// The name of the cognitohazard_visual the player is applying to the parent.
	var/datum/status_effect/cognitohazard_visual_effect

/datum/component/cognitohazard_visual/Initialize(_cognitohazard_visual_effect, obvious = FALSE)
	if(!isatom(parent) || !_cognitohazard_visual_effect)
		return COMPONENT_INCOMPATIBLE

	cognitohazard_visual_effect = _cognitohazard_visual_effect

	if(obvious)
		START_PROCESSING(SSdcs, src)

/datum/component/cognitohazard_visual/RegisterWithParent()
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(Examine))

/**
	This proc will trigger when someone examines the parent.
	It will attach the text found in the body of the proc to the `examine_list` and display it to the player examining the parent.

	Arguments:
	* source: The parent.
	* user: The mob exmaining the parent.
	* examine_list: The current list of text getting passed from the parent's normal examine() proc.
*/
/datum/component/cognitohazard_visual/proc/Examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	if(user)
		var/mob/living/L = user
		L.apply_status_effect(cognitohazard_visual_effect)

/datum/component/cognitohazard_visual/process()
	if(world.time > (last_blink + check_every))
		for(var/mob/living/L in oviewers(4, get_turf(parent)))
			if(!L.client)
				continue
			if(L.stat != CONSCIOUS)
				continue
			if(L.has_status_effect(cognitohazard_visual_effect))
				continue
			L.apply_status_effect(cognitohazard_visual_effect)
			to_chat(L, span_smallnotice("Your eye catches some weird detail about [parent]."))
