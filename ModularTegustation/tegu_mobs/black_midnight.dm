#define STATUS_EFFECT_IRRATIONAL_FEAR /datum/status_effect/irrational_fear
#define STATUS_EFFECT_HEAVY_GUILT /datum/status_effect/stacking/heavy_guilt
//lore I guess. It's the personifcation of the greed agents have for better stuff. So if me and Baikal fucked this would be our child.
/mob/living/simple_animal/hostile/megafauna/black_midnight
	name = "Flowering Nights"
	desc = "A strange humanoid creature with roses for a head."
	health = 5000
	maxHealth = 5000
	damage_coeff = list(RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0)
	attack_sound = "sound/abnormalities/goldenapple/Gold_Attack.ogg"
	icon_state = "black_midnight_rose"
	icon_living = "black_midnight_rose"
	icon_dead = "black_midnight_rose"
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	faction = list("hostile")
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	movement_type = GROUND
	speak_emote = list("says")
	melee_damage_type = PALE_DAMAGE
	melee_damage_lower = 5
	melee_damage_upper = 10
	stat_attack = HARD_CRIT
	speed = 1.5
	move_to_delay = 3
	rapid_melee = 2
	blood_volume = BLOOD_VOLUME_NORMAL
	del_on_death = FALSE
	ranged = TRUE
	ranged_cooldown_time = 5
	death_message = "falls to the ground, decaying into glowing particles."
	death_sound = 'ModularTegustation/Tegusounds/claw/death.ogg'
	patrol_cooldown_time = 5 SECONDS
	can_patrol = TRUE
	light_color = COLOR_ORANGE
	light_range = 0
	light_power = 0
	var/can_move = FALSE
	var/can_act = TRUE
	var/current_phase = "rose"
	var/damage_taken = 0
	var/list/been_hit = list()
	var/datum/ordeal/ordeal_reference
	//Var Lists
	// 1=name 2=disc 3=melee damage type 4=lower damage 5= upper damage 6=icon 7=file location 8=x offset 9=y offset
	var/list/phase_stats = list(
		"rose" = list("Flowering Night","A strange humanoid creature with roses for a head..",PALE_DAMAGE,5,10, "black_midnight_rose", 'ModularTegustation/Teguicons/32x64.dmi',0,0,'sound/abnormalities/goldenapple/Gold_Attack.ogg'),
		"distort" = list("Distortion", "An eldritch looking humanoid.",RED_DAMAGE,20,40,"John_Distortion", 'ModularTegustation/Teguicons/64x64.dmi',-16,-16,'sound/weapons/punch1.ogg'),
		"oberon" = list("Fairy King", "A being resembling Titania.", BLACK_DAMAGE,75,75, "fairy_king",'ModularTegustation/Teguicons/64x64.dmi',-16,0,'sound/weapons/slash.ogg'),
		"twilight" = list("Twilight", "A beast that seems to be hunting something...", RED_DAMAGE,150,180, "Twilight",'ModularTegustation/Teguicons/160x128.dmi',-64,-16, 'sound/abnormalities/nosferatu/attack.ogg'),
		"paradise" = list("Paradise Lost", "Manager you fucked up big time!", PALE_DAMAGE,120,140,"white_night",'ModularTegustation/Teguicons/64x64.dmi',-16,-16,'sound/weapons/ego/paradise.ogg')
	)
	var/list/modular_damage_coeff = list(
		"rose" = list(RED_DAMAGE = 0.3, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0),
		"distort" = list(RED_DAMAGE = 0.3, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 0.5),
		"oberon" = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0, PALE_DAMAGE = 0.3),
		"twilight" = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 0.3),
		"paradise" = list(RED_DAMAGE = 0.2, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.2, PALE_DAMAGE = 0.2),
	)
	//Rose form vars
	var/rose_timer
	var/rose_timer_warning
	var/rose_attack_timer
	var/rose_attack_cooldown = 10 SECONDS
	//Distort form vars
	var/list/meltdowns = list()
	//1 = damage type, 2 = lower damage, 3 = upper damage, 4 = rapid melee, 5 = icon, 6 = attack sound
	var/list/weapon_stats = list(
		"mimicry" = list(RED_DAMAGE,70,90,2, "distortion_mimicry", 'sound/abnormalities/nothingthere/attack.ogg'),//no I'm not going to give this life steal
		"dacapo" = list(WHITE_DAMAGE,45,55,4, "distortion_dacapo",'sound/weapons/ego/da_capo1.ogg'), // look into stealing kiries dqcapo mirror guy code
		"adoration" = list(BLACK_DAMAGE,70,90,0.75, "distortion_adoration",'sound/abnormalities/wrath_servant/big_smash1.ogg'), //has 60 black aoe so its more like 130-150 black
		"distortion" = list(RED_DAMAGE,45,45,1, "distortion^2",'sound/weapons/ego/heavy_guard.ogg'), // does 45 red, white, black, and pale
	)
	var/current_weapon
	var/list/weapon_type = list("mimicry","dacapo","adoration")
	var/distort_second_phase = FALSE
	var/distort_weapon_special
	var/distort_weapon_special_cooldown = 25 SECONDS
	var/distort_weapon_swap
	var/distort_weapon_swap_cooldown = 45 SECONDS
	var/obj/viscon_filtereffect/distortedform/current_effect
	var/distorted_meltdown_punish
	var/distorted_meltdown_punish_cooldown = 90 SECONDS
	//oberon vars
	var/fairy_spawn_number = 2
	var/oberon_fairy_spawn_time
	var/oberon_fairy_spawn_cooldown = 5 SECONDS
	var/oberon_fairy_spawn_limit = 25 // Oh boy, what can go wrong?
	var/list/oberon_spawned_fairies = list()
	var/oberon_flower_spawn_time
	var/oberon_flower_spawn_cooldown = 1 MINUTES
	var/oberon_flower_spawn_limit = 6
	var/list/oberon_spawned_flowers = list()
	var/oberon_flower_power = 0
	var/oberon_flower_speed = 0
	var/oberon_flower_defense = 0
	var/oberon_chokehold
	var/oberon_chokehold_cooldown = 20 SECONDS
	//twilight vars
	var/twilight_ranged
	var/twilight_ranged_cooldown = 45 SECONDS
	var/twilight_melee
	var/twilight_melee_cooldown = 20 SECONDS
	var/list/twilight_enchanted_list = list()
	//paradise vars
	var/list/apostles = list()// Currently spawned apostles by this mob
	var/paradise_aura
	var/paradise_aura_cooldown = 1 MINUTES
	var/paradise_aura_range = 64
	var/paradise_aura_damage = 120
	var/paradise_ability
	var/paradise_ability_cooldown = 30 SECONDS
	var/cross_ability
	var/cross_ability_cooldown = 30 SECONDS
	var/paradise_lifetime

/mob/living/simple_animal/hostile/megafauna/black_midnight/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_FLOATING_ANIM, ROUNDSTART_TRAIT) // Imagine floating.
	rose_timer = world.time + 4 MINUTES
	rose_timer_warning = world.time + 3 MINUTES


/mob/living/simple_animal/hostile/megafauna/black_midnight/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	switch(current_phase)
		if("rose")
			if(rose_timer_warning <= world.time)
				rose_timer_warning = world.time + 900 MINUTES
				Rose_Warn()
			if(rose_timer <= world.time)
				rose_timer = world.time + 900 MINUTES
				Rose_Bloom()
		if("distort")
			// Apply and refresh status effect to all humans nearby
			for(var/mob/living/carbon/human/H in view(7, src))
				if(H.stat == DEAD)
					continue
				if(faction_check_mob(H))
					continue
				H.apply_status_effect(STATUS_EFFECT_IRRATIONAL_FEAR)
			if(health <= 1500 && !distort_second_phase)
				Weapon_DF()
			if(distort_weapon_swap <= world.time)
				Weapon_Swap()
			if(distorted_meltdown_punish <= world.time)
				addtimer(CALLBACK(src, PROC_REF(CauseMelts)), 10)//spent too long trying to heal? Then suffer a meltdown!
				distorted_meltdown_punish = distorted_meltdown_punish_cooldown + world.time
		if("oberon")
			if(oberon_fairy_spawn_time <= world.time)
				oberon_fairy_spawn_time = world.time + oberon_fairy_spawn_cooldown
				FairySpawn()
			if(oberon_flower_spawn_time <= world.time)
				oberon_flower_spawn_time = world.time + oberon_flower_spawn_cooldown
				FlowerSpawn()
		if("twilight")
			if(twilight_ranged <= world.time)
				if(prob(50))
					SoulJudgement()
				else
					BrilliantEyes()
		if("paradise")
			if(paradise_aura < world.time)
				for(var/mob/living/simple_animal/hostile/apostle/scythe/guardian_black/G in apostles)
					if(G in view(10, src)) // Only teleport them if they are not in view.
						continue
					var/turf/T = get_step(src, pick(NORTH,SOUTH,WEST,EAST))
					G.forceMove(T)
				revive_humans()
			if(cross_ability < world.time)
				CrossSpawn()
			if(paradise_lifetime < world.time)
				adjustHealth(maxHealth)

/mob/living/simple_animal/hostile/megafauna/black_midnight/death()
	if(health > 0)
		return
	if(current_phase != "paradise")
		switch(current_phase)
			if("rose")
				Transform("distort")
			if("distort")
				Transform("oberon")
			if("oberon")
				Transform("twilight")
			if("twilight")
				Transform("paradise")
		return
	if(ordeal_reference)
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	animate(src, alpha = 0, time = 20)
	QDEL_IN(src, 20)
	return ..()

