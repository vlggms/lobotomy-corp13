/* Fragment of the Universe - One with the Universe */
/obj/effect/proc_holder/ability/universe_song
	name = "Song of the Universe"
	desc = "An ability that allows its user to damage and slow down the enemies around them."
	action_icon_state = "universe_song0"
	base_icon_state = "universe_song"
	cooldown_time = 20 SECONDS

	var/damage_amount = 25 // Amount of white damage dealt to enemies per "pulse".
	var/damage_slowdown = 0.6 // Slowdown per pulse
	var/damage_count = 5 // How many times the damage and slowdown is applied
	var/damage_range = 6

/obj/effect/proc_holder/ability/universe_song/Perform(target, mob/user)
	playsound(get_turf(user), 'sound/abnormalities/fragment/sing.ogg', 50, 0, 4)
	Pulse(user)
	for(var/i = 1 to damage_count - 1)
		addtimer(CALLBACK(src, .proc/Pulse, user), i*3)
	return ..()

/obj/effect/proc_holder/ability/universe_song/proc/Pulse(mob/user)
	new /obj/effect/temp_visual/fragment_song(get_turf(user))
	for(var/mob/living/L in view(damage_range, user))
		if(user.faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		L.apply_damage(damage_amount, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE))
		new /obj/effect/temp_visual/revenant(get_turf(L))
		if(ishostile(L))
			var/mob/living/simple_animal/hostile/H = L
			H.TemporarySpeedChange(damage_slowdown, 5 SECONDS) // Slow down

/* Judgement Bird - Head of God */
/obj/effect/proc_holder/ability/judgement
	name = "Soul Judgement"
	desc = "An ability that damages all enemies around the user and increases their weakness to pale damage."
	action_icon_state = "judgement0"
	base_icon_state = "judgement"
	cooldown_time = 20 SECONDS

	var/damage_amount = 150 // Amount of pale damage dealt to enemies. Humans receive half of it.
	var/damage_range = 9

/obj/effect/proc_holder/ability/judgement/Perform(target, mob/user)
	cooldown = world.time + (2 SECONDS)
	playsound(get_turf(user), 'sound/abnormalities/judgementbird/pre_ability.ogg', 50, 0)
	var/obj/effect/temp_visual/judgement/still/J = new (get_turf(user))
	animate(J, pixel_y = 24, time = 1.5 SECONDS)
	if(!do_after(user, 1.5 SECONDS))
		to_chat(user, "<span class='warning'>You must stand still to perform judgement!</span>")
		return
	playsound(get_turf(user), 'sound/abnormalities/judgementbird/ability.ogg', 75, 0, 2)
	for(var/mob/living/L in view(damage_range, user))
		if(user.faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		new /obj/effect/temp_visual/judgement(get_turf(L))
		L.apply_damage(ishuman(L) ? damage_amount*0.5 : damage_amount, PALE_DAMAGE, null, L.run_armor_check(null, PALE_DAMAGE))
		L.apply_status_effect(/datum/status_effect/judgement_pale_debuff)
	return ..()

/datum/status_effect/judgement_pale_debuff
	id = "judgement_pale_debuff"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 15 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/judgement_pale_debuff

/datum/status_effect/judgement_pale_debuff/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.physiology.pale_mod /= 1.5
		return
	var/mob/living/simple_animal/M = owner
	if(M.damage_coeff[PALE_DAMAGE] <= 0)
		qdel(src)
		return
	M.damage_coeff[PALE_DAMAGE] += 0.5

/datum/status_effect/judgement_pale_debuff/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.physiology.pale_mod *= 1.5
		return
	var/mob/living/simple_animal/M = owner
	M.damage_coeff[PALE_DAMAGE] -= 0.5

/atom/movable/screen/alert/status_effect/judgement_pale_debuff
	name = "Soul Drain"
	desc = "Your sinful actions have made your soul more vulnerable to PALE attacks."
	icon = 'icons/mob/actions/actions_ability.dmi'
	icon_state = "judgement"

/obj/effect/proc_holder/ability/fire_explosion
	name = "Match flame"
	desc = "An ability that deals high amount of RED damage to EVERYONE around the user after short delay."
	action_icon_state = "fire0"
	base_icon_state = "fire"
	cooldown_time = 30 SECONDS
	var/explosion_damage = 1000 // Humans receive half of it.
	var/explosion_range = 6

/obj/effect/proc_holder/ability/fire_explosion/Perform(target, mob/user)
	cooldown = world.time + (5 SECONDS)
	playsound(get_turf(user), 'sound/abnormalities/scorchedgirl/pre_ability.ogg', 50, 0, 2)
	if(!do_after(user, 1.5 SECONDS))
		to_chat(user, "<span class='warning'>You must stand still to ignite the explosion!</span>")
		return
	playsound(get_turf(user), 'sound/abnormalities/scorchedgirl/ability.ogg', 60, 0, 4)
	var/obj/effect/temp_visual/human_fire/F = new(get_turf(user))
	F.alpha = 0
	F.dir = user.dir
	animate(F, alpha = 255, time = (2 SECONDS))
	if(!do_after(user, 2.5 SECONDS))
		to_chat(user, "<span class='warning'>You must stand still to finish the ability!</span>")
		animate(F, alpha = 0, time = 5)
		return
	animate(F, alpha = 0, time = 5)
	INVOKE_ASYNC(src, .proc/FireExplosion, get_turf(user))
	return ..()

/obj/effect/proc_holder/ability/fire_explosion/proc/FireExplosion(turf/T)
	playsound(T, 'sound/abnormalities/scorchedgirl/explosion.ogg', 125, 0, 8)
	for(var/i = 1 to explosion_range)
		for(var/turf/open/TT in spiral_range_turfs(i, T) - spiral_range_turfs(i-1, T))
			new /obj/effect/temp_visual/fire(TT)
			for(var/mob/living/L in TT)
				if(L.stat == DEAD)
					continue
				playsound(get_turf(L), 'sound/effects/wounds/sizzle2.ogg', 25, TRUE)
				L.apply_damage(ishuman(L) ? explosion_damage*0.5 : explosion_damage, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE))
		sleep(1)

