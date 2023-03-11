#define INHOSPITABLE_FOR_NESTING 280

/mob/living/simple_animal/hostile/abnormality/naked_nest
	name = "Naked Nest"
	desc = "A pulsating round object covered with glistening scales. Tan sludge drips from numerous holes, and something appears to be moving beneath the surface."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "nakednest_inert"
	icon_living = "nakednest_inert"
	pixel_x = -8
	base_pixel_x = -8
	maxHealth = 800
	health = 800
	threat_level = WAW_LEVEL //If Naked Nest escaped from the facility it would result in a mass infestation of several civilians. That is bad.
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(40, 45, 50, 50, 55),
		ABNORMALITY_WORK_INSIGHT = 0,
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 45, 45, 50),
		ABNORMALITY_WORK_REPRESSION = list(40, 40, 40, 40, 40)
		)
	work_damage_amount = 14
	work_damage_type = RED_DAMAGE
	max_boxes = 22
	start_qliphoth = 1
	fear_level = 1

	ego_list = list(
		/datum/ego_datum/weapon/exuviae,
		/datum/ego_datum/armor/exuviae
		)
	gift_type =  /datum/ego_gifts/exuviae
	gift_message = "You manage to shave off a patch of scales."

	can_patrol = FALSE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5) //same stats as original armor
	stat_attack = HARD_CRIT
	ranged = TRUE
	ranged_cooldown_time = 1 SECONDS
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	faction = list("hostile", "Naked_Nest")
	deathmessage = "collapses as its residents flee."
	deathsound = 'sound/effects/dismember.ogg'
	var/serpentsnested = 4
	var/origin_cooldown
	var/origin_cooldown_delay = 20 SECONDS //to prevent serpent floods

/mob/living/simple_animal/hostile/abnormality/naked_nest/Initialize()
	. = ..()
	origin_cooldown = world.time + origin_cooldown_delay

/mob/living/simple_animal/hostile/abnormality/naked_nest/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	to_chat(user, "<span class='notice'>The serpents seem to avoid areas of their nest covered in this solution.</span>")
	new /obj/item/serpentspoision(get_turf(user))
	return

/mob/living/simple_animal/hostile/abnormality/naked_nest/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	if(prob(30 + ((user.health / user.maxHealth)*100)))
		user.apply_status_effect(/datum/status_effect/serpents_host)
	return

/mob/living/simple_animal/hostile/abnormality/naked_nest/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	if(prob(60 + ((user.health / user.maxHealth)*100)))
		user.apply_status_effect(/datum/status_effect/serpents_host)
	return

/mob/living/simple_animal/hostile/abnormality/naked_nest/ZeroQliphoth(mob/living/carbon/human/user)
	if(status_flags & GODMODE)
		if(origin_cooldown <= world.time) //To prevent serpent flood there is a delay on how many serpents are brave enough to leave the safety of their nest.
			var/turf/T = pick(GLOB.department_centers)
			var/mob/living/simple_animal/hostile/naked_nest_serpent/serpent = new(get_turf(T))
			serpent.hide()
			datum_reference.qliphoth_change(1)
			origin_cooldown = world.time + origin_cooldown_delay
		return
	if(serpentsnested <= 2)
		serpentsnested = serpentsnested + 1
	return

/mob/living/simple_animal/hostile/abnormality/naked_nest/death(gibbed)
	for(var/atom/movable/AM in src)
		AM.forceMove(get_turf(src))
	if(serpentsnested > 0)
		var/mob/living/simple_animal/hostile/naked_nest_serpent/S = new(get_turf(src))
		S.hide()
	..()

/mob/living/simple_animal/hostile/abnormality/naked_nest/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/naked_nest/AttackingTarget(atom/attacked_target)
	return OpenFire()

/mob/living/simple_animal/hostile/abnormality/naked_nest/Found(mob/living/H)
	if(!H.has_status_effect(/datum/status_effect/serpents_host))
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/naked_nest/PickTarget(list/Targets)
	var/list/highest_priority = list()
	var/list/lower_priority = list()
	for(var/mob/living/L in Targets)
		if(!CanAttack(L))
			continue
		if(ishuman(L))
			if(!L.has_status_effect(/datum/status_effect/serpents_host))
				highest_priority += L
		else
			lower_priority += L
	if(LAZYLEN(highest_priority))
		return pick(highest_priority)
	if(LAZYLEN(lower_priority))
		return pick(lower_priority)
	return ..()

/mob/living/simple_animal/hostile/abnormality/naked_nest/Crossed(atom/movable/AM)
	. = ..()
	if(!target && istype(AM, /mob/living/simple_animal/hostile/naked_nest_serpent))
		var/mob/living/simple_animal/hostile/naked_nest_serpent/S = AM
		if(!S.target && !client)
			S.nest(src)