/mob/living/simple_animal/hostile/megafauna/black_midnight/Destroy()
	if(ordeal_reference)
		ordeal_reference.OnMobDeath(src)
		ordeal_reference = null
	..()

/mob/living/simple_animal/hostile/megafauna/black_midnight/gib()
	if(current_phase != "paradise")
		if(health < maxHealth * 0.2)
			switch(current_phase)
				if("rose")
					return Transform("distort")
				if("distort")
					return Transform("oberon")
				if("oberon")
					return Transform("twilight")
				if("twilight")
					return Transform("paradise")
		return
	return ..()


/mob/living/simple_animal/hostile/megafauna/black_midnight/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(isliving(user))
		var/mob/living/L = user
		var/datum/status_effect/stacking/heavy_guilt/HG = L.has_status_effect(STATUS_EFFECT_HEAVY_GUILT)
		if(HG)
			if(prob(50))
				HG.add_stacks(-1)
				to_chat(L, span_nicegreen("You feel your sins are fading!"))
			if(prob(10 * HG.stacks))
				Comeuppance(target)

/mob/living/simple_animal/hostile/megafauna/black_midnight/bullet_act(obj/projectile/P)
	. = ..()
	if(isliving(P.firer))
		var/mob/living/L = P.firer
		var/datum/status_effect/stacking/heavy_guilt/HG = L.has_status_effect(STATUS_EFFECT_HEAVY_GUILT)
		if(HG)
			if(prob(50))
				HG.add_stacks(-1)
				to_chat(L, span_nicegreen("You feel your sins are fading!"))
			if(prob(10 * HG.stacks))
				Comeuppance(target)

// Modified patrolling
/mob/living/simple_animal/hostile/megafauna/black_midnight/patrol_select()
	if(current_phase == "twilight" || current_phase == "paradise")
		var/list/target_turfs = list() // Stolen from Punishing Bird
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.z != z) // Not on our level
				continue
			if(get_dist(src, H) < 4) // Unnecessary for this distance
				continue
			target_turfs += get_turf(H)

		var/turf/target_turf = get_closest_atom(/turf/open, target_turfs, src)
		if(istype(target_turf))
			patrol_path = get_path_to(src, target_turf, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 200)
			return
	return ..()

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/TransformSR()
	Transform("rose")

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/TransformDF()
	Transform("distort")

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/TransformNI()
	Transform("oberon")

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/TransformAB()
	Transform("twilight")

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/TransformWN()
	Transform("paradise")

//Transformations
/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/Transform(form)
	current_phase = form
	can_move = FALSE
	can_act = FALSE
	adjustHealth(-maxHealth)
	alpha = 0
	rapid_melee = 1
	clear_filters()
	vis_contents.Cut()
	current_effect = null
	for(var/mob/living/A in oberon_spawned_fairies)
		A.death()
	for(var/mob/living/A2 in oberon_spawned_flowers)
		A2.death()
	for(var/mob/living/carbon/human/H in twilight_enchanted_list)
		EndEnchant(H)
	ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))
	if(!HAS_TRAIT(src, TRAIT_NO_FLOATING_ANIM))
		ADD_TRAIT(src, TRAIT_NO_FLOATING_ANIM, ROUNDSTART_TRAIT)
	new /obj/effect/temp_visual/distortedform_shift(get_turf(src))
	distort_second_phase = FALSE
	for(var/area/facility_hallway/F in GLOB.sortedAreas)
		F.big_bird = FALSE
		F.RefreshLights()
	for(var/area/department_main/D in GLOB.sortedAreas)
		D.big_bird = FALSE
		D.RefreshLights()
	light_range = 0
	light_power = 0
	update_light()
	sleep(3)
	alpha = 255
	can_move = TRUE
	can_act = TRUE
	ChangeResistances(modular_damage_coeff[current_phase])
	name = phase_stats[current_phase][1]
	desc = phase_stats[current_phase][2]
	melee_damage_type = phase_stats[current_phase][3]
	melee_damage_lower = phase_stats[current_phase][4]
	melee_damage_upper = phase_stats[current_phase][5]
	icon_state = phase_stats[current_phase][6]
	icon = phase_stats[current_phase][7]
	pixel_x = phase_stats[current_phase][8]
	base_pixel_x = phase_stats[current_phase][8]
	pixel_y = phase_stats[current_phase][9]
	base_pixel_y = phase_stats[current_phase][9]
	attack_sound = phase_stats[current_phase][10]
	damage_taken = 0
	update_icon()
	switch(current_phase)
		if("rose")
			can_move = FALSE
			rose_timer = world.time + 4 MINUTES
			rose_timer_warning = world.time + 3 MINUTES
		if("distort")
			DFApplyFilters()
			addtimer(CALLBACK(src, PROC_REF(CauseMelts)), 10)
		if("oberon")
			move_to_delay = 2.5
			UpdateSpeed()
			REMOVE_TRAIT(src, TRAIT_NO_FLOATING_ANIM, ROUNDSTART_TRAIT)
		if("twilight")
			for(var/area/facility_hallway/F2 in GLOB.sortedAreas)
				F2.big_bird = TRUE
				F2.RefreshLights()
			for(var/area/department_main/D2 in GLOB.sortedAreas)
				D2.big_bird = TRUE
				D2.RefreshLights()
			move_to_delay = 2
			UpdateSpeed()
			light_range = 3
			light_power = 4
			update_light()
			REMOVE_TRAIT(src, TRAIT_NO_FLOATING_ANIM, ROUNDSTART_TRAIT)
		if("paradise")
			move_to_delay = 2.5
			UpdateSpeed()
			REMOVE_TRAIT(src, TRAIT_NO_FLOATING_ANIM, ROUNDSTART_TRAIT)
			ApostleSpawn()
			for(var/mob/M in GLOB.player_list)
				flash_color(M, flash_color = COLOR_RED, flash_time = 25)
			sound_to_playing_players('sound/abnormalities/whitenight/apostle_bell.ogg', 75)
			paradise_lifetime = world.time + 5 MINUTES

/mob/living/simple_animal/hostile/megafauna/black_midnight/Move()
	if(!can_move)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/megafauna/black_midnight/Moved()
	. = ..()
	if(current_phase == "distort")
		MoveVFX()

/mob/living/simple_animal/hostile/megafauna/black_midnight/OpenFire()
	if(!can_act)
		return FALSE
	switch(current_phase)
		if("rose")
			if(rose_attack_timer <= world.time)
				if(prob(50))
					Petal_Attack_Red()
				else
					Petal_Attack_White()
		if("distort")
			if(distort_weapon_special <= world.time && can_act)
				switch(current_weapon)
					if("mimicry")
						if(get_dist(src, target) < 4)
							Goodbye()
					if("dacapo")
						dacapo_slash(target)
					if("adoration")
						if(get_dist(src, target) < 4)
							adoration_slam()
					if("distortion")
						DistortedDash()
		if("oberon")
			if(oberon_chokehold <= world.time && can_act)
				if(get_dist(src, target) < 4)
					ChokeHold()
		if("paradise")
			if(paradise_ability <= world.time && can_act)
				if(get_dist(src, target) > 2)
					GangsAllHere()

