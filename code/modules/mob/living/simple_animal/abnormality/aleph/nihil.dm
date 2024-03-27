#define STATUS_EFFECT_VOID /datum/status_effect/stacking/void
//Coded by Coxswain, sprites by nutterbutter
/mob/living/simple_animal/hostile/abnormality/nihil
	name = "The Jester of Nihil"
	desc = "What the heck is this... A clown?"
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "nihil"
	icon_living = "nihil"
	portrait = "nihil"
	pixel_x = -16
	base_pixel_x = -16
	maxHealth = 15000
	health = 15000
	move_to_delay = 4
	rapid_melee = 1
	threat_level = ALEPH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 30, 35, 40),
		ABNORMALITY_WORK_INSIGHT = 0, //He's the fool Tarot
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 30, 35, 40),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 30, 35, 45),
	)
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 0.5) //change on phase
	melee_damage_lower = 55
	melee_damage_upper = 65
	melee_damage_type = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	work_damage_amount = 20
	work_damage_type = WHITE_DAMAGE
	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	faction = list("Nihil", "hostile")
	attack_sound = 'sound/abnormalities/nihil/attack.ogg'
	start_qliphoth = 4
	ranged = TRUE

	ego_list = list(
		/datum/ego_datum/weapon/nihil,
		/datum/ego_datum/armor/nihil,
	)
	gift_type = /datum/ego_gifts/nihil

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/hatred_queen = 5,
		/mob/living/simple_animal/hostile/abnormality/despair_knight = 5,
		/mob/living/simple_animal/hostile/abnormality/greed_king = 5,
		/mob/living/simple_animal/hostile/abnormality/wrath_servant = 5,
	)
	var/list/girl_types = list(
		/mob/living/simple_animal/hostile/abnormality/wrath_servant,
		/mob/living/simple_animal/hostile/abnormality/hatred_queen,
		/mob/living/simple_animal/hostile/abnormality/despair_knight,
		/mob/living/simple_animal/hostile/abnormality/greed_king
	)
	var/list/girls_present = list()
	var/list/quotes = list(
		"Everybody's agony becomes one.",
		"I slowly traced the road back. It's the road you would've taken.",
		"Where is the right path? Where do I go?",
		"Where is the bright dog when I need it to lead me?",
		"Leading the way through foolishness, there's not a thing to guide me.",
		"All I can do is trust my own intuition.",
		"I look just like them, and they look just like me when they're together.",
		"I become more fearless as they become more vacant.",
		"My mind is a void; my thoughts are empty.",
		"In the end, all returns to nihil.",
	)

//Work Code
/mob/living/simple_animal/hostile/abnormality/nihil/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-2)
	return

/mob/living/simple_animal/hostile/abnormality/nihil/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(1)

/mob/living/simple_animal/hostile/abnormality/nihil/AttemptWork(mob/living/carbon/human/user, work_type)
	work_damage_type = WHITE_DAMAGE
	switch(work_type)
		if(ABNORMALITY_WORK_REPRESSION)
			work_damage_type = BLACK_DAMAGE
	return ..()

//Qliphoth
/mob/living/simple_animal/hostile/abnormality/nihil/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_GLOB_ABNORMALITY_BREACH, PROC_REF(OnAbnoBreach))

/mob/living/simple_animal/hostile/abnormality/nihil/proc/OnAbnoBreach(datum/source, mob/living/simple_animal/hostile/abnormality/abno)
	SIGNAL_HANDLER
	if(abno.type in girl_types)
		datum_reference.qliphoth_change(-2)

//Breach
/mob/living/simple_animal/hostile/abnormality/nihil/ZeroQliphoth(mob/living/carbon/human/user)
	var/counter = 0
	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list)
		if(!(A.type in girl_types))
			continue
		counter += 1

	if(counter < 2)
		Debuff(0, FALSE)
	else
		Debuff(0, event_enabled = TRUE)

