/obj/projectile/ego_bullet/ego_prank
	name = "prank"
	damage = 10
	damage_type = BLACK_DAMAGE

/obj/projectile/ego_bullet/ego_transmission
	name = "transmission"
	damage = 14
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_gaze
	name = "gaze"
	icon_state = "gaze"
	damage = 18
	nondirectional_sprite = TRUE
	damage_type = RED_DAMAGE
	projectile_piercing = PASSMOB
	speed = 1.3
	ricochets_max = 3
	ricochet_chance = 100 // JUST FUCKING DO IT
	ricochet_decay_chance = 1
	ricochet_decay_damage = 1
	ricochet_auto_aim_range = 4
	ricochet_incidence_leeway = 0

/obj/projectile/ego_bullet/ego_gaze/check_ricochet_flag(atom/A)
	if(istype(A, /turf/closed))
		return TRUE
	if(istype(A, /obj/structure/window))
		return TRUE
	if(istype(A, /obj/machinery/door))
		return TRUE

	return FALSE

/obj/projectile/ego_bullet/ego_gaze/on_hit(atom/target, blocked = FALSE)
	. = ..()
	damage *= 0.8
	if(damage < 1)
		qdel(src)
		return

//Homing weapon with no homing
/obj/projectile/ego_bullet/ego_galaxy
	name = "galaxy"
	icon_state = "magicm"
	damage = 28
	damage_type = BLACK_DAMAGE
	speed = 1.5

//Homing weapon (Galaxy)
/obj/projectile/ego_bullet/ego_galaxy/homing
	homing = TRUE
	speed = 1.25
	homing_turn_speed = 30		//Angle per tick.
	var/homing_range = 9

/obj/projectile/ego_bullet/ego_galaxy/homing/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(fireback)), 3)

/obj/projectile/ego_bullet/ego_galaxy/homing/proc/fireback()
	icon_state = "magich"
	set_homing_target(GetHomingTarget(homing_range))


/obj/projectile/ego_bullet/ego_unrequited
	name = "unrequited"
	damage = 7
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/ego_harmony
	name = "harmony"
	icon_state = "pulse0"
	damage = 50
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/ego_harmony/strong
	damage = 75

/obj/projectile/ego_bullet/ego_song
	name = "song"
	damage = 3
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/ego_songmini
	name = "song"
	damage = 1 //4 pellets
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/ego_wedge
	name = "screaming"
	damage = 38
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/regs
	name = "sinewy claw"
	damage = 10
	damage_type = BLACK_DAMAGE
	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/tracer/laser/regs
	tracer_type = /obj/effect/projectile/tracer/laser/regs
	impact_type = /obj/effect/projectile/impact/laser/regs

/obj/effect/projectile/tracer/laser/regs
	name = "move-in claw"
	icon_state = "replica"
/obj/effect/projectile/impact/laser/regs
	name = "move-in impact"
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
	damage = 14
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_swindle/Initialize()
	. = ..()
	damage = rand(4, 24)

/obj/projectile/ego_bullet/ego_ringing
	name = "ringing"
	icon_state = "energy2"
	damage = 3
	damage_type = BLACK_DAMAGE
	hitscan = TRUE

/obj/projectile/ego_bullet/ego_ringing/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/splatter_dir = 0
	var/hitx = target.pixel_x + rand(-8, 8)
	var/hity = target.pixel_y + rand(-8, 8)
	if(isliving(target))
		splatter_dir = angle2dir(Angle)
		hitx = target.pixel_x + (sin(Angle) * 16)
		hity = target.pixel_y + (cos(Angle) * 16)

	new/obj/effect/temp_visual/dir_setting/longbloodsplatter/purple(get_turf(target), splatter_dir, hitx, hity)

/obj/projectile/ego_bullet/ego_syrinx
	name = "syrinx"
	icon_state = "ecstasy"
	damage_type = WHITE_DAMAGE
	color = COLOR_GREEN
	damage = 8
	hitscan = TRUE

/obj/projectile/ego_bullet/ego_syrinx/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/splatter_dir = 0
	var/hitx = target.pixel_x + rand(-8, 8)
	var/hity = target.pixel_y + rand(-8, 8)
	if(isliving(target))
		splatter_dir = angle2dir(Angle)
		hitx = target.pixel_x + (sin(Angle) * 16)
		hity = target.pixel_y + (cos(Angle) * 16)

	new/obj/effect/temp_visual/dir_setting/longbloodsplatter(get_turf(target), splatter_dir, hitx, hity)

/obj/projectile/ego_bullet/ego_squeak
	name = "squeak"
	damage = 3
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/soda_rifle
	damage = 11
	speed = 0.25