/mob/living/simple_animal/hostile/megafauna/black_midnight/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	switch(current_phase)
		if("rose")
			if(rose_attack_timer <= world.time)
				if(prob(50))
					Petal_Attack_Red()
				else
					Petal_Attack_White()
		if("distort")
			if(current_weapon == "adoration")
				new /obj/effect/gibspawner/generic/silent/melty_slime(get_turf(target))
				for(var/turf/open/T in view(1, target))
					var/obj/effect/temp_visual/small_smoke/halfsecond/S = new(T)
					S.color = "#FF0081"
					var/list/got_hit = list()
					got_hit = HurtInTurf(T, got_hit, 60, BLACK_DAMAGE, null, TRUE, FALSE, TRUE)
					for(var/mob/living/L in got_hit)
						L.apply_status_effect(/datum/status_effect/melty_slimed)
					for(var/mob/living/carbon/H in got_hit)
						if(H.health <= 0)
							SlimeConvert(H)
			if("distortion")
				if(!ishuman(target))
					return
				var/mob/living/H = target
				for(var/damage_type in list(WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE))
					H.apply_damage(melee_damage_lower, damage_type, null, H.run_armor_check(null, damage_type))

			if(distort_weapon_special <= world.time  && can_act)
				switch(current_weapon)
					if("mimicry")
						Goodbye()
					if("dacapo")
						dacapo_slash(attacked_target)
					if("adoration")
						adoration_slam()
					if("distortion")
						DistortedDash()
		if("oberon")
			if(isliving(target))
				var/mob/living/L = target
				L.apply_damage(melee_damage_lower, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
				if(L.health <= 0)
					say("#$R&% H%&$#!")
					L.gib()
					new /mob/living/simple_animal/hostile/fairy_flower/pale(get_turf(L))//Spawns a flower
			if(oberon_chokehold <= world.time && can_act)
				ChokeHold()
		if("twilight")
			if(isliving(target))
				var/mob/living/L = target
				var/datum/status_effect/stacking/heavy_guilt/HG = L.has_status_effect(STATUS_EFFECT_HEAVY_GUILT)
				if(HG && prob(50))
					HG.add_stacks(1)
		if("paradise")
			if(paradise_ability <= world.time && can_act)
				if(get_dist(src, target) > 2)
					GangsAllHere()
	return ..()

/mob/living/simple_animal/hostile/megafauna/black_midnight/CanAttack(atom/the_target)
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/megafauna/black_midnight/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	switch(current_phase)
		if("rose")
			if(. > 0)
				damage_taken += .
			if(damage_taken >= 750)
				Petal_Attack_Pale()
		if("distort")
			if(. > 0)
				damage_taken += .
			if(damage_taken >= 500)
				distorted_meltdown_punish = distorted_meltdown_punish_cooldown + world.time

/mob/living/simple_animal/hostile/megafauna/black_midnight/bullet_act(obj/projectile/P)
	switch(current_phase)
		if("rose")
			visible_message(span_userdanger("[src] is unfazed by \the [P]!"))
			P.Destroy()
		if("distortion")
			visible_message(span_userdanger("[src] deflects \the [P]!"))
			P.Destroy()//melee it bozo


//rose procs
/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/Rose_Warn()
	sound_to_playing_players('sound/abnormalities/rose/meltdown.ogg')	//Church bells ringing, whether it happens or not.
	icon_state = "black_midnight_rose_red"
	update_icon()

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/Rose_Bloom()
	src.adjustBruteLoss(5000)
	SSweather.run_weather(/datum/weather/petals/short)

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/Petal_Attack_Red()
	rose_attack_timer = world.time + rose_attack_cooldown
	var/turf/area_of_effect = list()
	for(var/turf/L in view(10, src))
		if((get_dist(src, L) > 1) && (get_dist(src, L) < 5))
			if((L.x == x) || (L.y == y) || (L.x == (x - 1)) || (L.x == (x + 1)) || (L.y == (y - 1)) || (L.y == (y + 1)))
				continue
		new /obj/effect/temp_visual/cult/sparks(L)
		area_of_effect += L
	playsound(get_turf(src), 'sound/abnormalities/apocalypse/pre_attack.ogg', 50, 0, 5) // todo: find a better sfx set
	SLEEP_CHECK_DEATH(10)
	for(var/turf/T in area_of_effect)
		pick(new /obj/effect/temp_visual/red_aura(T), new /obj/effect/temp_visual/red_aura2(T), new /obj/effect/temp_visual/red_aura3(T))
		for(var/mob/living/carbon/human/H in HurtInTurf(T, list(), 150, RED_DAMAGE, null, null, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE))
			if(H.health <= 0)
				H.dust()
	playsound(get_turf(src), 'sound/weapons/fixer/generic/sword3.ogg', 50, 0, 5)
	visible_message(span_danger("[src] realeases red petals everywhere!"))

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/Petal_Attack_White()
	rose_attack_timer = world.time + rose_attack_cooldown
	var/turf/area_of_effect = list()
	for(var/turf/L in view(10, src))
		if((get_dist(src, L) <= 4)&&(L.x != x) && (L.y != y) && (L.x != (x - 1)) && (L.x != (x + 1)) && (L.y != (y - 1)) && (L.y != (y + 1)))
			continue
		new /obj/effect/temp_visual/cult/sparks(L)
		area_of_effect += L
	playsound(get_turf(src), 'sound/abnormalities/armyinblack/black_attack.ogg', 50, 0, 5)
	SLEEP_CHECK_DEATH(10)
	for(var/turf/T in area_of_effect)
		pick(new /obj/effect/temp_visual/white_aura(T), new /obj/effect/temp_visual/white_aura2(T), new /obj/effect/temp_visual/white_aura3(T))
		for(var/mob/living/carbon/human/H in HurtInTurf(T, list(), 150, WHITE_DAMAGE, null, null, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE))
			if(H.sanity_lost)
				H.dust()
	playsound(get_turf(src), 'sound/weapons/fixer/generic/sword3.ogg', 50, 0, 5)
	visible_message(span_danger("[src] realeases white petals everywhere!"))

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/Petal_Attack_Pale()
	var/turf/target_c = get_turf(src)
	var/list/turf_list = list()
	var/list/been_hit = list()
	damage_taken = 0
	for(var/turf/L in view(3, src))
		new /obj/effect/temp_visual/cult/sparks(L)
	playsound(get_turf(src), 'sound/abnormalities/ichthys/blast.ogg', 50, 0, 5) // todo: find a better sfx set
	SLEEP_CHECK_DEATH(10)
	playsound(get_turf(src), 'sound/weapons/fixer/generic/sword3.ogg', 50, 0, 5)
	visible_message(span_danger("[src] starts realease pale petals everywhere!"))
	for(var/i = 1 to 10)
		turf_list = spiral_range_turfs(i, target_c) - spiral_range_turfs(i-1, target_c)
		for(var/turf/open/T in turf_list)
			pick(new /obj/effect/temp_visual/pale_aura(T), new /obj/effect/temp_visual/pale_aura2(T), new /obj/effect/temp_visual/pale_aura3(T))
			var/list/new_hits = HurtInTurf(T, been_hit, 90, PALE_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, hurt_structure = TRUE) - been_hit
			been_hit += new_hits
			for(var/mob/living/carbon/H in new_hits)
				if(H.health <= 0)
					H.dust()
		SLEEP_CHECK_DEATH(3)

//Weather and such
/datum/weather/petals/short
	weather_duration_lower = 900		//1.5-2 minutes.
	weather_duration_upper = 1200

//distortion related stuff
/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/DFApplyFilters()
//Filter stuff - Generates a randomized displacement of the icon's sprites
	var/icon/filter_icon = new(icon, icon_state)
	var/newcolor = pick(COLOR_RED, COLOR_BLUE, COLOR_YELLOW, COLOR_GREEN, COLOR_PURPLE, COLOR_ORANGE)
	filter_icon.Blend(newcolor,ICON_MULTIPLY)
	filters += filter(type="displace", size=3, icon=filter_icon, render_source = src)
	alpha = rand(150,255)
	qdel(filter_icon)
	current_effect = new() //Visual contents - An animation underlay for the icon
	current_effect.icon = icon
	current_effect.icon_state = icon_state
	current_effect.vis_flags |= VIS_UNDERLAY
	src.vis_contents += current_effect
	current_effect.render_target = "displace"
	var/size = rand(-5,5)
	var/size_end = rand(-10,10)
	current_effect.color = rgb(rand(120,255), rand(120,255), rand(120,255), rand(120,160))
	current_effect.filters += filter(type="displace", size=rand(5,10), render_source="displace")
	var/f1 = current_effect.filters[current_effect.filters.len]
	animate(f1, size = size,time=10,loop=-1)
	animate(size = size_end, time=10)
	update_icon()

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/MoveVFX()
	set waitfor = FALSE
	var/obj/viscon_filtereffect/distortedform_trail/trail = new(src.loc,themob = src, waittime = 5)
	trail.vis_contents += src
	trail.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=2, color=rgb(0, 250, 229))
	trail.filters += filter(type = "blur", size = 3)
	animate(trail, alpha=120)
	animate(alpha = 0, time = 10)

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/CauseMelts(datum/source, datum/abnormality/abno_datum, worked)
	var/meltdown_text = "Horrible screeches have caused a disturbance in the containment zones of the following abnormalities:"
	var/meltdown_sound = pick(
		"sound/abnormalities/distortedform/screech3.ogg",
		"sound/abnormalities/distortedform/screech4.ogg",
	)
	var/player_count = 0
	for(var/mob/player in GLOB.player_list)
		if(isliving(player) && (player.mind?.assigned_role in GLOB.security_positions))
			player_count += 1.5
	player_count = round(player_count) + (player_count > round(player_count) ? TRUE : FALSE) // Trying to round up
	meltdowns = SSlobotomy_corp.InitiateMeltdown(clamp(rand(player_count*0.5, player_count), 1, 10), TRUE, MELTDOWN_BLACK, 45, 60, meltdown_text, meltdown_sound)
	for(var/obj/machinery/computer/abnormality/A in meltdowns) // TODO: Figure out a way to exclude it entirely from melts so it doesn't breach itself.
		RegisterSignal(A, COMSIG_MELTDOWN_FINISHED, PROC_REF(SpecialMeltFinish))

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/SpecialMeltFinish(datum/source, datum/abnormality/abno_datum, worked)
	SIGNAL_HANDLER
	if(!LAZYLEN(meltdowns))
		return
	meltdowns -= source
	UnregisterSignal(source, COMSIG_MELTDOWN_FINISHED)
	var/list/breaching_list = shuffle(GLOB.abnormality_mob_list)
	if(!worked)
		for(var/mob/living/simple_animal/hostile/abnormality/A in breaching_list)
			if(A.datum_reference.qliphoth_meter > 0 && A.IsContained() && A.z == z)
				A.datum_reference.qliphoth_change(-200)
				return

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/Weapon_Swap()
	if(!can_act || distort_weapon_swap > world.time || distort_second_phase)
		return
	current_weapon = pick(weapon_type)
	can_move = FALSE
	can_act = FALSE
	alpha = 0
	new /obj/effect/temp_visual/distortedform_shift(get_turf(src))
	sleep(3)
	alpha = 255
	can_move = TRUE
	can_act = TRUE
	melee_damage_type = weapon_stats[current_weapon][1]
	melee_damage_lower = weapon_stats[current_weapon][2]
	melee_damage_upper = weapon_stats[current_weapon][3]
	rapid_melee = weapon_stats[current_weapon][4]
	icon_state = weapon_stats[current_weapon][5]
	attack_sound  = weapon_stats[current_weapon][6]
	distort_weapon_swap = world.time + distort_weapon_swap_cooldown
	update_icon()
	if(current_weapon == "distortion")
		ChangeResistances(list(RED_DAMAGE = 0.15, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0.15, PALE_DAMAGE = 0.25))
		move_to_delay = 4.5
		UpdateSpeed()
	else
		ChangeResistances(modular_damage_coeff[current_phase])
		move_to_delay = 3
		UpdateSpeed()

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/Weapon_DF()
	if(!can_act || distort_second_phase)
		return
	distorted_meltdown_punish = distorted_meltdown_punish_cooldown + world.time
	distort_second_phase = TRUE
	current_weapon = "distortion"
	can_move = FALSE
	can_act = FALSE
	alpha = 0
	new /obj/effect/temp_visual/distortedform_shift(get_turf(src))
	sleep(3)
	alpha = 255
	can_move = TRUE
	can_act = TRUE
	melee_damage_type = weapon_stats[current_weapon][1]
	melee_damage_lower = weapon_stats[current_weapon][2]
	melee_damage_upper = weapon_stats[current_weapon][3]
	rapid_melee = weapon_stats[current_weapon][4]
	icon_state = weapon_stats[current_weapon][5]
	attack_sound  = weapon_stats[current_weapon][6]
	update_icon()
	ChangeResistances(list(RED_DAMAGE = 0.15, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0.15, PALE_DAMAGE = 0.25))
	move_to_delay = 4.5
	UpdateSpeed()

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/Goodbye()
	if(distort_weapon_special > world.time)
		return
	distort_weapon_special = world.time + distort_weapon_special_cooldown
	can_act = FALSE
	can_move = FALSE
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/goodbye_cast.ogg', 75, 0, 5)
	icon_state = "distortion_mimicry_attack"
	for(var/turf/L in view(4, src))
		new /obj/effect/temp_visual/cult/sparks(L)
	new /obj/effect/temp_visual/distortedvisage/distortedvisage/nt(get_turf(src))
	SLEEP_CHECK_DEATH(12)
	for(var/turf/T in view(4, src))
		new /obj/effect/temp_visual/nt_goodbye(T)
		for(var/mob/living/L in HurtInTurf(T, list(), 500, RED_DAMAGE, null, TRUE, FALSE, TRUE, hurt_hidden = TRUE, hurt_structure = TRUE))
			if(L.health < 0)
				L.gib()
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/goodbye_attack.ogg', 75, 0, 7)
	SLEEP_CHECK_DEATH(3)
	icon_state = "distortion_mimicry"
	can_act = TRUE
	can_move = TRUE

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/dacapo_slash(atom/target)
	if(!istype(target) || QDELETED(target))
		return
	if(distort_weapon_special > world.time)
		return
	distort_weapon_special = world.time + distort_weapon_special_cooldown
	can_act = FALSE
	can_move = FALSE
	face_atom(get_step(src,SOUTH))
	playsound(src, 'ModularTegustation/Tegusounds/claw/prepare.ogg', 100, 1)
	icon_state = "distortion_dacapo_attack"
	new /obj/effect/temp_visual/distortedvisage/distortedvisage/tso(get_turf(src))
	var/turf/TT = get_turf(target)
	face_atom(TT)
	SLEEP_CHECK_DEATH(12)
	playsound(src, 'ModularTegustation/Tegusounds/claw/move.ogg', 100, 1)
	var/turf/T = get_turf(src)
	var/angle_to_target = Get_Angle(T, TT)
	var/angle = angle_to_target + 120
	if(angle > 360)
		angle -= 360
	else if(angle < 0)
		angle += 360
	var/turf/T2 = get_turf_in_angle(angle, T, 10)
	var/list/line = getline(T, T2)
	DoLineAttack(line)
	for(var/i = 1 to 40)//twice as much compared to the claw but since it has more range and angle, it being twice means it helps to fill in holes
		angle += ((240 / 40) * -1)
		if(angle > 360)
			angle -= 360
		else if(angle < 0)
			angle += 360
		T2 = get_turf_in_angle(angle, T, 8)
		line = getline(T, T2)
		DoLineAttack(line)
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	icon_state = "distortion_dacapo"
	can_act = TRUE
	can_move = TRUE

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/DoLineAttack(list/line)
	for(var/turf/T in line)
		if(locate(/obj/effect/temp_visual/small_smoke/second) in T)
			continue
		new /obj/effect/temp_visual/sparkles(T)
		new /obj/effect/temp_visual/small_smoke/second(T)
		for(var/mob/living/L in T)
			if(L.stat == DEAD)
				continue
			if(L.status_flags & GODMODE)
				continue
			if(faction_check_mob(L))
				continue
			L.apply_damage(300, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE))

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/SlimeConvert(mob/living/carbon/human/H)
	if(!istype(H))
		return FALSE
	visible_message(span_danger("[H] gets melted by the slime as a slime pawn appears!"))
	new /mob/living/simple_animal/hostile/slime(get_turf(H))
	H.gib()
	return TRUE

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/adoration_slam()//To Do: Make it say "SHE DOES NOT LOVE YOU" when you have melting loves gift.
	if(!istype(target) || QDELETED(target))
		return
	if(distort_weapon_special > world.time)
		return
	face_atom(get_step(src,SOUTH))
	distort_weapon_special = world.time + distort_weapon_special_cooldown
	can_act = FALSE
	can_move = FALSE
	playsound(src, 'sound/abnormalities/meltinglove/pawn_big_convert.ogg', 100, 1)
	icon_state = "distortion_adoration_attack"
	new /obj/effect/temp_visual/distortedvisage/distortedvisage/ml(get_turf(src))
	SLEEP_CHECK_DEATH(20)
	slime_aoe(2,'sound/abnormalities/wrath_servant/big_smash2.ogg')
	icon_state = "distortion_adoration_attack_down"
	SLEEP_CHECK_DEATH(5)
	icon_state = "distortion_adoration_attack"
	SLEEP_CHECK_DEATH(7)
	slime_aoe(4,'sound/abnormalities/wrath_servant/big_smash3.ogg')
	icon_state = "distortion_adoration_attack_down"
	SLEEP_CHECK_DEATH(5)
	icon_state = "distortion_adoration_attack"
	SLEEP_CHECK_DEATH(7)
	slime_aoe(6,'sound/abnormalities/apocalypse/slam.ogg')
	icon_state = "distortion_adoration_attack_down"
	for(var/mob/living/M in livinginrange(20, get_turf(src)))
		shake_camera(M, 2, 3)
	SLEEP_CHECK_DEATH(20)
	icon_state = "distortion_adoration"
	can_act = TRUE
	can_move = TRUE

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/slime_aoe(size, sound)
	playsound(src, sound, 100, 1)
	for(var/turf/open/T in view(size, get_turf(src)))
		var/obj/effect/temp_visual/small_smoke/halfsecond/S = new(T)
		S.color = "#FF0081"
		if(prob(35))
			new /obj/effect/gibspawner/generic/silent/melty_slime(T)
		var/list/got_hit = list()
		got_hit = HurtInTurf(T, got_hit, 200, BLACK_DAMAGE, null, TRUE, FALSE, TRUE)
		for(var/mob/living/L in got_hit)
			L.apply_status_effect(/datum/status_effect/melty_slimed)
		for(var/mob/living/carbon/H in got_hit)
			if(H.health <= 0)
				SlimeConvert(H)

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/DistortedDash()
	if(!istype(target) || QDELETED(target))
		return
	if(distort_weapon_special > world.time)
		return
	face_atom(get_step(src,SOUTH))
	can_act = FALSE
	can_move = FALSE
	icon_state = "distortion_rage"
	playsound(src, "sound/abnormalities/distortedform/screech4.ogg", 75, FALSE, 8)
	new /obj/effect/temp_visual/distortedvisage/distortedvisage/df(get_turf(src))
	for(var/i = 1 to 8)
		new /obj/effect/temp_visual/fragment_song(get_turf(src))
	SLEEP_CHECK_DEATH(20)
	SwiftDash(target, 25, 20,0)

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/SwiftDash(mob/living/target, distance, wait_time,dash_amount)
	been_hit = list()
	var/turf/end_turf = get_ranged_target_turf_direct(src, target, distance, 0)
	var/list/turf_list = getline(src, end_turf)
	for(var/turf/T in turf_list)
		new /obj/effect/temp_visual/cult/sparks(T)
	playsound(src, "sound/abnormalities/distortedform/screech2.ogg", 85, 1)
	face_atom(target)
	SLEEP_CHECK_DEATH(wait_time)
	for(var/turf/T in turf_list)
		if(!istype(T))
			break
		if(T.density)//Unlike claw this dash wont get it stuck in a wall
			MegaDashAoe()
			for(var/mob/living/M in livinginrange(20, get_turf(src)))
				playsound(src, "sound/abnormalities/distortedform/slam.ogg", 100, 1)
				shake_camera(M, 2, 3)
			break
		forceMove(T)
		playsound(src,'ModularTegustation/Tegusounds/claw/move.ogg', 50, 1)
		for(var/turf/T2 in view(1,src))
			new /obj/effect/temp_visual/small_smoke/halfsecond(T2)
			var/list/new_hits = HurtInTurf(T2, been_hit, 25, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE) - been_hit
			been_hit += new_hits
			for(var/mob/living/carbon/L in new_hits)
				L.throw_at(get_edge_target_turf(L, dir), 5, 2)
				if ishuman(L)
					for(var/damage_type in list(WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE))
						L.apply_damage(25, damage_type, null, L.run_armor_check(null, damage_type))
		if(T != turf_list[turf_list.len]) // Not the last turf
			SLEEP_CHECK_DEATH(0.25)
	if(dash_amount < 3)
		SLEEP_CHECK_DEATH(10)
		if(ishuman(target))
			if(!locate(target) in view(vision_range,src))
				DfGrab(target, dash_amount)//pull them back in if they're hiding
				return
		SwiftDash(target, 25, 20,dash_amount+1)
		return
	SLEEP_CHECK_DEATH(4 SECONDS)
	icon_state = "distortion^2"
	distort_weapon_special = world.time + distort_weapon_special_cooldown//I placed it here so that way it can't be nearly done after dashing
	can_act = TRUE
	can_move = TRUE

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/MegaDashAoe()
	for(var/turf/T in view(3,src))
		new /obj/effect/temp_visual/small_smoke(T)
		for(var/mob/living/carbon/L in HurtInTurf(T, list(), 25, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE))
			var/atom/throw_target = get_edge_target_turf(L, get_dir(L, get_step_away(L, get_turf(src))))
			L.throw_at(throw_target, 5, 2)
			if ishuman(L)
				for(var/damage_type in list(WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE))
					L.apply_damage(25, damage_type, null, L.run_armor_check(null, damage_type))

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/DfGrab(mob/living/carbon/human/target,dash_amount)
	face_atom(get_step(src,SOUTH))
	playsound(target, 'sound/abnormalities/fairy_longlegs/attack.ogg', 50, FALSE)
	target.Immobilize(15)
	if(target.sanity_lost)
		target.Stun(15) //Immobilize does not stop AI controllers from moving, for some reason.
	target.add_overlay(icon('icons/effects/effects.dmi', "distortedgrab"))
	addtimer(CALLBACK(target, TYPE_PROC_REF(/atom, cut_overlay), \
							icon('icons/effects/effects.dmi', "distortedgrab")), 10)
	var/list/all_turfs = RANGE_TURFS(1, src) //We need to grab the player, but also have them be visible.
	for(var/turf/T in all_turfs)
		if(T == get_turf(src))
			continue
		if(get_dir(src,T) == NORTH) //directly north is icky, blocks view.
			continue
		var/list/target_line = getline(T, src)
		var/available_turf
		for(var/turf/line_turf in target_line)
			if(line_turf.is_blocked_turf(exclude_mobs = TRUE))
				available_turf = FALSE
				break
			available_turf = TRUE
		if(!available_turf)
			continue
		target.forceMove(T)
		break
	SLEEP_CHECK_DEATH(10)
	SwiftDash(target, 25, 20,dash_amount+1)

