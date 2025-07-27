/obj/vehicle/sealed/mecha/combat
	force = 30
	internals_req_access = list(ACCESS_MECH_SCIENCE, ACCESS_MECH_SECURITY)
	internal_damage_threshold = 50
	armor = list(MELEE = 30, BULLET = 30, LASER = 15, ENERGY = 20, BOMB = 20, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	mouse_pointer = 'icons/effects/mouse_pointers/mecha_mouse.dmi'
	destruction_sleep_duration = 40
	exit_delay = 40

/obj/vehicle/sealed/mecha/combat/restore_equipment()
	mouse_pointer = 'icons/effects/mouse_pointers/mecha_mouse.dmi'
	return ..()


/obj/vehicle/sealed/mecha/combat/proc/max_ammo() //Max the ammo stored for Nuke Ops mechs, or anyone else that calls this
	for(var/obj/item/I in equipment)
		if(istype(I, /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/))
			var/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/gun = I
			gun.projectiles_cache = gun.projectiles_cache_max

/obj/vehicle/sealed/mecha/combat/attack_animal(mob/living/simple_animal/user)
	log_message("Attack by simple animal. Attacker - [user].", LOG_MECHA, color="red")
	if(!user.melee_damage_upper && !user.obj_damage)
		user.emote("custom", message = "[user.friendly_verb_continuous] [src].")
		return 0
	else
		var/play_soundeffect = 1
		if(user.environment_smash)
			play_soundeffect = 0
			playsound(src, 'sound/effects/bang.ogg', 50, TRUE)
		var/animal_damage = rand(user.melee_damage_lower,user.melee_damage_upper)
		log_combat(user, src, "attacked")
		attack_generic(user, animal_damage, user.melee_damage_type, MELEE, play_soundeffect)
		return 1
