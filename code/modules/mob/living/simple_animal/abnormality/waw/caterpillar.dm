/mob/living/simple_animal/hostile/abnormality/caterpillar
	name = "Hookah Caterpillar"
	desc = "A pathetic bug sitting on a mushroom."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "caterpillar"
	icon_living = "caterpillar"
	portrait = "hookah"
	pixel_x = -16
	base_pixel_x = -16
	maxHealth = 800
	health = 800
	ranged = TRUE
	attack_verb_continuous = "scolds"
	attack_verb_simple = "scold"
	stat_attack = HARD_CRIT
	melee_damage_lower = 3
	melee_damage_upper = 4
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.2, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.3, PALE_DAMAGE = 0)
	speak_emote = list("flutters")

	can_breach = TRUE
	threat_level = WAW_LEVEL
	faction = list("neutral", "hostile")
	start_qliphoth = 5
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = list(90, 90, 75, 65, 50),
		ABNORMALITY_WORK_ATTACHMENT = 20,
		ABNORMALITY_WORK_REPRESSION = list(20, 20, 20, 30, 35),
	)
	max_boxes = 20
	work_damage_upper = 6
	work_damage_lower = 4
	work_damage_type = PALE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/sloth
	patrol_cooldown_time = 3 SECONDS

	ego_list = list(
		/datum/ego_datum/weapon/havana,
		/datum/ego_datum/armor/havana,
	)
	gift_type =  /datum/ego_gifts/caterpillar
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	observation_prompt = "\"Kyukyu.\" <br>\
		The smoke that fills the room is suffocating. <br>\
		A fat worm sits lazily on a mushroom. <br>\
		When you think about it, it's not too different from when you lazily sit in an office chair. <br>\
		Enjoying a comfortable life working for a prestigious wing. <br.\
		Away from the common riff-raff of the backstreets. <br>\
		This uncanny feeling..."
	observation_choices = list(
		"It's just like me" = list(TRUE, "You can see your face in the smoke, haughty and indignant. <br>\
			Just like your old, shallow self. <br>\
			It's probably not a good idea to spend too much time with this abnormality."),
		"Just a filthy creature" = list(FALSE, "Repression, the emotion of refusal to face oneself. <br>\
			It will not yield anything on its own. <br>\
			One must face themselves through  constant insight. <br>\
			The worm will fatten up from the despair and doubts blown towards it <br>\
			To create silk... The silkworm must be boiled."),
	)

	var/eclosion_counter = 0 //How many times you worked on it without doing repression work
	var/can_counter = TRUE
	var/list/smoke = list()
	var/smoke_check
	var/smoke_check_time = 5 SECONDS
	var/smoke_cooldown
	var/smoke_cooldown_time = 8 SECONDS

/mob/living/simple_animal/hostile/abnormality/caterpillar/HandleStructures()
	. = ..()
	if(!.)
		return
	if(locate(/obj/structure/hookah_mushroom) in datum_reference.connected_structures)
		return
	SpawnConnectedStructure(/obj/structure/hookah_mushroom)

/mob/living/simple_animal/hostile/abnormality/caterpillar/BreachEffect()
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "caterpillar"
	..()

/mob/living/simple_animal/hostile/abnormality/caterpillar/proc/SpawnSmoke()
	var/datum/effect_system/smoke_spread/pale/S = new
	S.set_up(8, get_turf(src))	//Make the smoke bigger
	S.Hook = src
	S.start()
	qdel(S)

/mob/living/simple_animal/hostile/abnormality/caterpillar/PostSpawn()
	. = ..()
	for(var/obj/structure/hookah_mushroom/shroom in datum_reference.connected_structures)
		shroom.icon_state = "caterpillar_mushroon"

/mob/living/simple_animal/hostile/abnormality/caterpillar/Life()
	. = ..()
	if(IsContained())
		return
	if(smoke_check <= world.time)
		smoke_check = world.time + smoke_check_time
		Refresh_Smoke()
	if(smoke_cooldown <= world.time)
		smoke_cooldown = world.time + smoke_cooldown_time
		SpawnSmoke()

/mob/living/simple_animal/hostile/abnormality/caterpillar/proc/Refresh_Smoke()
	for(var/obj/effect/particle_effect/smoke/pale/P in smoke)
		P.lifetime = initial(P.lifetime)

//Counter shit if you get hit by a bullet, we want to keep them either dodging in and out or firing through the gas
/mob/living/simple_animal/hostile/abnormality/caterpillar/proc/Counter_Timer()
	can_counter = TRUE

/mob/living/simple_animal/hostile/abnormality/caterpillar/bullet_act(obj/projectile/P)
	if(!can_counter)
		return
	can_counter = FALSE
	var/datum/effect_system/smoke_spread/pale/S = new
	S.set_up(15, get_turf(src))	//on counter, do massive amounts of smoke
	S.Hook = src
	S.start()
	qdel(S)
	addtimer(CALLBACK(src, PROC_REF(Counter_Timer)), 15 SECONDS)



