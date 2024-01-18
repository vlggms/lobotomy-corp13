//Butcher
/obj/item/book/granter/action/skill/butcher
	granted_action = /datum/action/cooldown/butcher
	actionname = "Butcher"
	name = "Level 2 Skill: Butcher"
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/butcher
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "butcher"
	name = "Butcher"
	cooldown_time = 100

/datum/action/cooldown/butcher/Trigger()
	if(!..())
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	//Compile people around you
	for(var/mob/living/M in view(2, get_turf(src)))
		if(M.stat == DEAD && !ishuman(M))
			M.gib()
	StartCooldown()

