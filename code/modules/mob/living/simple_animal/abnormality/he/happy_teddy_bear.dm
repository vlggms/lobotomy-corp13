// coded by Byrene on July 2022. my first code, please go easy on me
// shoutout to InsightfulParasite for doing the sprites
/mob/living/simple_animal/hostile/abnormality/happyteddybear
	name = "Happy Teddy Bear"
	desc = "A worn-out teddy bear. It's missing an eye and spilling stuffing out of various tears."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "teddy"
	icon_living = "teddy"
	portrait = "happy_teddy_bear"
	// adding this for when it drops you
	layer = BELOW_OBJ_LAYER
	maxHealth = 200
	health = 200
	threat_level = HE_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 0,
		ABNORMALITY_WORK_INSIGHT = list(40, 45, 45, 35, 35),
		ABNORMALITY_WORK_ATTACHMENT = list(60, 60, 60, 50, 45),
		ABNORMALITY_WORK_REPRESSION = list(40, 45, 45, 40, 35),
	)
	work_damage_amount = 10
	work_damage_type = WHITE_DAMAGE
	max_boxes = 15
	response_help_continuous = "hugs" // :-)
	response_help_simple = "hug"
	buckled_mobs = list()
	buckle_lying = FALSE

	ego_list = list(
		/datum/ego_datum/weapon/paw,
		/datum/ego_datum/armor/paw,
	)
	gift_type =  /datum/ego_gifts/bearpaw
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "Here lies a piece of rubbish, a teddy bear. <br>Its wool sticks out here and there. <br>\
		The amount of dust piled up on it tells how long this teddy has been abandoned. <br>One of the buttons, which are eyes, is hanging loose."
	observation_choices = list(
		"Take the button off" = list(TRUE, "You took the button off. <br>It was disturbing for some reason. <br>The button is old and rotten and makes you uncomfortable. <br>\
			You replace the button with one off your suit with great care. <br>While the teddy looks awkward because of the mismatching buttons, it adds to its charm."),
		"Leave it alone" = list(FALSE, "You don't know what to do with it so you just left it alone. <br>The teddy sits there without any movement."),
	)

	/// if the same person works on Happy Teddy Bear twice in a row, the person will die unless certain requirements are met.
	var/last_worker = null
	var/hugging = FALSE
	var/break_check

/mob/living/simple_animal/hostile/abnormality/happyteddybear/proc/Strangle(mob/living/carbon/human/user)
	hugging = TRUE
	user.Stun(30 SECONDS)
	step_towards(user, src)
	sleep(0.5 SECONDS)
	if(QDELETED(user))
		hugging = FALSE
		last_worker = null
		return
	step_towards(user, src)
	sleep(0.5 SECONDS)
	if(QDELETED(user))
		hugging = FALSE
		last_worker = null
		return
	buckle_mob(user, force = TRUE, check_loc = FALSE)
	icon_state = "teddy_hug"
	visible_message(span_warning("[src] hugs [user]!"))
	var/last_pinged = 0
	var/time_strangled = 0
	while(user.stat != DEAD)
		if(time_strangled >= 4 && get_attribute_level(user, FORTITUDE_ATTRIBUTE) >= 80)
			if(user.stat != UNCONSCIOUS) //Wouldn't make sense if they break free while passed out
				break_check = TRUE
				unbuckle_mob(user, force=TRUE)
				icon_state = "teddy"
				visible_message(span_warning("[user] breaks free from [src]'s hug!"))
				hugging = FALSE
				last_worker = null
				user.SetStun(0)
				break_check = FALSE
				return
		if(time_strangled > 30) // up to 30 seconds, so this doesn't go on forever
			user.death(gibbed=FALSE)
			break
		if(world.time > last_pinged + 5 SECONDS)
			to_chat(user, span_userdanger("[src] is suffocating you!"))
			last_pinged = world.time
		user.adjustOxyLoss(10, updating_health=TRUE, forced=TRUE)
		time_strangled++
		SLEEP_CHECK_DEATH(1 SECONDS)
		if(QDELETED(user))
			hugging = FALSE
			last_worker = null
			icon_state = "teddy"
			return
	unbuckle_mob(user, force=TRUE)
	icon_state = "teddy"
	visible_message(span_warning("[src] drops [user] to the ground!"))
	hugging = FALSE
	last_worker = null

// can only unbuckle dead things
// hopefully prevents people from attempting to "save" the victim, which would break the immersion
// (because strangle code will continue whether they're buckled or not)
/mob/living/simple_animal/hostile/abnormality/happyteddybear/unbuckle_mob(mob/living/buckled_mob, force)
	if(buckled_mob.stat != DEAD && break_check == FALSE)
		return
	..()

/mob/living/simple_animal/hostile/abnormality/happyteddybear/AttemptWork(mob/living/carbon/human/user, work_type)
	if(hugging) // can't work while someone is being killed by it
		return FALSE
	if(user == last_worker)
		Strangle(user)
		return FALSE
	last_worker = user
	return TRUE
