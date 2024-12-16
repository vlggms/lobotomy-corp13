#define STATUS_EFFECT_BLUERESIN /datum/status_effect/blue_resin
//Coded by Coxswain
/mob/living/simple_animal/hostile/abnormality/blubbering_toad
	name = "Blubbering Toad"
	desc = "A giant toad, wailing with tears in its eyes. The tears are thick, like a blue resin."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "blubbering"
	icon_living = "blubbering"
	icon_dead = "blubbering_egg"
	portrait = "blubbering_toad"
	var/icon_tongue = "blubbering_tongue"
	del_on_death = FALSE
	pixel_x = -16
	base_pixel_x = -16

	threat_level = ZAYIN_LEVEL
	maxHealth = 1400 //megahuge stats, almost as strong as a WAW.
	health = 1400
	can_breach = TRUE
	melee_damage_type = BLACK_DAMAGE
	stat_attack = DEAD
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 2)
	move_to_delay = 3
	melee_damage_lower = 35
	melee_damage_upper = 45
	max_boxes = 10
	ranged = TRUE
	attack_sound = 'sound/abnormalities/blubbering_toad/attack.ogg'
	attack_verb_continuous = "mauls"
	attack_verb_simple = "maul"

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(70, 60, 50, 50, 50),
		ABNORMALITY_WORK_INSIGHT = 70,
		ABNORMALITY_WORK_ATTACHMENT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_REPRESSION = list(70, 30, 30, 30, 30),
	)
	work_damage_amount = 6
	work_damage_type = BLACK_DAMAGE

	// Petting
	pet_bonus = TRUE
	pet_bonus_emote = "Weh!"
	response_help_simple = "pet"
	response_help_continuous = "pets"

	ego_list = list(
		/datum/ego_datum/weapon/cavernous_wailing,
		/datum/ego_datum/armor/cavernous_wailing,
	)
	gift_type =  /datum/ego_gifts/melty_eyeball
	gift_message = "The toad gave you an eyeball, maybe it was for lending an ear?"
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	observation_prompt = "\"Croohoo, croohoo, croohoo.\" <br>\
		A giant toad cries inside a cave. <br>\
		Patches of dark blue resin cover the cave. <br>\
		This resin is like gloom. <br>\
		A sap of gloom, not quite like tears or sadness. <br>\
		The toad holds this resin."
	observation_choices = list(
		"Sit and wait" = list(TRUE, "An indeterminate amount of time passes. <br>\
			As you waited for the toad to finish its cries, <br>\
			it gazed into you, closing and opening its eyelids slowly. <br>\
			With a quick, slick sound, a long blue tongue popped out towards you. <br>\
			An eyeball belonging to the toad was on its tongue. <br>\
			When you picked it up, it blinked its other eye at us before going on its way. <br>\
			Was that its thanks for lending an ear?"),
		"Mimic the cry" = list(FALSE, "\"Croohic, croohoo.\" <br>\
			The toad’s cry is dull and heavy. <br>\
			It doesn’t seem to have understood what it heard. <br>\
			After crying like that a few more times, it hopped away from its spot. <br>\
			All that’s left is the sticky blue resin."),
	)

	//work
	var/pulse_healing = 15
	var/healing_pulse_amount = 0
	//breach
	var/tongue_cooldown
	var/tongue_cooldown_time = 2 SECONDS
	var/tongue_damage = 20
	var/jump_cooldown
	var/jump_cooldown_time = 6 SECONDS
	var/can_act = TRUE
	var/retreating = FALSE
	var/mob/living/idiot = null
	var/transformed = FALSE
	var/broken = FALSE
	var/persistant = FALSE

//Work/Misc
/mob/living/simple_animal/hostile/abnormality/blubbering_toad/PostSpawn()
	..()
	BlubberLoop() //crying sfx

/mob/living/simple_animal/hostile/abnormality/blubbering_toad/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(pe == 0)
		return
	user.apply_status_effect(STATUS_EFFECT_BLUERESIN)
	healing_pulse_amount = pick (rand(6,8))

