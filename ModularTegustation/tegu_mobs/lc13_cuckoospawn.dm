/mob/living/simple_animal/hostile/cuckoospawn
	name = "niaojia-ren"
	desc = "A tall humaniod looking bird, with eyes glaring anything moving around it."
	icon = 'icons/mob/cuckoospawn_big.dmi'
	icon_state = "evil_ass_bird"
	icon_dead = "evil_ass_corpse"
	maxHealth = 300
	health = 300
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 1.5)
	faction = list("cuckoospawn")
	city_faction = FALSE
	stat_attack = HARD_CRIT
	stat_attack = HARD_CRIT
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 12
	melee_damage_upper = 14
	attack_sound = 'sound/creatures/lc13/lovetown/slam.ogg'
	rapid_melee = 2
	gender = NEUTER
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	robust_searching = TRUE
	see_in_dark = 7
	vision_range = 12
	aggro_vision_range = 20
	move_to_delay = 4
	butcher_results = list(/obj/item/food/meat/slab = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab = 1)
	blood_volume = BLOOD_VOLUME_NORMAL
	mob_size = MOB_SIZE_HUGE
	a_intent = INTENT_HARM
	var/attempted_crosses = 0
	var/bird_watching = FALSE //Time to remake Canto 8 Peak
	var/head_immunity_start
	var/head_immunity_duration = 1 MINUTES

/mob/living/simple_animal/hostile/cuckoospawn/Initialize()
	. = ..()
	head_immunity_start = world.time + head_immunity_duration
	RegisterSignal(src, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(CheckSpace))

/mob/living/simple_animal/hostile/cuckoospawn/proc/CheckSpace(mob/user, atom/new_location)
	if(head_immunity_start < world.time)
		var/turf/newloc_turf = get_turf(new_location)
		// var/valid_tile = TRUE

		var/area/new_area = get_area(newloc_turf)
		if(istype(new_area, /area/city))
			var/area/city/city_area = new_area
			if(city_area.in_city && !bird_watching)
				if(attempted_crosses > 10)
					executed_claw()
				attempted_crosses++
				to_chat(src, span_danger("You feel a shiver down your spine, the city will not allow you to enter..."))
				// valid_tile = FALSE

		// if(!valid_tile)
		// 	return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

/mob/living/simple_animal/hostile/cuckoospawn/AttackingTarget(atom/attacked_target)
	var/mob/living/carbon/human/human_target
	var/alive = FALSE
	if(ishuman(attacked_target))
		human_target = attacked_target
		if(human_target.stat != DEAD)
			alive = TRUE
	. = ..()
	if(isanimal(attacked_target))
		var/mob/living/simple_animal/easy_target = attacked_target
		easy_target.deal_damage(melee_damage_upper * 3, RED_DAMAGE)
	if(human_target.stat != DEAD && prob(5))
		var/obj/item/bodypart/chest/LC = human_target.get_bodypart(BODY_ZONE_CHEST)
		if((!LC || LC.status != BODYPART_ROBOTIC) && !human_target.getorgan(/obj/item/organ/body_egg/cuckoospawn_embryo) && !HAS_TRAIT(human_target, TRAIT_XENO_IMMUNE))
			new /obj/item/organ/body_egg/cuckoospawn_embryo(human_target)
			var/turf/T = get_turf(human_target)
			log_game("[key_name(human_target)] was impregnated by a cockoospawn at [loc_name(T)]")
	if(bird_watching && alive && human_target.stat == DEAD)
		var/obj/item/organ/body_egg/cuckoospawn_embryo/bursting_embryo = human_target.getorgan(/obj/item/organ/body_egg/cuckoospawn_embryo)
		if(bursting_embryo)
			bursting_embryo.AttemptGrow()

/mob/living/simple_animal/hostile/cuckoospawn/attackby(obj/item/O, mob/user, params)
	. = ..()
	if(faction.Find("neutral") && user.faction.Find("neutral"))
		faction -= "neutral"

/mob/living/simple_animal/hostile/cuckoospawn/examine(mob/user)
	. = ..()
	if(istype(user, /mob/living/carbon/human/species/cuckoospawn))
		to_chat(user, span_nicegreen("They are ready to follow your orders!"))