/obj/effect/temp_visual/distortedvisage
	name = "Visual Distortion"
	render_target = "displace"
	appearance_flags = PASS_MOUSE | KEEP_TOGETHER
	vis_flags = VIS_INHERIT_ID | VIS_INHERIT_DIR | VIS_UNDERLAY
	duration = 10 SECONDS
	var/obj/viscon_filtereffect/distortedform/current_effect

/obj/effect/temp_visual/distortedvisage/Initialize()
	. = ..()
	vis_flags |= VIS_UNDERLAY
	var/icon/filter_icon = new(icon, icon_state)
	var/newcolor = pick(COLOR_RED, COLOR_BLUE, COLOR_YELLOW, COLOR_GREEN, COLOR_PURPLE, COLOR_ORANGE)
	filter_icon.Blend(newcolor,ICON_MULTIPLY)
	filters += filter(type="displace", size=3, icon=filter_icon, render_source = src)
	alpha = rand(125,230)
	qdel(filter_icon)
	current_effect = new() //Visual contents - An animation underlay for the icon
	current_effect.icon = icon
	current_effect.icon_state = icon_state
	current_effect.vis_flags |= VIS_UNDERLAY
	src.vis_contents += current_effect
	current_effect.render_target = "displace"
	var/size = rand(-5,5)
	var/size_end = rand(-10,10)
	current_effect.color = rgb(rand(120,255), rand(120,255), rand(120,255), rand(120,160))
	current_effect.filters += filter(type="displace", size=rand(5,10), render_source="displace")
	var/f1 = current_effect.filters[current_effect.filters.len]
	animate(f1, size = size,time=10,loop=-1)
	animate(size = size_end, time=10)
	update_icon()

