/mob/living/simple_animal/hostile/abnormality/tangle
	name = "Tangle"
	desc = "What seems to be a severed head laying in a tangle of hair."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "tangle"
	icon_living = "tangle"
	portrait = "tangle"
	maxHealth = 1600
	health = 1600
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	melee_damage_lower = 0		//Doesn't attack
	melee_damage_upper = 0
	rapid_melee = 2
	melee_damage_type = WHITE_DAMAGE
	stat_attack = HARD_CRIT
	faction = list("hostile")
	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 80,
		ABNORMALITY_WORK_INSIGHT = list(50, 50, 40, 40, 40),
		ABNORMALITY_WORK_ATTACHMENT = list(50, 50, 40, 40, 40),
		ABNORMALITY_WORK_REPRESSION = list(50, 50, 40, 40, 40),
	)
	work_damage_amount = 5
	work_damage_type = WHITE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/sloth
	ego_list = list(
		/datum/ego_datum/weapon/rapunzel,
		/datum/ego_datum/armor/rapunzel,
	)
//	gift_type =  /datum/ego_gifts/rapunzel
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	var/chosen
	var/instinct_count
	var/list/hair_list = list()

/mob/living/simple_animal/hostile/abnormality/tangle/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/tangle/CanAttack(atom/the_target)
	return FALSE

//Grab a list of all agents and picks one
/mob/living/simple_animal/hostile/abnormality/tangle/Initialize()
	. = ..()
	var/list/potentialmarked = list()
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		if(HAS_TRAIT(usr, TRAIT_WORK_FORBIDDEN)) //Don't get non agents
			continue
		potentialmarked += L

	if(length(potentialmarked) <= 1) //If there's only one or none of you, then don't do it. I'm not that evil.
		return
	chosen = pick(potentialmarked)



/mob/living/simple_animal/hostile/abnormality/tangle/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	// If your'e the chosen, lower
	if(user == chosen)
		datum_reference.qliphoth_change(-1)
		icon_state = "tangleawake"
		return

	if(work_type == ABNORMALITY_WORK_INSTINCT)
		instinct_count+=1
		if((instinct_count==3) || (instinct_count == 6))
			datum_reference.qliphoth_change(-1)
			icon_state = "tangleawake"

/mob/living/simple_animal/hostile/abnormality/tangle/BreachEffect()
	..()
	icon_state = "tangle"
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	new /obj/structure/spreading/tangle_hair (src)


/mob/living/simple_animal/hostile/abnormality/tangle/death()
	for(var/V in hair_list)
		qdel(V)
		hair_list-=V
	..()


// Hair turf
/obj/structure/spreading/tangle_hair
	gender = PLURAL
	name = "blonde hair"
	desc = "a patch of blonde hair."
	icon = 'icons/effects/effects.dmi'
	icon_state = "tanglehair"
	anchored = TRUE
	density = FALSE
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	max_integrity = 20
	base_icon_state = "tanglehair"
	var/mob/living/simple_animal/hostile/abnormality/tangle/connected_abno

/obj/structure/spreading/tangle_hair/Initialize()
	. = ..()

	//Stolen from Snow White's. Thanks Para!
	if(!connected_abno)
		connected_abno = locate(/mob/living/simple_animal/hostile/abnormality/tangle) in GLOB.abnormality_mob_list
	if(connected_abno)
		connected_abno.hair_list += src
	expand()


/obj/structure/spreading/tangle_hair/expand()
	addtimer(CALLBACK(src, PROC_REF(expand)), 5 SECONDS)
//	if(connected_abno.hair_list.len>=150)
// 		return
	..()

/obj/structure/spreading/tangle_hair/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.apply_damage(1, WHITE_DAMAGE, null, H.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		if(prob(10))
			H.Immobilize(5)
			to_chat(H, span_warning("You get caught in the hair!"))
