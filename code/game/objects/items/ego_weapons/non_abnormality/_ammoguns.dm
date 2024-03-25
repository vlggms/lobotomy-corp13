//Guns that gotta be reloaded.
/obj/item/gun/ego_gun/city/ammogun
	name = "ammo gun template"
	desc = "a template for ammo gun."
	icon_state = "ammogun"
	inhand_icon_state = "ammogun"
	ammo_type = /obj/item/ammo_casing/caseless/fullstop	//Does 10 damage
	weapon_weight = WEAPON_HEAVY
	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'
	special = "Use in hand to reload"
	var/shotsleft = 10
	var/reloadtime = 3 SECONDS

/obj/item/gun/ego_gun/city/ammogun/process_chamber()
	if(shotsleft)
		shotsleft-=1
	..()

/obj/item/gun/ego_gun/city/ammogun/can_shoot()
	..()
	if(shotsleft)
		return TRUE
	visible_message(span_notice("The gun is out of ammo."))
	playsound(src, dry_fire_sound, 30, TRUE)
	return FALSE

/obj/item/gun/ego_gun/city/ammogun/attack_self(mob/user)
	to_chat(user,span_notice("You start loading a new magazine."))
	playsound(src, 'sound/weapons/gun/general/slide_lock_1.ogg', 50, TRUE)
	if(do_after(user, reloadtime, src)) //gotta reload
		playsound(src, 'sound/weapons/gun/general/bolt_rack.ogg', 50, TRUE)
		shotsleft = initial(shotsleft)

/obj/item/gun/ego_gun/city/ammogun/EgoAttackInfo(mob/user)
	if(chambered && chambered.BB)
		return span_notice("Its bullets deal [chambered.BB.damage*projectile_damage_multiplier] [chambered.BB.damage_type] damage.")
	return

/obj/item/gun/ego_gun/city/ammogun/examine(mob/user)
	. = ..()
	. += "Ammo Counter: [shotsleft]/[initial(shotsleft)]."