/obj/effect/temp_visual/distortedvisage/distortedvisage/nt
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "nothing_blade"
	duration = 16
	pixel_x = -16
	base_pixel_x = -16

/obj/effect/temp_visual/distortedvisage/distortedvisage/tso
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "silent"
	duration = 18

/obj/effect/temp_visual/distortedvisage/distortedvisage/ml
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "SHE DOES NOT LOVE YOU"
	pixel_x = -32
	base_pixel_x = -32
	duration = 20

/obj/effect/temp_visual/distortedvisage/distortedvisage/df
	icon = 'ModularTegustation/Teguicons/128x128.dmi'
	icon_state = "distortedform"
	pixel_x = -48
	base_pixel_x = -48
	duration = 20

//weaker version of censored's effect
/datum/status_effect/irrational_fear
	id = "irrational_fear"
	status_type = STATUS_EFFECT_REFRESH
	duration = 20 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/irrational_fear
	/// The damage will not be done below that percentage of max sanity
	var/sanity_limit_percent = 0.25
	/// How much percents of max sanity is dealt as pure sanity damage each tick
	var/sanity_damage_percent = 0.05

/atom/movable/screen/alert/status_effect/irrational_fear
	name = "Irrational Fear"
	desc = "Just looking at that thing makes you feel uneasy. Your sanity will be slowly lowering to 75%."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "level3"

/datum/status_effect/irrational_fear/on_apply()
	if(!ishuman(owner))
		return FALSE
	return ..()

/datum/status_effect/irrational_fear/tick()
	. = ..()
	var/mob/living/carbon/human/status_holder = owner
	if(status_holder.getSanityLoss() >= status_holder.getMaxSanity() * sanity_limit_percent)
		return
	status_holder.adjustSanityLoss(status_holder.getMaxSanity() * sanity_damage_percent)

//fairy king stuff

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/FairySpawn()
	//Blurb about how many we have spawned
	listclearnulls(oberon_spawned_fairies)
	for(var/mob/living/L in oberon_spawned_fairies)
		if(L.stat == DEAD)
			qdel(L)
			oberon_spawned_fairies -= L
	if(length(oberon_spawned_fairies) >= oberon_fairy_spawn_limit)
		return
	//Actually spawning them
	for(var/i=fairy_spawn_number, i>=1, i--)	//This counts down.
		var/mob/living/simple_animal/hostile/bairyswarm/V = new(get_turf(src))
		V.faction = faction
		oberon_spawned_fairies+=V

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/FlowerSpawn()
	//Blurb about how many we have spawned
	listclearnulls(oberon_spawned_flowers)
	for(var/mob/living/L in oberon_spawned_flowers)
		if(L.stat == DEAD)
			qdel(L)
			oberon_spawned_flowers -= L
	if(length(oberon_spawned_flowers) >= oberon_flower_spawn_limit)
		return
	var/list/spawns = GLOB.xeno_spawn.Copy()
	var/A = pick_n_take(spawns)
	var/turf/T = get_turf(A)
	if(locate(/mob/living/simple_animal/hostile/fairy_flower) in get_turf(T))//Needs to be tested in a multiplayer environment
		T = get_ranged_target_turf(T, pick(GLOB.alldirs), 1)//This will move the target's turf to an adjacent one, preventing stacking and visual clutter to some degree.
	var/flower=pick(/mob/living/simple_animal/hostile/fairy_flower/power,/mob/living/simple_animal/hostile/fairy_flower/speed,/mob/living/simple_animal/hostile/fairy_flower/defense)
	var/mob/living/simple_animal/hostile/fairy_flower/F = new flower(T)//Spawns the flower
	F.master = src
	F.Boost()
	oberon_spawned_flowers+=F

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/FlowerPowerCalc()
	if(current_phase == "oberon")
		melee_damage_lower = 75 + oberon_flower_power
		melee_damage_upper = 75 + oberon_flower_power

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/FlowerSpeedCalc()
	if(current_phase == "oberon")
		move_to_delay = 2.5 - oberon_flower_speed
		UpdateSpeed()

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/FlowerDefenseCalc()
	if(current_phase == "oberon")
		ChangeResistances(list(RED_DAMAGE = 0.5 - oberon_flower_defense, WHITE_DAMAGE = 0.3 - oberon_flower_defense, BLACK_DAMAGE = 0 - oberon_flower_defense, PALE_DAMAGE = 0.3 - oberon_flower_defense))

//The Mini fairies
/mob/living/simple_animal/hostile/bairyswarm
	name = "fairy"
	desc = "A tiny, extremely hungry fairy."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "fairyswarm_black_midnight"
	icon_living = "fairyswarm_black_midnight"
	pass_flags = PASSTABLE | PASSMOB
	is_flying_animal = TRUE
	density = FALSE
	can_patrol = TRUE//why yes they are meant to be little shitters
	ranged = 1
	retreat_distance = 6
	minimum_distance = 1
	a_intent = INTENT_HARM
	health = 550
	maxHealth = 550
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 0.6)
	melee_damage_lower = 20
	melee_damage_upper = 20
	melee_damage_type = RED_DAMAGE
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	attack_verb_continuous = "cuts"
	attack_verb_simple = "cut"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	mob_size = MOB_SIZE_TINY
	del_on_death = TRUE

/mob/living/simple_animal/hostile/bairyswarm/Initialize()
	. = ..()
	pixel_x = rand(-16, 16)
	pixel_y = rand(-16, 16)

