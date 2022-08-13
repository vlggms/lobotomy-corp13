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

/obj/projectile/melting_blob
	name = "slime projectile"
	icon_state = "slime"
	desc = "A glob of infectious slime. It's going for your heart."
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE
	damage = 100
	spread = 15
	hitsound = "sound/effects/footstep/slime1.ogg"

/obj/projectile/melting_blob/enraged
	damage = 200
	spread = 15

/obj/projectile/mountain_spit
	name = "spit"
	desc = "Gross, disgusting spit."
	icon_state = "mountain"
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE
	damage = 10 // Launches 32(96) of those, for a whooping 320(960) black damage
	spread = 60
	slur = 3
	eyeblur = 3

/obj/projectile/mountain_spit/Initialize()
	. = ..()
	speed += pick(0, 0.1, 0.2, 0.3) // Randomized speed

