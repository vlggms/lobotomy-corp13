// The main gimmick is changing weapons while unlocking furioso. Changing weapons has 1 minute cooldown that reduces each time you attack
// Ping Chiemi for questions, but she's also confused
/obj/item/ego_weapon/black_silence_gloves
	name = "Gloves of the Black Silence"
	desc = "Worn out gloves that were originally used by the Black Silence."
	special = "SHIFT+CLICK to perform Furioso after using all of Black Silences weapons."
	icon_state = "gloves"
	icon = 'icons/obj/black_silence_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/black_silence_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/black_silence_righthand.dmi'
	force = 1
	damtype = BLACK_DAMAGE

	attack_verb_continuous = list("taps", "pats")
	attack_verb_simple = list("tap", "pat")
	hitsound = 'sound/effects/hit_punch.ogg'
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 120,
		PRUDENCE_ATTRIBUTE = 120,
		TEMPERANCE_ATTRIBUTE = 120,
		JUSTICE_ATTRIBUTE = 120,
	)
	actions_types = list(/datum/action/item_action/toggle_iff)
	var/special_cooldown
	var/special_cooldown_time
	var/exchange_cooldown
	var/exchange_cooldown_time = 60 SECONDS
	var/furioso_time
	var/furioso_wait = 300 SECONDS
	var/origin_name = "Gloves of the Black Silence"
	var/locked_state = "gloves_unlocked"
	var/unlocked = FALSE
	var/list/unlocked_list = list()
	var/iff = TRUE

/obj/item/ego_weapon/black_silence_gloves/equipped(mob/user, slot)
	. = ..()
	if(!user)
		return
	RegisterSignal(user, COMSIG_MOB_SHIFTCLICKON, PROC_REF(DoChecks))

/obj/item/ego_weapon/black_silence_gloves/Destroy(mob/user)
	UnregisterSignal(user, COMSIG_MOB_SHIFTCLICKON)
	return ..()

/obj/item/ego_weapon/black_silence_gloves/dropped(mob/user)
	. = ..()
	UnregisterSignal(user, COMSIG_MOB_SHIFTCLICKON)

/datum/action/item_action/toggle_iff
	name = "Toggle IFF"
	desc = "Toggles your ability to hit friendly targets."
	icon_icon = 'icons/obj/black_silence_weapons.dmi'
	button_icon_state = "gloves"

/datum/action/item_action/toggle_iff/Trigger()
	var/obj/item/ego_weapon/black_silence_gloves/H = target
	if(istype(H))
		H.toggle_iff(owner)

/obj/item/ego_weapon/black_silence_gloves/proc/toggle_iff(mob/living/user)
	if(iff)
		iff = FALSE
		to_chat(user,span_warning("You will now attack everything indiscriminately!"))
	else
		iff = TRUE
		to_chat(user,span_warning("You will now only attack enemies!"))

/obj/item/ego_weapon/black_silence_gloves/proc/dash(mob/living/user, turf/target_turf)
	var/list/line_turfs = list(get_turf(user))
	for(var/turf/T in getline(user, target_turf))
		line_turfs += T
	user.forceMove(target_turf)
	// "Movement" effect
	for(var/i = 1 to line_turfs.len)
		var/turf/T = line_turfs[i]
		if(!istype(T))
			continue
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(T, user)
		D.alpha = min(150 + i*15, 255)
		animate(D, alpha = 0, time = 2 + i*2)

/obj/item/ego_weapon/black_silence_gloves/proc/DoChecks(mob/living/user, atom/target)
	var/mob/living/L = target
	if(!CanUseEgo(user))
		return
	if(user.get_active_held_item() != src)
		return
	if(special_cooldown > world.time)
		return
	if(iff)
		if(user.faction_check_mob(L))
			return
	else
		if(target == user)
			return
	Special(user, target)

/obj/item/ego_weapon/black_silence_gloves/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	exchange_armaments(user)

// Radial menu
/obj/item/ego_weapon/black_silence_gloves/proc/exchange_armaments(mob/user)
	if(exchange_cooldown > world.time)
		to_chat(user, span_notice("Your gloves are still recharging, keep hitting enemies to charge it faster."))
		return

	var/list/display_names = list()
	var/list/armament_icons = list()
	for(var/arms in typesof(/obj/item/ego_weapon/black_silence_gloves))
		var/obj/item/ego_weapon/black_silence_gloves/armstype = arms
		if(initial(armstype)) // Changes icon based on furioso unlocks
			display_names[initial(armstype.name)] = armstype
			if(initial(armstype.name) in unlocked_list)
				armament_icons += list(initial(armstype.name) = image(icon = initial(armstype.icon), icon_state = initial(armstype.icon_state)))
			else if(initial(armstype.name) == origin_name && !(unlocked))
				armament_icons += list(initial(armstype.name) = image(icon = initial(armstype.icon), icon_state = initial(armstype.icon_state)))
			else
				armament_icons += list(initial(armstype.name) = image(icon = initial(armstype.icon), icon_state = initial(armstype.locked_state)))

	armament_icons = sortList(armament_icons)
	var/choice = show_radial_menu(user, src , armament_icons, custom_check = CALLBACK(src, PROC_REF(check_menu), user), radius = 42, require_near = TRUE)
	if(!choice || !check_menu(user))
		return

	var/picked = display_names[choice] // This needs to be on a separate var as list member access is not allowed for new
	var/obj/item/ego_weapon/black_silence_gloves/selected_armament = new picked(user.drop_location())

	if(selected_armament) // I'm sorry if this is confusing, it checks if you've already used this weapon and transfers variables
		var/obj/item/ego_weapon/black_silence_gloves/Y = selected_armament
		Y.unlocked_list = unlocked_list
		if(!(Y.name in unlocked_list) && Y.name != origin_name)
			Y.unlocked_list += Y.name
			addtimer(CALLBACK(Y, PROC_REF(furioso_reset)), furioso_wait)
			Y.furioso_time = world.time + furioso_wait
		else
			var/time_left = max((furioso_time - world.time), 0)
			addtimer(CALLBACK(Y, PROC_REF(furioso_reset)), time_left)
			Y.furioso_time = world.time + time_left
		Y.iff = iff
		qdel(src)
		user.put_in_hands(Y)
		if(!(unlocked) && Y.unlocked_list.len > 8)
			playsound(playsound(user, 'sound/weapons/black_silence/unlock.ogg', 100, 1))
			to_chat(user,span_userdanger("You are ready to unleash Furioso!"))
			Y.unlocked = TRUE
		if(unlocked)
			Y.unlocked = TRUE
			playsound(user, 'sound/weapons/black_silence/snap.ogg', 50, 1)
		else
			playsound(user, 'sound/weapons/black_silence/snap.ogg', 50, 1)
		Y.exchange_cooldown = world.time + exchange_cooldown_time