/mob/living/simple_animal/hostile/bairyswarm/AttackingTarget(atom/attacked_target)
	if(isliving(attacked_target))
		var/mob/living/L = attacked_target
		L.apply_damage(melee_damage_lower, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
	return ..()

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/ChokeHold()
	if(oberon_chokehold > world.time)
		return
	oberon_chokehold = world.time + oberon_chokehold_cooldown
	can_act = FALSE
	can_move = FALSE
	var/turf_list = list()
	icon_state = "fairy_king_attack"
	playsound(get_turf(src), 'sound/abnormalities/woodsman/woodsman_prepare.ogg', 75, 0, 5)
	for(var/turf/L in view(4 + (oberon_flower_power/15), src))//adds up to 6 range to its aoe
		new /obj/effect/temp_visual/cult/sparks(L)
		turf_list += L//add it to a list incase a flower spawns during the down time
	SLEEP_CHECK_DEATH(16)
	for(var/turf/T in turf_list)
		new /obj/effect/temp_visual/nobody_grab(T)
		for(var/mob/living/L in HurtInTurf(T, list(), 300, BLACK_DAMAGE, null, TRUE, FALSE, TRUE, hurt_hidden = TRUE, hurt_structure = TRUE))
			if(L.health < 0)
				L.gib()
				new /mob/living/simple_animal/hostile/fairy_flower/pale(get_turf(L))//Spawns a flower
			if(L.health >= 0)
				if(!L.buckled)
					var/mob/living/simple_animal/hostile/fairy_vines/N = new(get_turf(L))
					N.grab_victim = L
					N.Strangle()
	playsound(get_turf(src), 'sound/abnormalities/fairy_longlegs/attack.ogg', 75, 0, 3)
	SLEEP_CHECK_DEATH(5)
	icon_state = "fairy_king"
	can_act = TRUE
	can_move = TRUE

/mob/living/simple_animal/hostile/fairy_flower
	mob_size = MOB_SIZE_HUGE
	gender = NEUTER
	name = "Fairy Flower"
	desc = "You shouldn't see this"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "rose_red"
	maxHealth = 800
	health = 800
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.2, PALE_DAMAGE = 0.8)
	del_on_death = TRUE
	var/mob/living/simple_animal/hostile/megafauna/black_midnight/master
	var/fpower = 0
	var/fspeed = 0
	var/fdefense = 0

/mob/living/simple_animal/hostile/fairy_flower/Move()
	return FALSE

/mob/living/simple_animal/hostile/fairy_flower/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/fairy_flower/proc/Boost()
	if(!master)
		return
	master.oberon_flower_power += fpower
	master.oberon_flower_speed += fspeed
	master.oberon_flower_defense += fdefense
	master.FlowerPowerCalc()
	master.FlowerSpeedCalc()
	master.FlowerDefenseCalc()

/mob/living/simple_animal/hostile/fairy_flower/death()
	if(master)
		master.oberon_flower_power -= fpower
		master.oberon_flower_speed -= fspeed
		master.oberon_flower_defense -= fdefense
		master.FlowerPowerCalc()
		master.FlowerSpeedCalc()
		master.FlowerDefenseCalc()
	..()

/mob/living/simple_animal/hostile/fairy_flower/power
	name = "Fairy Attack Flower"
	desc = "A spikey looking flower that's causing that thing to become stronger!"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "rose_red"
	fpower = 15

/mob/living/simple_animal/hostile/fairy_flower/speed
	name = "Fairy Speed Flower"
	desc = "A sleek looking flower that's causing that thing to become faster!"
	icon_state = "rose_white"
	fspeed = 0.25

/mob/living/simple_animal/hostile/fairy_flower/defense
	name = "Fairy Defense Flower"
	desc = "A tough looking flower that's causing that thing to become tankier!"
	icon_state = "rose_black"
	fdefense = 0.05

//this one only spawns when someone dies to fairy king
/mob/living/simple_animal/hostile/fairy_flower/pale
	name = "Fairy Flower"
	desc = "A flower that's causing that thing to become more powerful!"
	icon_state = "rose_pale"
	fpower = 15
	fspeed = 0.25
	fdefense = 0.05

/mob/living/simple_animal/hostile/fairy_vines
	name = "Twisted Tentacles"
	desc = "Strange pink tentacles that are binding someone!"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "fairy_king_vines"
	maxHealth = 800
	health = 800
	faction = list("hostile")
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 0.2, PALE_DAMAGE = 0.8)
	density = TRUE
	del_on_death = TRUE
	mob_size = MOB_SIZE_HUGE
	gender = NEUTER
	layer = ABOVE_MOB_LAYER
	var/mob/living/carbon/human/grab_victim = null

/mob/living/simple_animal/hostile/fairy_vines/Move()
	return FALSE

/mob/living/simple_animal/hostile/fairy_vines/CanAttack(atom/the_target)//should only attack when it has fists
	return FALSE

/mob/living/simple_animal/hostile/fairy_vines/Initialize()
	. = ..()
	QDEL_IN(src, 12 SECONDS)

/mob/living/simple_animal/hostile/fairy_vines/proc/Strangle()
	set waitfor = FALSE
	grab_victim.Immobilize(10)
	if(grab_victim.sanity_lost)
		grab_victim.Stun(10) //Immobilize does not stop AI controllers from moving, for some reason.
	face_atom(grab_victim)
	grab_victim.forceMove(get_turf(src))
	SLEEP_CHECK_DEATH(5)
	to_chat(grab_victim, span_userdanger("[src] has grabbed you! Damage the [src] to break free!"))
	StrangleHit()

