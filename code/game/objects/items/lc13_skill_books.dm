// LC13 SKILLS / ACTIONS

/obj/item/book/granter/action/skill
	granted_action = null
	actionname = null
	var/level = 0
	var/mob/living/carbon/human/user

/obj/item/book/granter/action/skill/on_reading_finished(mob/user)
	if (ishuman(user))
		var/mob/living/carbon/human/human = user
		var/user_level = get_user_level(human)
		if (level != user_level && level != -1)
			to_chat(user, "<span class='notice'>Your level is [user_level]. This book need level [level]!</span>")
			return FALSE
		..()

/obj/item/book/granter/action/skill/dash
	granted_action = /datum/action/cooldown/dash
	actionname = "Dash"
	name = "Dash"
	level = 2

/obj/item/book/granter/action/skill/dashback
	granted_action = /datum/action/cooldown/dash/back
	actionname = "Dash back"
	name = "Dash back"
	level = 2

/datum/action/cooldown/dash
	name = "Dash back"
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
	name = "Shockwave"
	level = 3

/datum/action/cooldown/shockwave
	name = "Shockwave"
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
	name = "Timestop"
	level = 5

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
	level = -1

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

/obj/item/book/granter/action/skill/nightvision
	granted_action = /datum/action/innate/nightvision
	actionname = "Nightvision"
	name = "Nightvision"
	level = 4

/datum/action/innate/nightvision
	name = "Nightvision"

/datum/action/innate/nightvision/Activate()
	to_chat(owner, "<span class='notice'>You will now see in the dark.</span>")
	button_icon_state = "origami_on"
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		var/obj/item/organ/eyes/E = human.getorganslot(ORGAN_SLOT_EYES)
		if(E)
			E.see_in_dark = 8
		human.update_sight()

	active = TRUE
	UpdateButtonIcon()

/datum/action/innate/nightvision/Deactivate()
	to_chat(owner, "<span class='notice'>You will no longer see in the dark.</span>")
	button_icon_state = "origami_off"
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		var/obj/item/organ/eyes/E = human.getorganslot(ORGAN_SLOT_EYES)
		if(E)
			E.see_in_dark = 2
		human.update_sight()

	active = FALSE
	UpdateButtonIcon()


/obj/item/book/granter/action/skill/bulletproof
	granted_action = /datum/action/innate/bulletproof
	actionname = "Bulletproof"
	name = "Bulletproof"
	level = 4

/datum/action/innate/bulletproof
	name = "Bulletproof"
	var/datum/martial_art/bulletproof/MA = new /datum/martial_art/bulletproof

/datum/action/innate/bulletproof/Activate()
	to_chat(owner, "<span class='notice'>You will now block bullets.</span>")
	button_icon_state = "origami_on"
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		MA.teach(human, TRUE)
	active = TRUE
	UpdateButtonIcon()

/datum/action/innate/bulletproof/Deactivate()
	to_chat(owner, "<span class='notice'>You will no longer block bullets.</span>")
	button_icon_state = "origami_off"
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		MA.remove(human)
	active = FALSE
	UpdateButtonIcon()



/datum/martial_art/bulletproof

/datum/martial_art/bulletproof/on_projectile_hit(mob/living/A, obj/projectile/P, def_zone)
	to_chat(A, "<span class='notice'>You blocked a bullet.</span>")
	return BULLET_ACT_BLOCK
