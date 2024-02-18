//All the goober rifles used by Rcorp Assault troops

/obj/item/gun/energy/e_gun/rabbitdash
	name = "R-Corporation R-2000 'Red Rifle'"
	desc = "An energy gun mass-produced by R corporation for the bulk of their force."
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	icon_state = "rabbitk"
	inhand_icon_state = "rabbit"
	fire_delay = 5
	cell_type = /obj/item/stock_parts/cell/infinite
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/red,
	)
	can_charge = FALSE
	weapon_weight = WEAPON_HEAVY // No dual wielding
	pin = /obj/item/firing_pin
	//None of these fucking guys can use Rcorp guns
	var/list/banned_roles = list("Reindeer Squad Captain",
		"R-Corp Berserker Reindeer","R-Corp Medical Reindeer","R-Corp Gunner Rhino","R-Corp Hammer Rhino","R-Corp Scout Raven","R-Corp Support Raven",,
		"R-Corp Roadrunner", "Roadrunner Squad Leader")

/obj/item/gun/energy/e_gun/rabbitdash/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	if(user.mind)
		if(user.mind.assigned_role in banned_roles)
			to_chat(user, span_notice("You are not trained to use Rcorp firearms!"))
			return FALSE
	..()

/obj/item/gun/energy/e_gun/rabbitdash/white
	name = "R-Corporation R-2100 'White Rifle'"
	desc = "An energy gun mass-produced by R corporation for the bulk of their force. This slightly updated model can fire only white bullets."
	icon_state = "rabbitk"
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/white,
		)

/obj/item/gun/energy/e_gun/rabbitdash/small
	name = "R-Corporation R-2200 'Little Iron'"
	desc = "An energy pistol sometimes used by Rcorp. Fires slower, and deals slightly less damage"
	icon_state = "rabbitsmall"
	fire_delay = 7
	projectile_damage_multiplier = 0.9
	weapon_weight = WEAPON_LIGHT

/obj/item/gun/energy/e_gun/rabbitdash/shotgun
	name = "R-Corporation R-2300 'Chungid'"
	desc = "An energy gun mass-produced by R corporation for the bulk of their force. This slightly updated model can fire a shogun spread."
	icon_state = "rabbitshotgun"
	fire_delay = 10
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/red/shotgun,
		)

/obj/item/gun/energy/e_gun/rabbitdash/black
	name = "R-Corporation R-2400 'Black Rifle'"
	desc = "An energy gun mass-produced by R corporation for the bulk of their force. This slightly updated model can fire only black bullets."
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/black,
		)

//the 2800 is an autorifle, and is found in /rcorp
/obj/item/gun/energy/e_gun/rabbitdash/pale
	name = "R-Corporation R-2900 'The Solution'"
	desc = "An energy gun mass-produced by R corporation for the bulk of their force. This slightly updated model can fire only pale bullets."
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/pale,
		)


/obj/item/gun/energy/e_gun/rabbitdash/heavy
	name = "R-Corporation X-9 Heavy Rifle"
	desc = "An energy gun mass-produced by R corporation for the bulk of their force. This slightly updated model can fire heavy bullets, albeit very slowly. \
			Slows you down as you walk"
	icon_state = "rabbitheavy"
	fire_delay = 12
	item_flags = SLOWS_WHILE_IN_HAND
	drag_slowdown = 2
	slowdown = 0.7
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/red/heavy,
		)

/obj/item/gun/energy/e_gun/rabbitdash/sniper
	name = "R-Corporation X-12 Marksman"
	desc = "An energy rifle sometimes used by Rcorp. Fires slower, and deals slightly more damage. Has a scope."
	fire_delay = 8
	projectile_damage_multiplier = 1.2
	zoom_amt = 5 //Long range, Slightly better range
	zoomable = TRUE
	zoom_out_amt = 0

/obj/item/gun/energy/e_gun/rabbitdash/laser
	name = "R-Corporation X-13 Beam Rifle"
	desc = "An energy gun mass-produced by R corporation for the bulk of their force. This slightly updated model can fire a beam projectile."
	icon_state = "rabbitlaser"
	fire_delay = 10
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/red/beam,
		)
