/mob/living/simple_animal/hostile/distortion/Bremen
	name = "The Musicians of Bremen"
	desc = "A horrible amalgamation of noises and animals."
	icon = 'ModularTegustation/Teguicons/Ensemble96x96.dmi'
	icon_state = "Bremen"
	icon_living = "Bremen"
	icon_dead = "Bremen"
	faction = list("hostile", "crimsonOrdeal", "bongy")
	maxHealth = 12500
	health = 12500
	move_to_delay = 10
	melee_damage_lower = 120
	melee_damage_upper = 150
	rapid_melee = 0.25
	pixel_x = -34
	pixel_y = -10
	melee_damage_type = BLACK_DAMAGE
	ranged_ignores_vision = TRUE
	ranged = TRUE
	minimum_distance = 4
	damage_coeff = list(RED_DAMAGE = 0.6, WHITE_DAMAGE = -1, BLACK_DAMAGE = 0.2, PALE_DAMAGE = 1)
	move_resist = MOVE_FORCE_OVERPOWERING
	simple_mob_flags = SILENCE_RANGED_MESSAGE
	is_flying_animal = FALSE
	del_on_death = TRUE
	can_patrol = TRUE
	attack_sound = 'sound/distortions/Bremen_Strong.ogg'
	melee_reach = 3
//Variables important for distortions
	//The EGO worn by the egoist
	ego_list = list(
		/obj/item/clothing/suit/armor/ego_gear/city/ensemble,
		)
	//The egoist's name, if specified. Otherwise picks a random name.
	egoist_names = list("Musicians of Bremen")
	//The mob's gender, which will be inherited by the egoist. Can be left unspecified for a random pick.
	gender = MALE
	//The Egoist's outfit, which should usually be civilian unless you want them to be a fixer or something.
	egoist_outfit = /datum/outfit/job/civilian
	//Loot on death; distortions should be valuable targets in general.
	loot = list(/obj/item/clothing/suit/armor/ego_gear/city/ensembleweak)
	/// Prolonged exposure to a monolith will convert the distortion into an abnormality. Black swan is the most strongly related to this guy, but I might make one for it later.
	monolith_abnormality = /mob/living/simple_animal/hostile/abnormality/silentorchestra //Musicians that bring ruin.
	egoist_attributes = 130
	can_spawn = 0
	var/unmanifesting
	var/last_command = 0
	//Delay on charge command
	var/chargecommand_cooldown = 0
	var/screech_cooldown = 0
	var/screech_windup = 5 SECONDS
	var/chargecommand_delay = 1 MINUTES
	//Delay on general commands
	var/command_cooldown = 0
	var/command_delay = 18 SECONDS
	//If this creature can act.
	var/can_act = TRUE
	var/pulse_cooldown
	var/pulse_cooldown_time = 10 SECONDS
	var/pulse_damage = 40
/mob/living/simple_animal/hostile/distortion/Bremen/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if((pulse_cooldown > world.time))
		return
	pulse_cooldown = world.time + pulse_cooldown_time
	WhitePulse()


/mob/living/simple_animal/hostile/distortion/Bremen/proc/WhitePulse()
	pulse_cooldown = world.time + pulse_cooldown_time
	playsound(src, 'sound/distortions/Bremen_Horse.ogg', 50, FALSE, 4)
	for(var/mob/living/L in livinginview(8, src))
		if(faction_check_mob(L))
			continue
		L.deal_damage(pulse_damage, WHITE_DAMAGE)
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))
//Bremen buffs attempt down here.
/mob/living/simple_animal/hostile/distortion/Bremen/handle_automated_action()
	. = ..()
	if(command_cooldown < world.time && target && can_act && stat != DEAD)
		switch(last_command)
			if(1)
				Command(2) //always buff defense at start of battle
			else
				Command(pick(2,3))

/mob/living/simple_animal/hostile/distortion/Bremen/patrol_select()
	if(prob(25))
		say("Woof.")
	..()

/mob/living/simple_animal/hostile/distortion/Bremen/Aggro()
	. = ..()
	if(chargecommand_cooldown <= world.time)
		Command(1)
		ranged_cooldown = world.time + (10 SECONDS)
		chargecommand_cooldown = world.time + chargecommand_delay
	a_intent_change(INTENT_HARM)

/mob/living/simple_animal/hostile/distortion/Bremen/LoseAggro()
	. = ..()
	a_intent_change(INTENT_HELP)

/mob/living/simple_animal/hostile/distortion/Bremen/OpenFire()
	if(can_act && ranged_cooldown <= world.time)
		ManagerScreech()
		ranged_cooldown = world.time + ranged_cooldown_time

/mob/living/simple_animal/hostile/distortion/Bremen/Move()
	if(!can_act)
		return FALSE
	return ..()

//used for attacks and commands. could possibly make this a modular spell or ability.
/mob/living/simple_animal/hostile/distortion/Bremen/proc/Command(manager_order)
	playsound(loc, 'sound/distortions/Bremen_Chicken.ogg', 60, TRUE)
	switch(manager_order)
		if(1)
			if(prob(20))
				say(pick("Bawk Bawk!", "Cock-a-Doodle-Doo!", "Bok Bok Bok.", "Cluck!"))
			for(var/mob/living/simple_animal/hostile/G in oview(20, src))
				if(istype(G, /mob/living/simple_animal/hostile) && G.stat != DEAD && (!has_status_effect(/datum/status_effect/all_armor_buff) || !has_status_effect(/datum/status_effect/minor_damage_buff)))
					G.GiveTarget(target)
					G.TemporarySpeedChange(-1, 1 SECONDS)
			last_command = 1
		if(2)
			say("Auk uh errrr kerrrrr!")
			for(var/mob/living/simple_animal/hostile/G in oview(9, src))
				if((istype(G, /mob/living/simple_animal/hostile) || istype(G, /mob/living/simple_animal/hostile/ordeal/steel_dawn)) && G.stat != DEAD && !has_status_effect((/datum/status_effect/all_armor_buff || /datum/status_effect/minor_damage_buff)))
					G.apply_status_effect(/datum/status_effect/all_armor_buff)
			last_command = 2
		if(3)
			say("Kikeriki!")
			for(var/mob/living/simple_animal/hostile/G in oview(9, src))
				if((istype(G, /mob/living/simple_animal/hostile) || istype(G, /mob/living/simple_animal/hostile/ordeal/steel_dawn)) && G.stat != DEAD && !has_status_effect((/datum/status_effect/all_armor_buff || /datum/status_effect/minor_damage_buff)))
					G.apply_status_effect(/datum/status_effect/minor_damage_buff)
			last_command = 3
	command_cooldown = world.time + command_delay

/mob/living/simple_animal/hostile/distortion/Bremen/proc/ManagerScreech()
	var/visual_overlay = mutable_appearance('icons/effects/effects.dmi', "blip")
	add_overlay(visual_overlay)
	can_act = FALSE
	if(!do_after(src, screech_windup, target = src))
		cut_overlay(visual_overlay)
		can_act = TRUE
		return
	can_act = TRUE
	cut_overlay(visual_overlay)
	playsound(loc, 'sound/distortions/Bremen_StrongFar.ogg', 60, TRUE)
	new /obj/effect/temp_visual/screech(get_turf(src))
	for(var/mob/living/L in oview(10, src))
		if(!faction_check_mob(L))
			L.apply_damage(400, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
