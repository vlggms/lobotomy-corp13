/obj/item/gun/ego_gun/pistol/tough
	name = "tough pistol"
	desc = "A glock reminiscent of a certain detective who fought evil for 25 years, losing hair as time went by."
	icon_state = "bald"
	inhand_icon_state = "gun"
	worn_icon_state = "gun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	ammo_type = /obj/item/ammo_casing/caseless/ego_tough
	burst_size = 1
	fire_delay = 0
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70

/obj/item/gun/ego_gun/tough/SpecialEgoCheck(mob/living/carbon/human/H)
	if(H.hairstyle in list("Bald", "Shaved"))
		return TRUE
	to_chat(H, "<span class='notice'>Only the ones with clean hairstyle can use [src]!</span>")
	return FALSE

/obj/item/gun/ego_gun/tough/SpecialGearRequirements()
	return "\n<span class='warning'>The user must have bald or shaved hair.</span>"

/obj/item/gun/ego_gun/pistol/soda
	name = "soda pistol"
	desc = "A pistol painted in a refreshing purple. Whenever this EGO is used, a faint scent of grapes wafts through the air."
	icon_state = "soda"
	inhand_icon_state = "soda"
	ammo_type = /obj/item/ammo_casing/caseless/ego_soda
	burst_size = 1
	fire_delay = 0
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70


/obj/item/gun/ego_gun/clerk
	name = "clerk pistol"
	desc = "A shitty pistol, labeled 'Point open end towards enemy'."
	icon_state = "clerk"
	inhand_icon_state = "gun"
	worn_icon_state = "gun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	ammo_type = /obj/item/ammo_casing/caseless/ego_clerk
	burst_size = 1
	fire_delay = 0
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70