/obj/item/ego_weapon/black_silence_gloves/proc/furioso_reset()
	unlocked = FALSE
	unlocked_list = list()

// check_menu: Checks if we are allowed to interact with a radial menu
/obj/item/ego_weapon/black_silence_gloves/proc/check_menu(mob/user)
	if(!istype(user))
		return FALSE
	if(QDELETED(src))
		return FALSE
	if(user.incapacitated() || !user.is_holding(src))
		return FALSE
	return TRUE

// Refrain from putting things here since it will fuck up every other black silence weapon
/obj/item/ego_weapon/black_silence_gloves/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	..()

/obj/item/ego_weapon/black_silence_gloves/proc/Special(mob/living/user, atom/target)
	exchange_cooldown = 0 //Just to make sure they're not stuck in glove form if they accidentally press it
	if(isliving(target))
		if(unlocked_list.len > 8)
			furioso(user, target)
		else
			to_chat(user,span_userdanger("You haven't used all of Black Silence's Weapons!"))

// switching weapon increases damage dealt. Annoying but high damage, you're supposed to keep changing weapons anyway
/obj/item/ego_weapon/black_silence_gloves/zelkova
	name = "Zelkova Workshop"
	desc = "Mace and Axe once belonged to the Black Silence."
	special = "SHIFT+CLICK to attack with mace. Simultaneously switching your attacks will increase attack speed. Resets if you fail to do so"
	icon_state = "zelkova"

	special_cooldown_time = 12
	force = 90
	var/weapon
	var/reduction = 0
	var/special_check = FALSE
	locked_state = "zelkova_locked"

/obj/item/ego_weapon/black_silence_gloves/zelkova/Special(mob/living/user, atom/target)
	if(get_dist(src, target) <= 1)
		attack_verb_continuous = list("smashes", "smacks", "bashes")
		attack_verb_simple = list("smash", "smacks", "bashes")
		hitsound = 'sound/weapons/black_silence/mace.ogg'
		special_cooldown = world.time + special_cooldown_time
		special_check = TRUE
		if(weapon == 1)
			reduction += 0.1
			attack_speed = 1.2 - (min(reduction, 0.7))
		else
			reduction = 0
			attack_speed = 1.2
		attack(target, user)

/obj/item/ego_weapon/black_silence_gloves/zelkova/attack(mob/living/M, mob/living/user)
	if(!(special_check))
		attack_verb_continuous = list("slashes", "cuts", "slices")
		attack_verb_simple = list("slash", "cut", "slice")
		hitsound = 'sound/weapons/black_silence/axe.ogg'
		special_cooldown = world.time + special_cooldown_time
		attack_speed = 1.2
		if(weapon == 2)
			reduction += 0.1
			special_cooldown = special_cooldown - (min((reduction*10), 7))
		else
			reduction = 0
	..()
	if(reduction > 0.4)
		exchange_cooldown -= 50
	else
		exchange_cooldown -= 20
	// checks which attack used
	if(special_check)
		special_check = FALSE
		weapon = 2
	else
		weapon = 1

// literally unga bunga, loland's 3 dice. Adding dot (bleed) seems meh anyways
/obj/item/ego_weapon/black_silence_gloves/ranga
	name = "Ranga Workshop"
	desc = "Shortsword and Gauntlets once belonged to the Black Silence."
	special = "SHIFT+CLICK to perform 3 consecutive dash attacks on the enemy. Successful attacks reduces the dash cooldown"
	icon_state = "ranga"
	attack_speed = 0.3
	force = 25
	attack_verb_continuous = list("stabs", "maims", "claws", "slices", "pummels", "mutilates")
	attack_verb_simple = list("stab", "maim", "claw", "slice", "pummel", "mutilate")
	special_cooldown_time = 150
	var/dash_count = 0
	locked_state = "ranga_locked"

/obj/item/ego_weapon/black_silence_gloves/ranga/Special(mob/living/user, atom/target)
	if(!(isliving(target)))
		return
	special_cooldown = world.time + special_cooldown_time
	dash_attack(user, target)

