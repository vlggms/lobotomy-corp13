/obj/item/ego_weapon/ranged
	var/pellets = 1 //Pellets for spreadshot
	var/variance = 0 //Variance for inaccuracy fundamental to the casing
	var/random_spread = 0 //random_spread for automatics
	var/click_cooldown_override = 0 //Override this to make your gun have a faster fire rate, in tenths of a second. 4 is the default gun cooldown.
	var/firing_effect_type = null //the visual effect appearing when the ammo is fired.

/obj/item/ego_weapon/ranged/proc/fire_projectile(atom/target, mob/living/user, params, distro, quiet, zone_override, spread, atom/fired_from, temporary_damage_multiplier)
	var/obj/projectile/projectile = new projectile_path(src, src)
	projectile.original = target
	projectile.firer = user
	projectile.fired_from = fired_from
	distro += variance

	var/targloc = get_turf(target)

	if (zone_override)
		projectile.def_zone = zone_override
	else
		projectile.def_zone = user.zone_selected
	projectile.suppressed = quiet

	projectile.damage *= projectile_damage_multiplier

	if(HAS_TRAIT(user, TRAIT_BETTER_GUNS))
		projectile.damage += projectile.damage*get_attribute_level(user, JUSTICE_ATTRIBUTE)/130*0.50

	projectile.damage *= (1 + (user.extra_damage / 100))
	if(projectile.damage_type == RED_DAMAGE)
		projectile.damage *= (1 + (user.extra_damage_red / 100))
	if(projectile.damage_type == WHITE_DAMAGE)
		projectile.damage *= (1 + (user.extra_damage_white / 100))
	if(projectile.damage_type == BLACK_DAMAGE)
		projectile.damage *= (1 + (user.extra_damage_black / 100))
	if(projectile.damage_type == PALE_DAMAGE)
		projectile.damage *= (1 + (user.extra_damage_pale / 100))

	if(temporary_damage_multiplier)
		projectile.damage *= temporary_damage_multiplier

	last_projectile_damage = projectile.damage
	last_projectile_type = projectile.damage_type

	if(pellets == 1)
		if(distro) //We have to spread a pixel-precision bullet. throw_proj was called before so angles should exist by now...
			if(random_spread)
				spread = round((rand() - 0.5) * distro)
			else //Smart spread
				spread = round(1 - 0.5) * distro
		if(!throw_proj(target, targloc, user, params, spread, projectile))
			return FALSE
	else
		if(isnull(projectile))
			return FALSE
		var/obj/item/ammo_casing/caseless/casing = new(src)
		casing.pellets = pellets
		casing.variance = variance
		casing.projectile_type = projectile_path
		casing.BB = projectile
		casing.AddComponent(/datum/component/pellet_cloud, projectile_path, pellets)
		SEND_SIGNAL(casing, COMSIG_PELLET_CLOUD_INIT, target, user, fired_from, random_spread, spread, zone_override, params, distro)
		qdel(casing) // don't worry, the component protects the casing from deleting until its done doing its job

	if(click_cooldown_override)
		user.changeNext_move(click_cooldown_override)
	else
		user.changeNext_move(CLICK_CD_RANGE)
	user.newtonian_move(get_dir(target, user))

/obj/item/ego_weapon/ranged/proc/throw_proj(atom/target, turf/targloc, mob/living/user, params, spread, obj/projectile/projectile)
	var/turf/curloc = get_turf(user)
	if(!istype(targloc) || !istype(curloc))
		return FALSE

	var/firing_dir
	if(projectile.firer)
		firing_dir = projectile.firer.dir
	if(!projectile.suppressed && firing_effect_type)
		new firing_effect_type(get_turf(src), firing_dir)

	var/direct_target
	if(targloc == curloc)
		if(target) //if the target is right on our location we'll skip the travelling code in the proj's fire()
			direct_target = target
	if(!direct_target)
		projectile.preparePixelProjectile(target, user, params, spread)
	projectile.fire(null, direct_target)
	return TRUE
