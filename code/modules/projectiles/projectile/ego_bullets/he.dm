/obj/projectile/ego_bullet/ego_prank
	name = "prank"
	damage = 30
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE

/obj/projectile/ego_bullet/ego_gaze
	name = "gaze"
	damage = 52 //Slow as balls
	damage_type = RED_DAMAGE
	flag = RED_DAMAGE

//Homing weapon with no homing
/obj/projectile/ego_bullet/ego_galaxy
	name = "galaxy"
	icon_state = "magicm"
	damage = 40
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE
	speed = 1.5

//Homing weapon (Galaxy)
/obj/projectile/ego_bullet/ego_galaxy/homing
	homing = TRUE
	homing_turn_speed = 30		//Angle per tick.
	var/homing_range = 9

/obj/projectile/ego_bullet/ego_galaxy/homing/Initialize()
	..()
	addtimer(CALLBACK(src, .proc/fireback), 3)

/obj/projectile/ego_bullet/ego_galaxy/homing/proc/fireback()
	icon_state = "magich"
	var/list/targetslist = list()
	for(var/mob/living/L in livinginrange(homing_range, src))
		if(ishuman(L) || isbot(L))
			continue
		if(L.stat == DEAD)
			continue
		if(L.status_flags & GODMODE)
			continue
		targetslist+=L
	if(!LAZYLEN(targetslist))
		return
	homing_target = pick(targetslist)


/obj/projectile/ego_bullet/ego_unrequited
	name = "unrequited"
	damage = 9
	damage_type = WHITE_DAMAGE
	flag = WHITE_DAMAGE

/obj/projectile/ego_bullet/ego_harmony
	name = "harmony"
	icon_state = "harmony"
	nondirectional_sprite = TRUE
	damage = 16
	damage_type = WHITE_DAMAGE
	flag = WHITE_DAMAGE
	speed = 1.3
	projectile_piercing = PASSMOB
	ricochets_max = 3
	ricochet_chance = 99999999 // JUST FUCKING DO IT
	ricochet_decay_chance = 1
	ricochet_decay_damage = 1.5
	ricochet_auto_aim_range = 3
	ricochet_incidence_leeway = 360

/obj/projectile/ego_bullet/ego_harmony/check_ricochet_flag(atom/A)
	if(istype(A, /turf/closed))
		return TRUE
	return FALSE

/obj/projectile/ego_bullet/ego_harmony/check_ricochet(atom/A)
	return TRUE
