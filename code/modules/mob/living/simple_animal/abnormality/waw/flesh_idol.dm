/mob/living/simple_animal/hostile/abnormality/flesh_idol
	name = "Flesh Idol"
	desc = "A cross with flesh stapled in the middle."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "flesh_idol"
	portrait = "flesh_idol"
	maxHealth = 600
	health = 600
	threat_level = WAW_LEVEL
	pixel_x = -16
	base_pixel_x = -16
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 55,
		ABNORMALITY_WORK_INSIGHT = 55,
		ABNORMALITY_WORK_ATTACHMENT = 55,
		ABNORMALITY_WORK_REPRESSION = 55,
	)
	start_qliphoth = 1
	max_boxes = 20
	work_damage_amount = 0		//Work damage is later
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/heart,
		/datum/ego_datum/armor/heart,
	)
	gift_type = /datum/ego_gifts/heart
	abnormality_origin = ABNORMALITY_ORIGIN_ALTERED

	var/work_count = 0
	var/breach_count = 4	//when do you breach?
	var/reset_time = 1 MINUTES
	var/damage_amount = 7
	var/run_num = 2		//How many things you breach

	var/list/blacklist = list(
		/mob/living/simple_animal/hostile/abnormality/melting_love,
		/mob/living/simple_animal/hostile/abnormality/distortedform,
		/mob/living/simple_animal/hostile/abnormality/white_night,
		/mob/living/simple_animal/hostile/abnormality/nihil,
		/mob/living/simple_animal/hostile/abnormality/galaxy_child,
		/mob/living/simple_animal/hostile/abnormality/fetus,
		/mob/living/simple_animal/hostile/abnormality/crying_children,
	)

/mob/living/simple_animal/hostile/abnormality/flesh_idol/WorkComplete(mob/living/carbon/human/user, work_type, pe)
	..()
	work_count += 1
	//heal amount = the PE you made
	var/heal_amount = pe*2

	if(work_count >= breach_count)
		work_count = 0
		datum_reference.qliphoth_change(-1)
		heal_amount = pe*4

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat != DEAD)
			H.adjustBruteLoss(-heal_amount) // It heals everyone by 50 or 100 points
			H.adjustSanityLoss(-heal_amount) // It heals everyone by 50 or 100 points
			new /obj/effect/temp_visual/healing(get_turf(H))
	heal_amount = initial(heal_amount)


/mob/living/simple_animal/hostile/abnormality/flesh_idol/Worktick(mob/living/carbon/human/user)
	var/list/damtypes = list(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	var/damage = pick(damtypes)
	work_damage_type = damage
	user.apply_damage(damage_amount, damage, null, user.run_armor_check(null, damage)) // take 5 random damage each time
	WorkDamageEffect()

//Prevents red work damage effecs from appearing
/mob/living/simple_animal/hostile/abnormality/flesh_idol/WorktickFailure(mob/living/carbon/human/user)
	return

//Meltdown
/mob/living/simple_animal/hostile/abnormality/flesh_idol/ZeroQliphoth(mob/living/carbon/human/user)
	addtimer(CALLBACK (datum_reference, TYPE_PROC_REF(/datum/abnormality, qliphoth_change), 4), reset_time)
	var/list/total_abnormalities = list()

	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list)
		if(A.datum_reference.qliphoth_meter > 0 && A.IsContained() && !(A.type in blacklist) && A.z == z)
			total_abnormalities += A

	if(!LAZYLEN(total_abnormalities))
		return

	var/mob/living/simple_animal/hostile/abnormality/processing = pick(total_abnormalities)
	processing.datum_reference.qliphoth_change(-200)
