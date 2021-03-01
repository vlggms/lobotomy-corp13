/obj/structure/closet/secure_closet/quartermaster/Initialize()
	new /obj/item/clothing/shoes/sneakers/brown/digitigrade(src)
	new /obj/item/clothing/suit/hooded/wintercoat/cargo/head(src)
	. = ..()

/obj/structure/closet/secure_closet/engineering_chief/Initialize()
	new /obj/item/clothing/shoes/workboots/digitigrade(src)
	new /obj/item/clothing/suit/hooded/wintercoat/engineering/head(src)
	new /obj/item/gun/energy/disabler/head(src)
	new /obj/item/storage/lockbox/medal/ce(src)
	. = ..()

/obj/structure/closet/secure_closet/chief_medical/Initialize()
	new /obj/item/storage/belt/medical/surgeryfilled(src)
	new /obj/item/clothing/glasses/sunglasses/chemical(src)
	new /obj/item/clothing/shoes/sneakers/brown/digitigrade(src)
	new /obj/item/clothing/suit/hooded/wintercoat/medical/head(src)
	new /obj/item/gun/energy/disabler/head(src)
	new /obj/item/storage/lockbox/medal/cmo(src)
	. = ..()

/obj/structure/closet/secure_closet/research_director/Initialize()
	new /obj/item/clothing/shoes/laceup/digitigrade(src)
	new /obj/item/clothing/suit/hooded/wintercoat/science/head(src)
	new /obj/item/gun/energy/disabler/head(src)
	. = ..()

/obj/structure/closet/secure_closet/captains/Initialize()
	new /obj/item/clothing/shoes/digicombat(src)
	. = ..()

/obj/structure/closet/secure_closet/hop/Initialize()
	new /obj/item/clothing/shoes/laceup/digitigrade(src)
	new /obj/item/clothing/suit/hooded/wintercoat/captain/hop(src)
	. = ..()

/obj/structure/closet/secure_closet/hos/Initialize()
	new /obj/item/clothing/shoes/digicombat(src)
	new /obj/item/clothing/suit/hooded/wintercoat/security/head(src)
	. = ..()

/obj/structure/closet/secure_closet/warden/Initialize()
	new /obj/item/clothing/shoes/digicombat(src)
	. = ..()


//Medalboxes, was apparently removed at one point? Either way, it was supposed to be ported over.
/obj/item/storage/lockbox/medal/cmo
	name = "Chief Medical Officer's medal box"
	desc = "A locked box used to store medals to be given to those exhibiting excellence in the medical field."
	req_access = list(ACCESS_CMO)

/obj/item/storage/lockbox/medal/cmo/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/clothing/accessory/medal/ribbon/cmo(src)

/obj/item/clothing/accessory/medal/ribbon/cmo
	name = "\"medical excellence\" award"
	desc = "An award bestowed only upon those who have proven themselves a worthy follower of the Hippocratic Oath, which does not include 'Do no harm'."
	icon = 'ModularTegustation/Teguicons/tegu_medals.dmi'
	icon_state = "medical"

/obj/item/storage/lockbox/medal/ce
	name = "Chief Engineer's medal box"
	desc = "A locked box used to store medals to be given to those exhibiting excellence in Engineering or Atmospherics."
	req_access = list(ACCESS_CE)

/obj/item/storage/lockbox/medal/ce/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/clothing/accessory/medal/ribbon/ce(src)

/obj/item/clothing/accessory/medal/ribbon/ce
	name = "\"engineer of the shift\" award"
	desc = "An award bestowed only upon those who have mastered the craft of Engineering or Atmospherics, Glory to Engitopia."
	icon = 'ModularTegustation/Teguicons/tegu_medals.dmi'
	icon_state = "engineering"
