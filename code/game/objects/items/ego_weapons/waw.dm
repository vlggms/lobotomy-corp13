/obj/item/ego_weapon/lamp
	name = "lamp"
	desc = "Big Bird's eyes gained another in number for every creature it saved. \
	On this weapon, the radiant pride is apparent."
	special = "This weapon attacks all non-humans in an AOE. \
			This weapon deals double damage on direct attack."
	icon_state = "lamp"
	force = 25
	attack_speed = 1.3
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("slams", "attacks")
	attack_verb_simple = list("slam", "attack")
	hitsound = 'sound/weapons/ego/hammer.ogg'
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
	)

/obj/item/ego_weapon/lamp/attack(mob/living/M, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	for(var/mob/living/L in view(1, M))
		var/aoe = 25
		var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust/100
		aoe*=justicemod
		aoe*=force_multiplier
		if(L == user || ishuman(L))
			continue
		L.apply_damage(aoe, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(L))


/obj/item/ego_weapon/despair
	name = "sword sharpened with tears"
	desc = "A sword suitable for swift thrusts. \
	Even someone unskilled in dueling can rapidly puncture an enemy using this E.G.O with remarkable agility."
	special = "This weapon has a combo system. To turn off this combo system, use in hand. \
			This weapon has a fast attack speed"
	icon_state = "despair"
	force = 20
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("stabs", "attacks", "slashes")
	attack_verb_simple = list("stab", "attack", "slash")
	hitsound = 'sound/weapons/ego/rapier1.ogg'
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)
	var/combo = 0
	var/combo_time
	var/combo_wait = 10
	var/combo_on = TRUE

/obj/item/ego_weapon/despair/attack_self(mob/user)
	..()
	if(combo_on)
		to_chat(user,span_warning("You swap your grip, and will no longer perform a finisher."))
		combo_on = FALSE
		return
	if(!combo_on)
		to_chat(user,span_warning("You swap your grip, and will now perform a finisher."))
		combo_on =TRUE
		return

//This is like an anime character attacking like 4 times with the 4th one as a finisher attack.
/obj/item/ego_weapon/despair/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time || !combo_on)	//or you can turn if off I guess
		combo = 0
	combo_time = world.time + combo_wait
	if(combo==4)
		combo = 0
		user.changeNext_move(CLICK_CD_MELEE * 2)
		force *= 5	// Should actually keep up with normal damage.
		playsound(src, 'sound/weapons/fwoosh.ogg', 300, FALSE, 9)
		to_chat(user,span_warning("You are offbalance, you take a moment to reset your stance."))
	else
		user.changeNext_move(CLICK_CD_MELEE * 0.4)
	..()
	combo += 1
	force = initial(force)

/obj/item/ego_weapon/despair/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/nihil/spade))
		return
	new /obj/item/ego_weapon/shield/despair_nihil(get_turf(src))
	to_chat(user,span_warning("The [I] seems to drain all of the light away as it is absorbed into [src]!"))
	playsound(user, 'sound/abnormalities/nihil/filter.ogg', 15, FALSE, -3)
	qdel(I)
	qdel(src)

/obj/item/ego_weapon/totalitarianism
	name = "totalitarianism"
	desc = "When one is oppressed, sometimes they try to break free."
	special = "Use in hand to unlock its full power."
	icon_state = "totalitarianism"
	force = 80
	attack_speed = 3
	damtype = RED_DAMAGE
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleaves", "cuts")
	hitsound = 'sound/weapons/fixer/generic/finisher1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)
	var/charged = FALSE

/obj/item/ego_weapon/totalitarianism/attack(mob/living/M, mob/living/user)
	..()
	force = 80
	charged = FALSE

/obj/item/ego_weapon/totalitarianism/attack_self(mob/user)
	if(do_after(user, 12, src))
		charged = TRUE
		force = 120	//FULL POWER
		to_chat(user,span_warning("You put your strength behind this attack."))

/obj/item/ego_weapon/totalitarianism/get_clamped_volume()
	return 50

/obj/item/ego_weapon/oppression
	name = "oppression"
	desc = "Even light forms of contraint can be considered totalitarianism"
	special = "This weapon builds up charge on every hit. Use the weapon in hand to charge the blade."
	icon_state = "oppression"
	force = 13
	attack_speed = 0.3
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleaves", "cuts")
	hitsound = 'sound/weapons/fixer/generic/blade4.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)
	var/charged = FALSE
	var/meter = 0
	var/meter_counter = 1

/obj/item/ego_weapon/oppression/attack_self(mob/user)
	if (!charged)
		charged = TRUE
		to_chat(user,span_warning("You focus your energy, adding [meter] damage to your next attack."))
		force += meter
		meter = 0

/obj/item/ego_weapon/oppression/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	meter += meter_counter
	meter_counter += 1

	meter = min(meter, 60)
	..()
	if(charged == TRUE)
		charged = FALSE
		force = 15
		meter_counter = 0

/obj/item/ego_weapon/remorse
	name = "remorse"
	desc = "A hammer and nail, unwieldy and impractical against most. \
	Any crack, no matter how small, will be pried open by this E.G.O."
	special = "This weapon hits slower than usual."
	icon_state = "remorse"
	special = "Use this weapon in hand to change its mode. \
		The Nail mode marks targets for death. \
		The Hammer mode deals bonus damage to all marked."
	force = 30	//Does more damage later.
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("Smashes", "Pierces", "Cracks")
	attack_verb_simple = list("Smash", "Pierce", "Crack")
	hitsound = 'sound/weapons/ego/remorse.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
	var/list/targets = list()
	var/ranged_damage = 60	//Fuckload of white on ability. Be careful!
	var/mode = FALSE		//False for nail, true for hammer

/obj/item/ego_weapon/remorse/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return

	if(!mode)
		if(!(M in targets))
			targets+= M

	if(mode)
		if(M in targets)
			playsound(M, 'sound/weapons/fixer/generic/nail1.ogg', 100, FALSE, 4)
			M.apply_damage(ranged_damage, WHITE_DAMAGE, null, M.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
			new /obj/effect/temp_visual/remorse(get_turf(M))
			targets -= M
	..()

/obj/item/ego_weapon/remorse/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(mode)	//Turn to nail
		mode = FALSE
		to_chat(user,span_warning("You swap to nail mode, clearing all marks."))
		targets = list()
		return

	if(!mode)	//Turn to hammer
		mode = TRUE
		to_chat(user,span_warning("You swap to hammer mode."))
		return

/obj/item/ego_weapon/mini/crimson
	name = "crimson claw"
	desc = "It's more important to deliver a decisive strike in blind hatred without hesitation than to hold on to insecure courage."
	special = "Use it in hand to activate ranged attack."
	icon_state = "crimsonclaw"
	special = "This weapon hits faster than usual."
	force = 18
	attack_speed = 0.5
	damtype = RED_DAMAGE
	hitsound = 'sound/abnormalities/redhood/attack_1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

	var/combo = 1
	var/combo_time
	var/combo_wait = 20
	// "Throwing" attack
	var/special_attack = FALSE
	var/special_damage = 100
	var/special_cooldown
	var/special_cooldown_time = 8 SECONDS
	var/special_checks_faction = FALSE

/obj/item/ego_weapon/mini/crimson/get_clamped_volume() //this is loud as balls without this proc
	return 20

/obj/item/ego_weapon/mini/crimson/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time)
		combo = 1
	combo_time = world.time + combo_wait
	switch(combo)
		if(2)
			hitsound = 'sound/abnormalities/redhood/attack_2.ogg'
		if(3)
			hitsound = 'sound/abnormalities/redhood/attack_3.ogg'
		else
			hitsound = 'sound/abnormalities/redhood/attack_1.ogg'
	force *= (1 + (combo * 0.15))
	user.changeNext_move(CLICK_CD_MELEE * (1 + (combo * 0.2)))
	if(combo >= 3)
		combo = 0
	..()
	combo += 1
	force = initial(force)

/obj/item/ego_weapon/mini/crimson/attack_self(mob/living/user)
	if(!CanUseEgo(user))
		return
	if(special_cooldown > world.time)
		return
	special_attack = !special_attack
	if(special_attack)
		to_chat(user, span_notice("You prepare to throw [src]."))
	else
		to_chat(user, span_notice("You decide to not throw [src], for now."))

/obj/item/ego_weapon/mini/crimson/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user))
		return
	if(special_cooldown > world.time)
		return
	if(!special_attack)
		return
	special_attack = FALSE
	special_cooldown = world.time + special_cooldown_time
	var/turf/target_turf = get_ranged_target_turf_direct(user, A, 8)
	var/list/turfs_to_hit = list()
	for(var/turf/T in getline(user, target_turf))
		if(T.density)
			break
		if(locate(/obj/machinery/door) in T)
			continue
		turfs_to_hit += T
	if(!LAZYLEN(turfs_to_hit))
		return
	playsound(user, 'sound/abnormalities/redhood/throw.ogg', 75, TRUE, 3)
	user.visible_message(span_warning("[user] throws [src] towards [A]!"))
	var/dealing_damage = special_damage // Damage reduces a little with each mob hit
	dealing_damage*=force_multiplier
	for(var/i = 1 to turfs_to_hit.len) // Basically, I copied my code from helper's realized ability. Yep.
		var/turf/open/T = turfs_to_hit[i]
		if(!istype(T))
			continue
		// Effects
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(T, src)
		var/matrix/M = matrix(D.transform)
		M.Turn(45 * i)
		D.transform = M
		D.alpha = min(150 + i*15, 255)
		animate(D, alpha = 0, time = 2 + i*2)
		// Actual damage
		for(var/obj/structure/window/W in T)
			W.obj_destruction("[src.name]")
		for(var/mob/living/L in T)
			if(L == user)
				continue
			if(special_checks_faction && user.faction_check_mob(L))
				continue
			to_chat(L, span_userdanger("You are hit by [src]!"))
			L.apply_damage(dealing_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))
			dealing_damage = max(dealing_damage * 0.9, special_damage * 0.3)

