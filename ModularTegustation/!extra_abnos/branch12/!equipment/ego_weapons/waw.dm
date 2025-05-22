

// --------WAW---------
//Plagiarism
/obj/item/ego_weapon/branch12/plagiarism
	name = "plagiarism"
	desc = "This is my, my work!."
	special = "This weapon has a random damage type, also you are able to turn on 'Idea Theift'. Which causes this weapon to consume 8 Mental Decay from the target, to inflict Mental Detonation. <br><br>\
	(Mental Detonation: Does nothing until it is 'Shattered.' Once it is 'Shattered,' it will cause Mental Decay to trigger without reducing it's stack. Weapons that cause 'Shatter' gain other benefits as well.) <br>\
	(Mental Decay: Deals White damage every 5 seconds, equal to its stack, and then halves it. If it is on a mob, then it deals *4 more damage.)"
	icon_state = "plagiarism"
	force = 60
	swingstyle = WEAPONSWING_LARGESWEEP
	damtype = RED_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/fixer/generic/knife3.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60
							)
	var/active = FALSE
	var/detonation_breakpoint = 8

/obj/item/ego_weapon/branch12/plagiarism/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(active)
		active = FALSE
		to_chat(user,span_warning("You turn off your idea theift..."))
		return
	if(!active)
		active = TRUE
		to_chat(user,span_warning("You turn on your idea theift..."))
		return

/obj/item/ego_weapon/branch12/plagiarism/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	damtype = pick(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	var/datum/status_effect/stacking/lc_mental_decay/D = target.has_status_effect(/datum/status_effect/stacking/lc_mental_decay)
	if(D.stacks >= detonation_breakpoint)
		D.stacks -= detonation_breakpoint
		target.apply_status_effect(/datum/status_effect/mental_detonate)
	..()

//Degrading Honor
/obj/item/ego_weapon/branch12/honor
	name = "degrading honor"
	desc = "The whole art of life consists in belonging to oneself."
	special = "With a 1 minute cooldown, Using it in hand you are able to inspire your fellow workers by giving them a 40% damage buff for 5 seconds at the cost of some of your SP. <br>\
	This also all hostile mobs that you can see are inflicted with 6 Mental Decay. <br><br>\
	(Mental Decay: Deals White damage every 5 seconds, equal to its stack, and then halves it. If it is on a mob, then it deals *4 more damage.)"
	icon_state = "honor"
	force = 60
	reach = 2		//Has 2 Square Reach.
	stuntime = 5	//Longer reach, gives you a short stun.
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/fixer/generic/nail1.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 80
							)
	var/warcry_cooldown
	var/warcry_cooldown_time = 60 SECONDS
	var/list/affected = list()
	var/range = 5
	var/affect_self = TRUE
	var/justice_buff = 40
	var/sp_cost = 20
	var/inflicted_mental_decay = 6

/obj/item/ego_weapon/branch12/honor/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(warcry_cooldown > world.time)
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/commander = user
	commander.adjustSanityLoss(sp_cost)
	warcry_cooldown = world.time + warcry_cooldown_time
	commander.say("SLAY THEM, FOR THE QUEEN!", list("colossus","yell"), sanitize = FALSE)
	playsound(commander, 'sound/magic/clockwork/invoke_general.ogg', 50, TRUE, 4)
	for(var/mob/living/simple_animal/hostile/H in view(range, get_turf(src)))
		H.apply_lc_mental_decay(inflicted_mental_decay)
	for(var/mob/living/carbon/human/human in view(range, get_turf(src)))
		if (human == commander && !affect_self)
			continue
		human.adjust_attribute_buff(JUSTICE_ATTRIBUTE, justice_buff)
		affected+=human

	addtimer(CALLBACK(src, PROC_REF(Warcry), commander), 0.5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	addtimer(CALLBACK(src, PROC_REF(RemoveBuff), commander), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)


/obj/item/ego_weapon/branch12/honor/proc/Warcry(mob/user)
	for(var/mob/living/carbon/human/human in affected)
		if(human == user)
			continue
		human.say("FOR THE QUEEN!")

/obj/item/ego_weapon/branch12/honor/proc/RemoveBuff(mob/user)
	for(var/mob/living/carbon/human/human in affected)
		if (human == user && !affect_self)
			continue
		human.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -justice_buff)
		affected-=human

