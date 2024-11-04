/datum/action/cooldown/fishing
	icon_icon = 'icons/hud/screen_fishing.dmi'
	button_icon_state = "sacredword"
	name = "Sacred Word"
	cooldown_time = 300
	var/devotion_cost = 0

/datum/action/cooldown/fishing/Trigger()
	if(!..())
		return FALSE

	var/mob/living/carbon/human/H = owner
	var/spend_devotion = devotion_cost

	if(H.god_aligned == FISHGOD_SATURN)
		spend_devotion-=1	//Get one less cost on these spells

	if(H.devotion <spend_devotion)
		to_chat(H,span_warning("You do not have enough devotion for this spell!"))
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	H.devotion-=spend_devotion
	to_chat(H,span_notice("You expend [spend_devotion] devotion. Remaining Devotion: [H.devotion]."))
	StartCooldown()
	FishEffect(H)

/datum/action/cooldown/fishing/proc/FishEffect(mob/living/user)
	to_chat(owner,"Remaining Devotion: [user.devotion].")
