#define ICE_ARENA_QUEEN_SPAWN "ice_arena_queen"
#define ICE_ARENA_HERO_SPAWN "ice_arena_hero"
#define ICE_ARENA_VICTEM_SPAWN "ice_arena_victem"
#define ICE_ARENA_CENTER 1
#define ICE_ARENA_NORTH 2
#define ICE_ARENA_EAST 3
#define ICE_ARENA_SOUTH 4
#define ICE_ARENA_WEST 5
#define ICE_ARENA_TIMER 10 MINUTES

/mob/living/simple_animal/hostile/abnormality/snow_queen
	name = "Snow Queen"
	desc = "A tall construct of ice resembling royalty. Their robe seems to leave a \
	faint trail of snow flakes in their wake. They move with a cold elegance."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "snowqueen"
	icon_living = "snowqueen"
	icon_dead = "snowqueen_dead"
	portrait = "snow_queen"
	mob_biotypes = MOB_MINERAL
	maxHealth = 1500
	health = 1500
	blood_volume = 0
	move_to_delay = 5
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.1, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.8) //ASK SOMEONE GOOD AT BALANCING ABOUT THIS -IP
	base_pixel_x = -16
	pixel_x = -16
	can_breach = TRUE
	del_on_death = FALSE
	threat_level = HE_LEVEL
	melee_damage_lower = 15
	melee_damage_upper = 20
	melee_damage_type = RED_DAMAGE
	ranged = TRUE
	ranged_cooldown_time = 10 SECONDS
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(30, 30, 40, 40, 50),
		ABNORMALITY_WORK_INSIGHT = list(50, 50, 60, 60, 70),
		ABNORMALITY_WORK_ATTACHMENT = list(40, 40, 50, 50, 60),
		ABNORMALITY_WORK_REPRESSION = 0,
		"Rescue" = 100,
		)
	work_damage_amount = 10
	work_damage_type = WHITE_DAMAGE
	wander = FALSE

	observation_prompt = "You remember her. <br>\
		She got cold easily. <br>\
		The cryo-coffin must have been freezing. <br>\
		Freezing and cold. <br>\
		You thought about it often, seeing she who couldn't see her dreams come true, trapped inside ice. <br>\
		The brave agent headed to the Snow Palace and..."
	observation_choices = list(
		"Met the Snow Queen" = list(TRUE, "The Snow Queen was cold and beautiful. <br>You heard ice melting."),
		"Saved Kai" = list(FALSE, "Gerda saved Kai and returned home. <br>They lived happily ever after."),
	)

	ego_list = list(
		/datum/ego_datum/weapon/frostsplinter,
		/datum/ego_datum/armor/frostsplinter,
	)
	gift_type = /datum/ego_gifts/frostcrown
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY
	var/can_act = TRUE
	//The purpose of this variable is to prevent people from ghosting in the arena and making snow queen unworkable.
	var/arena_timer = 0
	var/slash_cooldown = 0
	var/slash_cooldown_time = 10 SECONDS
	//Arena attack cooldown.
	var/cleave_cooldown = 0
	var/cleave_cooldown_time = 7 SECONDS
	//If the snow queen activates her arena based attacks or not.
	var/arena_attacks = FALSE
	//Double Check if i need to have this variable.
	var/mob/living/carbon/human/frozen_employee
	var/mob/living/carbon/human/storybook_hero
	var/obj/structure/snowqueened_employee/snow_prison
	//A List of people who have been kissed.
	var/list/kissed = list()
		//Static variables shared by all iterations of Snow Queen and are not reset upon her defeat
	//Where the duelest and the victem are dropped off.
	var/static/turf/release_location
	//Landmarks used to teleport participants
	var/static/list/arena_landmarks = list()
	//attack teleport spots
	var/static/list/teleport_locations = list()
	//AOE area cleaves
	var/static/list/arena_cleave = list()
	//We may be getting too many lists now. List for existing temporary elements like illusions
	var/static/list/temp_effects = list()
	//Reusable visuals for cleave attacks.
	var/datum/reusable_visual_pool/RVP = new(200)

/mob/living/simple_animal/hostile/abnormality/snow_queen/Move()
	if(!can_act)
		return FALSE
	..()

/mob/living/simple_animal/hostile/abnormality/snow_queen/PostSpawn()
	..()
	if(!arena_landmarks.len)
		arena_landmarks = RegisterArenaSpawns()
		//Teleport Locations for Attacks
		var/turf/teleport_turf
		if(!teleport_locations.len)
			for(var/obj/effect/landmark/snowqueen_teleport/T in GLOB.landmarks_list)
				teleport_turf = get_turf(T)
				teleport_locations += teleport_turf
		RegisterCleaveZones()