/obj/item/ego_weapon/thirteen
	name = "dead silence"
	desc = "Time flows as life does, and life goes as time does."
	special = "This weapon deals an absurd amount of damage on the 13th hit."
	icon_state = "thirteen"
	force = 30
	damtype = PALE_DAMAGE
	attack_verb_continuous = list("cuts", "attacks", "slashes")
	attack_verb_simple = list("cut", "attack", "slash")
	hitsound = 'sound/weapons/rapierhit.ogg'
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)
	var/combo = 0
	var/combo_time
	var/combo_wait = 3 SECONDS

//On the 13th hit, Deals user justice x 2
/obj/item/ego_weapon/thirteen/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time)
		combo = 0
	combo_time = world.time + combo_wait
	if(combo >= 13)
		combo = 0
		force = get_modified_attribute_level(user, JUSTICE_ATTRIBUTE)
		new /obj/effect/temp_visual/thirteen(get_turf(M))
		playsound(src, 'sound/weapons/ego/price_of_silence.ogg', 25, FALSE, 9)
	..()
	combo += 1
	force = initial(force)


/obj/item/ego_weapon/stem
	name = "green stem"
	desc = "All personnel involved in the equipment's production wore heavy protection to prevent them from being influenced by the entity."
	special = "Wielding this weapon grants an immunity to the slowing effects of the princess's vines. \
				When used in hand 30 sanity will be consumed before channeling a 7 second vine burst that \
				will hit all hostiles in a 3 tile range around the user. If vine burst is used at 30% sanity the damage is \
				increased by 50% but will hit allies due to the intense hatred of F-04-42 influencing the user."
	icon_state = "green_stem"
	force = 32 //original 8-16
	reach = 2		//Has 2 Square Reach.
	attack_speed = 1.2
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	equip_sound = 'sound/creatures/venus_trap_hit.ogg'
	pickup_sound = 'sound/creatures/venus_trap_hurt.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 80
							)
	var/vine_cooldown

/obj/item/ego_weapon/stem/Initialize(mob/user)
	.=..()
	vine_cooldown = world.time

/obj/item/ego_weapon/stem/attack_self(mob/living/user)
	. = ..()
	if(!CanUseEgo(user))
		return
	if(vine_cooldown <= world.time)
		user.visible_message(span_notice("[user] stabs [src] into the ground."), span_nicegreen("You stab your [src] into the ground."))
		var/mob/living/carbon/human/L = user
		L.adjustSanityLoss(30)

		var/affected_mobs = 0
		for(var/i = 1 to 6)
			var/channel_level = (3 SECONDS) / i //Burst is 3 + 1.5 + 1 + 0.75 + 0.6 + 0.2 seconds for a total of 60-90 damage over a period of 7.05 seconds if you allow it to finish.
			vine_cooldown = world.time + channel_level + (1 SECONDS)
			if(!do_after(user, channel_level, target = user))
				to_chat(user, span_warning("Your vineburst is interrupted."))
				break
			for(var/mob/living/C in oview(3, get_turf(src)))
				var/vine_damage = 10
				vine_damage *=force_multiplier
				if(user.sanityhealth <= (user.maxSanity * 0.3))
					vine_damage *= 1.5
				else if(user.faction_check_mob(C))
					continue
				new /obj/effect/temp_visual/vinespike(get_turf(C))
				C.apply_damage(vine_damage, BLACK_DAMAGE, null, C.run_armor_check(null, BLACK_DAMAGE), spread_damage = FALSE)
				affected_mobs += 1
			playsound(loc, 'sound/creatures/venus_trap_hurt.ogg', min(75, affected_mobs * 15), TRUE, round( affected_mobs * 0.5))
		vine_cooldown = world.time + (3 SECONDS)

/obj/item/ego_weapon/ebony_stem
	name = "ebony stem"
	desc = "An apple does not culminate when it ripens to bright red; \
	only when the apple shrivels up and attracts lowly creatures."
	special = "This weapon has a ranged attack."
	icon_state = "ebony_stem"
	force = 35
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("admonishes", "rectifies", "conquers")
	attack_verb_simple = list("admonish", "rectify", "conquer")
	hitsound = 'sound/weapons/ego/rapier2.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
	var/ranged_cooldown
	var/ranged_cooldown_time = 1.2 SECONDS
	var/ranged_damage = 60

/obj/item/ego_weapon/ebony_stem/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(ranged_cooldown > world.time)
		to_chat(user, "<span class='warning'>Your ranged attack is still recharging!")
		return
	if(!CanUseEgo(user))
		return
	var/turf/target_turf = get_turf(A)
	if(!istype(target_turf))
		return
	if((get_dist(user, target_turf) < 2) || !(target_turf in view(10, user)))
		return
	..()
	ranged_cooldown = world.time + ranged_cooldown_time
	if(do_after(user, 5))
		var/damage_dealt = (ranged_damage * force_multiplier)
		playsound(target_turf, 'sound/abnormalities/ebonyqueen/attack.ogg', 50, TRUE)
		for(var/turf/open/T in RANGE_TURFS(1, target_turf))
			new /obj/effect/temp_visual/thornspike(T)
			user.HurtInTurf(T, list(), damage_dealt, BLACK_DAMAGE, hurt_mechs = TRUE)

/obj/item/ego_weapon/wings // Is this overcomplicated? Yes. But I'm finally happy with what I want to make of this weapon.
	name = "torn off wings"
	desc = "He stopped, gave a deep sigh, quickly tore from his shoulders the ribbon Marie had tied around him, \
		pressed it to his lips, put it on as a token, and, bravely brandishing his bare sword, \
		jumped as nimbly as a bird over the ledge of the cabinet to the floor."
	special = "This weapon has a unique combo system and attacks twice per click.\n \
		Press Z to do a spinning attack, and click on a distant target to dash towards them in a cardinal direction."
	icon_state = "wings"
	force = 10
	attack_speed = 0.6
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("slashes", "claws")
	attack_verb_simple = list("slashes", "claws")
	hitsound = 'sound/weapons/fixer/generic/dodge3.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60
							)
	var/hit_count = 0
	var/max_count = 16
	var/special_cost = 4
	var/special_force = 20
	var/special_combo = 0
	var/special_combo_mult = 0.2
	var/decay_time = 3 SECONDS
	var/combo_hold
	var/special_combo_hold
	var/special_cooldown = 3
	var/specialing = FALSE
	var/list/hit_turfs = list()

/obj/item/ego_weapon/wings/attack(mob/living/M, mob/living/user) // This part's simple, basically Oppression but with decay.
	if(!CanUseEgo(user))
		return
	if(world.time > combo_hold) // Your combo ended.
		hit_count = 0
	if(max_count > hit_count)
		hit_count++
	else if(prob(10))
		to_chat(user, span_notice("[src]' feathers bristle!")) // "Hey dumbass, you can stop smacking them now"
	combo_hold = world.time + decay_time
	..()
	INVOKE_ASYNC(src, PROC_REF(SecondSwing), M, user)
	return

/obj/item/ego_weapon/wings/attack_self(mob/user)
	. = ..()
	if(world.time > combo_hold && hit_count > 0)
		to_chat(user, span_notice("[src]' feathers fall still...")) // Notify you the combo's over
		hit_count = 0
	if(!(special_cost > hit_count) && !(specialing))
		specialing = TRUE
		combo_hold = world.time + decay_time
		hit_count -= special_cost
		if(special_combo < 4) // Special combo goes up to 5.
			special_combo++
		else if(prob(20)) // If your special combo is at max, you get some glory.
			user.visible_message(span_notice("[user] is moving like the wind!"))
		Pirouette(user)
		specialing = FALSE

/obj/item/ego_weapon/wings/afterattack(atom/A, mob/living/user, params) // Time for the ANIME BLADE DASH ATTACK
	if(world.time > combo_hold && hit_count > 0)
		to_chat(user, span_notice("[src]' feathers fall still..."))
		hit_count = 0
		return
	if(special_cost > hit_count || !CanUseEgo(user) || get_dist(get_turf(A), get_turf(user)) < 2 || specialing)
		return
	var/aim_dir = get_cardinal_dir(get_turf(user), get_turf(A)) // You can only anime dash in a cardinal direction.
	if(CheckPath(user, aim_dir))
		to_chat(user,span_notice("You need more room to do that!"))
	else
		user.visible_message(span_notice("[user] lunges forward, [src] dancing in their grasp!")) // ANIME AS FUCK
		playsound(src, hitsound, 75, FALSE, 4) // Might need a punchier sound, but none come to mind.
		hit_count -= special_cost
		combo_hold = world.time + decay_time // Specials continue the regular AND special combo.
		if(special_combo_hold > world.time)
			if(special_combo < 4)
				special_combo++
			else if(prob(20))
				user.visible_message(span_notice("[user] is moving like the wind!"))
		else
			special_combo = 1
		special_combo_hold = world.time + decay_time
		hit_turfs = list() // Clear the list of turfs we hit last time
		specialing = TRUE
		addtimer(CALLBACK(src, PROC_REF(ResetSpecial)), special_cooldown)// Engage special cooldown
		Leap(user, aim_dir, 0)
	return