/obj/item/ego_weapon/black_silence_gloves/ranga/proc/dash_attack(mob/living/user, atom/target)
	user.dir = get_dir(user, target)
	var/turf/target_turf = get_step(get_turf(target), get_dir(src, target))
	dash(user, target_turf)
	var/mob/living/L = target
	var/turf/F = get_turf(L)
	new /obj/effect/temp_visual/smash_effect(F)
	L.apply_damage(80, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))
	exchange_cooldown -= 20
	switch(dash_count)
		if(0)
			playsound(user, 'sound/weapons/black_silence/mace.ogg', 80, 1)
			dash_count += 1
			addtimer(CALLBACK(src, PROC_REF(dash_attack), user, target), 3)
		if(1)
			playsound(user, 'sound/weapons/black_silence/axe.ogg', 80, 1)
			dash_count += 1
			addtimer(CALLBACK(src, PROC_REF(dash_attack), user, target), 3)
		if(2)
			playsound(user, 'sound/weapons/black_silence/shortsword.ogg', 90, 1)
			dash_count = 0

/obj/item/ego_weapon/black_silence_gloves/ranga/attack(mob/living/M, mob/living/user)
	var/sfx = pick(1, 2, 3)
	switch(sfx)
		if(1)
			hitsound = 'sound/weapons/black_silence/mace.ogg'
		if(2)
			hitsound = 'sound/weapons/black_silence/axe.ogg'
		if(3)
			hitsound = 'sound/weapons/black_silence/shortsword.ogg'
	..()
	special_cooldown -= 10
	exchange_cooldown -= 10

// parry increases attack (block dice)
/obj/item/ego_weapon/black_silence_gloves/old_boys
	name = "Old Boys Workshop"
	desc = "Hammer once belonged to the Black Silence."
	special = "SHIFT+CLICK to parry attacks and reduce damage. Successful parries increases next damage dealt"
	icon_state = "old_boys"
	attack_verb_continuous = list("smashes", "smacks", "bashes")
	attack_verb_simple = list("smash", "smacks", "bashes")
	hitsound = 'sound/weapons/black_silence/mace.ogg'
	force = 80 // parry weapon
	attack_speed = 1
	var/block = 0
	var/block_success
	var/parry_buff = FALSE
	var/buff_check = FALSE // make sure you only get the buff once each parry
	var/list/reductions = list(90, 90, 100, 90)
	locked_state = "old_boys_locked"

/obj/item/ego_weapon/black_silence_gloves/old_boys/Special(mob/living/user, atom/target)
	if (block == 0)
		var/mob/living/carbon/human/shield_user = user
		if(shield_user.physiology.armor.bomb) //"We have NOTHING that should be modifying this, so I'm using it as an existant parry checker." - Ancientcoders
			to_chat(shield_user,span_warning("You're still off-balance!"))
			return FALSE
		for(var/obj/machinery/computer/abnormality/AC in range(1, shield_user))
			if(AC.datum_reference.working) // No blocking during work.
				to_chat(shield_user,span_notice("You cannot defend yourself from responsibility!"))
				return FALSE
		block = TRUE
		block_success = FALSE
		shield_user.physiology.armor = shield_user.physiology.armor.modifyRating(bomb = 1) //bomb defense must be over 0
		shield_user.physiology.red_mod *= max(0.001, (1 - ((reductions[1]) / 100)))
		shield_user.physiology.white_mod *= max(0.001, (1 - ((reductions[2]) / 100)))
		shield_user.physiology.black_mod *= max(0.001, (1 - ((reductions[3]) / 100)))
		shield_user.physiology.pale_mod *= max(0.001, (1 - ((reductions[4]) / 100)))
		RegisterSignal(user, COMSIG_MOB_APPLY_DAMGE, PROC_REF(AnnounceBlock))
		addtimer(CALLBACK(src, PROC_REF(DisableBlock), shield_user), 1 SECONDS)
		to_chat(user, span_userdanger("You attempt to parry the attack!"))
		return TRUE

/obj/item/ego_weapon/black_silence_gloves/old_boys/proc/DisableBlock(mob/living/carbon/human/user)
	user.physiology.armor = user.physiology.armor.modifyRating(bomb = -1)
	user.physiology.red_mod /= max(0.001, (1 - ((reductions[1]) / 100)))
	user.physiology.white_mod /= max(0.001, (1 - ((reductions[2]) / 100)))
	user.physiology.black_mod /= max(0.001, (1 - ((reductions[3]) / 100)))
	user.physiology.pale_mod /= max(0.001, (1 - ((reductions[4]) / 100)))
	UnregisterSignal(user, COMSIG_MOB_APPLY_DAMGE)
	buff_check = FALSE
	addtimer(CALLBACK(src, PROC_REF(BlockCooldown), user), 3 SECONDS)
	if (!block_success)
		BlockFail(user)

/obj/item/ego_weapon/black_silence_gloves/old_boys/proc/BlockCooldown(mob/living/carbon/human/user)
	block = FALSE
	to_chat(user,span_nicegreen("You rearm your hammer"))

/obj/item/ego_weapon/black_silence_gloves/old_boys/proc/BlockFail(mob/living/carbon/human/user)
	to_chat(user,span_warning("Your stance is widened."))
	force = 50
	addtimer(CALLBACK(src, PROC_REF(RemoveDebuff), user), 2 SECONDS)

/obj/item/ego_weapon/black_silence_gloves/old_boys/proc/RemoveDebuff(mob/living/carbon/human/user)
	to_chat(user,span_nicegreen("You recollect your stance."))
	force = 80

