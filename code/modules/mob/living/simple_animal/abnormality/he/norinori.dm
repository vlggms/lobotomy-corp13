//Code by Coxswain, sprites by Kojka Kill and "Multiwonder"
/mob/living/simple_animal/hostile/abnormality/norinori //Not li'l helper
	name = "Norinori"
	desc = "It has the appearance of a cartoon fox, but upon closer inspection, it is actually a cat."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "norinori"
	icon_living = "norinori"
	var/icon_aggro = "norinori_breach"
	portrait = "norinori"
	speak_emote = list("meows")
	ranged = TRUE
	maxHealth = 1200
	health = 1200
	attack_sound = 'sound/weapons/slashmiss.ogg'
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 20
	melee_damage_upper = 25
	rapid_melee = 1 //we change this later
	melee_reach = 1
	ranged = TRUE
	damage_coeff = list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	see_in_dark = 10
	stat_attack = HARD_CRIT
	move_to_delay = 7
	threat_level = HE_LEVEL
	can_breach = TRUE
	start_qliphoth = 5
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = 60,
		ABNORMALITY_WORK_ATTACHMENT = -80,
		ABNORMALITY_WORK_REPRESSION = 35,
	)
	work_damage_amount = 10
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/split,
		/datum/ego_datum/armor/split,
	)
	gift_type =  /datum/ego_gifts/split
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

	observation_prompt = "The split fox stands before you. <br>\
		Despite it's unassuming appearance, this thing can kill you in seconds. <br>\
		You have been tasked to work on this creature. <br>\
		What type of work will you attempt? <br>\
		Choose carefully."
	observation_choices = list(
		"Inject Cogito" = list(TRUE, "You prepare to start instinct work .<br>\
			... <br>\
			Checking Vitals <br>\
			... <br>\
			Adjusting Fluid Intake <br>\
			... <br>\
			Allocating 37% Cogito <br>\
			... <br>\
			The work is complete, <br>you report the good result to the work log."),
		"Try to make friends with it" = list(FALSE, "Surely such a cute thing must be friendly, right? <br>\
			It seems you have not learned your lesson <br>\
			The split fox senses your intent. <br>\
			It opens up, revealing a core connected to several sharp cutting tools <br>\
			You are too close to get away."),
	)

//breach related
	var/can_act = TRUE
	var/transformed = FALSE
	pet_bonus = "meows" //saves a few lines of code by allowing funpet() to be called by attack_hand()

//attack vars
	var/split_cooldown
	var/split_cooldown_time = 8 SECONDS

//PLAYABLES ATTACKS
	attack_action_types = list(/datum/action/cooldown/norisplit)

/datum/action/cooldown/norisplit
	name = "Split"
	icon_icon = 'ModularTegustation/Teguicons/32x32.dmi'
	button_icon_state = "norinori"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = 8 SECONDS

/datum/action/cooldown/norisplit/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/norinori))
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/norinori/N = owner
	if(N.IsContained())
		return FALSE
	if(N.transformed)
		N.UnTransform()
		StartCooldown()
		return TRUE
	else
		N.Transform()
		return FALSE

//Init
/mob/living/simple_animal/hostile/abnormality/norinori/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(On_Mob_Death)) // Hell

/mob/living/simple_animal/hostile/abnormality/norinori/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	return ..()

/mob/living/simple_animal/hostile/abnormality/norinori/proc/On_Mob_Death(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!(status_flags & GODMODE)) // If it's breaching right now
		return FALSE
	if(!ishuman(died))
		return FALSE
	if(!died.ckey)
		return FALSE
	if(died.z != z)
		return FALSE
	datum_reference.qliphoth_change(-1) // One death reduces it
	return TRUE

//Work
/mob/living/simple_animal/hostile/abnormality/norinori/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(work_type == ABNORMALITY_WORK_ATTACHMENT && !(GODMODE in user.status_flags))
		KillCheck(user, TRUE)

