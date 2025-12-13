/mob/living/simple_animal/hostile/abnormality/caterpillar
	name = "Hookah Caterpillar"
	desc = "A pathetic bug sitting on a mushroom."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "caterpillar"
	icon_living = "caterpillar"
	core_icon = "caterpillar_egg"
	portrait = "hookah"
	pixel_x = -16
	base_pixel_x = -16
	pixel_y = -16
	base_pixel_y = -16
	maxHealth = 1280
	health = 1280
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/abnormalities/big_wolf/Wolf_Scratch.ogg'
	stat_attack = HARD_CRIT
	melee_damage_type = PALE_DAMAGE
	melee_damage_lower = 14
	melee_damage_upper = 16
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.1, WHITE_DAMAGE = 0.1, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 0)
	speak_emote = list("flutters")

	can_breach = TRUE
	threat_level = WAW_LEVEL
	fear_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 50,
		ABNORMALITY_WORK_INSIGHT = list(90, 90, 75, 65, 50),
		ABNORMALITY_WORK_ATTACHMENT = 35,
		ABNORMALITY_WORK_REPRESSION = list(20, 20, 20, 30, 35),
	)
	max_boxes = 20
	work_damage_upper = 6
	work_damage_lower = 3
	work_damage_type = PALE_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/sloth
	patrol_cooldown_time = 2 SECONDS

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
	var/work_success_damage_upper = 4
	var/work_success_damage_lower = 2
	var/list/smoke = list()
	var/smoke_check_range = 20
	//Stuff Relating to it expanding its smoke cloud
	var/smoke_tick
	var/smoke_expand_range = 8
	var/smoke_expand_amount = 2
	var/break_threshold = 80
	var/shell_broken = FALSE

/mob/living/simple_animal/hostile/abnormality/caterpillar/PostSpawn()
	pixel_y = 0
	base_pixel_y = 0
	. = ..()
	for(var/obj/structure/hookah_mushroom/shroom in datum_reference.connected_structures)
		shroom.icon_state = "caterpillar_mushroon"

/mob/living/simple_animal/hostile/abnormality/caterpillar/examine(mob/user)
	. = ..()
	if(IsContained() && eclosion_counter == 5)
		. += "It isn't moving."
	if(shell_broken)
		. += "Its shell looks heavily damaged."

/mob/living/simple_animal/hostile/abnormality/caterpillar/HandleStructures()
	. = ..()
	if(!.)
		return
	if(locate(/obj/structure/hookah_mushroom) in datum_reference.connected_structures)
		return
	SpawnConnectedStructure(/obj/structure/hookah_mushroom)
	if(locate(/obj/structure/smoke_detector) in datum_reference.connected_structures)
		return
	SpawnConnectedStructure(/obj/structure/smoke_detector, 2, 2)

/mob/living/simple_animal/hostile/abnormality/caterpillar/WorktickSuccess(mob/living/carbon/human/user)
	if(user.sanityhealth > (user.maxSanity * 0.2))
		user.deal_damage(rand(work_success_damage_lower, work_success_damage_upper), WHITE_DAMAGE)

/mob/living/simple_animal/hostile/abnormality/caterpillar/proc/UpdateEclosion()
	if(eclosion_counter < 5)
		eclosion_counter ++
		if(eclosion_counter >= 1)
			if(!LAZYLEN(smoke))
				var/datum/effect_system/smoke_spread/pale/S = new
				S.set_up(0, get_turf(src))	//Spawn the smoke
				S.Hook = src
				S.weak_mode = TRUE
				S.start()
			else
				if(eclosion_counter < 4)
					Expand_Smoke(2, smoke) //Or make the smoke bigger
		datum_reference.max_boxes = max_boxes + (eclosion_counter*6)

		if(eclosion_counter > 4)
			icon_state = "caterpillar_big"
			for(var/obj/structure/hookah_mushroom/shroom in datum_reference.connected_structures)
				shroom.icon_state = "caterpillar_mushroon_red"
	else
		playsound(get_turf(src), 'sound/effects/alertbeep.ogg', 50, FALSE)
		BreachEffect()

/mob/living/simple_animal/hostile/abnormality/caterpillar/proc/RestartEclosion()
	Remove_Smoke()
	icon_state = "caterpillar"
	datum_reference.max_boxes = initial(max_boxes)
	eclosion_counter = 0
	for(var/obj/structure/hookah_mushroom/shroom in datum_reference.connected_structures)
		shroom.icon_state = "caterpillar_mushroon"

