/datum/action/cooldown/autoloader
	name = "Autoloader"
	desc = "Reload all guns on the user. Costs 10 SP"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "autoload"
	cooldown_time = 30 SECONDS


/datum/action/cooldown/autoloader/Trigger()
	. = ..()
	if (owner.stat == DEAD)
		return FALSE

	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjustSanityLoss(10)
		playsound(H, 'sound/weapons/gun/general/bolt_rack.ogg', 50, TRUE)
		for(var/obj/item/ego_weapon/ranged/Gun in H.contents)
			Gun.shotsleft = initial(Gun.shotsleft)
	StartCooldown()
