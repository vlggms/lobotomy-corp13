//All the goober rifles used by Rcorp Assault troops

/obj/item/gun/energy/e_gun/rabbitdash
	name = "R-Corporation R-2000 'Red Rifle'"
	desc = "An energy gun mass-produced by R corporation for the bulk of their force."
	icon = 'ModularTegustation/Teguicons/rcorp_weapons.dmi'
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
		if(user.mind.has_antag_datum(/datum/antagonist/wizard/arbiter/rcorp))
			to_chat(user, span_notice("You wouldn't stoop so low as to use the weapons of those below you.")) //You are a arbiter not a super crazed gunman
			return FALSE
	..()

/obj/item/gun/energy/e_gun/rabbitdash/white
	name = "R-Corporation R-2100 'White Rifle'"
	desc = "An energy gun mass-produced by R corporation for the bulk of their force. This slightly updated model can fire only white bullets."
	icon_state = "rabbitk"
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/white,
		)

//Pistols
/obj/item/gun/energy/e_gun/rabbitdash/small
	name = "R-Corporation R-2020 'Little Iron'"
	desc = "An energy pistol sometimes used by Rcorp. Fires slower, and deals slightly less damage. Only in red."
	icon_state = "rabbitsmall"
	fire_delay = 7
	projectile_damage_multiplier = 0.9
	weapon_weight = WEAPON_LIGHT

/obj/item/gun/energy/e_gun/rabbitdash/small/white
	name = "R-Corporation R-2120 'Disco Panic'"
	desc = "An energy pistol sometimes used by Rcorp. Fires slower, and deals slightly less damage. Only in white. \
		Called the 'Disco Panic' by R-corp due to the unfortunately high rate of friendly fire from rabbits firing this gun akimbo."
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/white,
		)

/obj/item/gun/energy/e_gun/rabbitdash/small/black
	name = "R-Corporation R-2420 'Night Operator'"
	desc = "An energy pistol sometimes used by Rcorp. Fires slower, and deals slightly less damage. Only in black. \
		Favored for night work, due to Rabbits believing that it's harder to see in the dark. Unfortunately, this is not true."
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/black,
		)

/obj/item/gun/energy/e_gun/rabbitdash/small/pale
	name = "R-Corporation R-2920 'Wakeup Call'"
	desc = "An energy pistol sometimes used by Rcorp. Fires slower, and deals slightly less damage. Only in pale. \
		Nicknamed the 'Wakeup Call' by RnD due to this being the last gun produced before the R-3000 series of guns "
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/pale,
		)

/obj/item/gun/energy/e_gun/rabbitdash/small/tiny
	name = "R-Corporation R-2025 'Fucker Gun'"
	desc = "An energy pistol sometimes used by Rcorp. Only in red, and only found in the hands of people who use it as an emergency self-defense weapon. \
			It got it's nickname due to every single person who has ever fired it wishing they had something else."
	icon_state = "rabbittiny"
	fire_delay = 5
	projectile_damage_multiplier = 0.5

/obj/item/gun/energy/e_gun/rabbitdash/small/tinypale
	name = "R-Corporation X-29 'Mistake'"
	desc = "An energy pistol sometimes used by Rcorp. Only in pale, and was an experimental pistol found in the desk drawer of an assistant manager. \
			To test it's efficacy, The X-29's first round ever fired was a failure, as the user broke their own wrist."
	icon_state = "rabbittiny"
	fire_delay = 7
	recoil = 4
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/pale,
		)

//SMGs
/obj/item/gun/energy/e_gun/rabbitdash/small/smg
	name = "R-Corporation R-2540 'Hellspit'"
	desc = "An energy SMG created by Rcorp. A micro Mark 1, and deals slightly less damage. Only in red. \
		Was created when a need for fully automatic rifle came up among R-Corp staff."
	icon_state = "rabbitsmall"
	projectile_damage_multiplier = 0.8
	weapon_weight = WEAPON_MEDIUM

/obj/item/gun/energy/e_gun/rabbitdash/small/smg/Initialize()
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.16 SECONDS)


/obj/item/gun/energy/e_gun/rabbitdash/small/smg/white
	name = "R-Corporation R-2550 'Skid'"
	desc = "An energy pistol sometimes used by Rcorp. Fires slower, and deals slightly less damage. Only in white."
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/white,
		)

/obj/item/gun/energy/e_gun/rabbitdash/small/smg/black
	name = "R-Corporation R-2560 'Dreamland'"
	desc = "An energy pistol sometimes used by Rcorp. Fires slower, and deals slightly less damage. Only in black."
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/black,
		)

