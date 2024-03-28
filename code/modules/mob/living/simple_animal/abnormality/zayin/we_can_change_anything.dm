#define STATUS_EFFECT_CHANGE /datum/status_effect/we_can_change_anything
/mob/living/simple_animal/hostile/abnormality/we_can_change_anything
	name = "We Can Change Anything"
	desc = "A human sized container with spikes inside it. You shouldn't enter it"
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "wecanchange"
	portrait = "we_can_change_anything"
	maxHealth = 1000
	health = 1000
	threat_level = ZAYIN_LEVEL
	damage_coeff = list(RED_DAMAGE = 2, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.5)
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(80, 85, 90, 95, 100),
		ABNORMALITY_WORK_INSIGHT = list(80, 85, 90, 95, 100),
		ABNORMALITY_WORK_ATTACHMENT = list(80, 85, 90, 95, 100),
		ABNORMALITY_WORK_REPRESSION = list(80, 85, 90, 95, 100),
		"Enter machine" = 100, //"Go inside the torture machine, it'll be fun they said"
	)

	charger = TRUE
	charge_distance = 8
	charge_frequency = 40 SECONDS
	knockdown_time = 0
	blood_volume = 0 // Doesn't normally bleed
	layer = LARGE_MOB_LAYER

	work_damage_amount = 0
	work_damage_type = RED_DAMAGE
	max_boxes = 10
	speech_span = SPAN_ROBOT

	ego_list = list(
		/datum/ego_datum/weapon/change,
		/datum/ego_datum/armor/change,
		/datum/ego_datum/weapon/iron_maiden,
	)

	gift_type =  /datum/ego_gifts/change
	gift_message = "Your heart beats with new vigor."
	abnormality_origin = ABNORMALITY_ORIGIN_ALTERED

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/helper = 1.5,
		/mob/living/simple_animal/hostile/abnormality/cleaner = 1.5,
	)

	var/grinding = FALSE
	var/grind_duration = 5 SECONDS
	var/grind_damage = 2 // Dealt 100 times

	chem_type = /datum/reagent/abnormality/we_can_change_anything
	harvest_phrase = span_notice("You scoop up some goo from the inner lip of %ABNO using %VESSEL.")
	harvest_phrase_third = "%PERSON scoops up some goo from the inner lip of %ABNO with %VESSEL."
	var/sacrifice = FALSE //are we doing "Enter machine" work?
	var/ramping_speed = 20 //work speed for sacrifice work, gets subtracted from so we can have faster work ticks.
	var/total_damage = 0 //stored so we can later convert it into PE
	var/total_energy = 0 //after reaching 1000+, locks sacrifice out, if they try to

/mob/living/simple_animal/hostile/abnormality/we_can_change_anything/proc/StoreWorker(mob/living/L) //Stores the worker inside
	if(!L)
		return FALSE
	playsound(src, 'sound/abnormalities/we_can_change_anything/change_start.ogg', 50, FALSE)
	ADD_TRAIT(L, TRAIT_NOBREATH, type)
	ADD_TRAIT(L, TRAIT_IMMOBILIZED, type)
	ADD_TRAIT(L, TRAIT_HANDS_BLOCKED, type)
	L.forceMove(src)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/we_can_change_anything/proc/ReleaseWorker() //Releases all workers inside
	var/spew_turf = pick(get_adjacent_open_turfs(src))
	for(var/atom/movable/i in contents)
		if(isliving(i))
			var/mob/living/L = i
			L.Knockdown(10, FALSE)
			REMOVE_TRAIT(L, TRAIT_NOBREATH, type)
			REMOVE_TRAIT(L, TRAIT_IMMOBILIZED, type)
			REMOVE_TRAIT(L, TRAIT_HANDS_BLOCKED, type)
		i.forceMove(spew_turf)

/mob/living/simple_animal/hostile/abnormality/we_can_change_anything/AttemptWork(mob/living/carbon/human/user, work_type)
	if(work_type != "Enter machine")
		return TRUE
	if(total_energy >= 1000) //Cant just spam the work
		say("[total_energy] PE Boxes accumulated, processing energy, please stay on standby!")
		return FALSE
	if(!istype(datum_reference)) //Prevents a runtime
		return FALSE
	StoreWorker(user) //Yoink.
	datum_reference.max_boxes = 100 //much longer than a normal work.
	sacrifice = TRUE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/we_can_change_anything/Worktick(mob/living/carbon/human/user)
	if(!sacrifice)
		user.apply_damage(5, RED_DAMAGE, null, user.run_armor_check(null, RED_DAMAGE)) // say goodbye to your kneecaps chucklenuts!
	else
		do_shaky_animation(1)
		playsound(get_turf(src), 'sound/abnormalities/we_can_change_anything/change_generate.ogg', 50, FALSE)
		switch(ramping_speed)
			if(1 to 8)
				ramping_speed -= 0.2
			if(8 to 20)
				ramping_speed -= 0.5
		user.apply_damage(8, RED_DAMAGE, null, user.run_armor_check(null, RED_DAMAGE)) // say goodbye to a bit more than your kneecaps... (total damage is 800 RED).
		total_damage += 8