/mob/living/simple_animal/hostile/abnormality/snow_queen/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(CheckArmor(user))
		FreezeEmployee(user)
		return

/mob/living/simple_animal/hostile/abnormality/snow_queen/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(CheckArmor(user))
		FreezeEmployee(user)
		return
	if(prob(40))
		KissEmployee(user)
	return

/mob/living/simple_animal/hostile/abnormality/snow_queen/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(CheckArmor(user))
		FreezeEmployee(user)
		return
	if(prob(90))
		KissEmployee(user)
	return

/mob/living/simple_animal/hostile/abnormality/snow_queen/AttemptWork(mob/living/carbon/human/user, work_type)
	..()
	if(work_type == "Rescue")
		if(!QDELETED(frozen_employee))
			if(!storybook_hero)
				BringToArena(src, user, snow_prison)
				datum_reference.console.meltdown = FALSE
			else
				to_chat(user, span_notice("The Snow Queen is currently in battle."))
				datum_reference.console.meltdown = FALSE
				return FALSE
		else
			to_chat(user, span_notice("No one is frozen by the Snow Queen yet."))
			frozen_employee = null
		return FALSE
	if(frozen_employee || snow_prison)
		if(QDELETED(snow_prison))
			to_chat(user, span_notice("You brush the shards of ice out of the way."))
			snow_prison = null
			frozen_employee = null
			return FALSE
		to_chat(user, span_notice("You'll need to shatter the frozen employee to continue normal working."))
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/snow_queen/BreachEffect(mob/living/carbon/human/user, breach_type)
	//If your in the arena dont breach, if your not in godmode dont breach.
	if(breach_type == BREACH_PINK)
		faction += "pink_midnight"
	//Call root code but with normal breach
	. = ..(null, BREACH_NORMAL)
	if(!IsCombatMap())
		var/turf/T = pick(GLOB.department_centers)
		forceMove(T)
	update_icon()

/mob/living/simple_animal/hostile/abnormality/snow_queen/ZeroQliphoth(mob/living/carbon/human/user)
	if(arena_attacks)
		datum_reference.qliphoth_change(1)
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/snow_queen/Life()
	. = ..()
	if(status_flags & GODMODE)
		return
	if(arena_attacks)
		if(arena_timer <= world.time)
			WinterContinues()
			return
		if(cleave_cooldown <= world.time && health >= 200 && target && !client)
			ArenaAttack()

/mob/living/simple_animal/hostile/abnormality/snow_queen/OpenFire()
	if(!can_act)
		return FALSE
	if(ranged_cooldown > world.time)
		return FALSE
	ranged_cooldown = world.time + ranged_cooldown_time
	var/turf/T = get_step(get_turf(src), pick(1,2,4,5,6,8,9,10))
	if(T.density == FALSE)
		ProjectSplinter(target, T, 8)
		SLEEP_CHECK_DEATH(3)
		playsound(get_turf(src), 'sound/abnormalities/despairknight/attack.ogg', 50, 0, 4)
		return

//Attack until dusted
/mob/living/simple_animal/hostile/abnormality/snow_queen/CanAttack(atom/the_target)
	if(storybook_hero == the_target || frozen_employee == the_target)
		return TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/snow_queen/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	if(client)
		return ..()
	//Destroy them. They lost the duel.
	if(ishuman(attacked_target))
		var/mob/living/carbon/human/H = attacked_target
		if(H.stat == DEAD && (H == storybook_hero || H == frozen_employee))
			H.dust(TRUE, FALSE)
			return FALSE
	//If arena attacks is true then dont have a chance connected to it.
	if(slash_cooldown < world.time && (prob(50) || arena_attacks))
		if(arena_attacks)
			can_act = FALSE
			playsound(get_turf(src), 'ModularTegustation/Tegusounds/weapons/unsheathed_blade.ogg', 55, 0, 5)
			if(!do_after(src, 7, target = src))
				can_act = TRUE
				return
			can_act = TRUE
		Slash(attacked_target, wide = pick(TRUE, FALSE))
		return
	//Dont do normal attacks if in the arena.
	if(!arena_attacks)
		return ..()

//Snow Queen will only release her prisoner if she was dueled with her arena attacks on. Which is every time shes dueled in her arena.
/mob/living/simple_animal/hostile/abnormality/snow_queen/death(gibbed)
	if(QDELETED(snow_prison) && arena_attacks)
		Defrost(snow_prison)
	update_icon()
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	return ..()

//Prevents gibbing during the duel.
/mob/living/simple_animal/hostile/abnormality/snow_queen/gib()
	if(arena_attacks)
		return FALSE
	return ..()

