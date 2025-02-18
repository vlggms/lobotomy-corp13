// Coded by Coxswain, sprites by Mel, Coxwswain and glowinthedarkmannhandler.
#define STATUS_EFFECT_EVENING_TWILIGHT /datum/status_effect/evening_twilight
/mob/living/simple_animal/hostile/abnormality/hammer_light
	name = "Hammer of Light"
	desc = "A white hammer engraved with yellow runic writing."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "hammer_pedestal"
	icon_living = "hammer_pedestal"
	portrait = "hammer_light"
	pixel_x = -16
	base_pixel_x = -16
	pixel_y = -8
	base_pixel_y = -8
	threat_level = ZAYIN_LEVEL
	can_breach = FALSE
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 70,
		ABNORMALITY_WORK_INSIGHT = 70,
		ABNORMALITY_WORK_ATTACHMENT = 70,
		ABNORMALITY_WORK_REPRESSION = 70,
	)
	work_damage_amount = 6
	work_damage_type = RED_DAMAGE
	max_boxes = 8

	ego_list = list(
		/datum/ego_datum/weapon/evening,
		/datum/ego_datum/armor/evening,
	)
	gift_type = /datum/ego_gifts/evening
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK // Technically it was in the beta but I dont want it showing it up in LC-only modes

	observation_prompt = "I was the unluckiest man in the world.<br>\
		Everything around me did nothing but ruining my life. But I had no power to change this fate.<br>\
		Someday, someone made an offer to me. \"If you accept it, your whole world will change.\"<br>\
		Such a tempting offer. I would become something that I could only hope to be."
	observation_choices = list(
		"Accept the offer" = list(TRUE, "I accepted the offer and paid the price. <br>The $0 Hammer of Light shined.")
	)

	pet_bonus = "hums" // saves a few lines of code by allowing funpet() to be called by attack_hand()
	var/sealed = TRUE
	var/hammer_present = TRUE
	var/list/spawned_mobs = list()
	var/list/banned = list()
	var/mob/living/carbon/human/current_user = null
	var/obj/item/ego_weapon/chosen_arms = null
	var/points
	var/points_threshold = 150
	var/usable_cooldown
	var/usable_cooldown_time = 5 MINUTES
	var/healing_cooldown
	var/healing_cooldown_time = 3 MINUTES

	var/list/lock_sounds = list(
		'sound/abnormalities/lighthammer/hammer_filterOut1.ogg',
		'sound/abnormalities/lighthammer/hammer_filterOut2.ogg',
	)
	var/list/pickup_sounds = list(
		'sound/abnormalities/lighthammer/hammer_usable1.ogg',
		'sound/abnormalities/lighthammer/hammer_usable2.ogg',
	)

// Work Mechanic
/mob/living/simple_animal/hostile/abnormality/hammer_light/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(healing_cooldown >= world.time)
		return
	healing_cooldown = world.time + usable_cooldown_time
	var/available_heals = 5
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!available_heals)
			return
		if(H.z != z)
			continue
		if(H.sanity_lost)
			continue
		if((H.health > (H.maxHealth * 0.5)) && H.sanityhealth > (H.maxSanity * 0.5))
			continue
		available_heals -= 1
		new /obj/effect/temp_visual/heal(get_turf(H))
		H.apply_status_effect(/datum/status_effect/heroism)
		playsound(get_turf(H), 'sound/abnormalities/crying_children/sorrow_shot.ogg', 25, FALSE, 3)
		new /obj/effect/temp_visual/beam_in(get_turf(H))

// Lock/Unlocking system
/mob/living/simple_animal/hostile/abnormality/hammer_light/Initialize()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(Check))
	RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH, PROC_REF(Check))

/mob/living/simple_animal/hostile/abnormality/hammer_light/proc/Check() // A lot going on here, but basically we assess how bad the situation in the facility is
	if((!hammer_present) || usable_cooldown > world.time)
		return
	points = 0
	for(var/mob/living/simple_animal/hostile/abnormality/A in GLOB.abnormality_mob_list) // How many breaching abnormalities? How dangerous are they?
		if(A.IsContained())
			continue
		if(A.z != z)
			continue
		switch(A.threat_level)
			if(ZAYIN_LEVEL)
				points += 5 // practically nothing
			if(TETH_LEVEL)
				points += 20
			if(HE_LEVEL)
				points += 40
			if(WAW_LEVEL)
				points += 60
			if(ALEPH_LEVEL)
				points += 80
			else
				continue

	if(LAZYLEN(SSlobotomy_corp.current_ordeals)) // Is there an ordeal? How dangerous is it?
		for(var/datum/ordeal/O in SSlobotomy_corp.current_ordeals)
			points += (O.level * 20)

	var/playercount = get_active_player_count()
	for(var/mob/dead/observer/G in GLOB.player_list) // How many dead players are there?
		if(G.started_as_observer) // Exclude people who started as observers
			continue
		if(!G.mind)
			continue
		points += (100 / playercount) // A dead guy has more impact if there's less people, so we run a quick calculation

	if(points >= points_threshold) // If we have enough points, we unseal
		if(sealed)
			playsound(get_turf(src), 'sound/abnormalities/lighthammer/chain.ogg', 75, 0, -9)
		sealed = FALSE
	else
		if(!sealed) // If we don't have enough points, we seal
			playsound(get_turf(src), "[pick(lock_sounds)]", 75, 0, -9)
		sealed = TRUE
	update_icon()