//Meltdown Stuff
/mob/living/simple_animal/hostile/abnormality/caterpillar/MeltdownEnd()
	playsound(get_turf(src), 'sound/effects/alertbeep.ogg', 50, FALSE)
	BreachEffect()

/mob/living/simple_animal/hostile/abnormality/caterpillar/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	if(work_type != ABNORMALITY_WORK_REPRESSION)
		UpdateEclosion()
	else
		if(user.stat >= SOFT_CRIT || user.sanity_lost || canceled)
			return
		if(get_attribute_level(user, JUSTICE_ATTRIBUTE) >= 100)
			RestartEclosion()

//Breach Stuff
/mob/living/simple_animal/hostile/abnormality/caterpillar/BreachEffect()
	icon = 'ModularTegustation/Teguicons/80x80.dmi'
	icon_state = "caterpillar"
	desc = "A large humanoid bug that's spewing smoke."
	pixel_x = -24
	base_pixel_x = -24
	pixel_y = 0
	base_pixel_y = 0
	Remove_Smoke()
	fear_level = WAW_LEVEL
	..()

/mob/living/simple_animal/hostile/abnormality/caterpillar/Moved()
	. = ..()
	if(IsContained())
		return
	SpreadSmoke()

/mob/living/simple_animal/hostile/abnormality/caterpillar/proc/SpreadSmoke()
	//We don't want it to spread smoke twice in the same tick.
	if(smoke_tick >= world.time)
		return
	smoke_tick = world.time
	var/T = get_turf(src)
	if(!(locate(/obj/effect/particle_effect/smoke/pale) in T))
		var/datum/effect_system/smoke_spread/pale/S = new
		S.set_up(4, T)	//Make the smoke bigger
		S.Hook = src
		S.start()
	else
		Expand_Smoke(smoke_expand_amount, view(loc, smoke_expand_range))

/mob/living/simple_animal/hostile/abnormality/caterpillar/Destroy()
	Remove_Smoke()
	. = ..()

/mob/living/simple_animal/hostile/abnormality/caterpillar/CanAttack(atom/the_target)
	if(!shell_broken)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/caterpillar/FindTarget(list/possible_targets, HasTargetsList = 0)
	if(!shell_broken)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/caterpillar/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if((!shell_broken) && (health <= maxHealth - break_threshold))
		shell_broken = TRUE
		ChangeResistances(list(RED_DAMAGE = 2, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 0))
		icon_state = "caterpillar_damaged"
		ChangeMoveToDelay(2.5)
		playsound(get_turf(src), 'sound/effects/wounds/crack2.ogg', 200, 0, 7)
		visible_message(span_warning("[src]'s shell finally breaks!"), span_boldwarning("Your shell is heavily damaged!"))

/mob/living/simple_animal/hostile/abnormality/caterpillar/Life()
	. = ..()
	var/list/smoke_list = smoke
	if(!IsContained())
		SpreadSmoke()
		smoke_list = view(loc, smoke_check_range)
	Refresh_Smoke(smoke_list)

/mob/living/simple_animal/hostile/abnormality/caterpillar/proc/Refresh_Smoke(list/smoke_list)
	for(var/obj/effect/particle_effect/smoke/pale/P in smoke_list)
		P.lifetime = initial(P.lifetime)

/mob/living/simple_animal/hostile/abnormality/caterpillar/proc/Remove_Smoke()
	for(var/obj/effect/particle_effect/smoke/pale/P in smoke)
		smoke -= P
		P.lifetime = 0
		P.Hook = null
		P.kill_smoke()

/mob/living/simple_animal/hostile/abnormality/caterpillar/proc/Expand_Smoke(amount = 1, list/smoke_list)
	for(var/obj/effect/particle_effect/smoke/pale/P in smoke_list)
		if(P.amount <= 0)
			P.lifetime = initial(P.lifetime)
			P.amount = amount
			P.spread_smoke()

//Structures
/obj/structure/hookah_mushroom
	name = "Big Mushroom"
	desc = "A large mushroom with a red top acting like a cushion."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "caterpillar_mushroon"
	anchored = TRUE
	density = FALSE
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	resistance_flags = INDESTRUCTIBLE
	pixel_x = -16
	base_pixel_x = -16