/mob/living/simple_animal/hostile/abnormality/naked_nest/Life()
	. = ..()
	if(status_flags & GODMODE)
		return
	if(serpentsnested <= 0) //A empty nest falls to ruin
		adjustHealth(10)

/mob/living/simple_animal/hostile/abnormality/naked_nest/OpenFire()
	if(bodytemperature <= INHOSPITABLE_FOR_NESTING || ranged_cooldown > world.time || serpentsnested <= 0 || status_flags & GODMODE) //Do we have serpents? Is it too cold to leave?
		return FALSE
	ranged_cooldown = world.time + ranged_cooldown_time
	playsound(get_turf(src), 'sound/misc/moist_impact.ogg', 10, 1)
	var/mob/living/simple_animal/hostile/naked_nest_serpent/S = new(get_turf(src))
	S.GiveTarget(target)
	serpentsnested = serpentsnested - 1

/mob/living/simple_animal/hostile/abnormality/naked_nest/proc/recover_serpent(mob/living/simple_animal/hostile/naked_nest_serpent/S) //destination of serpents nest proc
	if(serpentsnested <= 5)
		if(S.client)
			to_chat(src, "<span class='nicegreen'>You return to the safety of the nest.</span>")
		playsound(get_turf(src), 'sound/misc/moist_impact.ogg', 10, 1)
		qdel(S)
		serpentsnested = serpentsnested + 1
	else if(S.client)
		to_chat(S, "<span class='notice'>This nest has no more room.</span>")

/mob/living/simple_animal/hostile/abnormality/naked_nest/proc/nest() //return to the nest
	for(var/mob/living/simple_animal/hostile/naked_nest_serpent/M in range(0, src))
		M.nest(src)

/mob/living/simple_animal/hostile/naked_nest_serpent
	name = "naked serpent"
	desc = "A sickly looking green-colored worm."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "nakednest_serpent"
	icon_living = "nakednest_serpent"
	faction = list("hostile", "Naked_Nest")
	a_intent = "harm"
	melee_damage_lower = 1
	melee_damage_upper = 1
	maxHealth = 5
	health = 5 //STOMP THEM STOMP THEM NOW.
	move_to_delay = 3
	speed = 3
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5)
	stat_attack = HARD_CRIT
	density = FALSE //they are worms.
	robust_searching = 1
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	mob_size = MOB_SIZE_SMALL
	pass_flags = PASSTABLE | PASSMOB
	layer = ABOVE_NORMAL_TURF_LAYER
	mouse_opacity = MOUSE_OPACITY_OPAQUE //Clicking anywhere on the turf is good enough
	del_on_death = 1
	vision_range = 18 //two screens away
	minbodytemp = INHOSPITABLE_FOR_NESTING
	var/origin_nest

/mob/living/simple_animal/hostile/naked_nest_serpent/Initialize()
	. = ..()
	for(var/mob/living/simple_animal/hostile/abnormality/naked_nest/N in loc)
		origin_nest = N.tag
	AddComponent(/datum/component/swarming)

/mob/living/simple_animal/hostile/naked_nest_serpent/AttackingTarget()
	if(iscarbon(target) && prob(80))
		var/mob/living/carbon/human/C = target
		if(C.stat != DEAD && !C.has_status_effect(/datum/status_effect/serpents_host) && a_intent == "harm")
			enter_host(C)
			return
	if(istype(target, /mob/living/simple_animal/hostile/abnormality/naked_nest))
		var/mob/living/simple_animal/hostile/abnormality/naked_nest/nest = target
		nest.recover_serpent(src)
	. = ..()

/mob/living/simple_animal/hostile/naked_nest_serpent/PickTarget(list/Targets)
	var/list/highest_priority = list()
	var/list/lower_priority = list()
	for(var/mob/living/L in Targets)
		if(!CanAttack(L))
			continue
		if(ishuman(L))
			if(!L.has_status_effect(/datum/status_effect/serpents_host))
				highest_priority += L
		else
			lower_priority += L
	if(LAZYLEN(highest_priority))
		return pick(highest_priority)
	if(LAZYLEN(lower_priority))
		return pick(lower_priority)
	return ..()

/mob/living/simple_animal/hostile/naked_nest_serpent/LoseAggro() //its best to return home
	..()
	if(origin_nest)
		for(var/mob/living/simple_animal/hostile/abnormality/naked_nest/N in oview(vision_range, src))
			if(origin_nest == N.tag)
				Goto(N, 5, 0)
				return

