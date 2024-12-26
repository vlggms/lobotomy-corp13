#define STATUS_EFFECT_PROTECTION /datum/status_effect/protection
GLOBAL_LIST_EMPTY(army)
/mob/living/simple_animal/hostile/abnormality/army
	name = "Army in Black"
	desc = "The color of the human heart is pink, and by wearing the same color, we can blend in with people's minds."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "armyinpink"
	icon_living = "armyinpink"
	icon_dead = "armyinpink_heart"
	portrait = "army_in_black"
	pixel_x = -16
	base_pixel_x = -16

	//*--Suppression info--*
	maxHealth = 450
	health = 450
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 1.0, PALE_DAMAGE = 0.8)//the same as hostile mobs, ez records
	speed = 1//unused
	generic_canpass = FALSE
	del_on_death = TRUE
	is_flying_animal = TRUE

	//melee stats(unused)
	attack_sound = 'sound/abnormalities/armyinblack/pink_heal.ogg'
	attack_verb_continuous = "shoots"
	attack_verb_simple = "shoot"

	//*--Containment info--*
	threat_level = ALEPH_LEVEL
	can_breach = TRUE
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 0,
		ABNORMALITY_WORK_INSIGHT = list(40, 40, 40, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = list(50, 50, 50, 55, 55),
		ABNORMALITY_WORK_REPRESSION = 30,
		"Protection" = 0, //shouldn't attempt to generate any PE
	)
	work_damage_amount = 17
	work_damage_type = WHITE_DAMAGE

	//E.G.O list
	ego_list = list(
		/datum/ego_datum/weapon/pink,
		/datum/ego_datum/armor/pink,
	)
	gift_type =  /datum/ego_gifts/pink

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/quiet_day = 1.5,
		/mob/living/simple_animal/hostile/abnormality/khz = 1.5,
		/mob/living/simple_animal/hostile/abnormality/mhz = 1.5,
	)
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "\"We're here to help sir, to keep the hearts of humans a clean pink, we're willing to dirty our own. We won't overlook a single speck of black.\" <br>\
		The soldier in pink makes a salute. <br>You..."
	observation_choices = list(
		"Don't salute" = list(TRUE, "The soldier frowns. <br>\"As expected. <br>You're only human, a clean heart is only ever temporary for you. <br>\
			Yours is rife with sin. <br>Ours are...\" <br>The soldier falls silent, as if in deep thought."),
		"Salute him back" = list(FALSE, "The soldier in pink smiles. <br>\"Glad to have you on board Sir, with our help, there will be no more black hearts.\""),
	)

	//Unique variables
	var/death_counter = 0
	var/protection_duration = 120 SECONDS
	var/protected_targets = list()
	var/summoned_army = list()//hostile unit list
	var/boom_radius = 20
	var/boom_damage = 70
	var/adds_max = 1

/***Simple mob procs***/
//checks for deaths
/mob/living/simple_animal/hostile/abnormality/army/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(OnMobDeath))
	adds_max = clamp((LAZYLEN(GLOB.player_list)/ 2),2, 5)//between 2 and 5 mooks on breach, one for every 2 people.

//stops the previous snippet from destroying the server
/mob/living/simple_animal/hostile/abnormality/army/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	return ..()

/mob/living/simple_animal/hostile/abnormality/army/Life()
	..()
	if(LAZYLEN(protected_targets))
		for(var/mob/living/carbon/human/H in protected_targets)
			if(!H.has_status_effect(STATUS_EFFECT_PROTECTION))
				protected_targets -= H
	return

//no more nuzzling
/mob/living/simple_animal/hostile/abnormality/army/AttackingTarget()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/army/Move()
	return FALSE

/***Work procs***/
//protect work grants you a buff in exchange for reducing its counter
/mob/living/simple_animal/hostile/abnormality/army/AttemptWork(mob/living/carbon/human/user, work_type)
	..()
	if(work_type == "Protection")
		if(datum_reference?.qliphoth_meter > 1)
			if(user in protected_targets)
				return FALSE
			datum_reference.qliphoth_change(-1)
			if((get_user_level(user)) < 4)
				user.SanityLossEffect(TEMPERANCE_ATTRIBUTE)
				return FALSE
			protected_targets += user
			user.apply_status_effect(STATUS_EFFECT_PROTECTION)
			to_chat(user, span_nicegreen("You feel like you're in good company."))
			playsound(get_turf(user), 'sound/abnormalities/armyinblack/pink_heal.ogg', 50, 0, 2)
		return FALSE
	return TRUE

