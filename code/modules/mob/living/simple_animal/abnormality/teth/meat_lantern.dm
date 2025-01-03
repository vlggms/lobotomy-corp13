/mob/living/simple_animal/hostile/abnormality/meat_lantern
	name = "Meat Lantern"
	desc = "All you can see is a small white mound with two eyes and a glowing flower."
	icon = 'ModularTegustation/Teguicons/64x32.dmi'
	icon_state = "lantern"
	icon_living = "lantern"
	portrait = "meat_lantern"
	maxHealth = 900
	health = 900
	base_pixel_x = -16
	pixel_x = -16
	threat_level = TETH_LEVEL
	faction = list("hostile")
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(45, 45, 50, 55, 55),
		ABNORMALITY_WORK_INSIGHT = 60,
		ABNORMALITY_WORK_ATTACHMENT = 45,
		ABNORMALITY_WORK_REPRESSION = 30,
	)
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	can_patrol = FALSE
	can_breach = TRUE
	del_on_death = FALSE
	death_message = "explodes in a shower of gore."

	work_damage_amount = 5
	work_damage_type = WHITE_DAMAGE
	start_qliphoth = 1
	max_boxes = 14
	ego_list = list(
		/datum/ego_datum/weapon/lantern,
		/datum/ego_datum/armor/lantern,
	)

	gift_type = /datum/ego_gifts/lantern
	gift_message = "Not a single employee has seen Meat Lantern's full form."

	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "It's always the same, dull colours in the facility. Grey walls, grey floors, grey ceilings, even the people were grey. <br>\
		Every day was grey until, one day, you saw the a small, beautifully green flower growing and glowing from the ground."
	observation_choices = list(
		"Approach the flower" = list(TRUE, "It's the most beautiful thing you've ever seen, you brush your hand against it and the petals tickle your hand. You feel a tremor beneath and..."),
		"Call for security" = list(FALSE, "Something so beautiful had no right to exist in the City. You called for security and left in a hurry back to your grey workplace."),
	)

	var/can_act = TRUE
	var/detect_range = 1
	var/chop_cooldown
	var/chop_cooldown_time = 4 SECONDS
	var/chop_damage = 400

/mob/living/simple_animal/hostile/abnormality/meat_lantern/PostSpawn()
	. = ..()
	med_hud_set_health() //show medhud while in containment
	med_hud_set_status()

//Cameras cant auto track it now.
/mob/living/simple_animal/hostile/abnormality/meat_lantern/can_track(mob/living/user)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/meat_lantern/PickTarget(list/Targets)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/meat_lantern/AttackingTarget()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/meat_lantern/Goto(target, delay, minimum_distance)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/meat_lantern/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/meat_lantern/FearEffect() //makes it too easy to find with a giant exclamation mark over your head
	return

/mob/living/simple_animal/hostile/abnormality/meat_lantern/death()
	. = ..()
	gib()

/mob/living/simple_animal/hostile/abnormality/meat_lantern/HasProximity(atom/movable/AM)
	if(!isliving(AM))
		return
	var/mob/living/L = AM
	if(L.stat == DEAD || faction_check_mob(L))
		return
	if(!can_act || (chop_cooldown > world.time))
		return
	INVOKE_ASYNC(src, PROC_REF(BigChop))

/mob/living/simple_animal/hostile/abnormality/meat_lantern/proc/BigChop()
	can_act = FALSE
	new /obj/effect/temp_visual/yellowsmoke(get_turf(src))
	icon = 'ModularTegustation/Teguicons/224x128.dmi'
	flick("lantern_bite_open",src)
	pixel_x = base_pixel_x - 88
	playsound(get_turf(src), 'sound/effects/ordeals/amber/midnight_out.ogg', 40)
	SLEEP_CHECK_DEATH(7)
	icon = 'ModularTegustation/Teguicons/128x128.dmi'
	flick("lantern_bite_closed", src)
	pixel_x = base_pixel_x - 40
	for(var/mob/living/L in oview(1, src))
		if(faction_check_mob(L))
			continue
		L.deal_damage(chop_damage, RED_DAMAGE)
		if(L.health < 0)
			L.gib(FALSE,FALSE,TRUE)
	SLEEP_CHECK_DEATH(2.5)
	icon = initial(icon)
	pixel_x = base_pixel_x
	can_act = TRUE
	chop_cooldown = world.time + chop_cooldown_time
	addtimer(CALLBACK(src, PROC_REF(ProximityCheck)), chop_cooldown_time)

/mob/living/simple_animal/hostile/abnormality/meat_lantern/proc/ProximityCheck()
	for(var/mob/living/L in range(1,src)) //hidden istype() call
		if(L == src)
			continue
		if(faction_check_mob(L))
			continue
		BigChop()
		return

/mob/living/simple_animal/hostile/abnormality/meat_lantern/med_hud_set_health()
	if(!IsContained())
		var/image/holder = hud_list[HEALTH_HUD]
		holder.icon_state = null
		return
	..()

/mob/living/simple_animal/hostile/abnormality/meat_lantern/med_hud_set_status()
	if(!IsContained())
		var/image/holder = hud_list[STATUS_HUD]
		holder.icon_state = null
		return
	..()

/mob/living/simple_animal/hostile/abnormality/meat_lantern/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	if (get_attribute_level(user, TEMPERANCE_ATTRIBUTE) >= 60)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/meat_lantern/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/meat_lantern/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	update_icon()
	density = FALSE
	med_hud_set_health() //hides medhud
	med_hud_set_status()
	forceMove(pick(GLOB.xeno_spawn))
	chop_cooldown = world.time + chop_cooldown_time
	proximity_monitor = new(src, detect_range)
	return

/mob/living/simple_animal/hostile/abnormality/meat_lantern/update_icon_state()
	icon = initial(icon)
	icon_living = IsContained() ? initial(icon_state) : "lantern_breach"
	icon_state = icon_living

/obj/effect/temp_visual/yellowsmoke
	icon = 'icons/effects/96x96.dmi'
	icon_state = "smoke2"
	duration = 15
	pixel_x = -32
	base_pixel_x = -32
	pixel_y = -32
	base_pixel_y = -32
	color = COLOR_VIVID_YELLOW
