/obj/item/storage/belt/clerk
	name = "clerk toolbelt"
	desc = "Holds clerk tools and gadgets."
	icon_state = "utility"
	inhand_icon_state = "plantbelt"
	worn_icon_state = "plantbelt"
	custom_premium_price = PAYCHECK_MEDIUM * 2
	drop_sound = 'sound/items/handling/toolbelt_drop.ogg'
	pickup_sound =  'sound/items/handling/toolbelt_pickup.ogg'

/obj/item/storage/belt/clerk/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_combined_w_class = 600
	STR.max_items = 5
	STR.set_holdable(list(
		/obj/item/powered_gadget,
		/obj/item/pet_whistle,
		/obj/item/deepscanner,
		/obj/item/safety_kit,
		/obj/item/clerkbot_gadget,
		/obj/item/device/Plushie_Extractor,
		/obj/item/reagent_containers/hypospray/emais,
		/obj/item/forcefield_projector
		))

//For fucking about outside of combat
/obj/item/storage/belt/clerk/facility/PopulateContents()
	new /obj/item/safety_kit(src)
	new /obj/item/reagent_containers/hypospray/emais(src)
	new /obj/item/crowbar(src)
	new /obj/item/powered_gadget/teleporter(src)
	new /obj/item/forcefield_projector(src)


//For fucking about inside combat
/obj/item/storage/belt/clerk/agent/PopulateContents()
	new /obj/item/powered_gadget/slowingtrapmk1(src)
	new /obj/item/deepscanner(src)
	new /obj/item/clerkbot_gadget(src)
	new /obj/item/powered_gadget/vitals_projector(src)
	new /obj/item/powered_gadget/handheld_taser(src)
