// Overwrites sec_hud_set_ID to make tegu jobs get their HUD icons.

/mob/living/carbon/human/sec_hud_set_ID()
	var/image/holder = hud_list[ID_HUD]
	var/icon/I = icon(icon, icon_state, dir)
	holder.pixel_y = I.Height() - world.icon_size
	holder.icon_state = "hudno_id"
	holder.icon =  'icons/mob/hud.dmi'
	if(wear_id?.GetID())
		var/obj/item/card/id/our_id = wear_id.GetID()
		holder.icon = our_id.return_icon_hud()
		holder.icon_state = "hud[ckey(wear_id.GetJobName())]"
	sec_hud_set_security_status()
