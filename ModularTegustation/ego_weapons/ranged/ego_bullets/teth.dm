/obj/projectile/ego_bullet/ego_match
	name = "match"
	icon_state = "pulse0"
	damage = 35 // Direct hit
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_match/on_hit(atom/target, blocked = FALSE)
	..()
	for(var/mob/living/L in view(1, target))
		new /obj/effect/temp_visual/fire/fast(get_turf(L))
		L.apply_damage(25, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
	return BULLET_ACT_HIT

/obj/projectile/ego_bullet/ego_beak
	name = "beak"
	damage = 4
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_noise
	name = "noise"
	damage = 10
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/ego_solitude
	name = "solitude"
	damage = 40	//Slow as balls
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/ego_beakmagnum
	name = "beak"
	damage = 30	//entirely accurate. should have 32 DPS, it suffers.
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_shy
	name = "today's expression"
	damage = 4 //Can dual wield, full auto
	damage_type = BLACK_DAMAGE

/obj/projectile/ego_bullet/ego_dream
	name = "dream"
	icon_state = "energy2"
	damage = 6
	speed = 1.5
	damage_type = WHITE_DAMAGE


/obj/projectile/ego_bullet/ego_page
	name = "page"
	damage = 20
	damage_type = BLACK_DAMAGE


//Snapshot, hitscan laser
/obj/projectile/beam/snapshot
	name = "snapshot"
	icon_state = "snapshot"
	hitsound = null
	damage = 18
	damage_type = WHITE_DAMAGE

	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/muzzle/laser/snapshot
	tracer_type = /obj/effect/projectile/tracer/laser/snapshot
	impact_type = /obj/effect/projectile/impact/laser/snapshot
	wound_bonus = -100
	bare_wound_bonus = -100

/obj/effect/projectile/muzzle/laser/snapshot
	name = "grey flash"
	icon_state = "muzzle_grey"

/obj/effect/projectile/tracer/laser/snapshot
	name = "grey beam"
	icon_state = "beam_grey"

/obj/effect/projectile/impact/laser/snapshot
	name = "grey impact"
	icon_state = "impact_grey"

/obj/projectile/ego_bullet/ego_wishing
	name = "stone"
	icon_state = "wishing_rock"
	damage = 5
	damage_type = BLACK_DAMAGE


/obj/projectile/ego_bullet/ego_wishing/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/obj/item/ego_weapon/ranged/wishing_cairn/gun = fired_from
	gun.Ammo_Change()
	return

/obj/projectile/ego_bullet/ego_wishing2
	name = "kunai"
	icon_state = "wishing_kunai"
	damage = 10
	damage_type = BLACK_DAMAGE


/obj/projectile/ego_bullet/ego_aspiration
	name = "aspiration"
	icon_state = "lava"
	damage = 25
	damage_type = RED_DAMAGE

	hitscan = TRUE
	tracer_type = /obj/effect/projectile/tracer/laser/aspiration

/obj/effect/projectile/tracer/laser/aspiration
	name = "aspiration"
	icon_state = "aspiration"

/obj/projectile/ego_bullet/ego_aspiration/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(!isliving(target))
		return
	var/mob/living/T = target
	var/mob/living/user = firer
	if(firer == target)
		return BULLET_ACT_BLOCK
	if(user.faction_check_mob(T)) // Our faction
		T.adjustBruteLoss(-10)
		return BULLET_ACT_BLOCK

/obj/projectile/ego_bullet/ego_patriot
	name = "patriot"
	damage = 15
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_luckdraw
	name = "luck of the draw"
	icon_state = "drawcard"
	damage = 18
	damage_type = WHITE_DAMAGE
	projectile_piercing = PASSMOB
	speed = 0.45
	range = 14
	hit_nondense_targets = TRUE

/obj/projectile/ego_bullet/ego_tough
	name = "9mm tough bullet"
	damage = 16 // Being bald is the optimal gameplay choice!
	damage_type = WHITE_DAMAGE