//Pet it as a clerk, die.
/mob/living/simple_animal/hostile/abnormality/norinori/funpet(mob/petter)
	if(!IsContained())
		return
	if(get_attribute_level(petter, TEMPERANCE_ATTRIBUTE) <= 60)
		KillCheck(petter)
	else
		datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/norinori/proc/KillCheck(mob/living/carbon/human/user)
	if(!IsContained())
		return
	icon_state = "norinori_transformed"
	playsound(src, 'sound/effects/blobattack.ogg', 150, FALSE, 4)
	playsound(src, 'sound/weapons/chainsawhit.ogg', 200, FALSE, 4)
	attack_sound = 'sound/abnormalities/helper/attack.ogg'
	user.Stun(3 SECONDS)
	step_towards(user, src)
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	if(QDELETED(user))
		attack_sound = initial(attack_sound)
		icon_state = IsContained() ? initial(icon_state) : icon_aggro
		return
	step_towards(user, src)
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	if(QDELETED(user))
		attack_sound = initial(attack_sound)
		icon_state = IsContained() ? initial(icon_state) : icon_aggro
		return
	user.attack_animal(src)
	SLEEP_CHECK_DEATH(0.2 SECONDS)
	if(QDELETED(user))
		attack_sound = initial(attack_sound)
		icon_state = IsContained() ? initial(icon_state) : icon_aggro
		return
	user.attack_animal(src)
	SLEEP_CHECK_DEATH(0.5 SECONDS)
	if(QDELETED(user))
		attack_sound = initial(attack_sound)
		icon_state = IsContained() ? initial(icon_state) : icon_aggro
		return
	user.visible_message(span_warning("[src] mutilates [user]!"), span_userdanger("[src] mutilates you!"))
	user.deal_damage(3000, RED_DAMAGE)
	playsound(user, 'sound/abnormalities/helper/attack.ogg', 100, FALSE, 4)
	attack_sound = initial(attack_sound)
	if(user.stat == DEAD)
		user.gib() //update it with cool effects
	SLEEP_CHECK_DEATH(10)
	if(IsContained()) //fixes a bug with invisibility on breach
		icon_state = initial(icon_state)
	else
		icon_state = icon_aggro

/mob/living/simple_animal/hostile/abnormality/norinori/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

//Breach
/mob/living/simple_animal/hostile/abnormality/norinori/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	icon_state = icon_aggro
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	pixel_x = -8
	base_pixel_x = -8

/mob/living/simple_animal/hostile/abnormality/norinori/proc/Transform()
	if(transformed)
		return
	if(split_cooldown > world.time)
		return
	split_cooldown = world.time + split_cooldown_time
	transformed = TRUE
	can_act = FALSE
	icon_state = "norinori_scream"
	SLEEP_CHECK_DEATH(10)
	playsound(src, 'sound/effects/blobattack.ogg', 150, FALSE, 4)
	playsound(src, 'sound/weapons/chainsawhit.ogg', 250, FALSE, 4)
	attack_sound = 'sound/abnormalities/helper/attack.ogg'
	ChangeResistances(list(RED_DAMAGE = 0.1, WHITE_DAMAGE = 1.1, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 1.6))
	can_act = TRUE
	rapid_melee = 3
	melee_reach = 3
	icon_state = "norinori_transformed"

/mob/living/simple_animal/hostile/abnormality/norinori/proc/UnTransform()
	if(!transformed)
		return
	transformed = FALSE
	playsound(src, 'sound/effects/blobattack.ogg', 150, FALSE, 4)
	icon_state = icon_aggro
	attack_sound = 'sound/weapons/slashmiss.ogg'
	SLEEP_CHECK_DEATH(10)
	ChangeResistances(list(RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 2))
	can_act = TRUE
	rapid_melee = 1
	melee_reach = 1

/mob/living/simple_animal/hostile/abnormality/norinori/bullet_act(obj/projectile/P)
	if(transformed) //guns are ineffective on the split form
		visible_message(span_userdanger("[src] swiftly dodges [P]!"))
		P.Destroy()
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/norinori/LoseTarget()
	. = ..()
	if(transformed && !client)
		UnTransform()

//Combat
/mob/living/simple_animal/hostile/abnormality/norinori/Move()
	if(!can_act || transformed)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/norinori/OpenFire()
	if(!can_act || client)
		return
	if(!transformed)
		if((get_dist(src, target) <= 3))
			Transform()
			return
	else
		if((get_dist(src, target) > 3) || !target)
			UnTransform()