/mob/living/simple_animal/hostile/abnormality/blubbering_toad/proc/BlubberLoop()
	if(health < 1)
		return
	var/num = pick(1,2,3,4)
	playsound(get_turf(src), "sound/abnormalities/blubbering_toad/blurble[num].ogg", 100, FALSE)
	addtimer(CALLBACK(src, PROC_REF(BlubberLoop)), rand(3,10) SECONDS)
	if(IsContained() && (healing_pulse_amount > 0)) //isn't breached and has charges left
		healing_pulse_amount --
		HealPulse()

/mob/living/simple_animal/hostile/abnormality/blubbering_toad/proc/HealPulse()
	for(var/mob/living/carbon/human/H in livinginview(3, get_turf(src)))
		H.adjustSanityLoss(-pulse_healing)

//Attack or approach it directly and it attacks you!
/mob/living/simple_animal/hostile/abnormality/blubbering_toad/BreachEffect(mob/living/user, breach_type = BREACH_NORMAL)
	if(breach_type == BREACH_PINK || breach_type == BREACH_MINING)
		persistant = TRUE
	if(breach_type == BREACH_MINING)//nerfed to a ZAYIN statline since this is something you'll typically fight roundstart
		name = "Weakened [name]"
		maxHealth = 400
		melee_damage_lower = 9
		melee_damage_upper = 15
		tongue_damage = 10
		broken = TRUE
	SetIdiot(user)
	return ..()

/mob/living/simple_animal/hostile/abnormality/blubbering_toad/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(!IsContained())
		return
	if(user.a_intent == INTENT_HELP)
		return
	BreachEffect(user)

/mob/living/simple_animal/hostile/abnormality/blubbering_toad/attack_paw(mob/living/carbon/human/M)
	. = ..()
	if(!IsContained())
		return
	BreachEffect(M)

/mob/living/simple_animal/hostile/abnormality/blubbering_toad/bullet_act(obj/projectile/Proj, def_zone, piercing_hit = FALSE)
	..()
	if(!IsContained())
		return
	if(Proj.firer)
		BreachEffect(Proj.firer)

/mob/living/simple_animal/hostile/abnormality/blubbering_toad/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(!IsContained())
		return
	if(I.force)
		BreachEffect(user)

/mob/living/simple_animal/hostile/abnormality/blubbering_toad/proc/ReturnCell()
	QDEL_NULL(src)

/mob/living/simple_animal/hostile/abnormality/blubbering_toad/proc/SetIdiot(mob/living/L)
	idiot = L
	if(idiot)
		to_chat(src, span_notice("You current target is [idiot]!"))
	else
		to_chat(src, span_notice("Your work here is done, you should now return to your cell."))

/mob/living/simple_animal/hostile/abnormality/blubbering_toad/death() //EGG! just kidding no egg....
	density = FALSE
	playsound(src, 'sound/effects/limbus_death.ogg', 40, 0, FALSE)
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

//Attacks
/mob/living/simple_animal/hostile/abnormality/blubbering_toad/OpenFire()
	if(target != idiot)
		return
	var/dist = get_dist(target, src)
	if((dist > 2) && (dist < 5))
		TongueAttack(target)
	if(dist >= 5)
		Jump(target)

/mob/living/simple_animal/hostile/abnormality/blubbering_toad/proc/TongueAttack(mob/living/target)
	if(!istype(target))
		return
	var/dist = get_dist(target, src)
	if(dist > 2 && tongue_cooldown < world.time)
		can_act = FALSE
		var/turf/target_turf = get_turf(target)
		var/list/turfs_to_hit = getline(src, target_turf)
		var/turf/MT = get_turf(src)
		playsound(get_turf(src), "sound/abnormalities/blubbering_toad/tongue.ogg", 100, FALSE)
		MT.Beam(target_turf, "tongue", time=5)
		icon_state = icon_tongue
		for(var/turf/T in turfs_to_hit)
			if(T.density)
				break
			if(idiot in T)
				idiot.deal_damage(tongue_damage, BLACK_DAMAGE)
				new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(idiot), pick(GLOB.alldirs))
				if(!idiot.anchored)
					var/whack_speed = (prob(60) ? 1 : 4)
					idiot.throw_at(MT, rand(1, 2), whack_speed, src)
		sleep(5)
		tongue_cooldown = world.time + tongue_cooldown_time
		can_act = TRUE
		icon_state = icon_living

