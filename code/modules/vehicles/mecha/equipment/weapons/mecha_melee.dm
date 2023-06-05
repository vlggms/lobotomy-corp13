/obj/item/mecha_parts/mecha_equipment/hammer
	name = "Rhino Hammer"
	desc = "Equipment for smashing and bashing. Does Red Damage"
	icon_state = "mecha_drill"
	equip_cooldown = 15
	energy_drain = 10
	force = 200
	harmful = TRUE
	range = MECHA_MELEE
	mech_flags = EXOSUIT_MODULE_COMBAT
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE

/obj/item/mecha_parts/mecha_equipment/rhinoblade
	name = "Rhino Blade"
	desc = "Equipment for cutting and slicing. Does Black damage"
	icon_state = "mecha_drill"
	equip_cooldown = 15
	energy_drain = 10
	force = 200
	harmful = TRUE
	range = MECHA_MELEE
	mech_flags = EXOSUIT_MODULE_COMBAT
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE

/obj/item/mecha_parts/mecha_equipment/hammer/action(mob/source, atom/target, params)
	// Check if we can even use the equipment to begin with.
	if(!action_checks(target))
		return

	if(isliving(target))
		var/mob/living/L = target
		L.apply_damage(force, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		playsound(src,'sound/weapons/fixer/generic/club2.ogg',40,TRUE)

	new /obj/effect/temp_visual/smash_effect(get_turf(target))

	return ..()