/obj/item/ego_weapon/black_silence_gloves/old_boys/proc/AnnounceBlock(mob/living/carbon/human/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	block_success = TRUE

	playsound(get_turf(src), 'sound/weapons/black_silence/guard.ogg', 50, 0, 7)
	source.visible_message(span_userdanger("[source.real_name] parried the attack!"))
	exchange_cooldown -= 100
	if(!(buff_check))
		parry_buff = TRUE

/obj/item/ego_weapon/black_silence_gloves/old_boys/attack(mob/living/M, mob/living/user)
	if(parry_buff)
		force = 130
		hitsound = 'sound/weapons/black_silence/greatsword.ogg'
		exchange_cooldown -= 50
	..()
	if(parry_buff)
		var/atom/throw_target = get_edge_target_turf(M, user.dir)
		if(!M.anchored)
			var/whack_speed = (prob(60) ? 1 : 4)
			M.throw_at(throw_target, rand(1, 2), whack_speed, user)
		force = 80
		hitsound = 'sound/weapons/black_silence/mace.ogg'
		parry_buff = FALSE
	else
		exchange_cooldown -= 20

// mid ranged support (damage buffer)
/obj/item/ego_weapon/black_silence_gloves/allas
	name = "Allas Workshop"
	desc = "Spear once belonged to the Black Silence."
	special = "SHIFT+CLICK to dash to the enemy. The further you are, the higher the dash damage. On hit, increases targets vulnerability to BLACK DAMAGE"
	icon_state = "allas"
	attack_verb_continuous = list("pokes", "jabs", "pierces", "gores")
	attack_verb_simple = list("poke", "jab", "pierce", "gore")
	force = 70
	reach = 2
	attack_speed = 1.2
	special_cooldown_time = 50
	hitsound = 'sound/weapons/ego/spear1.ogg'
	locked_state = "allas_locked"

/obj/item/ego_weapon/black_silence_gloves/allas/Special(mob/living/user, atom/target)
	var/list/line_turfs = list(get_turf(user))
	if(!(isliving(target)))
		return
	special_cooldown = world.time + special_cooldown_time
	var/turf/target_turf = get_step(get_turf(target), get_dir(target, src))
	target_turf = get_step(target_turf, get_dir(target_turf, src))
	dash(user, target_turf)
	for(var/turf/T in getline(user, target_turf))
		line_turfs += T
	force = 70 + (5*min(line_turfs.len, 8))
	hitsound = 'sound/weapons/black_silence/duelsword_strong.ogg'
	exchange_cooldown -= 80
	attack(target, user)

/obj/item/ego_weapon/black_silence_gloves/allas/attack(mob/living/M, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	exchange_cooldown -= 20
	force = 70
	hitsound = 'sound/weapons/ego/spear1.ogg'
	if(isliving(M))
		var/mob/living/simple_animal/target = M
		if(!ishuman(target) && !target.has_status_effect(/datum/status_effect/rend_black))
			new /obj/effect/temp_visual/cult/sparks(get_turf(target))
			target.apply_status_effect(/datum/status_effect/rend_black)

// litrally just vergil, I don't even care
/obj/item/ego_weapon/black_silence_gloves/mook
	name = "Mook Workshop"
	desc = "LongSword once belonged to the Black Silence."
	special = "SHIFT+CLICK to perform judgm- air slash (has 3 stacks, resets to 3 each cooldown). Performing an attack between 1.8-2.2 seconds greatly increases damage."
	icon_state = "mook"
	force = 75
	attack_verb_continuous = list("attacks", "slashes", "cuts", "slices")
	attack_verb_simple = list("attack", "slash", "cut", "slice")
	hitsound = 'sound/weapons/ego/sword1.ogg'
	var/concentration_time
	var/concentration_wait = 23
	var/stacks = 3
	var/stacks_reset_time
	var/stacks_reset_wait = 100
	locked_state = "mook_locked"

/obj/item/ego_weapon/black_silence_gloves/mook/Special(mob/living/user, atom/target)
	if(stacks_reset_time <= world.time)
		stacks = 3
	if(stacks == 3)
		stacks_reset_time = world.time + stacks_reset_wait
	if(stacks > 0)
		stacks -= 1
		playsound(user, 'sound/weapons/black_silence/longsword_start.ogg', 50, 1)
		sleep(3)
		var/turf/T = get_turf(target)
		playsound(T, 'sound/weapons/black_silence/longsword_atk.ogg', 50, 1)
		for (var/i = 0; i < 3; i++)
			new /obj/effect/temp_visual/smash_effect(T)
			for(var/mob/living/L in user.HurtInTurf(T, list(), 50, BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE))
				exchange_cooldown -= 10
			sleep(0.25 SECONDS)

/obj/item/ego_weapon/black_silence_gloves/mook/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	concentration_time = concentration_time - world.time
	if(concentration_time > 0 && concentration_time < 5)
		force = 200
		hitsound = 'sound/weapons/black_silence/longsword_fin.ogg'
		exchange_cooldown -= 50
	else
		force = 75
		hitsound = 'sound/weapons/ego/sword1.ogg'
		exchange_cooldown -= 10
	..()
	concentration_time =  world.time + concentration_wait


// iff guns with shotgun as knockback
/obj/item/ego_weapon/black_silence_gloves/logic
	name = "Atelier Logic"
	desc = "Shotgun and dual revolvers once belonged to the Black Silence."
	special = "SHIFT+CLICK to shoot your shotgun, knocking back nearby enemies. On 2 successful bullet hits, the shotgun is instantly reloaded"
	icon_state = "logic"
	attack_verb_continuous = list("attacks", "smacks")
	attack_verb_simple = list("attack", "smack")
	special_cooldown_time = 70
	hitsound = 'sound/effects/hit_kick.ogg'
	var/combo_count = 0
	var/gun_cooldown
	var/gun_cooldown_time = 8
	var/aoe_length = 2
	var/aoe_width = 1
	locked_state = "logic_locked"

/obj/item/ego_weapon/black_silence_gloves/logic/Initialize()
	RegisterSignal(src, COMSIG_PROJECTILE_ON_HIT, PROC_REF(projectile_hit))
	..()

/obj/item/ego_weapon/black_silence_gloves/logic/Special(mob/living/user, atom/target)
	special_cooldown = world.time + special_cooldown_time
	var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
	var/turf/source_turf = get_turf(src)
	var/turf/area_of_effect = list()
	var/turf/middle_line
	switch(dir_to_target)
		if(EAST)
			middle_line = getline(get_step(source_turf, EAST), get_ranged_target_turf(source_turf, EAST, aoe_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, aoe_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, aoe_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(WEST)
			middle_line = getline(get_step(source_turf, WEST), get_ranged_target_turf(source_turf, WEST, aoe_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, aoe_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, aoe_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(SOUTH)
			middle_line = getline(get_step(source_turf, SOUTH), get_ranged_target_turf(source_turf, SOUTH, aoe_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, aoe_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, aoe_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
		if(NORTH)
			middle_line = getline(get_step(source_turf, NORTH), get_ranged_target_turf(source_turf, NORTH, aoe_length))
			for(var/turf/T in middle_line)
				if(T.density)
					break
				for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, aoe_width)))
					if (Y.density)
						break
					if (Y in area_of_effect)
						continue
					area_of_effect += Y
				for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, aoe_width)))
					if (U.density)
						break
					if (U in area_of_effect)
						continue
					area_of_effect += U
	playsound(user, 'sound/weapons/black_silence/shotgun.ogg', 75, 1)
	var/list/been_hit = list()
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	for(var/turf/T in area_of_effect)
		new /obj/effect/temp_visual/smash_effect(T)
		var/list/new_hits = user.HurtInTurf(T, been_hit, 100, BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE) - been_hit
		been_hit += new_hits
		for(var/mob/living/L in new_hits)
			if(!L.anchored)
				var/whack_speed = (prob(60) ? 1 : 4)
				L.throw_at(throw_target, 1, whack_speed, user)
			exchange_cooldown -= 30

/obj/item/ego_weapon/black_silence_gloves/logic/afterattack(atom/target, mob/living/user, proximity_flag, clickparams)
	if(!CanUseEgo(user))
		return
	if(!proximity_flag && gun_cooldown <= world.time)
		var/turf/proj_turf = user.loc
		if(!isturf(proj_turf))
			return
		var/bullet_type = /obj/projectile/ego_bullet/atelier_logic
		if(iff)
			bullet_type = /obj/projectile/ego_bullet/atelier_logic/iff
		var/obj/projectile/ego_bullet/atelier_logic/G = new bullet_type(proj_turf)
		G.fired_from = src //for signal check
		G.firer = user
		G.preparePixelProjectile(target, user, clickparams)
		G.fire()
		playsound(user, 'sound/weapons/black_silence/revolver.ogg', 60, 1)
		gun_cooldown = world.time + gun_cooldown_time
		return

/obj/item/ego_weapon/black_silence_gloves/logic/proc/projectile_hit(atom/fired_from, atom/movable/firer, atom/target, Angle)
	SIGNAL_HANDLER

	if(isliving(target))
		exchange_cooldown -= 10
		if(combo_count < 2 && special_cooldown > world.time)
			combo_count += 1
	if(combo_count > 1)
		special_cooldown = 0
		combo_count = 0

/obj/item/ego_weapon/black_silence_gloves/logic/exchange_armaments(mob/user)
	UnregisterSignal(src, COMSIG_PROJECTILE_ON_HIT)
	..()

/obj/item/ego_weapon/black_silence_gloves/logic/attack(mob/living/M, mob/living/user)
	..()
	exchange_cooldown -= 20 //freebie in case you hit with melee

/obj/projectile/ego_bullet/atelier_logic
	name = "atelier logic"
	damage = 80
	speed = 0.3
	icon_state = "logic"
	damage_type = BLACK_DAMAGE


/obj/projectile/ego_bullet/atelier_logic/iff
	nodamage = TRUE
	projectile_piercing = PASSMOB

/obj/projectile/ego_bullet/atelier_logic/iff/on_hit(atom/target, blocked = FALSE)
	if(!ishuman(target))
		nodamage = FALSE
	else
		return
	..()
	if(!ishuman(target))
		qdel(src)

// builds up power each hit
/obj/item/ego_weapon/black_silence_gloves/durandal
	name = "Durandal"
	desc = "It has been, it still is, faithful to me..."
	special = "SHIFT+CLICK to perform a finisher attack. Successful attacks increase this weapon's power up to 10 times."
	icon_state = "durandal"
	attack_verb_continuous = list("attacks", "slashes", "cuts", "slices")
	attack_verb_simple = list("attack", "slash", "cut", "slice")
	attack_speed = 1.5
	force = 80 //this is just for breaking objects
	special_cooldown_time = 30 SECONDS
	hitsound = 'sound/weapons/black_silence/durandal_up.ogg'
	var/finisher = FALSE
	var/combo_count = 0
	var/combo_time
	var/combo_wait = 50
	locked_state = "durandal_locked"

/obj/item/ego_weapon/black_silence_gloves/durandal/Special(mob/living/user, atom/target)
	if(isliving(target) && get_dist(src, target) <= 1)
		special_cooldown = world.time + special_cooldown_time
		finisher = TRUE
		attack(target, user)

/obj/item/ego_weapon/black_silence_gloves/durandal/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(combo_time <= world.time)
		combo_count = 0
	if(finisher)
		force = 100 + (40*combo_count)
		exchange_cooldown -= (30*combo_count)
		hitsound = 'sound/weapons/black_silence/durandal_strong.ogg'
		var/turf/T = get_turf(M)
		new /obj/effect/temp_visual/smash_effect(T)
	else
		force = 80 + (5*combo_count)
		exchange_cooldown -= 10
		hitsound = 'sound/weapons/black_silence/durandal_up.ogg'
	..()
	combo_count += 1
	if(combo_count > 10)
		combo_count = 10
	combo_time = world.time + combo_wait
	finisher = FALSE

// basically burst hit and run (evade dice lmao)
/obj/item/ego_weapon/black_silence_gloves/crystal
	name = "Crystal Atelier"
	desc = "Dual Swords once belonged to the Black Silence."
	special = "SHIFT+CLICK to perform 2 consecutive dash attacks on the enemy. Finishing a combo allows you to perform a dodge"
	icon_state = "crystal"
	attack_verb_continuous = list("attacks", "slashes", "cuts", "slices")
	attack_verb_simple = list("attack", "slash", "cut", "slice")
	force = 50
	hitsound = 'sound/weapons/ego/sword1.ogg'
	var/dash_count = 0
	var/combo = 0
	var/combo_time
	var/combo_wait = 20
	var/dash_cooldown
	var/dash_cooldown_time = 80
	var/evade_time
	var/evade_wait = 20
	var/evade_range = 5
	locked_state = "crystal_locked"

/obj/item/ego_weapon/black_silence_gloves/crystal/Special(mob/living/user, atom/target)
	if(isliving(target) && dash_cooldown <= world.time)
		dash_cooldown = world.time + dash_cooldown_time
		dash_attack(user, target)
		return
	if(evade_time > world.time)
		evade_time = 0
		var/turf/target_turf = get_turf(user)
		var/list/line_turfs = list(target_turf)
		for(var/turf/T in getline(user, get_ranged_target_turf_direct(user, target, evade_range)))
			if(T.density)
				break
			target_turf = T
			line_turfs += T
		user.dir = get_dir(user, target)
		user.forceMove(target_turf)
		// "Movement" effect
		for(var/i = 1 to line_turfs.len)
			var/turf/T = line_turfs[i]
			if(!istype(T))
				continue
			var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(T, user)
			D.alpha = min(150 + i*15, 255)
			animate(D, alpha = 0, time = 2 + i*2)
			playsound(user, 'sound/weapons/black_silence/evasion.ogg', 50, 1)

/obj/item/ego_weapon/black_silence_gloves/crystal/proc/dash_attack(mob/living/user, atom/target)
	user.dir = get_dir(user, target)
	var/turf/target_turf = get_step(get_turf(target), get_dir(src, target))
	var/mob/living/L = target
	var/turf/F = get_turf(L)
	dash(user, target_turf)
	playsound(user, 'sound/weapons/black_silence/duelsword.ogg', 50, 1)
	if(dash_count < 1)
		L.apply_damage(60, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))
		addtimer(CALLBACK(src, PROC_REF(dash_attack), user, target), 5)
		new /obj/effect/temp_visual/smash_effect(F)
		dash_count += 1
	else
		L.apply_damage(100, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE))
		new /obj/effect/temp_visual/smash_effect(F)
		exchange_cooldown -= 30
		dash_count = 0