// Overlays
/mob/living/simple_animal/hostile/abnormality/hammer_light/PostSpawn()
	..()
	update_icon()
	playsound(get_turf(src), "[pick(lock_sounds)]", 75, 0, -9)

/mob/living/simple_animal/hostile/abnormality/hammer_light/update_overlays()
	. = ..()
	if(hammer_present)
		. += "hammer_light"
		if(sealed)
			. += "hammer_lock"

/mob/living/simple_animal/hostile/abnormality/hammer_light/funpet(mob/petter)
	if(!ishuman(petter))
		return
	var/mob/living/carbon/human/H = petter
	if(!hammer_present)
		to_chat(H, span_warning("The hammer is not there!"))
		return
	if(sealed)
		to_chat(H, span_warning("The hammer is sealed!"))
		return
	if(get_user_level(H) <= 1)
		to_chat(H, span_warning("Your body is reduced to atoms by the power of [src]!"))
		H.dust()
		return
	PickUpHammer(H)
	return

// User-related Code
/mob/living/simple_animal/hostile/abnormality/hammer_light/proc/PickUpHammer(mob/living/carbon/human/user)
	if(user.ckey in banned)
		to_chat(user, span_warning("[src] rejects you, not even reacting to your presence at all. You feel empty inside."))
		return
	points_threshold += 150
	usable_cooldown = world.time + usable_cooldown_time
	banned += user.ckey
	current_user = user
	RegisterSignal(current_user, COMSIG_LIVING_DEATH, PROC_REF(UserDeath))
	user.apply_status_effect(STATUS_EFFECT_EVENING_TWILIGHT)
	chosen_arms = new /obj/item/ego_weapon/hammer_light(get_turf(user))
	user.put_in_hands(chosen_arms, forced = TRUE)
	hammer_present = FALSE
	playsound(get_turf(src), "[pick(pickup_sounds)]", 75, 0, -9)
	ADD_TRAIT(user, TRAIT_COMBATFEAR_IMMUNE, "Abnormality")
	ADD_TRAIT(user, TRAIT_WORK_FORBIDDEN, "Abnormality")
	ADD_TRAIT(user, TRAIT_IGNOREDAMAGESLOWDOWN, "Abnormality")
	ADD_TRAIT(user, TRAIT_NODROP, "Abnormality")
	user.hairstyle = "Bald"
	user.update_hair()
	update_icon()
	addtimer(CALLBACK(src, PROC_REF(HammerCheck)), 3050) // max duration of buff + 5 seconds
	new /obj/effect/temp_visual/beam_in(get_turf(user))

/mob/living/simple_animal/hostile/abnormality/hammer_light/proc/HammerCheck()
	if((isnull(chosen_arms) || QDELETED(chosen_arms)) && !hammer_present)
		RecoverHammer()

/mob/living/simple_animal/hostile/abnormality/hammer_light/proc/RecoverHammer()
	qdel(chosen_arms)
	chosen_arms = null
	current_user = null
	sealed = TRUE
	hammer_present = TRUE
	playsound(get_turf(src), "[pick(lock_sounds)]", 75, 0, -9)
	update_icon()

/mob/living/simple_animal/hostile/abnormality/hammer_light/proc/UserDeath(mob/living/carbon/human/user)
	UnregisterSignal(current_user, COMSIG_LIVING_DEATH)
	if(!QDELETED(current_user)) // in case they died without being dusted
		current_user.dust()
	RecoverHammer()

