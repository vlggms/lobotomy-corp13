/obj/item/gun/ego_gun/sodarifle
	name = "soda rifle"
	desc = "A gun used by shrimp corp, apparently."
	icon_state = "sodarifle"
	inhand_icon_state = "sodalong"
	ammo_type = /obj/item/ammo_casing/caseless/ego_shrimprifle
	weapon_weight = WEAPON_HEAVY
	fire_delay = 3
	fire_sound = 'sound/weapons/gun/rifle/shot.ogg'

/obj/item/gun/ego_gun/sodashotty
	name = "soda shotgun"
	desc = "A gun used by shrimp corp, apparently."
	icon_state = "sodashotgun"
	inhand_icon_state = "sodalong"
	special = "This weapon fires 3 pellets."
	ammo_type = /obj/item/ammo_casing/caseless/ego_shrimpshotgun
	weapon_weight = WEAPON_HEAVY
	fire_delay = 10
	fire_sound = 'sound/weapons/gun/shotgun/shot.ogg'

/obj/item/gun/ego_gun/sodasmg
	name = "soda submachinegun"
	desc = "A gun used by shrimp corp, apparently."
	icon_state = "sodasmg"
	inhand_icon_state = "soda"
	ammo_type = /obj/item/ammo_casing/caseless/ego_soda
	weapon_weight = WEAPON_HEAVY
	spread = 8
	fire_sound = 'sound/weapons/gun/smg/shot.ogg'
	autofire = 0.15 SECONDS

//My sweet orange tree - The cure
/obj/item/gun/ego_gun/flammenwerfer
	name = "flamethrower"
	desc = "A shitty flamethrower, great for clearing out infested areas and people."
	special = "Use this in-hand to cover yourself in flames. To prevent infection, of course."
	icon = 'icons/obj/flamethrower.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/flamethrower_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/flamethrower_righthand.dmi'
	icon_state = "flamethrower1"
	inhand_icon_state = "flamethrower_1"
	ammo_type = /obj/item/ammo_casing/caseless/flammenwerfer
	weapon_weight = WEAPON_HEAVY
	spread = 50
	fire_sound = 'sound/abnormalities/doomsdaycalendar/Effect_Burn.ogg'
	autofire = 0.08 SECONDS
	fire_sound_volume = 5

/obj/item/gun/ego_gun/flammenwerfer/attack_self(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(do_after(H, 12, src))
		to_chat(H,"<span class='warning'>You cover yourself in flames!</span>")
		H.playsound_local(get_turf(H), 'sound/abnormalities/doomsdaycalendar/Effect_Burn.ogg', 100, 0)
		H.apply_damage(10, RED_DAMAGE, null, H.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		H.adjust_fire_stacks(1)
		H.IgniteMob()
