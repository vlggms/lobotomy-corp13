/obj/projectile/ego_bullet/ego_correctional
	name = "correctional"
	damage = 5
	damage_type = BLACK_DAMAGE
	spread = 5

/obj/projectile/ego_bullet/ego_hornet
	name = "hornet"
	damage = 15
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_hatred
	name = "magic beam"
	icon_state = "qoh1"
	damage_type = BLACK_DAMAGE
	damage = 30
	spread = 10

/obj/projectile/ego_bullet/ego_hatred/on_hit(atom/target, blocked = FALSE)
	if(ishuman(target) && isliving(firer))
		var/mob/living/carbon/human/H = target
		var/mob/living/user = firer
		if(firer==target)
			return BULLET_ACT_BLOCK
		if(user.faction_check_mob(H)) // Our faction
			if(H.is_working)
				H.visible_message("<span class='warning'>[src] vanishes on contact with [H]... but nothing happens!</span>")
				qdel(src)
				return BULLET_ACT_BLOCK
			switch(damage_type)
				if(WHITE_DAMAGE)
					H.adjustSanityLoss(-10)
				if(BLACK_DAMAGE)
					H.adjustBruteLoss(-5)
					H.adjustSanityLoss(-5)
				else // Red or pale
					H.adjustBruteLoss(-10)
			H.visible_message("<span class='warning'>[src] vanishes on contact with [H]!</span>")
			qdel(src)
			return BULLET_ACT_BLOCK
	..()

/obj/projectile/ego_bullet/ego_hatred/Initialize()
	. = ..()
	icon_state = "qoh[pick(1,2,3)]"
	damage_type = pick(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)

/obj/projectile/ego_bullet/ego_magicbullet
	name = "magic bullet"
	icon_state = "magic_bullet"
	damage = 40
	speed = 0.1
	damage_type = BLACK_DAMAGE
	projectile_piercing = PASSMOB
	range = 18 // Don't want people shooting it through the entire facility
	hit_nondense_targets = TRUE

/obj/projectile/ego_bullet/ego_magicbullet/abnormality
	damage = 35 // Lower damage, inflicts a status effect.

/obj/projectile/ego_bullet/ego_magicbullet/abnormality/on_hit(atom/target, blocked = FALSE, pierce_hit)
	if(istype(target, /mob/living/simple_animal/hostile/der_freis_portal))
		var/mob/living/simple_animal/hostile/der_freis_portal/P = target
		P.death()
	else if(istype(target, /mob/living))
		var/mob/living/the_target = target
		the_target.apply_dark_flame(7)
	. = ..()



/obj/projectile/ego_bullet/ego_solemnlament
	name = "solemn lament"
	icon_state = "whitefly"
	damage = 7
	speed = 0.35
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/ego_solemnvow
	name = "solemn vow"
	icon_state = "blackfly"
	damage = 7
	speed = 0.35
	damage_type = BLACK_DAMAGE

//Smartgun
/obj/projectile/ego_bullet/ego_loyalty
	name = "loyalty"
	icon_state = "loyalty"
	damage = 3
	speed = 0.2
	damage_type = RED_DAMAGE
	ff_multiplier = 0

/// Fired from the Loyalty rifle's UGL.
/obj/projectile/ego_bullet/loyalty_ugl
	name = "loyal grenade"
	icon_state = "bolter"
	damage = 80
	range = 16
	nodamage = TRUE	// Damage is calculated later
	speed = 0.8
	// No hitsound - we play a sound on detonation
	ff_multiplier = 0
	var/tile_radius = 3
	/// Damage at epicenter (distance 0)
	/// Each tile away from the epicenter reduces damage by this much
	var/falloff_per_dist = 15

/// Whenever this thing finally meets its end, blow up.
/obj/projectile/ego_bullet/loyalty_ugl/Destroy(force)
	Detonate()
	return ..()