/obj/item/ego_weapon/wings/proc/Pirouette(mob/living/user)
	user.visible_message(span_notice("[user] whirls in place, [src] flicking out at enemies!")) // You cool looking bitch
	playsound(src, hitsound, 75, FALSE, 4)
	for(var/turf/T in orange(1, user)) // Most of this code was jacked from Harvest tbh
		new /obj/effect/temp_visual/smash_effect(T)
	var/aoe = special_force * (1 + special_combo_mult * special_combo)
	var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
	var/justicemod = 1 + userjust/100
	aoe*=justicemod
	aoe*=force_multiplier
	for(var/mob/living/L in range(1, user))
		if(L == user) // Might remove FF immunity sometime
			continue
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(!H.sanity_lost)
				continue
		L.apply_damage(aoe, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
		L.visible_message(span_danger("[user] slices [L]!"))

/obj/item/ego_weapon/wings/proc/Leap(mob/living/user, dir = SOUTH, times_ran = 3)
	user.forceMove(get_step(get_turf(user), dir))
	var/end_leap = FALSE
	if(times_ran > 2)
		end_leap = TRUE
	if(CheckPath(user, dir)) // If we have something ahead of us, yes, but we're ALSO going to attack around us
		to_chat(user,span_notice("You cut your leap short!"))
		for(var/turf/T in orange(1, user)) // I hate having to use this code twice but it's TWO LINES and I don't need to use callbacks with it so it's not getting a proc
			hit_turfs |= T
		end_leap = TRUE
	if(end_leap)
		for(var/turf/T in hit_turfs) // Once again mostly jacked from harvest, but modified to work with hit_turfs instead of an on-the-spot orange
			new /obj/effect/temp_visual/smash_effect(T)
			for(var/mob/living/L in T.contents)
				var/aoe = special_force * 1 + (special_combo_mult * special_combo)
				var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
				var/justicemod = 1 + userjust/100
				aoe*=justicemod
				aoe*=force_multiplier
				if(L == user)
					continue
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					if(!H.sanity_lost)
						continue
				L.apply_damage(aoe, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
				L.visible_message(span_danger("[user] evicerates [L]!"))
		return
	for(var/turf/T in orange(1, user))
		hit_turfs |= T
	addtimer(CALLBACK(src, PROC_REF(Leap), user, dir, times_ran + 1), 0.1)

/obj/item/ego_weapon/wings/proc/CheckPath(mob/living/user, dir = SOUTH)
	var/list/immediate_path = list() // Looks two tiles ahead for anything dense; the leap attack must move you at least one tile and will stop one tile short of a dense one
	immediate_path |= get_step(get_turf(user), dir)
	immediate_path |= get_step(immediate_path[1], dir)
	var/fail_charge = FALSE
	for(var/turf/T in immediate_path)
		if(T.density)
			fail_charge = TRUE
		for(var/obj/machinery/door/D in T.contents)
			if(D.density)
				fail_charge = TRUE
		for(var/obj/structure/window/W in T.contents)
			fail_charge = TRUE
	return fail_charge

/obj/item/ego_weapon/wings/proc/SecondSwing(mob/living/M, mob/living/user)
	sleep(CLICK_CD_MELEE*attack_speed*0.5+1)
	if(get_dist(M, user) > 1)
		return
	if(force && HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("You don't want to harm other living beings!"))
		return
	if(max_count > hit_count)
		hit_count++
	else if(prob(10))
		to_chat(user, span_notice("[src]' feathers bristle!")) // "Hey dumbass, you can stop smacking them now"
	combo_hold = world.time + decay_time
	playsound(loc, hitsound, get_clamped_volume(), TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
	user.do_attack_animation(M)
	M.attacked_by(src, user)

	log_combat(user, M, "attacked", src.name, "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(damtype)])")

/obj/item/ego_weapon/wings/proc/ResetSpecial()
	specialing = FALSE

/obj/item/ego_weapon/mini/mirth
	name = "mirth"
	desc = "A round of applause, for the clowns who joined us for tonight’s show!"
	special = "This weapon can be paired with its sister blade."
	icon_state = "mirth"
	force = 15
	attack_speed = 0.5
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("cuts", "attacks", "slashes")
	attack_verb_simple = list("cut", "attack", "slash")
	hitsound = 'sound/weapons/ego/sword1.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60
							)

	var/combo_on = TRUE
	var/sound = FALSE
	var/dash_cooldown
	var/dash_cooldown_time = 4 SECONDS
	var/dash_range = 6

//Switch between weapons every hit, or don't
/obj/item/ego_weapon/mini/mirth/attack_self(mob/user)
	..()
	if(combo_on)
		to_chat(user,span_warning("You swap your grip, and will no longer fight with two weapons."))
		combo_on = FALSE
		return
	if(!combo_on)
		to_chat(user,span_warning("You swap your grip, and will now fight with two weapons."))
		combo_on =TRUE
		return

/obj/item/ego_weapon/mini/mirth/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	var/combo = FALSE
	force = 15
	hitsound = 'sound/weapons/fixer/generic/knife1.ogg'
	var/mob/living/carbon/human/myman = user
	var/obj/item/ego_weapon/mini/malice/Y = myman.get_inactive_held_item()
	if(istype(Y) && combo_on) //dual wielding? if so...
		combo = TRUE //hits twice, you're spending as much PE as you would getting an ALEPH anyways
		if(sound)
			hitsound = 'sound/weapons/fixer/generic/knife3.ogg'
			sound = FALSE
		else
			sound = TRUE
	..()
	if(combo)
		for(var/damage_type in list(RED_DAMAGE))
			damtype = damage_type
			M.attacked_by(src, user)
		damtype = initial(damtype)

/obj/item/ego_weapon/mini/mirth/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user))
		return
	if(!isliving(A))
		return
	if(dash_cooldown > world.time)
		to_chat(user, "<span class='warning'>Your dash is still recharging!")
		return
	if((get_dist(user, A) < 2) || (!(can_see(user, A, dash_range))))
		return
	..()
	dash_cooldown = world.time + dash_cooldown_time
	for(var/i in 2 to get_dist(user, A))
		step_towards(user,A)
	if((get_dist(user, A) < 2))
		A.attackby(src,user)
	playsound(src, 'sound/weapons/fwoosh.ogg', 300, FALSE, 9)
	to_chat(user, "<span class='warning'>You dash to [A]!")

/obj/item/ego_weapon/mini/malice
	name = "malice"
	desc = "Seeing that I wasn't amused, it took out another tool. \
	I thought it was a tool. Just that moment."
	special = "This weapon can be paired with its sister blade."
	icon_state = "malice"
	force = 15
	attack_speed = 0.5
	damtype = RED_DAMAGE
	attack_verb_continuous = list("cuts", "attacks", "slashes")
	attack_verb_simple = list("cut", "attack", "slash")
	hitsound = 'sound/weapons/fixer/generic/knife3.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60
							)

	var/combo_on = TRUE
	var/sound = FALSE
	var/dash_cooldown
	var/dash_cooldown_time = 4 SECONDS
	var/dash_range = 6

/obj/item/ego_weapon/mini/malice/attack_self(mob/user)
	..()
	if(combo_on)
		to_chat(user,span_warning("You swap your grip, and will no longer fight with two weapons."))
		combo_on = FALSE
		return
	if(!combo_on)
		to_chat(user,span_warning("You swap your grip, and will now fight with two weapons."))
		combo_on =TRUE
		return

/obj/item/ego_weapon/mini/malice/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	var/combo = FALSE
	force = 15
	hitsound = 'sound/weapons/fixer/generic/knife3.ogg'
	var/mob/living/carbon/human/myman = user
	var/obj/item/ego_weapon/mini/mirth/Y = myman.get_inactive_held_item()
	if(istype(Y) && combo_on)
		combo = TRUE //hits twice, you're spending as much PE as you would getting an ALEPH anyways
		if(sound)
			hitsound = 'sound/weapons/fixer/generic/knife1.ogg'
			sound = FALSE
		else
			sound = TRUE
	..()
	if(combo)
		for(var/damage_type in list(WHITE_DAMAGE))
			damtype = damage_type
			M.attacked_by(src, user)
		damtype = initial(damtype)

/obj/item/ego_weapon/mini/malice/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user))
		return
	if(!isliving(A))
		return
	if(dash_cooldown > world.time)
		to_chat(user, "<span class='warning'>Your dash is still recharging!")
		return
	if((get_dist(user, A) < 2) || (!(can_see(user, A, dash_range))))
		return
	..()
	dash_cooldown = world.time + dash_cooldown_time
	for(var/i in 2 to get_dist(user, A))
		step_towards(user,A)
	if((get_dist(user, A) < 2))
		A.attackby(src,user)
	playsound(src, 'sound/weapons/fwoosh.ogg', 300, FALSE, 9)
	to_chat(user, "<span class='warning'>You dash to [A]!")

