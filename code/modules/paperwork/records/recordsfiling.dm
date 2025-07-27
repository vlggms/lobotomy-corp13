/*
 * Records Cabinet
 */

//Zayin
/obj/structure/filingcabinet/zayininfo
	name = "zayin abnormality information cabinet"
	icon_state = "employmentcabinet"
	var/virgin = TRUE

/obj/structure/filingcabinet/zayininfo/proc/fillCurrent()
	var/list/queue = subtypesof(/obj/item/paper/fluff/info/zayin)
	for(var/sheet in queue)
		new sheet(src)


/obj/structure/filingcabinet/zayininfo/interact(mob/user)
	if(virgin)
		fillCurrent()
		virgin = FALSE
	return ..()

//Teths
/obj/structure/filingcabinet/tethinfo
	name = "teth abnormality information cabinet"
	icon_state = "employmentcabinet"
	var/virgin = TRUE

/obj/structure/filingcabinet/tethinfo/proc/fillCurrent()
	var/list/queue = subtypesof(/obj/item/paper/fluff/info/teth)
	for(var/sheet in queue)
		new sheet(src)


/obj/structure/filingcabinet/tethinfo/interact(mob/user)
	if(virgin)
		fillCurrent()
		virgin = FALSE
	return ..()

//HEs
/obj/structure/filingcabinet/heinfo
	name = "he abnormality information cabinet"
	icon_state = "employmentcabinet"
	var/virgin = TRUE

/obj/structure/filingcabinet/heinfo/proc/fillCurrent()
	var/list/queue = subtypesof(/obj/item/paper/fluff/info/he)
	for(var/sheet in queue)
		new sheet(src)


/obj/structure/filingcabinet/heinfo/interact(mob/user)
	if(virgin)
		fillCurrent()
		virgin = FALSE
	return ..()


//WAWs
/obj/structure/filingcabinet/wawinfo
	name = "waw abnormality information cabinet"
	icon_state = "employmentcabinet"
	var/virgin = TRUE

/obj/structure/filingcabinet/wawinfo/proc/fillCurrent()
	var/list/queue = subtypesof(/obj/item/paper/fluff/info/waw)
	for(var/sheet in queue)
		new sheet(src)


/obj/structure/filingcabinet/wawinfo/interact(mob/user)
	if(virgin)
		fillCurrent()
		virgin = FALSE
	return ..()

//Aleph
/obj/structure/filingcabinet/alephinfo
	name = "aleph abnormality information cabinet"
	icon_state = "employmentcabinet"
	var/virgin = TRUE

/obj/structure/filingcabinet/alephinfo/proc/fillCurrent()
	var/list/queue = subtypesof(/obj/item/paper/fluff/info/aleph)
	for(var/sheet in queue)
		new sheet(src)


/obj/structure/filingcabinet/alephinfo/interact(mob/user)
	if(virgin)
		fillCurrent()
		virgin = FALSE
	return ..()

//Tools
/obj/structure/filingcabinet/toolinfo
	name = "tool abnormality information cabinet"
	icon_state = "employmentcabinet"
	var/virgin = TRUE

/obj/structure/filingcabinet/toolinfo/proc/fillCurrent()
	var/list/queue = subtypesof(/obj/item/paper/fluff/info/tool)
	for(var/sheet in queue)
		new sheet(src)


/obj/structure/filingcabinet/toolinfo/interact(mob/user)
	if(virgin)
		fillCurrent()
		virgin = FALSE
	return ..()


/*
 * Lore Cabinet
 */

/obj/structure/filingcabinet/lore
	name = "template supplimentary information cabinet"
	icon_state = "employmentcabinet"
	var/virgin = TRUE
	var/list/infotype = /obj/item/paper/fluff/lore/zayin

/obj/structure/filingcabinet/lore/interact(mob/user)
	if(virgin)
		fillCurrent()
		virgin = FALSE
	return ..()

/obj/structure/filingcabinet/lore/proc/fillCurrent()
	for(var/sheet in subtypesof(infotype))
		new sheet(src)


//Zayin
/obj/structure/filingcabinet/lore/zayin
	name = "zayin supplimentary information cabinet"
	infotype = /obj/item/paper/fluff/lore/zayin

//Teth
/obj/structure/filingcabinet/lore/teth
	name = "teth supplimentary information cabinet"
	infotype = /obj/item/paper/fluff/lore/teth

//He
/obj/structure/filingcabinet/lore/he
	name = "he supplimentary information cabinet"
	infotype = /obj/item/paper/fluff/lore/he

//Waw
/obj/structure/filingcabinet/lore/waw
	name = "waw supplimentary information cabinet"
	infotype = /obj/item/paper/fluff/lore/waw

//Aleph
/obj/structure/filingcabinet/lore/aleph
	name = "aleph supplimentary information cabinet"
	infotype = /obj/item/paper/fluff/lore/aleph
