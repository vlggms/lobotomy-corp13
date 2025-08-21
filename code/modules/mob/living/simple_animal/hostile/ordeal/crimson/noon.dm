/mob/living/simple_animal/hostile/ordeal/crimson_noon
	name = "harmony of skin"
	desc = "A large clown-like creature with 3 heads full of red tumors."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "crimson_noon"
	icon_living = "crimson_noon"
	icon_dead = "crimson_noon_dead"
	faction = list("crimson_ordeal")
	maxHealth = 350
	health = 350
	pixel_x = -8
	base_pixel_x = -8
	melee_damage_lower = 6
	melee_damage_upper = 8
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/effects/ordeals/crimson/noon_bite.ogg'
	death_sound = 'sound/effects/ordeals/crimson/noon_dead.ogg'
	damage_coeff = list(RED_DAMAGE = 0.6, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5)
	blood_volume = BLOOD_VOLUME_NORMAL
	ordeal_remove_ondeath = FALSE

	/// How many mobs we spawn on death
	var/mob_spawn_amount = 3

	var/can_be_gibbed = TRUE

/mob/living/simple_animal/hostile/ordeal/crimson_noon/death(gibbed)
	if(gibbed)
		DeathExplosion(TRUE)
	else
		can_be_gibbed = FALSE
		animate(src, transform = matrix()*1.25, color = "#FF0000", time = 5)
		addtimer(CALLBACK(src, PROC_REF(DeathExplosion)), 5)
	..()

/mob/living/simple_animal/hostile/ordeal/crimson_noon/gib()
	if(!can_be_gibbed)
		return
	return ..()

/mob/living/simple_animal/hostile/ordeal/crimson_noon/proc/DeathExplosion(gibbed = FALSE)
	if(QDELETED(src))
		return
	visible_message(span_danger("[src] suddenly explodes!"))
	var/valid_directions = list(0) // 0 is used by get_turf to find the turf a target, so it'll at the very least be able to spawn on itself.
	for(var/d in list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
		var/turf/TF = get_step(src, d)
		if(!istype(TF))
			continue
		if(!TF.is_blocked_turf(TRUE))
			valid_directions += d
	for(var/i = 1 to mob_spawn_amount)
		var/turf/T = get_step(get_turf(src), pick(valid_directions))
		var/mob/living/simple_animal/hostile/ordeal/crimson_clown/nc = new(T)
		addtimer(CALLBACK(nc, TYPE_PROC_REF(/mob/living/simple_animal/hostile/ordeal/crimson_clown, TeleportAway)), 1)
		if(ordeal_reference)
			nc.ordeal_reference = ordeal_reference
			ordeal_reference.ordeal_mobs += nc
	if(ordeal_reference)
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	if(!gibbed)
		can_be_gibbed = TRUE
		gib()