//This is here so that people can see the death animation before snow queen is defeated.
/mob/living/simple_animal/hostile/abnormality/snow_queen/Destroy()
	if(!storybook_hero && snow_prison)
		Defrost(snow_prison, TRUE)
	else
		ReleasePrisoners()
	ClearEffects()
	QDEL_NULL(RVP)
	return ..()

		/*---------------------\
		|CROSS ABNO INTERACTION|
		\---------------------*/
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/CheckArmor(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	var/obj/item/clothing/suit/armor/ego_gear/user_ego = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(user_ego, /obj/item/clothing/suit/armor/ego_gear/waw/feather))
		to_chat(H, span_userdanger("Snow Queen reacts to your ego and freezes you."))
		return TRUE

		/*-------------------\
		|DEFAULT SLASH ATTACK|
		\-------------------*/
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/Slash(target, wide = TRUE)
	if (!client && (get_dist(src, target) > 4))
		return
	slash_cooldown = world.time + slash_cooldown_time
	var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
	var/turf/source_turf = get_turf(src)
	var/turf/area_of_effect = list()
	var/turf/middle_line = list()
	var/upline = NORTH
	var/downline = SOUTH
	var/smash_length = 2
	var/smash_width = 2
	if(wide)
		playsound(get_turf(src), 'sound/weapons/bladeslice.ogg', 50, 0, 5)
	else
		playsound(get_turf(src), 'sound/weapons/bladeslice.ogg', 50, 0, 5)
		smash_length = 4
		smash_width = 1
	middle_line = getline(source_turf, get_ranged_target_turf(source_turf, dir_to_target, smash_length))
	if(dir_to_target == NORTH || dir_to_target == SOUTH)
		upline = EAST
		downline = WEST
	for(var/turf/T in middle_line)
		if(T.density)
			break
		for(var/turf/Y in getline(T, get_ranged_target_turf(T, upline, smash_width)))
			if (Y.density)
				break
			if (Y in area_of_effect)
				continue
			area_of_effect += Y
		for(var/turf/U in getline(T, get_ranged_target_turf(T, downline, smash_width)))
			if (U.density)
				break
			if (U in area_of_effect)
				continue
			area_of_effect += U
	if(!dir_to_target)
		for(var/turf/TT in view(1, src))
			if (TT.density)
				break
			if (TT in area_of_effect)
				continue
			area_of_effect |= TT
	if (!LAZYLEN(area_of_effect))
		return
	can_act = FALSE
	dir = dir_to_target
	for(var/turf/T in area_of_effect)
		new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/L in HurtInTurf(T, list(), 20, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE))
			playsound(get_turf(src), 'sound/magic/teleport_app.ogg', 30, 1)

	SLEEP_CHECK_DEATH(0.5 SECONDS)
	can_act = TRUE

//Quick proc for spawning and launching a frost splinter projectile.
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/ProjectSplinter(mob/living/L, turf/T, projectile_telegraph_delay = 3)
	if(!L || !T)
		return
	var/obj/projectile/frost_splinter/P
	P = new(T)
	P.starting = T
	P.firer = src
	P.fired_from = T
	P.yo = L.y - T.y
	P.xo = L.x - T.x
	P.original = L
	P.preparePixelProjectile(L, T)
	addtimer(CALLBACK (P, TYPE_PROC_REF(/obj/projectile, fire)), projectile_telegraph_delay)

		/*--------\
		|WORK KISS|
		\--------*/
//This can be connected to a LCL gamemode ability
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/KissEmployee(mob/living/carbon/human/H)
	to_chat(H, span_notice("[src] gives you a kiss."))
	if(!locate(H) in kissed)
		kissed += H
		kissed[H] = 0
	kissed[H] += 1
	if(kissed[H] >= 2)
		FreezeEmployee(H)

