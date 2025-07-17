/datum/species/cuckoospawn
	name = "Cuckoospawn"
	id = "cuckoo"
	mutant_bodyparts = list()
	say_mod = "chrips"
	sexes = 0 // cuckoo has no need for this

	nojumpsuit = TRUE
	species_traits = list(NO_UNDERWEAR, NOEYESPRITES)
	inherent_traits = list(TRAIT_PERFECT_ATTACKER, TRAIT_BRUTEPALE, TRAIT_BRUTESANITY, TRAIT_SANITYIMMUNE, TRAIT_GENELESS, TRAIT_COMBATFEAR_IMMUNE, TRAIT_NOGUNS, TRAIT_PIERCEIMMUNE, TRAIT_NOEGOWEAPONS, TRAIT_XENO_IMMUNE)
	use_skintones = FALSE
	species_language_holder = /datum/language_holder/cuckoospawn
	mutanteyes = /obj/item/organ/eyes/night_vision/cuckoo
	limbs_id = "cuckoo"
	say_mod = "chrips"
	no_equip = list(ITEM_SLOT_EYES, ITEM_SLOT_MASK, ITEM_SLOT_FEET, ITEM_SLOT_OCLOTHING, ITEM_SLOT_ICLOTHING)
	changesource_flags = MIRROR_BADMIN | WABBAJACK
	liked_food = MEAT | RAW
	disliked_food = VEGETABLES | DAIRY
	attack_sound = 'sound/abnormalities/big_wolf/Wolf_Scratch.ogg'
	punchdamagelow = 24
	punchdamagehigh = 27
	stunmod = 0.5
	redmod = 0.7
	whitemod = 1
	blackmod = 0.7
	palemod = 1.5
	payday_modifier = 0

/datum/species/cuckoospawn/random_name(gender,unique,lastname)
	return "Niaojia-ren"

/mob/living/carbon/human/species/cuckoospawn
	race = /datum/species/cuckoospawn
	faction = list("cuckoospawn")
	var/datum/martial_art/cuckoopunch/cuckoopunch
	// var/datum/martial_art/wrestling/cuckoowrestling
	var/attempted_crosses = 0
	/// For storing our tackler datum so we can remove it after
	var/datum/component/tackler
	/// See: [/datum/component/tackler/var/stamina_cost]
	var/tackle_stam_cost = 75
	/// See: [/datum/component/tackler/var/base_knockdown]
	var/base_knockdown = 1 SECONDS
	/// See: [/datum/component/tackler/var/range]
	var/tackle_range = 8
	/// See: [/datum/component/tackler/var/min_distance]
	var/min_distance = 0
	/// See: [/datum/component/tackler/var/speed]
	var/tackle_speed = 2
	/// See: [/datum/component/tackler/var/skill_mod]
	var/skill_mod = 0
	var/head_immunity_start
	var/head_immunity_duration = 1 MINUTES

/mob/living/carbon/human/species/cuckoospawn/Login()
	. = ..()
	if(mind) //Just a back up, if somehow this proc gets triggered without a mind.
		cuckoopunch = new(null)
		cuckoopunch.teach(src)
		// cuckoowrestling = new(null)
		// cuckoowrestling.teach(src)
	to_chat(src, span_info("<b>You are a Niaojia-ren, the vulture of the ruins.</b> <br>\
		Your job is to hunt down humans who enter your domain, and to infect them with your skills. <br>\
		Using your tackle and charged attack, infects humans with your embryo. Make sure that the host is alive for it to grow. <br>\
		However, this land is also infested with other simple minded creatures... Exterminate them as well.<br>\
		DO NOT LEAVE THE RUINS... The head is watching you, and will exterminate you if you enter the land of the humans."))

/mob/living/carbon/human/species/cuckoospawn/Initialize()
	. = ..()
	head_immunity_start = world.time + head_immunity_duration
	adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 100)
	AddComponent(/datum/component/footstep, FOOTSTEP_MOB_CLAW, 1, -6)
	RegisterSignal(src, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(CheckSpace))
	AddComponent(/datum/component/tackler/cuckoo, stamina_cost=tackle_stam_cost, base_knockdown = base_knockdown, range = tackle_range, speed = tackle_speed, skill_mod = skill_mod, min_distance = min_distance)

