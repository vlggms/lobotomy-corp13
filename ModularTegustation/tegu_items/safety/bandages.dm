/// Safety department healing items for health, sanity, etc are covered here.
/// Injectors, bandages, and pills are the types of healing items.
/// These items take advantage of legacy code to make our own items.

/obj/item/reagent_containers/hypospray/medipen/safety
	name = "salicylic acid medipen"
	desc = "An autoinjector containing salicylic acid, used to treat severe brute damage."
	icon_state = "salacid"
	inhand_icon_state = "salacid"
	list_reagents = list(/datum/reagent/medicine/sal_acid = 5)

