/obj/projectile/ego_bullet/ego_soda/rifle
	damage = 17
	speed = 0.25

/obj/projectile/ego_bullet/ego_kcorp
	damage = 15

/obj/projectile/ego_bullet/ego_knade
	damage = 15
	speed = 1
	icon_state = "kcorp_nade"

/obj/projectile/ego_bullet/ego_knade/Initialize()
	. = ..()
	addtimer(CALLBACK(src, .proc/fireback), 5)

/obj/projectile/ego_bullet/ego_knade/proc/fireback()
	on_hit()

/obj/projectile/ego_bullet/ego_knade/on_hit(atom/target, blocked = FALSE)
	..()
	for(var/turf/T in view(1, src))
		for(var/mob/living/L in T)
			L.apply_damage(60, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
	new /obj/effect/explosion(get_turf(src))
	qdel(src)
	return BULLET_ACT_HIT