/* King of Greed - Gold Experience */
/obj/effect/proc_holder/ability/road_of_gold
	name = "The Road of Gold"
	desc = "An ability that teleports you to the nearest non-visible threat."
	action_icon_state = "gold0"
	base_icon_state = "gold"
	cooldown_time = 30 SECONDS

	var/list/spawned_effects = list()

/obj/effect/proc_holder/ability/road_of_gold/Perform(mob/living/simple_animal/hostile/target, mob/user)
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
		to_chat(user, "<span class='notice'>You can't find anything else nearby!</span>")
		return ..()
	Circle(null, null, user)
	var/pre_circle_dir = user.dir
	to_chat(user, "<span class='warning'>You begin along the Road of Gold to your target!</span>")
	if(!do_after(user, 15, src))
		to_chat(user, "<span class='warning'>You abandon your path!</span>")
		CleanUp()
		return ..()
	animate(user, alpha = 0, time = 5)
	step_towards(user, get_step(user, pre_circle_dir))
	new /obj/effect/temp_visual/guardian/phase(get_turf(src))
	var/turf/open/target_turf = get_step_towards(target, user)
	if(!istype(target_turf))
		target_turf = pick(get_adjacent_open_turfs(target))
	if(!target_turf)
		to_chat(user, "<span class='warning'>No road leads to that target!?</span>")
		CleanUp()
		return ..()
	var/obj/effect/qoh_sygil/kog/KS = Circle(target_turf, get_step(target_turf, pick(GLOB.cardinals)), null)
	sleep(5)
	user.dir = get_dir(user, target)
	animate(user, alpha = 255, time = 5)
	new /obj/effect/temp_visual/guardian/phase/out(get_turf(KS))
	user.forceMove(get_turf(KS))
	CleanUp()
	sleep(2.5)
	step_towards(user, get_step_towards(KS, target))
	if(get_dist(user, target) <= 1)
		var/obj/item/held = user.get_active_held_item()
		if(held)
			held.attack(target, user)
	return ..()

