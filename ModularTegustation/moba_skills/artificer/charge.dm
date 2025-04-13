//Curing
/datum/action/cooldown/charge
	name = "Charge"
	desc = "Charge all powered gadgets on your person to full. Costs 10SP"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "charge"
	cooldown_time = 30 SECONDS

/datum/action/cooldown/charge/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(owner.stat == DEAD)
		return FALSE

	if (!ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/H = owner
	H.adjustSanityLoss(10)
	for(var/obj/item/powered_gadget/G in owner.contents)
		if(!G.cell)
			return
		G.cell.charge = G.cell.maxcharge
 	to_chat(owner, span_notice("You charge all the cells in your gadgets."))
	StartCooldown()

