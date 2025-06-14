/mob/living/simple_animal/hostile/abnormality/branch12/deadman
	name = "Dead Man's Plan"
	desc = "A man in a straight jacket."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "deadman"
	icon_living = "deadman"
	del_on_death = TRUE
	maxHealth = 3100	//super slow but tanky
	health = 3100
	rapid_melee = 2
	move_to_delay = 4
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.4, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 0.5)
	melee_damage_lower = 14
	melee_damage_upper = 14
	melee_damage_type = BLACK_DAMAGE	//Doesn't matter, he kills you
	stat_attack = HARD_CRIT
	attack_verb_continuous = "touches"
	attack_verb_simple = "touches"
	attack_sound = 'sound/abnormalities/cleave.ogg'
	faction = list("hostile")
	can_breach = TRUE
	threat_level = WAW_LEVEL
	start_qliphoth = 5

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 45,
		ABNORMALITY_WORK_INSIGHT = 0,
		ABNORMALITY_WORK_ATTACHMENT = 30,
		ABNORMALITY_WORK_REPRESSION = 50,
	)
	work_damage_amount = 12
	work_damage_type = RED_DAMAGE

	//So you can see him coming through doors
	light_color = COLOR_BUBBLEGUM_RED
	light_range = 6
	light_power = 7

	ego_list = list(
		//datum/ego_datum/weapon/departure,
		//datum/ego_datum/armor/departure,
	)
	//gift_type =  /datum/ego_gifts/departure
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12
	var/mob/living/carbon/human/marked_man
	var/list/nearby_players = list()

	patrol_cooldown_time = 5 SECONDS	//Needs to be super common


//Attacking stuff
/mob/living/simple_animal/hostile/abnormality/branch12/deadman/CanAttack(atom/the_target)
	if(ismob(the_target))
		if(the_target!=marked_man)
			return FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/branch12/deadman/AttackingTarget(atom/attacked_target)
	. = ..()
	if(ishuman(attacked_target))
		if(attacked_target==marked_man)	//Instantly kill our man.
			to_chat(marked_man, span_userdanger("Your sins have caught up to you."), confidential = TRUE)
			new /obj/effect/temp_visual/human_horizontal_bisect(get_turf(marked_man))
			marked_man.set_lying_angle(NORTH)
			marked_man.gib()

			say("My job here is done.")
			death()

//Death Stuff
/mob/living/simple_animal/hostile/abnormality/branch12/deadman/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(on_mob_death)) // Hell

/mob/living/simple_animal/hostile/abnormality/branch12/deadman/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	return ..()

/mob/living/simple_animal/hostile/abnormality/branch12/deadman/proc/on_mob_death(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!IsContained())
		return
	if(!istype(died, /mob/living/simple_animal/hostile/abnormality))
		return FALSE
	if(died.z != z)
		return FALSE
	if(!died.lastattackerckey)
		return FALSE
	var/look_for_ckey = died.lastattackerckey
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.ckey == look_for_ckey)
			marked_man = H
	datum_reference.qliphoth_change(-1) // One death reduces it, but it has to be killed by a player
	return TRUE

/mob/living/simple_animal/hostile/abnormality/branch12/deadman/Life(mob/living/carbon/human/user, work_type, pe, work_time)
	..()
	if(IsContained())
		return

	if(prob(20))//Low-effort, low processing way to check if people are constantly around him, to reduce bodyblocking.
		//I won't be emptying this list, so you can't keep pestering him and then running away.
		for(var/mob/living/carbon/human/H in range(2,src))
			if(H in nearby_players)	//If you try to bodyblock him in a door, stun and bleed.
				H.Stun(20)
				H.Knockdown(20)
				H.apply_lc_bleed(15)
				say("Begone. I quarrel not with you, fool.")
				nearby_players -= H
			else
				nearby_players|=H

	//Kill them if they run to the manager's floor.
	if(marked_man.z!=z)
		to_chat(marked_man, span_userdanger("Running means death."), confidential = TRUE)
		new /obj/effect/temp_visual/human_horizontal_bisect(get_turf(marked_man))
		marked_man.set_lying_angle(NORTH)
		marked_man.gib()

		say("What a fool.")
		death()

	if(marked_man.stat == DEAD)
		say("Slain, but not by my hand.")
		death()


//Breach Stuff
/mob/living/simple_animal/hostile/abnormality/branch12/deadman/BreachEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(!marked_man || marked_man.stat == DEAD)
		say("What a coward.")
		death()

	sound_to_playing_players_on_level('sound/abnormalities/silence/bong.ogg', 50, zlevel = z)
	for(var/mob/H in GLOB.player_list)
		to_chat(H, span_userdanger("You. [marked_man]. You will be slain for your sins."))
	..()

//Patrol stuff

/mob/living/simple_animal/hostile/abnormality/branch12/deadman/PickTarget(list/Targets) // Only patrol to the marked
	if(marked_man)
		return marked_man

/mob/living/simple_animal/hostile/abnormality/branch12/deadman/patrol_reset()
	. = ..()
	if(marked_man)
		FindTarget() // KILL HIM, KILL HIM NOW
	else
		say("My job here is done.")
		death()

/mob/living/simple_animal/hostile/abnormality/branch12/deadman/patrol_select()
	var/patrol_turf = get_turf(marked_man)

	var/turf/target_turf = get_closest_atom(/turf/open, patrol_turf, src)

	if(istype(target_turf))
		patrol_path = get_path_to(src, target_turf, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 200)
		return
	return ..()