//counter goes down when people die, repression/protection work is performed, or raised when an abnormality is suppressed.
/mob/living/simple_animal/hostile/abnormality/army/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/army/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

//death counter from MoSB, it works exactly the same.
/mob/living/simple_animal/hostile/abnormality/army/proc/OnMobDeath(datum/source, mob/living/died, gibbed)
	SIGNAL_HANDLER
	if(!IsContained())//Stops if it's breaching
		return FALSE
	if(died.z != z)//check for z-level congruency
		return FALSE
	if(isabnormalitymob(died))//counter restored if another abnormality dies
		datum_reference.qliphoth_change(1)
		return TRUE
	if(!died.mind)//if it's not a player
		return FALSE
	if(!ishuman(died))//all simple mobs, ordeals, other npcs except for humans
		return FALSE
	death_counter += 1
	if(death_counter >= 2)
		death_counter = 0
		datum_reference.qliphoth_change(-1)
	return TRUE

//*--Combat Mechanics--*
/mob/living/simple_animal/hostile/abnormality/army/BreachEffect(mob/living/carbon/human/user, breach_type)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_ABNORMALITY_BREACH, src)
	FearEffect()
	Blackify()
	SpawnAdds()//set its alpha to 0 and make it non-dense
	for(var/mob/living/L in protected_targets)
		L.remove_status_effect(STATUS_EFFECT_PROTECTION)
	density = FALSE
	alpha = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	return TRUE

/mob/living/simple_animal/hostile/abnormality/army/proc/SpawnAdds()
	var/list/spawns = shuffle(GLOB.xeno_spawn)
	for(var/i = 1 to adds_max)//# of iterations is equal to adds_max
		for(var/turf/T in spawns)//this picks the first few shuffled xeno spawns. Maybe change it to a different type of loop
			var/mob/living/simple_animal/hostile/army_enemy/E = new(get_turf(T))
			summoned_army += E//the actual army list
			RegisterSignal(E, COMSIG_PARENT_QDELETING, PROC_REF(ArmyDeath))
			spawns -= T
			break

/mob/living/simple_animal/hostile/abnormality/army/proc/ArmyDeath(mob/E)//return to containment when all armies are dead
	UnregisterSignal(E, COMSIG_PARENT_QDELETING)
	summoned_army -= E
	if(LAZYLEN(summoned_army) <=1)
		qdel(src)//suppress the abnormality
		return

//convert all protection buffs into hostile units
/mob/living/simple_animal/hostile/abnormality/army/proc/Blackify()
	for(var/mob/living/carbon/A in protected_targets)
		var/datum/status_effect/protection/P = A.has_status_effect(/datum/status_effect/protection)
		P.boom = FALSE
		A.remove_status_effect(STATUS_EFFECT_PROTECTION)
		var/mob/living/simple_animal/hostile/army_enemy/B = new(get_turf(A))
		protected_targets -= A
		summoned_army += B

//hostile breach mob
/mob/living/simple_animal/hostile/army_enemy
	name = "Army In Black"
	desc = "Yes.. we, the Army in Black.. blend into the human heart.. and drive away good thoughts.."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "armyinblack"
	icon_living = "armyinblack"
	icon_dead = "armyinblack_heart"
	pixel_x = -16
	base_pixel_x = -16
	faction = list("hostile")
	attack_verb_continuous = "attacks"
	attack_verb_simple = "attack"
	attack_sound = 'sound/abnormalities/armyinblack/pink_heal.ogg'
	/*Core stats*/
	health = 900
	maxHealth = 900
	obj_damage = 50
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.6, BLACK_DAMAGE = 1.0, PALE_DAMAGE = 0.8)
	ranged = TRUE
	minimum_distance = 2
	speed = 2
	move_to_delay = 20//TODO: make this determined by how far away it spawned from the beacon
	stat_attack = HARD_CRIT
	del_on_death = FALSE
	density = FALSE
	is_flying_animal = TRUE
	var/list/fear_affected = list()
	var/shot_cooldown
	var/shot_cooldown_time = 5 SECONDS
	var/boom_damage = 70
	var/targetted_beacon
	var/list/moving_path

//movement and AI
/mob/living/simple_animal/hostile/army_enemy/AttackingTarget()
	return