/obj/item/ego_weapon/shield/swan
	name = "black swan"
	desc = "It yeared for a dream it would never wake up from, but reality was as cruel as ever.\
	All that was left is a worn parasol it once treasured."
	special = "This weapon has a small windup before blocking, and performs a counterattack upon a successful block."
	icon_state = "swan_closed"
	force = 17
	attack_speed = 0.5
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("bashs", "whaps", "beats", "prods", "pokes")
	attack_verb_simple = list("bash", "whap", "beat", "prod", "poke")
	hitsound = 'sound/weapons/fixer/generic/spear1.ogg'
	reductions = list(40, 30, 50, 30) // 150
	projectile_block_duration = 1 SECONDS
	block_duration = 3 SECONDS // Exempt from normal reduction due to block restriction.
	block_cooldown = 3 SECONDS
	block_sound = 'sound/weapons/ego/clash1.ogg'
	projectile_block_message = "You swat the projectile out of the air!"
	block_cooldown_message = "You rearm your E.G.O."
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)
	var/close_cooldown
	var/close_cooldown_time = 6 SECONDS
	var/reflect_cooldown
	var/reflect_cooldown_time = 1 //need to prevent simultaneous hits; bullets overlapping is very bad.

/obj/item/ego_weapon/shield/swan/attack_self(mob/user)
	if(close_cooldown > world.time) //prevents shield usage with no DPS loss
		to_chat(user,span_warning("You cannot use this again so soon!"))
		return
	if(do_after(user, 4, src))
		icon_state = "swan"
		close_cooldown = world.time + close_cooldown_time
		..()
	user.update_inv_hands()

/obj/item/ego_weapon/shield/swan/DisableBlock(mob/living/carbon/human/user)
	. = ..()
	icon_state = "swan_closed"
	to_chat(user,span_nicegreen("You close the umbrella."))
	user.update_inv_hands()
	return

/obj/item/ego_weapon/shield/swan/AnnounceBlock(mob/living/carbon/human/source, damage, damagetype, def_zone)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(Reflect), source, damage)

/obj/item/ego_weapon/shield/swan/proc/Reflect(mob/living/carbon/human/user, damage, damagetype, def_zone)
	if(!block)
		return
	if(reflect_cooldown > world.time)
		return
	reflect_cooldown = world.time + reflect_cooldown_time
	var/turf/proj_turf = user.loc
	if(!isturf(proj_turf))
		return
	var/list/mob_list = list()
	for(var/mob/living/simple_animal/hostile/H in livinginview(8, user))
		mob_list += H
	if(!mob_list.len)
		return
	var/mob/living/simple_animal/hostile/target = pick(mob_list)
	var/obj/projectile/ego_bullet/swan/S = new /obj/projectile/ego_bullet/swan(proj_turf)
	S.fired_from = src //for signal check
	playsound(user, 'sound/weapons/resonator_blast.ogg', 30, TRUE)
	S.firer = user
	S.preparePixelProjectile(target, user)
	S.fire()
	S.damage *= force_multiplier
	return

/obj/item/ego_weapon/shield/swan/Initialize()
	RegisterSignal(src, COMSIG_PROJECTILE_ON_HIT, PROC_REF(projectile_hit))
	..()

/obj/item/ego_weapon/shield/swan/proc/projectile_hit(atom/fired_from, atom/movable/firer, atom/target, Angle)
	SIGNAL_HANDLER
	return TRUE

/obj/projectile/ego_bullet/swan
	name = "mass of goo"
	icon_state = "neurotoxin"
	damage = 30
	damage_type = BLACK_DAMAGE

	hitsound = 'sound/abnormalities/wrath_servant/small_smash1.ogg'
	hitsound_wall = 'sound/abnormalities/wrath_servant/small_smash1.ogg'

/obj/item/ego_weapon/moonlight
	name = "moonlight"
	desc = "The serpentine ornament is loyal to the original owner’s taste. The snake’s open mouth represents the endless yearning for music."
	special = "Use this weapon in hand to heal the sanity of those around you."
	icon_state = "moonlight"
	force = 32					//One of the best support weapons. Does HE damage in its stead.
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("beats", "jabs")
	attack_verb_simple = list("beat", "jab")
	var/inuse
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/moonlight/attack_self(mob/user)
	. = ..()
	if(!CanUseEgo(user))
		return

	if(inuse)
		return
	inuse = TRUE
	if(do_after(user, 30))	//3 seconds for a big heal.
		playsound(src, 'sound/magic/staff_healing.ogg', 200, FALSE, 9)
		for(var/mob/living/carbon/human/L in range(5, get_turf(user)))
			if(L.is_working)
				to_chat(L, span_nicegreen("The powers of the moon are the same as the powers of the sun. The redundancy of moonlight does not make this work any less mind-numbing."))
				continue
			L.adjustSanityLoss(-10)
	inuse = FALSE


/obj/item/ego_weapon/heaven
	name = "heaven"
	desc = "As it spreads its wings for an old god, a heaven just for you burrows its way."
	icon_state = "heaven"
	force = 40
	reach = 2		//Has 2 Square Reach.
	throwforce = 80		//It costs like 50 PE I guess you can go nuts
	throw_speed = 5
	throw_range = 7
	attack_speed = 1.2
	damtype = RED_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/fixer/generic/nail1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/heaven/get_clamped_volume()
	return 25

/obj/item/ego_weapon/spore
	name = "spore"
	desc = "A spear covered in spores and affection. \
	It lights the employee's heart, shines like a star, and steadily tames them."
	special = "Upon hit the targets WHITE vulnerability is increased by 0.2."
	icon_state = "spore"
	force = 30		//Quite low as WAW coz the armor rend effect
	reach = 2		//Has 2 Square Reach.
	attack_speed = 1.2
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/spore/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if(isliving(target))
		var/mob/living/simple_animal/M = target
		if(!ishuman(M) && !M.has_status_effect(/datum/status_effect/rend_white))
			new /obj/effect/temp_visual/cult/sparks(get_turf(M))
			M.apply_status_effect(/datum/status_effect/rend_white)


/obj/item/ego_weapon/dipsia
	name = "dipsia"
	desc = "The thirst will never truly be quenched."
	special = "This weapon heals you on hit."
	icon_state = "dipsia"
	force = 32
	damtype = RED_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/pierce_slow.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/dipsia/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	if(!(target.status_flags & GODMODE) && target.stat != DEAD)
		var/heal_amt = force*0.10
		if(isanimal(target))
			var/mob/living/simple_animal/S = target
			if(S.damage_coeff.getCoeff(damtype) > 0)
				heal_amt *= S.damage_coeff.getCoeff(damtype)
			else
				heal_amt = 0
		user.adjustBruteLoss(-heal_amt)
	..()

/obj/item/ego_weapon/shield/pharaoh
	name = "pharaoh"
	desc = "Look on my Works, ye Mighty, and despair!"
	special = "This weapon can remove petrification."
	icon_state = "pharaoh"
	force = 20
	attack_speed = 0.5
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("decimates", "bisects")
	attack_verb_simple = list("decimate", "bisect")
	hitsound = 'sound/weapons/bladeslice.ogg'
	reductions = list(30, 50, 30, 40) // 150
	projectile_block_duration = 0.5 SECONDS
	block_duration = 1 SECONDS
	block_cooldown = 3 SECONDS
	block_sound = 'sound/weapons/ego/clash1.ogg'
	projectile_block_message ="A God does not fear death!"
	block_message = "You attempt to parry the attack!"
	hit_message = "parries the attack!"
	block_cooldown_message = "You rearm your blade."
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/shield/pharaoh/pre_attack(atom/A, mob/living/user, params)
	if(istype(A,/obj/structure/statue/petrified) && CanUseEgo(user))
		playsound(A, 'sound/effects/break_stone.ogg', rand(10,50), TRUE)
		A.visible_message(span_danger("[A] returns to normal!"), span_userdanger("You break free of the stone!"))
		A.Destroy()
		return
	..()

/obj/item/ego_weapon/blind_rage
	name = "Blind Rage"
	desc = "Those who suffer injustice tend to lash out at all those around them."
	icon_state = "blind_rage"
	force = 40
	attack_speed = 1.2
	special = "This weapon possesses a devastating Red AND Black damage AoE. Be careful!"
	damtype = RED_DAMAGE
	attack_verb_continuous = list("smashes", "crushes", "flattens")
	attack_verb_simple = list("smash", "crush", "flatten")
	hitsound = 'sound/abnormalities/wrath_servant/big_smash1.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)

	var/aoe_damage = 15
	var/aoe_damage_type = BLACK_DAMAGE
	var/aoe_range = 2
	var/attacks = 0

/obj/item/ego_weapon/blind_rage/get_clamped_volume()
	return 30

