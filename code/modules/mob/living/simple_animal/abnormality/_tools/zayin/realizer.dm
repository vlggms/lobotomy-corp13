/obj/structure/toolabnormality/realization
	name = "realization engine"
	desc = "An artifact used to find true potential within certains items."
	icon_state = "realization"
	var/static/realized_users = list()
	/// Assoc list 'input = output'
	var/list/output = list(
		// ZAYIN
		/obj/item/clothing/suit/armor/ego_gear/zayin/penitence 		= /obj/item/clothing/suit/armor/ego_gear/realization/confessional,
		/obj/item/storage/book/bible 								= /obj/item/clothing/suit/armor/ego_gear/realization/prophet, // TEMPORARY
		/obj/item/clothing/suit/armor/ego_gear/zayin/little_alice 	= /obj/item/clothing/suit/armor/ego_gear/realization/maiden,
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
		to_chat(user, "<span class='warning'>The true potential of [I] cannot be realized.</span>")
		return

	if((istype(I, /obj/item/clothing/suit/armor/ego_gear/waw/discord) || istype(I, /obj/item/clothing/suit/armor/ego_gear/waw/assonance)) && !YinYangCheck())
		to_chat(user, "<span class='warning'>The true potential of [I] cannot be realized without the other half.</span>")
		return

	if(user.ckey in realized_users)
		to_chat(user, "<span class='warning'>You have realized your full potential already.</span>")
		return

	var/stat_total = 0
	for(var/attribute in user.attributes)
		stat_total += get_raw_level(user, attribute)

	if(stat_total <= 500) // ~125 in all stats required
		to_chat(user, "<span class='warning'>You are too weak to use this machine.</span>")
		return

	var/atom/item_out = output[I.type]
	to_chat(user, "<span class='notice'>The machine is slowly turning [I] into [initial(item_out.name)]...</span>")
	if(!do_after(user, 5 SECONDS))
		return

	qdel(I)
	realized_users |= user.ckey
	user.adjust_all_attribute_levels(-10)
	var/atom/new_item = new item_out(get_turf(user))
	user.put_in_hands(new_item)
	to_chat(user, "<span class='nicegreen'>You retrieve [new_item] from the [src]!</span>")
	playsound(get_turf(src), 'sound/magic/clockwork/ratvar_attack.ogg', 50, TRUE)
