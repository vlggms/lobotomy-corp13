// LC13 SKILLS / ACTIONS

/obj/item/book/granter/action/skill
	granted_action = null
	actionname = null
	var/level_min = 0
	var/level_max = 0

/obj/item/book/granter/action/skill/dash
	granted_action = /datum/action/cooldown/dash
	actionname = "Dash"
	level_min = 10
	level_max = 40

/obj/item/book/granter/action/skill/dashback
	granted_action = /datum/action/cooldown/dash/back
	actionname = "Dash back"
	level_min = 10
	level_max = 40

/datum/action/cooldown/dash
	cooldown_time = 30
	var/direction = 1

/datum/action/cooldown/dash/Trigger()
	if(!..())
		return FALSE

	var/dodgelanding
	if(owner.dir == 1)
		dodgelanding = locate(owner.x, owner.y + 5 * direction, owner.z)
	if(owner.dir == 2)
		dodgelanding = locate(owner.x, owner.y - 5 * direction, owner.z)
	if(owner.dir == 4)
		dodgelanding = locate(owner.x + 5 * direction, owner.y, owner.z)
	if(owner.dir == 8)
		dodgelanding = locate(owner.x - 5 * direction, owner.y, owner.z)
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		if (!human.IsParalyzed())
			human.adjustStaminaLoss(20, TRUE, TRUE)
			human.throw_at(dodgelanding, 3, 2, spin = TRUE)
			StartCooldown()
			return TRUE

/datum/action/cooldown/dash/back
	direction = -1

/obj/item/book/granter/action/skill/shockwave
	granted_action = /datum/action/cooldown/shockwave
	actionname = "Shockwave"
	level_min = 10
	level_max = 40

/datum/action/cooldown/shockwave
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

/obj/item/book/granter/action/skill/timestop
	granted_action = /datum/action/cooldown/timestop
	actionname = "Timestop"
	level_min = 10
	level_max = 40

/datum/action/cooldown/timestop
	cooldown_time = 100
	var/timestop_range = 2
	var/timestop_duration = 100

/datum/action/cooldown/timestop/Trigger()
	. = ..()
	if(!.)
		return FALSE
	new /obj/effect/timestop(get_turf(owner), timestop_range, timestop_duration, list(owner))
	StartCooldown()

/obj/item/book/granter/action/skill/assault
	granted_action = /datum/action/cooldown/assault
	actionname = "Assault"
	level_min = 10
	level_max = 40

/datum/action/cooldown/assault
	cooldown_time = 30

/datum/action/cooldown/assault/Trigger()
	. = ..()
	if(!.)
		return FALSE
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		human.add_movespeed_modifier(/datum/movespeed_modifier/assault)
		addtimer(CALLBACK(human, .mob/proc/remove_movespeed_modifier, /datum/movespeed_modifier/assault), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		StartCooldown()

/datum/movespeed_modifier/assault
	variable = TRUE
	multiplicative_slowdown = -0.1
