/obj/structure/toolabnormality/realization
	name = "realization engine"
	desc = "An artifact used to find true potential within certains items."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "bough_pedestal"
	var/static/realized_users = list()
	/// Assoc list 'input = output'
	var/list/output = list(
		// ZAYIN
		/obj/item/clothing/suit/armor/ego_gear/zayin/penitence 		= /obj/item/clothing/suit/armor/ego_gear/realization/confessional,
		/obj/item/storage/book/bible 								= /obj/item/clothing/suit/armor/ego_gear/realization/prophet, // TEMPORARY
		/obj/item/clothing/suit/armor/ego_gear/zayin/little_alice 	= /obj/item/clothing/suit/armor/ego_gear/realization/maiden,
		/obj/item/clothing/suit/armor/ego_gear/zayin/soda			= /obj/item/clothing/suit/armor/ego_gear/realization/wellcheers,
		/obj/item/clothing/suit/armor/ego_gear/zayin/doze			= /obj/item/clothing/suit/armor/ego_gear/realization/comatose,
		/obj/item/clothing/suit/armor/ego_gear/tools/bucket			= /obj/item/clothing/suit/armor/ego_gear/realization/brokencrown,
		// TETH
		/obj/item/clothing/suit/armor/ego_gear/teth/beak 			= /obj/item/clothing/suit/armor/ego_gear/realization/mouth,
		/obj/item/clothing/suit/armor/ego_gear/teth/fragment 		= /obj/item/clothing/suit/armor/ego_gear/realization/universe,
		/obj/item/clothing/suit/armor/ego_gear/teth/eyes 			= /obj/item/clothing/suit/armor/ego_gear/realization/death,
		/obj/item/clothing/suit/armor/ego_gear/teth/daredevil		= /obj/item/clothing/suit/armor/ego_gear/realization/fear,
		/obj/item/clothing/suit/armor/ego_gear/teth/wrist 			= /obj/item/clothing/suit/armor/ego_gear/realization/exsanguination,
		/obj/item/clothing/suit/armor/ego_gear/teth/match 			= /obj/item/clothing/suit/armor/ego_gear/realization/ember_matchlight,
		/obj/item/clothing/suit/armor/ego_gear/teth/blossoms 		= /obj/item/clothing/suit/armor/ego_gear/realization/sakura_bloom,
		// HE
		/obj/item/clothing/suit/armor/ego_gear/he/grinder 			= /obj/item/clothing/suit/armor/ego_gear/realization/grinder,
		/obj/item/clothing/suit/armor/ego_gear/he/magicbullet		= /obj/item/clothing/suit/armor/ego_gear/realization/bigiron,
		/obj/item/clothing/suit/armor/ego_gear/he/solemnlament 		= /obj/item/clothing/suit/armor/ego_gear/realization/eulogy,
		/obj/item/clothing/suit/armor/ego_gear/he/galaxy    		= /obj/item/clothing/suit/armor/ego_gear/realization/ourgalaxy,
		/obj/item/clothing/suit/armor/ego_gear/he/unrequited 		= /obj/item/clothing/suit/armor/ego_gear/realization/forever,
		/obj/item/clothing/suit/armor/ego_gear/he/harvest 			= /obj/item/clothing/suit/armor/ego_gear/realization/wisdom,
		/obj/item/clothing/suit/armor/ego_gear/he/logging		    = /obj/item/clothing/suit/armor/ego_gear/realization/empathy,
		/obj/item/clothing/suit/armor/ego_gear/he/courage           = /obj/item/clothing/suit/armor/ego_gear/realization/valor,
		/obj/item/clothing/suit/armor/ego_gear/he/homing_instinct   = /obj/item/clothing/suit/armor/ego_gear/realization/home,
		/obj/item/clothing/suit/armor/ego_gear/he/warp   			= /obj/item/clothing/suit/armor/ego_gear/realization/dimension_ripper,
		// WAW
		/obj/item/clothing/suit/armor/ego_gear/waw/goldrush 		= /obj/item/clothing/suit/armor/ego_gear/realization/goldexperience,
		/obj/item/clothing/suit/armor/ego_gear/waw/despair 			= /obj/item/clothing/suit/armor/ego_gear/realization/quenchedblood,
		/obj/item/clothing/suit/armor/ego_gear/waw/hatred 			= /obj/item/clothing/suit/armor/ego_gear/realization/lovejustice,
		/obj/item/clothing/suit/armor/ego_gear/waw/blind_rage 		= /obj/item/clothing/suit/armor/ego_gear/realization/woundedcourage,
		/obj/item/clothing/suit/armor/ego_gear/waw/crimson 			= /obj/item/clothing/suit/armor/ego_gear/realization/crimson,
		/obj/item/clothing/suit/armor/ego_gear/waw/lamp 			= /obj/item/clothing/suit/armor/ego_gear/realization/eyes,
		/obj/item/clothing/suit/armor/ego_gear/waw/oppression 		= /obj/item/clothing/suit/armor/ego_gear/realization/cruelty,
		/obj/item/clothing/suit/armor/ego_gear/waw/thirteen 		= /obj/item/clothing/suit/armor/ego_gear/realization/bell_tolls,
		/obj/item/clothing/suit/armor/ego_gear/waw/executive 		= /obj/item/clothing/suit/armor/ego_gear/realization/capitalism,
		/obj/item/clothing/suit/armor/ego_gear/waw/thirteen			= /obj/item/clothing/suit/armor/ego_gear/realization/bell_tolls,
		/obj/item/clothing/suit/armor/ego_gear/waw/assonance		= /obj/item/clothing/suit/armor/ego_gear/realization/duality_yang,
		/obj/item/clothing/suit/armor/ego_gear/waw/discord			= /obj/item/clothing/suit/armor/ego_gear/realization/duality_yin,
		/obj/item/clothing/suit/armor/ego_gear/waw/heart			= /obj/item/clothing/suit/armor/ego_gear/realization/repentance,
		/obj/item/clothing/suit/armor/ego_gear/waw/exuviae			= /obj/item/clothing/suit/armor/ego_gear/realization/nest,
		// ALEPH
		/obj/item/clothing/suit/armor/ego_gear/aleph/da_capo 		= /obj/item/clothing/suit/armor/ego_gear/realization/alcoda,
		/obj/item/clothing/suit/armor/ego_gear/aleph/justitia 		= /obj/item/clothing/suit/armor/ego_gear/realization/head,
		/obj/item/clothing/suit/armor/ego_gear/aleph/smile 			= /obj/item/clothing/suit/armor/ego_gear/realization/laughter,
		/obj/item/clothing/suit/armor/ego_gear/aleph/mimicry 		= /obj/item/clothing/suit/armor/ego_gear/realization/shell,
		/obj/item/clothing/suit/armor/ego_gear/aleph/space 			= /obj/item/clothing/suit/armor/ego_gear/realization/fallencolors,
		/obj/item/clothing/suit/armor/ego_gear/aleph/combust 		= /obj/item/clothing/suit/armor/ego_gear/realization/desperation,
		// Personal
		/obj/item/managerbullet = /obj/item/clothing/suit/armor/ego_gear/realization/farmwatch,
		/obj/item/storage/box/fireworks/dangerous = /obj/item/clothing/suit/armor/ego_gear/realization/spicebush,//from smuggler's satchels
		// Other
		/obj/item/ego_weapon/paradise = /obj/item/toy/plush/ayin, // He-he
		/obj/item/toy/plush/hokma = /obj/item/toy/plush/benjamin,
		/obj/item/toy/plush/angela = /obj/item/toy/plush/carmen,
		)

	//Visual vars
	var/obj/effect/golden_bough/bough //The bough effect that is spawned above the pedestal
	var/f1 //Filter 1, Ripple filter
	var/f2 //Filter 2, Rays filter

