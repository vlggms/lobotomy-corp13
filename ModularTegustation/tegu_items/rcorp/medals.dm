/obj/item/clothing/accessory/medal/rcorp
	name = "distinguished conduct medal"
	desc = "A bronze medal awarded for distinguished conduct. Whilst a great honor, this is the most basic award given by R-Corp. \
		It is often awarded by an officer to one of their soldiers for going above and beyond the call of duty."

/obj/item/clothing/accessory/medal/silver/rcorp
	name = "medal of valor"
	desc = "An award for distinguished combat and sacrifice for R-Corp interests. Often awarded to disciplinary soldiers."

/obj/item/clothing/accessory/medal/gold/rcorp
	name = "medal of exceptional heroism"
	desc = "An extremely rare golden medal awarded only by R-Corp Commanders to their soldiers. \
	To receive such a medal is the highest honor and as such, very few exist. This medal is almost never awarded to anybody but captains."


//Medal Boxes
/obj/item/storage/lockbox/medal/officer
	name = "Captain's medal box"
	desc = "A locked box used to store medals to be given to those exhibiting excellence in the field."
	req_access = list(ACCESS_COMMAND)

/obj/item/storage/lockbox/medal/officer/PopulateContents()
	new /obj/item/clothing/accessory/medal/rcorp(src)

/obj/item/storage/lockbox/medal/lcdr
	name = "Lieutenant Commander's medal box"
	desc = "A locked box used to store medals to be given to those exhibiting excellence in the field."
	req_access = list(ACCESS_COMMAND)

/obj/item/storage/lockbox/medal/lcdr/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/clothing/accessory/medal/rcorp(src)
	new /obj/item/clothing/accessory/medal/silver/rcorp(src)

/obj/item/storage/lockbox/medal/cdr
	name = "Commander's medal box"
	desc = "A locked box used to store medals to be given to those exhibiting excellence in the field."
	req_access = list(ACCESS_MANAGER)

/obj/item/storage/lockbox/medal/cdr/PopulateContents()
	for(var/i in 1 to 3)
		new /obj/item/clothing/accessory/medal/rcorp(src)
	for(var/i in 1 to 2)
		new /obj/item/clothing/accessory/medal/silver/rcorp(src)
	new /obj/item/clothing/accessory/medal/gold/rcorp(src)
