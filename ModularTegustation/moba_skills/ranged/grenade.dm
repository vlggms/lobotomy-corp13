
/datum/action/cooldown/grenade
	name = "Grenade Spawn"
	desc = "Create a grenade that blows up after 15 seconds. Costs 10SP"
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "smokedash"
	cooldown_time = 20 SECONDS

/datum/action/cooldown/grenade/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if (owner.stat == DEAD)
		return FALSE

	if(!ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/user = owner
	user.adjustSanityLoss(10)

	var/obj/item/grenade/r_corp/lcorp/F = new(get_turf(user))
	F.explosion_damage_type = pick(RED_DAMAGE, BLACK_DAMAGE, WHITE_DAMAGE)
	F.explosion_damage = get_attribute_level(user, JUSTICE_ATTRIBUTE)*2
	user.equip_in_one_of_slots(F, ITEM_SLOT_HANDS , qdel_on_fail = TRUE)
	StartCooldown()

//This is only used by the grenade launcher ability
/obj/item/grenade/r_corp/lcorp
	name = "l-corp grenade"
	desc = "An anti-abnormality grenade. It deals 90% less damage to humans."