/mob/living/carbon/human/species/cuckoospawn/proc/CheckSpace(mob/user, atom/new_location)
	if(head_immunity_start < world.time)
		var/turf/newloc_turf = get_turf(new_location)
		// var/valid_tile = TRUE

		var/area/new_area = get_area(newloc_turf)
		if(istype(new_area, /area/city))
			var/area/city/city_area = new_area
			if(city_area.in_city)
				if(attempted_crosses > 10)
					executed_claw()
				attempted_crosses++
				to_chat(src, span_warning("You feel a shiver down your spine, the city will not allow you to enter..."))
				// valid_tile = FALSE

		// if(!valid_tile)
		// 	return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

/mob/living/carbon/human/species/cuckoospawn/stripPanelUnequip(obj/item/what, mob/who)
	to_chat(src, span_warning("You don't have the dexterity to do this!"))
	return

/mob/living/carbon/human/species/cuckoospawn/start_pulling(atom/movable/AM, state, force = pull_force, supress_message = FALSE)
	if(istype(AM, /mob/living/carbon/human/species/cuckoospawn))
		return ..()

	if(istype(AM, /mob/living/carbon/human/species))
		var/mob/living/carbon/human/species/possible_human
		if(!possible_human.race && possible_human.stat == DEAD)
			to_chat(src, span_warning("They are already dead, they are of no use to you."))
			return FALSE
	. = ..()

/mob/living/carbon/human/species/cuckoospawn/proc/executed_claw()
	var/turf/origin = get_turf(src)
	var/list/all_turfs = origin.GetAtmosAdjacentTurfs(1)
	for(var/turf/T in all_turfs)
		if(T == origin)
			continue
		new /obj/effect/temp_visual/dir_setting/claw_appears (T)
		break
	new /obj/effect/temp_visual/justitia_effect(get_turf(src))
	for(var/obj/item/W in contents)
		if(!dropItemToGround(W))
			qdel(W)
	qdel(src)

/obj/item/organ/eyes/night_vision/cuckoo
	name = "bird-eye"
	desc = "Bright open, always looking for their new prey in the dark..."