/obj/item/ego_weapon/black_silence_gloves/crystal/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time)
		combo = 0
	combo_time = world.time + combo_wait
	switch(combo)
		if(4)
			hitsound = 'sound/weapons/black_silence/duelsword_strong.ogg'
			force *= 6
			combo = 0
			evade_time = world.time + evade_wait
			user.changeNext_move(CLICK_CD_MELEE * 5)
			var/turf/F = get_turf(M)
			new /obj/effect/temp_visual/smash_effect(F)
			exchange_cooldown -= 100
		if(1, 3)
			user.changeNext_move(CLICK_CD_MELEE * 0.5)
			exchange_cooldown -= 10
		else
			hitsound = 'sound/weapons/ego/sword1.ogg'
			user.changeNext_move(CLICK_CD_MELEE * 0.1)
			exchange_cooldown -= 10
	..()
	combo += 1
	force = initial(force)

// basic weapon with big damage and aoe
/obj/item/ego_weapon/black_silence_gloves/wheels
	name = "Wheels Industry"
	desc = "Greatsword once belonged to the Black Silence."
	special = "SHIFT+CLICK to perform a giant AoE attack."
	icon_state = "wheels"
	attack_verb_continuous = list("attacks", "smashes", "cleaves", "slashes")
	attack_verb_simple = list("attack", "smash", "cleave", "slash")
	attack_speed = 2
	force = 100
	hitsound = 'sound/weapons/ego/twilight.ogg'
	special_cooldown_time = 5 SECONDS
	var/aoe_length = 4
	var/aoe_width = 2
	locked_state = "wheels_locked"

