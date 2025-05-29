/mob/living/simple_animal/hostile/cuckoospawn
	name = "jiajiaren"
	desc = "A tall humaniod looking bird, with eyes glaring anything moving around it."
	icon = 'icons/mob/cuckoospawn_big.dmi'
	icon_state = "evil_ass_bird"
	icon_living = "evil_ass_corpse"
	maxHealth = 700
	health = 700
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 1.5)
	faction = list("hostile", "cuckoospawn")
	stat_attack = HARD_CRIT
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 20
	melee_damage_upper = 24
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

/mob/living/simple_animal/hostile/cuckoospawn/AttackingTarget(atom/attacked_target)
	var/mob/living/carbon/human/human_target
	var/alive = FALSE
	if(ishuman(attacked_target))
		human_target = attacked_target
		if(human_target.stat != DEAD)
			alive = TRUE
	. = ..()
	if(human_target.stat != DEAD && prob(40))
		var/obj/item/bodypart/chest/LC = human_target.get_bodypart(BODY_ZONE_CHEST)
		if((!LC || LC.status != BODYPART_ROBOTIC) && !human_target.getorgan(/obj/item/organ/body_egg/cuckoospawn_embryo))
			new /obj/item/organ/body_egg/cuckoospawn_embryo(human_target)
			var/turf/T = get_turf(human_target)
			log_game("[key_name(human_target)] was impregnated by a cockoospawn at [loc_name(T)]")
	if(alive && human_target.stat == DEAD)
		var/obj/item/organ/body_egg/cuckoospawn_embryo/bursting_embryo = human_target.getorgan(/obj/item/organ/body_egg/cuckoospawn_embryo)
		if(bursting_embryo)
			bursting_embryo.AttemptGrow()

/mob/living/simple_animal/hostile/cuckoospawn_parasite
	name = "jiajiaren parasite"
	icon = 'icons/mob/cuckoospawn.dmi'
	icon_state = "skrinkly_bird"
	desc = "A nastly little bird worm thing, it appears to be growing quickly!"
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
	var/mob/living/carbon/human/species/cuckoospawn/C = new(get_turf(src))
	if(mind)
		mind.transfer_to(C)
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/growl.ogg', 30, 1)
	qdel(src)