/mob/living/simple_animal/hostile/abnormality/nihil/proc/Debuff(attack_count,event_enabled)
	if(attack_count > 13)
		datum_reference.qliphoth_change(3)
		return
	if(!attack_count)
		sound_to_playing_players_on_level("sound/abnormalities/nihil/attack.ogg", 30, zlevel = z)
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(faction_check_mob(L, FALSE) || L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		var/datum/status_effect/stacking/void/V = L.has_status_effect(/datum/status_effect/stacking/void)
		if(!V)
			L.apply_status_effect(STATUS_EFFECT_VOID)
		else
			V.add_stacks(1)
			V.refresh()
			playsound(L, 'sound/abnormalities/nihil/filter.ogg', 15, FALSE, -3)
			if(attack_count < 8)
				to_chat(L, span_warning("[quotes[attack_count]]"))
			else
				to_chat(L, span_warning("[quotes[10]]"))
	if(attack_count == 10)
		if(event_enabled)
			BreachEffect()
			return
		else
			SSlobotomy_corp.InitiateMeltdown((SSlobotomy_corp.all_abnormality_datums.len), TRUE)
	SLEEP_CHECK_DEATH(4 SECONDS)
	attack_count += 1
	Debuff(attack_count, event_enabled)

/mob/living/simple_animal/hostile/abnormality/nihil/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	var/list/potential_spawns
	var/mob/living/simple_animal/nihil_portal/portal
	for(var/turf/T in GLOB.department_centers)
		if(istype(get_area(T),/area/department_main/command))
			for(var/mob/living/simple_animal/forest_portal/FP in T.contents) // Prevents breaching on top of apocalypse bird
				potential_spawns = GLOB.department_centers.Copy()
				potential_spawns -= T
				continue
			portal = new(T)
			break
	if(!portal)
		var/turf/T = pick(GLOB.department_centers)
		portal = new(T)
	AIStatus = AI_OFF
	forceMove(portal)

// Portal/Event code
/mob/living/simple_animal/nihil_portal
	name = "Portal to the Void"
	desc = "A portal leading an evil villain to this world, it doesn't seem to be open yet..."
	icon = 'icons/effects/64x64.dmi'
	icon_state = "curse"
	pixel_x = -16
	base_pixel_x = -16
	layer = LARGE_MOB_LAYER
	faction = list("Nihil", "hostile")
	maxHealth = 30000
	health = 30000
	damage_coeff = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0)
	move_resist = MOVE_FORCE_STRONG
	pull_force = MOVE_FORCE_STRONG
	mob_size = MOB_SIZE_HUGE
	del_on_death = TRUE
	var/list/girl_types = list(
		/mob/living/simple_animal/hostile/abnormality/wrath_servant,
		/mob/living/simple_animal/hostile/abnormality/hatred_queen,
		/mob/living/simple_animal/hostile/abnormality/despair_knight,
		/mob/living/simple_animal/hostile/abnormality/greed_king
	)
	var/list/portal_types = list(
		/obj/effect/magical_girl_portal/heart,
		/obj/effect/magical_girl_portal/spade,
		/obj/effect/magical_girl_portal/diamond,
		/obj/effect/magical_girl_portal/club
	)
	var/list/active_portals = list()

/mob/living/simple_animal/nihil_portal/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/nihil_portal/Move()
	return FALSE

/mob/living/simple_animal/nihil_portal/Initialize()
	. = ..()
	for(var/mob/M in GLOB.player_list) //vfx
		if(M.z == z && M.client)
			flash_color(M, flash_color = "#CCBBBB", flash_time = 50)
			shake_camera(M, 30, 2)
	for(var/area/A in world)
		for(var/obj/machinery/light/L in A)
			L.flicker(10)

	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list) //breach the girls
		if(!(A.type in girl_types))
			continue
		if(A.IsContained())
			A.BreachEffect()
//TODO: Add SFX
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 5 SECONDS, "How is the situation in your branch? We've got a disaster on our hands!", 25))
	addtimer(CALLBACK(src, PROC_REF(SpawnPortals)), 1 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(StartEvent)), 30 SECONDS)

/mob/living/simple_animal/nihil_portal/proc/SpawnPortals()
	set waitfor = FALSE
	for(var/dir in GLOB.diagonals) //Spawn the portals
		if(QDELETED(src))
			return
		var/turf/T = get_step(get_step(src, dir), dir)
		var/theportal = pick_n_take(portal_types)
		new theportal(T)
		active_portals += theportal
		sleep(5)

/mob/living/simple_animal/nihil_portal/proc/DeletePortals()
	for(var/obj/effect/magical_girl_portal/theportal in range(2, src))
		qdel(theportal)

/mob/living/simple_animal/nihil_portal/proc/StartEvent()
	DeletePortals()
	for(var/mob/living/simple_animal/hostile/abnormality/nihil/jester in contents)
		jester.forceMove(get_turf(src))
		jester.AIStatus = AI_ON
	addtimer(CALLBACK(GLOBAL_PROC, .proc/show_global_blurb, 5 SECONDS, "Life, Dreams, Hope, where do they come from? And where will they go?", 25))
	qdel(src)

/mob/living/simple_animal/nihil_portal/death(gibbed)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/show_global_blurb, 5 SECONDS, "The crisis has been averted.", 25))
	DeletePortals()
	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list) //breach the girls
		if(!is_type_in_list(A, girl_types))
			continue
		qdel(A)
	return

/obj/effect/magical_girl_portal
	name = "Magical Portal"
	desc = "Where does it go?"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "portal1"
	light_range = 3
	light_power = 2
	light_color = null
	light_on = TRUE
	var/magical_girl = null

/obj/effect/magical_girl_portal/Initialize()
	. = ..()
	var/turf/landing_turf
	var/turf/target_turf
	for(var/mob/living/simple_animal/nihil_portal/summonpoint in range(2,src))
		target_turf = get_turf(summonpoint)
		landing_turf = get_step_towards(src, summonpoint)

	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list) //breach the girls
		if(!istype(A, magical_girl))
			continue
		var/mob/living/simple_animal/hostile/abnormality/greed_king/girltarget = A //It shouldn't really matter which one is instanced here
		girltarget.toggle_ai(AI_OFF)
		girltarget.forceMove(landing_turf)
		girltarget.face_atom(target_turf)
		girltarget.EventStart()