//I did not know how to add the infection without overiding the whole proc, so I am overiding it completely.
/datum/component/tackler/cuckoo/sack(mob/living/carbon/user, atom/hit)
	SIGNAL_HANDLER_DOES_SLEEP

	if(!tackling || !tackle)
		return

	user.toggle_throw_mode()
	if(!iscarbon(hit))
		if(hit.density)
			return splat(user, hit)
		return

	var/mob/living/carbon/target = hit
	var/mob/living/carbon/human/T = target
	var/mob/living/carbon/human/S = user
	var/tackle_word = isfelinid(user) ? "pounce" : "tackle" //If cat, "pounce" instead of "tackle".

	var/roll = rollTackle(target)
	tackling = FALSE
	tackle.gentle = TRUE

	if(T.stat != DEAD && prob(30))
		var/obj/item/bodypart/chest/LC = T.get_bodypart(BODY_ZONE_CHEST)
		if((!LC || LC.status != BODYPART_ROBOTIC) && !T.getorgan(/obj/item/organ/body_egg/cuckoospawn_embryo) && !HAS_TRAIT(T, TRAIT_XENO_IMMUNE))
			to_chat(S, span_nicegreen("You implant [T], soon a new niaojia-ren bird shall grow..."))
			new /obj/item/organ/body_egg/cuckoospawn_embryo(T)
			var/turf/TT = get_turf(T)
			log_game("[key_name(T)] was infected by a niaojia-ren at [loc_name(TT)]")

	switch(roll)
		if(-INFINITY to -5)
			user.visible_message("<span class='danger'>[user] botches [user.p_their()] [tackle_word] and slams [user.p_their()] head into [target], knocking [user.p_them()]self silly!</span>", "<span class='userdanger'>You botch your [tackle_word] and slam your head into [target], knocking yourself silly!</span>", ignored_mobs = target)
			to_chat(target, "<span class='userdanger'>[user] botches [user.p_their()] [tackle_word] and slams [user.p_their()] head into you, knocking [user.p_them()]self silly!</span>")

			user.Paralyze(30)
			var/obj/item/bodypart/head/hed = user.get_bodypart(BODY_ZONE_HEAD)
			if(hed)
				hed.receive_damage(brute=15, updating_health=TRUE, wound_bonus = CANT_WOUND)
			user.gain_trauma(/datum/brain_trauma/mild/concussion)

		if(-4 to -2) // glancing blow at best
			user.visible_message("<span class='warning'>[user] lands a weak [tackle_word] on [target], briefly knocking [target.p_them()] off-balance!</span>", "<span class='userdanger'>You land a weak [tackle_word] on [target], briefly knocking [target.p_them()] off-balance!</span>", ignored_mobs = target)
			to_chat(target, "<span class='userdanger'>[user] lands a weak [tackle_word] on you, briefly knocking you off-balance!</span>")

			user.Knockdown(10)
			target.apply_lc_tremor(10, 40)

		if(-1 to 0) // decent hit, both parties are about equally inconvenienced
			user.visible_message("<span class='warning'>[user] lands a passable [tackle_word] on [target], sending them both tumbling!</span>", "<span class='userdanger'>You land a passable [tackle_word] on [target], sending you both tumbling!</span>", ignored_mobs = target)
			to_chat(target, "<span class='userdanger'>[user] lands a passable [tackle_word] on you, sending you both tumbling!</span>")

			user.Knockdown(10)
			target.apply_lc_tremor(15, 40)

		if(1 to 2) // solid hit, tackler has a slight advantage
			user.visible_message("<span class='warning'>[user] lands a solid [tackle_word] on [target], knocking them both down hard!</span>", "<span class='userdanger'>You land a solid [tackle_word] on [target], knocking you both down hard!</span>", ignored_mobs = target)
			to_chat(target, "<span class='userdanger'>[user] lands a solid [tackle_word] on you, knocking you both down hard!</span>")

			user.Knockdown(10)
			target.apply_lc_tremor(20, 40)

		if(3 to 4) // really good hit, the target is definitely worse off here. Without positive modifiers, this is as good a tackle as you can land
			user.visible_message("<span class='warning'>[user] lands an expert [tackle_word] on [target], knocking [target.p_them()] down hard while landing on [user.p_their()] feet with a passive grip!</span>", "<span class='userdanger'>You land an expert [tackle_word] on [target], knocking [target.p_them()] down hard while landing on your feet with a passive grip!</span>", ignored_mobs = target)
			to_chat(target, "<span class='userdanger'>[user] lands an expert [tackle_word] on you, knocking you down hard and maintaining a passive grab!</span>")

			user.SetKnockdown(0)
			user.get_up(TRUE)
			user.forceMove(get_turf(target))
			target.apply_lc_tremor(30, 40)
			if(ishuman(target) && ishuman(user))
				S.dna.species.grab(S, T)
				S.setGrabState(GRAB_PASSIVE)

		if(5 to INFINITY) // absolutely BODIED
			user.visible_message("<span class='warning'>[user] lands a monster [tackle_word] on [target], knocking [target.p_them()] senseless and applying an aggressive pin!</span>", "<span class='userdanger'>You land a monster [tackle_word] on [target], knocking [target.p_them()] senseless and applying an aggressive pin!</span>", ignored_mobs = target)
			to_chat(target, "<span class='userdanger'>[user] lands a monster [tackle_word] on you, knocking you senseless and aggressively pinning you!</span>")

			user.SetKnockdown(0)
			user.get_up(TRUE)
			user.forceMove(get_turf(target))
			target.Paralyze(5)
			target.apply_lc_tremor(35, 40)
			if(ishuman(target) && ishuman(user))
				S.dna.species.grab(S, T)
				S.setGrabState(GRAB_AGGRESSIVE)

	return COMPONENT_MOVABLE_IMPACT_FLIP_HITPUSH

