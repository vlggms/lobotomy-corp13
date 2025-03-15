
/obj/item/ego_weapon/ranged/branch12
	icon = 'ModularTegustation/Teguicons/branch12/branch12_weapon.dmi'

/obj/item/ego_weapon/branch12
	icon = 'ModularTegustation/Teguicons/branch12/branch12_weapon.dmi'

//Weapons are simple for now.
// --------ZAYIN---------
//Signal
/obj/item/ego_weapon/ranged/branch12/mini/signal
	name = "signal"
	desc = "It continued calling out, expecting no response in return"
	special = "Upon hitting living target, inflict 1 Metal Decay per 20 missing SP. Then the firer recovers a bit of SP. <br>\
	(Metal Decay: Deals White damage every 5 seconds, equal to it's stack and then halves it. If it is on a mob, then it deal *4 more damage.)"
	icon_state = "signal"
	inhand_icon_state = "signal"
	force = 12
	projectile_path = /obj/projectile/ego_bullet/branch12/signal
	fire_delay = 7
	spread = 10
	shotsleft = 12
	reloadtime = 1.3 SECONDS
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'

/obj/projectile/ego_bullet/branch12/signal
	name = "signal"
	damage = 12
	damage_type = WHITE_DAMAGE
	var/healing_on_hit = 4
	var/inflict_per_sanityloss = 20

/obj/projectile/ego_bullet/branch12/signal/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(!ishuman(firer) || !isliving(target))
		return
	var/mob/living/carbon/human/user = firer
	var/mob/living/target_hit = target
	var/inflicted_decay = round((user.maxSanity - user.sanityhealth)/inflict_per_sanityloss)
	target_hit.apply_lc_metal_decay(inflicted_decay)
	user.adjustSanityLoss(-healing_on_hit)

//Serenity
//TODO: Let it cause MD shatters, for some upside.
/obj/item/ego_weapon/branch12/mini/serenity
	name = "serenity"
	desc = "By praying for its protection, the statue might grant you its gift if you�re worthy."
	special = "Every time you attack with this weapon, you heal SP. You heal more SP per status effect you have. You also inflict Metal Decay equal to the amount of statues effects you have. <br>\
	(Metal Decay: Deals White damage every 5 seconds, equal to it's stack and then halves it. If it is on a mob, then it deal *4 more damage.)"
	icon_state = "serenity"
	force = 12
	damtype = WHITE_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/fixer/generic/knife3.ogg'
	var/heal_per_status = 5

/obj/item/ego_weapon/branch12/mini/serenity/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	H.adjustSanityLoss((user.status_effects.len)*(-heal_per_status))
	if(isliving(target))
		target.apply_lc_metal_decay(user.status_effects.len)

//Age of Man
/obj/item/ego_weapon/branch12/age
	name = "age of man"
	desc = "A copper sword, freshly forged."
	special = "Using the weapon in hand, you will revive all fallen humans within 5 sqrs. Revived humans will then slowly decay over the course of 1.5 minutes. But, they will gain extra attributes for the duration of the decay. <br>\
	Also, This weapon inflicts 2 Metal Decay on hit. If the target has 15+ Metal Decay, inflict 3 more Metal Decay <br>\
	(Metal Decay: Deals White damage every 5 seconds, equal to it's stack and then halves it. If it is on a mob, then it deal *4 more damage.)"
	icon_state = "age_of_man"
	force = 14
	damtype = WHITE_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP
	attack_verb_continuous = list("slices", "slashes")
	attack_verb_simple = list("slice", "slash")
	hitsound = 'sound/weapons/fixer/generic/knife3.ogg'
	var/pray_cooldown
	var/pray_cooldown_time = 120 SECONDS
	var/attribute_buff = 60
	var/range = 5
	var/inflicted_decay = 2
	var/target_stacks = 15
	var/inflicted_extra_decay = 3

/obj/item/ego_weapon/branch12/age/attack(mob/living/target, mob/living/user)
	. = ..()
	if(isliving(target))
		target.apply_lc_metal_decay(inflicted_decay)
	var/datum/status_effect/stacking/lc_metal_decay/D = target.has_status_effect(/datum/status_effect/stacking/lc_metal_decay)
	if(D)
		if(D.stacks > target_stacks)
			target.apply_lc_metal_decay(inflicted_extra_decay)

