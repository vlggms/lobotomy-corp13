//Dismember
/obj/item/book/granter/action/skill/dismember
	granted_action = /datum/action/cooldown/dismember
	actionname = "Dismember"
	name = "Level 4 Skill: Dismember"
	level = 4
	custom_premium_price = 2400

/datum/action/cooldown/dismember
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "dismember"
	name = "Dismember"
	cooldown_time = 6000

/datum/action/cooldown/dismember/Trigger()
	if(!..())
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	//Compile people around you
	for(var/mob/living/carbon/human/M in view(1, get_turf(src)))
		if(M == owner)
			continue

		//Lop off a random arm
		if(HAS_TRAIT(M, TRAIT_NODISMEMBER))
			return
		var/obj/item/bodypart/arm = pick(M.get_bodypart(BODY_ZONE_R_ARM), M.get_bodypart(BODY_ZONE_L_ARM))

		var/did_the_thing = (arm?.dismember()) //not all limbs can be removed, so important to check that we did. the. thing.
		if(!did_the_thing)
			return

	StartCooldown()