/obj/item/ego_weapon/honor/get_clamped_volume()
	return 25

//Fluttering Passion
/obj/item/ego_weapon/branch12/passion
	name = "fluttering passion"
	desc = "When a red butterfly appears at a funeral, it�s believed that the butterfly is the passion they once had."
	special = "On hit, if you have less then 50% HP, heal SP and HP. If the target has less then 50% HP, increase your attack speed against that target."
	icon_state = "passion"
	force = 60
	stuntime = 5	//Stronger, so has quite the stun
	attack_speed = 1.5	//and is a bit slower
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("chops")
	attack_verb_simple = list("chop")
	hitsound = 'sound/abnormalities/woodsman/woodsman_attack.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)
	var/healing_on_hit = 5
	var/inflicted_bleed = 3

/obj/item/ego_weapon/branch12/passion/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return FALSE
	if(isliving(target))
		target.apply_lc_bleed(inflicted_bleed)
		if(target.health < target.maxHealth * 0.5)
			attack_speed = 0.75
			stuntime = 0
			to_chat(user, span_nicegreen("May their death, bring forth passion..."))
		else
			stuntime = 5
			attack_speed = 1.5
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.health < H.maxHealth * 0.5)
			H.adjustSanityLoss(-healing_on_hit)
			H.adjustBruteLoss(-healing_on_hit)
			to_chat(H, span_nicegreen("Within this passion of death, we find love..."))

//Average Joe
/obj/item/ego_weapon/branch12/joe
	name = "average joe"
	desc = "A good briefcase is your best friend. It can carry a lot of important documents, your pencils, and your lunch! It can even be a good self-defense tool!"
	special = "You are able to turn on abnormality deterrence, which lets you make the foes you attack ignore you, at the cost of your SP. Also, when you attack foes who are not targeting you, you inflict 4 Mental Decay. You also inflict Mental Detonation if the target has 15+ Mental Decay<br><br>\
	(Mental Decay: Deals White damage every 5 seconds, equal to its stack, and then halves it. If it is on a mob, then it deals *4 more damage.)<br>\
	(Mental Detonation: Does nothing until it is 'Shattered.' Once it is 'Shattered,' it will cause Mental Decay to trigger without reducing it's stack. Weapons that cause 'Shatter' gain other benefits as well.)"
	icon_state = "joe"
	force = 72
	attack_speed = 2
	damtype = WHITE_DAMAGE
	knockback = KNOCKBACK_LIGHT
	attack_verb_continuous = list("bashes", "clubs")
	attack_verb_simple = list("bashes", "clubs")
	hitsound = 'sound/weapons/fixer/generic/club1.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
	var/active = FALSE
	var/range = 4
	var/list/other_targets = list()
	var/sp_cost = 45
	var/inflicted_decay = 4
	var/detonation_breakpoint = 15

/obj/item/ego_weapon/branch12/joe/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(active)
		active = FALSE
		to_chat(user,span_warning("You turn off your abnormality deterrence..."))
		return
	if(!active)
		active = TRUE
		to_chat(user,span_warning("You turn on your abnormality deterrence..."))
		return

