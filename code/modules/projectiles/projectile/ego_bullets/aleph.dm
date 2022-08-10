/obj/projectile/ego_bullet/ego_star
	name = "star"
	icon_state = "star"
	damage = 25 // Multiplied by 2 or more when at full SP
	damage_type = WHITE_DAMAGE
	flag = WHITE_DAMAGE

/obj/projectile/ego_bullet/melting_blob
	name = "slime projectile"
	icon_state = "slime"
	desc = "A glob of infectious slime. It's going for your heart."
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE
	damage = 100
	spread = 15
	hitsound = "sound/effects/footstep/slime1.ogg"