/// Explode, dealing damage and knocking back all nearby enemies. Ignore anything that has the firer's faction. Also gib dead things.
/obj/projectile/ego_bullet/loyalty_ugl/proc/Detonate()
	var/mob/living/nadeslinger = firer
	if(!istype(nadeslinger))
		return
	var/turf/impact_turf = get_turf(src)

	// Aesthetics
	new /obj/effect/explosion(impact_turf)
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(RadialShockwaveVisual), impact_turf, tile_radius, 2, /obj/effect/temp_visual/small_smoke/halfsecond)
	playsound(impact_turf, 'sound/effects/explosion2.ogg', 50, 0, 6)

	// Shake the screen of the firer
	var/dist_from_epicenter = get_dist(nadeslinger, impact_turf)
	var/screenshake_intensity = clamp((3.5 - (dist_from_epicenter * 0.4)), 0.3, 3.5)
	shake_camera(nadeslinger, 3, screenshake_intensity)

	// Check every turf in our radius, hit mobs once at most. This can hit corpses.
	var/list/affected_turfs = RANGE_TURFS(tile_radius, impact_turf)
	for(var/turf/T in affected_turfs)
		for(var/mob/living/M in T)
			if(impacted[M])
				continue
			if(nadeslinger.faction_check_mob(M))
				continue

			impacted[M] = TRUE

			// Damage
			var/distance_from_epicenter = clamp(get_dist(M, impact_turf), 0, 3)
			var/final_damage = (damage - (distance_from_epicenter * falloff_per_dist)) * damage_multiplier
			M.deal_damage(final_damage, damage_type)

			// Knockback
			var/throw_comparison = get_turf(M) == impact_turf ? null : impact_turf // If they're standing directly in the epicenter we need to take special measures
			var/throw_dir = throw_comparison ? get_cardinal_dir(throw_comparison, M) : pick(GLOB.cardinals) // Take a random cardinal if they're directly on top of us
			if(M)
				M.safe_throw_at(target = get_ranged_target_turf(impact_turf, throw_dir, 4), range = 5, speed = 5, thrower = nadeslinger, spin = TRUE)
				// Gib corpses
				if(M.stat >= DEAD)
					M.gib()

/obj/projectile/ego_bullet/ego_soda_premium
	name = "soda premium"
	damage = 10
	spread = 0
	damage_type = PALE_DAMAGE	//hehe

/obj/projectile/ego_bullet/ego_crimson
	name = "crimson"
	damage = 6
	damage_type = RED_DAMAGE
	spread = 5

/obj/projectile/ego_bullet/ego_ecstasy
	name = "ecstasy"
	icon_state = "ecstasy"
	damage_type = WHITE_DAMAGE
	damage = 5
	speed = 1.3
	range = 6

/obj/projectile/ego_bullet/ego_ecstasy/Initialize()
	. = ..()
	color = pick(COLOR_RED, COLOR_YELLOW, COLOR_LIME, COLOR_CYAN, COLOR_MAGENTA, COLOR_ORANGE)


//Smartpistol
/obj/projectile/ego_bullet/ego_praetorian
	name = "praetorian"
	icon_state = "loyalty"
	damage = 10
	damage_type = RED_DAMAGE
	ff_multiplier = 0
	var/homing_range = 9

/obj/projectile/ego_bullet/ego_praetorian/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(fireback)), 3)

/obj/projectile/ego_bullet/ego_praetorian/proc/fireback()
	var/mob/living/target = GetHomingTarget(homing_range)
	if(target)
		var/datum/point/PT = RETURN_PRECISE_POINT(target)
		PT.x += clamp(homing_offset_x, 1, world.maxx)
		PT.y += clamp(homing_offset_y, 1, world.maxy)
		set_angle(angle_between_points(RETURN_PRECISE_POINT(src), PT))

/obj/projectile/ego_bullet/ego_magicpistol
	name = "magic pistol"
	icon_state = "magic_bullet"
	damage = 15
	speed = 0.1
	damage_type = BLACK_DAMAGE
	projectile_piercing = PASSMOB
	hit_nondense_targets = TRUE
	var/damage_decay = 0.85

/obj/projectile/ego_bullet/ego_magicpistol/on_hit(atom/target, blocked = FALSE)
	. = ..()
	damage *= damage_decay
	if(damage < 1)
		qdel(src)
		return

//tommygun
/obj/projectile/ego_bullet/ego_intention
	name = "good intentions"
	damage = 3
	speed = 0.2
	damage_type = RED_DAMAGE

//laststop
/obj/projectile/ego_bullet/ego_laststop
	name = "laststop"
	damage = 90
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_aroma
	name = "aroma"
	icon_state = "arrow_aroma"
	damage = 58
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/accord
	name = "accord"
	icon_state = "arrow_greyscale"
	damage = 48
	damage_type = WHITE_DAMAGE
	speed = 0.2

