/mob/living/simple_animal/hostile/abnormality/branch12/joe_shmoe
	name = "Joe Shmoe"
	desc = "It's a regular dummy with straw poking out of it."
	icon = 'ModularTegustation/Teguicons/branch12/joe.dmi'
	icon_state = "joe_1"
	icon_living = "joe_1"
	blood_volume = 0
	threat_level = WAW_LEVEL
	start_qliphoth = 4
	can_breach = FALSE
	max_boxes = 22
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 40,
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 40,
	)
	work_damage_amount = 10
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/branch12/joe,
		/datum/ego_datum/armor/branch12/joe,
	)
	//gift_type =  /datum/ego_gifts/signal
	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12

	var/list/joelist = list()
	var/mob/living/carbon/human/marked

/mob/living/simple_animal/hostile/abnormality/branch12/joe_shmoe/Initialize()
	. = ..()
	if(prob(10))
		icon_state = "joe_[rand(1,12)]"

/mob/living/simple_animal/hostile/abnormality/branch12/joe_shmoe/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/joe_shmoe/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(1)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/joe_shmoe/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/branch12/joe_shmoe/Life()
	. = ..()
	if(marked && marked.sanity_lost)
		var/mob/living/simple_animal/hostile/subjoe/S = new (get_turf(marked))
		S.masterjoe = src
		joelist+=S
		marked.gib()
		marked = null

	if(length(joelist) == 0)
		marked = null

/mob/living/simple_animal/hostile/abnormality/branch12/joe_shmoe/ZeroQliphoth(mob/living/carbon/human/user, work_type, pe, work_time)
	..()
	for(var/i = 1 to 6)
		var/turf/W = pick(GLOB.xeno_spawn)
		var/mob/living/simple_animal/hostile/subjoe/S = new (get_turf(W))
		S.masterjoe = src
		joelist+=S


//Most of the meat is in the simples
/mob/living/simple_animal/hostile/subjoe
	name = "Joe Shmoe"
	desc = "It's a regular dummy with straw poking out of it."
	icon = 'ModularTegustation/Teguicons/branch12/joe.dmi'
	icon_state = "joe_1"
	icon_living = "joe_1"
	del_on_death = TRUE
	maxHealth = 800
	health = 800
	density = TRUE
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT
	melee_damage_lower = 20
	melee_damage_upper = 30
	attack_verb_continuous = "stabs"
	attack_verb_simple = "stab"
	attack_sound = 'sound/abnormalities/laetitia/spider_attack.ogg'

	move_resist = MOVE_FORCE_STRONG
	pull_force = MOVE_FORCE_STRONG
	can_buckle_to = FALSE
	mob_size = MOB_SIZE_HUGE
	blood_volume = BLOOD_VOLUME_NORMAL
	simple_mob_flags = SILENCE_RANGED_MESSAGE
	can_patrol = TRUE

	var/mob/living/simple_animal/hostile/abnormality/branch12/joe_shmoe/masterjoe

//Random sprite
/mob/living/simple_animal/hostile/abnormality/branch12/joe_shmoe/Initialize()
	. = ..()
	if(prob(10))
		icon_state = "joe_[rand(1,12)]"
	if(prob(1))
		icon_state = "joe_13"

/mob/living/simple_animal/hostile/subjoe/Life()
	. = ..()
	for(var/mob/living/carbon/human/H in view(3, src))
		if(masterjoe.marked)
			H.deal_damage(2, WHITE_DAMAGE)
		H.deal_damage(10, WHITE_DAMAGE)

	//don't move or attack if there's no marked.
/mob/living/simple_animal/hostile/subjoe/Move()
	if(!masterjoe.marked)
		return FALSE
	. = ..()

/mob/living/simple_animal/hostile/subjoe/CanAttack(atom/the_target)
	if(the_target != masterjoe.marked)
		return FALSE
	. = ..()

//Turn anyone that attacks one into an enemy of all
/mob/living/simple_animal/hostile/subjoe/bullet_act(obj/projectile/Proj)
	..()

	if(!ishuman(Proj.firer))
		return
	masterjoe.marked = Proj.firer

/mob/living/simple_animal/hostile/subjoe/attacked_by(obj/item/I, mob/living/user)
	..()
	if(!user)
		return
	masterjoe.marked = user

/mob/living/simple_animal/hostile/subjoe/PickTarget(list/Targets) // Only patrol to the marked
	if(masterjoe.marked)
		return masterjoe.marked



/mob/living/simple_animal/hostile/subjoe/patrol_reset()
	. = ..()
	if(masterjoe.marked)
		FindTarget() // KILL HIM, KILL HIM NOW

/mob/living/simple_animal/hostile/subjoe/patrol_select()
	if(!masterjoe.marked)
		return

	var/patrol_turf = get_turf(masterjoe.marked)

	var/turf/target_turf = get_closest_atom(/turf/open, patrol_turf, src)

	if(istype(target_turf))
		patrol_path = get_path_to(src, target_turf, TYPE_PROC_REF(/turf, Distance_cardinal), 0, 200)
		return
	return ..()