/obj/effect/proc_holder/ability/road_of_gold/proc/CleanUp()
	for(var/obj/effect/FX in spawned_effects)
		if(istype(FX, /obj/effect/qoh_sygil/kog))
			var/obj/effect/qoh_sygil/kog/KS = FX
			KS.fade_out()
			continue
		FX.Destroy()
	listclearnulls(spawned_effects)

/obj/effect/proc_holder/ability/road_of_gold/proc/Circle(turf/first_target, turf/second_target, mob/user = null)
	var/obj/effect/qoh_sygil/kog/KS
	if(user)
		KS = new(get_turf(user))
	else
		KS = new(first_target)
	spawned_effects += KS
	var/matrix/M = matrix(KS.transform)
	M.Translate(0, 32)
	var/rot_angle
	var/my_dir
	if(user)
		my_dir = user.dir
		rot_angle = Get_Angle(user, get_step(user, my_dir))
	else
		my_dir = get_dir(first_target, second_target)
		rot_angle = Get_Angle(first_target, get_step_towards(first_target, second_target))
	M.Turn(rot_angle)
	switch(my_dir)
		if(EAST)
			M.Scale(0.5, 1)
			KS.layer += 0.1
		if(WEST)
			M.Scale(0.5, 1)
			KS.layer += 0.1
		if(NORTH)
			M.Scale(1, 0.5)
			KS.layer += 0.1
		if(SOUTH)
			M.Scale(1, 0.5)
			KS.layer -= 0.1
	KS.transform = M
	return KS

/* Servant of Wrath - Wounded Courage */
/obj/effect/proc_holder/ability/justice_and_balance
	name = "For the Justice and Balance of this Land"
	desc = "An ability with 3 charges. Each use smashes all enemies in the area around you and buffs you, the third charge is amplified. \
		Each hit grants you a temporary bonus to justice, hitting the same target increases this bonus."
	action_icon_state = "justicebalance0"
	base_icon_state = "justicebalance"
	cooldown_time = 1 MINUTES

	var/max_charges = 3
	var/charges = 3
	var/list/spawned_effects = list()
	var/list/SFX = list(
		'sound/abnormalities/wrath_servant/big_smash3.ogg',
		'sound/abnormalities/wrath_servant/big_smash2.ogg',
		'sound/abnormalities/wrath_servant/big_smash1.ogg'
		)
	var/damage = 30
	var/list/targets_hit = list()

/obj/effect/proc_holder/ability/justice_and_balance/Perform(target, user)
	INVOKE_ASYNC(src, .proc/Smash, user, charges)
	charges--
	if(charges < 1)
		charges = max_charges
		targets_hit = list()
		return ..()

/obj/effect/proc_holder/ability/justice_and_balance/proc/Smash(mob/user, on_use_charges)
	playsound(user, SFX[on_use_charges], 25*(4-on_use_charges))
	var/temp_dam = damage
	temp_dam *= 1 + (get_attribute_level(user, JUSTICE_ATTRIBUTE)/100)
	if(on_use_charges <= 1)
		temp_dam *= 1.5
	for(var/turf/open/T in range(3, user))
		if(T.z != user.z)
			continue
		new /obj/effect/temp_visual/small_smoke/halfsecond/green(T)
		for(var/mob/living/L in T)
			if(L.status_flags & GODMODE)
				continue
			if(L == user)
				continue
			if(L.stat == DEAD)
				continue
			if(user.faction_check_mob(L))
				continue
			if(L in targets_hit)
				targets_hit[L] += 1
			else
				targets_hit[L] = 1
			L.apply_damage(temp_dam, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/datum/status_effect/stacking/justice_and_balance/JAB = H.has_status_effect(/datum/status_effect/stacking/justice_and_balance)
	if(!JAB)
		JAB = H.apply_status_effect(/datum/status_effect/stacking/justice_and_balance)
		if(!JAB)
			return
	for(var/hit in targets_hit)
		JAB.add_stacks(targets_hit[hit])

/datum/status_effect/stacking/justice_and_balance
	id = "EGO_JAB"
	status_type = STATUS_EFFECT_UNIQUE
	stacks = 0
	tick_interval = 10
	alert_type = /atom/movable/screen/alert/status_effect/justice_and_balance
	var/next_tick = 0

/atom/movable/screen/alert/status_effect/justice_and_balance
	name = "Justice and Balance"
	desc = "The power to preserve balance is in your hands. \
		Your Justice is increased by "
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "JAB"

/datum/status_effect/stacking/justice_and_balance/process()
	if(!owner)
		qdel(src)
		return
	if(next_tick < world.time)
		tick()
		next_tick = world.time + tick_interval
	if(duration != -1 && duration < world.time)
		qdel(src)

/datum/status_effect/stacking/justice_and_balance/add_stacks(stacks_added)
	if(!ishuman(owner))
		return
	if(stacks <= 0 && stacks_added < 0)
		qdel(src)
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, stacks_added)
	stacks += stacks_added
	linked_alert.desc = initial(linked_alert.desc)+"[stacks]!"
	tick_interval = max(10 - (stacks/10), 0.1)