/obj/item/gun/energy/e_gun/rabbitdash/small/smg/pale
	name = "R-Corporation R-2950 'Icemilk Magic'"
	desc = "An energy pistol sometimes used by Rcorp. Fires slower, and deals slightly less damage. Only in pale."
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/pale,
		)




/obj/item/gun/energy/e_gun/rabbitdash/shotgun
	name = "R-Corporation R-2300 'Chungid'"
	desc = "An energy gun mass-produced by R corporation for the bulk of their force. This slightly updated model can fire a shogun spread of red damage."
	icon_state = "rabbitshotgun"
	fire_delay = 10
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/red/shotgun,
		)

/obj/item/gun/energy/e_gun/rabbitdash/shotgun/white
	name = "R-Corporation R-2330 'Fatty'"
	desc = "An energy gun mass-produced by R corporation for the bulk of their force. This slightly updated model can fire a shogun spread of white damage."
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/white/shotgun,
		)

/obj/item/gun/energy/e_gun/rabbitdash/shotgun/black
	name = "R-Corporation R-2430 'Moz'"
	desc = "An energy gun mass-produced by R corporation for the bulk of their force. This slightly updated model can fire a shogun spread of black damage."
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/black/shotgun,
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
	projectile_damage_multiplier = 0.7
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/red/heavy,
		)

/obj/item/gun/energy/e_gun/rabbitdash/sniper
	name = "R-Corporation X-12 Marksman"
	desc = "An energy rifle sometimes used by Rcorp. Fires slower, and deals slightly more damage. Has a scope."
	icon_state = "rabbitsniper"
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

/obj/item/gun/energy/e_gun/rabbitdash/heavysniper
	name = "R-Corporation X-21 Sniper"
	desc = "A heavy energy rifle used by Rcorp sniper units. Fires slower, and deals significantly more damage. Has a scope and IFF capabilities."
	icon_state = "rabbitheavysniper"
	fire_delay = 15
	zoomable = TRUE
	zoom_amt = 10 //Long range, enough to see in front of you, but no tiles behind you.
	zoom_out_amt = 5
	projectile_damage_multiplier = 3
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/red/iff,
		)


//Melee weapons
/obj/item/ego_weapon/city/rabbit
	name = "R-1R R-Corp Blade"
	desc = "A small blade used by R-corp. An earlier model, this one deals only red damage. \
			Discontinued quickly in the 4th Pack, but favored by other, more self-reliant packs due to it's higher stopping power and easy production."
	icon_state = "rabbitknife_red"
	icon = 'ModularTegustation/Teguicons/rcorp_weapons.dmi'
	force = 50
	attack_speed = 1
	damtype = RED_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP

	attack_verb_continuous = list("slices", "stabs")
	attack_verb_simple = list("slice", "stab")
	hitsound = 'sound/weapons/bladeslice.ogg'


/obj/item/ego_weapon/city/rabbit/white
	name = "R-1W R-Corp Blade"
	desc = "A small blade used by R-corp. This one deals only white damage. \
				Created much later than the R-1R, this knife is used primarily as emergency measures against insanity."
	icon_state = "rabbitknife_white"
	damtype = WHITE_DAMAGE


/obj/item/ego_weapon/city/rabbit/black
	name = "R-1B R-Corp Blade"
	desc = "A small blade used by R-corp. This one deals only black damage. \
				It is currently unknown why R&D made this weapon, as it was created long after the multiphase blade was in production. \
				Unsurprisingly, the suspected designer was fired due to wasting company resources."
	icon_state = "rabbitknife_black"
	damtype = BLACK_DAMAGE

/obj/item/ego_weapon/city/rabbit/pale
	name = "R-1P R-Corp Blade"
	desc = "A small blade used by R-corp. This one deals only pale damage. \
				After the commercial and operational failure of the R-1B Rabbit blade, plans for this weapon were found in the designer's desk. \
				Rather than toss the design, Ravens were sent to silence the designer. This weapon was put into production shortly after, \
				in an attempt to both recoup costs, and create a breakthrough in pale damage technology. This weapon's technology was later used \
				in the production of R-2900 'The Solution' rifles."
	force = 35
	icon_state = "rabbitknife_pale"
	damtype = PALE_DAMAGE

/obj/item/ego_weapon/city/rabbit/throwing
	name = "R-1T R-Corp Blade"
	desc = "A small blade used by R-corp. This one deals only red damage. \
				Created quickly after the R-1R, this knife is rather good when thrown, but is a servicable melee weapon."
	force = 25
	throwforce = 80
	icon_state = "rabbitthrowing"

