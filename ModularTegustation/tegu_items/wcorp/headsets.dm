//Wcorp headsets
/obj/item/radio/headset/wcorp
	name = "radio headset"
	desc = "An updated, modular intercom that fits over the head. Takes encryption keys, but only a few."
	icon_state = "headset"
	inhand_icon_state = "headset"
	freerange = TRUE
	freqlock = TRUE

/obj/item/radio/headset/wcorp/safety
	name = "axe squad radio headset"
	frequency = FREQ_SAFETY

/obj/item/radio/headset/wcorp/discipline
	name = "buckler squad radio headset"
	frequency = FREQ_DISCIPLINE


/obj/item/radio/headset/wcorp/welfare
	name = "cleaver radio headset"
	frequency = FREQ_WELFARE


//L3 headsets
/obj/item/radio/headset/wcorp/safety/head
	name = "axe squad captain radio headset"
	command = TRUE

/obj/item/radio/headset/wcorp/discipline/head
	name = "buckler squad captain radio headset"
	command = TRUE

/obj/item/radio/headset/wcorp/welfare/head
	name = "cleaver squad captain radio headset"
	command = TRUE