/obj/item/ego_weapon/branch12/age/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(pray_cooldown > world.time)
		return
	pray_cooldown = world.time + pray_cooldown_time
	var/success = FALSE
	for(var/mob/living/carbon/human/human in view(range, get_turf(src)))
		if (human == user)
			continue
		if (human.stat == DEAD)
			success = TRUE
			human.revive(full_heal = TRUE, admin_revive = TRUE)
			human.grab_ghost(force = TRUE) // even suicides
			to_chat(human, span_spider("The bells are ringing. It's not your day to die... At least not for now..."))
			human.apply_status_effect(/datum/status_effect/fade_away)
			human.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, attribute_buff)
			human.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, attribute_buff)
			human.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -attribute_buff)
			human.adjust_attribute_buff(JUSTICE_ATTRIBUTE, attribute_buff)
	for(var/mob/living/simple_animal/hostile/ordeal/O in view(range, get_turf(src)))
		success = TRUE
		O.revive(full_heal = TRUE, admin_revive = TRUE)
		O.faction = list("neutral")
		O.apply_status_effect(/datum/status_effect/fade_away)
		O.color = "#fffc66"

	if(success)
		user.visible_message(span_spider("May the dead rise once more, to fight one last time..."))
		playsound(user, 'sound/abnormalities/silence/church.ogg', 50, TRUE, 4)

//Becoming
/obj/item/ego_weapon/branch12/becoming
	name = "becoming"
	desc = "A hammer made with the desire to become better"
	special = "This weapon inflicts 2 Metal Decay on hit. When this weapon hits a target with Metal Detonation, it will cause it to 'Shatter', and the weapon will deal double damage. This weapon can also change forms by being used in hand.<br>\
	(Metal Detonation: Does nothing until it is 'Shattered.' Once it is 'Shattered,' it will cause Metal Decay to trigger without reducing it's stack. Weapons that cause 'Shatter' gain other benefits as well.) <br>\
	(Metal Decay: Deals White damage every 5 seconds, equal to it's stack and then halves it. If it is on a mob, then it deal *4 more damage.)"
	icon_state = "becoming"
	force = 14
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")
	var/inflicted_decay = 2
	var/damage_multiplier = 2

/obj/item/ego_weapon/branch12/becoming/attack(mob/living/target, mob/living/user)
	var/old_force_multiplier = force_multiplier
	if(isliving(target))
		target.apply_lc_metal_decay(inflicted_decay)
		var/datum/status_effect/metal_detonate/D = target.has_status_effect(/datum/status_effect/metal_detonate)
		if(D)
			force_multiplier = damage_multiplier
			D.shatter()
	. = ..()
	force_multiplier = old_force_multiplier

/obj/item/ego_weapon/branch12/becoming/proc/equip_self(target)
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	src.attack_hand(H)

/obj/item/ego_weapon/branch12/becoming/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/held = H.get_active_held_item()
	H.dropItemToGround(held) //Drop weapon
	var/obj/item/ego_weapon/branch12/making/maker = new(get_turf(user))
	playsound(src, 'sound/effects/hokma_meltdown_short.ogg', 30, TRUE, 5)
	addtimer(CALLBACK(maker, PROC_REF(equip_self), user), 1, TIMER_UNIQUE | TIMER_OVERRIDE)
	Destroy(src)

//Making
/obj/item/ego_weapon/branch12/making
	name = "making"
	desc = "A hammer made with the desire to make anything"
	special = "This weapon inflicts Metal Detonation if the target has 15+ Metal Decay. This weapon can also change forms by being used in hand. <br>\
	(Metal Detonation: Does nothing until it is 'Shattered.' Once it is 'Shattered,' it will cause Metal Decay to trigger without reducing it's stack. Weapons that cause 'Shatter' gain other benefits as well.) <br>\
	(Metal Decay: Deals White damage every 5 seconds, equal to it's stack and then halves it. If it is on a mob, then it deal *4 more damage.)"
	color = "#d382ff"
	icon_state = "becoming"
	force = 14
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")
	var/detonation_breakpoint = 15

