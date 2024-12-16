/datum/action/cooldown/fishing
	name = "Sacred Word"
	button_icon_state = "sacredword"
	icon_icon = 'icons/hud/screen_fishing.dmi'
	cooldown_time = 30 SECONDS
	var/devotion_cost = 0

/datum/action/cooldown/fishing/Trigger()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/human/H = owner
	var/required_devotion = devotion_cost

	if(H.god_aligned == FISHGOD_SATURN)
		required_devotion--	//Get one less cost on these spells

	if(H.devotion < required_devotion)
		to_chat(H, span_warning("You do not have enough devotion for this spell!"))
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	H.devotion -= required_devotion
	to_chat(H, span_notice("You expend [required_devotion] devotion. Remaining Devotion: [H.devotion]."))
	StartCooldown()
	FishEffect(H)

/datum/action/cooldown/fishing/proc/FishEffect(mob/living/user)
	to_chat(owner,"Remaining Devotion: [user.devotion].")
