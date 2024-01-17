//Confusion
/obj/item/book/granter/action/skill/confusion
	granted_action = /datum/action/cooldown/confusion
	actionname = "Confusion"
	name = "Level 2 Skill: Confusion"
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/confusion
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "confusion"
	name = "Confusion"
	cooldown_time = 500

/datum/action/cooldown/confusion/Trigger()
	if(!..())
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	//Bang people around you
	for(var/mob/living/carbon/M in view(7, get_turf(src)))
		if(M.stat != DEAD && M!=owner)
			to_chat(M, "<span class='userdanger'>[owner] emits a horrible noise!</span>")
			M.set_confusion(10)
			M.dizziness += 10
			M.adjust_blurriness(15)
			M.silent = 12
	StartCooldown()