// Pink Midnight
/mob/living/simple_animal/hostile/abnormality/hammer_light/BreachEffect(mob/living/carbon/human/user, breach_type = BREACH_NORMAL)
	if(!hammer_present)
		return FALSE
	if(breach_type != BREACH_PINK)
		return FALSE
	hammer_present = FALSE
	sealed = FALSE
	update_icon()
	var/mob/living/simple_animal/hostile/ordeal/pink_midnight/P = locate() in GLOB.ordeal_list
	if(!P)
		return FALSE
	var/turf/destination = get_turf(P)
	var/turf/W = pick(GLOB.department_centers) // spawn hammers at a random department
	for(var/turf/T in orange(1, W))
		new /obj/effect/temp_visual/dir_setting/cult/phase
		if(prob(50))
			var/mob/living/simple_animal/hostile/lighthammer/V = new(T)
			new /obj/effect/temp_visual/beam_in(T)
			V.faction = P.faction.Copy()
			if(!destination)
				continue
			if(!V.patrol_to(destination)) // Move them to pink midnight
				V.forceMove(destination)
	addtimer(CALLBACK(src, PROC_REF(UserDeath)), usable_cooldown_time)
	return TRUE

// Item version
/obj/item/ego_weapon/hammer_light
	name = "hammer of light"
	desc = "The $0 \[Hammer of Light\] is such a simple abnormality. It takes as much it gave to you. What price will you pay to it?"
	special = "Use in hand to summon an army of spectral warriors to your location."
	icon_state = "hammer_light"
	lefthand_file = 'icons/mob/inhands/64x64_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/64x64_righthand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 40
	damtype = BRUTE //Ignores armor for our intents and purposes.
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")
	hitsound = 'sound/abnormalities/lighthammer/hammer_filter.ogg'
	var/list/spawned_mobs = list()
	var/spawned_mob_max = 4
	var/spawn_cooldown = 0
	var/spawn_cooldown_time = 20 SECONDS
	var/banned_list = list(/mob/living/simple_animal/hostile/megafauna/apocalypse_bird)
	var/obj/effect/proc_holder/ability/hammer_ability = /obj/effect/proc_holder/ability/evening_twilight

/obj/item/ego_weapon/hammer_light/Initialize()
	. = ..()
	var/obj/effect/proc_holder/ability/AS = new hammer_ability
	var/datum/action/spell_action/ability/item/A = AS.action
	A.SetItem(src)

/obj/item/ego_weapon/hammer_light/CanUseEgo(mob/living/carbon/human/user)
	. = ..()
	var/datum/status_effect/evening_twilight/E = user.has_status_effect(/datum/status_effect/evening_twilight)
	if(!E)
		to_chat(user, span_notice("You cannot use [src], only the abnormality's chosen can!"))
		return FALSE

/obj/item/ego_weapon/hammer_light/EgoAttackInfo(mob/user)
	return span_notice("It deals damage that ignores armor, and inflicts massive damage on stronger foes.")

/obj/item/ego_weapon/hammer_light/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!CanUseEgo(user))
		to_chat(user, span_warning("The [src] burns in your hands!"))
		user.dropItemToGround(src)
		return
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/ego_weapon/hammer_light/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(spawn_cooldown >= world.time)
		return
	spawn_cooldown = world.time + spawn_cooldown_time
	if(LAZYLEN(spawned_mobs))
		for(var/mob/living/L in spawned_mobs)
			qdel(L)
	listclearnulls(spawned_mobs)
	var/directions = GLOB.cardinals.Copy()
	for(var/i=spawned_mob_max, i>=1, i--)	// This counts down.
		var/turf/T = (get_step(user,pick_n_take(directions)))
		var/mob/living/simple_animal/hostile/lighthammer/V = new(T)
		new /obj/effect/temp_visual/beam_in(T)
		V.summoned = TRUE
		spawned_mobs+=V
		V.faction = user.faction.Copy()
	playsound(user, 'sound/weapons/black_silence/snap.ogg', 50, FALSE)

/obj/item/ego_weapon/hammer_light/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	if(target.type in banned_list)
		return
	var/statbonus
	for(var/attribute in user.attributes)
		var/attribute_level = get_raw_level(user, attribute)
		statbonus += attribute_level
	var/damage_multiplier = (clamp(statbonus * 0.25,0, 130) * 0.01)
	var/damage_mod = (40 * damage_multiplier) // A damage bonus of up to 130% at max stats, multiplied again by justice
	var/damage_bonus = clamp(target.maxHealth * 0.025,0, 250)
	force += (damage_mod + damage_bonus)
	if(faction_check(target))	 // Brute damage causes runtimes, and this thing does INSANE, unblockable damage. I dont want people getting unfairly killed
		force = 5
		to_chat(user, span_warning("The [src] rejects the attempted killing of [target] this way!"))
	..()
	force = initial(force)
	damtype = initial(damtype)

/obj/item/ego_weapon/hammer_light/get_clamped_volume()
	return 40

