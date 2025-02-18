/mob/living/simple_animal/hostile/abnormality/bloodbath
	name = "Bloodbath"
	desc = "A constantly dripping bath of blood"
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "bloodbath"
	portrait = "blood_bath"
	maxHealth = 1000
	health = 1000
	move_to_delay = 3
	attack_sound = 'sound/abnormalities/ichthys/slap.ogg'
	attack_verb_continuous = "mauls"
	attack_verb_simple = "maul"
	melee_damage_lower = 6
	melee_damage_upper = 12
	melee_damage_type = WHITE_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1.6, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.4, PALE_DAMAGE = 1.5)
	ranged = TRUE
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(55, 55, 50, 50, 50),
		ABNORMALITY_WORK_INSIGHT = list(45, 45, 40, 40, 40),
		ABNORMALITY_WORK_ATTACHMENT = 60,
		ABNORMALITY_WORK_REPRESSION = list(30, 20, 10, 0, 0),
	)
	work_damage_amount = 8
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/woe
	max_boxes = 14

	ego_list = list(
		/datum/ego_datum/weapon/wrist,
		/datum/ego_datum/armor/wrist,
	)

	gift_type =  /datum/ego_gifts/wrist

	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "The Enkephalin cure affected not only mind, but also body. <br>\
		The problem is, the supply of cure became tremendously huge to control when we realized the problem. <br>\
		One of problems, one of them was numbing. <br>People believed they could live happy life. <br>\
		People believed they could buy sadness and sell happiness with money. <br>When the first suicide happened, we should have known that these beliefs had been shattered. <br>\
		Many hands float in the bath. <br>Hands that wanted to grab something but could not. <br>You......"
	observation_choices = list(
		"Grabbed a hand" = list(TRUE, "I feel coldness and stiffness. <br>I know these hands. <br>These are the hands of people I once loved."),
		"Did not grab a hand" = list(FALSE, "You looked away. <br>This is not the first time you ignore them. <br>It will be the same afterwards."),
	)

	var/hands = 0
	var/can_act = TRUE
	var/special_attack_cooldown

/mob/living/simple_animal/hostile/abnormality/bloodbath/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
// any work performed with level 1 Fort and Temperance makes you panic and die
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 40 && get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 40 || (hands == 3 && prob(50)))
		icon = 'ModularTegustation/Teguicons/48x64.dmi'
		icon_state = "bloodbath_a[hands]"
		user.Stun(30 SECONDS)
		step_towards(user, src)
		sleep(0.5 SECONDS)
		if(QDELETED(user))
			return
		step_towards(user, src)
		sleep(0.5 SECONDS)
		if(QDELETED(user))
			return
		user.dust()
		visible_message(span_warning("[src] drags [user] into itself!"))
		playsound(get_turf(src),'sound/effects/wounds/blood2.ogg')
		playsound(get_turf(src),'sound/effects/footstep/water1.ogg')
		SLEEP_CHECK_DEATH(3 SECONDS)
		hands ++
		if(hands < 4)
			datum_reference.max_boxes += 4
			icon_state = "bloodbath[hands]"
		else
			hands = 0
			datum_reference.max_boxes = max_boxes
			icon_state = "bloodbath"
		return

/mob/living/simple_animal/hostile/abnormality/bloodbath/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type != BREACH_MINING && breach_type != BREACH_PINK)
		return
	if(breach_type == BREACH_PINK)
		maxHealth = 4000
		melee_damage_lower = 20
		melee_damage_upper = 40
	..()
	icon_state = "bloodbath_DF"
	pixel_x = -8
	base_pixel_x = -8
	update_icon()

/mob/living/simple_animal/hostile/abnormality/bloodbath/OpenFire()
	if(!can_act)
		return
	if(special_attack_cooldown > world.time)
		return
	BloodBathSlam()

/mob/living/simple_animal/hostile/abnormality/bloodbath/proc/BloodBathSlam()//weaker version of the DF form
	if(!can_act)
		return
	special_attack_cooldown = world.time + 5 SECONDS
	can_act = FALSE
	for(var/turf/L in view(3, src))
		new /obj/effect/temp_visual/cult/sparks(L)
	playsound(get_turf(src), 'sound/abnormalities/ichthys/jump.ogg', 100, FALSE, 6)
	icon_state = "bloodbath_slamprepare"
	SLEEP_CHECK_DEATH(12)
	for(var/turf/T in view(3, src))
		var/obj/effect/temp_visual/small_smoke/halfsecond/FX =  new(T)
		FX.color = "#b52e19"
		for(var/mob/living/carbon/human/H in HurtInTurf(T, list(), 50, WHITE_DAMAGE, null, null, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE))
			if(H.sanity_lost)
				H.gib()
	playsound(get_turf(src), 'sound/abnormalities/bloodbath/Bloodbath_EyeOn.ogg', 125, FALSE, 6)
	icon_state = "bloodbath_slam"
	SLEEP_CHECK_DEATH(3)
	icon_state = "bloodbath_DF"
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/bloodbath/Move()
	if(!can_act)
		return FALSE
	..()