/obj/effect/magical_girl_portal/heart
	magical_girl = /mob/living/simple_animal/hostile/abnormality/hatred_queen
	light_color = "#FE5BAC"

/obj/effect/magical_girl_portal/spade
	magical_girl = /mob/living/simple_animal/hostile/abnormality/despair_knight
	light_color = "#371F76"

/obj/effect/magical_girl_portal/diamond
	magical_girl = /mob/living/simple_animal/hostile/abnormality/greed_king
	light_color = "D4FAF37"

/obj/effect/magical_girl_portal/club
	magical_girl = /mob/living/simple_animal/hostile/abnormality/wrath_servant
	light_color = "960019"

//Void Status effect
//Decrease everyone's attributes.
/datum/status_effect/stacking/void
	id = "stacking_void"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 20 SECONDS
	alert_type = null
	stack_decay = 0
	stacks = 1
	max_stacks = 13
	on_remove_on_mob_delete = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/void
	consumed_on_threshold = FALSE

/atom/movable/screen/alert/status_effect/void
	name = "Void"
	desc = "You are empty inside."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "nihil"

/datum/status_effect/stacking/void/on_apply()
	. = ..()
	to_chat(owner, span_warning("The whole world feels dark and empty..."))
	if(owner.client)
		owner.add_client_colour(/datum/client_colour/monochrome)

/datum/status_effect/stacking/void/add_stacks(stacks_added)
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, -10 * stacks_added)
	status_holder.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, -10 * stacks_added)
	status_holder.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, -10 * stacks_added)
	status_holder.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, -10 * stacks_added)

/datum/status_effect/stacking/void/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, 10 * stacks)
	status_holder.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, 10 * stacks)
	status_holder.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, 10 * stacks)
	status_holder.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, 10 * stacks)
	to_chat(owner, span_nicegreen("You feel normal again."))
	if(owner.client)
		owner.remove_client_colour(/datum/client_colour/monochrome)

//Items - Loot
/obj/item/nihil
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	desc = "A playing card that seems to resonate with certain E.G.O."
	var/special

/obj/item/nihil/examine(mob/user)
	. = ..()
	if(special)
		. += span_notice("[special]")

/obj/item/nihil/heart
	name = "ace of hearts"
	icon_state = "nihil_heart"
	special = "Someone has to be the villain..."

/obj/item/nihil/spade
	name = "ace of spades"
	icon_state = "nihil_spade"
	special = "If I can't protect others, I may as well disappear..."

/obj/item/nihil/diamond
	name = "ace of diamonds"
	icon_state = "nihil_diamond"
	special = "I feel empty inside... Hungry. I want more things!"

/obj/item/nihil/club
	name = "ace of clubs"
	icon_state = "nihil_club"
	special = "Sinners of the otherworlds! Embodiments of evil!!!"

//Petrified statue code for the magical girls
/obj/structure/statue/petrified/magicalgirl
	name = "magical girl statue"
	desc = "A petrified magical girl."
	max_integrity = 100
	var/list/girl_types = list(
		/mob/living/simple_animal/hostile/abnormality/wrath_servant,
		/mob/living/simple_animal/hostile/abnormality/hatred_queen,
		/mob/living/simple_animal/hostile/abnormality/despair_knight,
		/mob/living/simple_animal/hostile/abnormality/greed_king
	)

/obj/structure/statue/petrified/magicalgirl/deconstruct(disassembled = TRUE) //You HAVE to use force to smash it
	qdel(src)

/obj/structure/statue/petrified/magicalgirl/Destroy()
	if(istype(src.loc, /mob/living/simple_animal/hostile/statue))
		var/mob/living/simple_animal/hostile/statue/S = src.loc
		forceMove(S.loc)
		if(S.mind)
			if(petrified_mob)
				S.mind.transfer_to(petrified_mob)
				to_chat(petrified_mob, span_notice("You slowly come back to your senses. You are in control of yourself again!"))
		qdel(S)

	for(var/obj/O in src)
		O.forceMove(loc)

	if(petrified_mob)
		petrified_mob.status_flags &= ~GODMODE
		petrified_mob.forceMove(loc)
		REMOVE_TRAIT(petrified_mob, TRAIT_MUTE, STATUE_MUTE)
		REMOVE_TRAIT(petrified_mob, TRAIT_NOBLEED, MAGIC_TRAIT)
		petrified_mob.faction -= "mimic"
		if(is_type_in_list(petrified_mob, girl_types))
			var/mob/living/simple_animal/hostile/abnormality/greed_king/magicalgirl = petrified_mob //It shouldn't really matter which one is instanced here
			magicalgirl.NihilIconUpdate()
			magicalgirl.AIStatus = AI_ON
		petrified_mob = null
	return ..()

#undef STATUS_EFFECT_VOID
