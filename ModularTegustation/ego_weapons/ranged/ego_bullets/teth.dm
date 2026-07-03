/obj/projectile/ego_bullet/ego_match
	name = "match"
	icon_state = "pulse0"
	damage = 35 // Direct hit
	damage_type = RED_DAMAGE
	var/aoe_damage = 15

/obj/projectile/ego_bullet/ego_match/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/mob/living/user = firer
	for(var/mob/living/L in view(1, target))
		new /obj/effect/temp_visual/fire/fast(get_turf(L))
		if(user.faction_check_mob(L) || L == target)
			continue
		L.apply_damage(aoe_damage * damage_multiplier, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
	return BULLET_ACT_HIT

/obj/projectile/ego_bullet/ego_beak
	name = "beak"
	damage = 9
	damage_type = RED_DAMAGE

/obj/projectile/ego_bulletsmg/ego_bulletsmg
	name = "beak"
	damage = 2
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_bulletsmg/strong
	damage = 4

/obj/projectile/ego_bullet/ego_noise
	name = "noise"
	damage = 4
	damage_type = WHITE_DAMAGE
	spread = 5

/obj/projectile/ego_bullet/ego_solitude
	name = "solitude"
	damage = 10
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/ego_shy
	name = "today's expression"
	damage = 2 //Can dual wield, full auto
	damage_type = BLACK_DAMAGE

/obj/projectile/ego_bullet/ego_dream
	name = "dream"
	icon_state = "energy2"
	damage = 6
	speed = 1.5
	damage_type = WHITE_DAMAGE


/obj/projectile/ego_bullet/ego_page
	name = "page"
	damage = 6
	damage_type = BLACK_DAMAGE


//Snapshot, hitscan laser
/obj/projectile/ego_bullet/snapshot
	name = "snapshot"
	icon_state = "snapshot"
	hitsound = null
	damage = 15
	damage_type = WHITE_DAMAGE

	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/muzzle/laser/snapshot
	tracer_type = /obj/effect/projectile/tracer/laser/snapshot
	impact_type = /obj/effect/projectile/impact/laser/snapshot
	wound_bonus = -100
	bare_wound_bonus = -100
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	hitsound = 'sound/weapons/sear.ogg'
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'
	eyeblur = 0
	impact_effect_type = /obj/effect/temp_visual/impact_effect/red_laser
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 1
	light_color = COLOR_SOFT_RED

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
	damage = 1
	damage_type = BLACK_DAMAGE


/obj/projectile/ego_bullet/ego_wishing/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/obj/item/ego_weapon/ranged/wishing_cairn/gun = fired_from
	gun.Ammo_Change()
	return

/obj/projectile/ego_bullet/ego_wishing2
	name = "kunai"
	icon_state = "wishing_kunai"
	damage = 3
	damage_type = BLACK_DAMAGE


/obj/projectile/ego_bullet/ego_aspiration
	name = "aspiration"
	icon_state = "lava"
	damage = 8
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
		T.adjustBruteLoss(T.maxHealth * 0.05)
		return BULLET_ACT_BLOCK

/obj/projectile/ego_bullet/ego_patriot
	name = "patriot"
	damage = 6
	damage_type = RED_DAMAGE
	spread = 10

/obj/projectile/ego_bullet/ego_luckdraw
	name = "luck of the draw"
	icon_state = "drawcard"
	damage = 6
	damage_type = WHITE_DAMAGE
	projectile_piercing = PASSMOB
	speed = 0.45
	range = 14
	hit_nondense_targets = TRUE

/obj/projectile/ego_bullet/ego_tough
	name = "9mm tough bullet"
	damage = 4 // Being bald is the optimal gameplay choice!
	damage_type = WHITE_DAMAGE


/obj/projectile/ego_bullet/ego_adjustment
	name = "magic beam"
	icon_state = "antimagic"
	damage_type = WHITE_DAMAGE
	damage = 20
	spread = 0
	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/muzzle/laser/adjustment
	tracer_type = /obj/effect/projectile/tracer/adjustment
	impact_type = /obj/effect/projectile/impact/laser/adjustment

/obj/effect/projectile/muzzle/laser/adjustment
	name = "lightning flash"
	icon_state = "muzzle_warring"
	color = "#33EBFF"

/obj/effect/projectile/tracer/adjustment
	name = "lightning beam"
	icon_state = "warring"
	color = "#33EBFF"

/obj/effect/projectile/impact/laser/adjustment
	name = "lightning impact"
	icon_state = "impact_warring"
	color = "#33EBFF"

/obj/projectile/ego_bullet/ego_adjustment/on_hit(atom/target, blocked = FALSE)
	if(ishuman(target) && firer!=target)
		var/mob/living/carbon/human/H = target
		if(H.is_working)
			qdel(src)
			return BULLET_ACT_BLOCK
		H.adjustSanityLoss(-damage * damage_multiplier * 0.25, FALSE) // deal fixed white damage to employees, ignoring armor
		if(!H.sanity_lost)
			qdel(src)
			return BULLET_ACT_BLOCK
	..()
