/mob/living/simple_animal/hostile/abnormality/scarecrow
	name = "Scarecrow Searching for Wisdom"
	desc = "An abnormality taking form of a scarecrow with metal rake in place of its hand."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "scarecrow"
	icon_living = "scarecrow"
	icon_dead = "scarecrow_dead"
	portrait = "scarecrow"
	del_on_death = FALSE
	maxHealth = 1000
	health = 1000
	rapid_melee = 2
	move_to_delay = 3
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 2)
	melee_damage_lower = 20
	melee_damage_upper = 24
	melee_damage_type = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = 'sound/abnormalities/scarecrow/attack.ogg'
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 45,
		ABNORMALITY_WORK_INSIGHT = list(50, 60, 70, 80, 90),
		ABNORMALITY_WORK_ATTACHMENT = 45,
		ABNORMALITY_WORK_REPRESSION = 45,
	)
	work_damage_amount = 10
	work_damage_type = WHITE_DAMAGE
	death_message = "stops moving, with its torso rotating forwards."
	death_sound = 'sound/abnormalities/scarecrow/death.ogg'

	ego_list = list(
		/datum/ego_datum/weapon/harvest,
		/datum/ego_datum/armor/harvest,
	)
	gift_type =  /datum/ego_gifts/harvest
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/road_home = 2,
		/mob/living/simple_animal/hostile/abnormality/woodsman = 2,
		/mob/living/simple_animal/hostile/abnormality/scaredy_cat = 2,
		// Ozma = 2,
		/mob/living/simple_animal/hostile/abnormality/pinocchio = 1.5,
	)

	observation_prompt = "Poor stuffing of straw. <br>I'll give you the wisdom to ponder over anything. <br>The wizard grants you..."
	observation_choices = list(
		"A silk sack of sawdust" = list(TRUE, "Do you think jabbering away with your oh-so smart mouth is all that matters?"),
		"Wisdom" = list(FALSE, "Come closer. <br>I’ll help you forget all of your woes and worries."),
	)

	/// Can't move/attack when it's TRUE
	var/finishing = FALSE
	var/braineating = TRUE
	var/healthmodifier = 0.05	// Can restore 30% of HP
	var/attack_healthmodifier = 0.05
	var/target_hit = FALSE
	var/hunger = FALSE

	attack_action_types = list(/datum/action/cooldown/hungering)

/mob/living/simple_animal/hostile/abnormality/scarecrow/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	to_chat(src, "<h1>You are Scarecrow Searching for Wisdom, A Tank Role Abnormality.</h1><br>\
		<b>|Seeking Wisdom|: When you attack corpses, You heal.<br>\
		Unlike other abnormalities which use corpses, you are able to reuse the corpses you drain as many times as you would like.<br>\
		|Hungering for Wisdom|: You have an ability which causes you to enter a 'Hungering' State.<br>\
		While you are in the 'Hungering' State, You have increased movement speed and melee damage. As well, Your melee attack heal 5% of your max HP on hit.<br>\
		You will need to hit at least on human every 6 seconds in order to keep this state active.<br>\
		However, If you don't hit any humans you will lose 5% of your max HP, become slowed down for 3.5 seconds and lose your 'Hungering' state.</b>")

/datum/action/cooldown/hungering
	name = "Hungering for Wisdom"
	icon_icon = 'icons/mob/actions/actions_rcorp.dmi'
	button_icon_state = "hungering"
	desc = "Gain a short speed/damage boost to rush at your foes!"
	cooldown_time = 300
	var/speeded_up = 1.5
	var/punishment_speed = 6
	var/speed_duration = 60
	var/weaken_duration = 30
	var/min_dam_buff = 35
	var/max_dam_buff = 40
	var/min_dam_old
	var/max_dam_old
	var/old_speed

/datum/action/cooldown/hungering/Trigger()
	if(!..())
		return FALSE
	if (istype(owner, /mob/living/simple_animal/hostile/abnormality/scarecrow))
		var/sound/heartbeat = sound('sound/health/fastbeat.ogg', repeat = TRUE)
		var/mob/living/simple_animal/hostile/abnormality/scarecrow/H = owner
		if(H.hunger == TRUE)
			to_chat(H, span_nicegreen("YOU ARE RUSHING RIGHT NOW!"))
			return FALSE
		else
			old_speed = H.move_to_delay
			H.move_to_delay = speeded_up
			H.playsound_local(get_turf(H),heartbeat,40,0, channel = CHANNEL_HEARTBEAT, use_reverb = FALSE)
			H.UpdateSpeed()
			H.target_hit = FALSE
			H.color = "#ff5770"
			H.manual_emote("starts twitching...")
			H.hunger = TRUE
			min_dam_old = H.melee_damage_lower
			max_dam_old = H.melee_damage_upper
			H.melee_damage_lower = min_dam_buff
			H.melee_damage_upper = max_dam_buff
			to_chat(H, span_nicegreen("THEIR WISDOM, SHALL BE YOURS!"))
			addtimer(CALLBACK(src, PROC_REF(Hunger)), speed_duration)
			StartCooldown()