/mob/living/simple_animal/hostile/abnormality/caterpillar/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(eclosion_counter >= 3)
		var/datum/effect_system/smoke_spread/pale/S = new
		S.set_up(4, get_turf(src))	//Make the smoke bigger
		S.start()
		qdel(S)
	if(work_type != ABNORMALITY_WORK_REPRESSION)
		eclosion_counter++
		datum_reference.max_boxes = max_boxes + (eclosion_counter*6)

		if(eclosion_counter > 4)
			icon_state = "caterpillar_big"
			for(var/obj/structure/hookah_mushroom/shroom in datum_reference.connected_structures)
				shroom.icon_state = "caterpillar_mushroon_red"
		//In Wonderlab, they were able to afford the Rabbit Team with the amount of energy Hookah was producing so safe to say it shits it out.
		SSlobotomy_corp.AdjustAvailableBoxes(50 * (eclosion_counter - 1)) // 0 - 250
		if(eclosion_counter > 5)
			datum_reference.qliphoth_change(-1)
	else
		if(get_attribute_level(user, JUSTICE_ATTRIBUTE) >= 100)
			icon_state = "caterpillar"
			datum_reference.max_boxes = max_boxes
			eclosion_counter = 0
			for(var/obj/structure/hookah_mushroom/shroom in datum_reference.connected_structures)
				shroom.icon_state = "caterpillar_mushroon"

//Structure
/obj/structure/hookah_mushroom
	name = "Big Mushroom"
	desc = "A large pink mushroom with a red top, acting like a cushion."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "caterpillar_mushroon"
	anchored = TRUE
	density = FALSE
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	resistance_flags = INDESTRUCTIBLE
	pixel_x = -16
	base_pixel_x = -16

/////////////////////////////////////////////
// Bad smoke
/////////////////////////////////////////////

/obj/effect/particle_effect/smoke/pale
	icon_state = "palesmoke"
	opaque = 0
	lifetime = 4
	var/mob/living/simple_animal/hostile/abnormality/caterpillar/Hook = null

//Bypasses smoke detection
/obj/effect/particle_effect/smoke/pale/smoke_mob(mob/living/carbon/C)
	if(!istype(C))
		return FALSE
	if(lifetime<1)
		return FALSE
	if(C.smoke_delay)
		return FALSE

	C.smoke_delay++
	addtimer(CALLBACK(src, PROC_REF(remove_smoke_delay), C), 10)
	C.deal_damage(15, PALE_DAMAGE)
	to_chat(C, span_danger("IT BURNS!"))
	C.emote("scream")
	return TRUE

/obj/effect/particle_effect/smoke/pale/spread_smoke()
	var/turf/t_loc = get_turf(src)
	if(!t_loc)
		return
	var/list/newsmokes = list()
	for(var/turf/T in t_loc.GetAtmosAdjacentTurfs())
		var/obj/effect/particle_effect/smoke/pale/foundsmoke = locate() in T //Don't spread smoke where there's already smoke!
		if(foundsmoke)
			continue
		for(var/mob/living/L in T)
			smoke_mob(L)
		var/obj/effect/particle_effect/smoke/pale/S = new type(T)
		if(Hook)
			S.Hook = Hook
		reagents.copy_to(S, reagents.total_volume)
		S.setDir(pick(GLOB.cardinals))
		S.amount = amount-1
		S.add_atom_colour(color, FIXED_COLOUR_PRIORITY)
		S.lifetime = lifetime
		if(S.amount>0)
			if(opaque)
				S.set_opacity(TRUE)
			newsmokes.Add(S)

	//the smoke spreads rapidly but not instantly
	for(var/obj/effect/particle_effect/smoke/SM in newsmokes)
		addtimer(CALLBACK(SM, TYPE_PROC_REF(/obj/effect/particle_effect/smoke, spread_smoke)), 1)
	var/i = 0
	for(var/obj/effect/particle_effect/smoke/pale/P in get_turf(src))
		i += 1
	if(i>1)
		qdel(src)
		return
	if(Hook)
		Hook.smoke += src
/datum/effect_system/smoke_spread/pale
	effect_type = /obj/effect/particle_effect/smoke/pale
	var/mob/living/simple_animal/hostile/abnormality/caterpillar/Hook = null

/datum/effect_system/smoke_spread/pale/start()
	if(holder)
		location = get_turf(holder)
	var/obj/effect/particle_effect/smoke/pale/S = new effect_type(location)
	S.amount = amount
	S.Hook = Hook
	if(S.amount)
		S.spread_smoke()