/datum/component/tackler/cuckoo/splat(mob/living/carbon/user, atom/hit)
	if(istype(hit, /obj/machinery/vending)) // before we do anything else-
		var/obj/machinery/vending/darth_vendor = hit
		darth_vendor.tilt(user, TRUE)
		return
	else if(istype(hit, /obj/structure/window))
		var/obj/structure/window/W = hit
		splatWindow(user, W)
		if(QDELETED(W))
			return COMPONENT_MOVABLE_IMPACT_NEVERMIND
		return

	var/oopsie_mod = 0
	var/danger_zone = (speed - 1) * 13 // for every extra speed we have over 1, take away 13 of the safest chance
	danger_zone = max(min(danger_zone, 100), 1)

	if(ishuman(user))
		var/mob/living/carbon/human/S = user
		var/head_slot = S.get_item_by_slot(ITEM_SLOT_HEAD)
		var/suit_slot = S.get_item_by_slot(ITEM_SLOT_OCLOTHING)
		if(head_slot && (istype(head_slot,/obj/item/clothing/head/helmet) || istype(head_slot,/obj/item/clothing/head/hardhat)))
			oopsie_mod -= 6
		if(suit_slot && (istype(suit_slot,/obj/item/clothing/suit/armor/riot)))
			oopsie_mod -= 6

	if(HAS_TRAIT(user, TRAIT_CLUMSY))
		oopsie_mod += 6 //honk!

	var/oopsie = rand(danger_zone, 100)
	if(oopsie >= 94 && oopsie_mod < 0) // good job avoiding getting paralyzed! gold star!
		to_chat(user, "<span class='usernotice'>You're really glad you're wearing protection!</span>")
	oopsie += oopsie_mod

	switch(oopsie)
		if(99 to INFINITY)
			// can you imagine standing around minding your own business when all of the sudden some guy fucking launches himself into a wall at full speed and irreparably paralyzes himself?
			user.visible_message("<span class='danger'>[user] slams face-first into [hit] at an awkward angle, severing [user.p_their()] spinal column with a sickening crack! Fucking shit!</span>", "<span class='userdanger'>You slam face-first into [hit] at an awkward angle, severing your spinal column with a sickening crack! Fucking shit!</span>")
			var/obj/item/bodypart/head/hed = user.get_bodypart(BODY_ZONE_HEAD)
			if(hed)
				hed.receive_damage(brute=40, updating_health=FALSE, wound_bonus = 40)
			else
				user.adjustBruteLoss(40, updating_health=FALSE)
			user.adjustStaminaLoss(30)
			playsound(user, 'sound/effects/blobattack.ogg', 60, TRUE)
			playsound(user, 'sound/effects/splat.ogg', 70, TRUE)
			playsound(user, 'sound/effects/wounds/crack2.ogg', 70, TRUE)
			user.emote("scream")
			shake_camera(user, 7, 7)

		if(97 to 98)
			user.visible_message("<span class='danger'>[user] slams skull-first into [hit] with a sound like crumpled paper, revealing a horrifying breakage in [user.p_their()] cranium! Holy shit!</span>", "<span class='userdanger'>You slam skull-first into [hit] and your senses are filled with warm goo flooding across your face! Your skull is open!</span>")
			var/obj/item/bodypart/head/hed = user.get_bodypart(BODY_ZONE_HEAD)
			if(hed)
				hed.receive_damage(brute=30, updating_health=FALSE, wound_bonus = 25)
			else
				user.adjustBruteLoss(40, updating_health=FALSE)
			user.adjustStaminaLoss(30)
			playsound(user, 'sound/effects/blobattack.ogg', 60, TRUE)
			playsound(user, 'sound/effects/splat.ogg', 70, TRUE)
			user.emote("gurgle")
			shake_camera(user, 7, 7)

		if(93 to 96)
			user.visible_message("<span class='danger'>[user] slams face-first into [hit] with a concerning squish, immediately going limp!</span>", "<span class='userdanger'>You slam face-first into [hit], and immediately lose consciousness!</span>")
			user.adjustStaminaLoss(30)
			user.adjustBruteLoss(30)
			user.Unconscious(100)
			shake_camera(user, 6, 6)

		if(86 to 92)
			user.visible_message("<span class='danger'>[user] slams head-first into [hit], suffering major cranial trauma!</span>", "<span class='userdanger'>You slam head-first into [hit], and the world explodes around you!</span>")
			user.adjustStaminaLoss(30, updating_health=FALSE)
			user.adjustBruteLoss(30)
			user.add_confusion(15)
			user.Knockdown(40)
			shake_camera(user, 5, 5)

		if(68 to 85)
			user.visible_message("<span class='danger'>[user] slams hard into [hit], knocking [user.p_them()] senseless!</span>", "<span class='userdanger'>You slam hard into [hit], knocking yourself senseless!</span>")
			user.adjustStaminaLoss(30, updating_health=FALSE)
			user.adjustBruteLoss(10)
			user.add_confusion(10)
			user.Knockdown(30)
			shake_camera(user, 3, 4)

		if(1 to 67)
			user.visible_message("<span class='danger'>[user] slams into [hit]!</span>", "<span class='userdanger'>You slam into [hit]!</span>")
			user.adjustStaminaLoss(20, updating_health=FALSE)
			user.adjustBruteLoss(10)
			user.Knockdown(20)
			shake_camera(user, 2, 2)

	playsound(user, 'sound/weapons/smash.ogg', 70, TRUE)
