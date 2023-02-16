#define SHOT_MODE 0
#define DOT_MODE 1
#define AOE_MODE 2

/obj/item/gun/ego_gun/star
	name = "sound of a star"
	desc = "The star shines brighter as our despair gathers. The weapon's small, evocative sphere fires a warm ray."
	icon_state = "star"
	inhand_icon_state = "star"
	special = "This gun fires 240 rounds per minute. \
			This gun scales with remaining SP."
	ammo_type = /obj/item/ammo_casing/caseless/ego_star
	weapon_weight = WEAPON_HEAVY
	spread = 5
	fire_sound = 'sound/weapons/ego/star.ogg'
	vary_fire_sound = TRUE
	fire_sound_volume = 25
	autofire = 0.25 SECONDS

	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/gun/ego_gun/adoration
	name = "adoration"
	desc = "A big mug filled with mysterious slime that never runs out. \
	It’s the byproduct of some horrid experiment in a certain laboratory that eventually failed."
	icon_state = "adoration"
	inhand_icon_state = "adoration"
	special = "Use in hand to swap between AOE, DOT and shotgun modes."
	ammo_type = /obj/item/ammo_casing/caseless/ego_adoration
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'sound/effects/attackblob.ogg'
	fire_sound_volume = 50
	fire_delay = 3

	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)
	var/mode = 0

/obj/item/gun/ego_gun/adoration/attack_self(mob/user)
	..()
	switch(mode)
		if(SHOT_MODE)
			to_chat(user,"<span class='warning'>You focus, changing for a DOT blast</span>")
			ammo_type = /obj/item/ammo_casing/caseless/ego_adoration/dot
			mode = DOT_MODE
			return
		if(DOT_MODE)
			to_chat(user,"<span class='warning'>You focus, changing for an AOE blast</span>")
			ammo_type = /obj/item/ammo_casing/caseless/ego_adoration/aoe
			mode = AOE_MODE
			return
		if(AOE_MODE)
			to_chat(user,"<span class='warning'>You focus, changing for a shotgun blast</span>")
			ammo_type = /obj/item/ammo_casing/caseless/ego_adoration
			mode = SHOT_MODE
			return

#undef SHOT_MODE
#undef DOT_MODE
#undef AOE_MODE