//Imprisons employee who was kissed twice by Snow Queen.
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/FreezeEmployee(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	kissed.Cut()
	playsound(get_turf(src), 'sound/effects/podwoosh.ogg', 75, 1)
	var/obj/item/radio/headset/radio = H.get_item_by_slot(ITEM_SLOT_EARS)
	if(radio)
		radio.forceMove(get_turf(H))
	var/obj/structure/snowqueened_employee/P = new(get_turf(H))
	P.GrabEmployee(H)
	snow_prison = P
	frozen_employee = H
	to_chat(frozen_employee, "In an unforgiving blizzard, Kai met the Snow Queen. He became curious of the world beyond his knowledge..")
	return TRUE

//Remotely defrosts employee, lethally or non lethally.
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/Defrost(obj/structure/snowqueened_employee/melt_ice, lethal = FALSE)
	if(melt_ice)
		if(lethal)
			QDEL_IN(melt_ice, 5)
		else
			melt_ice.ReleaseSafe()

		/*-------------\
		|REGISTER PROCS|
		\-------------*/

//Registers turf locations for the 3 people being teleported to the duel.
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/RegisterArenaSpawns()
	var/list/arena_spawn_locs = list(
		ICE_ARENA_QUEEN_SPAWN = 0,
		ICE_ARENA_HERO_SPAWN = 0,
		ICE_ARENA_VICTEM_SPAWN = 0
		)
	var/turf/landmark_turf = locate(/obj/effect/landmark/snowqueen_spawn) in GLOB.landmarks_list
	arena_spawn_locs[ICE_ARENA_QUEEN_SPAWN] = get_turf(landmark_turf)
	landmark_turf = locate(/obj/effect/landmark/snowqueen_playerspawn) in GLOB.landmarks_list
	arena_spawn_locs[ICE_ARENA_HERO_SPAWN] = get_turf(landmark_turf)
	landmark_turf = locate(/obj/effect/landmark/snowqueen_victimspawn) in GLOB.landmarks_list
	arena_spawn_locs[ICE_ARENA_VICTEM_SPAWN] = get_turf(landmark_turf)
	return arena_spawn_locs

//Collects list of turfs needed for cleave attacks.
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/RegisterCleaveZones()
	arena_cleave.Cut()
	if(!arena_landmarks.len)
		return FALSE
	arena_cleave = list(
		ICE_ARENA_CENTER = list(),
		ICE_ARENA_NORTH = list(),
		ICE_ARENA_EAST = list(),
		ICE_ARENA_SOUTH = list(),
		ICE_ARENA_WEST = list()
		)
	var/turf/arena_center = get_turf(arena_landmarks[ICE_ARENA_VICTEM_SPAWN])
	var/xcord = arena_center.x
	var/ycord = arena_center.y
	for(var/turf/T in circlerange(arena_center, 7))
		arena_cleave[ICE_ARENA_CENTER] += T
	arena_cleave[ICE_ARENA_NORTH] = GetArenaTurfs(locate(xcord - 11,ycord + 4,z), locate(xcord + 11,ycord + 7, arena_center.z))
	arena_cleave[ICE_ARENA_EAST] = GetArenaTurfs(locate(xcord + 4,ycord - 11,z), locate(xcord + 12,ycord + 11 ,arena_center.z))
	arena_cleave[ICE_ARENA_SOUTH] = GetArenaTurfs(locate(xcord - 11,ycord - 12,z), locate(xcord + 11,ycord - 4, arena_center.z))
	arena_cleave[ICE_ARENA_WEST] = GetArenaTurfs(locate(xcord -12,ycord - 11,z), locate(xcord - 4,ycord + 11,arena_center.z))

//Uses DM guide code to get a solid block of turfs from the southwest and northeast cords.
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/GetArenaTurfs(point_one, point_two)
	. = list()
	for(var/turf/T in block(point_one, point_two))
		if(isfloorturf(T))
			. += T

//Collects 8 turfs surrounding the target.
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/SurroundTarget(mob/living/L)
	. = list()
	var/turf/enemy_turf = get_turf(L)
	//Four Tiles North
	. += locate(enemy_turf.x ,enemy_turf.y +4,enemy_turf.z)
	//Four Tiles South
	. += locate(enemy_turf.x ,enemy_turf.y -4,enemy_turf.z)
	//Four Tiles East
	. += locate(enemy_turf.x +4 ,enemy_turf.y,enemy_turf.z)
	//Four Tiles West
	. += locate(enemy_turf.x -4 ,enemy_turf.y,enemy_turf.z)
	//Four Tiles Northeast
	. += locate(enemy_turf.x +4 ,enemy_turf.y +3,enemy_turf.z)
	//Four Tiles Southeast
	. += locate(enemy_turf.x +4,enemy_turf.y -3,enemy_turf.z)
	//Four Tiles Northwest
	. += locate(enemy_turf.x -4 ,enemy_turf.y +3,enemy_turf.z)
	//Four Tiles Southwest
	. += locate(enemy_turf.x -4 ,enemy_turf.y -3,enemy_turf.z)
	//Double check that all areas are nondense
	for(var/turf/good_area in .)
		if(!isfloorturf(good_area))
			. -= good_area

//Combines two parts of the arena without having overlap.
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/ReturnNoOverlap(list/area_one, list/area_two)
	var/list/unique_list = area_one + area_two
	return uniqueList(unique_list)

		/*-----------------------------\
		|SNOW QUEEN ARENA RELATED PROCS|
		\-----------------------------*/
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/BringToArena(mob/living/simple_animal/hostile/abnormality/snow_queen/queen, mob/living/carbon/hero, obj/structure/snowqueened_employee/prison)
	if(!release_location)
		release_location = get_turf(hero)
	if(!arena_landmarks.len)
		return FALSE
	if(QDELETED(prison))
		frozen_employee = null
		return FALSE
	arena_timer = world.time + ICE_ARENA_TIMER
	arena_attacks = TRUE
	dir = 2
	toggle_ai(AI_IDLE) // Run.
	status_flags &= ~GODMODE
	//Clean up the arena
	CleanArena()
	queen.forceMove(arena_landmarks[ICE_ARENA_QUEEN_SPAWN])
	//Her normal attack is now her secondary
	slash_cooldown_time = 2 SECONDS
	//Drop all your weapons.
	for(var/obj/item/E in hero.GetAllContents())
		if(!is_ego_weapon(E))
			continue
		hero.dropItemToGround(E, TRUE, TRUE)
	hero.forceMove(arena_landmarks[ICE_ARENA_HERO_SPAWN])
	storybook_hero = hero
	RegisterSignal(hero, COMSIG_PARENT_QDELETING, PROC_REF(WinterContinues))
	prison.forceMove(arena_landmarks[ICE_ARENA_VICTEM_SPAWN])
	var/storybook_text = "Gerda was strong enough to remain unpierced by the mirror, and brave enough to go on a journey to rescue Kai. So she set off towards the Snow Palace."
	to_chat(storybook_hero, storybook_text)
	to_chat(frozen_employee, storybook_text)
	notify_ghosts("[hero] is challenging the Snow Queen to a duel!", source = src, action = NOTIFY_ORBIT, header="Something Interesting!")
	return TRUE

//For removing blood and debris
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/CleanArena()
	var/area/arena = get_area(arena_landmarks[ICE_ARENA_VICTEM_SPAWN])
	for(var/atom/stuff in arena)
		if(istype(stuff, /obj/effect/decal/cleanable/blood) || istype(stuff, /obj/effect/decal/cleanable/ash) || istype(stuff, /obj/structure/spring_healing))
			QDEL_IN(stuff, 10)
		if(istype(stuff, /obj/item/chair/icequeen))
			continue
		if(isitem(stuff))
			var/obj/item/I = stuff
			I.forceMove(release_location)

//Procs when the hero saves Snow Queens captive
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/ReleasePrisoners()
	if(!QDELETED(snow_prison))
		Defrost(snow_prison)
	if(!QDELETED(frozen_employee))
		RewardPrisoner(frozen_employee)
	RewardPrisoner(storybook_hero)
	storybook_hero = null
	frozen_employee = null

/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/RewardPrisoner(mob/living/carbon/human/rewardee)
	if(!rewardee)
		return
	rewardee.forceMove(release_location)
	to_chat(rewardee, "The roses blossom and the Snow Palace falls. Not a single soul remembered the woman sleeping there.")
	if(ishuman(rewardee))
		var/datum/ego_gifts/frostsplinter/S = new
		S.datum_reference = datum_reference
		rewardee.Apply_Gift(S)

//Procs when the hero is dusted by Snow Queen or the arena timer runs out.
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/WinterContinues()
	SIGNAL_HANDLER
	Defrost(snow_prison, TRUE)
	if(!QDELETED(storybook_hero))
		storybook_hero.dust(TRUE, TRUE)
	if(!QDELETED(frozen_employee))
		frozen_employee.dust(TRUE, TRUE)
	frozen_employee = null
	storybook_hero = null
	QDEL_IN(src, 10)
	//The story is over.

			/*------------\
			|ARENA ATTACKS|
			\------------*/

//Begins Area Attack
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/ArenaAttack()
	if(!can_act)
		return
	can_act = FALSE
	ChooseArenaAttack(rand(0,2))
	cleave_cooldown = world.time + cleave_cooldown_time
	ClearEffects()
	SpringComes()
	can_act = TRUE

//Determines what area attack we preform
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/ChooseArenaAttack(attack_type = 0)
	var/after_image_locations = Illusions(attack_type)
	var/get_health = health
	if(attack_type == 0)
		ChillingCleave(get_health)
	if(attack_type == 1)
		RapidSplinter(target)
	else
		if(do_after(src, 1 SECONDS, target = src) && get_health == health)
			for(var/turf/after_spike in after_image_locations)
				AoeTurfEffect(after_spike, 6)
			BladeDash(target)

//Rapidly shoots frost splinters at the target
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/RapidSplinter(mob/living/L)
	var/get_health = health
	if(!L || L.stat == DEAD)
		return
	for(var/round = 0 to 6)
		if(!L || L.stat == DEAD || stat == DEAD)
			break
		if(!do_after(src, 2, target = src) && get_health > health)
			break
		ProjectSplinter(L, get_turf(src), 3)
		playsound(get_turf(src), 'sound/abnormalities/despairknight/attack.ogg', 50, 0, 4)

//At half health a healing patch of roses spawn to assist the player.
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/SpringComes(turf/melted_snow)
	if(health < 750)
		if(!melted_snow)
			melted_snow = pick(arena_cleave[ICE_ARENA_CENTER])
		new /obj/structure/spring_healing(melted_snow)

//Creates fading decoys to distract the player while the real one preps a attack.
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/Illusions(close = FALSE)
	var/list/places = list()
	if(close && target)
		places += SurroundTarget(target)
	else
		places = teleport_locations.Copy()
	src.forceMove(get_turf(pick_n_take(places)))
	dir = 2
	for(var/turf/T in places)
		var/obj/effect/temp_visual/decoy/fading/fivesecond/D = new(get_turf(T), src)
		temp_effects += D
	return places

//Removes all temporary effects
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/ClearEffects()
	for(var/obj/i in temp_effects)
		qdel(i)
	temp_effects.Cut()

//Cleaves a defined area of the Arena. Leads to Cleave()
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/ChillingCleave(snow_health)
	//No hitting the same area twice.
	var/attack_area
	var/second_attack_area
	var/last_attack_area
	for(var/i = 0 to 3)
		var/list/potential_aoe = list(1,2,3,4,5)
		last_attack_area = 0
		LAZYREMOVE(potential_aoe, last_attack_area)
		attack_area = pick_n_take(potential_aoe)

		if(i > 0)
			second_attack_area = pick_n_take(potential_aoe)

		var/list/turfs_to_hit = arena_cleave[attack_area]
		if(second_attack_area)
			turfs_to_hit = ReturnNoOverlap(arena_cleave[attack_area], arena_cleave[second_attack_area])

		var/cleave_chargeup = (3 SECONDS) - (i * 5)
		for(var/turf/T in turfs_to_hit)
			AoeTurfEffect(T, cleave_chargeup, TRUE)
		if(do_after(src, cleave_chargeup, target = src) && snow_health <= health)
			if(i > 0)
				ProjectileHell(target)
			Cleave(turfs_to_hit)
			last_attack_area = attack_area
			i++
			continue
		else
			visible_message("[src] breaks concentration on her spell due to your attacks.")
			playsound(get_turf(src), 'sound/magic/magic_missile.ogg', 50, 0, 4)
			break

//Cleaves a large area of the arena
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/Cleave(list/turfs_to_cleave)
	playsound(get_turf(src), 'sound/effects/podwoosh.ogg', 100, 1)
	for(var/turf/T in turfs_to_cleave)
		AoeTurfEffect(T, 4)

//Shoots projectiles from teleport spots that the snow queen isnt at.
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/ProjectileHell(mob/living/L)
	for(var/turf/shootems in teleport_locations)
		if(!L)
			break
		if(shootems == get_turf(src))
			continue
		ProjectSplinter(L, shootems, 3)
		playsound(shootems, 'sound/abnormalities/despairknight/attack.ogg', 50, 0, 4)

//Determines if the effect on a AOE area is telegraphed or actually harmful.
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/AoeTurfEffect(turf/T, duration, telegraph = FALSE)
	if(!T)
		return
	RVP.NewSnowQueenEffect(T, duration, telegraph)
	if(telegraph)
		return
	return HurtInTurf(T, list(), 35, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE)

//Code taken from big_wolf.dm. Essentially is a 3by3 dash at the target.
/mob/living/simple_animal/hostile/abnormality/snow_queen/proc/BladeDash(dash_target)
	can_act = FALSE
	if(IsContained())
		return
	var/turf/target_turf = get_turf(dash_target)
	var/list/hit_mob = list()
	icon_state = "snowqueen_charge"
	update_icon()
	if(do_after(src, 1 SECONDS, target = src))
		//I know it isnt a directional sprite... maybe one day -IP
		icon_state = "snowqueen_burst"
		update_icon()
		var/turf/wallcheck = get_turf(src)
		var/enemy_direction = get_dir(src, target_turf)
		for(var/i = 0 to 7)
			if(get_turf(src) != wallcheck || stat == DEAD || IsContained())
				break
			wallcheck = get_step(src, enemy_direction)
			if(!ClearSky(wallcheck))
				break
			//without this the attack happens instantly
			sleep(1)
			forceMove(wallcheck)
			playsound(wallcheck, 'sound/abnormalities/doomsdaycalendar/Lor_Slash_Generic.ogg', 20, 0, 4)
			for(var/turf/T in orange(get_turf(src), 1))
				if(isclosedturf(T))
					continue
				new /obj/effect/temp_visual/slice(T)
				hit_mob = HurtInTurf(T, hit_mob, 20, RED_DAMAGE, null, TRUE, FALSE, TRUE, hurt_structure = FALSE)
	can_act = TRUE
	icon_state = "snowqueen"
	update_icon()

		/*-------------------\
		|REUSABLE VISUAL PROC|
		\-------------------*/
// It feels like this should be more modular but i dont want to overstep
/datum/reusable_visual_pool/proc/NewSnowQueenEffect(turf/location, duration = 10, telegraph = FALSE)
	var/obj/effect/reusable_visual/RV = TakePoolElement()
	if(telegraph)
		RV.name = "cracked floor"
		RV.icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
		RV.icon_state = "cracks_dark"
	else
		RV.name = "ice spike"
		RV.icon = 'ModularTegustation/Teguicons/32x48.dmi'
		RV.icon_state = pick("ice_spike1", "ice_spike2", "ice_spike3")
	RV.layer = ABOVE_MOB_LAYER
	RV.loc = location
	DelayedReturn(RV, duration)
	return RV

		/*-----------\
		|MAP ELEMENTS|
		\-----------*/
/obj/effect/landmark/snowqueen_teleport
	name = "snow queen teleport"
	icon_state = "x2"

/obj/effect/landmark/snowqueen_spawn
	name = "snow queen spawn"
	icon_state = "x"

/obj/effect/landmark/snowqueen_playerspawn
	name = "snow queen player spawn"
	icon_state = "observer_start"

/obj/effect/landmark/snowqueen_victimspawn
	name = "snow queen victim spawn"
	icon_state = "observer_start"

//Healing Roses
/obj/structure/spring_healing
	name = "blooming roses"
	desc = ""
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "rdflowers_1"
	anchored = TRUE
	density = FALSE
	var/auto_deactivate_cooldown
	var/healing_cooldown = 0
	var/healing_cooldown_time = 1 SECONDS

/obj/structure/spring_healing/Initialize()
	. = ..()
	auto_deactivate_cooldown = world.time + (6 SECONDS)
	icon_state = "rdflowers_[rand(1,3)]"
	START_PROCESSING(SSobj, src)

/obj/structure/spring_healing/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/spring_healing/process(delta_time)
	if(healing_cooldown <= world.time)
		var/turf/where_we_are = get_turf(src)
		healing_cooldown = world.time + healing_cooldown_time
		new /obj/effect/area_heal(where_we_are)
		for(var/mob/living/carbon/human/H in range(1, where_we_are))
			if(H.stat != DEAD)
				to_chat(H, span_nicegreen("The warmth of spring melts away the winter frost and restores you."))
				H.adjustBruteLoss(-5)
	if(auto_deactivate_cooldown <= world.time)
		STOP_PROCESSING(SSobj, src)

//Snow Prison
/obj/structure/snowqueened_employee
	icon_state = "ice_grave2"
	icon = 'icons/obj/flora/icedecor.dmi'
	max_integrity = 600
	anchored = TRUE
	density = FALSE
	var/release_safe = FALSE
	var/thawing = 0

/obj/structure/snowqueened_employee/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/ego_weapon/shield/ice_sword))
		thawing += 35
		if(thawing >= 500)
			to_chat(user, span_notice("The ice melts away."))
			ReleaseSafe()
			return
		to_chat(user, span_notice("The ice slowly melts."))
		playsound(get_turf(src), 'sound/effects/glass_step.ogg', 50, TRUE)
		return
	return ..()

