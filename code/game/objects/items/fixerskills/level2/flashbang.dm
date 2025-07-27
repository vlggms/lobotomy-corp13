//Solar Flare
/obj/item/book/granter/action/skill/solarflare
	granted_action = /datum/action/cooldown/solarflare
	actionname = "Solar Flare"
	name = "Level 2 Skill: Solar Flare"
	level = 2
	custom_premium_price = 1200

/datum/action/cooldown/solarflare
	name = "Solar Flare"
	desc = "Blinds all humans on the screen, making it harder for them to attack you."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "solarflare"
	cooldown_time = 50 SECONDS

/datum/action/cooldown/solarflare/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	//Bang people around you
	for(var/mob/living/M in view(7, get_turf(src)))
		if(M.stat != DEAD && M!=owner)
			to_chat(M, span_userdanger("[owner] emits a blinding white light!"))
			M.adjust_blindness(5)
	StartCooldown()