/obj/item/ego_weapon/branch12/making/attack(mob/living/target, mob/living/user)
	. = ..()
	if(isliving(target))
		var/datum/status_effect/stacking/lc_metal_decay/D = target.has_status_effect(/datum/status_effect/stacking/lc_metal_decay)
		if(D.stacks >= detonation_breakpoint)
			target.apply_status_effect(/datum/status_effect/metal_detonate)

/obj/item/ego_weapon/branch12/making/proc/equip_self(target)
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	src.attack_hand(H)

/obj/item/ego_weapon/branch12/making/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/held = H.get_active_held_item()
	H.dropItemToGround(held) //Drop weapon
	var/obj/item/ego_weapon/branch12/becoming/becomer = new(get_turf(user))
	playsound(src, 'sound/effects/hokma_meltdown_short.ogg', 30, TRUE, 5)
	addtimer(CALLBACK(becomer, PROC_REF(equip_self), user), 1, TIMER_UNIQUE | TIMER_OVERRIDE)
	Destroy(src)

//Exterminator
//TODO: Make this weapon inflict Metal Detonation with it's first bullet and every other bullet inflicts Metal Decay. Also it shatters it by melee hitting it. Which causes you to inflict a bunch of Metal Decay, and then shatter it.
/obj/item/ego_weapon/ranged/branch12/mini/exterminator
	name = "exterminator"
	desc = "A gun that's made to take out pests."
	special = "This weapon inflicts 1 Metal Decay with each shot, and the first bullet of each mag inflicts Metal Detonation. <br>\
	(Metal Detonation: Does nothing until it is 'Shattered.' Once it is 'Shattered,' it will cause Metal Decay to trigger without reducing it's stack. Weapons that cause 'Shatter' gain other benefits as well.) <br>\
	(Metal Decay: Deals White damage every 5 seconds, equal to it's stack and then halves it. If it is on a mob, then it deal *4 more damage.)"
	icon_state = "exterminator"
	inhand_icon_state = "exterminator"
	force = 12
	projectile_path = /obj/projectile/ego_bullet/branch12/exterminator
	fire_delay = 7
	spread = 10
	shotsleft = 10
	reloadtime = 1.2 SECONDS
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'
	var/inflicted_decay = 1

/obj/item/ego_weapon/ranged/branch12/mini/exterminator/before_firing(atom/target, mob/user)
	if(shotsleft == initial(shotsleft))
		projectile_path = /obj/projectile/ego_bullet/branch12/exterminator/first

/obj/item/ego_weapon/ranged/branch12/mini/exterminator/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, temporary_damage_multiplier = 1)
	. = ..()
	projectile_path = /obj/projectile/ego_bullet/branch12/exterminator

/obj/projectile/ego_bullet/branch12/exterminator
	name = "exterminator"
	damage = 12
	damage_type = BLACK_DAMAGE

/obj/projectile/ego_bullet/branch12/exterminator/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(!istype(fired_from, /obj/item/ego_weapon/ranged/branch12/mini/exterminator) || !isliving(target))
		return
	var/obj/item/ego_weapon/ranged/branch12/mini/exterminator/gun = fired_from
	var/mob/living/target_hit = target
	target_hit.apply_lc_metal_decay(gun.inflicted_decay)

/obj/projectile/ego_bullet/branch12/exterminator/first
	name = "marking exterminator"

/obj/projectile/ego_bullet/branch12/exterminator/first/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/mob/living/target_hit = target
	target_hit.apply_status_effect(/datum/status_effect/metal_detonate)

// --------TETH---------
//Departure
/obj/item/ego_weapon/branch12/departure
	name = "Departure"
	desc = "Each man's death diminishes me, For I am involved in mankind"
	special = "Upon hitting living target, Inflict bleed to the target and gain some bleed to self."
	icon_state = "departure"
	force = 8
	attack_speed = 0.5
	damtype = RED_DAMAGE
	hitsound = 'sound/weapons/slashmiss.ogg'
	var/inflicted_bleed = 4
	var/gained_bleed = 1

