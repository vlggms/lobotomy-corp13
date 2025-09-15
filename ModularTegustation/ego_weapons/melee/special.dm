//Abnormality rewards
//Bottle of Tears
/**
 * Here's how it works. It scales with Fortitude.
 * This is more balanced than it sounds.
 * Think of it as if Fortitude adjusted base force.
 * Once you get yourself to 80, an additional scaling factor begins to kick in that will let you keep up through the endgame.
 * This scaling factor only applies if it's the only weapon in your inventory, however. Use it faithfully, and it can cut through even enemies immune to black.
 * Why? Because well Catt has been stated to work on WAWs, which means that she's at least level 3-4.
 * Why is she still using Eyeball Scooper from a Zayin? Maybe it scales with fortitude?
 */
/obj/item/ego_weapon/eyeball
	name = "eyeball scooper"
	desc = "Mind if I take them?"
	special = "This weapon grows more powerful as you do, but its potential is limited if you possess any other EGO weapons."
	icon_state = "eyeball1"
	force = 12
	damtype = BLACK_DAMAGE

	attack_verb_continuous = list("cuts", "smacks", "bashes")
	attack_verb_simple = list("cuts", "smacks", "bashes")
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 20, //It's 20 to keep clerks from using it
	)

/obj/item/ego_weapon/eyeball/attack(mob/living/target, mob/living/carbon/human/user)
	force = initial(force)
	damtype = initial(damtype)
	var/userfort = (get_attribute_level(user, FORTITUDE_ATTRIBUTE))
	var/fortitude_mod = clamp((userfort - 40) / 4 + 2, 0, 50) // 3 at 40 fortitude, 17 at 100 fortitude
	var/extra_mod = fortitude_mod * 0.5
	var/list/search_area = user.contents.Copy()
	for(var/obj/item/storage/spare_space in search_area)
		search_area |= spare_space.contents
	for(var/obj/item/ego_weapon/ranged/disloyal_gun in search_area)
		extra_mod = 0
		break
	for(var/obj/item/ego_weapon/disloyal_weapon in search_area)
		if(disloyal_weapon == src)
			continue
		extra_mod = 0
		break
	force = 12 + fortitude_mod
	if(extra_mod > 0)
		var/resistance = target.run_armor_check(null, damtype)
		icon_state = "eyeball2"				// Cool sprite
		if(isanimal(target))
			var/mob/living/simple_animal/S = target
			if(S.damage_coeff.getCoeff(damtype) <= 0)
				resistance = 100
		if(resistance >= 100) // If the eyeball wielder is going no-balls and using one fucking weapon, let's throw them a bone.
			force *= 0.1
			damtype = BRUTE //Armor-piercing
	else
		icon_state = "eyeball1" //Cool sprite gone
	if(ishuman(target))
		force *= 1.3
	return ..()

//Pile of Mail
/obj/item/ego_weapon/mail_satchel
	name = "envelope"
	desc = "Heavy satchel filled to the brim with letters."
	icon_state = "mailsatchel"
	force = 6
	attack_speed = 1.2
	damtype = WHITE_DAMAGE

	attack_verb_continuous = list("slams", "bashes", "strikes")
	attack_verb_simple = list("slams", "bashes", "strikes")
	attribute_requirements = list(TEMPERANCE_ATTRIBUTE = 20) //pesky clerks!

/obj/item/ego_weapon/mail_satchel/attack(atom/A, mob/living/user, proximity_flag, params)
	force = initial(force)
	var/usertemp = (get_attribute_level(user, TEMPERANCE_ATTRIBUTE))
	var/temperance_mod = clamp((usertemp - 20) / 4 + 2, 0, 14)
	force = 6 + temperance_mod
	if(prob(30))
		new /obj/effect/temp_visual/maildecal(get_turf(A))

	return ..()

//Puss in Boots
/obj/item/ego_weapon/lance/famiglia
	name = "famiglia"
	desc = "Do not be cast down, for I will provide for your well-being as well as mine."
	icon_state = "famiglia"
	lefthand_file = 'icons/mob/inhands/96x96_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/96x96_righthand.dmi'
	inhand_x_dimension = 96
	inhand_y_dimension = 96
	force = 20
	reach = 2		//Has 2 Square Reach.
	stuntime = 5	//Longer reach, gives you a short stun.
	attack_speed = 1.4// slow
	damtype = RED_DAMAGE

	attack_verb_continuous = list("bludgeons", "whacks")
	attack_verb_simple = list("bludgeon", "whack")
	hitsound = 'sound/weapons/ego/mace1.ogg'

/obj/item/ego_weapon/lance/famiglia/CanUseEgo(mob/living/carbon/human/user)
	. = ..()
	var/datum/status_effect/chosen/C = user.has_status_effect(/datum/status_effect/chosen)
	if(!C)
		to_chat(user, span_notice("You cannot use [src], only the abnormality's chosen can!"))
		return FALSE

/obj/item/ego_weapon/lance/famiglia/attack(mob/living/target, mob/living/user)
	if(raised)
		knockback = KNOCKBACK_LIGHT
	else
		knockback = FALSE

	return ..()