/mob/living/simple_animal/hostile/fairy_vines/proc/StrangleHit(count)
	if(!grab_victim)
		qdel(src)
		return
	if(grab_victim.health < 0)
		grab_victim.gib()
		return
	grab_victim.apply_damage(15, RED_DAMAGE, null, grab_victim.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
	grab_victim.Immobilize(10)
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_bam.ogg', 50, 0, 7)
	playsound(get_turf(src), 'sound/abnormalities/nobodyis/strangle.ogg', 100, 0, 7)
	playsound(get_turf(src), 'sound/effects/wounds/crack2.ogg', 200, 0, 7)
	if(grab_victim.sanity_lost) //This should prevent weird things like panics running away halfway through
		grab_victim.Stun(10) //Immobilize does not stop AI controllers from moving, for some reason.
	SLEEP_CHECK_DEATH(10)
	StrangleHit()

//twilight stuff

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/SoulJudgement()
	if(twilight_ranged > world.time || !can_act)
		return
	can_act = FALSE
	can_move = FALSE
	sound_to_playing_players_on_level('sound/abnormalities/apocalypse/judge.ogg', 75, zlevel = z)
	twilight_ranged = world.time + twilight_ranged_cooldown
	icon_state = "Twilight_arms"
	SLEEP_CHECK_DEATH(5 SECONDS)
	sound_to_playing_players_on_level('sound/abnormalities/judgementbird/ability.ogg', 75, zlevel = z)
	for(var/mob/living/L in GLOB.mob_living_list)
		var/check_z = L.z
		if(isatom(L.loc))
			check_z = L.loc.z
		if(check_z != z)
			continue
		if(faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		new /obj/effect/temp_visual/judgement(get_turf(L))
		var/datum/status_effect/stacking/heavy_guilt/HG = L.has_status_effect(STATUS_EFFECT_HEAVY_GUILT)
		if(HG)
			L.apply_damage(50+ (HG.stacks * 10), PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
		if(!HG)
			L.apply_damage(50, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
			HG = L.apply_status_effect(STATUS_EFFECT_HEAVY_GUILT)
		HG.add_stacks(2)
		if(L.health <= 0 && L.stat != DEAD)
			L.death()
			var/turf/T = get_turf(L)
			if(locate(/obj/structure/jbird_noose) in T)
				T = pick_n_take(T.reachableAdjacentTurfs())//if a noose is on this tile, it'll still create another one. You probably shouldn't be letting this many people die to begin with
				L.forceMove(T)
			var/obj/structure/jbird_noose/N = new(get_turf(L))
			N.buckle_mob(L)
			playsound(get_turf(L), 'sound/abnormalities/judgementbird/kill.ogg', 75, 0, 7)
			playsound(get_turf(L), 'sound/abnormalities/judgementbird/hang.ogg', 100, 0, 7)
			new /mob/living/simple_animal/hostile/runawaybird(get_turf(L))
			new /mob/living/simple_animal/hostile/runawaybird(get_turf(L))
			new /mob/living/simple_animal/hostile/runawaybird(get_turf(L))
	SLEEP_CHECK_DEATH(1 SECONDS)
	icon_state = "Twilight"
	can_act = TRUE
	can_move = TRUE

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/BrilliantEyes()
	if(twilight_ranged > world.time || !can_act)
		return
	can_act = FALSE
	can_move = FALSE
	light_power = 7
	light_range = 5
	sound_to_playing_players_on_level('sound/abnormalities/apocalypse/enchant.ogg', 80, zlevel = z)
	twilight_ranged = world.time + twilight_ranged_cooldown
	icon_state = "Twilight_eyes"
	var/list/candidates = list()
	for(var/i = 1 to 24)
		var/atom/PT = src // Shoot it somewhere, idk
		if(LAZYLEN(candidates))
			PT = pick(candidates)
		var/turf/T = get_step(get_turf(src), pick(GLOB.alldirs))
		var/obj/projectile/twilight/P = new(T)
		P.starting = T
		P.firer = src
		P.fired_from = T
		P.yo = PT.y - T.y
		P.xo = PT.x - T.x
		P.original = PT
		P.preparePixelProjectile(PT, T)
		addtimer(CALLBACK (P, TYPE_PROC_REF(/obj/projectile, fire)), 5 SECONDS)
	SLEEP_CHECK_DEATH(5 SECONDS)
	sound_to_playing_players_on_level('sound/abnormalities/apocalypse/fire.ogg', 75, zlevel = z)
	for(var/mob/living/L in GLOB.mob_living_list)
		var/check_z = L.z
		if(isatom(L.loc))
			check_z = L.loc.z
		if(check_z != z)
			continue
		if(faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			H.adjust_blindness(1)
		var/datum/status_effect/stacking/heavy_guilt/HG = L.has_status_effect(STATUS_EFFECT_HEAVY_GUILT)
		if(HG)
			if(HG.stacks >= 5 && ishuman(L))
				twilight_enchanted_list.Add(L)
				to_chat(L, "<span class='boldwarning'>You see a light glowing in the distance!")
	SLEEP_CHECK_DEATH(1 SECONDS)
	for(var/mob/living/carbon/human/H in twilight_enchanted_list)
		H.ai_controller = /datum/ai_controller/insane/enchanted_black
		H.InitializeAIController()
		H.add_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "enchanted", -HALO_LAYER))
		addtimer(CALLBACK(src, PROC_REF(EndEnchant), H), 30 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)
	icon_state = "Twilight"
	light_range = 3
	light_power = 4
	can_act = TRUE
	can_move = TRUE

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/EndEnchant(mob/living/carbon/human/victim)
	if(victim in twilight_enchanted_list)
		twilight_enchanted_list.Remove(victim)
		victim.cut_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "enchanted", -HALO_LAYER))
		if(istype(victim.ai_controller,/datum/ai_controller/insane/enchanted_black))
			to_chat(victim, "<span class='boldwarning'>You snap out of your trance!")
			qdel(victim.ai_controller)

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/Comeuppance(mob/living/target)
	if(!istype(target) || QDELETED(target))
		return
	if(twilight_melee > world.time)
		return
	twilight_melee = world.time + twilight_melee_cooldown
	icon_state = "Twilight_beak"
	playsound(src, 'sound/abnormalities/apocalypse/pre_attack.ogg', 125, FALSE, 4)
	can_act = FALSE
	can_move = FALSE
	visible_message(span_danger("[src] opens its mouth and is about to dash towards someone!"))
	var/turf/end_turf = get_ranged_target_turf_direct(src, target, get_dist(src, target) + 6, 0)
	var/list/turf_list = getline(src, end_turf)
	for(var/turf/T in turf_list)
		new /obj/effect/temp_visual/cult/sparks(T)
	face_atom(target)
	SLEEP_CHECK_DEATH(2 SECONDS)
	for(var/turf/T in turf_list)
		if(!istype(T))
			break
		if(locate(target) in view(1,src))
			BeakAttack()
			break
		if(T.density)//Unlike claw this dash wont get it stuck in a wall
			break
		forceMove(T)

		if(T != turf_list[turf_list.len]) // Not the last turf
			SLEEP_CHECK_DEATH(0.25)
	SLEEP_CHECK_DEATH(2 SECONDS)
	icon_state = "Twilight"
	can_act = TRUE
	can_move = TRUE

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/BeakAttack()
	playsound(src, 'sound/abnormalities/apocalypse/beak.ogg', 100, FALSE, 12)
	for(var/turf/T in view(3,src))
		new /obj/effect/temp_visual/beakbite(T)
		for(var/mob/living/carbon/L in HurtInTurf(T, list(), 500, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE))
			to_chat(L, "<span class='boldwarning'>[src] devours you!")
			if(L.health < 0)
				L.gib()

/datum/status_effect/stacking/heavy_guilt
	id = "TWILIGHT"
	status_type = STATUS_EFFECT_UNIQUE
	stacks = 0
	stack_decay = 0 //Without this the stacks were decaying after 1 sec
	duration = 45 SECONDS //Lasts for 4 minutes
	alert_type = /atom/movable/screen/alert/status_effect/heavy_guilt
	max_stacks = 10
	var/stage = 0
	consumed_on_threshold = FALSE

/atom/movable/screen/alert/status_effect/heavy_guilt
	name = "Heavy Guilt"
	desc = "You feel your sins crawling on your back... Current Stacks: "
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "heavy_guilt"


/datum/status_effect/stacking/heavy_guilt/add_stacks(stacks_added)
	if(stacks <= 0 && stacks_added < 0)
		qdel(src)
	stacks += stacks_added
	if(stacks > max_stacks)
		stacks = 10
	duration = world.time + 45 SECONDS
	if(stacks > 6)
		linked_alert.icon_state = "heavy_guilt3"
		linked_alert.desc = "You feel your sins crawling on your back... Current Stacks: [stacks]"
		linked_alert.update_icon()
		stage = 3
	if(stacks > 3 && stacks <= 6)
		linked_alert.icon_state = "heavy_guilt2"
		linked_alert.update_icon()
		linked_alert.desc = "You feel something weighing you down.. Current Stacks: [stacks]"
		stage = 2
	if(stacks > 0 && stacks <= 3)
		linked_alert.icon_state = "heavy_guilt"
		linked_alert.update_icon()
		linked_alert.desc = "You feel something watching you... Current Stacks: [stacks]"
		stage = 1

/datum/ai_controller/insane/enchanted_black
	lines_type = /datum/ai_behavior/say_line/insanity_enchanted
	var/last_message = 0

/datum/ai_controller/insane/enchanted_black/SelectBehaviors(delta_time)
	..()
	if(blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] != null)
		return

	var/mob/living/simple_animal/hostile/megafauna/black_midnight/bird
	for(var/mob/living/simple_animal/hostile/megafauna/black_midnight/M in GLOB.mob_living_list)
		if(!istype(M))
			continue
		bird = M
	if(bird)
		current_behaviors += GET_AI_BEHAVIOR(/datum/ai_behavior/enchanted_move_black)
		blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = bird

/datum/ai_controller/insane/enchanted_black/PerformIdleBehavior(delta_time)
	var/mob/living/living_pawn = pawn
	if(DT_PROB(30, delta_time) && (living_pawn.mobility_flags & MOBILITY_MOVE) && isturf(living_pawn.loc) && !living_pawn.pulledby)
		var/move_dir = pick(GLOB.alldirs)
		living_pawn.Move(get_step(living_pawn, move_dir), move_dir)
	if(DT_PROB(25, delta_time))
		current_behaviors += GET_AI_BEHAVIOR(lines_type)

/datum/ai_behavior/enchanted_move_black

/datum/ai_behavior/enchanted_move_black/perform(delta_time, datum/ai_controller/insane/enchanted_black/controller)
	. = ..()

	var/mob/living/carbon/human/living_pawn = controller.pawn

	if(IS_DEAD_OR_INCAP(living_pawn))
		return

	var/mob/living/simple_animal/hostile/megafauna/black_midnight/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	if(!istype(target))
		finish_action(controller, FALSE)
		return

	if(!LAZYLEN(controller.current_path))
		controller.current_path = get_path_to(living_pawn, target, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 80)
		if(!controller.current_path.len) // Returned FALSE or null.
			finish_action(controller, FALSE)
			return
		controller.current_path.Remove(controller.current_path[1])
		Movement(controller)

/datum/ai_behavior/enchanted_move_black/proc/Movement(datum/ai_controller/insane/enchanted_black/controller)
	var/mob/living/carbon/human/living_pawn = controller.pawn
	var/mob/living/simple_animal/hostile/megafauna/apocalypse_bird/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]

	if(world.time > controller.last_message + 10 SECONDS)
		controller.last_message = world.time
		controller.current_behaviors += GET_AI_BEHAVIOR(controller.lines_type)
		living_pawn.Immobilize(10 SECONDS)

	if(LAZYLEN(controller.current_path) && !IS_DEAD_OR_INCAP(living_pawn))
		var/target_turf = controller.current_path[1]
		if(target_turf && get_dist(living_pawn, target_turf) < 3)
			if(!step_towards(living_pawn, target_turf))
				controller.pathing_attempts++
			if(controller.pathing_attempts >= MAX_PATHING_ATTEMPTS)
				finish_action(controller, FALSE)
				return FALSE
			else
				if(get_turf(living_pawn) == target_turf)
					controller.current_path.Remove(target_turf)
					controller.pathing_attempts = 0
					if(isturf(target.loc) && (target in view(3,living_pawn)))
						finish_action(controller, TRUE)
						return
				else
					controller.pathing_attempts++
			var/move_delay = living_pawn.cached_multiplicative_slowdown + 0.1
			addtimer(CALLBACK(src, PROC_REF(Movement), controller), move_delay)
			return TRUE
	finish_action(controller, FALSE)
	return FALSE

/datum/ai_behavior/enchanted_move_black/finish_action(datum/ai_controller/insane/enchanted_black/controller, succeeded)
	. = ..()
	var/mob/living/carbon/human/living_pawn = controller.pawn
	var/mob/living/simple_animal/hostile/megafauna/black_midnight/target = controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET]
	controller.pathing_attempts = 0
	controller.current_path = list()
	if(succeeded)
		target.EndEnchant(living_pawn)
		living_pawn.Immobilize(50)
	controller.blackboard[BB_INSANE_CURRENT_ATTACK_TARGET] = null

/obj/projectile/twilight
	name = "light"
	icon_state = "apocalypse"
	damage_type = BLACK_DAMAGE
	damage = 50
	alpha = 0
	spread = 45
	projectile_phasing = (ALL & (~PASSMOB))
	light_color = COLOR_ORANGE
	light_range = 2
	light_power = 5

