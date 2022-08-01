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

/obj/projectile/melting_blob
	name = "slime projectile"
	icon_state = "slime"
	desc = "A glob of infectious slime. It's going for your heart."
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE
	damage = 70
	spread = 15

/obj/projectile/melting_blob/enraged
	name = "slime projectile"
	icon_state = "slime"
	desc = "A glob of infectious slime. It's going for your heart."
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE
	projectile
	damage = 100
	spread = 15

/obj/projectile/melting_blob/Initialize()
	. = ..()
	hitsound = "sound/effects/footstep/slime1.ogg"
	animate(src, alpha = 255, time = 3)