/obj/structure/toolabnormality/realization/Initialize()
	..()
	bough = new/obj/effect/golden_bough(src)

	//Filter 1 gets applied to the bough
	bough.filters += filter(type="ripple", x = 0, y = 11, size = 20, repeat = 6, radius = 0, falloff = 1)
	f1 = bough.filters[bough.filters.len]

	//Filter 2 gets applied to the pedestal
	filters += filter(type="rays", x = 0, y = 11, size = 20, color = COLOR_VERY_SOFT_YELLOW, offset = 0.2, density = 10, factor = 0.4, threshold = 0.5)
	f2 = filters[filters.len]
	vis_contents += bough

	FilterLoop(1) //Starts the filter's loop

/obj/structure/toolabnormality/realization/Destroy()
	qdel(bough)
	..()

/obj/structure/toolabnormality/realization/proc/FilterLoop(loop_stage) //Takes a numeric argument for advancing the loop's stage in a cycle (1 > 2 > 3 > 1 > ...)
	if(filters[filters.len]) // Stops the loop if we have no filters to animate
		switch(loop_stage)
			if(1)
				animate(f1, radius = 60, time = 60, flags = CIRCULAR_EASING | EASE_OUT | ANIMATION_PARALLEL)
				animate(f2, size = 30, offset = pick(4,5,6), time = 60, flags = SINE_EASING | EASE_OUT | ANIMATION_PARALLEL)
				addtimer(CALLBACK(src, PROC_REF(FilterLoop), 2), 6 SECONDS)
			if(2)
				animate(f1, size = 25, radius = 80, time = 20, flags = CIRCULAR_EASING | EASE_OUT | ANIMATION_PARALLEL)
				animate(f2, size = 20, offset = pick(0.2,0.4), time = 60, flags = SINE_EASING | EASE_OUT | ANIMATION_END_NOW | ANIMATION_PARALLEL)
				addtimer(CALLBACK(src, PROC_REF(FilterLoop), 3), 2 SECONDS)
			if(3)
				animate(f1, size = 20, radius = 0, time = 0, flags = CIRCULAR_EASING | EASE_IN | EASE_OUT | ANIMATION_PARALLEL)
				addtimer(CALLBACK(src, PROC_REF(FilterLoop), 1), 4 SECONDS)
		update_icon()

