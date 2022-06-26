/obj/item/gun/ego_gun/tough
	name = "tough pistol"
	desc = "A glock reminiscent of a certain detective who fought evil for 25 years, losing hair as time went by."
	icon_state = "bald"
	inhand_icon_state = "gun"
	worn_icon_state = "gun"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	ammo_type = /obj/item/ammo_casing/caseless/ego_tough
	burst_size = 1
	fire_delay = 0
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70

/obj/item/gun/ego_gun/tough/special_ego_check(mob/living/carbon/human/H)
	if(H.hairstyle in list("Bald", "Shaved"))
		return TRUE
	to_chat(H, "<span class='notice'>Only the ones with clean hairstyle can use [src]!</span>")
	return FALSE