/obj/item/ego_weapon/branch12/joe/attack(mob/living/target, mob/living/user)
	..()
	var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
	var/justicemod = 1 + userjust / 100
	var/extra_damage = force * justicemod
	target.deal_damage(-extra_damage, AGGRO_DAMAGE)
	if(ishostile(target))
		var/mob/living/simple_animal/hostile/blindfool = target
		if(blindfool.target != user)
			blindfool.apply_lc_mental_decay(inflicted_decay)
			var/datum/status_effect/stacking/lc_mental_decay/D = blindfool.has_status_effect(/datum/status_effect/stacking/lc_mental_decay)
			if(D.stacks >= detonation_breakpoint)
				blindfool.apply_status_effect(/datum/status_effect/mental_detonate)
	if(active)
		if(ishuman(user))
			var/mob/living/carbon/human/joe = user
			for(var/mob/living/carbon/human/human in view(range, get_turf(src)))
				if(human == user)
					continue
				else if(human.stat == DEAD)
					continue
				else
					other_targets += human
			if(ishostile(target))
				var/mob/living/simple_animal/hostile/getawayplease = target
				if(other_targets && getawayplease.target == user)
					shuffle_inplace(other_targets)
					var/killthem = other_targets[1]
					getawayplease.GiveTarget(killthem)
					to_chat(user, span_nicegreen("Ignore me, am just a normal joe..."))
					joe.adjustSanityLoss(sp_cost)
	other_targets = list()

//Medea
/obj/item/ego_weapon/ranged/branch12/mini/medea
	name = "medea"
	desc = "Mortal fate is hard. You'd best get used to it."
	special = "You are able to activate 'Dead Eye' mode while wielding this weapon. While 'Dead Eye' is active, your shots take 2 extra seconds to fire, but they become piercing and deal 30% more damage. <br>\
	Also, while you are using Deadeye mode, if you hit someone with Mental Detonation, you will cause a Shatter, which will cause the bullet to deal 200% more damage, and inflict 10 Mental Decay to all nearby mobs.<br><br>\
	(Mental Detonation: Does nothing until it is 'Shattered.' Once it is 'Shattered,' it will cause Mental Decay to trigger without reducing it's stack. Weapons that cause 'Shatter' gain other benefits as well.) <br>\
	(Mental Decay: Deals White damage every 5 seconds, equal to its stack, and then halves it. If it is on a mob, then it deals *4 more damage.)"
	icon_state = "medea"
	inhand_icon_state = "medea"
	force = 14
	damtype = PALE_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/branch12/medea
	fire_delay = 10
	shotsleft = 5
	reloadtime = 2.1 SECONDS
	fire_sound = 'sound/weapons/gun/pistol/deagle.ogg'
	vary_fire_sound = FALSE
	weapon_weight = WEAPON_HEAVY
	fire_sound_volume = 70
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)
	var/lock_on = TRUE
	var/lock_on_time = 2.5 SECONDS
	var/aiming = FALSE

/obj/item/ego_weapon/ranged/branch12/mini/medea/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(lock_on)
		lock_on = FALSE
		to_chat(user,span_warning("You turn off your dead eye aimming..."))
	else
		lock_on = TRUE
		to_chat(user,span_warning("You turn on your dead eye aimming..."))
	. = ..()

/obj/item/ego_weapon/ranged/branch12/mini/medea/afterattack(atom/target, mob/living/user, flag, params)
	if (aiming)
		to_chat(user, span_warning("You are already aiming at someone!"))
		return
	. = ..()

/obj/item/ego_weapon/ranged/branch12/mini/medea/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, temporary_damage_multiplier = 1)
	if(!CanUseEgo(user))
		return
	if(lock_on)
		to_chat(user, span_warning("You start aiming for [target]..."))
		playsound(user, 'sound/abnormalities/freischutz/prepare.ogg', 35, TRUE, 20)
		aiming = TRUE
		if(do_after(user, lock_on_time, src))
			projectile_path = /obj/projectile/ego_bullet/branch12/medea/big
			fire_sound = 'sound/abnormalities/freischutz/shoot.ogg'
			. = ..()
			fire_sound = 'sound/weapons/gun/pistol/deagle.ogg'
			projectile_path = /obj/projectile/ego_bullet/branch12/medea
		aiming = FALSE
	else
		aiming = FALSE
		. = ..()

/obj/projectile/ego_bullet/branch12/medea
	name = "medea"
	damage = 70
	damage_type = PALE_DAMAGE

/obj/projectile/ego_bullet/branch12/medea/big
	icon_state = "magic_bullet"
	damage = 90
	speed = 0.1
	projectile_piercing = PASSMOB
	range = 18 // Don't want people shooting it through the entire facility
	hit_nondense_targets = TRUE