/obj/item/ego_weapon/black_silence_gloves/wheels/Special(mob/living/user, atom/target)
	special_cooldown = world.time + special_cooldown_time
	if(do_after(user, 10, target))
		var/dir_to_target = get_cardinal_dir(get_turf(src), get_turf(target))
		var/turf/source_turf = get_turf(src)
		var/turf/area_of_effect = list()
		var/turf/middle_line = list()
		switch(dir_to_target)
			if(EAST)
				middle_line = getline(source_turf, get_ranged_target_turf(source_turf, EAST, aoe_length))
				for(var/turf/T in middle_line)
					if(T.density)
						break
					for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, aoe_width)))
						if (Y.density)
							break
						if (Y in area_of_effect)
							continue
						area_of_effect += Y
					for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, aoe_width)))
						if (U.density)
							break
						if (U in area_of_effect)
							continue
						area_of_effect += U
			if(WEST)
				middle_line = getline(source_turf, get_ranged_target_turf(source_turf, WEST, aoe_length))
				for(var/turf/T in middle_line)
					if(T.density)
						break
					for(var/turf/Y in getline(T, get_ranged_target_turf(T, NORTH, aoe_width)))
						if (Y.density)
							break
						if (Y in area_of_effect)
							continue
						area_of_effect += Y
					for(var/turf/U in getline(T, get_ranged_target_turf(T, SOUTH, aoe_width)))
						if (U.density)
							break
						if (U in area_of_effect)
							continue
						area_of_effect += U
			if(SOUTH)
				middle_line = getline(source_turf, get_ranged_target_turf(source_turf, SOUTH, aoe_length))
				for(var/turf/T in middle_line)
					if(T.density)
						break
					for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, aoe_width)))
						if (Y.density)
							break
						if (Y in area_of_effect)
							continue
						area_of_effect += Y
					for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, aoe_width)))
						if (U.density)
							break
						if (U in area_of_effect)
							continue
						area_of_effect += U
			if(NORTH)
				middle_line = getline(source_turf, get_ranged_target_turf(source_turf, NORTH, aoe_length))
				for(var/turf/T in middle_line)
					if(T.density)
						break
					for(var/turf/Y in getline(T, get_ranged_target_turf(T, EAST, aoe_width)))
						if (Y.density)
							break
						if (Y in area_of_effect)
							continue
						area_of_effect += Y
					for(var/turf/U in getline(T, get_ranged_target_turf(T, WEST, aoe_width)))
						if (U.density)
							break
						if (U in area_of_effect)
							continue
						area_of_effect += U
		playsound(user, 'sound/weapons/black_silence/greatsword.ogg', 75, 1)
		var/list/been_hit = list()
		for(var/turf/T in area_of_effect)
			new /obj/effect/temp_visual/smash_effect(T)
			var/list/new_hits = user.HurtInTurf(T, been_hit, 300, BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE) - been_hit
			been_hit += new_hits
			for(var/mob/living/L in new_hits)
				var/atom/throw_target = get_edge_target_turf(target, get_dir(user, L))
				if(iff)
					if(user.faction_check_mob(L))
						continue
				else
					if(L == user)
						continue
				if(L in been_hit)
					continue
				if(!L.anchored)
					var/whack_speed = (prob(60) ? 1 : 4)
					L.throw_at(throw_target, 2, whack_speed, user)
				exchange_cooldown -= 50
	else
		to_chat(user, "<span class='spider'><b>Your attack was interrupted!</b></span>")
		special_cooldown = 0
		return