/obj/structure/smoke_detector
	name = "smoke detector"
	desc = "A specialized smoke detector meant to detect Hookah Caterpillar's current Eclosion Counter."
	icon = 'ModularTegustation/Teguicons/lc13_structures.dmi'
	icon_state = "smoke_detector"
	anchored = TRUE
	density = FALSE

	resistance_flags = INDESTRUCTIBLE

/obj/structure/smoke_detector/examine(mob/user)
	. = ..()
	var/mob/living/simple_animal/hostile/abnormality/caterpillar/Hook = locate() in range(src, 3)
	if(Hook && Hook.IsContained())
		. += span_info("Current Eclosion Counter: [100*(Hook.eclosion_counter/5)]%.")
	else
		. += span_info("ERROR: The abnormality isn't contained currently!")

/////////////////////////////////////////////
// Bad smoke
/////////////////////////////////////////////

/obj/effect/particle_effect/smoke/pale
	icon_state = "palesmoke"
	opaque = 0
	lifetime = 8
	var/mob/living/simple_animal/hostile/abnormality/caterpillar/Hook = null
	var/damage_done = 16
	var/weak_mode = FALSE
	var/damage_chance = 100

/obj/effect/particle_effect/smoke/pale/Initialize(loc, is_weak)
	if(is_weak)
		weak_mode = TRUE
		alpha = 180
		damage_done = 6
		damage_chance = 30
	. = ..()

//Bypasses smoke detection
/obj/effect/particle_effect/smoke/pale/smoke_mob(mob/living/carbon/C)
	if(!istype(C))
		return FALSE
	if(lifetime < 1)
		return FALSE
	if(C.smoke_delay)
		return FALSE
	C.smoke_delay++
	if(prob(damage_chance))
		addtimer(CALLBACK(C, TYPE_PROC_REF(/mob/living, remove_smoke_delay)), 10)
		C.deal_damage(damage_done, PALE_DAMAGE, attack_type = (ATTACK_TYPE_ENVIRONMENT))
		if(prob(40))
			to_chat(C, span_danger("IT BURNS!"))
			C.emote("scream")
	else
		addtimer(CALLBACK(C, TYPE_PROC_REF(/mob/living, remove_smoke_delay)), 5)
	return TRUE

/obj/effect/particle_effect/smoke/pale/spread_smoke()
	var/turf/t_loc = get_turf(src)
	if(!t_loc)
		return
	if(SmokeStart())
		return
	var/list/newsmokes = list()
	for(var/turf/T in t_loc.GetAtmosAdjacentTurfs())
		var/obj/effect/particle_effect/smoke/pale/foundsmoke = locate() in T //Don't spread smoke where there's already smoke!
		if(foundsmoke && foundsmoke.lifetime > 0 && !QDELETED(foundsmoke))
			continue
		for(var/mob/living/L in T)
			smoke_mob(L)
		var/obj/effect/particle_effect/smoke/pale/S = new type(T, weak_mode)
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
		else
			S.SmokeStart()
	amount = 0
	//the smoke spreads rapidly but not instantly
	for(var/obj/effect/particle_effect/smoke/SM in newsmokes)
		addtimer(CALLBACK(SM, TYPE_PROC_REF(/obj/effect/particle_effect/smoke, spread_smoke)), 1)

/obj/effect/particle_effect/smoke/pale/proc/SmokeStart()
	var/i = 0
	for(var/obj/effect/particle_effect/smoke/pale/P in get_turf(src))
		if(P.lifetime > 0 && !QDELETED(P))
			i += 1
	if(i>1)
		qdel(src)
		return TRUE
	if(Hook)
		Hook.smoke |= src
	return FALSE

/obj/effect/particle_effect/smoke/pale/kill_smoke()
	if(Hook)
		Hook.smoke -= src
		Hook = null
	STOP_PROCESSING(SSobj, src)
	INVOKE_ASYNC(src, PROC_REF(fade_out))
	QDEL_IN(src, 10)

/datum/effect_system/smoke_spread/pale
	effect_type = /obj/effect/particle_effect/smoke/pale
	var/mob/living/simple_animal/hostile/abnormality/caterpillar/Hook = null
	var/weak_mode = FALSE //This spawns a weaker version of the smoke for during containment

/datum/effect_system/smoke_spread/pale/start()
	if(holder)
		location = get_turf(holder)
	var/obj/effect/particle_effect/smoke/pale/S = new effect_type(location, weak_mode)
	S.amount = amount
	S.Hook = Hook
	if(S.amount)
		S.spread_smoke()
	else
		S.SmokeStart()
	qdel(src)