/obj/projectile/ego_bullet/branch12/medea/big/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		var/datum/status_effect/mental_detonate/D = L.has_status_effect(/datum/status_effect/mental_detonate)
		if(D)
			D.shatter()
			L.deal_damage(damage*2, damage_type)
			for(var/mob/living/simple_animal/hostile/H in view(3, get_turf(src)))
				H.apply_lc_mental_decay(10)

//10000dolers
/obj/item/ego_weapon/branch12/mini/ten_thousand_dolers
	name = "100000 Dollars"
	desc = "Build it all up, to cash it in..."
	special = "Each time you attack with this weapon, You will throw out some coins (You can also use this weapon as a ranged weapon to throw out coins). However these coins are very inaccurate. These coins exist for 8 seconds before fading away. <br>\
	When you use this weapon in hand, you will recall all coins. With them dealing RED damage to any hostile they fly through, and inflicting 2 Mental Decay per coin. <br><br>\
	(Mental Decay: Deals White damage every 5 seconds, equal to its stack, and then halves it. If it is on a mob, then it deals *4 more damage.)"
	icon_state = "blue_coin"
	inhand_icon_state = "blue_coin"
	force = 34
	damtype = RED_DAMAGE
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60
							)
	var/ranged_cooldown
	var/ranged_cooldown_time = 0.5 SECONDS
	var/recall_cooldown
	var/recall_cooldown_time = 8 SECONDS
	var/ranged_range = 7

/obj/item/ego_weapon/branch12/mini/ten_thousand_dolers/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(recall_cooldown > world.time)
		return
	recall_cooldown = world.time + recall_cooldown_time
	to_chat(user, span_nicegreen("[src] recalls all nearby coins!"))
	playsound(get_turf(user), 'sound/magic/arbiter/repulse.ogg', 60, 0, 5)
	for(var/mob/living/simple_animal/hostile/blue_coin/C in view(9, get_turf(user)))
		C.recall(user)

/obj/item/ego_weapon/branch12/mini/ten_thousand_dolers/attack(mob/living/target, mob/living/user)
	. = ..()
	var/turf/origin = get_turf(target)
	var/list/all_turfs = RANGE_TURFS(1, origin)
	for(var/turf/T in shuffle(all_turfs))
		if (T.is_blocked_turf(exclude_mobs = TRUE))
			continue
		var/mob/living/simple_animal/hostile/blue_coin/placed_coin = new (T)
		var/random_x = rand(-16, 16)
		placed_coin.pixel_x += random_x
		var/random_y = rand(-16, 16)
		placed_coin.pixel_y += random_y
		break

/obj/item/ego_weapon/branch12/mini/ten_thousand_dolers/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(ranged_cooldown > world.time)
		return
	if(!CanUseEgo(user))
		return
	var/turf/target_turf = get_turf(A)
	if(!istype(target_turf))
		return
	if(!(target_turf in view(ranged_range, user)))
		return
	..()
	var/turf/projectile_start = get_turf(user)
	ranged_cooldown = world.time + ranged_cooldown_time
	playsound(get_turf(src), 'sound/effects/cashregister.ogg', 25, 3, 3)

	//Stuff for creating the projctile.
	var/obj/projectile/ego_bullet/branch12/blue_coin/B = new(projectile_start)
	B.starting = projectile_start
	B.firer = user
	B.fired_from = projectile_start
	B.yo = target_turf.y - projectile_start.y
	B.xo = target_turf.x - projectile_start.x
	B.original = target_turf
	B.preparePixelProjectile(target_turf, projectile_start)
	B.fire()

/obj/projectile/ego_bullet/branch12/blue_coin
	name = "blue coin"
	icon = 'ModularTegustation/Teguicons/branch12/branch12_weapon.dmi'
	icon_state = "blue_coin"
	damage = 0
	speed = 0.8
	nodamage = TRUE
	projectile_piercing = PASSMOB
	range = 4

