//Pistol
/obj/item/ego_weapon/ranged/city/limbuspistol
	name = "LCCB pistol"
	desc = "A pistol often found in the hands of LCCB staff."
	icon_state = "lccb_pistol"
	inhand_icon_state = "lccb_pistol"
	icon = 'icons/obj/limbus_weapons.dmi'
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	force = 8
	attack_speed = 0.5
	weapon_weight = WEAPON_LIGHT
	projectile_path = /obj/projectile/ego_bullet/tendamage
	shotsleft = 13
	reloadtime = 1 SECONDS
	fire_delay = 5

//Auto Pistol
/obj/item/ego_weapon/ranged/city/limbusautopistol
	name = "LCCB auto pistol"
	desc = "A pistol often found in the hands of LCCB staff. This one is fully automatic"
	icon_state = "lccb_burstpistol"
	inhand_icon_state = "lccb_pistol"
	icon = 'icons/obj/limbus_weapons.dmi'
	force = 8
	attack_speed = 0.5
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	weapon_weight = WEAPON_LIGHT
	projectile_path = /obj/projectile/ego_bullet/tendamage
	spread = 30
	shotsleft = 13
	reloadtime = 1.5 SECONDS
	autofire = 0.12 SECONDS

//Magnum
/obj/item/ego_weapon/ranged/city/limbusmagnum
	name = "LCCB magnum"
	desc = "A pistol often found in the hands of LCCB combat officers."
	icon_state = "lccb_magnum"
	inhand_icon_state = "lccb_magnum"
	icon = 'icons/obj/limbus_weapons.dmi'
	fire_sound = 'sound/weapons/gun/pistol/shot.ogg'
	force = 8
	attack_speed = 0.5
	weapon_weight = WEAPON_HEAVY
	projectile_path = /obj/projectile/ego_bullet/tendamage
	projectile_damage_multiplier = 6 //60 damage per bullet
	shotsleft = 6
	reloadtime = 3 SECONDS
	fire_delay = 12

//SMG
/obj/item/ego_weapon/ranged/city/limbussmg
	name = "LCCB submachine gun"
	desc = "An SMG often found in the hands of LCCB staff. This one is fully automatic, but requires two hands."
	icon_state = "lccb_smg"
	inhand_icon_state = "lccb_smg"
	icon = 'icons/obj/limbus_weapons.dmi'
	force = 14
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'
	projectile_path = /obj/projectile/ego_bullet/tendamage
	spread = 30
	shotsleft = 30
	reloadtime = 2.7 SECONDS
	autofire = 0.12 SECONDS

//Shottie
/obj/item/ego_weapon/ranged/city/limbusshottie
	name = "LCCB shotgun"
	desc = "A shotgun found in the hands of LCCB staff. Has limited ammo and a long reload."
	icon_state = "lccb_shotgun"
	inhand_icon_state = "lccb_shotgun"
	icon = 'icons/obj/limbus_weapons.dmi'
	force = 14
	projectile_path = /obj/projectile/ego_bullet/tendamage // total 40 damage
	pellets = 8
	variance = 16
	projectile_damage_multiplier = 0.5 //5 damage per bullet
	fire_delay = 10
	fire_sound = 'sound/weapons/gun/rifle/shot_alt.ogg'
	shotsleft = 7
	reloadtime = 3.2 SECONDS
	force = 10	//You have knockback
	damtype = RED_DAMAGE


/obj/item/ego_weapon/ranged/city/limbusshottie/attack(mob/living/target, mob/living/user)
	. = ..()
	user.changeNext_move(CLICK_CD_MELEE * 1.5)
	if(!.)
		return FALSE
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user)

//LCCB Defensive Equipment
/obj/item/ego_weapon/shield/lccb
	name = "LCCB riot shield"
	desc = "A riot shield used by lccb staff."
	special = "Slows down the user significantly."
	icon = 'icons/obj/limbus_weapons.dmi'
	icon_state = "lccb_shield"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right.dmi'
	force = 20
	slowdown = 0.7
	damtype = RED_DAMAGE
	attack_verb_continuous = list("shoves", "bashes")
	attack_verb_simple = list("shove", "bash")
	hitsound = 'sound/weapons/genhit2.ogg'
	reductions = list(50, 40, 40, 20)
	projectile_block_duration = 5 SECONDS
	block_cooldown = 4 SECONDS
	block_duration = 2 SECONDS
	item_flags = SLOWS_WHILE_IN_HAND


/obj/item/ego_weapon/shield/lccb/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user)


//Bats for the bat people
/obj/item/ego_weapon/city/lccb_bat
	name = "LCCB bat"
	desc = "A baton used by LCCB staff."
	special = "This weapon has knockback."
	icon_state = "lccb_baton"
	icon = 'icons/obj/limbus_weapons.dmi'
	force = 54	//You're hitting shit with your baton
	attack_speed = 2
	damtype = RED_DAMAGE
	attack_verb_continuous = list("bashes", "clubs")
	attack_verb_simple = list("bashes", "clubs")
	hitsound = 'sound/weapons/fixer/generic/club1.ogg'

/obj/item/ego_weapon/city/lccb_bat/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 4), whack_speed, user)

/obj/item/ego_weapon/city/lccb_bat/CanUseEgo(mob/living/user)
	. = ..()
	if(user.get_inactive_held_item())
		to_chat(user, span_notice("You cannot use [src] with only one hand!"))
		return FALSE

