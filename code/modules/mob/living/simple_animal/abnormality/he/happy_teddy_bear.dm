// coded by Byrene on July 2022. my first code, please go easy on me
// shoutout to InsightfulParasite for doing the sprites
// TODO: EGO

/mob/living/simple_animal/hostile/abnormality/happyteddybear
	name = "Happy Teddy Bear"
	desc = "A worn-out teddy bear. It's missing an eye and spilling stuffing out of various tears."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "teddy"
	icon_living = "teddy"
	// adding this for when it drops you
	layer = BELOW_OBJ_LAYER
	maxHealth = 200
	health = 200
	threat_level = HE_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 0,
		ABNORMALITY_WORK_INSIGHT = list(40, 45, 45, 35, 35),
		ABNORMALITY_WORK_ATTACHMENT = list(60, 60, 60, 50, 45),
		ABNORMALITY_WORK_REPRESSION = list(40, 45, 45, 40, 35)
	)
	work_damage_amount = 10
	work_damage_type = WHITE_DAMAGE
	max_boxes = 15
	response_help_continuous = "hugs" // :-)
	response_help_simple = "hug"
	buckled_mobs = list()
	buckle_lying = FALSE
	/// if the same person works on Happy Teddy Bear twice in a row, the person will die.
	var/last_worker = null
	var/hugging = FALSE
	ego_list = list(
		/datum/ego_datum/weapon/paw,
		/datum/ego_datum/armor/paw
		)
	gift_type =  /datum/ego_gifts/bearpaw
	pinkable = FALSE // Actually what would I do with this that ISN'T an instant kill?

/mob/living/simple_animal/hostile/abnormality/happyteddybear/proc/Strangle(mob/living/carbon/human/user)
	src.hugging = TRUE
	user.Stun(30 SECONDS)
	step_towards(user, src)
	sleep(0.5 SECONDS)
	step_towards(user, src)
	sleep(0.5 SECONDS)
	src.buckle_mob(user, force=TRUE, check_loc=FALSE)
	src.icon_state = "teddy_hug"
	src.visible_message("<span class='warning'>[src] hugs [user]!</span>")
	var/_last_pinged = 0
	var/_times_strangled = 0
	while(user.stat != DEAD)
		if(_times_strangled > 30) // up to 30 seconds, so this doesn't go on forever
			user.death(gibbed=FALSE)
			break
		if(world.time > _last_pinged + 5 SECONDS)
			to_chat(user, "<span class='userdanger'>[src] is suffocating you!</span>")
			_last_pinged = world.time
		user.adjustOxyLoss(10, updating_health=TRUE, forced=TRUE)
		_times_strangled++
		SLEEP_CHECK_DEATH(1 SECONDS)
	src.unbuckle_mob(user, force=TRUE)
	src.icon_state = "teddy"
	src.visible_message("<span class='warning'>[src] drops [user] to the ground!</span>")
	src.hugging = FALSE

// can only unbuckle dead things
// hopefully prevents people from attempting to "save" the victim, which would break the immersion
// (because strangle code will continue whether they're buckled or not)
/mob/living/simple_animal/hostile/abnormality/happyteddybear/unbuckle_mob(mob/living/buckled_mob, force)
	if(buckled_mob.stat == DEAD)
		. = ..()

/mob/living/simple_animal/hostile/abnormality/happyteddybear/attempt_work(mob/living/carbon/human/user, work_type)
	if(user == src.last_worker)
		Strangle(user)
		return FALSE
	if(src.hugging) // can't work while someone is being killed by it
		return FALSE
	src.last_worker = user
	. = ..()