/mob/living/simple_animal/hostile/naked_nest_serpent/proc/enter_host(mob/living/carbon/host)
	if(prob(50 * (host.health / host.maxHealth)))
		to_chat(host, "<span class='warning'>You feel something cold touch the back of your leg!</span>")
	to_chat(src, "<span class='nicegreen'>You’ve found a new nest!</span>")
	host.apply_status_effect(/datum/status_effect/serpents_host)
	QDEL_IN(src, 5)

/mob/living/simple_animal/hostile/naked_nest_serpent/proc/nest(mob/living/simple_animal/hostile/abnormality/naked_nest/nest)
	for(var/mob/living/simple_animal/hostile/abnormality/naked_nest/N in range(1, src))
		if(nest.serpentsnested <= 5 && origin_nest == N.tag || !origin_nest)
			nest.recover_serpent(src)

/mob/living/simple_animal/hostile/naked_nest_serpent/proc/hide()
	Goto((locate(/obj/structure/table) in oview(get_turf(src), 9)), move_to_delay, 0)
	wander = FALSE

/mob/living/simple_animal/hostile/naked_nested
	name = "naked nested"
	desc = "A humanoid form covered in slimy scales. It looks like it is protected by the host’s armor."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "nakednest_minion"
	icon_living = "nakednest_minion"
	icon_dead = "nakednest_miniondead"
	faction = list("Naked_Nest")
	deathmessage = "collapses into a unrecognizable pile of scales, shredded clothing, and broken serpents."
	melee_damage_lower = 10
	melee_damage_upper = 30
	melee_damage_type = RED_DAMAGE
	armortype = RED_DAMAGE
	maxHealth = 300
	health = 300
	stat_attack = CONSCIOUS //When you are put into crit the nested will continue to transform into a nest. I thought about having the nested infest you if your in crit but that seemed a bit too cruel.
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5)
	mob_size = MOB_SIZE_HUMAN
	minbodytemp = INHOSPITABLE_FOR_NESTING
	guaranteed_butcher_results = list(/obj/item/food/meatball/human = 1) //considered having it spawn a single worm on butcher but that seemed cruel.
	var/nestingtimer
	var/fortitude
	var/prudence
	var/temperance
	var/justice

/mob/living/simple_animal/hostile/naked_nested/Initialize()
	. = ..()
	nestingtimer = world.time + (40 SECONDS)
	updateArmor() //in order to fix damage coefficents

/mob/living/simple_animal/hostile/naked_nested/Life()
	. = ..()
	if(stat == DEAD && buffed == 0)
		buffed = 1
		nestingtimer = nestingtimer + (120 SECONDS)
	if(nestingtimer <= world.time && !target)
		Nest()

/mob/living/simple_animal/hostile/naked_nested/gib()
	for(var/atom/movable/AM in src) //morph code
		AM.forceMove(loc)
	..()

/mob/living/simple_animal/hostile/naked_nested/proc/Nest()
	var/mob/living/simple_animal/hostile/abnormality/naked_nest/N = new(get_turf(src))
	for(var/atom/movable/AM in src) //morph code
		AM.forceMove(N)
	N.damage_coeff = damage_coeff
	playsound(get_turf(src), 'sound/misc/moist_impact.ogg', 30, 1)
	qdel(src)

/mob/living/simple_animal/hostile/naked_nested/proc/updateArmor()
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.6, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1.5)
	var/obj/item/clothing/suit/armor/host_armor = locate(/obj/item/clothing/suit/armor) in contents
	if(host_armor)
		if(host_armor.armor[RED_DAMAGE])
			fortitude = 1 - (host_armor.armor[RED_DAMAGE] / 100) // 100 armor / 100 = 1
			if(fortitude <= damage_coeff[RED_DAMAGE] && fortitude > 0) //if armor is less than current red armor and is more than 0 since anything 0 or below is healing or immune to damage
				damage_coeff[RED_DAMAGE] = fortitude
		if(host_armor.armor[WHITE_DAMAGE])
			prudence = 1 - (host_armor.armor[WHITE_DAMAGE] / 100)
			if(prudence <= damage_coeff[WHITE_DAMAGE] && prudence > 0)
				damage_coeff[WHITE_DAMAGE] = prudence
		if(host_armor.armor[BLACK_DAMAGE])
			temperance = 1 - (host_armor.armor[BLACK_DAMAGE] / 100)
			if(temperance > 0)
				damage_coeff[BLACK_DAMAGE] = temperance
		if(host_armor.armor[PALE_DAMAGE])
			justice = 1 - (host_armor.armor[PALE_DAMAGE] / 100)
			if(justice > 0)
				damage_coeff[PALE_DAMAGE] = justice
		return TRUE

	//Status Effect
