/obj/projectile/despair_rapier
	name = "enchanted rapier"
	desc = "A magic rapier, enchanted by the sheer despair and suffering the knight has been through."
	icon_state = "despair"
	damage_type = PALE_DAMAGE
	flag = PALE_DAMAGE
	damage = 40
	alpha = 0
	spread = 20

/obj/projectile/despair_rapier/Initialize()
	. = ..()
	hitsound = "sound/weapons/ego/rapier[pick(1,2)].ogg"
	animate(src, alpha = 255, time = 3)

/obj/projectile/apocalypse
	name = "light"
	icon_state = "apocalypse"
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE
	damage = 40
	alpha = 0
	spread = 45

/obj/projectile/apocalypse/Initialize()
	. = ..()
	animate(src, alpha = 255, pixel_x = rand(-10,10), pixel_y = rand(-10,10), time = 5 SECONDS)

/obj/projectile/hatred
	name = "magic beam"
	icon_state = "qoh1"
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE
	damage = 25
	spread = 15

/obj/projectile/hatred/Initialize()
	. = ..()
	icon_state = "qoh[pick(1,2,3)]"

/obj/projectile/mountain
	name = "spit"
	desc = "Gross, disgusting spit."
	icon_state = "mini_leaper"
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE
	damage = 30
	spread = 20
	knockdown = 5

/obj/projectile/mountain/big
	name = "big spit"
	desc = "Gross, disgusting spit."
	icon_state = "leaper"
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE
	damage = 40
	knockdown = 10

/obj/projectile/mountain/big/on_hit(atom/target, blocked = FALSE)
	..()
	for(var/mob/living/L in view(2, target))
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L))
		L.apply_damage(30, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
	return BULLET_ACT_HIT