/obj/item/ego_weapon/branch12/departure/attack(mob/living/target, mob/living/user)
	..()
	if(isliving(target))
		target.apply_lc_bleed(inflicted_bleed)
	if(isliving(user))
		user.apply_lc_bleed(gained_bleed)

//Acupuncture
/obj/item/ego_weapon/branch12/mini/acupuncture
	name = "Acupuncture"
	desc = "One man's medicine is another man's poison."
	special = "You are able to inject yourself with this weapon. If you inject yourself with the weapon, you will take toxic damage, but gain a 30% damage buff for 5 seconds."
	icon_state = "acupuncture"
	force = 20
	damtype = BLACK_DAMAGE
	swingstyle = WEAPONSWING_THRUST
	attack_verb_continuous = list("jabs", "stabs")
	attack_verb_simple = list("jab", "stab")
	hitsound = 'sound/weapons/fixer/generic/nail1.ogg'
	var/inject_cooldown
	var/inject_cooldown_time = 5.1 SECONDS
	var/justice_buff = 30

/obj/item/ego_weapon/branch12/mini/acupuncture/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/drugie = user
	if(inject_cooldown < world.time)
		inject_cooldown = world.time + inject_cooldown_time
		drugie.set_drugginess(15)
		drugie.adjustToxLoss(4)
		to_chat(drugie, span_nicegreen("Wow... I can taste the colors..."))
		if(prob(20))
			drugie.emote(pick("twitch","drool","moan","giggle"))
		drugie.adjust_attribute_buff(JUSTICE_ATTRIBUTE, justice_buff)
		addtimer(CALLBACK(src, PROC_REF(RemoveBuff), drugie), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	else
		to_chat(drugie, span_boldwarning("[src] has not refueled yet."))

/obj/item/ego_weapon/branch12/mini/acupuncture/proc/RemoveBuff(mob/user)
	var/mob/living/carbon/human/human = user
	human.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -justice_buff)

//One Starry Night
/obj/item/ego_weapon/ranged/branch12/starry_night
	name = "One Starry Night"
	desc = "A gun that's made to take out pests."
	special = "This weapon deal 1% more damage to abnormalities, per 1% of their understanding. If they have max understanding, this weapon also reduces the target's white resistance by 20% for 5 seconds."
	icon_state = "starry_night"
	inhand_icon_state = "starry_night"
	force = 12
	projectile_path = /obj/projectile/ego_bullet/branch12/starry_night
	weapon_weight = WEAPON_HEAVY
	fire_delay = 5
	spread = 10
	shotsleft = 25
	reloadtime = 2.5 SECONDS
	fire_sound = 'sound/weapons/gun/smg/mp7.ogg'

/obj/projectile/ego_bullet/branch12/starry_night
	name = "starry night"
	icon_state = "whitelaser"
	damage = 22
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/branch12/starry_night/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(!istype(target, /mob/living/simple_animal/hostile/abnormality))
		return
	var/mob/living/simple_animal/hostile/abnormality/A = target
	var/extra_damage = 0
	if(A.datum_reference)
		extra_damage = (A.datum_reference.understanding / A.datum_reference.max_understanding)
		A.deal_damage(damage*extra_damage, "white")
		if(A.datum_reference.understanding == A.datum_reference.max_understanding)
			if(!A.has_status_effect(/datum/status_effect/rend_white))
				new /obj/effect/temp_visual/cult/sparks(get_turf(A))
				A.apply_status_effect(/datum/status_effect/rend_white)


//Slot Machine
/obj/item/ego_weapon/branch12/mini/slot_machine
	name = "Slot Machine"
	desc = "Big money!"
	special = "Upon throwing, this weapon returns to the user."
	icon_state = "coin"
	force = 10
	damtype = RED_DAMAGE
	throwforce = 45
	throw_speed = 1
	throw_range = 7
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")

/obj/item/ego_weapon/branch12/mini/slot_machine/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/caught = hit_atom.hitby(src, FALSE, FALSE, throwingdatum=throwingdatum)
	if(thrownby && !caught)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, throw_at), thrownby, throw_range+2, throw_speed, null, TRUE), 1)
	if(caught)
		return
	else
		return ..()


