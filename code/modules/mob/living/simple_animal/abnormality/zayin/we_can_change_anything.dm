#define STATUS_EFFECT_CHANGE /datum/status_effect/we_can_change_anything
/mob/living/simple_animal/hostile/abnormality/we_can_change_anything
	name = "We Can Change Anything"
	desc = "A human sized container with spikes inside it, you shouldn't enter it"
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "wecanchange"
	maxHealth = 1000
	health = 1000
	threat_level = ZAYIN_LEVEL
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 2, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.5)
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(80, 85, 90, 95, 100),
		ABNORMALITY_WORK_INSIGHT = list(80, 85, 90, 95, 100),
		ABNORMALITY_WORK_ATTACHMENT = list(40, 50, 55, 60, 60),
		ABNORMALITY_WORK_REPRESSION = list(55, 60, 65, 70, 75)
		)

	charger = TRUE
	charge_distance = 8
	charge_frequency = 40 SECONDS
	knockdown_time = 0
	blood_volume = 0 // Doesn't normally bleed
	layer = LARGE_MOB_LAYER

	work_damage_amount = 4
	work_damage_type = RED_DAMAGE
	max_boxes = 10

	ego_list = list(
		/datum/ego_datum/weapon/change,
		/datum/ego_datum/armor/change
		)

	gift_type =  /datum/ego_gifts/change
	gift_message = "Your heart beats with new vigor."

	var/grinding = FALSE
	var/grind_duration = 5 SECONDS
	var/grind_damage = 2 // Dealt 100 times

/mob/living/simple_animal/hostile/abnormality/we_can_change_anything/work_complete(mob/living/carbon/human/user, work_type, pe)
	user.apply_damage(40, RED_DAMAGE, null, user.run_armor_check(null, RED_DAMAGE)) // say goodbye to your kneecaps chucklenuts!
	user.apply_status_effect(STATUS_EFFECT_CHANGE)
	..()

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
	if(..())
		update_all()

/mob/living/simple_animal/hostile/abnormality/we_can_change_anything/charge_end()
	..()
	Grind()

/mob/living/simple_animal/hostile/abnormality/we_can_change_anything/proc/Grind()
	if(grinding)
		return
	grinding = TRUE
	var/list/AoE = list()
	visible_message("<span class='userdanger'>[src] opens wide!</span>")
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
				victim.spawn_gibs()
				QDEL_NULL(victim)
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
	duration = 3000		//Lasts 5 mins
	alert_type = /atom/movable/screen/alert/status_effect/we_can_change_anything

/atom/movable/screen/alert/status_effect/we_can_change_anything
	name = "The desire to change"
	desc = "Your lost kneecaps have made you stronger, enjoy."

/datum/status_effect/we_can_change_anything/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.physiology.red_mod *= 0.9

/datum/status_effect/we_can_change_anything/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.physiology.red_mod /= 0.9

#undef STATUS_EFFECT_CHANGE
