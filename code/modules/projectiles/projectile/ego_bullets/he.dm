/obj/projectile/ego_bullet/ego_prank
	name = "prank"
	damage = 30
	damage_type = BLACK_DAMAGE

/obj/projectile/ego_bullet/ego_transmission
	name = "transmission"
	damage = 30
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_gaze
	name = "gaze"
	damage = 70 //Slow as balls
	damage_type = RED_DAMAGE

//Homing weapon with no homing
/obj/projectile/ego_bullet/ego_galaxy
	name = "galaxy"
	icon_state = "magicm"
	damage = 45
	damage_type = BLACK_DAMAGE
	speed = 1.5

//Homing weapon (Galaxy)
/obj/projectile/ego_bullet/ego_galaxy/homing
	homing = TRUE
	homing_turn_speed = 30		//Angle per tick.
	var/homing_range = 9

/obj/projectile/ego_bullet/ego_galaxy/homing/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(fireback)), 3)

/obj/projectile/ego_bullet/ego_galaxy/homing/proc/fireback()
	icon_state = "magich"
	var/list/targetslist = list()
	for(var/mob/living/L in range(homing_range, src))
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
	damage = 11
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/ego_harmony
	name = "harmony"
	icon_state = "harmony"
	nondirectional_sprite = TRUE
	damage = 16
	damage_type = WHITE_DAMAGE
	speed = 1.3
	projectile_piercing = PASSMOB
	ricochets_max = 3
	ricochet_chance = 100 // JUST FUCKING DO IT
	ricochet_decay_chance = 1
	ricochet_decay_damage = 1.5 // Does MORE per bounce
	ricochet_auto_aim_range = 3
	ricochet_incidence_leeway = 0

/obj/projectile/ego_bullet/ego_harmony/check_ricochet_flag(atom/A)
	if(istype(A, /turf/closed))
		return TRUE
	return FALSE

/obj/projectile/ego_bullet/ego_song
	name = "song"
	damage = 6
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/ego_songmini
	name = "song"
	damage = 2 //4 pellets
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/ego_wedge
	name = "screaming"
	damage = 30
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/replica
	name = "sinewy claw"
	damage = 30
	damage_type = BLACK_DAMAGE
	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/tracer/laser/replica
	tracer_type = /obj/effect/projectile/tracer/laser/replica
	impact_type = /obj/effect/projectile/impact/laser/replica

/obj/effect/projectile/tracer/laser/replica
	name = "replica claw"
	icon_state = "replica"
/obj/effect/projectile/impact/laser/replica
	name = "replica impact"
	icon_state = "replica"

/obj/projectile/ego_bullet/replica/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(!isliving(target))
		return
	var/mob/living/T = target
	var/mob/living/user = firer
	if(user.faction_check_mob(T))//player faction
		T.Knockdown(50)//trip the target
		return BULLET_ACT_BLOCK
	qdel(src)

/obj/projectile/ego_bullet/ego_swindle
	name = "swindle"
	icon_state = "d6"
	damage = 1
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_swindle/Initialize()
	. = ..()
	damage = pick(5, 10, 25, 30, 35, 45)

/obj/projectile/ego_bullet/ego_ringing
	name = "ringing"
	icon_state = "energy2"
	damage = 7
	damage_type = BLACK_DAMAGE

/obj/projectile/ego_bullet/ego_syrinx
	name = "syrinx"
	icon_state = "ecstasy"
	damage_type = WHITE_DAMAGE
	color = COLOR_GREEN
	damage = 7
	speed = 1.3
	range = 6