/mob/living/simple_animal/hostile/abnormality/we_can_change_anything/SpeedWorktickOverride(mob/living/carbon/human/user, work_speed, init_work_speed, work_type)
	if(!sacrifice)
		return work_speed
	return ramping_speed

/mob/living/simple_animal/hostile/abnormality/we_can_change_anything/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(work_type != "Enter machine")
		user.apply_status_effect(STATUS_EFFECT_CHANGE)
	else
		playsound(src, 'sound/abnormalities/we_can_change_anything/change_gas.ogg', 50, TRUE)
		sacrifice = FALSE
		var/energy_generated = round(10 ** ( (total_damage/100) * 0.375) ) //exponential formula, caps out at 800 damage, generating 1000 PE.

		if(user.health <= 0)
			qdel(user) //reduced to atoms
			energy_generated += total_damage/8 //adds the normal work PE boxes, since those are normally lost on death
		else
			ReleaseWorker()
		datum_reference.stored_boxes += energy_generated //only increases PE on the normal console, doesn't give any to the quota...
		total_energy += energy_generated
		say("[total_energy] PE Boxes accumulated!")

		datum_reference.max_boxes = 10 //resets the max boxes for future works.
		ramping_speed = 20
		total_damage = 0
	return

/mob/living/simple_animal/hostile/abnormality/we_can_change_anything/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_PINK)
		can_breach = TRUE
		var/mob/living/carbon/human/H = locate() in view(3, src)
		if(!H)
			forceMove(pick(GLOB.xeno_spawn))
	return ..()

/mob/living/simple_animal/hostile/abnormality/we_can_change_anything/Move()
	if(charge_state)
		return ..()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/we_can_change_anything/AttackingTarget()
	if(COOLDOWN_FINISHED(src, charge_cooldown))
		COOLDOWN_START(src, charge_cooldown, charge_frequency)
		Grind()
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/we_can_change_anything/handle_charge_target(atom/target)
	. = ..()
	if(.)
		update_all()

/mob/living/simple_animal/hostile/abnormality/we_can_change_anything/charge_end()
	. = ..()
	Grind()

/mob/living/simple_animal/hostile/abnormality/we_can_change_anything/proc/Grind()
	if(grinding)
		return
	grinding = TRUE
	var/list/AoE = list()
	visible_message(span_warning("[src] opens wide!"), span_nicegreen("Time to begin another productive day!"))
	for(var/turf/open/T in view(2, src))
		AoE += T
		new /obj/effect/temp_visual/cult/sparks(T)
	SLEEP_CHECK_DEATH(1 SECONDS)
	for(var/turf/open/TF in AoE)
		for(var/mob/living/carbon/human/H in TF)
			H.Stun(5 SECONDS)
			if(get_dist(src, H) > 1)
				step_towards(H, src)
			src.buckle_mob(H, TRUE, TRUE)
			if(H.blood_volume > 0)
				blood_volume += H.blood_volume
	update_all()
	if(!LAZYLEN(buckled_mobs))
		grinding = FALSE
		return
	var/grind_end = world.time + grind_duration
	var/sound_cooldown = 0
	while(grind_end > world.time)
		if(sound_cooldown < 3)
			sound_cooldown++
		else
			sound_cooldown = 0
			playsound(src, 'sound/abnormalities/change/change_ding.ogg', 50)
		for(var/mob/living/carbon/human/victim in get_turf(src))
			victim.apply_damage(grind_damage, RED_DAMAGE, null, victim.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			if(victim.health <= 0)
				victim.gib()
		stoplag(1)
	unbuckle_all_mobs()
	grinding = FALSE

/mob/living/simple_animal/hostile/abnormality/we_can_change_anything/proc/update_all()
	if(icon_state != initial(icon_state))
		icon = initial(icon)
		icon_state = initial(icon_state)
		pixel_x = initial(pixel_x)
		base_pixel_x = initial(base_pixel_x)
		density = initial(density)
		return
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "change_opening"
	pixel_x = -8
	base_pixel_x = -8
	density = FALSE

/datum/status_effect/we_can_change_anything
	id = "change"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 5 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/we_can_change_anything

/atom/movable/screen/alert/status_effect/we_can_change_anything
	name = "The desire to change"
	desc = "Your painful experience has made you more resilient to RED damage."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "change"

/datum/status_effect/we_can_change_anything/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.red_mod *= 0.9

/datum/status_effect/we_can_change_anything/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.red_mod /= 0.9

#undef STATUS_EFFECT_CHANGE

/datum/reagent/abnormality/we_can_change_anything
	name = "Dubious Red Goo"
	description = "You have a strong suspicion about where this came from, but..."
	color = "#8f1108"
	health_restore = -1
	damage_mods = list(0.9, 1, 1, 1)