/obj/item/ego_weapon/blind_rage/attack(mob/living/M, mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return FALSE

	attacks++
	attacks %= 3
	switch(attacks)
		if(0)
			hitsound = 'sound/abnormalities/wrath_servant/big_smash1.ogg'
		if(1)
			hitsound = 'sound/abnormalities/wrath_servant/big_smash2.ogg'
		if(2)
			hitsound = 'sound/abnormalities/wrath_servant/big_smash3.ogg'
	var/damage = aoe_damage * (1 + (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))/100)
	damage *= force_multiplier
	if(attacks == 0)
		damage *= 3
	if(user.sanity_lost)
		damage *= 1.2
	for(var/turf/open/T in range(aoe_range, M))
		var/obj/effect/temp_visual/small_smoke/halfsecond/smonk = new(T)
		smonk.color = COLOR_GREEN
		user.HurtInTurf(T, list(M), damage, damtype, hurt_mechs = TRUE, hurt_structure = TRUE, break_not_destroy = TRUE)
		user.HurtInTurf(T, list(), damage, aoe_damage_type, hurt_mechs = TRUE, hurt_structure = TRUE, break_not_destroy = TRUE)
		if(prob(5))
			new /obj/effect/gibspawner/generic/silent/wrath_acid(T) // The non-damaging one

/obj/item/ego_weapon/blind_rage/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/nihil/club))
		return
	new /obj/item/ego_weapon/blind_rage/nihil(get_turf(src))
	to_chat(user,span_warning("The [I] seems to drain all of the light away as it is absorbed into [src]!"))
	playsound(user, 'sound/abnormalities/nihil/filter.ogg', 15, FALSE, -3)
	qdel(I)
	qdel(src)

/obj/item/ego_weapon/mini/heart
	name = "bleeding heart"
	desc = "The supplicant will suffer various ordeals in a manner like being put through a trial."
	icon_state = "heart"
	special = "Hit yourself to heal others."
	inhand_icon_state = "bloodbath"
	force = 30
	damtype = RED_DAMAGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(FORTITUDE_ATTRIBUTE = 80)

/obj/item/ego_weapon/mini/heart/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	..()
	if(M==user)
		for(var/mob/living/carbon/human/L in range(10, user))
			if(L==user)
				continue
			L.adjustBruteLoss(-15)
			new /obj/effect/temp_visual/healing(get_turf(L))

/obj/item/ego_weapon/diffraction
	name = "diffraction"
	desc = "Many employees have sustained injuries from erroneous calculation."
	special = "This weapon deals double damage to targets under 20% HP."
	icon_state = "diffraction"
	force = 40
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("slices", "cuts")
	attack_verb_simple = list("slice", "cut")
	hitsound = 'sound/weapons/blade1.ogg'
	attribute_requirements = list(FORTITUDE_ATTRIBUTE = 80)

/obj/item/ego_weapon/diffraction/attack(mob/living/target, mob/living/user)
	if((target.health<=target.maxHealth *0.2) && !(GODMODE in target.status_flags))
		force*=2
	..()
	force = initial(force)

/obj/item/ego_weapon/mini/infinity
	name = "infinity"
	desc = "A giant novelty pen."
	special = "This weapon marks enemies with a random damage type. They take that damage after 5 seconds."
	icon_state = "infinity"
	force = 30	//Does more damage for being harder to use.
	hitsound = 'sound/abnormalities/book/scribble.ogg'
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)
	damtype = PALE_DAMAGE
	var/mark_damage
	var/mark_type = RED_DAMAGE

//Replaces the normal attack with a mark
/obj/item/ego_weapon/mini/infinity/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	..()
	if(do_after(user, 4, src))
		playsound(loc, hitsound, 120, TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
		target.visible_message(span_danger("[user] markes [target]!"), \
						span_userdanger("[user] marks you!"), COMBAT_MESSAGE_RANGE, user)
		to_chat(user, span_danger("You enscribe a code on [target]!"))

		mark_damage = force*2
		//I gotta grab  justice here
		var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust/100
		mark_damage *= justicemod
		mark_damage *= force_multiplier

		var/obj/effect/infinity/P = new get_turf(target)
		if(mark_type == RED_DAMAGE)
			P.color = COLOR_RED

		if(mark_type == BLACK_DAMAGE)
			P.color = COLOR_PURPLE

		addtimer(CALLBACK(src, PROC_REF(cast), target, user, mark_type), 5 SECONDS)

		//So you can see what the next mark is.
		mark_type = pick(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE)
		damtype = mark_type

	else
		to_chat(user, "<span class='spider'><b>Your attack was interrupted!</b></span>")
		return

/obj/effect/infinity
	name = "mark"
	icon = 'icons/effects/cult_effects.dmi'
	icon_state = "rune3center"
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/infinity/Initialize()
	. = ..()
	animate(src, alpha = 0, time = 1 SECONDS)
	QDEL_IN(src, 1 SECONDS)

/obj/item/ego_weapon/mini/infinity/proc/cast(mob/living/target, mob/living/user, damage_color)
	target.apply_damage(mark_damage, damage_color, null, target.run_armor_check(null, damage_color), spread_damage = TRUE)		//MASSIVE fuckoff punch
	playsound(loc, 'sound/weapons/fixer/generic/energyfinisher3.ogg', 15, TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
	new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(target), pick(GLOB.alldirs))
	mark_damage = force

/obj/item/ego_weapon/amrita
	name = "amrita"
	desc = "The rings attached to the cane represent the middle way and the Six Paramitas."
	special = "Use this weapon in your hand to damage every non-human within reach."
	icon_state = "amrita"
	force = 40
	reach = 2		//Has 2 Square Reach.
	throw_speed = 5
	throw_range = 7
	attack_speed = 1.3
	damtype = RED_DAMAGE
	attack_verb_continuous = list("slams", "attacks")
	attack_verb_simple = list("slam", "attack")
	hitsound = 'sound/abnormalities/clouded_monk/monk_attack.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)
	var/can_spin = TRUE
	var/spinning = FALSE

/obj/item/ego_weapon/amrita/get_clamped_volume()
	return 20

/obj/item/ego_weapon/amrita/attack(mob/living/target, mob/living/user)
	if(!can_spin)
		return FALSE
	..()
	can_spin = FALSE
	addtimer(CALLBACK(src, PROC_REF(spin_reset)), 13)

/obj/item/ego_weapon/amrita/proc/spin_reset()
	can_spin = TRUE

/obj/item/ego_weapon/amrita/attack_self(mob/user) //spin attack with knockback
	if(!CanUseEgo(user))
		return
	if(!can_spin)
		to_chat(user,span_warning("You attacked too recently."))
		return
	can_spin = FALSE
	if(do_after(user, 13, src))
		var/aoe = force
		var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust/100
		var/firsthit = TRUE //One target takes full damage
		can_spin = TRUE
		addtimer(CALLBACK(src, PROC_REF(spin_reset)), 13)
		playsound(src, 'sound/abnormalities/clouded_monk/monk_bite.ogg', 75, FALSE, 4)
		aoe*=justicemod
		aoe*=force_multiplier

		for(var/turf/T in orange(2, user))
			new /obj/effect/temp_visual/smash_effect(T)
		for(var/mob/living/L in range(2, user)) //knocks enemies away from you
			if(L == user || ishuman(L))
				continue
			L.apply_damage(aoe, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
			if(firsthit)
				aoe = (aoe / 2)
				firsthit = FALSE
			var/throw_target = get_edge_target_turf(L, get_dir(L, get_step_away(L, src)))
			if(!L.anchored)
				var/whack_speed = (prob(60) ? 1 : 4)
				L.throw_at(throw_target, rand(1, 2), whack_speed, user)
	spin_reset()

/obj/item/ego_weapon/discord
	name = "discord"
	desc = "The existance of evil proves the existance of good, just as light proves the existance of darkness."
	special = "This weapon can be two-handed, and attacks thrice in rapid succession when doing so.\n Attacks with this weapon will heal a nearby ally using Assonance."
	icon_state = "discord"
	force = 28
	attack_speed = 0.8
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)
	damtype = BLACK_DAMAGE
	var/wielded = FALSE

/obj/item/ego_weapon/discord/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_TWOHANDED_WIELD, PROC_REF(OnWield))
	RegisterSignal(src, COMSIG_TWOHANDED_UNWIELD, PROC_REF(on_unwield))

/obj/item/ego_weapon/discord/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=30, force_wielded=20)

/obj/item/ego_weapon/discord/proc/OnWield(obj/item/source, mob/user)
	SIGNAL_HANDLER
	wielded = TRUE

/obj/item/ego_weapon/discord/proc/on_unwield(obj/item/source, mob/user)
	SIGNAL_HANDLER
	wielded = FALSE

/obj/item/ego_weapon/discord/attack(mob/living/target, mob/living/carbon/human/user)
	if(!..())
		return FALSE
	if(!ishostile(target))
		return
	if(target.stat == DEAD || target.status_flags & GODMODE)
		return
	Harmony(user)
	if(!wielded)
		return
	user.changeNext_move(CLICK_CD_MELEE*attack_speed*2.5)
	for(var/i = 1 to 2)
		addtimer(CALLBACK(src, PROC_REF(MultiSwing), target, user), CLICK_CD_MELEE * 0.6 * i)