/obj/item/ego_weapon/lance/famiglia/LowerLance(mob/user)
	hitsound = 'sound/weapons/ego/spear1.ogg'
	..()

/obj/item/ego_weapon/lance/famiglia/RaiseLance(mob/user)
	hitsound = 'sound/weapons/ego/mace1.ogg'
	..()

//We Can Change Anything
/obj/item/ego_weapon/iron_maiden
	name = "iron maiden"
	desc = "Just open up the machine, step inside, and press the button to make it shut. Now everything will be just fine.."
	special = "This weapon builds up the amount of times it hits as you attack, at maximum speed it will damage you per hit, increasing more and more, use it in hands."
	icon_state = "iron_maiden"
	force = 10 //DPS of 10, 20, 30, 40 at each ramping level
	damtype = RED_DAMAGE

	attack_verb_continuous = list("clamps")
	attack_verb_simple = list("clamp")
	hitsound = 'sound/abnormalities/helper/attack.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)
	var/ramping_speed = 0 //maximum of 10
	var/ramping_damage = 0 //no maximum, will stack as long as people are attacking with it.

/obj/item/ego_weapon/iron_maiden/Initialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/ego_weapon/iron_maiden/proc/Multihit(mob/living/target, mob/living/user, attack_amount)
	sleep(1)
	for(var/i = 1 to attack_amount)
		switch(attack_amount)
			if(1)
				sleep(5)
			if(2)
				sleep(3)
			if(3)
				sleep(2)
		if(target in view(reach,user))
			playsound(loc, hitsound, get_clamped_volume(), TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
			user.do_attack_animation(target)
			target.attacked_by(src, user)
			log_combat(user, target, pick(attack_verb_continuous), src.name, "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(damtype)])")

/obj/item/ego_weapon/iron_maiden/melee_attack_chain(mob/living/user, atom/target, params)
	..()
	if(isliving(target))
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(target), pick(GLOB.alldirs))

/obj/item/ego_weapon/iron_maiden/attack(mob/living/target, mob/living/user)
	if(!..())
		return
	if (ramping_speed < 10)
		ramping_speed += 1
	else
		ramping_damage += 0.02
		user.adjustBruteLoss(user.maxHealth*ramping_damage)
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(user), pick(GLOB.alldirs))
	playsound(loc, 'sound/abnormalities/we_can_change_anything/change_generate.ogg', get_clamped_volume(), FALSE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
	switch(ramping_speed)
		if(5 to 10)
			Multihit(target, user, 1)
		if(10 to 15)
			Multihit(target, user, 2)
		if(15 to 20)
			if(icon_state != "iron_maiden_open")
				playsound(src, 'sound/abnormalities/we_can_change_anything/change_gas.ogg', 50, TRUE)
				icon_state = "iron_maiden_open"
				update_icon_state()
			Multihit(target, user, 3)
	return

/obj/item/ego_weapon/iron_maiden/attack_self(mob/user)
	if(ramping_speed == 0)
		to_chat(user,span_notice("It is already revved down!"))
		return
	to_chat(user,span_notice("You being to cool down [src]."))
	playsound(src, 'sound/abnormalities/we_can_change_anything/change_gas.ogg', 50, TRUE)
	if(do_after(user, 2.5 SECONDS, src))
		icon_state = "iron_maiden"
		update_icon_state()
		playsound(src, 'sound/abnormalities/we_can_change_anything/change_start.ogg', 50, FALSE)
		ramping_speed = 0
		ramping_damage = 0
		to_chat(user,span_notice("The mechanism on [src] dies down!"))

//Event rewards
/obj/item/ego_weapon/goldrush/nihil
	name = "worthless greed"
	desc = "The magical girl, who was no longer a magical girl, ate many things. \
	Authority, money, fame, and many other forms of pleasure. She ended up eating away anything in her sight."
	special = "This weapon has a combo system and can charge up a powerful charge attack."
	hitsound = 'sound/weapons/fixer/generic/fist2.ogg'
	icon_state = "greed"
	force = 40
	var/charge_damage = 120
	var/charge_wind_up = 3 SECONDS
	var/can_charge = TRUE
	var/prepair_charge = FALSE
	var/charge_cooldown_time = 7 SECONDS

/obj/item/ego_weapon/goldrush/nihil/attack_self(mob/user) //spin attack with knockback
	if(!CanUseEgo(user) || charging)
		return
	if(!can_charge)
		to_chat(user,span_warning("You attacked too recently."))
		return
	prepair_charge = !prepair_charge
	if(!prepair_charge)
		to_chat(user,span_notice("You prepair to preform a dash."))
	else
		to_chat(user,span_notice("You decide to not preform a dash."))
	. = ..()

/obj/item/ego_weapon/goldrush/nihil/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user) || !prepair_charge || charging)
		return
	var/turf/target_turf = get_turf(A)
	if(!istype(target_turf))
		return
	..()
	to_chat(user,span_notice("You start charging up a dash."))
	prepair_charge = FALSE
	charging = TRUE
	user.Immobilize(stuntime)
	if(do_after(user, charge_wind_up, src))
		if(QDELETED(user))
			charge_reset()
			return
		can_charge = FALSE
		var/list/been_hit = list()
		var/turf/end_turf = get_ranged_target_turf_direct(user, target_turf, 12, 0)
		var/list/turf_list = getline(user, end_turf)
		for(var/turf/T in turf_list)
			var/stop_charge = FALSE
			if(T.density)
				break
			for(var/obj/structure/window/W in T.contents)
				stop_charge = TRUE
				break
			for(var/obj/machinery/door/MD in T.contents)
				if(!MD.CanAStarPass(null))
					stop_charge = TRUE
					break
				if(MD.density)
					INVOKE_ASYNC(MD, TYPE_PROC_REF(/obj/machinery/door, open), 2)
			if(stop_charge)
				break
			if(QDELETED(user))
				charge_reset()
				return
			user.loc = T
			var/aoe = charge_damage
			var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
			var/justicemod = 1 + userjust / 100
			aoe *= justicemod
			aoe *= force_multiplier
			for(var/mob/living/L in range(1, user))
				if(L == user)
					continue
				if(ishuman(L))
					continue
				if(L in been_hit)
					continue
				been_hit += L
				L.apply_damage(aoe, RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
				L.visible_message(span_danger("[user] tackles [L]!"))
				playsound(T, 'sound/abnormalities/kog/GreedHit1.ogg', 40, 1)
				playsound(T, 'sound/abnormalities/kog/GreedHit2.ogg', 30, 1)
			for(var/turf/open/R in range(1, T))
				new /obj/effect/temp_visual/small_smoke/halfsecond(R)
			playsound(src,'sound/effects/bamf.ogg', 70, TRUE, 20)
			user.Immobilize(0.6)
			sleep(0.6)
		addtimer(CALLBACK(src, PROC_REF(charge_reset)), charge_cooldown_time)
		charging = FALSE
	else
		charging = FALSE

/obj/item/ego_weapon/goldrush/nihil/proc/charge_reset()
	can_charge = TRUE
	charging = FALSE

/obj/item/ego_weapon/shield/despair_nihil
	name = "meaningless despair"
	desc = "When Justice turns its back once more, several dozen blades will rove without a purpose. \
	The swords will eventually point at those she could not protect."
	special = "This weapon has a combo system."
	icon_state = "despair_nihil"
	force = 20
	attack_speed = 1
	damtype = WHITE_DAMAGE

	attack_verb_continuous = list("stabs", "attacks", "slashes")
	attack_verb_simple = list("stab", "attack", "slash")
	hitsound = 'sound/weapons/ego/rapier1.ogg'
	reductions = list(90, 90, 90, 50)
	projectile_block_duration = 1 SECONDS
	block_duration = 1 SECONDS
	block_cooldown = 3 SECONDS
	block_message = "You attempt to parry the attack!"
	hit_message = "parries the attack!"
	block_cooldown_message = "You rearm your blade."
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)
	var/combo = 0
	var/combo_time
	var/combo_wait = 10

