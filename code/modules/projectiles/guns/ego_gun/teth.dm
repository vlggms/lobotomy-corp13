//All teth Rifles should be around 22 DPS (31 per bullet
//All Teth Pistols should hit about

//Does slightly less damage due to AOE.
/obj/item/gun/ego_gun/match
	name = "fourth match flame"
	desc = "The light of the match will not go out until it has burned away happiness, warmth, light, \
	and all the other good things of the world; there's no need to worry about it being quenched."
	icon_state = "match"
	inhand_icon_state = "match"
	special = "This weapon does AOE damage."
	ammo_type = /obj/item/ammo_casing/caseless/ego_match
	weapon_weight = WEAPON_HEAVY
	fire_delay = 30
	fire_sound = 'sound/weapons/ego/cannon.ogg'

/obj/item/gun/ego_gun/beak
	name = "beak"
	desc = "As if to prove that size doesn't matter when it comes to force, \
	the weapon has high firepower despite its small size."
	icon_state = "beak"
	inhand_icon_state = "beak"
	ammo_type = /obj/item/ammo_casing/caseless/ego_beak
	weapon_weight = WEAPON_HEAVY
	spread = 10
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'
	autofire = 0.14 SECONDS

/obj/item/gun/ego_gun/pistol/beakmagnum
	name = "beak mk2"
	desc = "A heavy revolver that fires at a surprisingly fast rate, and is deadly accurate."
	icon_state = "beakmagnum"
	inhand_icon_state = "beak"
	special = "This weapon has pinpoint accuracy when dual wielded."
	ammo_type = /obj/item/ammo_casing/caseless/ego_beakmagnum
	fire_delay = 20
	fire_sound = 'sound/weapons/gun/revolver/shot_alt.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70
	dual_wield_spread = 0

/obj/item/gun/ego_gun/noise
	name = "noise"
	desc = "The noises take you back to the very moment of the day that everyone had forgotten."
	icon_state = "noise"
	inhand_icon_state = "noise"
	special = "This weapon fires 5 pellets."
	ammo_type = /obj/item/ammo_casing/caseless/ego_noise
	weapon_weight = WEAPON_HEAVY
	fire_delay = 20
	fire_sound = 'sound/weapons/gun/shotgun/shot_auto.ogg'

/obj/item/gun/ego_gun/pistol/solitude
	name = "solitude"
	desc = "A classic blue revolver, that gives you feelings of loneliness."
	icon_state = "solitude"
	inhand_icon_state = "solitude"
	ammo_type = /obj/item/ammo_casing/caseless/ego_solitude
	fire_delay = 25
	fire_sound = 'sound/weapons/gun/revolver/shot_light.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70

/obj/item/gun/ego_gun/pistol/shy
	name = "todays expression"
	desc = "Many different expressions are padded on the equipment like patches. \
	When throbbing emotions surge up from time to time, it's best to simply cover the face."
	icon_state = "shy"
	inhand_icon_state = "shy"
	ammo_type = /obj/item/ammo_casing/caseless/ego_shy
	fire_sound = 'sound/effects/meatslap.ogg'
	vary_fire_sound = FALSE
	autofire = 0.2 SECONDS

/obj/item/gun/ego_gun/dream
	name = "engulfing dream"
	desc = "And when the crying stops, dawn will break."
	icon_state = "dream"
	inhand_icon_state = "dream"
	ammo_type = /obj/item/ammo_casing/caseless/ego_dream
	weapon_weight = WEAPON_HEAVY
	fire_sound = "dreamy_gun"
	autofire = 0.2 SECONDS

/obj/item/gun/ego_gun/page
	name = "page"
	desc = "The pain of creation! The pain! The pain!"
	icon_state = "page"
	inhand_icon_state = "page"
	ammo_type = /obj/item/ammo_casing/caseless/ego_page
	weapon_weight = WEAPON_HEAVY
	fire_delay = 10
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'

/obj/item/gun/ego_gun/snapshot
	name = "snapshot"
	desc = "I swear, that obscene portrait was just trying to make us lower our guard."
	icon_state = "snapshot"
	inhand_icon_state = "snapshot"
	special = "This weapon fires a hitscan beam."
	ammo_type = /obj/item/ammo_casing/caseless/ego_snapshot
	weapon_weight = WEAPON_HEAVY
	fire_delay = 10
	fire_sound = 'sound/weapons/sonic_jackhammer.ogg'

/obj/item/gun/ego_gun/wishing_cairn
	name = "wishing cairn"
	desc = "Speak unto me your wish, vocalize your eagerness..."
	icon_state = "wishing_cairn"
	inhand_icon_state = "wishing_cairn"
	special = "This weapon has a combo system with a short range."
	ammo_type = /obj/item/ammo_casing/caseless/ego_wishing
	weapon_weight = WEAPON_HEAVY
	fire_delay = 3
	burst_size = 2
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	fire_sound = 'sound/abnormalities/pagoda/throw.ogg'
	var/ammo2 = /obj/item/ammo_casing/caseless/ego_wishing2

/obj/item/gun/ego_gun/wishing_cairn/proc/Ammo_Change()
	chambered = new ammo2
	fire_sound = 'sound/abnormalities/pagoda/throw2.ogg'
	return

/obj/item/gun/ego_gun/wishing_cairn/afterattack(atom/target, mob/user)
	..()
	chambered = new ammo_type
	fire_sound = 'sound/abnormalities/pagoda/throw.ogg'

/obj/item/gun/ego_gun/aspiration
	name = "aspiration"
	desc = "The desire to live was stronger than anything. That is when regret finally ran a shudder through my body."
	icon_state = "aspiration"
	inhand_icon_state = "aspiration"
	special = "This weapon fires a hitscan beam at the cost of health. \n Upon hitting an ally, this weapon heals the target,"
	ammo_type = /obj/item/ammo_casing/caseless/ego_aspiration
	weapon_weight = WEAPON_HEAVY
	autofire = 0.5 SECONDS
	fire_sound = 'sound/abnormalities/fragment/attack.ogg'

/obj/item/gun/ego_gun/aspiration/before_firing(atom/target,mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.adjustBruteLoss(3)
	..()
	return