/obj/item/ego_weapon/discord/proc/MultiSwing(mob/living/target, mob/living/carbon/human/user)
	if(get_dist(target, user) > 1)
		return
	if(src != user.get_active_held_item())
		return
	if(!wielded)
		return
	Harmony(user)
	playsound(loc, hitsound, get_clamped_volume(), TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
	user.do_attack_animation(target)
	target.attacked_by(src, user)

	log_combat(user, target, "attacked", src.name, "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(damtype)])")

/obj/item/ego_weapon/discord/proc/Harmony(mob/living/carbon/human/user)
	var/heal_amount = 5
	if(wielded)
		heal_amount = 4
	for(var/mob/living/carbon/human/Yang in view(7, user))
		var/obj/item/gun/ego_gun/assonance/A = Yang.get_active_held_item()
		if(istype(A, /obj/item/gun/ego_gun/assonance))
			if(!A.CanUseEgo(Yang))
				continue
			Yang.adjustBruteLoss(-heal_amount)
			Yang.adjustSanityLoss(-heal_amount)
			new /obj/effect/temp_visual/healing(get_turf(Yang))
			break

/obj/item/ego_weapon/shield/innocence
	name = "innocence"
	desc = "But why is it about ‘innocence’? After countless assumptions and careful research, we learned that it could be defined as \[REDACTED\]."
	icon_state = "innocence"
	force = 72
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("shoves", "bashes")
	attack_verb_simple = list("shove", "bash")
	hitsound = 'sound/weapons/fixer/generic/gen2.ogg'
	reductions = list(10, 70, 50, 20) //150
	projectile_block_duration = 3 SECONDS
	block_duration = 3 SECONDS
	block_cooldown = 3 SECONDS
	block_sound = 'sound/abnormalities/orangetree/ding.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/rimeshank
	name = "rimeshank"
	desc = "Stay frozen... And there will be no pain."
	special = "This weapon can be used to perform a jump attack after a short wind-up."
	icon_state = "rimeshank"
	force = 75
	attack_speed = 2
	damtype = RED_DAMAGE
	attack_verb_continuous = list("slams", "attacks")
	attack_verb_simple = list("slam", "attack")
	hitsound = 'sound/abnormalities/babayaga/attack.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

	var/dash_cooldown
	var/dash_cooldown_time = 6 SECONDS
	var/dash_range = 10
	var/can_attack = TRUE

/obj/item/ego_weapon/rimeshank/get_clamped_volume()
	return 30

/obj/item/ego_weapon/rimeshank/attack(mob/living/target, mob/living/user)
	if(!can_attack)
		return
	..()
	can_attack = FALSE
	addtimer(CALLBACK(src, PROC_REF(JumpReset)), 20)

/obj/item/ego_weapon/rimeshank/proc/JumpReset()
	can_attack = TRUE

/obj/item/ego_weapon/rimeshank/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user) || !can_attack)
		return
	if(!isliving(A))
		return
	if(dash_cooldown > world.time)
		to_chat(user, span_warning("Your dash is still recharging!"))
		return
	if((get_dist(user, A) < 2) || (!(can_see(user, A, dash_range))))
		return
	..()
	if(do_after(user, 5, src))
		dash_cooldown = world.time + dash_cooldown_time
		playsound(src, 'sound/abnormalities/babayaga/charge.ogg', 50, FALSE, -1)
		animate(user, alpha = 1,pixel_x = 0, pixel_z = 16, time = 0.1 SECONDS)
		user.pixel_z = 16
		sleep(0.5 SECONDS)
		for(var/i in 2 to get_dist(user, A))
			step_towards(user,A)
		if((get_dist(user, A) < 2))
			JumpAttack(A,user)
		to_chat(user, span_warning("You jump towards [A]!"))
		animate(user, alpha = 255,pixel_x = 0, pixel_z = -16, time = 0.1 SECONDS)
		user.pixel_z = 0

/obj/item/ego_weapon/rimeshank/proc/JumpAttack(atom/A, mob/living/user, proximity_flag, params)
	force = 25
	A.attackby(src,user)
	force = initial(force)
	can_attack = FALSE
	addtimer(CALLBACK(src, PROC_REF(JumpReset)), 20)
	for(var/mob/living/L in livinginrange(2, A))
		if(L.z != user.z) // Not on our level
			continue
		var/aoe = 25
		var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust/100
		aoe*=justicemod
		aoe*=force_multiplier
		if(L == user || ishuman(L))
			continue
		L.apply_damage(aoe, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		var/obj/effect/temp_visual/small_smoke/halfsecond/FX =  new(get_turf(L))
		FX.color = "#a2d2df"

/obj/item/ego_weapon/animalism
	name = "animalism"
	desc = "The frothing madness of the revving engine brings a fleeting warmth to your hands and heart alike."
	special = "This weapon hits 4 times for every hit"
	icon_state = "animalism"
	force = 20
	attack_speed = 1.3
	damtype = RED_DAMAGE
	attack_verb_continuous = list("slices", "saws", "rips")
	attack_verb_simple = list("slice", "saw", "rip")
	hitsound = 'sound/abnormalities/helper/attack.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/animalism/attack(mob/living/target, mob/living/user)
	if(!..())
		return
	sleep(2)
	for(var/i = 1 to 3)
		sleep(2)
		target.apply_damage(force, damtype, null, target.run_armor_check(null, damtype), spread_damage = TRUE)
		user.do_attack_animation(target)
		playsound(loc, hitsound, get_clamped_volume(), TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(target), pick(GLOB.alldirs))

/obj/item/ego_weapon/psychic
	name = "psychic dagger"
	desc = "A saber from the deepest sea, meant for a groom's mortality."
	special = "Use this weapon in hand to dodgeroll."
	icon_state = "psychic"
	force = 13
	attack_speed = 0.3
	damtype = WHITE_DAMAGE
	hitsound = 'sound/weapons/fixer/generic/knife4.ogg'
	var/dodgelanding

/obj/item/ego_weapon/psychic/attack_self(mob/living/carbon/user)
	if(user.dir == 1)
		dodgelanding = locate(user.x, user.y + 5, user.z)
	if(user.dir == 2)
		dodgelanding = locate(user.x, user.y - 5, user.z)
	if(user.dir == 4)
		dodgelanding = locate(user.x + 5, user.y, user.z)
	if(user.dir == 8)
		dodgelanding = locate(user.x - 5, user.y, user.z)
	user.adjustStaminaLoss(20, TRUE, TRUE)
	user.throw_at(dodgelanding, 3, 2, spin = TRUE)

/obj/item/ego_weapon/grasp
	name = "grasp"
	desc = "I should’ve said that I'm sorry that I let go of your hand and apologized, even if it didn't mean anything."
	special = "This weapon can be used to dash to a target."
	icon_state = "grasp"
	force = 16
	attack_speed = 0.5
	damtype = PALE_DAMAGE
	attack_verb_continuous = list("cuts", "attacks", "slashes")
	attack_verb_simple = list("cut", "attack", "slash")
	hitsound = 'sound/weapons/fixer/generic/knife2.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60
							)

	var/dash_cooldown
	var/dash_cooldown_time = 3 SECONDS
	var/dash_range = 4
	var/charging = TRUE

/obj/item/ego_weapon/grasp/attack_self(mob/user)
	..()
	if(charging)
		to_chat(user,span_warning("You change your stance, and will no longer perform a dash towards enemies."))
		charging = FALSE
		force = initial(force) + 2
		return
	if(!charging)
		to_chat(user,span_warning("You change your stance, and will now perform a dash towards enemies."))
		charging =TRUE
		force = initial(force)
		return

/obj/item/ego_weapon/grasp/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user))
		return
	if(!isliving(A) || !charging)
		return
	if(dash_cooldown > world.time)
		to_chat(user, "<span class='warning'>Your dash is still recharging!")
		return
	if((get_dist(user, A) < 2) || (!(can_see(user, A, dash_range))))
		return
	..()
	dash_cooldown = world.time + dash_cooldown_time
	for(var/i in 2 to get_dist(user, A))
		step_towards(user,A)
	if((get_dist(user, A) < 2))
		A.attackby(src,user)
	playsound(src, 'sound/weapons/fwoosh.ogg', 300, FALSE, 9)
	to_chat(user, "<span class='warning'>You dash to [A]!")

/obj/item/ego_weapon/cobalt
	name = "cobalt scar"
	desc = "Once upon a time, these claws would cut open the bellies of numerous creatures and tear apart their guts."
	special = "Preform an additional attack of 50% damage when at half health."
	icon_state = "cobalt"
	force = 24
	attack_speed = 0.5
	damtype = RED_DAMAGE
	attack_verb_continuous = list("claws")
	attack_verb_simple = list("claw")
	hitsound = 'sound/abnormalities/big_wolf/Wolf_Hori.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/cobalt/attack(mob/living/target, mob/living/user)
	if(!..())
		return
	var/our_health = 100 * (user.health / user.maxHealth)
	if(our_health <= 50 && isliving(target) && target.stat != DEAD)
		FrenzySwipe(user)