/mob/living/simple_animal/hostile/army_enemy/proc/GoToBeacon()
	if(QDELETED(src))
		return
	patrol_to(get_turf(targetted_beacon))//this causes a runtime when the unit is deleted due to invoking asynchronous move_to! Please help!
	return

/mob/living/simple_animal/hostile/army_enemy/Life()
	. = ..()
	if(!.)
		return
	if(targetted_beacon)
		GoToBeacon()
	FearEffect()
	return

/mob/living/simple_animal/hostile/army_enemy/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(Explode)), 120 SECONDS)
	var/list/depts = shuffle(GLOB.department_centers)
	var/list/depts_far = list()
	if(!LAZYLEN(depts))
		return
	for(var/turf/T in depts)
		if(!(get_area(T) in (get_areas_in_range(20, get_area(src)))))//if they're not within 20 tiles of T, pick the next one.
			depts_far += T
			continue
		if(locate(/obj/effect/pink_beacon) in get_turf(T))
			continue
		var/obj/effect/pink_beacon/P = new(get_turf(T))//beacon
		targetted_beacon = P
		P.targetted_army = src
		INVOKE_ASYNC(src, PROC_REF(SetSpeed))
		break
	if(!targetted_beacon)//if none of the above are picked, grab one that's further away
		for(var/turf/T in depts_far)
			if(locate(/obj/effect/pink_beacon) in get_turf(T))
				continue
			var/obj/effect/pink_beacon/P = new(get_turf(T))//beacon
			targetted_beacon = P
			P.targetted_army = src
			INVOKE_ASYNC(src, PROC_REF(SetSpeed))
			break

/mob/living/simple_animal/hostile/army_enemy/death()
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/army_enemy/proc/SetSpeed()
	if(!LAZYLEN(patrol_path))
		sleep(5)
		SetSpeed()//wait for a patrol path. What could possibly go wrong?
		return
	var/dist_travelled = LAZYLEN(patrol_path)
	ChangeMoveToDelayBy(-clamp((dist_travelled / 4), 0, 15)) //armies that spawn closest to dept centers can actually be suppressed this way, while further ones remain a threat. Math needs tweaking

/mob/living/simple_animal/hostile/army_enemy/proc/FearEffect()
	for(var/mob/living/carbon/human/H in view(7, src))
		if(H in fear_affected)
			continue
		if(HAS_TRAIT(H, TRAIT_COMBATFEAR_IMMUNE))
			continue
		H.adjustSanityLoss(H.maxSanity*0.3)
		fear_affected += H
		if(H.sanity_lost)
			continue
		to_chat(H, span_warning("Oh dear."))
	return

//explosion definition
/mob/living/simple_animal/hostile/army_enemy/proc/Explode()
	if(QDELETED(src))
		return
	playsound(get_turf(src), 'sound/abnormalities/armyinblack/black_explosion.ogg', 125, 0, 8)
	visible_message(span_danger("[src] suddenly explodes!"))
	for(var/mob/living/simple_animal/hostile/abnormality/P in livinginrange(20, src))
		if(!P.datum_reference)//Prevents a runtime if the abno lacks datums, such as those spawned by contract
			continue
		P.datum_reference.qliphoth_change(-1)
	for(var/mob/living/carbon/human/H in view(20, src))
		H.deal_damage(boom_damage, WHITE_DAMAGE)
	new /obj/effect/temp_visual/black_explosion(get_turf(src))
	qdel(src)

//aoe attacks
/mob/living/simple_animal/hostile/army_enemy/ListTargets()//Move Move Move! This prevents it from aggroing anything
	return FALSE

/mob/living/simple_animal/hostile/army_enemy/attackby(obj/item/W, mob/user, params)
	. = ..()
	OpenFire(user)

/mob/living/simple_animal/hostile/army_enemy/attack_hand(mob/living/carbon/human/M)
	. = ..()
	OpenFire()
	return

/mob/living/simple_animal/hostile/army_enemy/attack_animal(mob/living/simple_animal/M)
	. = ..()
	OpenFire()
	return

/mob/living/simple_animal/hostile/army_enemy/bullet_act()//it retaliates, but you can still out-range it
	. = ..()
	OpenFire()
	return

/mob/living/simple_animal/hostile/army_enemy/OpenFire()
	if(shot_cooldown <= world.time)
		BlackAoe()