/obj/structure/snowqueened_employee/Destroy()
	for(var/atom/movable/AM in src)
		AM.forceMove(get_turf(src))
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			if(!release_safe)
				H.dust(TRUE, TRUE)
			else
				ReleaseEmployee(H)
	return ..()

/obj/structure/snowqueened_employee/proc/GrabEmployee(mob/living/carbon/human/H)
	if(!H)
		return
	H.forceMove(src)
	ADD_TRAIT(H, TRAIT_NOBREATH, src)
	ADD_TRAIT(H, TRAIT_INCAPACITATED, src)
	ADD_TRAIT(H, TRAIT_IMMOBILIZED, src)
	ADD_TRAIT(H, TRAIT_HANDS_BLOCKED, src)

/obj/structure/snowqueened_employee/proc/ReleaseSafe()
	release_safe = TRUE
	Destroy()

/obj/structure/snowqueened_employee/proc/ReleaseEmployee(mob/living/carbon/human/prisoner)
	REMOVE_TRAIT(prisoner, TRAIT_NOBREATH, src)
	REMOVE_TRAIT(prisoner, TRAIT_INCAPACITATED, src)
	REMOVE_TRAIT(prisoner, TRAIT_IMMOBILIZED, src)
	REMOVE_TRAIT(prisoner, TRAIT_HANDS_BLOCKED, src)