/datum/status_effect/serpents_host // its final destination is your frontal lobe
	id = "serpents_host"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 2400 //4 minutes
	alert_type = null
	var/cured = 0
	var/physical_symptoms
	var/presented_symptoms = 0
	var/originalskintone
	var/extra_time = 0.8 SECONDS //doubles remaining time

/datum/status_effect/serpents_host/on_apply()
	. = ..()
	if(ishuman(owner))
		owner.add_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
		owner.add_movespeed_mod_immunities(type, /datum/movespeed_modifier/justice_attribute) //will test to see if can be cured.
		var/mob/living/carbon/human/H = owner
		originalskintone = H.skin_tone
	physical_symptoms = world.time + (180 SECONDS)
	owner.faction += "Naked_Nest"

/datum/status_effect/serpents_host/tick()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.adjustSanityLoss(0.1) //the serpents final destination is your frontal lobe
		H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.1)
		if(H.bodytemperature <= INHOSPITABLE_FOR_NESTING) //cure conditions
			serpentsPoision()
		if(H.drunkenness >= 5 && H.stat != DEAD) //increases duration of infection.
			duration = duration + extra_time
			physical_symptoms = physical_symptoms + extra_time
			if(prob(30))
				to_chat(H, "<span class='warning'>You feel a gurgling noise inside of you...</span>")
			else if(presented_symptoms == 1 && prob(20))
				to_chat(H, "<span class='warning'>A sudden spasming headache overtakes you...</span>")
		if(world.time >= physical_symptoms)
			examine_text = "<span class='boldwarning'>SUBJECTPRONOUN has a gross green hue to their skin! </span>"
			if(presented_symptoms != 1)
				presented_symptoms = 1
				H.skin_tone = "serpentgreen" //resulted in alteration to helpers.dm
				H.regenerate_icons()

/datum/status_effect/serpents_host/proc/serpentsPoision()
	cured = 1
	qdel(src)

/datum/status_effect/serpents_host/on_remove()
	if(ishuman(owner))
		owner.remove_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
		owner.remove_movespeed_mod_immunities(type, /datum/movespeed_modifier/justice_attribute)
		var/mob/living/carbon/human/host = owner
		var/obj/item/organ/brain/B = host.getorganslot(ORGAN_SLOT_BRAIN)
		if(ishuman(host) && presented_symptoms == 1)
			host.skin_tone = originalskintone
			host.regenerate_icons()
		if(B && cured != 1)
			var/mob/living/simple_animal/hostile/naked_nested/N = new(owner.loc) //there was a issue with several converted naked nests getting the same damage coeffs so convert proc had to be moved here.
			nested_items(N, host.get_item_by_slot(ITEM_SLOT_SUITSTORE))
			nested_items(N, host.get_item_by_slot(ITEM_SLOT_BELT))
			nested_items(N, host.get_item_by_slot(ITEM_SLOT_BACK))
			if(host.get_item_by_slot(ITEM_SLOT_OCLOTHING))
				nested_items(N, host.get_item_by_slot(ITEM_SLOT_OCLOTHING))
				N.updateArmor() //moved to creature proc since changing armor values in the status effect resulted in all naked nested having their armor values changed. Even admin spawned ones.
			playsound(get_turf(owner), 'sound/misc/soggy.ogg', 20, 1)
			qdel(owner)
	owner.faction -= "Naked_Nest"
	. = ..()

/datum/status_effect/serpents_host/proc/nested_items(mob/living/simple_animal/hostile/naked_nested/nest, obj/item/nested_item)
	if(nested_item)
		nested_item.forceMove(nest)

#undef INHOSPITABLE_FOR_NESTING

//Offical Cure
/obj/item/serpentspoision
	name = "serpent infestation cure"
	desc = "A formula that removes O-02-74-1 infestation."
	icon = 'icons/obj/chromosomes.dmi'
	icon_state = ""
	color = "gold"

/obj/item/serpentspoision/attack(mob/living/M, mob/user)
	user.visible_message("<span class='notice'>[user] injects [M] with [src].</span>")
	cure(M)
	qdel(src)

/obj/item/serpentspoision/attack_self(mob/living/carbon/user)
	user.visible_message("<span class='notice'>[user] injects themselves with [src].</span>")
	cure(user)
	qdel(src)

/obj/item/serpentspoision/proc/cure(mob/living/carbon/target)
	if(target.has_status_effect(/datum/status_effect/serpents_host))
		var/datum/status_effect/serpents_host/C = target.has_status_effect(/datum/status_effect/serpents_host)
		C.serpentsPoision()