//Attack again but with less of the code.
/obj/item/ego_weapon/cobalt/proc/FrenzySwipe(mob/living/wolf)
	var/list/killers = list()
	for(var/mob/living/hunters in oview(get_turf(wolf), 1))
		//This is placed here as a safety net in the case that the user is in the middle of 30 enemies
		if(killers.len >= 5)
			break
		if(hunters.stat == DEAD)
			continue
		killers += hunters
	if(!killers.len)
		return FALSE
	var/mob/living/those_we_rend = pick(killers)
	if(!those_we_rend)
		return FALSE
	if(prob(25))
		wolf.visible_message(span_warning("[wolf] claws [those_we_rend] in a blind frenzy!"), span_warning("You swipe your claws at [those_we_rend]!"))
	wolf.do_attack_animation(those_we_rend)
	if(ishuman(wolf))
		var/rend_damage = 16
		var/userjust = (get_modified_attribute_level(wolf, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust/100
		rend_damage*=justicemod
		rend_damage*=force_multiplier
		those_we_rend.apply_damage(rend_damage, damtype, null, those_we_rend.run_armor_check(null, damtype), spread_damage = TRUE)
		those_we_rend.lastattacker = wolf.real_name
		those_we_rend.lastattackerckey = wolf.ckey
		playsound(loc, hitsound, get_clamped_volume(), TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
		wolf.log_message(" attacked [those_we_rend] due to the cobalt scar weapon ability.", LOG_ATTACK) //the following attack will log itself
	return TRUE

/obj/item/ego_weapon/scene
	name = "as written in the scenario"
	desc = "The scenario is about a man who was raised in a normal family. \
	One day, he picks up a mask from the street and goes on to impulsively murder all the people that he knows."
	special = "This weapon can store damage dealt for later healing."
	icon_state = "scenario"
	force = 38
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("disrespects", "sullies")
	attack_verb_simple = list("disrespect", "sully")
	hitsound = 'sound/effects/fish_splash.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)
	var/amount_filled
	var/amount_max = 30

/obj/item/ego_weapon/scene/update_icon_state()
	. = ..()
	if(amount_filled)
		icon_state = "scenario_filled"
	else
		icon_state = "scenario"

/obj/item/ego_weapon/scene/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	if(!(target.status_flags & GODMODE) && target.stat != DEAD)
		var/heal_amt = force*0.05
		if(isanimal(target))
			var/mob/living/simple_animal/S = target
			if(S.damage_coeff.getCoeff(damtype) > 0)
				heal_amt *= S.damage_coeff.getCoeff(damtype)
			else
				heal_amt = 0
		amount_filled = clamp(amount_filled + heal_amt, 0, amount_max)
		if(amount_filled >= amount_max)
			to_chat(user, "<span class='warning'>[src] is full!")
	update_icon()
	..()

/obj/item/ego_weapon/scene/attack_self(mob/living/carbon/human/user)
	..()
	if(!amount_filled)
		to_chat(user, "<span class='warning'>[src] is empty!")
		return
	if(do_after(user, 12, src))
		to_chat(user, "<span class='warning'>You take a sip from [src]!")
		playsound(get_turf(src), 'sound/items/drink.ogg', 50, TRUE) //slurp
		user.adjustBruteLoss(-amount_filled)
		user.adjustSanityLoss(-amount_filled)
		amount_filled = 0
	update_icon()

/obj/item/ego_weapon/lance/tattered_kingdom
	name = "tattered kingdom"
	desc = "No one remembers those who gave their effort to raise the kingdom. It’s a truth that repeats on and on."
	icon_state = "tattered_kingdom"
	lefthand_file = 'icons/mob/inhands/96x96_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/96x96_righthand.dmi'
	inhand_x_dimension = 96
	inhand_y_dimension = 96
	force = 35
	reach = 2		//Has 2 Square Reach.
	attack_speed = 1.2 //same speed as Spore
	damtype = RED_DAMAGE
	attack_verb_continuous = list("pierces", "jabs")
	default_attack_verbs = list("pierce", "jab")
	hitsound = 'sound/weapons/fixer/generic/spear2.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)
	couch_cooldown_time = 4 SECONDS
	force_cap = 70 //double base damage
	force_per_tile = 5 //if I can read, this means you need to cross 14 tiles for max damage
	pierce_force_cost = 20

/obj/item/ego_weapon/charge/warring
	name = "warring"
	desc = "It was a good day to die, but everybody did."
	special = "Upon throwing, this weapon returns to the user. Throwing will activate the charge effect."
	icon_state = "warring2"
	force = 30
	attack_speed = 0.8
	throwforce = 65
	throw_speed = 1
	throw_range = 7
	damtype = BLACK_DAMAGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	release_message = "You release your charge!"
	charge_effect = "expend all charge stacks in a powerful burst."
	charge_cost = 5
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
	)

/obj/item/ego_weapon/charge/warring/Initialize()
	..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/ego_weapon/charge/warring/attack(mob/living/target, mob/living/user)
	if(charge == 19)//max power, get ready to throw!
		playsound(src, 'sound/magic/lightningshock.ogg', 50, TRUE)
	. = ..()
	if(charge == 5)
		playsound(src, 'sound/magic/lightningshock.ogg', 50, TRUE)
		icon_state = "warring2_firey"
		hitsound = 'sound/abnormalities/thunderbird/tbird_peck.ogg'
		if(user)
			user.update_inv_hands()

/obj/item/ego_weapon/charge/warring/release_charge(mob/living/target, mob/living/user)
	playsound(src, 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 50, TRUE)
	var/turf/T = get_turf(src)
	for(var/mob/living/L in view(1, T))
		var/aoe = charge * 5
		var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust/100
		aoe*=justicemod
		if(L == user || ishuman(L))
			continue
		L.apply_damage(aoe, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		new /obj/effect/temp_visual/tbirdlightning(get_turf(L))
	icon_state = initial(icon_state)
	hitsound = initial(hitsound)
	charge = 0

/obj/item/ego_weapon/charge/warring/on_thrown(mob/living/carbon/user, atom/target)//No, clerks cannot hilariously kill themselves with this
	if(!CanUseEgo(user))
		return
	return ..()

/obj/item/ego_weapon/charge/warring/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/caught = hit_atom.hitby(src, FALSE, FALSE, throwingdatum=throwingdatum)
	if(thrownby && !caught)
		if(charge >= charge_cost && isliving(hit_atom))
			release_charge(hit_atom)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, throw_at), thrownby, throw_range+2, throw_speed, null, TRUE), 1)
	if(caught)
		return
	else
		return ..()

/obj/item/ego_weapon/charge/warring/get_clamped_volume()
	return 40

/obj/item/ego_weapon/hyde
	name = "hyde"
	desc = "The most racking pangs succeeded: a grinding in the bones, deadly nausea, and a horror of the spirit that cannot be exceeded at the hour of birth or death."
	special = "Activate this weapon in hand to take a syringe, empowering it at the cost of taking damage."
	icon_state = "hyde"
	force = 25
	attack_speed = 0.8
	damtype = RED_DAMAGE
	attack_verb_continuous = list("punches", "slaps", "scratches")
	attack_verb_simple = list("punch", "slap", "scratch")
	hitsound = 'sound/effects/hit_kick.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60
							)
	var/list/attack_styles = list("red", "white", "black")
	var/chosen_style
	var/transformed = FALSE

