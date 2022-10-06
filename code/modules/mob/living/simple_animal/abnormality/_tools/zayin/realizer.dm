/obj/structure/toolabnormality/realization
	name = "realization engine V1"
	desc = "A strange artifact."
	icon_state = "realization"
	var/output
	var/realized = list()
	var/stat_total
	var/list/stats = list(FORTITUDE_ATTRIBUTE,
			PRUDENCE_ATTRIBUTE,
			TEMPERANCE_ATTRIBUTE,
			JUSTICE_ATTRIBUTE)

/obj/structure/toolabnormality/realization/attackby(obj/item/I, mob/living/carbon/human/user)
	..()
	output = null

	if(user.ckey in realized)
		to_chat(user, "<span class='nicegreen'>You have realized your full potential already.</span>")
		return

	for(var/attribute in stats)
		stat_total += get_raw_level(user, attribute)

	if(stat_total <= 500) //EX agents only. All armor requires 130, but I'll let you get it a little early.
		to_chat(user, "<span class='userdanger'>You are too weak to use this machine.</span>")
		return

	if(istype(I, /obj/item/clothing/suit/armor/ego_gear/goldrush))
		output = /obj/item/clothing/suit/armor/ego_gear/realization/goldexperience

	if(istype(I, /obj/item/clothing/suit/armor/ego_gear/magicbullet))
		output = /obj/item/clothing/suit/armor/ego_gear/realization/bigiron

	if(istype(I, /obj/item/clothing/suit/armor/ego_gear/grinder))
		output = /obj/item/clothing/suit/armor/ego_gear/realization/grinder

	if(istype(I, /obj/item/clothing/suit/armor/ego_gear/da_capo))
		output = /obj/item/clothing/suit/armor/ego_gear/realization/alcoda

	if(istype(I, /obj/item/clothing/suit/armor/ego_gear/wrist))
		output = /obj/item/clothing/suit/armor/ego_gear/realization/exsanguination

	if(istype(I, /obj/item/clothing/suit/armor/ego_gear/solemnlament))
		output = /obj/item/clothing/suit/armor/ego_gear/realization/eulogy

	if(istype(I, /obj/item/clothing/suit/armor/ego_gear/eyes))
		output = /obj/item/clothing/suit/armor/ego_gear/realization/death

	if(istype(I, /obj/item/clothing/suit/armor/ego_gear/penitence))
		output = /obj/item/clothing/suit/armor/ego_gear/realization/confessional

	if(istype(I, /obj/item/clothing/suit/armor/ego_gear/fragment))
		output = /obj/item/clothing/suit/armor/ego_gear/realization/universe

	if(istype(I, /obj/item/clothing/suit/armor/ego_gear/beak))
		output = /obj/item/clothing/suit/armor/ego_gear/realization/mouth

	if(istype(I, /obj/item/clothing/suit/armor/ego_gear/lamp))
		output = /obj/item/clothing/suit/armor/ego_gear/realization/eyes

	if(istype(I, /obj/item/clothing/suit/armor/ego_gear/justitia))
		output = /obj/item/clothing/suit/armor/ego_gear/realization/head

	if(istype(I, /obj/item/clothing/suit/armor/ego_gear/daredevil))
		output = /obj/item/clothing/suit/armor/ego_gear/realization/fear

	if(istype(I, /obj/item/clothing/suit/armor/ego_gear/executive))
		output = /obj/item/clothing/suit/armor/ego_gear/realization/capitalism

	if(istype(I, /obj/item/clothing/suit/armor/ego_gear/smile))
		output = /obj/item/clothing/suit/armor/ego_gear/realization/laughter

	if(istype(I, /obj/item/clothing/suit/armor/ego_gear/oppression))
		output = /obj/item/clothing/suit/armor/ego_gear/realization/cruelty

	if(output)
		qdel(I)
		realized += user.ckey
		var/location = get_turf(user)
		new output(location)
		to_chat(user, "<span class='nicegreen'>You realize your full potential.</span>")
		user.adjust_all_attribute_levels(-30)

	else
		to_chat(user, "<span class='userdanger'>This armor is incompatible with the engine.</span>")

