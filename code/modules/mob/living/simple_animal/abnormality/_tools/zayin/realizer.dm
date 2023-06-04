/obj/structure/toolabnormality/realization
	name = "realization engine"
	desc = "An artifact used to find true potential within certains items."
	icon_state = "realization"
	var/static/realized_users = list()
	/// Assoc list 'input = output'
	var/list/output = list(
		// ZAYIN
		/obj/item/clothing/suit/armor/ego_gear/penitence = /obj/item/clothing/suit/armor/ego_gear/realization/confessional,
		/obj/item/storage/book/bible = /obj/item/clothing/suit/armor/ego_gear/realization/prophet, // TEMPORARY
		/obj/item/clothing/suit/armor/ego_gear/little_alice = /obj/item/clothing/suit/armor/ego_gear/realization/maiden,
		// TETH
		/obj/item/clothing/suit/armor/ego_gear/beak = /obj/item/clothing/suit/armor/ego_gear/realization/mouth,
		/obj/item/clothing/suit/armor/ego_gear/fragment = /obj/item/clothing/suit/armor/ego_gear/realization/universe,
		/obj/item/clothing/suit/armor/ego_gear/eyes = /obj/item/clothing/suit/armor/ego_gear/realization/death,
		/obj/item/clothing/suit/armor/ego_gear/daredevil = /obj/item/clothing/suit/armor/ego_gear/realization/fear,
		/obj/item/clothing/suit/armor/ego_gear/wrist = /obj/item/clothing/suit/armor/ego_gear/realization/exsanguination,
		/obj/item/clothing/suit/armor/ego_gear/match = /obj/item/clothing/suit/armor/ego_gear/realization/ember_matchlight,
		// HE
		/obj/item/clothing/suit/armor/ego_gear/grinder = /obj/item/clothing/suit/armor/ego_gear/realization/grinder,
		/obj/item/clothing/suit/armor/ego_gear/magicbullet = /obj/item/clothing/suit/armor/ego_gear/realization/bigiron,
		/obj/item/clothing/suit/armor/ego_gear/solemnlament = /obj/item/clothing/suit/armor/ego_gear/realization/eulogy,
		/obj/item/clothing/suit/armor/ego_gear/unrequited = /obj/item/clothing/suit/armor/ego_gear/realization/maiden,
		// WAW
		/obj/item/clothing/suit/armor/ego_gear/goldrush = /obj/item/clothing/suit/armor/ego_gear/realization/goldexperience,
		/obj/item/clothing/suit/armor/ego_gear/despair = /obj/item/clothing/suit/armor/ego_gear/realization/quenchedblood,
		/obj/item/clothing/suit/armor/ego_gear/hatred = /obj/item/clothing/suit/armor/ego_gear/realization/lovejustice,
		/obj/item/clothing/suit/armor/ego_gear/blind_rage = /obj/item/clothing/suit/armor/ego_gear/realization/woundedcourage,
		/obj/item/clothing/suit/armor/ego_gear/lamp = /obj/item/clothing/suit/armor/ego_gear/realization/eyes,
		/obj/item/clothing/suit/armor/ego_gear/oppression = /obj/item/clothing/suit/armor/ego_gear/realization/cruelty,
		/obj/item/clothing/suit/armor/ego_gear/executive = /obj/item/clothing/suit/armor/ego_gear/realization/capitalism,
		// ALEPH
		/obj/item/clothing/suit/armor/ego_gear/da_capo = /obj/item/clothing/suit/armor/ego_gear/realization/alcoda,
		/obj/item/clothing/suit/armor/ego_gear/justitia = /obj/item/clothing/suit/armor/ego_gear/realization/head,
		/obj/item/clothing/suit/armor/ego_gear/smile = /obj/item/clothing/suit/armor/ego_gear/realization/laughter,
		// Other
		/obj/item/ego_weapon/paradise = /obj/item/toy/plush/ayin, // He-he
		/obj/item/toy/plush/hokma = /obj/item/toy/plush/benjamin,
		/obj/item/toy/plush/angela = /obj/item/toy/plush/carmen,
		)

/obj/structure/toolabnormality/realization/attackby(obj/item/I, mob/living/carbon/human/user)
	. = ..()
	if(!ishuman(user))
		return

	if(!(I.type in output))
		to_chat(user, "<span class='warning'>The true potential of [I] cannot be realized.</span>")
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