/mob/living/simple_animal/hostile/abnormality/blubbering_toad/proc/Jump(mob/living/target)
	if(!istype(target))
		return
	var/dist = get_dist(target, src)
	if(dist > 2 && jump_cooldown < world.time)
		can_act = FALSE
		animate(src, alpha = 1,pixel_x = 0, pixel_z = 16, time = 0.1 SECONDS)
		src.pixel_z = 16
		playsound(src, 'sound/abnormalities/blubbering_toad/windup.ogg', 50, FALSE, 4)
		SLEEP_CHECK_DEATH(0.5 SECONDS)
		forceMove(get_turf(target)) //look out, someone is rushing you!
		SLEEP_CHECK_DEATH(0.3)
		for(var/turf/T in view(1, src))
			new /obj/effect/temp_visual/blubbering_smash(T)
		playsound(src, 'sound/abnormalities/blubbering_toad/attack.ogg', 50, FALSE, 4)
		jump_cooldown = world.time + jump_cooldown_time
		animate(src, alpha = 255,pixel_x = 0, pixel_z = -16, time = 0.1 SECONDS)
		src.pixel_z = 0
		can_act = TRUE

//AI code
/mob/living/simple_animal/hostile/abnormality/blubbering_toad/Move()
	if(!can_act)
		return FALSE
	update_icon_state() //prevents icons from getting stuck
	..()

/mob/living/simple_animal/hostile/abnormality/blubbering_toad/AttackingTarget(atom/attacked_target)
	if(!ishuman(attacked_target))
		return
	if(attacked_target != idiot)
		LoseTarget(attacked_target)
		return
	..()
	var/mob/living/carbon/human/H = attacked_target
	if(H.sanity_lost) //prevents hitting the same guy in an infinite loop
		melee_damage_type = BLACK_DAMAGE
	if(H.health < 0)
		H.gib()
		if(!persistant)
			addtimer(CALLBACK(src, PROC_REF(ReturnCell)), 10 SECONDS)
			return
		idiot = null
		for(var/mob/living/carbon/human/HU in GLOB.player_list)
			if(HU.z != z)
				continue
			if(HU.stat == DEAD)
				continue
			if(isnull(idiot))
				idiot = HU
			if(idiot.health > HU.health)
				idiot = HU
		if(isnull(idiot))
			addtimer(CALLBACK(src, PROC_REF(ReturnCell)), 10 SECONDS)
			return
		SetIdiot(idiot)


/mob/living/simple_animal/hostile/abnormality/blubbering_toad/ListTargets()
	. = ..()
	if(idiot in .)
		return list(idiot)
	return

//Transformation
/mob/living/simple_animal/hostile/abnormality/blubbering_toad/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	..()
	if(broken)
		return
	if(transformed)
		if(health < (maxHealth / 5)) //20% health or lower
			melee_damage_lower = 15
			melee_damage_upper = 25
			icon_living = "blubbering_egg"
			icon_tongue = "blubbering_egg_tongue"
			icon_state = icon_living
			melee_damage_type = WHITE_DAMAGE
			broken = TRUE
			playsound(src, 'sound/effects/limbus_death.ogg', 40, 0, 1)
		return
	if(health < (maxHealth / 2)) //50% health or lower
		var/state = pick("red", "white")
		if(state == "white")
			melee_damage_lower = 25
			melee_damage_upper = 35
		else
			melee_damage_type = RED_DAMAGE
		transformed = TRUE
		icon_living = "blubbering_[state]"
		icon_tongue = "blubbering_tongue_[state]"
		icon_state = icon_living
		playsound(src, 'sound/effects/limbus_death.ogg', 40, 0, 1)

/datum/status_effect/blue_resin
	id = "blue resin"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 5 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/blue_resin

/atom/movable/screen/alert/status_effect/blue_resin
	name = "Blue Resin"
	desc = "The gushing gloom has made you more resilient to BLACK damage."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "blueresin"

/datum/status_effect/blue_resin/on_apply()
	. = ..()
	if(ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.black_mod *= 0.9

/datum/status_effect/blue_resin/on_remove()
	. = ..()
	if(ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.black_mod /= 0.9

#undef STATUS_EFFECT_BLUERESIN
