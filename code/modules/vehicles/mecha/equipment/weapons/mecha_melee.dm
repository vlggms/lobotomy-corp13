/obj/item/mecha_parts/mecha_equipment/hammer
	name = "Rhino Hammer (Red)"
	desc = "Equipment for smashing and bashing. Does Red Damage"
	icon = 'ModularTegustation/Teguicons/workshop.dmi'
	icon_state = "hammertemplate"
	color = "#db2121"
	equip_cooldown = 15
	energy_drain = 10
	force = 200
	harmful = TRUE
	range = MECHA_MELEE
	mech_flags = EXOSUIT_MODULE_COMBAT
	damtype = RED_DAMAGE


/obj/item/mecha_parts/mecha_equipment/hammer/rhinoblade
	name = "Rhino Hammer (Black)"
	desc = "Equipment for cutting and slicing. Does Black damage"
	icon = 'ModularTegustation/Teguicons/workshop.dmi'
	icon_state = "hammertemplate"
	color = "#210f3d"
	equip_cooldown = 15
	energy_drain = 10
	force = 200
	harmful = TRUE
	range = MECHA_MELEE
	mech_flags = EXOSUIT_MODULE_COMBAT
	damtype = BLACK_DAMAGE


/obj/item/mecha_parts/mecha_equipment/hammer/action(mob/source, atom/target, params)
	// Check if we can even use the equipment to begin with.
	if(!action_checks(target))
		return

	if(isliving(target))
		var/mob/living/L = target
		//for the immunity/healing visual effects
		if(ishostile(target))
			var/mob/living/simple_animal/hostile/H = target
			H.attack_threshold_check(force, damtype)
		else
			L.apply_damage(force, damtype, null, L.run_armor_check(null, damtype), spread_damage = TRUE)
		if(prob(50))
			L.add_splatter_floor(get_turf(L))
		chassis.do_attack_animation(L)
		playsound(src, 'sound/weapons/fixer/generic/club2.ogg', 40, TRUE)
		chassis.visible_message(span_danger("[chassis.name] smashes [L] with [src]!"), ignored_mobs = list(source, L))
		to_chat(source, span_danger("You smash [L] with your [src]!"))
		to_chat(L, span_danger("[chassis.name] smashes you with [src]!"))
		log_combat(source, L, "attacked", src)
	else if(ismecha(target))
		var/obj/vehicle/sealed/mecha/M = target
		M.take_damage(force, damtype, attack_dir = get_dir(M, src))
		chassis.do_attack_animation(M)
		playsound(src, 'sound/weapons/fixer/generic/club2.ogg', 40, TRUE)
		chassis.visible_message(span_danger("[chassis.name] smashes [M.name] with [src]!"), ignored_mobs = M.occupants + source)
		to_chat(source, span_danger("You smash [M.name] with [src]!"))
		to_chat(M.occupants, span_danger("[chassis.name] smashes you with [src]!"))
		log_combat(source, M, "attacked", src)
	else if(isstructure(target) || ismachinery(target))
		var/obj/O = target
		O.take_damage(force / 2, damtype)
		chassis.do_attack_animation(O)
		playsound(src, 'sound/weapons/fixer/generic/club2.ogg', 40, TRUE)
	else
		playsound(src, 'sound/weapons/fwoosh.ogg', 70, TRUE)

	new /obj/effect/temp_visual/smash_effect(get_turf(target))
	return ..()
