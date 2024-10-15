/datum/action/cooldown/fishing
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "sacredword"
	name = "Sacred Word"
	cooldown_time = 300
	var/devotion_cost = 0

/datum/action/cooldown/fishing/Trigger()
	if(!..())
		return FALSE

	var/mob/living/carbon/human/H = owner
	if(H.devotion <devotion_cost)
		to_chat(H,"You do not have enough devotion for this spell!")
		return FALSE

	if (owner.stat == DEAD)
		return FALSE
	to_chat(H,"You expend [devotion_cost] devotion. Remaining Devotion: [H.devotion].")
	H.devotion-=devotion_cost
	StartCooldown()
	FishEffect(H)

/datum/action/cooldown/fishing/proc/FishEffect(mob/living/user)
	to_chat(owner,"Remaining Devotion: [user.devotion].")
