// Designs
/datum/design/vortex_gun
	name = "Black Hole Projector"
	desc = "A strange weapon that uses a compressed singularity as projectiles. Requires a vortex anomaly core to operate properly."
	id = "vortex_gun"
	construction_time = 200
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 30000, /datum/material/glass = 20000, /datum/material/uranium = 15000, /datum/material/bluespace = 10000, /datum/material/diamond = 5000)
	build_path = /obj/item/gun/energy/vortex_gun
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_SCIENCE

/datum/design/flux_sword
	name = "Flux Sword"
	desc = "A weapon that is using power of high-voltage electricity. Requires a flux anomaly core to operate properly."
	id = "flux_sword"
	construction_time = 200
	build_type = PROTOLATHE
	materials = list(/datum/material/iron = 45000, /datum/material/titanium = 30000, /datum/material/uranium = 15000, /datum/material/diamond = 5000)
	build_path = /obj/item/melee/flux_sword
	category = list("Weapons")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_SCIENCE

// Da guns
/obj/item/gun/energy/vortex_gun
	name = "black hole projector"
	desc = "A weapon that releases a dark matter energy in a form of compressed singularity. Requires a vortex anomaly core to function. Fits in a bag."
	ammo_type = list(/obj/item/ammo_casing/energy/vortex)
	w_class = WEIGHT_CLASS_NORMAL
	inhand_icon_state = null
	icon = 'ModularTegustation/Teguicons/bhole_projector.dmi'
	icon_state = "vortex_gun"
	cell_type = /obj/item/stock_parts/cell/mini_egun // 3 shots.
	var/firing_core = FALSE

/obj/item/gun/energy/vortex_gun/Initialize()
	. = ..()
	fire_delay = 20

/obj/item/gun/energy/vortex_gun/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/assembly/signaler/anomaly/vortex) && !firing_core)
		to_chat(user, span_notice("You insert [C] into the [src] and the weapon starts humming."))
		firing_core = TRUE
		playsound(src.loc, 'sound/machines/click.ogg', 50, TRUE)
		qdel(C)
		return

/obj/item/gun/energy/vortex_gun/can_shoot()
	if(!firing_core)
		return FALSE
	return ..()

/obj/item/gun/energy/vortex_gun/shoot_with_empty_chamber(mob/living/user)
	. = ..()
	if(!firing_core)
		to_chat(user, span_danger("The display says, \"NO CORE INSTALLED\"."))

// Casing
/obj/item/ammo_casing/energy/vortex
	projectile_type = /obj/projectile/beam/vortex_bullet
	select_name = "death"
	e_cost = 200
	fire_sound = 'sound/weapons/marauder.ogg'

// Projectiles
/obj/projectile/beam/vortex_bullet
	name = "compressed singularity"
	desc = "Well, you are dead."
	icon = 'ModularTegustation/Teguicons/bhole_projector.dmi'
	icon_state = "dark_bullet"
	impact_effect_type = /obj/effect/projectile/impact/wormhole
	light_color = LIGHT_COLOR_PURPLE
	damage = 55
	irradiate = 100
	range = 11
	projectile_piercing = PASSMOB
	projectile_phasing = (ALL & (~PASSMOB))

/obj/projectile/beam/vortex_bullet/on_hit(atom/target, blocked = FALSE)
	if(ishuman(target))
		var/mob/living/carbon/human/dead_man = target
		dead_man.Sleeping(6 SECONDS)
	return ..()

/obj/projectile/beam/vortex_bullet/Moved(atom/OldLoc, Dir)
	. = ..()
	grav(rand(0,3), rand(2,3), 25, 25)

	//Godless copy-pasta from vortex anomaly.
	for(var/obj/O in range(2,src))
		if(O == src)
			return
		if(!O.anchored)
			var/mob/living/target = locate() in view(2,src)
			if(target && !target.stat)
				O.throw_at(target, 5, 3)

/obj/projectile/beam/vortex_bullet/proc/grav(r, ex_act_force, pull_chance, turf_removal_chance)
	for(var/t = -r, t < r, t++)
		affect_coord(x+t, y-r, ex_act_force, pull_chance, turf_removal_chance)
		affect_coord(x-t, y+r, ex_act_force, pull_chance, turf_removal_chance)
		affect_coord(x+r, y+t, ex_act_force, pull_chance, turf_removal_chance)
		affect_coord(x-r, y-t, ex_act_force, pull_chance, turf_removal_chance)

/obj/projectile/beam/vortex_bullet/proc/affect_coord(x, y, ex_act_force, pull_chance, turf_removal_chance)
	var/turf/T = locate(x, y, z)
	if(isnull(T))
		return

	if(prob(pull_chance))
		for(var/obj/O in T.contents)
			if(istype(O,/obj/machinery/atmospherics)) // Please don't kill atmos, thanks.
				continue
			if(O.anchored)
				switch(ex_act_force)
					if(EXPLODE_DEVASTATE)
						SSexplosions.high_mov_atom += O
					if(EXPLODE_HEAVY)
						SSexplosions.med_mov_atom += O
					if(EXPLODE_LIGHT)
						SSexplosions.low_mov_atom += O
			else
				step_towards(O,src)
		for(var/mob/living/M in T.contents)
			step_towards(M,src)

	//Damaging the turf
	if(T && prob(turf_removal_chance) )
		switch(ex_act_force)
			if(EXPLODE_DEVASTATE)
				SSexplosions.highturf += T
			if(EXPLODE_HEAVY)
				SSexplosions.medturf += T
			if(EXPLODE_LIGHT)
				SSexplosions.lowturf += T

// Sword
/obj/item/melee/flux_sword
	name = "dormant flux sword"
	desc = "A weapon that is using power of high-voltage electricity. Requires flux anomaly core to operate properly."
	icon_state = "claymore_gold"
	inhand_icon_state = "claymore_gold"
	worn_icon_state = "claymore_gold"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	hitsound = 'sound/weapons/bladeslice.ogg'
	slot_flags = null
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_BELT
	force = 10
	armour_penetration = 0
	var/burn_force = 12
	var/stam_force = 10
	var/anomaly_ready = FALSE

/obj/item/melee/flux_sword/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/assembly/signaler/anomaly/flux) && !anomaly_ready)
		to_chat(user, span_notice("You insert [C] into the [src]."))
		playsound(src.loc, "sparks", 50, TRUE)
		name = "flux sword"
		anomaly_ready = TRUE
		force = 12
		armour_penetration = 35
		qdel(C)
		return

/obj/item/melee/flux_sword/afterattack(target, mob/user, proximity_flag)
	. = ..()
	if(proximity_flag && anomaly_ready)
		if(isliving(target))
			var/mob/living/L = target
			playsound(src.loc, "sparks", 75, TRUE, -1)
			do_sparks(5, TRUE, L)
			L.adjustFireLoss(burn_force)
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				H.adjustStaminaLoss(stam_force)
				H.electrocution_animation(15)
				H.jitteriness += 5
				if(prob(20))
					H.Knockdown(burn_force / 2)