/obj/projectile/ego_bullet/branch12/blue_coin/on_range()
	var/turf/origin = get_turf(src)
	var/list/all_turfs = RANGE_TURFS(1, origin)
	for(var/turf/T in shuffle(all_turfs))
		if (T.is_blocked_turf(exclude_mobs = TRUE))
			continue
		var/mob/living/simple_animal/hostile/blue_coin/placed_coin = new (T)
		var/random_x = rand(-16, 16)
		placed_coin.pixel_x += random_x
		var/random_y = rand(-16, 16)
		placed_coin.pixel_y += random_y
		break
	. = ..()

/mob/living/simple_animal/hostile/blue_coin
	name = "blue coin"
	desc = "A blue coin made by 100000 Dollars"
	icon = 'ModularTegustation/Teguicons/branch12/branch12_weapon.dmi'
	icon_state = "blue_coin"
	icon_living = "blue_coin"
	gender = NEUTER
	density = FALSE
	mob_biotypes = MOB_ROBOTIC
	faction = list("neutral")
	health = 50
	maxHealth = 50
	healable = FALSE
	var/dash_damage = 25
	var/inflicted_decay = 2

/mob/living/simple_animal/hostile/blue_coin/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/blue_coin/Move()
	return FALSE

/mob/living/simple_animal/hostile/blue_coin/Initialize()
	QDEL_IN(src, (8 SECONDS))
	. = ..()
	faction = list("neutral")

/mob/living/simple_animal/hostile/blue_coin/proc/recall(mob/recall_target)
	var/turf/slash_start = get_turf(src)
	var/turf/slash_end = get_turf(recall_target)
	var/list/hitline = getline(slash_start, slash_end)
	forceMove(slash_end)
	for(var/turf/T in hitline)
		for(var/mob/living/simple_animal/hostile/L in HurtInTurf(T, list(), dash_damage, RED_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, hurt_structure = FALSE))
			to_chat(L, span_userdanger("[src] quickly flies through you!"))
			L.apply_lc_mental_decay(inflicted_decay)
	new /datum/beam(slash_start.Beam(slash_end, "magic_bullet", time=3))
	playsound(src, attack_sound, 50, FALSE, 4)
	qdel(src)

//Rumor
/obj/item/ego_weapon/branch12/rumor
	name = "rumor"
	desc = "They reached for the stars, only for them to be pulled beyond their reach."
	special = "This weapon inflicts random debuffs to the target, ranging from: 4 Bleed, 4 Burn, Red/White/Black Armor Rend and Healing Block.<br>\
	This weapon also inflicts Mental Decay equal to the number of debuffs the target has (Max of 5). If the target also has Mental Detonation, Shatter it and inflict all of the possible statues effects this weapon can inflict.<br><br>\
	(Mental Detonation: Does nothing until it is 'Shattered.' Once it is 'Shattered,' it will cause Mental Decay to trigger without reducing it's stack. Weapons that cause 'Shatter' gain other benefits as well.) <br>\
	(Mental Decay: Deals White damage every 5 seconds, equal to its stack, and then halves it. If it is on a mob, then it deals *4 more damage.)"
	icon_state = "rumor"
	force = 30
	attack_speed = 1.6
	swingstyle = WEAPONSWING_LARGESWEEP
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("slashes", "slices", "rips", "cuts")
	attack_verb_simple = list("slash", "slice", "rip", "cut")
	hitsound = 'sound/weapons/ego/da_capo2.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
	var/bleed_inflict = 4
	var/burn_inflict = 4
	var/max_decay_infliction = 5