/obj/structure/chair/snowqueen
	name = "Snow Queen's Throne"
	desc = "An icey throne."
	icon = 'ModularTegustation/Teguicons/160x160.dmi'
	icon_state = "snowqueen_throne"
	dir = 2
	resistance_flags = INDESTRUCTIBLE
	layer = HIGH_OBJ_LAYER
	density = 1
	anchored = 1
	bound_height = 160
	bound_width = 160
	item_chair = null

//The sword holder
/obj/structure/frozensword
	name = "frozen sword"
	desc = "A sword, partially frozen. It beckons you to try and pull it out."
	icon = 'icons/obj/structures.dmi'
	icon_state = "icechunk"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/obj/item/ego_weapon/shield/ice_sword/dueling_sword
	var/empty = FALSE
	var/mob/living/simple_animal/hostile/abnormality/snow_queen/connected_abno

/obj/structure/frozensword/Initialize()
	. = ..()
	dueling_sword = new
	update_icon()

/obj/structure/frozensword/attack_hand(mob/user) //Add code to open the gate when its drawn
	. = ..()
	if(!connected_abno)
		connected_abno = locate(/mob/living/simple_animal/hostile/abnormality/snow_queen) in GLOB.abnormality_mob_list
		if(connected_abno)
			RegisterSignal(connected_abno, COMSIG_PARENT_QDELETING, PROC_REF(Refresh))
	if(dueling_sword)
		user.put_in_hands(dueling_sword)
		RegisterSignal(dueling_sword, COMSIG_PARENT_QDELETING, PROC_REF(Refresh))
		to_chat(user, span_notice("You pull out [dueling_sword]!"))
		src.add_fingerprint(user)
		empty = TRUE
		playsound(get_turf(src), 'sound/items/unsheath.ogg', 50, TRUE)
		update_icon()
		return

