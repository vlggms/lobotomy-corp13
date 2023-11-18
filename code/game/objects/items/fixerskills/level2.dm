/obj/item/book/granter/action/skill/shockwave
	granted_action = /datum/action/cooldown/shockwave
	actionname = "Shockwave"
	name = "Shockwave"
	level = 2

/datum/action/cooldown/shockwave
	icon_icon = 'icons/hud/screen_skills.dmi'
	name = "Shockwave"
	button_icon_state = "shockwave"
	cooldown_time = 150
	var/range = 7
	var/stun_amt = 40
	var/maxthrow = 5
	var/repulse_force = MOVE_FORCE_EXTREMELY_STRONG

/datum/action/cooldown/shockwave/Trigger()
	. = ..()
	if(!.)
		return FALSE

	var/list/thrownatoms = list()
	var/atom/throwtarget
	var/distfromcaster
	//playMagSound()
	var/list/targets = list()
	var/user = owner

	for(var/turf/target in view(range, user))
		targets += target

	for(var/turf/T in targets) //Done this way so things don't get thrown all around hilariously.
		for(var/atom/movable/AM in T)
			thrownatoms += AM

	for(var/am in thrownatoms)
		var/atom/movable/AM = am
		if(AM == user || AM.anchored)
			continue

		throwtarget = get_edge_target_turf(user, get_dir(user, get_step_away(AM, user)))
		distfromcaster = get_dist(user, AM)
		if(distfromcaster == 0)
			if(isliving(AM))
				var/mob/living/M = AM
				M.Paralyze(stun_amt * 2)
				M.adjustRedLoss(15)
				to_chat(M, "<span class='userdanger'>You're slammed into the floor by [user]!</span>")
		else
			new /obj/effect/temp_visual/gravpush(get_turf(AM), get_dir(user, AM)) //created sparkles will disappear on their own
			if(isliving(AM))
				var/mob/living/M = AM
				M.Paralyze(stun_amt)
				to_chat(M, "<span class='userdanger'>You're thrown back by [user]!</span>")
			AM.safe_throw_at(throwtarget, ((clamp((maxthrow - (clamp(distfromcaster - 2, 0, distfromcaster))), 3, maxthrow))), 1,user, force = repulse_force)//So stuff gets tossed around at the same time.
	StartCooldown()
