
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
/obj/item/ego_weapon/branch12/purity
	name = "purity"
	desc = "To be pure is to be different than Innocent, for innocence requires ignorance while the pure takes in the experiences \
	they go through grows while never losing that spark of light inside. To hold the weight of the world requires someone Pure, \
	and the same can be said for this EGO which is weighed down by a heavy past that might as well be the weight of the world."
	special = "This weapon has a ranged attack which inflicts 5 Mental Decay. Attacking a target with Mental Decay will cause it to be triggered 3 time in a row, this has a cooldown. <br>\
	When attacking a target with Mental Detonation, cause a Shatter 3 times in a row. <br><br>\
	(Mental Detonation: Does nothing until it is 'Shattered.' Once it is 'Shattered,' it will cause Mental Decay to trigger without reducing it's stack. Weapons that cause 'Shatter' gain other benefits as well.) <br>\
	(Mental Decay: Deals White damage every 5 seconds, equal to its stack, and then halves it. If it is on a mob, then it deals *4 more damage.)"
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
	var/datum/status_effect/mental_detonate/mark = target.has_status_effect(/datum/status_effect/mental_detonate)
	if(mark)
		mark.shatter()
		for(var/i = 1 to 2)
			target.apply_status_effect(/datum/status_effect/mental_detonate)
			var/datum/status_effect/mental_detonate/extra_mark = target.has_status_effect(/datum/status_effect/mental_detonate)
			extra_mark.shatter()

	var/datum/status_effect/stacking/lc_mental_decay/D = target.has_status_effect(/datum/status_effect/stacking/lc_mental_decay)
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
	poorfool.apply_lc_mental_decay(inflicted_decay)

//Lunar Night
/obj/item/ego_weapon/branch12/lunar_night
	name = "lunar night"
	desc = "A reflection of the moon."
	special = "When you attack with this weapon, if the target has Mental Detonation, shatter it and increase the weapon's damage by 5. You will also lose denisty for 4 seconds. <br><br>\
	After attacking, if the target has 20+ Mental Decay, inflict Mental Detonation to the target. Otherwise, if there are no targets with Mental Detonation, inflict Mental Detonation on 1 random nearby target. <br><br>\
	(Mental Detonation: Does nothing until it is 'Shattered.' Once it is 'Shattered,' it will cause Mental Decay to trigger without reducing it's stack. Weapons that cause 'Shatter' gain other benefits as well.) <br>\
	(Mental Decay: Deals White damage every 5 seconds, equal to its stack, and then halves it. If it is on a mob, then it deals *4 more damage.)"
	icon_state = "lunar_night"
	force = 60
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/fixer/reverb_normal.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)
	var/damage_buff_per_shatter = 5
	var/old_force = 60
	var/max_force = 120
	var/shatter_limit = 20

/obj/item/ego_weapon/branch12/lunar_night/attack(mob/living/target, mob/living/user)
	var/datum/status_effect/mental_detonate/MD = target.has_status_effect(/datum/status_effect/mental_detonate)
	if(MD)
		MD.shatter()
		if(force < max_force)
			force += damage_buff_per_shatter
		var/datum/status_effect/stacking/lc_mental_decay/decay = target.has_status_effect(/datum/status_effect/stacking/lc_mental_decay)
		if(decay)
			if(decay.stacks >= shatter_limit)
				target.apply_status_effect(/datum/status_effect/mental_detonate)
	else
		force = old_force
	var/is_detonate = FALSE
	var/list/detonate_targets = list()
	for(var/mob/living/simple_animal/hostile/H in view(5, get_turf(user)))
		var/datum/status_effect/mental_detonate/D = H.has_status_effect(/datum/status_effect/mental_detonate)
		if(D)
			is_detonate = TRUE
			break
		else
			if(H != target)
				detonate_targets += H
	if(!is_detonate && detonate_targets.len)
		shuffle_inplace(detonate_targets)
		var/mob/living/simple_animal/hostile/random_marked = detonate_targets[1]
		random_marked.apply_status_effect(/datum/status_effect/mental_detonate)
		user.density = FALSE
		user.color = "#57f7ff"
	else
		RemoveBuff(user)
	addtimer(CALLBACK(src, PROC_REF(RemoveBuff), user), 4 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
	. = ..()

/obj/item/ego_weapon/branch12/lunar_night/proc/RemoveBuff(mob/user)
	user.density = TRUE
	user.color = null

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

//Darkness
/obj/item/ego_weapon/branch12/darkness
	name = "darkness"
	desc = "It's all consuming... Gaze into it enough, you might never leave it."
	icon_state = "darkness"
	special = "When you attack with this weapon, if the target has Mental Decay, gain darkness equal to the amount Mental Decay the target has. Then trigger the Mental Decay on target. If the target has Mental Detonation, shatter it and gain 20 Darkness. <br><br>\
	At enough darkness, you are able to spend all of your darkness to send out a singularity which deal MASSIVE damage. Then more darkness you had at the time of creation, then greater it's size and damage is. However the speed and range will decease at higher amounts. <br><br>\
	(Mental Detonation: Does nothing until it is 'Shattered.' Once it is 'Shattered,' it will cause Mental Decay to trigger without reducing it's stack. Weapons that cause 'Shatter' gain other benefits as well.) <br>\
	(Mental Decay: Deals White damage every 5 seconds, equal to its stack, and then halves it. If it is on a mob, then it deals *4 more damage.)"
	force = 100
	damtype = BLACK_DAMAGE
	attack_speed = 1.6
	hitsound = 'sound/weapons/ego/hammer.ogg'
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)
	var/max_gathered_darkness = 1000
	var/gathered_darkness = 700
	var/ranged_cooldown
	var/ranged_cooldown_time = 1 SECONDS
	var/ranged_range = 8
	var/summoning_time
	var/darkness_per_shatter = 20
	var/inflicted_decay = 2

