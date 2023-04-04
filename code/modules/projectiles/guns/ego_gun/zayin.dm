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
	fire_delay = 10
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70

/obj/item/gun/ego_gun/pistol/tough/SpecialEgoCheck(mob/living/carbon/human/H)
	if(HAS_TRAIT(H, TRAIT_BALD))
		return TRUE
	to_chat(H, "<span class='notice'>Only the ones with dedication to clean hairstyle can use [src]!</span>")
	return FALSE

/obj/item/gun/ego_gun/pistol/tough/SpecialGearRequirements()
	return "\n<span class='warning'>The user must have clean hairstyle.</span>"

/obj/item/gun/ego_gun/pistol/soda
	name = "soda pistol"
	desc = "A pistol painted in a refreshing purple. Whenever this EGO is used, a faint scent of grapes wafts through the air."
	icon_state = "soda"
	inhand_icon_state = "soda"
	ammo_type = /obj/item/ammo_casing/caseless/ego_soda
	burst_size = 1
	fire_delay = 10
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
	fire_delay = 3
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70

/obj/item/gun/ego_gun/clerk/handle_suicide(mob/living/carbon/human/user, mob/living/carbon/human/target, params, bypass_timer)
	if(!ishuman(user) || !ishuman(target))
		return

	if(semicd)
		return

	var/user_target = FALSE
	if(user == target)
		target.visible_message("<span class='warning'>[user] sticks [src] in [user.p_their()] mouth, ready to pull the trigger...</span>", \
			"<span class='userdanger'>You stick [src] in your mouth, ready to pull the trigger...</span>")
		user_target = TRUE
	else
		target.visible_message("<span class='warning'>[user] points [src] at [target]'s head, ready to pull the trigger...</span>", \
			"<span class='userdanger'>[user] points [src] at your head, ready to pull the trigger...</span>")

	semicd = TRUE

	if(!bypass_timer && (!do_mob(user, target, (user_target ? 3 SECONDS : 12 SECONDS)) || user.zone_selected != BODY_ZONE_PRECISE_MOUTH))
		if(user)
			if(user == target)
				user.visible_message("<span class='notice'>[user] decided not to shoot.</span>")
			else if(target?.Adjacent(user))
				target.visible_message("<span class='notice'>[user] has decided to spare [target]</span>", "<span class='notice'>[user] has decided to spare your life!</span>")
		semicd = FALSE
		return

	semicd = FALSE

	target.visible_message("<span class='warning'>[user] pulls the trigger!</span>", "<span class='userdanger'>[(user == target) ? "You pull" : "[user] pulls"] the trigger!</span>")

	if(chambered?.BB)
		chambered.BB.damage *= (user_target ? 100 : 5) // This should certainly kill you on suicide
		chambered.BB.wound_bonus += (user_target ? 200 : 10) // THERE WILL BE BLOOD
		chambered.BB.dismemberment = (user_target ? 5 : 0) // Tiny chance to behead you for no reason at all

	var/fired = process_fire(target, user, TRUE, params, BODY_ZONE_HEAD)
	if(!fired && chambered?.BB)
		chambered.BB.damage /= (user_target ? 100 : 5)
		chambered.BB.wound_bonus -= (user_target ? 200 : 10)
		chambered.BB.dismemberment = 0

/obj/item/gun/ego_gun/pistol/nostalgia
	name = "nostalgia"
	desc = "An old-looking pistol made of wood"
	icon_state = "nostalgia"
	inhand_icon_state = "nostalgia"
	ammo_type = /obj/item/ammo_casing/caseless/ego_nostalgia
	fire_delay = 20
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 70