/obj/item/ego_weapon/hyde/Initialize()
	..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/ego_weapon/hyde/attack_self(mob/living/carbon/human/user)
	if(transformed)
		return
	if(!CanUseEgo(user))
		return
	chosen_style = input(user, "Which syringe will you use?") as null|anything in attack_styles
	if(!chosen_style)
		return
	if(do_after(user, 10, src, IGNORE_USER_LOC_CHANGE))
		user.emote("scream")
		playsound(get_turf(src),'sound/abnormalities/doomsdaycalendar/Limbus_Dead_Generic.ogg', 50, 1)//YEOWCH!
		icon_state = ("hyde_" + chosen_style)
		force = 42
		switch(chosen_style)
			if("red")
				user.apply_damage(50, RED_DAMAGE, null, user.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
				damtype = RED_DAMAGE
				to_chat(user, span_notice("Your bones are painfully sculpted to fit a muscular claw."))
				hitsound = 'sound/weapons/bladeslice.ogg'
			if("white")
				user.apply_damage(50, WHITE_DAMAGE, null, user.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
				damtype = WHITE_DAMAGE
				to_chat(user, span_notice("Your angst is plastered onto your arm."))
			if("black")
				user.apply_damage(50, BLACK_DAMAGE, null, user.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
				damtype = BLACK_DAMAGE
				to_chat(user, span_notice("Bristles are painfully ejected from your arm, filled with hate."))
				hitsound = 'sound/weapons/ego/spear1.ogg'
		ADD_TRAIT(src, TRAIT_NODROP, null)
		user.update_inv_hands()
		transformed = TRUE
		addtimer(CALLBACK(src, PROC_REF(Reset_Timer)), 600)
	return

/obj/item/ego_weapon/hyde/proc/Reset_Timer(mob/living/carbon/human/user)
	if(!transformed)
		return
	icon_state = "hyde"
	force = initial(force)
	hitsound = initial(hitsound)
	damtype = initial(damtype)
	transformed = FALSE
	REMOVE_TRAIT(src, TRAIT_NODROP, null)
	if(user)
		user.update_inv_hands()
		to_chat(user, span_notice("Your arm returns to normal."))

/obj/item/ego_weapon/hyde/on_thrown(mob/living/carbon/user, atom/target)//you can't throw it. bleh
	if(transformed)
		return
	return ..()

/obj/item/ego_weapon/rosa
	name = "flore sicut rosa"
	desc = "See? Wish, wish for it. Knowing that it is a sin. Only then can you bloom such colorful roses."
	special = "Hit yourself to heal the sanity of others"
	icon_state = "rosa"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 40
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("lashes", "punishes", "whips", "slaps", "lacerates")
	attack_verb_simple = list("lash", "punish","whip", "slap", "lacerate")
	hitsound = 'sound/weapons/whip.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/rosa/attack(mob/living/M, mob/living/user)
	..()
	if(M==user)
		var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust/100
		var/heal_amount = (force * justicemod * 0.75)
		var/armormod = (user.run_armor_check(null, WHITE_DAMAGE))
		if(armormod)//skips all the math if you're not wearing armor
			heal_amount -= (heal_amount * (armormod / 100))//wearing da capo will reduce it to 0
		heal_amount *= 0.5
		for(var/mob/living/carbon/human/L in range(10, user))
			if(L==user)
				continue
			L.adjustSanityLoss(-heal_amount)
			new /obj/effect/temp_visual/healing(get_turf(L))

/obj/item/ego_weapon/blind_obsession//When I saw that Ishmael's version was an anchor I thought "hey would it be funny if it was a throwing weapon with aoe".
	name = "blind obsession"
	desc = "All hands, full speed toward where the lights flicker. The waves... will lay waste to everything in our way."
	special = "This weapon requires two hands to use. \
			Use in hand to unlock its full power for a short period of time at the cost of speed. \
			When at thrown at full power, this weapon damages everyone but yourself in an AOE. Be careful! \
			This weapon deals 75% more damage on fully powered direct throws."
	icon_state = "blind_obsession"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 80
	attack_speed = 2.5
	throwforce = 80
	throw_speed = 1
	throw_range = 9
	damtype = RED_DAMAGE
	attack_verb_continuous = list("bashes", "smashes")
	attack_verb_simple = list("bashes", "smashes")
	hitsound = 'sound/weapons/ego/hammer.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)
	var/charged
	var/speed_slowdown = 0
	var/mob/current_holder
	var/power_timer


//Equipped setup
/obj/item/ego_weapon/blind_obsession/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!user)
		return
	current_holder = user
	RegisterSignal(current_holder, COMSIG_MOVABLE_MOVED, PROC_REF(UserMoved))

//Destroy setup
/obj/item/ego_weapon/blind_obsession/Destroy(mob/user)
	if(!user)
		return ..()
	speed_slowdown = 0
	UnregisterSignal(current_holder, COMSIG_MOVABLE_MOVED)
	PowerReset(user)
	current_holder = null
	user.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/anchor, multiplicative_slowdown = 0)
	return ..()

//Dropped setup
/obj/item/ego_weapon/blind_obsession/dropped(mob/user)
	. = ..()
	if(!user)
		return
	speed_slowdown = 0
	UnregisterSignal(current_holder, COMSIG_MOVABLE_MOVED)
	PowerReset(user)
	current_holder = null
	user.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/anchor, multiplicative_slowdown = 0)

/obj/item/ego_weapon/blind_obsession/proc/UserMoved(mob/user)
	SIGNAL_HANDLER
	user.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/anchor, multiplicative_slowdown = speed_slowdown)

/obj/item/ego_weapon/blind_obsession/CanUseEgo(mob/living/user)
	. = ..()
	if(user.get_inactive_held_item())
		to_chat(user, span_notice("You cannot use [src] with only one hand!"))
		return FALSE

/obj/item/ego_weapon/blind_obsession/attack_self(mob/user)
	if(user.get_inactive_held_item())
		to_chat(user, span_notice("You cannot impower [src] with only one hand!"))
		return
	if(charged)
		to_chat(user, span_notice("You've already prepared to throw [src]!"))
		return
	if(do_after(user, 12, src))
		charged = TRUE
		speed_slowdown = 1
		throwforce = 100//TIME TO DIE!
		to_chat(user,span_warning("You put your strength behind this attack."))
		power_timer = addtimer(CALLBACK(src, PROC_REF(PowerReset)), 3 SECONDS,user, TIMER_STOPPABLE)//prevents storing 3 powered up anchors and unloading all of them at once

/obj/item/ego_weapon/blind_obsession/proc/PowerReset(mob/user)
	to_chat(user, span_warning("You lose your balance while holding [src]."))
	charged = FALSE
	speed_slowdown = 0
	throwforce = 80
	deltimer(power_timer)

/obj/item/ego_weapon/blind_obsession/on_thrown(mob/living/carbon/user, atom/target)//No, clerks cannot hilariously kill others with this
	if(!CanUseEgo(user))
		return
	if(user.get_inactive_held_item())
		to_chat(user, span_notice("You cannot throw [src] with only one hand!"))
		return
	user.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/anchor, multiplicative_slowdown = 0)
	return ..()

/obj/item/ego_weapon/blind_obsession/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	deltimer(power_timer)
	playsound(src, 'sound/weapons/ego/hammer.ogg', 300, FALSE, 9)
	if(charged)
		var/damage = 75
		if(ishuman(thrownby))
			damage *= 1 + (get_modified_attribute_level(thrownby, JUSTICE_ATTRIBUTE))/100
		damage *= force_multiplier
		for(var/turf/open/T in range(1, src))
			var/obj/effect/temp_visual/small_smoke/halfsecond/smonk = new(T)
			smonk.color = COLOR_TEAL
			if(!ismob(thrownby))
				continue
			thrownby.HurtInTurf(T, list(thrownby), damage, RED_DAMAGE)
		PowerReset(thrownby)

/datum/movespeed_modifier/anchor
	multiplicative_slowdown = 0
	variable = TRUE

/obj/item/ego_weapon/abyssal_route //An ungodly love child of sword sharpened with tears and fluid sac
	name = "abyssal route"//old korean name I think
	desc = "I am the only one who moves in these waves. ... Shatter."
	special = "This weapon has a combo system ending with a dive attack. To turn off this combo system, use in hand. \
			This weapon has a fast attack speed"
	icon_state = "abyssal_route"
	force = 20
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("stabs", "attacks", "slashes")
	attack_verb_simple = list("stab", "attack", "slash")
	hitsound = 'sound/weapons/ego/rapier1.ogg'
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)
	var/combo = 0
	var/combo_time
	var/combo_wait = 10
	var/combo_on = TRUE
	var/can_attack = TRUE

/obj/item/ego_weapon/abyssal_route/attack_self(mob/user)
	..()
	if(combo_on)
		to_chat(user, span_warning("You swap your grip, and will now perform a dive finisher."))
		combo_on = FALSE
		return
	if(!combo_on)
		to_chat(user, span_warning("You swap your grip, and will no longer perform a dive finisher."))
		combo_on = TRUE
		return

/obj/item/ego_weapon/abyssal_route/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user)|| !can_attack)
		return
	if(combo_on)
		if(world.time > combo_time || !combo_on)	//or you can turn if off I guess
			combo = 0
		combo_time = world.time + combo_wait
		if(combo == 4)
			combo = 0
			user.changeNext_move(CLICK_CD_MELEE * 2)
			force *= 2	// Should actually keep up with normal damage.
			playsound(src, 'sound/weapons/fwoosh.ogg', 300, FALSE, 9)
		else
			user.changeNext_move(CLICK_CD_MELEE * 0.4)
	..()
	combo += 1
	force = initial(force)

/obj/item/ego_weapon/abyssal_route/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user)|| !can_attack)
		return
	if(!isliving(A))
		return
	if(!combo_on)
		return
	..()
	if(combo == 4)
		can_attack = FALSE
		sleep(0.5 SECONDS)
		playsound(get_turf(src), 'sound/abnormalities/piscinemermaid/waterjump.ogg', 20, 0, 3)
		animate(user, alpha = 1,pixel_x = 0, pixel_z = -16, time = 0.1 SECONDS)
		user.pixel_z = -16
		sleep(0.5 SECONDS)
		can_attack = TRUE
		for(var/i in 2 to get_dist(user, A))
			step_towards(user,A)
		if((get_dist(user, A) < 2))
			DiveAttack(A,user)
		playsound(get_turf(src), 'sound/abnormalities/bloodbath/Bloodbath_EyeOn.ogg', 20, 0, 3)
		to_chat(user, span_warning("You dive towards [A]!"))
		animate(user, alpha = 255,pixel_x = 0, pixel_z = 16, time = 0.1 SECONDS)
		user.pixel_z = 0

/obj/item/ego_weapon/abyssal_route/proc/DiveAttack(atom/A, mob/living/user, proximity_flag, params)
	A.attackby(src,user)
	can_attack = FALSE
	addtimer(CALLBACK(src, PROC_REF(DiveReset)), 5)
	for(var/turf/open/T in range(1, user))
		var/obj/effect/temp_visual/small_smoke/halfsecond/smonk = new(T)
		smonk.color = COLOR_TEAL
	for(var/mob/living/L in livinginrange(1, user))
		if(L.z != user.z) // Not on our level
			continue
		var/aoe = 40
		var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust/100
		aoe*=justicemod
		aoe*=force_multiplier
		if(L == user || ishuman(L))
			continue
		L.apply_damage(aoe, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)

/obj/item/ego_weapon/abyssal_route/proc/DiveReset()
	can_attack = TRUE