/mob/living/simple_animal/hostile/cuckoospawn/attack_hand(mob/living/carbon/M)
	if(stat || M.a_intent != INTENT_HELP || client || !istype(M, /mob/living/carbon/human/species/cuckoospawn))
		return ..()
	else
		var/bird_ask = alert("select command", "[src] recognizes your authority.", "Follow", "Stay", "Change Aggro", "Cancel")
		switch(bird_ask)
			if("Follow")
				walk_to(src, M, 2, move_to_delay)
				return
			if("Stay")
				walk(src, 0)
				return
			if("Change Aggro")
				if(faction.Find("neutral"))
					to_chat(M, span_notice("[src] will now attack humans on sight."))
					faction -= "neutral"
				else
					to_chat(M, span_notice("[src] will now not attack humans on sight."))
					faction += "neutral"
				return //This will add or remove the neutral faction.
		return

/mob/living/simple_animal/hostile/cuckoospawn/proc/executed_claw()
	var/turf/origin = get_turf(src)
	var/list/all_turfs = origin.GetAtmosAdjacentTurfs(1)
	for(var/turf/T in all_turfs)
		if(T == origin)
			continue
		new /obj/effect/temp_visual/dir_setting/claw_appears (T)
		break
	new /obj/effect/temp_visual/justitia_effect(get_turf(src))
	gib()

/mob/living/simple_animal/hostile/cuckoospawn_parasite
	name = "niaojia-ren parasite"
	icon = 'icons/mob/cuckoospawn.dmi'
	icon_state = "skrinkly_bird"
	desc = "A nastly little bird worm thing, it appears to be growing quickly!"
	faction = list("cuckoospawn")
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	density = FALSE
	layer = ABOVE_NORMAL_TURF_LAYER
	melee_damage_lower = 1
	melee_damage_upper = 3
	maxHealth = 50
	health = 50
	wander = 0
	move_to_delay = 2
	simple_mob_flags = SILENCE_RANGED_MESSAGE
	environment_smash = FALSE
	ranged = TRUE
	retreat_distance = 10
	minimum_distance = 10
	var/growing_time = 15 SECONDS
	var/growingtimer

/mob/living/simple_animal/hostile/cuckoospawn_parasite/Initialize()
	. = ..()
	growingtimer = world.time + (growing_time)

/mob/living/simple_animal/hostile/cuckoospawn_parasite/Life()
	. = ..()
	if(growingtimer <= world.time)
		Growup()

/mob/living/simple_animal/hostile/cuckoospawn_parasite/AttackingTarget(atom/attacked_target)
	if(isvehicle(attacked_target) || istype(attacked_target, /obj/machinery/door))
		var/turf/target_turf = get_turf(attacked_target)
		forceMove(target_turf)
		manual_emote("crawls under [attacked_target]!")
	else if (istype(attacked_target, /mob/living))
		if (attacked_target != src)
			var/turf/target_turf = get_turf(attacked_target)
			forceMove(target_turf)
			manual_emote("crawls under [attacked_target]!")

/mob/living/simple_animal/hostile/cuckoospawn_parasite/proc/Growup()
	var/mob/living/simple_animal/hostile/cuckoospawn/C = new(get_turf(src))
	if(mind)
		mind.transfer_to(C)
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/growl.ogg', 30, 1)
	qdel(src)

/mob/living/simple_animal/hostile/cuckoospawn_parasite/intelligent
	icon_state = "parasitispawn"
	growing_time = 60 SECONDS

/mob/living/simple_animal/hostile/cuckoospawn_parasite/intelligent/Growup()
	if(stat != DEAD)
		var/mob/living/carbon/human/species/cuckoospawn/C = new(get_turf(src))
		if(mind)
			mind.transfer_to(C)
		playsound(get_turf(src), 'sound/abnormalities/nothingthere/growl.ogg', 30, 1)
	qdel(src)

/obj/effect/temp_visual/dir_setting/claw_appears
	name = "Claw"
	desc = "A strange humanoid creature with several gadgets attached to it."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "claw_dash"
	duration = 5

/obj/effect/temp_visual/dir_setting/claw_appears/Destroy()
	playsound(src, 'ModularTegustation/Tegusounds/claw/death.ogg', 50, TRUE)
	. = ..()