/obj/structure/toolabnormality/realization/proc/YinYangCheck()
	for(var/datum/abnormality/AD in SSlobotomy_corp.all_abnormality_datums)
		if(AD.abno_path == /mob/living/simple_animal/hostile/abnormality/yang)
			for(var/datum/abnormality/AD2 in SSlobotomy_corp.all_abnormality_datums)
				if(AD2.abno_path == /mob/living/simple_animal/hostile/abnormality/yin)
					return TRUE
	return FALSE

/obj/structure/toolabnormality/realization/attackby(obj/item/I, mob/living/carbon/human/user)
	. = ..()
	if(!ishuman(user))
		return

	if(!(I.type in output))
		to_chat(user, span_warning("The true potential of [I] cannot be realized."))
		return

	if((istype(I, /obj/item/clothing/suit/armor/ego_gear/waw/discord) || istype(I, /obj/item/clothing/suit/armor/ego_gear/waw/assonance)) && !YinYangCheck())
		to_chat(user, span_warning("The true potential of [I] cannot be realized without the other half."))
		return

	if(user.ckey in realized_users)
		to_chat(user, span_warning("You have realized your full potential already."))
		return

	var/stat_total = 0
	for(var/attribute in user.attributes)
		stat_total += get_raw_level(user, attribute)

	if(stat_total <= 500) // ~125 in all stats required
		to_chat(user, span_warning("You are too weak to use this machine."))
		return

	var/atom/item_out = output[I.type]
	to_chat(user, span_notice("The machine is slowly turning [I] into [initial(item_out.name)]..."))
	if(!do_after(user, 5 SECONDS))
		return

	qdel(I)
	realized_users |= user.ckey
	var/atom/new_item = new item_out(get_turf(user))
	user.put_in_hands(new_item)
	to_chat(user, span_nicegreen("You retrieve [new_item] from the [src]!"))
	playsound(get_turf(src), 'sound/magic/clockwork/ratvar_attack.ogg', 50, TRUE)
