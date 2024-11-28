//Guns that gotta be reloaded.
/obj/item/ego_weapon/ranged/city/fullstop
	name = "fullstop template"
	desc = "a template for fullstop."
	icon_state = "fullstop"
	inhand_icon_state = "fullstop"
	force = 14
	projectile_path = /obj/projectile/ego_bullet/tendamage	//Does 10 damage
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'
	special = "Use in hand to reload"
	shotsleft = 10
	reloadtime = 2 SECONDS

//The actual weapons
/obj/item/ego_weapon/ranged/city/fullstop/assault
	name = "fullstop assault gun"
	desc = "A heavy rifle. Guns like these are expensive in the City. You could buy a whole other weapon of good quality with the money for this one's bullets."
	icon_state = "fullstop"
	inhand_icon_state = "fullstop"
	force = 20
	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'
	shotsleft = 30
	autofire = 0.12 SECONDS
	spread = 10
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/ranged/city/fullstop/pistol
	name = "fullstop pistol"
	desc = "A fullstop pistol. Looks familiar."
	icon_state = "fullstoppistol"
	inhand_icon_state = "fullstopsniper"
	force = 12
	attack_speed = 0.5
	shotsleft = 17
	fire_delay = 5
	reloadtime = 1.3 SECONDS
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/ranged/city/fullstop/sniper
	name = "fullstop sniper"
	desc = "A sniper rifle. Despite the cost and heavy regulations, you could still kill someone stealthily from a good distance with this."
	icon_state = "fullstopsniper"
	inhand_icon_state = "fullstopsniper"
	force = 20
	fire_sound = 'sound/weapons/gun/sniper/shot.ogg'
	zoom_amt = 10 //Long range, enough to see in front of you, but no tiles behind you.
	zoomable = TRUE
	zoom_out_amt = 5
	projectile_damage_multiplier = 4
	shotsleft = 5
	fire_delay = 30
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/ranged/city/fullstop/deagle
	name = "fullstop magnum"
	desc = "An expensive pistol. Keep your hands steady. It's not over yet."
	icon_state = "fullstopdeagle"
	inhand_icon_state = "fullstopdeagle"
	force = 17
	attack_speed = 0.5
	weapon_weight = WEAPON_LIGHT
	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'
	projectile_damage_multiplier = 4
	shotsleft = 9
	reloadtime = 1 SECONDS
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