/obj/projectile/ego_bullet/accord/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(pierce_hit)
		return
	if(!ishostile(target))
		return
	var/mob/living/simple_animal/hostile/H = target
	if(H.stat == DEAD || H.status_flags & GODMODE)
		return
	for(var/mob/living/carbon/human/Yin in view(7, H))
		var/obj/item/ego_weapon/wield/discord/D = Yin.get_active_held_item()
		if(istype(D, /obj/item/ego_weapon/wield/discord))
			if(!D.CanUseEgo(Yin))
				continue
			Yin.adjustBruteLoss(-10)
			Yin.adjustSanityLoss(-10)
			break
	return

//Exuviae
/obj/projectile/ego_bullet/ego_exuviae
	name = "serpents exuviae"
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "nakednest_serpent"
	desc = "A sterile naked nest serpent"
	damage = 160
	damage_type = RED_DAMAGE
	hitsound = "sound/effects/wounds/pierce1.ogg"

/obj/projectile/ego_bullet/ego_exuviae/on_hit(target)
	. = ..()
	if(isliving(target))
		var/mob/living/simple_animal/M = target
		if(!ishuman(M) && !M.has_status_effect(/datum/status_effect/display/rend))
			new /obj/effect/temp_visual/cult/sparks(get_turf(M))
			M.apply_status_effect(/datum/status_effect/display/rend)

//feather of valor
/obj/projectile/ego_bullet/ego_warring
	name = "feather of valor"
	icon_state = "arrow"
	damage = 42
	damage_type = BLACK_DAMAGE

/obj/projectile/ego_bullet/ego_warring/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/obj/item/ego_weapon/ranged/warring/bow = fired_from
	var/mob/living/L = target
	if(!isliving(target))
		return
	if((L.stat == DEAD) || L.status_flags & GODMODE)//if the target is dead or godmode
		return FALSE
	bow.HandleCharge(1, target)
	return

//feather of valor cont'd
/obj/projectile/ego_bullet/ego_warring2
	name = "feather of valor"
	icon_state = "lava"
	hitsound = null
	damage = 63
	damage_type = BLACK_DAMAGE
	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/muzzle/laser/warring
	tracer_type = /obj/effect/projectile/tracer/warring
	impact_type = /obj/effect/projectile/impact/laser/warring
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	hitsound = 'sound/weapons/sear.ogg'
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'
	eyeblur = 0
	impact_effect_type = /obj/effect/temp_visual/impact_effect/red_laser
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 1
	light_color = COLOR_SOFT_RED

/obj/effect/projectile/muzzle/laser/warring
	name = "lightning flash"
	icon_state = "muzzle_warring"
/obj/effect/projectile/tracer/warring
	name = "lightning beam"
	icon_state = "warring"
/obj/effect/projectile/impact/laser/warring
	name = "lightning impact"
	icon_state = "impact_warring"

/obj/projectile/ego_bullet/ego_warring2/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/mob/living/carbon/human/H = target
	if(ishuman(H))
		H.adjustSanityLoss(-damage*0.2)
		H.electrocute_act(1, src, flags = SHOCK_NOSTUN)
		H.Knockdown(50)
		return BULLET_ACT_BLOCK
	qdel(src)

/obj/projectile/ego_bullet/ego_banquet
	name = "banquet"
	icon_state = "pulse0"
	damage = 80
	damage_type = BLACK_DAMAGE


/obj/projectile/ego_bullet/ego_blind_rage
	name = "blind rage"
	icon_state = "blind_rage"
	damage = 9
	damage_type = BLACK_DAMAGE
	spread = 10

/obj/projectile/ego_bullet/ego_blind_rage/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(!isliving(target))
		return
	var/mob/living/L = target
	L.apply_status_effect(/datum/status_effect/wrath_burning)

/obj/projectile/ego_bullet/ego_innocence
	name = "innocence"
	icon_state = "energy"
	damage = 5 //Can dual wield, full auto
	damage_type = WHITE_DAMAGE


/obj/projectile/ego_bullet/ego_hypocrisy
	name = "hypocrisy"
	icon_state = "arrow_greyscale"
	color = "#AAFF00"
	damage = 54 //4 damage is transfered to the spawnable trap
	damage_type = RED_DAMAGE