/obj/item/ego_weapon/black_silence_gloves/wheels/attack(mob/living/M, mob/living/user)
	..()
	var/atom/throw_target = get_edge_target_turf(M, user.dir)
	if(!M.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		M.throw_at(throw_target, rand(1, 2), whack_speed, user)
	exchange_cooldown -= 50

/obj/item/ego_weapon/black_silence_gloves/proc/furioso(mob/living/user, mob/living/target)
	special_cooldown = world.time + 500 SECONDS //This just prevents spam click, you will change weapon anyways
	furioso_start(user, target)
	var/mob/living/L = target
	var/turf/target_turf
	var/turf/T
	var/i

	//Dual Revolver
	icon_state = "logic"
	for(i = 0, i < 2, i++)
		T = get_turf(target)
		new /obj/effect/temp_visual/smash_effect(T)
		target_turf = get_step(get_turf(target), get_dir(user, target))
		if(!target.anchored)
			target.Move(target_turf)
		playsound(user, 'sound/weapons/black_silence/revolver.ogg', 100, 1)
		sleep(3.5)
	//Spear
	icon_state = "allas"
	target_turf = get_step(get_turf(target), get_dir(user, target))
	dash(user, target_turf)
	T = get_turf(target)
	new /obj/effect/temp_visual/smash_effect(T)
	playsound(user, 'sound/weapons/black_silence/duelsword_strong.ogg', 100, 1)
	sleep(2)

	//Hammer
	icon_state = "old_boys"
	user.dir = get_dir(user, target)
	playsound(user, 'sound/weapons/black_silence/mace.ogg', 100, 1)
	target_turf = get_step(get_turf(target), get_dir(user, target))
	new /obj/effect/temp_visual/smash_effect(T)
	if(!target.anchored)
		target.Move(target_turf)
	sleep(4)
	//LongSword
	icon_state = "mook"
	playsound(user, 'sound/weapons/black_silence/longsword_start.ogg', 100, 1)
	sleep(1.5)
	T = get_turf(target)
	playsound(T, 'sound/weapons/black_silence/longsword_atk.ogg', 100, 1)
	for (i = 0; i < 3; i++)
		new /obj/effect/temp_visual/smash_effect(T)
		sleep(1.25)

	//Gauntlets & Shortsword
	icon_state = "ranga"
	for(i = 0, i <= 2, i++)
		user.dir = get_dir(user, target)
		target_turf = get_step(get_turf(target), get_dir(user, target))
		dash(user, target_turf)
		T = get_turf(target)
		new /obj/effect/temp_visual/smash_effect(T)
		if(i == 0)
			playsound(user, 'sound/weapons/black_silence/mace.ogg', 100, 1)
			sleep(1)
		if(i == 1)
			playsound(user, 'sound/weapons/black_silence/axe.ogg', 100, 1)
			sleep(1)
		if(i == 2)
			playsound(user, 'sound/weapons/black_silence/shortsword.ogg', 100, 1)
			sleep(3)
	//Mace & Axe
	icon_state = "zelkova"
	user.dir = get_dir(user, target)
	playsound(user, 'sound/weapons/black_silence/axe.ogg', 100, 1)
	new /obj/effect/temp_visual/smash_effect(T)
	sleep(3)
	playsound(user, 'sound/weapons/black_silence/mace.ogg', 100, 1)
	new /obj/effect/temp_visual/smash_effect(T)
	sleep(3)

	//Greatsword
	icon_state = "wheels"
	target_turf = get_step(get_turf(target), get_dir(user, target))
	playsound(user, 'sound/weapons/black_silence/greatsword.ogg', 100, 1)
	new /obj/effect/temp_visual/smash_effect(T)
	if(!target.anchored)
		target.Move(target_turf)
	sleep(5)

	//Dual Swords
	icon_state = "crystal"
	target_turf = get_step(get_turf(target), get_dir(user, target))
	dash(user, target_turf)
	T = get_turf(target)
	new /obj/effect/temp_visual/smash_effect(T)
	playsound(user, 'sound/weapons/black_silence/duelsword_strong.ogg', 100, 1)
	sleep(4)

	//Shotgun
	icon_state = "logic"
	user.dir = get_dir(user, target)
	new /obj/effect/temp_visual/smash_effect(T)
	playsound(user, 'sound/weapons/black_silence/shotgun.ogg', 100, 1)
	target_turf = get_step(get_turf(target), get_dir(user, target))
	target_turf = get_step(target_turf, get_dir(user, target))
	target_turf = get_step(target_turf, get_dir(user, target))
	if(!target.anchored)
		target.Move(target_turf)
	sleep(4)
	//Durandal
	icon_state = "durandal"
	target_turf = get_step(get_turf(target), get_dir(target, user))
	dash(user, target_turf)
	playsound(user, 'sound/weapons/black_silence/durandal_down.ogg', 100, 1)
	T = get_turf(target)
	new /obj/effect/temp_visual/smash_effect(T)
	sleep(3.5)
	target_turf = get_step(get_turf(target), get_dir(user, target))
	dash(user, target_turf)
	playsound(user, 'sound/weapons/black_silence/durandal_up.ogg', 100, 1)
	new /obj/effect/temp_visual/smash_effect(T)
	sleep(3.5)
	user.dir = get_dir(user, target)
	target_turf = get_step(get_turf(target), get_dir(user, target))
	playsound(user, 'sound/weapons/black_silence/durandal_strong.ogg', 100, 1)
	T = get_turf(target)
	new /obj/effect/temp_visual/smash_effect(T)
	if(!target.anchored)
		target.Move(target_turf)
	L.apply_damage(1500, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE)) //this went on for 5 sec, so 300 DPS as the final attack
	sleep(10)

	furioso_end(user, target)