/obj/projectile/twilight/Initialize()
	. = ..()
	animate(src, alpha = 255, pixel_x = rand(-10,10), pixel_y = rand(-10,10), time = 5 SECONDS)

/obj/projectile/twilight/on_hit(target)
	. = ..()
	if(isliving(target))
		var/mob/living/simple_animal/M = target
		M.adjust_blindness(4)

//wn procs
/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/ApostleSpawn()
	for(var/i = 1 to 11)
		var/apostle_type = /mob/living/simple_animal/hostile/apostle/scythe
		if(i in list(1,11))
			apostle_type = /mob/living/simple_animal/hostile/apostle/scythe/guardian_black
		if(i in list(4,5,6))
			apostle_type = /mob/living/simple_animal/hostile/apostle/staff
		if(i in list(7,8,9,10))
			apostle_type = /mob/living/simple_animal/hostile/apostle/spear
		apostles += new apostle_type(get_turf(src))
		var/list/possible_locs = GLOB.xeno_spawn.Copy()
		for(var/mob/living/simple_animal/hostile/apostle/A in apostles)
			if(istype(A, /mob/living/simple_animal/hostile/apostle/scythe/guardian_black))
				continue
			var/turf/T = pick(possible_locs)
			A.forceMove(T)
			if(length(possible_locs) > 1)
				possible_locs -= T

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/revive_humans(range_override = null, faction_check = "apostle")
	if(paradise_aura > world.time)
		return
	if(!can_act)
		return
	if(range_override == null)
		range_override = paradise_aura_range
	paradise_aura = (world.time + paradise_aura_cooldown)
	been_hit = list()
	playsound(src, 'sound/abnormalities/whitenight/apostle_spell.ogg', 75, 1, range_override)
	var/turf/target_c = get_turf(src)
	var/list/turf_list = list()
	for(var/i = 1 to range_override)
		turf_list = spiral_range_turfs(i, target_c) - spiral_range_turfs(i-1, target_c)
		for(var/turf/open/T in turf_list)
			var/obj/effect/temp_visual/cult/sparks/S = new(T)
			if(faction_check != "apostle")
				S.color = "#AAFFAA" // Indicating that it's a good thing
			for(var/obj/structure/closet/C in T)
				for(var/mob/living/L in C)
					if(ishuman(L))
						C.Destroy()
						break
			for(var/mob/living/L in T)
				new /obj/effect/temp_visual/dir_setting/cult/phase(T, L.dir)
				addtimer(CALLBACK(src, PROC_REF(revive_target), L, i, faction_check))
		SLEEP_CHECK_DEATH(1.5)

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/revive_target(mob/living/L, attack_range = 1, faction_check = "apostle")
	if(L in been_hit)
		return
	been_hit += L
	if(!(faction_check in L.faction))
		playsound(L.loc, 'sound/machines/clockcult/ark_damage.ogg', 50 - attack_range, TRUE, -1)
		// The farther you are from white night - the less damage it deals
		var/dealt_damage = max(5, paradise_aura_damage - attack_range)
		L.apply_damage(dealt_damage, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
		if(ishuman(L) && dealt_damage > 25)
			L.emote("scream")
		to_chat(L, span_userdanger("The holy light... IT BURNS!!"))
	else
		if(istype(L, /mob/living/simple_animal/hostile/apostle) && L.stat == DEAD)
			L.revive(full_heal = TRUE, admin_revive = FALSE)
			L.grab_ghost(force = TRUE)
			to_chat(L, span_notice("The holy light compels you to live!"))
		else if(L.stat != DEAD)
			L.adjustBruteLoss(-(paradise_aura_damage * 0.75) * (L.maxHealth/100))
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				H.adjustSanityLoss(-(paradise_aura_damage * 0.75) * (H.maxSanity/100))
			L.regenerate_limbs()
			L.regenerate_organs()
			to_chat(L, span_notice("The holy light heals you!"))

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/GangsAllHere()
	if(paradise_ability > world.time)
		return
	if(!can_act)
		return
	paradise_ability = paradise_ability_cooldown + world.time
	for(var/mob/living/simple_animal/hostile/apostle/G in apostles)
		var/turf/T = get_step(src, pick(NORTH,SOUTH,WEST,EAST))
		G.forceMove(T)
		if(G.stat == DEAD)
			G.revive(full_heal = TRUE, admin_revive = FALSE)
			G.grab_ghost(force = TRUE)
			to_chat(G, span_notice("The holy light compels you to live!"))

/mob/living/simple_animal/hostile/megafauna/black_midnight/proc/CrossSpawn()
	if(cross_ability > world.time)
		return
	if(!can_act)
		return
	cross_ability = world.time + cross_ability_cooldown
	var/list/targets = list()
	for(var/mob/living/L in livinginrange(40, src))
		if(L.z != z)
			continue
		if(L.status_flags & GODMODE)
			continue
		if(faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		targets += L
		for(var/i = 1 to 4)
			if(targets.len > 0)
				var/mob/living/L2 = pick(targets)
				new /obj/effect/crossspawner(get_turf(L2), faction)
				targets -= L2

/obj/effect/crossspawner
	name = "cross summon"
	desc = "A target warning you of incoming pain"
	icon = 'icons/effects/effects.dmi'
	icon_state = "crosswarning"
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	var/list/faction = list("hostile")
	var/damage_done = 100
	layer = POINT_LAYER	//We want this HIGH. SUPER HIGH. We want it so that you can absolutely, guaranteed, see exactly what is about to hit you.

/obj/effect/crossspawner/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(crosspawn)), 3.5 SECONDS)

/obj/effect/crossspawner/New(loc, ...)
	. = ..()
	if(args[2])
		faction = args[2]

/obj/effect/crossspawner/proc/crosspawn()
	alpha = 0
	new /obj/effect/temp_visual/unholycross/fall(get_turf(src))
	sleep(5.5)
	visible_message("<span class='warning'>A giant upside down cross falls down on the ground!</span>")
	playsound(get_turf(src), 'sound/effects/impact_thunder.ogg', 50, FALSE)
	playsound(get_turf(src), 'sound/effects/impact_thunder_far.ogg', 25, FALSE, 7)
	var/obj/effect/temp_visual/unholycross/C = new(get_turf(src))
	animate(C, alpha = 0, transform = matrix()*2, time = 10)
	for(var/turf/open/TF in view(6, get_turf(src)))
		new /obj/effect/temp_visual/small_smoke/halfsecond(TF)
	for(var/mob/living/L in view(6, get_turf(src)))
		if(faction_check(faction, L.faction, FALSE))
			continue
		var/distance_decrease = get_dist(get_turf(src), L) * 10
		L.apply_damage((damage_done - distance_decrease), PALE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE))
		new /obj/effect/temp_visual/revenant(get_turf(L))
	qdel(src)

/mob/living/simple_animal/hostile/apostle/scythe/guardian_black
	name = "guardian apostle"
	health = 3000
	maxHealth = 3000
	move_to_delay = 7
	melee_damage_type = PALE_DAMAGE
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5)
	vision_range = 12
	aggro_vision_range = 12
	patrol_cooldown_time = 2.5 SECONDS
	scythe_range = 3
	scythe_cooldown_time = 8 SECONDS // More often, since the damage increase was disliked.
	scythe_damage_type = PALE_DAMAGE
	scythe_damage = 150 // It's a big AoE unlike base game where it's smaller and as it is you straight up die unless you have 7+ Pale resist. You also have TWO of these AND WN hitting you for ~80 Pale at this range.

/mob/living/simple_animal/hostile/apostle/scythe/guardian_black/CanStartPatrol()
	if(locate(/mob/living/simple_animal/hostile/megafauna/black_midnight) in view(9, src))
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/apostle/scythe/guardian_black/patrol_select()
	var/mob/living/simple_animal/hostile/megafauna/black_midnight/PL = locate() in GLOB.mob_list
	if(!istype(PL))
		return
	var/turf/target_turf = pick(RANGE_TURFS(2, PL))
	patrol_path = get_path_to(src, target_turf, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 200)
	playsound(get_turf(src), 'sound/abnormalities/whitenight/apostle_growl.ogg', 75, FALSE)
	TemporarySpeedChange(-4, 5 SECONDS) // OUT OF MY WAY

/mob/living/simple_animal/hostile/apostle/scythe/guardian_black/ScytheAttack()
	if(scythe_cooldown > world.time)
		return
	scythe_cooldown = world.time + scythe_cooldown_time
	can_act = FALSE
	for(var/turf/T in view(scythe_range, src))
		new /obj/effect/temp_visual/cult/sparks(T)
	SLEEP_CHECK_DEATH(10)
	var/gibbed = FALSE
	for(var/turf/T in view(scythe_range, src))
		new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/L in T) // Not changing this one because it notable does not gib pre-dead bodies, only living ones.
			if(L.stat == DEAD)
				continue
			if(faction_check_mob(L))
				continue
			L.apply_damage(scythe_damage, scythe_damage_type, null, L.run_armor_check(null, scythe_damage_type), spread_damage = TRUE)
			if(L.stat == DEAD) // Total overkill
				for(var/i = 1 to 5) // Alternative to gib()
					new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))
				new /obj/effect/gibspawner/generic/silent(get_turf(L))
				gibbed = TRUE
	playsound(get_turf(src), (gibbed ? 'sound/abnormalities/whitenight/scythe_gib.ogg' : 'sound/abnormalities/whitenight/scythe_spell.ogg'), (gibbed ? 100 : 75), FALSE, (gibbed ? 12 : 5))
	SLEEP_CHECK_DEATH(5)
	can_act = TRUE