// Item's teleport ability
/obj/effect/proc_holder/ability/evening_twilight
	name = "Evening Twilight"
	desc = "An ability that teleports you to the nearest non-visible threat."
	action_icon_state = "gold0"
	base_icon_state = "gold"
	cooldown_time = 25 SECONDS

/obj/effect/proc_holder/ability/evening_twilight/Perform(mob/living/simple_animal/hostile/target, mob/user)
	if(!istype(user))
		return ..()
	cooldown = world.time + (2 SECONDS)
	target = null
	var/dist = 100
	for(var/mob/living/simple_animal/hostile/H in GLOB.alive_mob_list)
		if(H.z != user.z)
			continue
		if(H.stat == DEAD)
			continue
		if(H.status_flags & GODMODE)
			continue
		if(user.faction_check_mob(H, FALSE))
			continue
		if(H in view(7, user))
			continue
		var/t_dist = get_dist(user, H)
		if(t_dist >= dist)
			continue
		dist = t_dist
		target = H
	if(!target)
		to_chat(user, span_notice("You can't find anything else nearby!"))
		return ..()
	playsound(user, 'sound/weapons/black_silence/unlock.ogg', 50, FALSE)
	new /obj/effect/temp_visual/beam_in(get_turf(user))
	new /obj/effect/temp_visual/beam_in(get_turf(target))
	user.forceMove(get_turf(target))
	sleep(2.5)
	if(get_dist(user, target) <= 1)
		var/obj/item/held = user.get_active_held_item()
		if(held)
			held.attack(target, user)
	return ..()

// Status Effects
// Evening Twilight - An armor buff applied to whomever picks up the hammer
/datum/status_effect/evening_twilight
	id = "evening_twilight"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 5 MINUTES // max duration
	alert_type = null
	var/attribute_bonus = 0

/datum/status_effect/evening_twilight/on_apply()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	to_chat(status_holder, span_nicegreen("You feel powerful."))
	status_holder.add_overlay(mutable_appearance('ModularTegustation/Teguicons/32x32.dmi', "hammer_overlay", -ABOVE_MOB_LAYER))
	status_holder.physiology.red_mod *= 0.3
	status_holder.physiology.white_mod *= 0.3
	status_holder.physiology.black_mod *= 0.3
	status_holder.physiology.pale_mod *= 0.3
	duration = min(get_user_level(status_holder) * 300, initial(duration)) // 30 seconds per level, so a max of about 3.5 minutes at 130/all.
	return ..()

/datum/status_effect/evening_twilight/on_remove()
	if(!ishuman(owner))
		return
	var/mob/living/status_holder = owner
	status_holder.dust()
	return ..()

// Heroism - A powerful healing effect applied to people at low hp by the work mechanic. Heals 30% of HP/HP over 3 seconds
/datum/status_effect/heroism
	id = "heroism"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 6 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/heroism

/atom/movable/screen/alert/status_effect/heroism
	name = "Heroism"
	desc = "You are quickly recovering HP and SP due to the effects of hammer of light."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "rest"

/datum/status_effect/heroism/tick()
	. = ..()
	var/mob/living/carbon/human/status_holder = owner
	var/heal_factor = 0.05
	if(status_holder.sanity_lost)
		heal_factor = 0.025
	status_holder.adjustSanityLoss(-status_holder.maxSanity * heal_factor)
	status_holder.adjustBruteLoss(-status_holder.maxHealth * heal_factor)

// Simple mob
/mob/living/simple_animal/hostile/lighthammer
	name = "Light Being"
	desc = "What appears to be human, only made entirely out of light."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "light_hammer"
	icon_living = "light_hammer"
	icon_dead = "light_hammer"
	speak_emote = list("intones", "echoes")
	gender = NEUTER
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	attack_sound = 'sound/abnormalities/lighthammer/hammer_filter.ogg'
	health = 1000
	maxHealth = 1000
	faction = list("neutral") // Should always be overridden
	obj_damage = 300
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	melee_damage_type = PALE_DAMAGE
	melee_damage_lower = 20
	melee_damage_upper = 30
	speed = 5
	move_to_delay = 3
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	density = TRUE
	var/summoned = FALSE
	var/life_tick = 10

/mob/living/simple_animal/hostile/lighthammer/Life()
	. = ..()
	if(summoned)
		if(life_tick > 0)
			life_tick -= 1
			return
		qdel(src) // They're on a timer

// Visual effect
/obj/effect/temp_visual/beam_in
	name = "light beam"
	desc = "A beam of light"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "beamin"
	pixel_x = -32
	base_pixel_x = -32
	randomdir = FALSE
	duration = 1 SECONDS
	layer = POINT_LAYER

#undef STATUS_EFFECT_EVENING_TWILIGHT