/obj/structure/frozensword/attack_paw(mob/living/user)
	return attack_hand(user)

/obj/structure/frozensword/update_overlays()
	. = ..()
	if(!empty)
		. += "sword"

/obj/structure/frozensword/proc/Refresh()
	SIGNAL_HANDLER

	if(!QDELETED(dueling_sword))
		QDEL_IN(dueling_sword, 1)
	dueling_sword = new
	empty = FALSE
	update_icon()

/obj/item/ego_weapon/shield/ice_sword
	name = "old sword"
	desc = "This blade is almost encased in frost yet it eminates a soothing warmth."
	special = "Use in hand to deflect attacks and prevent damage."
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right.dmi'
	icon_state = "philip"
	force = 30
	damtype = RED_DAMAGE
	attack_verb_continuous = list("slashes", "stabs")
	attack_verb_simple = list("slash", "stab")
	hitsound = 'sound/weapons/bladeslice.ogg'
	reductions = list(80, 0, 0, 0) // 80
	projectile_block_duration = 0.5 SECONDS
	block_duration = 1 SECONDS
	block_cooldown = 3 SECONDS
	block_sound = 'sound/weapons/ego/crumbling_parry.ogg'
	projectile_block_message ="Spring arrives with blossoming roses."
	block_message = "You attempt to parry the attack!"
	hit_message = "parries the attack!"
	block_cooldown_message = "You rearm your blade."
	//For deleting it whenever seperated from user.
	item_flags = DROPDEL

