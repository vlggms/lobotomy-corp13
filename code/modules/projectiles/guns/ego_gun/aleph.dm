/obj/item/gun/ego_gun/star
	name = "sound of a star"
	desc = "The star shines brighter as our despair gathers. The weapon's small, evocative sphere fires a warm ray."
	icon_state = "star"
	inhand_icon_state = "star"
	ammo_type = /obj/item/ammo_casing/caseless/ego_star
	weapon_weight = WEAPON_HEAVY
	spread = 5
	fire_sound = 'sound/weapons/ego/star.ogg'
	vary_fire_sound = TRUE
	fire_sound_volume = 50

	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/gun/ego_gun/star/Initialize()
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.25 SECONDS)

/obj/item/gun/ego_gun/adoration
	name = "adoration"
	desc = "A big mug filled with mysterious slime that never runs out. \
	It’s the byproduct of some horrid experiment in a certain laboratory that eventually failed."
	icon_state = "adoration"
	inhand_icon_state = "adoration"
	ammo_type = /obj/item/ammo_casing/caseless/ego_adoration
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'sound/effects/attackblob.ogg'
	fire_sound_volume = 50
	fire_delay = 15

	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)