//This is like an anime character attacking like 4 times with the 4th one as a finisher attack.
/obj/item/ego_weapon/shield/despair_nihil/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time)
		combo = 0
	combo_time = world.time + combo_wait
	if(combo==4)
		combo = 0
		user.changeNext_move(CLICK_CD_MELEE * 2)
		force *= 5	// Should actually keep up with normal damage.
		playsound(src, 'sound/weapons/fixer/generic/sword5.ogg', 50, FALSE, 9)
		to_chat(user,span_warning("You are offbalance, you take a moment to reset your stance."))
	else
		user.changeNext_move(CLICK_CD_MELEE * 0.4)
	..()
	combo += 1
	force = initial(force)

/obj/item/ego_weapon/blind_rage/nihil
	name = "senseless wrath"
	desc = "The Servant of Wrath valued justice and balance more than anyone, but she began sharing knowledge with the \
	Hermit - an enemy of her realm, becoming friends with her in secret."
	icon_state = "wrath"
	force = 40
	attack_speed = 1.2
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)
	aoe_damage = 20
	aoe_range = 3

/obj/item/ego_weapon/blind_rage/nihil/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/nihil))
		return
	..()

//Tutorial
/obj/item/ego_weapon/tutorial
	name = "rookie dagger"
	desc = "E.G.O intended for Agent Education"
	icon_state = "rookie"
	force = 3
	damtype = RED_DAMAGE
	attack_verb_continuous = list("cuts", "stabs", "slashes")
	attack_verb_simple = list("cuts", "stabs", "slashes")

/obj/item/ego_weapon/tutorial/white
	name = "fledgling dagger"
	icon_state = "fledgling"
	damtype = WHITE_DAMAGE

/obj/item/ego_weapon/tutorial/black
	name = "apprentice dagger"
	icon_state = "apprentice"
	damtype = BLACK_DAMAGE

/obj/item/ego_weapon/tutorial/pale
	name = "freshman dagger"
	icon_state = "freshman"
	damtype = PALE_DAMAGE
