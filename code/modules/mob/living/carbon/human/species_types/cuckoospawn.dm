/datum/species/cuckoospawn
	name = "Cuckoospawn"
	id = "cuckoo"
	mutant_bodyparts = list()
	say_mod = "chrips"
	sexes = 0 // cuckoo has no need for this

	nojumpsuit = TRUE
	species_traits = list(NO_UNDERWEAR, NOEYESPRITES)
	inherent_traits = list(TRAIT_PERFECT_ATTACKER, TRAIT_BRUTEPALE, TRAIT_BRUTESANITY, TRAIT_SANITYIMMUNE, TRAIT_GENELESS, TRAIT_COMBATFEAR_IMMUNE, TRAIT_NOGUNS)
	use_skintones = FALSE
	species_language_holder = /datum/language_holder/cuckoospawn
	mutanteyes = /obj/item/organ/eyes/night_vision/cuckoo
	limbs_id = "cuckoo"
	say_mod = "chrips"
	no_equip = list(ITEM_SLOT_EYES, ITEM_SLOT_MASK, ITEM_SLOT_FEET, ITEM_SLOT_OCLOTHING)
	changesource_flags = MIRROR_BADMIN | WABBAJACK
	liked_food = MEAT | RAW
	disliked_food = VEGETABLES | DAIRY
	attack_sound = 'sound/abnormalities/big_wolf/Wolf_Scratch.ogg'
	punchdamagelow = 24
	punchdamagehigh = 27
	stunmod = 0.5
	redmod = 0.4
	whitemod = 0.7
	blackmod = 0.4
	palemod = 0.7
	speedmod = -0.5
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
	var/tackle_stam_cost = 50
	/// See: [/datum/component/tackler/var/base_knockdown]
	var/base_knockdown = 1 SECONDS
	/// See: [/datum/component/tackler/var/range]
	var/tackle_range = 8
	/// See: [/datum/component/tackler/var/min_distance]
	var/min_distance = 0
	/// See: [/datum/component/tackler/var/speed]
	var/tackle_speed = 1.5
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
	AddComponent(/datum/component/footstep, FOOTSTEP_MOB_CLAW, 1, -6)
	adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 200)
	adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 200)
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

/mob/living/carbon/human/species/cuckoospawn/proc/executed_claw()
	var/turf/origin = get_turf(src)
	var/list/all_turfs = origin.GetAtmosAdjacentTurfs(1)
	for(var/turf/T in all_turfs)
		if(T == origin)
			continue
		new /obj/effect/temp_visual/dir_setting/claw_appears (T)
		break
	new /obj/effect/temp_visual/justitia_effect(get_turf(src))
	qdel(src)

/mob/living/carbon/human/species/cuckoospawn/attack_ghost(mob/dead/observer/ghost)
	if(key)
		to_chat(ghost, span_notice("Somebody is already controlling this bird."))
		return

	var/response = alert(ghost, "Do you want to take over this bird?", "Soul transfer", "Yes", "No")
	if(response == "No")
		return

	if(key)
		to_chat(ghost, span_notice("Somebody has taken this bird whilst you were busy selecting!"))
		return

	ckey = ghost.client.ckey

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

	if(T.stat != DEAD && prob(20) && (roll >= 0))
		var/obj/item/bodypart/chest/LC = T.get_bodypart(BODY_ZONE_CHEST)
		if((!LC || LC.status != BODYPART_ROBOTIC) && !T.getorgan(/obj/item/organ/body_egg/cuckoospawn_embryo))
			to_chat(S, span_nicegreen("You implant [T], soon a new niaojia-ren bird shall grow..."))
			new /obj/item/organ/body_egg/cuckoospawn_embryo(T)
			var/turf/TT = get_turf(T)
			log_game("[key_name(T)] was impregnated by a niaojia-ren at [loc_name(TT)]")

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

			user.Knockdown(30)
			target.apply_lc_tremor(5, 40)

		if(-1 to 0) // decent hit, both parties are about equally inconvenienced
			user.visible_message("<span class='warning'>[user] lands a passable [tackle_word] on [target], sending them both tumbling!</span>", "<span class='userdanger'>You land a passable [tackle_word] on [target], sending you both tumbling!</span>", ignored_mobs = target)
			to_chat(target, "<span class='userdanger'>[user] lands a passable [tackle_word] on you, sending you both tumbling!</span>")

			user.Knockdown(10)
			target.apply_lc_tremor(10, 40)

		if(1 to 2) // solid hit, tackler has a slight advantage
			user.visible_message("<span class='warning'>[user] lands a solid [tackle_word] on [target], knocking them both down hard!</span>", "<span class='userdanger'>You land a solid [tackle_word] on [target], knocking you both down hard!</span>", ignored_mobs = target)
			to_chat(target, "<span class='userdanger'>[user] lands a solid [tackle_word] on you, knocking you both down hard!</span>")

			user.Knockdown(10)
			target.apply_lc_tremor(15, 40)

		if(3 to 4) // really good hit, the target is definitely worse off here. Without positive modifiers, this is as good a tackle as you can land
			user.visible_message("<span class='warning'>[user] lands an expert [tackle_word] on [target], knocking [target.p_them()] down hard while landing on [user.p_their()] feet with a passive grip!</span>", "<span class='userdanger'>You land an expert [tackle_word] on [target], knocking [target.p_them()] down hard while landing on your feet with a passive grip!</span>", ignored_mobs = target)
			to_chat(target, "<span class='userdanger'>[user] lands an expert [tackle_word] on you, knocking you down hard and maintaining a passive grab!</span>")

			user.SetKnockdown(0)
			user.get_up(TRUE)
			user.forceMove(get_turf(target))
			target.apply_lc_tremor(25, 40)
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