// --------HE---------
//Perfectionist
//TODO: Increase the downside, but make it able to shatter, which guarantees a critical hit. Also it's critical hits inflict Metal Decay. Normal hits inflict less Metal Decay.
/obj/item/ego_weapon/branch12/perfectionist
	name = "perfectionist"
	desc = "I couldn�t bear it, they silently judged, accusing every step I took."
	special = "Upon hitting living target, You have a chance to critically hit the target dealing quadruple damage. However, if you don't hit you take some damage. <br>\
	This weapon also inflicts 2 Metal Decay on hit, and if the target has Metal Detonation, shatter it, inflict double the Metal Decay and guarantee a critical hit. <br>\
	(Metal Detonation: Does nothing until it is 'Shattered.' Once it is 'Shattered,' it will cause Metal Decay to trigger without reducing it's stack. Weapons that cause 'Shatter' gain other benefits as well.) <br>\
	(Metal Decay: Deals White damage every 5 seconds, equal to it's stack and then halves it. If it is on a mob, then it deal *4 more damage.)"
	icon_state = "perfectionist"
	force = 30
	reach = 3
	stuntime = 8
	attack_speed = 0.7
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("whips", "lashes", "tears")
	attack_verb_simple = list("whip", "lash", "tear")
	hitsound = 'sound/weapons/whip.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)
	var/crit_chance = 5
	var/default_crit_chance = 5
	var/crit_chance_raise = 5
	var/inflicted_decay = 2

/obj/item/ego_weapon/branch12/perfectionist/attack(mob/living/target, mob/living/user)
	..()
	if(isliving(target))
		target.apply_lc_metal_decay(inflicted_decay)
		var/datum/status_effect/metal_detonate/D = target.has_status_effect(/datum/status_effect/metal_detonate)
		if(prob(crit_chance) || D)
			if(D)
				D.shatter()
				target.apply_lc_metal_decay(inflicted_decay)
			var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
			var/justicemod = 1 + userjust / 100
			var/extra_damage = force
			extra_damage *= justicemod
			target.deal_damage(extra_damage*3, damtype)
			playsound(target, 'sound/abnormalities/spiral_contempt/spiral_hit.ogg', 50, TRUE, 4)
			to_chat(user, span_nicegreen("FOR THEIR PERFORMANCE, I SHALL ACT!"))
			crit_chance = default_crit_chance
		else
			crit_chance += crit_chance_raise
			user.deal_damage(force*0.25, damtype)
			to_chat(user, span_boldwarning("They are watching... Judging..."))

/obj/item/ego_weapon/branch12/nightmares
	name = "childhood nightmares"
	desc = "A small side satchel with throwable items inside, the contents inside vary in appearance between people."
	special = "This weapon has a ranged attack, which throws out small plushies which inflict 2 Metal Decay on hit, this weapon also inflicts 2 Metal Decay on hit. You gain plushies to throw by attacking targets. <br>\
	(Metal Decay: Deals White damage every 5 seconds, equal to it's stack and then halves it. If it is on a mob, then it deal *4 more damage.)"
	icon_state = "nightmares"
	inhand_icon_state = "nightmares"
	force = 25
	damtype = WHITE_DAMAGE
	hitsound = 'sound/abnormalities/happyteddy/teddy_guard.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 40
							)
	var/inflicted_decay = 2
	var/ranged_cooldown
	var/ranged_cooldown_time = 1 SECONDS
	var/ranged_range = 7
	var/max_stored_pals = 3
	var/stored_pals = 3

/obj/item/ego_weapon/branch12/nightmares/examine(mob/user)
	. = ..()
	. += span_notice("This satchel is currently holding [stored_pals] out of [max_stored_pals] friends!")

/obj/item/ego_weapon/branch12/nightmares/attack(mob/living/target, mob/living/user)
	. = ..()
	if(isliving(target))
		target.apply_lc_metal_decay(inflicted_decay)
	if(stored_pals < max_stored_pals)
		if(prob(60))
			to_chat(user, span_nicegreen("Hey! You found another friend."))
			stored_pals++