/datum/action/cooldown/hungering/proc/Hunger()
	if (istype(owner, /mob/living/simple_animal/hostile/abnormality/scarecrow))
		var/mob/living/simple_animal/hostile/abnormality/scarecrow/H = owner
		if (H.target_hit)
			addtimer(CALLBACK(src, PROC_REF(Hunger)), speed_duration)
			H.target_hit = FALSE
			to_chat(H, span_nicegreen("YOUR FEAST CONTINUES!"))
		else
			H.stop_sound_channel(CHANNEL_HEARTBEAT)
			H.melee_damage_lower = min_dam_old
			H.melee_damage_upper = max_dam_old
			H.move_to_delay = punishment_speed
			H.deal_damage(100, WHITE_DAMAGE)
			H.color = null
			H.manual_emote("starts slowing down...")
			to_chat(H, span_userdanger("No... I need that wisdom..."))
			H.target_hit = TRUE
			addtimer(CALLBACK(src, PROC_REF(RushEnd)), weaken_duration)
			H.UpdateSpeed()

/datum/action/cooldown/hungering/proc/RushEnd()
	if (istype(owner, /mob/living/simple_animal/hostile/abnormality/scarecrow))
		var/mob/living/simple_animal/hostile/abnormality/scarecrow/H = owner
		H.move_to_delay = old_speed
		to_chat(H, span_nicegreen("You calm down from your feast..."))
		H.hunger = FALSE
		H.UpdateSpeed()


/mob/living/simple_animal/hostile/abnormality/scarecrow/CanAttack(atom/the_target)
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/scarecrow/Move()
	if(finishing)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/scarecrow/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/scarecrow/AttackingTarget(atom/attacked_target)
	. = ..()
	if(.)
		if(!istype(attacked_target, /mob/living/carbon/human))
			return
		target_hit = TRUE
		if (hunger == TRUE)
			adjustBruteLoss(-(maxHealth*attack_healthmodifier))
			playsound(get_turf(src), 'sound/abnormalities/scarecrow/start_drink.ogg', 50, 1)
		var/mob/living/carbon/human/H = target
		if(H.health < 0 && stat != DEAD && !finishing && H.getorgan(/obj/item/organ/brain))
			finishing = TRUE
			H.Stun(10 SECONDS)
			playsound(get_turf(src), 'sound/abnormalities/scarecrow/start_drink.ogg', 50, 1)
			SLEEP_CHECK_DEATH(2)
			for(var/i = 1 to 6)
				if(!targets_from.Adjacent(H) || QDELETED(H)) // They can still be saved if you move them away
					finishing = FALSE
					return
				playsound(get_turf(src), 'sound/abnormalities/scarecrow/drink.ogg', 50, 1)
				if (!IsCombatMap())
					if(H.health < -120) //prevents infinite healing, corpse is too mangled
						break
					H.adjustBruteLoss(20)
				adjustBruteLoss(-(maxHealth*healthmodifier))
				SLEEP_CHECK_DEATH(4)
			if(!targets_from.Adjacent(H) || QDELETED(H))
				finishing = FALSE
				return
			if(braineating)
				for(var/obj/item/organ/O in H.getorganszone(BODY_ZONE_HEAD, TRUE))
					O.Remove(H)
					QDEL_NULL(O)
			finishing = FALSE

/mob/living/simple_animal/hostile/abnormality/scarecrow/WorkChance(mob/living/carbon/human/user, chance, work_type)
	var/newchance = chance
	if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) >= 60)
		newchance = chance-20
	return newchance

/mob/living/simple_animal/hostile/abnormality/scarecrow/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return


/mob/living/simple_animal/hostile/abnormality/scarecrow/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) >= 60)
		if(prob(40))
			datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/scarecrow/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	icon_living = "scarecrow_breach"
	icon_state = icon_living
	GiveTarget(user)