/datum/status_effect/stacking/justice_and_balance/can_have_status()
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	if(H.stat == DEAD)
		return FALSE
	var/obj/item/clothing/suit/armor/ego_gear/realization/woundedcourage/WC = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(!istype(WC))
		return FALSE
	return TRUE

/obj/effect/proc_holder/ability/petal_blizzard
	name = "Petal Blizzard"
	desc = "Increases damage taken but you make a healing aura."
	action_icon_state = "petalblizzard0"
	base_icon_state = "petalblizzard"
	cooldown_time = 30 SECONDS
	var/damage_amount = 5 // Amount of healing to plater per "pulse".
	var/damage_count = 15 // How many times the healing is applied
	var/damage_range = 10

/obj/effect/proc_holder/ability/petal_blizzard/Perform(target, mob/user)

	Pulse(user)
	var/mob/living/carbon/human/H = user
	to_chat(H, "<span class='userdanger'>You feel frailer!</span>")
	H.apply_status_effect(/datum/status_effect/bloomdebuff)
	for(var/i = 1 to damage_count - 1)
		addtimer(CALLBACK(src, .proc/Pulse, user), i* 3)
	return ..()

/obj/effect/proc_holder/ability/petal_blizzard/proc/Pulse(mob/user)
	new /obj/effect/temp_visual/cherry_aura(get_turf(user))
	var/mob/living/carbon/human/H = user
	if(!H.is_working) //time to suffer
		H.adjustBruteLoss(-damage_amount)
		H.adjustSanityLoss(-damage_amount)
	for(var/mob/living/carbon/human/L in view(damage_range, user))
		if(user.faction_check_mob(L, FALSE))
			if(L.status_flags & GODMODE)
				continue
			if(L == src) //stop hitting yourself
				continue
			if(L.is_working) //no work heal :(
				continue
			if(L.stat == DEAD)
				continue
			if(H.faction_check_mob(L))
				if(L.stat < DEAD && L.stat > CONSCIOUS) // unhealthy but not dead
					L.adjustBruteLoss(-damage_amount)
					L.adjustSanityLoss(-damage_amount)


/datum/status_effect/bloomdebuff
	id = "bloomdebuff"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 15 SECONDS		//Lasts 30 seconds
	alert_type = /atom/movable/screen/alert/status_effect/bloomdebuff

/atom/movable/screen/alert/status_effect/bloomdebuff
	name = "Blooming Sakura"
	desc = "You Take Double Damage."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "marked_for_death"

/datum/status_effect/bloomdebuff/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.physiology.red_mod *= 2
		L.physiology.white_mod *= 2
		L.physiology.black_mod *= 2
		L.physiology.pale_mod *= 2

/datum/status_effect/bloomdebuff/tick()
	var/mob/living/carbon/human/Y = owner
	if(Y.sanity_lost)
		Y.death()
	if(owner.stat == DEAD)
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(H.stat != DEAD)
				H.adjustBruteLoss(-100) // It heals everyone to full
				H.adjustSanityLoss(-100) // It heals everyone to full

/datum/status_effect/bloomdebuff/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		to_chat(L, "<span class='userdanger'>You feel normal!</span>")
		L.physiology.red_mod /= 2
		L.physiology.white_mod /= 2
		L.physiology.black_mod /= 2
		L.physiology.pale_mod /= 2