/obj/item/ego_weapon/branch12/nightmares/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(ranged_cooldown > world.time || !CanUseEgo(user) || (stored_pals < 1))
		return
	var/turf/target_turf = get_turf(A)
	if(!istype(target_turf) || (get_dist(user, target_turf) < 3) || !(target_turf in view(ranged_range, user)))
		return
	..()
	ranged_cooldown = world.time + ranged_cooldown_time
	stored_pals--
	playsound(src, 'sound/weapons/throwhard.ogg', 25, TRUE)
	var/mob/living/simple_animal/hostile/nightmare_toy/thrown_object = new(get_turf(user))
	thrown_object.throw_at(target_turf, 10, 3, user, spin = TRUE)

/mob/living/simple_animal/hostile/nightmare_toy
	name = "Forgotten Plush"
	desc = "Have I seen them before?"
	icon = 'icons/obj/plushes.dmi'
	icon_state = "plushie_slime"
	icon_living = "plushie_slime"
	gender = NEUTER
	resize = 0.75
	density = FALSE
	mob_biotypes = MOB_ROBOTIC
	faction = list("neutral")
	health = 100
	maxHealth = 100
	healable = FALSE
	melee_damage_lower = 4
	melee_damage_upper = 6
	melee_damage_type = WHITE_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_sound = 'sound/abnormalities/happyteddy/teddy_guard.ogg'
	var/list/plushies = list("debug", "plushie_snake", "plushie_lizard", "plushie_spacelizard", "plushie_slime", "plushie_nuke", "plushie_pman", "plushie_awake", "plushie_h", "goat", "fumo_cirno")
	var/inflicted_decay = 2

/mob/living/simple_animal/hostile/nightmare_toy/Initialize()
	shuffle_inplace(plushies)
	icon_state = plushies[1]
	icon_living = plushies[1]
	QDEL_IN(src, (10 SECONDS))
	. = ..()
	faction = list("neutral")

/mob/living/simple_animal/hostile/nightmare_toy/AttackingTarget(atom/attacked_target)
	. = ..()
	if(isliving(attacked_target))
		var/mob/living/L = attacked_target
		L.apply_lc_metal_decay(inflicted_decay)

// --------WAW---------
//Plagiarism
/obj/item/ego_weapon/branch12/plagiarism
	name = "plagiarism"
	desc = "This is my, my work!."
	special = "Applies a random damage number"
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

