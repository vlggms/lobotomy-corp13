//Guns that reload on melee. You can reload them, but it's really slow
/obj/item/gun/ego_gun/city/thumb
	name = "thumb soldato rifle"
	desc = "A 5 round magazine rifle used by The Thumb."
	icon_state = "thumb_soldato"
	inhand_icon_state = "thumb_soldato"
	force = 30
	var/attack_speed = 1.5
	ammo_type = /obj/item/ammo_casing/caseless/fullstop	//Does 10 damage
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'
	special = "Attack an enemy with your bayonet to reload."
	projectile_damage_multiplier = 3		//30 damage per bullet
	fire_delay = 7
	shotsleft = 5		//Based off the Mas 36, That's what my Girlfriend things it looks like. Holds 5 bullets.
	reloadtime = 5 SECONDS
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 80,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 60,
	)

/obj/item/gun/ego_gun/city/thumb/attack(mob/living/target, mob/living/carbon/human/user)
	..()
	if(shotsleft < initial(shotsleft))
		shotsleft += 1
	user.changeNext_move(CLICK_CD_MELEE * attack_speed)

//Capo
/obj/item/gun/ego_gun/city/thumb/capo
	name = "thumb capo rifle"
	desc = "A rifle used by thumb Capos. The gun is inlaid with silver."
	icon_state = "thumb_capo"
	inhand_icon_state = "thumb_capo"
	force = 50
	projectile_damage_multiplier = 5		//50 damage per bullet
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 60
							)

//Sottoacpo
/obj/item/gun/ego_gun/city/thumb/sottocapo
	name = "thumb sottocapo shotgun"
	desc = "A pistol used by thumb sottocapos. While expensive, it's power is rarely matched among syndicates."
	icon_state = "thumb_sottocapo"
	inhand_icon_state = "thumb_sottocapo"
	force = 20	//It's a pistol
	ammo_type = /obj/item/ammo_casing/caseless/thumbshell	//Does 10 damage
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

//wepaons are kinda uninteresting
/obj/item/ego_weapon/city/thumbmelee
	name = "thumb brass knuckles"
	desc = "An pair of dusters sometimes used by thumb capos."
	icon_state = "thumb_duster"
	force = 44
	damtype = RED_DAMAGE

	attack_verb_continuous = list("beats")
	attack_verb_simple = list("beat")
	hitsound = 'sound/weapons/fixer/generic/fist2.ogg'

/obj/item/ego_weapon/city/thumbcane
	name = "thumb sottocapo cane"
	desc = "An cane used by thumb sottocapos."
	icon_state = "thumb_cane"
	force = 65
	damtype = RED_DAMAGE

	attack_verb_continuous = list("beats")
	attack_verb_simple = list("beat")
	hitsound = 'sound/weapons/fixer/generic/club1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