/obj/item/ego_weapon/branch12/rumor/attack(mob/living/target, mob/living/user)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		if(target.status_effects)
			var/inflicted_decay = target.status_effects.len
			if(inflicted_decay >= max_decay_infliction)
				inflicted_decay = max_decay_infliction
			target.apply_lc_mental_decay(inflicted_decay)
		switch(rand(1,6))
			if(1)
				L.apply_lc_bleed(bleed_inflict)
			if(2)
				L.apply_lc_burn(burn_inflict)
			if(3)
				L.apply_status_effect(/datum/status_effect/rend_red)
			if(4)
				L.apply_status_effect(/datum/status_effect/rend_white)
			if(5)
				L.apply_status_effect(/datum/status_effect/rend_black)
			if(6)
				L.apply_status_effect(/datum/status_effect/healing_block)
		var/datum/status_effect/mental_detonate/mark = target.has_status_effect(/datum/status_effect/mental_detonate)
		if(mark)
			mark.shatter()
			L.apply_lc_bleed(bleed_inflict)
			L.apply_lc_burn(burn_inflict)
			L.apply_status_effect(/datum/status_effect/rend_red)
			L.apply_status_effect(/datum/status_effect/rend_white)
			L.apply_status_effect(/datum/status_effect/rend_black)
			L.apply_status_effect(/datum/status_effect/healing_block)

//Icon of Chaos
/obj/item/ego_weapon/ranged/branch12/icon_of_chaos
	name = "Icon of Chaos"
	desc = "Endless chaos comes from this wand."
	special = "The beams from this wand perform various effects."
	icon_state = "chaos"
	inhand_icon_state = "chaos"
	force = 20
	damtype = PALE_DAMAGE
	fire_delay = 10
	projectile_path = /obj/projectile/ego_bullet/enchanted_wand
	fire_sound = 'sound/magic/wandodeath.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 80
							)



//Plasmacore E-6
/obj/item/ego_weapon/ranged/branch12/mini/plasmacoree6
	name = "Plasmacore E-6"
	desc = "A beautiful laser gun coming from a far away space station."
	icon_state = "space"
	inhand_icon_state = "space"
	special = "Use in hand to load bullets."
	force = 20
	projectile_path = /obj/projectile/ego_bullet/plasmacoree6
	spread = 5
	fire_sound = 'sound/weapons/laser3.ogg'
	vary_fire_sound = TRUE
	fire_sound_volume = 30
	fire_delay = 15

	attribute_requirements = list(TEMPERANCE_ATTRIBUTE = 80)
	shotsleft = 5
	reloadtime = 1 SECONDS

/obj/item/ego_weapon/ranged/branch12/mini/plasmacoree6/reload_ego(mob/user)
	if(shotsleft == initial(shotsleft))
		return
	is_reloading = TRUE
	to_chat(user,"<span class='notice'>You start loading a bullet.</span>")
	if(do_after(user, reloadtime, src)) //gotta reload
		playsound(src, 'sound/weapons/gun/general/slide_lock_1.ogg', 50, TRUE)
		shotsleft +=1
	is_reloading = FALSE

/obj/item/ego_weapon/ranged/branch12/antique
	name = "Captain's Antique Laser Gun"
	desc = "A beautiful laser gun coming from a far away space station."
	icon_state = "caplaser"
	inhand_icon_state = "caplaser"
	special = "This gun regenerates bullets over time, instead of being reloaded."
	force = 20
	projectile_path = /obj/projectile/ego_bullet/plasmacoree6
	spread = 5
	fire_sound = 'sound/weapons/laser.ogg'
	vary_fire_sound = TRUE
	fire_sound_volume = 30
	fire_delay = 7

	attribute_requirements = list(FORTITUDE_ATTRIBUTE = 80)
	shotsleft = 15

/obj/item/ego_weapon/ranged/branch12/antique/Initialize()
	..()
	addtimer(CALLBACK(src, PROC_REF(charge)), 10 SECONDS)

/obj/item/ego_weapon/ranged/branch12/antique/proc/charge()
	addtimer(CALLBACK(src, PROC_REF(charge)), 10 SECONDS)

	if(shotsleft <= initial(shotsleft))
		shotsleft++

/obj/item/ego_weapon/ranged/branch12/antique/reload_ego(mob/user)
	to_chat(user,"<span class='notice'>You see no way to reload this EGO.</span>")

/obj/projectile/ego_bullet/plasmacoree6
	name = "plasmacore e6"
	icon_state = "heavylaser"
	damage = 60
	damage_type = RED_DAMAGE