/obj/item/ego_weapon/branch12/darkness/examine(mob/user)
	. = ..()
	. += span_notice("This weapon currently has gathered [gathered_darkness] darkness out of [max_gathered_darkness] maximum darkness.")

/obj/item/ego_weapon/branch12/darkness/attack(mob/living/target, mob/living/user)
	..()
	var/datum/status_effect/mental_detonate/mark = target.has_status_effect(/datum/status_effect/mental_detonate)
	if(mark)
		mark.shatter()
		if(gathered_darkness <= (max_gathered_darkness-darkness_per_shatter))
			gathered_darkness += darkness_per_shatter
	var/datum/status_effect/stacking/lc_mental_decay/D = target.has_status_effect(/datum/status_effect/stacking/lc_mental_decay)
	if(D)
		if(gathered_darkness <= (max_gathered_darkness - D.stacks))
			gathered_darkness += D.stacks
			to_chat(user, span_nicegreen("You siphon some of the target's mental decay!"))
			playsound(loc, 'sound/magic/teleport_diss.ogg', 25, TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
			var/obj/effect/infinity/P = new get_turf(target)
			P.color = COLOR_PURPLE
			D.statues_damage(FALSE)
	if(isliving(target))
		var/mob/living/target_hit = target
		target_hit.apply_lc_mental_decay(inflicted_decay)

/obj/item/ego_weapon/branch12/darkness/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(ranged_cooldown > world.time)
		return
	if(!CanUseEgo(user))
		return
	var/turf/target_turf = get_turf(A)
	if(!istype(target_turf))
		return
	if((get_dist(user, target_turf) < 2) || !(target_turf in view(ranged_range, user)))
		return
	..()

	//Stuff for creating the projctile.
	var/obj/projectile/magic/aoe/black_hole/B
	if(gathered_darkness >= 900)
		B = new /obj/projectile/magic/aoe/black_hole/stage_5
	else if(gathered_darkness >= 600)
		B = new /obj/projectile/magic/aoe/black_hole/stage_4
	else if(gathered_darkness >= 400)
		B = new /obj/projectile/magic/aoe/black_hole/stage_3
	else if(gathered_darkness >= 200)
		B = new /obj/projectile/magic/aoe/black_hole/stage_2
	else if(gathered_darkness >= 100)
		B = new /obj/projectile/magic/aoe/black_hole
	else
		return
	ranged_cooldown = world.time + ranged_cooldown_time
	playsound(target_turf, 'sound/magic/arbiter/repulse.ogg', 45, TRUE)
	update_black_hole(B, user, target_turf)

/obj/item/ego_weapon/branch12/darkness/proc/update_black_hole(obj/projectile/magic/aoe/black_hole/B, mob/user, turf/target_turf)
	var/turf/projectile_start = get_turf(user)
	B.starting = projectile_start
	B.firer = user
	B.fired_from = projectile_start
	B.yo = target_turf.y - projectile_start.y
	B.xo = target_turf.x - projectile_start.x
	B.original = target_turf
	B.set_angle(Get_Angle(user, target_turf))
	B.forceMove(projectile_start)
	//B.preparePixelProjectile(target_turf, user, TRUE)
	if(do_after(user, B.appearing_time, src))
		B.fire()
		gathered_darkness = 0
	else
		qdel(B)

/obj/projectile/magic/aoe/black_hole
	name = "devouring singularity"
	icon = 'icons/obj/singularity.dmi'
	icon_state = "singularity_s1"
	alpha = 0
	range = 50
	damage = 100
	damage_type = BLACK_DAMAGE
	armour_penetration = 0
	speed = 1
	white_healing = FALSE
	nodamage = FALSE
	projectile_piercing = PASSMOB
	projectile_phasing = (ALL & (~PASSMOB))
	hitsound = 'sound/magic/arbiter/pillar_hit.ogg'
	var/consuming_range = 0
	var/appearing_time = 10

/obj/projectile/magic/aoe/black_hole/Initialize()
	. = ..()
	animate(src, alpha = 255, time = appearing_time)

/obj/projectile/magic/aoe/black_hole/Range()
	if(proxdet)
		if(isliving(firer))
			var/mob/living/user = firer
			var/target_aoe_turf = locate(src.x + consuming_range, src.y + consuming_range, user.z)
			for(var/mob/living/L in range(consuming_range, target_aoe_turf))
				if(L != user && !(faction_check(L.faction, list("neutral"), FALSE)))
					L.deal_damage(damage, "black")

	range--
	damage += damage_falloff_tile
	if(range <= 0 && loc)
		on_range()

/obj/projectile/magic/aoe/black_hole/stage_2
	icon = 'icons/effects/96x96.dmi'
	icon_state = "singularity_s3"
	range = 40
	damage = 200
	speed = 1.5
	pixel_x = -32
	pixel_y = -32
	consuming_range = 1
	appearing_time = 20

/obj/projectile/magic/aoe/black_hole/stage_3
	icon = 'icons/effects/160x160.dmi'
	icon_state = "singularity_s5"
	range = 30
	damage = 400
	speed = 2.5
	pixel_x = -64
	pixel_y = -64
	consuming_range = 2
	appearing_time = 30

/obj/projectile/magic/aoe/black_hole/stage_4
	icon = 'icons/effects/224x224.dmi'
	icon_state = "singularity_s7"
	range = 20
	damage = 600
	speed = 3.5
	pixel_x = -96
	pixel_y = -96
	consuming_range = 3
	appearing_time = 40

/obj/projectile/magic/aoe/black_hole/stage_5
	icon = 'icons/effects/288x288.dmi'
	icon_state = "singularity_s9"
	range = 10
	damage = 800
	speed = 4.5
	pixel_x = -128
	pixel_y = -128
	consuming_range = 4
	appearing_time = 50


//Lucifer, Morning Star and Executioner
/obj/item/ego_weapon/ranged/branch12/lucifer
	name = "Lucifer, Morning Star"
	desc = "The first star seen in the sky on any given night."
	icon_state = "lucifer"
	inhand_icon_state = "lucifer"
	special = "Use in hand to load bullets."
	force = 56
	projectile_path = /obj/projectile/ego_bullet/lucifer
	weapon_weight = WEAPON_HEAVY
	spread = 5
	recoil = 1.5
	fire_sound = 'sound/weapons/gun/rifle/shot_atelier.ogg'
	vary_fire_sound = TRUE
	fire_sound_volume = 30
	fire_delay = 7

	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)


	shotsleft = 16
	reloadtime = 0.5 SECONDS


/obj/item/ego_weapon/ranged/branch12/lucifer/reload_ego(mob/user)
	if(shotsleft == initial(shotsleft))
		return
	is_reloading = TRUE
	to_chat(user,"<span class='notice'>You start loading a bullet.</span>")
	if(do_after(user, reloadtime, src)) //gotta reload
		playsound(src, 'sound/weapons/gun/general/slide_lock_1.ogg', 50, TRUE)
		shotsleft +=1
	is_reloading = FALSE


/obj/item/ego_weapon/ranged/branch12/lucifer/executioner
	name = "Executioner"
	desc = "There is but one last ."
	icon_state = "executioner"
	inhand_icon_state = "executioner"
	force = 56
	weapon_weight = WEAPON_MEDIUM	//Can be dual wielded
	recoil = 2
	fire_sound_volume = 30
	fire_delay = 12

	shotsleft = 6	//Based off a colt Single Action Navy
	reloadtime = 0.8 SECONDS

/obj/projectile/ego_bullet/lucifer
	name = "lucifer"
	damage = 140 // VERY high damage
	damage_type = BLACK_DAMAGE