/obj/item/ego_weapon/black_silence_gloves/proc/furioso_start(mob/living/user, mob/living/target)
	ADD_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
	user.status_flags |= GODMODE
	user.Stun(60 SECONDS, ignore_canstun = TRUE)
	target.Stun(60 SECONDS, ignore_canstun = TRUE)
	ADD_TRAIT(target, TRAIT_MUTE, TIMESTOP_TRAIT)
	walk(target, 0) //stops them mid pathing even if they're stunimmune
	if(isanimal(target))
		var/mob/living/simple_animal/S = target
		S.toggle_ai(AI_OFF)
	if(ishostile(target))
		var/mob/living/simple_animal/hostile/H = target
		H.LoseTarget()
	user.anchored = TRUE

/obj/item/ego_weapon/black_silence_gloves/proc/furioso_end(mob/living/user, mob/living/target)
	user.status_flags &= ~GODMODE
	user.AdjustStun(-60 SECONDS, ignore_canstun = TRUE)
	target.AdjustStun(-60 SECONDS, ignore_canstun = TRUE)
	REMOVE_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
	REMOVE_TRAIT(target, TRAIT_MUTE, TIMESTOP_TRAIT)
	if(isanimal(target))
		var/mob/living/simple_animal/S = target
		S.toggle_ai(initial(S.AIStatus))
	user.anchored = FALSE
	icon_state = "gloves"
	hitsound = 'sound/effects/hit_punch.ogg'
	special_cooldown = 0
	exchange_cooldown = 0
	unlocked = FALSE
	unlocked_list = list()
