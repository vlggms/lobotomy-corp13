/mob/living/simple_animal/hostile/abnormality/bloodbath
	name = "Bloodbath"
	desc = "A constantly dripping bath of blood"
	icon = 'ModularTegustation/Teguicons/48x64.dmi'
	icon_state = "bloodbath"
	maxHealth = 500
	health = 500
	threat_level = TETH_LEVEL
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 2, PALE_DAMAGE = 0.8)
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(55, 55, 50, 50, 50),
		ABNORMALITY_WORK_INSIGHT = list(45, 45, 40, 40, 40),
		ABNORMALITY_WORK_ATTACHMENT = 60,
		ABNORMALITY_WORK_REPRESSION = list(30, 20, 10, 0, 0)
	)
	work_damage_amount = 8
	work_damage_type = WHITE_DAMAGE
	max_boxes = 14

	base_pixel_x = -16
	pixel_x = -16

	rapid_melee = 8
	melee_damage_lower = 4
	melee_damage_upper = 7
	melee_damage_type = RED_DAMAGE
	attack_sound = 'sound/weapons/punch1.ogg'
	move_to_delay = 4
	stat_attack = HARD_CRIT

	ego_list = list(
		/datum/ego_datum/weapon/wrist,
		/datum/ego_datum/armor/wrist
	)

	//gift_type =  /datum/ego_gifts/bloodbath
	var/melee_cooldown = 8 SECONDS
	var/melee_cooldown_time
	var/mob/living/carbon/human/pull_victim
	var/grab_attempt = FALSE
	var/hands = 0


/mob/living/simple_animal/hostile/abnormality/bloodbath/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
// any work performed with level 1 Fort or Temperance makes you panic and die
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 40 || get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 40 || (hands == 3 && prob(50)))
		icon = 'ModularTegustation/Teguicons/48x64.dmi'
		icon_state = "bloodbath_a[hands]"
		user.Stun(30 SECONDS)
		step_towards(user, src)
		sleep(0.5 SECONDS)
		step_towards(user, src)
		sleep(0.5 SECONDS)
		user.dust()
		visible_message("<span class='warning'>[src] drags [user] into itself!</span>")
		playsound(get_turf(src),'sound/effects/wounds/blood2.ogg')
		playsound(get_turf(src),'sound/effects/footstep/water1.ogg')
		SLEEP_CHECK_DEATH(3 SECONDS)
		hands ++
		if(hands < 4)
			max_boxes += 4
			icon_state = "bloodbath[hands]"
		else
			hands = 0
			max_boxes = 14
			icon_state = "bloodbath"
		return

/mob/living/simple_animal/hostile/abnormality/bloodbath/breach_effect(mob/living/carbon/human/user)
	. = ..()
	update_icon_state()

/mob/living/simple_animal/hostile/abnormality/bloodbath/MeleeAction(patience)
	if(melee_cooldown_time < world.time)
		melee_cooldown_time = world.time + melee_cooldown
		grab_attempt = FALSE
		var/datum/callback/cb = CALLBACK(src, .proc/CheckAndAttack)
		var/delay = SSnpcpool.wait / rapid_melee
		for(var/i in 1 to rapid_melee)
			addtimer(cb, (i - 1)*delay)
	if(patience)
		GainPatience()

/mob/living/simple_animal/hostile/abnormality/bloodbath/AttackingTarget()
	attack_sound = pick('sound/weapons/punch1.ogg', 'sound/weapons/punch2.ogg', 'sound/weapons/punch3.ogg', 'sound/weapons/punch4.ogg')
	if(ishuman(target))
		if(target != pull_victim)
			pull_victim = target
			stop_pulling()
		if(!pulling)
			pull_victim.grabbedby(src)
		if(pulling && !grab_attempt)
			grab_attempt = TRUE
			pull_victim.grippedby(src, TRUE)
	update_icon_state()
	. = ..()

/mob/living/simple_animal/hostile/abnormality/bloodbath/update_icon_state()
	if(pulling)
		icon_state = "bloodbath_a3"
	else
		icon_state = "bloodbath3"

/mob/living/simple_animal/hostile/abnormality/bloodbath/Move()
	update_icon_state()
	. = ..()