/mob/living/simple_animal/hostile/army_enemy/proc/BlackAoe()
	if(stat == DEAD)
		return
	for(var/turf/T in view(4, src))
		new /obj/effect/temp_visual/army_hearts(get_turf(T))
	for(var/mob/living/L in view(4, src))
		if(faction_check_mob(L))
			continue
		L.deal_damage(50, BLACK_DAMAGE)
	playsound(get_turf(src), 'sound/abnormalities/armyinblack/black_attack.ogg', 100, 0, 8)
	shot_cooldown = world.time + shot_cooldown_time

// Status Effect
/datum/status_effect/protection
	id = "protection"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 2 MINUTES
	alert_type = null
	tick_interval = 30
	var/boom = TRUE
	var/obj/army_bud

/datum/status_effect/protection/on_creation(mob/living/new_owner, ...)
	army_bud = new /obj/effect/army_friend
	return ..()

/datum/status_effect/protection/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.red_mod *= 0.8
	status_holder.physiology.white_mod *= 0.8
	status_holder.physiology.black_mod *= 0.8
	status_holder.physiology.pale_mod *= 0.8
	status_holder.add_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects10x10.dmi', "pink", -MUTATIONS_LAYER))
	status_holder.vis_contents += army_bud

/datum/status_effect/protection/on_remove()
	. = ..()
	if(boom)
		playsound(get_turf(owner), 'sound/abnormalities/armyinblack/pink_explosion.ogg', 125, 0, 8)
		new /obj/effect/temp_visual/pink_explosion(get_turf(owner))
		for(var/mob/living/carbon/human/affected_human in view(7, owner))
			affected_human.adjustBruteLoss(-20)
			affected_human.adjustSanityLoss(20)
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.red_mod /= 0.8
	status_holder.physiology.white_mod /= 0.8
	status_holder.physiology.black_mod /= 0.8
	status_holder.physiology.pale_mod /= 0.8
	status_holder.cut_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects10x10.dmi', "pink", -MUTATIONS_LAYER))
	status_holder.vis_contents -= army_bud
	to_chat(status_holder, span_notice("The pink soldier assigned to you returns to its containment cell."))

/datum/status_effect/protection/tick()
	if(owner.health < 0)
		qdel(src)
	for(var/turf/T in view(3, owner))
		new /obj/effect/temp_visual/friend_hearts(get_turf(T))
		for(var/mob/living/carbon/human/H in T.contents)
			H.adjustBruteLoss(-6)
			H.adjustSanityLoss(-6)
	playsound(get_turf(owner), 'sound/abnormalities/armyinblack/pink_heal.ogg', 50, 0, 2)

/obj/effect/pink_beacon
	name = "pink beacon"
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "armyinblack_heart"
	alpha = 0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/targetted_army

/obj/effect/pink_beacon/Initialize()
	. = ..()
	QDEL_IN(src, 130 SECONDS)

/obj/effect/pink_beacon/Crossed(atom/movable/AM)//this atom eventually qdeletes itself, no need to worry about cleanup
	. = ..()
	var/mob/living/simple_animal/hostile/army_enemy/E = targetted_army
	if(AM == E)
		E.Explode()
		qdel(src)

/obj/effect/temp_visual/pink_explosion
	name = "pink explosion"
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "black_explosion"
	duration = 3 SECONDS
	color = COLOR_PINK
	pixel_x = -32
	pixel_y = 0

/obj/effect/temp_visual/pink_explosion/Initialize()
	. = ..()
	animate(src, transform = matrix()*1.8, alpha = 0, time = duration)

/obj/effect/temp_visual/black_explosion
	name = "black explosion"
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "black_explosion"
	duration = 6 SECONDS
	pixel_x = -32
	pixel_y = 0

/obj/effect/temp_visual/black_explosion/Initialize()
	. = ..()
	animate(src, transform = matrix()*1.8, alpha = 0, time = duration)

/obj/effect/temp_visual/army_hearts
	name = "black haze"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "army_hearts"
	duration = 10

/obj/effect/temp_visual/army_hearts/Initialize()
	. = ..()
	animate(src, alpha = 0, time = duration)

/obj/effect/temp_visual/friend_hearts
	name = "warmth"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "friend_hearts"
	duration = 10

/obj/effect/temp_visual/friend_hearts/Initialize()
	. = ..()
	animate(src, alpha = 0, time = duration)

/obj/effect/army_friend
	name = "Army in Pink"
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "armyinpink"
	mouse_opacity = 0
	pixel_x = -16
	pixel_y = 16
	alpha = 200
	vis_flags = VIS_INHERIT_DIR

#undef STATUS_EFFECT_PROTECTION