/obj/item/ego_weapon/shield/ice_sword/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/*
This is a code snippet that should be used when the player exits or dies to refresh the boss areana
Change /obj/item/ego_weapon to the path of the special snow queen sword
You may also simply be able to call refresh when snow queen dies.

	//To delete the sword. You can call this when snow queen dies by adding the player as a variable or any similar approach
	for(var/obj/item/ego_weapon/THESWORDPATH/THESWORD in PLAYERS_EXITING_ARENA.GetAllContents())
		qdel(THESWORD)

	//To reset the structure, you can call this when snow queen dies.
	var/linked_structure = locate(/obj/structure/frozensword) in world.contents
	linked_structure.Refresh()


Airlock stuff
Find /obj/machinery/door/airlock/snowqueen in the airlock_types.dm file
To prevent players from leaving without the sword, make sure to update the path of the sword in the code.


Footnotes

It is probably a good idea to stick the sword to the player's hand, lest they get trapped behind the gate after throwing it through or something.
 */

/*
* Im too tired to reorganize everything in this PR. The ice queens chair is in chair.dm
* and all arena elements are in flora/icedecor.dmi
* When i feel better i may change the door into a structure like necorpolis_gate.dm -IP
*/

#undef ICE_ARENA_QUEEN_SPAWN
#undef ICE_ARENA_HERO_SPAWN
#undef ICE_ARENA_VICTEM_SPAWN
#undef ICE_ARENA_CENTER
#undef ICE_ARENA_NORTH
#undef ICE_ARENA_EAST
#undef ICE_ARENA_SOUTH
#undef ICE_ARENA_WEST
#undef ICE_ARENA_TIMER
