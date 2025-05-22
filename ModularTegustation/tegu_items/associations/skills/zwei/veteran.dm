#define STATUS_EFFECT_FIRSTSTAND /datum/status_effect/first_stand //Yes this is a status effect used solely to check your HP to apply another status effect
#define STATUS_EFFECT_LASTSTAND	/datum/status_effect/last_stand //You shouldnt be walking go die already
/datum/action/cooldown/protectinnocent
	name = "Protect the Innocent"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "warbanner"
	cooldown_time = 45 SECONDS
	var/list/affected = list()
	var/range = 4
	var/affect_self = FALSE

/datum/action/cooldown/protectinnocent/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	owner.say("I'll protect you with all my strength!")
	get_user_level(owner)
	for(var/mob/living/carbon/human/human in view(range, get_turf(src)))
		if (human.stat == DEAD)
			continue
		if (human == owner && !affect_self)
			continue
		if (get_user_level(owner) > get_user_level(human))
			human.physiology.red_mod *= 0.5
			human.physiology.white_mod *= 0.5
			human.physiology.black_mod *= 0.5
			human.physiology.pale_mod *= 0.5
			affected+= human

	addtimer(CALLBACK(src, PROC_REF(Recall)), 15 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	addtimer(CALLBACK(src, PROC_REF(Thanks)), 0.5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	StartCooldown()

/datum/action/cooldown/protectinnocent/proc/Recall()
	for(var/mob/living/carbon/human/human in affected)
		human.physiology.red_mod /= 0.5
		human.physiology.white_mod /= 0.5
		human.physiology.black_mod /= 0.5
		human.physiology.pale_mod /= 0.5
		affected-=human

/datum/action/cooldown/protectinnocent/proc/Thanks()//Its free protection why wouldnt you thank the man
	for(var/mob/living/carbon/human/human in affected)
		if(human == owner)
			continue
		human.say("Thank you.")

/datum/action/cooldown/laststand
	name = "Last Stand"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "reraise"
	cooldown_time = 30 MINUTES

/datum/action/cooldown/laststand/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		if(human.has_status_effect(STATUS_EFFECT_LASTSTAND))
			to_chat(owner, span_notice("You're on your last legs already."))
			return
		..()
		to_chat(human, span_notice("You prepare yourself for a last stand."))
		human.apply_status_effect(STATUS_EFFECT_FIRSTSTAND)

	StartCooldown()

/datum/status_effect/first_stand
	id = "first_stand"
	alert_type = /atom/movable/screen/alert/status_effect/firststand

/atom/movable/screen/alert/status_effect/firststand
	name = "First Stand"
	desc = "You prepare to fight to your last breath."
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	icon_state = "Zwei"

/datum/status_effect/first_stand/tick() //if you die, you revive
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(H.sanity_lost || H.stat == DEAD) //checks if youre going down
		LastStand(owner)

/datum/status_effect/first_stand/proc/LastStand(mob/living/carbon/human/H)
	if(H.revive(full_heal = TRUE, admin_revive = TRUE))
		H.grab_ghost(force = TRUE)
	to_chat(H, span_notice("You are their unyielding shield, you can't afford to stand down."))
	H.apply_status_effect(STATUS_EFFECT_LASTSTAND)
	H.remove_status_effect(src)

/datum/status_effect/last_stand
	id = "last_stand"
	alert_type = /atom/movable/screen/alert/status_effect/dyinghurts
	var/damage = 10

/atom/movable/screen/alert/status_effect/dyinghurts
	name = "Last Stand"
	desc = "You prepare for the inevitable."
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	icon_state = "Zwei"

/datum/status_effect/last_stand/tick()
	. = ..()
	owner.adjustBruteLoss(damage)
	if (owner.stat == DEAD)
		owner.remove_status_effect(src)

#undef STATUS_EFFECT_FIRSTSTAND
#undef STATUS_EFFECT_LASTSTAND
