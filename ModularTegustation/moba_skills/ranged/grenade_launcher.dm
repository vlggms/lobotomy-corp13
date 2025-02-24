/obj/effect/proc_holder/ability/aimed/grenade_launcher
	name = "Grenade Launcher"
	desc = "Use a gun in hand to fire a grenade. Damage type and amount is based off the gun's damage and type. Costs 10 SP"
	action_icon_state = "cross_spawn0"
	base_icon_state = "cross_spawn"
	cooldown_time = 20 SECONDS

/obj/effect/proc_holder/ability/aimed/grenade_launcher/Perform(target, mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/shooter = user
		H.adjustSanityLoss(10)

	var/list/gunsinhand = list()
	for(var/obj/item/ego_weapon/ranged/Gun in shooter.held_items)
		gunsinhand+=Gun
	if(!length(gunsinhand))
		return ..()

	var/obj/item/ego_weapon/ranged/chosengun = pick(gunsinhand)
	var/grenadedamage = chosengun.last_projectile_type

	var/obj/item/grenade/r_corp/F = new /obj/item/grenade/r_corp/lcorp
	F.explosion_damage_type = grenadedamage
	F.explosion_damage = chosengun.last_projectile_damage*3
	F.forceMove(user.loc)
	F.throw_at(target, 30, 2, user)

//This is only used by the grenade launcher ability
/obj/item/grenade/r_corp/lcorp
	name = "l-corp grenade"
	desc = "An anti-abnormality grenade. It deals 90% less damage to humans."
