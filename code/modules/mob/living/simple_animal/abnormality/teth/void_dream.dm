/mob/living/simple_animal/hostile/abnormality/voiddream
	name = "Void Dream"
	desc = "A very fluffy floating sheep.."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "void_dream"
	icon_living = "void_dream"
	portrait = "void_dream"
	del_on_death = TRUE
	is_flying_animal = TRUE
	maxHealth = 600
	health = 600
	rapid_melee = 2
	move_to_delay = 6
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2)
	patrol_cooldown_time = 5 SECONDS // Zooming around the place

	attack_verb_continuous = "nuzzles"
	attack_verb_simple = "nuzzles"
	faction = list("neutral", "hostile")
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 45,
		ABNORMALITY_WORK_INSIGHT = 45,
		ABNORMALITY_WORK_ATTACHMENT = 60,
		ABNORMALITY_WORK_REPRESSION = 20,
	)
	work_damage_amount = 6
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/dream,
		/datum/ego_datum/armor/dream,
	)
	gift_type =  /datum/ego_gifts/dream
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "\"There's nothing wrong with dreams. <br>\
		I go out and bring such sweet dreams to those who've only learned to stop dreaming, <br>\
		I'm not to blame if their dreams are so entrancing they become hollow people in their waking lives, am I not? <br>\
		Don't you want such sweet dreams too?\""
	observation_choices = list(
		"You're a demon" = list(TRUE, "\"Don't say such scary, complicated things. <br>I just gave them the enrapturing dreams they wanted. <br>They're destined to come back to me.\""),
		"Please, eat my dreams" = list(FALSE, "It's alright, dreams are harmless but unnecessary things. <br>So, just close your eyes and show me your most delectable dream..."),
	)

	var/punched = FALSE
	var/pulse_damage = 50
	var/ability_cooldown
	var/ability_cooldown_time = 12 SECONDS

/mob/living/simple_animal/hostile/abnormality/voiddream/Initialize()
	. = ..()
	if(IsCombatMap())
		faction = list("hostile") //So that they don't target pino specificlly on RCA

/mob/living/simple_animal/hostile/abnormality/voiddream/Life()
	. = ..()
	if(!.)
		return
	PerformAbility()
	if(punched && prob(33))
		playsound(get_turf(src), "sound/abnormalities/voiddream/ambient_[pick(1,2)].ogg", 50, TRUE)

/mob/living/simple_animal/hostile/abnormality/voiddream/PickTarget(list/Targets)
	return

/mob/living/simple_animal/hostile/abnormality/voiddream/CanAttack(atom/the_target)
	return FALSE

//Getting hit
/mob/living/simple_animal/hostile/abnormality/voiddream/attackby(obj/item/I, mob/living/user, params)
	..()
	Transform()

/mob/living/simple_animal/hostile/abnormality/voiddream/bullet_act(obj/projectile/P)
	..()
	Transform()

/mob/living/simple_animal/hostile/abnormality/voiddream/proc/Transform()
	if(IsContained())
		return
	if(punched)
		return
	if(IsCombatMap())
		return
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	punched = TRUE
	ChangeMoveToDelayBy(-2)
	ability_cooldown_time = 8 SECONDS
	ability_cooldown = 0
	REMOVE_TRAIT(src, TRAIT_MOVE_FLYING, ROUNDSTART_TRAIT)

/mob/living/simple_animal/hostile/abnormality/voiddream/proc/DelPassive()
	if(punched)
		return
	animate(src, alpha = 0, time = 5)
	QDEL_IN(src, 5)

/mob/living/simple_animal/hostile/abnormality/voiddream/proc/PerformAbility()
	if(ability_cooldown > world.time)
		return
	ability_cooldown = world.time + ability_cooldown_time
	if(punched)
		INVOKE_ASYNC(src, PROC_REF(Shout))
	else
		INVOKE_ASYNC(src, PROC_REF(SleepyDart))

/mob/living/simple_animal/hostile/abnormality/voiddream/proc/SleepyDart()
	var/list/possibletargets = list()
	for(var/mob/living/carbon/human/H in view(10, src))
		if(faction_check(src.faction, H.faction))
			continue
		if(H.IsSleeping())
			continue
		if(H.stat >= SOFT_CRIT)
			continue
		possibletargets += H
	if(!LAZYLEN(possibletargets))
		return

	playsound(get_turf(src), 'sound/abnormalities/voiddream/fire.ogg', 50, TRUE)
	var/obj/projectile/P = new /obj/projectile/sleepdart(get_turf(src))
	P.firer = src
	var/bullet_target = pick(possibletargets)
	P.original = bullet_target
	P.fire(Get_Angle(src, bullet_target))

/mob/living/simple_animal/hostile/abnormality/voiddream/proc/Shout()
	playsound(get_turf(src), 'sound/abnormalities/voiddream/shout.ogg', 75, FALSE, 5)
	for(var/mob/living/carbon/human/L in urange(10, src))
		if(faction_check(src.faction, L.faction)) // I LOVE NESTING IF STATEMENTS
			continue
		if(L.has_status_effect(STATUS_EFFECT_SLEEPING))
			L.SetSleeping(0)
			L.adjustSanityLoss(1000) //Die.
			continue
		L.deal_damage(pulse_damage, WHITE_DAMAGE)
	for(var/i = 1 to 5)
		var/obj/effect/temp_visual/screech/S = new(get_turf(src))
		S.pixel_y = 16
		S.color = COLOR_RED
		SLEEP_CHECK_DEATH(1)

// Work stuff
/mob/living/simple_animal/hostile/abnormality/voiddream/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/voiddream/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 40)
		user.drowsyness += 30
		user.Sleeping(30 SECONDS) //Not a big fan of killing you, take a little nap.
		playsound(get_turf(user), 'sound/abnormalities/voiddream/skill.ogg', 50, TRUE)
	return

/mob/living/simple_animal/hostile/abnormality/voiddream/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	ability_cooldown = world.time + 4 SECONDS
	if(IsCombatMap())
		return
	addtimer(CALLBACK(src, PROC_REF(DelPassive)), rand((3 MINUTES), (5 MINUTES)))

// Projectile code
/obj/projectile/sleepdart
	name = "void dream"
	icon_state = "antimagic"
	color = "#FCF344"
	damage = 0
	speed = 3
	homing = TRUE
	homing_turn_speed = 25 //Angle per tick.
	var/homing_range = 9

/obj/projectile/sleepdart/Initialize()
	. = ..()
	var/list/targetslist = list()
	for(var/mob/living/carbon/human/H in view(homing_range, src))
		if(H.IsSleeping())
			continue
		targetslist += H
	if(!LAZYLEN(targetslist))
		return
	homing_target = pick(targetslist)

/obj/projectile/sleepdart/on_hit(atom/target, blocked = FALSE)
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(H.IsSleeping())
		return
	H.SetSleeping(30 SECONDS) // Used to be a full minute
	var/datum/status_effect/incapacitating/sleeping/S = H.IsSleeping()
	S.remove_on_damage = TRUE
	playsound(get_turf(H), 'sound/abnormalities/voiddream/skill.ogg', 50, TRUE)
