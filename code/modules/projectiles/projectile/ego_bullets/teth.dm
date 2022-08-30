/obj/projectile/ego_bullet/ego_match
	name = "match"
	icon_state = "pulse0"
	damage = 35 // Direct hit
	damage_type = RED_DAMAGE
	flag = RED_DAMAGE

/obj/projectile/ego_bullet/ego_match/on_hit(atom/target, blocked = FALSE)
	..()
	for(var/mob/living/L in view(1, target))
		new /obj/effect/temp_visual/fire/fast(get_turf(L))
		L.apply_damage(25, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
	return BULLET_ACT_HIT

/obj/projectile/ego_bullet/ego_beak
	name = "beak"
	damage = 6
	damage_type = RED_DAMAGE
	flag = RED_DAMAGE

/obj/projectile/ego_bullet/ego_noise
	name = "noise"
	damage = 4
	damage_type = WHITE_DAMAGE
	flag = WHITE_DAMAGE

/obj/projectile/ego_bullet/ego_solitude
	name = "solitude"
	damage = 13
	damage_type = WHITE_DAMAGE
	flag = WHITE_DAMAGE
