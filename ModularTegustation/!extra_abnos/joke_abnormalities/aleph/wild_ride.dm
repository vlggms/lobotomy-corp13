/mob/living/simple_animal/hostile/abnormality/wild_ride
	name = "ride that never ends"
	desc = "A giant skeleton holding a top hat, it seems to be handing out tickets for a roller coaster called \"Mr. Bones Wild Ride\""
	health = 4000
	maxHealth = 4000
	pixel_x = -48
	base_pixel_x = -48
	pixel_y = -20
	base_pixel_y = -20
	icon = 'ModularTegustation/Teguicons/128x128.dmi'
	icon_state = "wild_ride"
	icon_living = "wild_ride"
	portrait = "wild_Ride"
	is_flying_animal = TRUE
	del_on_death = FALSE
	can_breach = FALSE
	threat_level = ALEPH_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 5, 5, 10),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 5, 5, 10),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 5, 5, 10),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 5, 5, 10),
	)
	work_damage_amount = 1
	work_damage_type = PALE_DAMAGE
	max_boxes = 100 //I WANT OFF THIS WILD RIDE!

	can_spawn = FALSE//It's a joke abnormality

	ego_list = list(
		/datum/ego_datum/weapon/wild_ride,
		/datum/ego_datum/armor/wild_ride,
	)
	abnormality_origin = ABNORMALITY_ORIGIN_JOKE

	var/works_in_a_row = 0
	var/saved_work_type = null

//Work mechanics
/mob/living/simple_animal/hostile/abnormality/wild_ride/AttemptWork(mob/living/carbon/human/user, work_type, forced)
	if(user.sanity_lost || user.stat != CONSCIOUS)
		return FALSE
	user.SetImmobilized(30, ignore_canstun = TRUE)
	if(!forced)
		works_in_a_row = 0
		saved_work_type = work_type
		return ..()
	return ..()

/mob/living/simple_animal/hostile/abnormality/wild_ride/WorkChance(mob/living/carbon/human/user, chance) //THE RIDE NEVER ENDS
	if(!works_in_a_row)
		return chance
	return chance * (2 * works_in_a_row)

/mob/living/simple_animal/hostile/abnormality/wild_ride/SpeedWorktickOverride(mob/living/carbon/human/user, work_speed, init_work_speed, work_type) //THE RIDE NEVER ENDS
	return 20 + (3 * works_in_a_row)//I. WANT. OFF. THIS. WILD. RIDE!!!!!

/mob/living/simple_animal/hostile/abnormality/wild_ride/Worktick(mob/living/carbon/human/user) //THE RIDE NEVER ENDS
	user.SetImmobilized(21 + (3 * works_in_a_row), ignore_canstun = TRUE)  //I want off this wild ride! (You can't get off!)
	return

/mob/living/simple_animal/hostile/abnormality/wild_ride/NeutralEffect(mob/living/carbon/human/user, work_type, pe) //THE RIDE NEVER ENDS
	. = ..()
	if(prob(50))
		return
	works_in_a_row += 1
	work_damage_amount = 1
	user.SetImmobilized(10, ignore_canstun = TRUE)
	if(prob(80))
		addtimer(CALLBACK(src, PROC_REF(ForceToWork),user,work_type,TRUE), 5)

/mob/living/simple_animal/hostile/abnormality/wild_ride/FailureEffect(mob/living/carbon/human/user, work_type, pe) //THE RIDE NEVER ENDS
	. = ..()
	works_in_a_row += 2
	work_damage_amount = 2
	user.SetImmobilized(10, ignore_canstun = TRUE)
	addtimer(CALLBACK(src, PROC_REF(ForceToWork),user,work_type,TRUE), 5)

/mob/living/simple_animal/hostile/abnormality/wild_ride/ZeroQliphoth(mob/living/carbon/human/user)
	datum_reference.qliphoth_change(3)
	if(datum_reference.working)
		return
	DoBreachThing()

/mob/living/simple_animal/hostile/abnormality/wild_ride/proc/DoBreachThing()
	var/list/potentialmarked = list()
	var/marked = null
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		if(HAS_TRAIT(L, TRAIT_WORK_FORBIDDEN))
			continue
		potentialmarked += L
		to_chat(L, span_danger("Something horrible is about to happen to someone!"))
	SLEEP_CHECK_DEATH(5 SECONDS)
	if(datum_reference.working) //5 seconds for someone to bravely sacrifice themselves
		return
	for(var/mob/living/carbon/human/H in potentialmarked)
		if(faction_check_mob(H, FALSE) || H.z != z || H.stat == DEAD || H.is_working) //hostile, off-z, dead, or working
			continue
		to_chat(H, span_userdanger("WIIIIIILD RIIIDE!"))
		marked = H
		break
	if(!marked)
		return
	ForceToWork(marked, ABNORMALITY_WORK_INSTINCT, TRUE)

/mob/living/simple_animal/hostile/abnormality/wild_ride/proc/ForceToWork(mob/living/carbon/human/user, work_type, forced)
	DropPlayerByConsole(user)
	SLEEP_CHECK_DEATH(5)
	if(AttemptWork(user, saved_work_type, TRUE)) //THE RIDE NEVER ENDS
		datum_reference.console.start_work(user, saved_work_type)
		to_chat(user, span_userdanger("THE RIDE NEVER ENDS!"))

/mob/living/simple_animal/hostile/abnormality/wild_ride/proc/DropPlayerByConsole(mob/living/carbon/human/user)
	var/turf/dispense_turf = get_step(datum_reference.console, pick(2,8,10)) //south, west, southwest
	if(!isopenturf(dispense_turf))
		dispense_turf = get_turf(datum_reference.console)
	user.forceMove(dispense_turf)
	user.SetImmobilized(30, ignore_canstun = TRUE)