/obj/item/ego_weapon/branch12/plagiarism/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	damtype = pick(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	..()

//Degrading Honor
/obj/item/ego_weapon/branch12/honor
	name = "degrading honor"
	desc = "The whole art of life consists in belonging to oneself."
	special = "With a 1 minute cooldown, Using it in hand you are able to inspire your fellow workers by giving them a 40% damage buff for 5 seconds at the cost of some of your SP."
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

//sound\magic\clockwork\invoke_general.ogg
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
	special = "You are able to turn on abnormality deterrence, which lets you make the foes you attack ignore you, at the cost of your SP."
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
	var/sp_cost = 10

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
	special = "You are able to activate 'Dead Eye' mode while wielding this weapon. While 'Dead Eye' is active, your shots take 2 extra seconds to fire, but they become piercing and deal more damage. <br>\
	Also, while you are using Deadeye mode, if you hit someone with Metal Detonation, you will cause a Shatter, which will inflict 10 Metal Decay to all nearby mobs.<br>\
	(Metal Detonation: Does nothing until it is 'Shattered.' Once it is 'Shattered,' it will cause Metal Decay to trigger without reducing it's stack. Weapons that cause 'Shatter' gain other benefits as well.) <br>\
	(Metal Decay: Deals White damage every 5 seconds, equal to it's stack and then halves it. If it is on a mob, then it deal *4 more damage.)"
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
		var/datum/status_effect/metal_detonate/D = L.has_status_effect(/datum/status_effect/metal_detonate)
		if(D)
			D.shatter()
			for(var/mob/living/simple_animal/hostile/H in view(3, get_turf(src)))
				H.apply_lc_metal_decay(10)

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


// --------ALEPH---------
//Pulsating Insanity
/obj/item/ego_weapon/branch12/mini/insanity
	name = "pulsating insanity"
	desc = "I could scarcely contain my feelings of triumph"
	special = "Upon hitting living target, the attacker would inflict a low amount of bleed. When this weapon is thrown, if it hits a mob you will teleport to the weapon and instantly pick it up. Also, the throwing attack deals an extra 10% more damager per bleed on target. (Max of 500% more damage)"
	icon_state = "insanity"
	force = 48
	swingstyle = WEAPONSWING_LARGESWEEP
	throwforce = 96
	throw_speed = 5
	throw_range = 7
	damtype = PALE_DAMAGE
	attack_verb_continuous = list("jabs")
	attack_verb_simple = list("jabs")
	hitsound = 'sound/weapons/slashmiss.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
	var/inflicted_bleed = 2
	var/detonate_cooldown
	var/detonate_cooldown_time = 5 SECONDS
	var/extra_damage_per_bleed = 0.1

/obj/item/ego_weapon/branch12/mini/insanity/on_thrown(mob/living/carbon/user, atom/target)//No, clerks cannot hilariously kill themselves with this
	if(!CanUseEgo(user))
		return
	return ..()

/obj/item/ego_weapon/branch12/mini/insanity/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	//var/caught = hit_atom.hitby(src, FALSE, TRUE, throwingdatum=throwingdatum)
	. = ..()
	if(!ismob(hit_atom) || detonate_cooldown > world.time)
		return
	if(thrownby && !.)
		detonate_cooldown = world.time + detonate_cooldown_time
		new /obj/effect/temp_visual/dir_setting/cult/phase/out (get_turf(thrownby))
		thrownby.forceMove(get_turf(src))
		new /obj/effect/temp_visual/dir_setting/cult/phase (get_turf(thrownby))
		playsound(src, 'sound/magic/exit_blood.ogg', 100, FALSE, 4)
		src.attack_hand(thrownby)
		bleed_boost(hit_atom, thrownby)
		if(thrownby.get_active_held_item() == src) //if our attack_hand() picks up the item...
			visible_message(span_warning("[thrownby] teleports to [src]!"))

/obj/item/ego_weapon/branch12/mini/insanity/proc/bleed_boost(hit_target, thrower)
	if(!ismob(hit_target) && !iscarbon(thrower))
		return
	var/mob/living/T = hit_target
	var/mob/living/carbon/U = thrower
	var/datum/status_effect/stacking/lc_bleed/B = T.has_status_effect(/datum/status_effect/stacking/lc_bleed)
	if(B)
		var/obj/effect/infinity/P = new get_turf(T)
		P.color = COLOR_RED
		var/bleed_buff = B.stacks * extra_damage_per_bleed
		var/userjust = (get_modified_attribute_level(U, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust / 100
		var/extra_damage = throwforce
		extra_damage *= justicemod
		T.deal_damage(extra_damage*bleed_buff, damtype)
		visible_message(span_warning("[U] punctures [T] with [src]!"))

/obj/item/ego_weapon/branch12/mini/insanity/attack(mob/living/target, mob/living/user)
	. = ..()
	if(isliving(target))
		target.apply_lc_bleed(inflicted_bleed)

//Purity
//TODO: Let it cause MD shatters, where it will do a triple shatter.
/obj/item/ego_weapon/branch12/purity
	name = "purity"
	desc = "To be pure is to be different than Innocent, for innocence requires ignorance while the pure takes in the experiences \
	they go through grows while never losing that spark of light inside. To hold the weight of the world requires someone Pure, \
	and the same can be said for this EGO which is weighed down by a heavy past that might as well be the weight of the world."
	special = "This weapon has a ranged attack which inflicts 5 Metal Decay. Attacking a target with Metal Decay will cause it to be triggered 3 time in a row, this has a cooldown. <br>\
	When attacking a target with Metal Detonation, cause a Shatter 3 times in a row. <br>\
	(Metal Detonation: Does nothing until it is 'Shattered.' Once it is 'Shattered,' it will cause Metal Decay to trigger without reducing it's stack. Weapons that cause 'Shatter' gain other benefits as well.) <br>\
	(Metal Decay: Deals White damage every 5 seconds, equal to it's stack and then halves it. If it is on a mob, then it deal *4 more damage.)"
	icon_state = "purity"
	force = 80
	reach = 2		//Has 2 Square Reach.
	stuntime = 5	//Longer reach, gives you a short stun.
	attack_speed = 1.2
	damtype = WHITE_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
	var/detonate_cooldown
	var/detonate_cooldown_time = 8 SECONDS
	var/ranged_cooldown
	var/ranged_cooldown_time = 2 SECONDS
	var/ranged_range = 5
	var/ranged_inflict = 5

/obj/item/ego_weapon/branch12/purity/attack(mob/living/target, mob/living/user)
	..()
	var/datum/status_effect/metal_detonate/mark = target.has_status_effect(/datum/status_effect/metal_detonate)
	if(mark)
		mark.shatter()
		for(var/i = 1 to 2)
			target.apply_status_effect(/datum/status_effect/metal_detonate)
			var/datum/status_effect/metal_detonate/extra_mark = target.has_status_effect(/datum/status_effect/metal_detonate)
			extra_mark.shatter()

	var/datum/status_effect/stacking/lc_metal_decay/D = target.has_status_effect(/datum/status_effect/stacking/lc_metal_decay)
	if(D)
		if(detonate_cooldown > world.time)
			return
		detonate_cooldown = world.time + detonate_cooldown_time
		var/obj/effect/infinity/P = new get_turf(target)
		P.color = COLOR_PURPLE
		playsound(loc, 'sound/magic/staff_animation.ogg', 15, TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
		for(var/i = 1 to 3)
			D.statues_damage(FALSE)

/obj/item/ego_weapon/branch12/purity/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(ranged_cooldown > world.time)
		return
	if(!CanUseEgo(user))
		return
	var/turf/target_turf = get_turf(A)
	if(!istype(target_turf))
		return
	if((get_dist(user, target_turf) < 3) || !(target_turf in view(ranged_range, user)))
		return
	..()
	var/turf/projectile_start = get_turf(user)
	ranged_cooldown = world.time + ranged_cooldown_time
	playsound(target_turf, 'sound/effects/smoke.ogg', 20, TRUE)

	//Stuff for creating the projctile.
	var/obj/projectile/ego_bullet/branch12/old_pale/B = new(projectile_start)
	B.starting = projectile_start
	B.firer = user
	B.fired_from = projectile_start
	B.yo = target_turf.y - projectile_start.y
	B.xo = target_turf.x - projectile_start.x
	B.original = target_turf
	B.preparePixelProjectile(target_turf, projectile_start)
	B.fire()

/obj/projectile/ego_bullet/branch12/old_pale
	name = "pale smoke"
	icon_state = "smoke"
	damage = 10
	speed = 4
	range = 6
	damage_type = WHITE_DAMAGE
	projectile_piercing = PASSMOB
	var/inflicted_decay = 8

/obj/projectile/ego_bullet/branch12/old_pale/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(!isliving(target))
		return
	var/mob/living/poorfool = target
	poorfool.apply_lc_metal_decay(inflicted_decay)

//Sands of Time
/obj/item/ego_weapon/branch12/time_sands
	name = "sands of time"
	desc = "And so it was lost."
	icon_state = "pharaoh"
	special = "This weapon inflicts burn on target and self. This weapon also deals 1% more damage per burn on target, and 4% more damage per burn on user."
	force = 80
	damtype = RED_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)
	var/extra_damage_target_burn = 0.01
	var/extra_damage_self_burn = 0.04
	var/inflicted_burn = 4
	var/gained_burn = 2

/obj/item/ego_weapon/branch12/time_sands/attack(mob/living/target, mob/living/user)
	var/datum/status_effect/stacking/lc_burn/TB = target.has_status_effect(/datum/status_effect/stacking/lc_burn)
	var/datum/status_effect/stacking/lc_burn/UB = user.has_status_effect(/datum/status_effect/stacking/lc_burn)
	var/target_burn_buff
	var/user_burn_buff
	if(TB)
		target_burn_buff = TB.stacks * extra_damage_target_burn
	if(TB)
		user_burn_buff = UB.stacks * extra_damage_self_burn
	var/old_force = force
	force = force * (1 + target_burn_buff + user_burn_buff)
	. = ..()
	force = old_force
	if(isliving(target))
		target.apply_lc_burn(inflicted_burn)
	if(isliving(user))
		user.apply_lc_burn(gained_burn)