/obj/projectile/ego_bullet/ego_bride
	name = "bride"
	icon_state = "gaussphase"
	damage = 23
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/ego_supershotgun
	name = "super shotgun"
	damage = 5
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_fellbullet
	name = "fell bullet"
	icon_state = "fell_bullet"
	damage = 36
	speed = 0.1
	damage_type = RED_DAMAGE
	projectile_piercing = PASSMOB
	range = 36
	hit_nondense_targets = TRUE

/obj/projectile/ego_bullet/ego_fellscatter
	name = "fell pellet"
	damage = 8//7 pellets
	damage_type = RED_DAMAGE
	spread = 20

/obj/projectile/ego_bullet/ego_fellscatter/greater
	name = "fell pellet"
	icon_state = "fell_pellet"
	damage = 16//generated by friendly fire effect
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/special_fellbullet
	name = "fell bullet"
	icon_state = "fell_bullet"
	damage = 36
	speed = 0.1
	damage_type = RED_DAMAGE
	projectile_piercing = PASSMOB
	range = 18
	hit_nondense_targets = TRUE

/obj/projectile/ego_bullet/special_fellbullet/on_hit(atom/target, blocked = FALSE, angle)
	. = ..()
	var/mob/living/carbon/human/H = target
	if(ishuman(H))
		if(H.stat == DEAD)
			return FALSE
		INVOKE_ASYNC(src, PROC_REF(MagicBulletEffect), angle)

/obj/projectile/ego_bullet/special_fellbullet/prehit_pierce(atom/A)
	. = ..()
	var/mob/living/carbon/human/H = A
	if(ishuman(H))
		return PROJECTILE_PIERCE_NONE

/obj/projectile/ego_bullet/special_fellbullet/proc/MagicBulletEffect(angle, atom/direct_target)
	var/obj/effect/fellcircle/circle = new(get_turf(src))
	circle.damage_mult = damage_multiplier
	circle.AdjustCircle(Angle, firer)//visual dir thingy
	circle.FireBullets(Angle, damage)

/obj/effect/fellcircle//thing that shoots
	name = "magic circle"
	desc = "A circle of red magic featuring a six-pointed star "
	icon = 'icons/effects/effects.dmi'
	icon_state = "fellcircle"
	var/pellets = 7
	var/shotsleft = 4
	var/angle = 0
	var/damage = 40
	var/damage_mult = 1
	var/distro = 30

/obj/effect/fellcircle/Initialize()
	QDEL_IN(src, 10 SECONDS)
	return ..()

/obj/effect/fellcircle/proc/FireBullets(angle, damage)
	playsound(src, 'sound/abnormalities/fluchschutze/fell_portal.ogg', 50, FALSE)
	sleep(1 SECONDS)
	animate(src, alpha = 0, time = 4 SECONDS)
	for(var/i = 0, i < shotsleft, i++)
		sleep(0.5 SECONDS)
		playsound(src, 'sound/abnormalities/fluchschutze/fell_scatter2.ogg', 25, TRUE)
		for(var/ii = 0, ii < pellets, ii++)
			var/obj/projectile/ego_bullet/ego_fellscatter/greater/bullet = new(get_turf(src))
			bullet.damage_multiplier = damage_mult
			var/true_angle = angle + round(((ii+1) / pellets - 0.5) * distro) + (round(1 - 0.5) * distro)
			bullet.fire(true_angle)
	QDEL_IN(src, 1 SECONDS)

/obj/effect/fellcircle/proc/AdjustCircle(angle, atom/movable/firer)
	if(!firer)
		return
	var/matrix/M = matrix(transform)
	var/rot_angle = angle
	M.Turn(rot_angle)
	switch(firer.dir)
		if(EAST)
			M.Scale(0.5, 1)
			M.Translate(12, 0)
		if(WEST)
			M.Scale(0.5, 1)
			M.Translate(-16, 0)
		if(NORTH)
			M.Translate(0, 8)
			layer -= 0.2
	transform = M

/obj/projectile/ego_bullet/soda_shotty
	name = "9mm soda bullet"
	damage = 5
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/soda_assault
	name = "9mm soda bullet"
	damage = 7
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/soda_mini
	name = "9mm soda bullet"
	damage = 2
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/soda_smg
	name = "9mm soda bullet"
	damage = 4
	damage_type = RED_DAMAGE
