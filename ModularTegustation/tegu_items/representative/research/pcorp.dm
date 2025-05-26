//-----P_CORP-----
//P Corp sells different storage items
///Backpack Items Line
/datum/data/lc13research/pcorpbackpack
	research_name = "P Corp Large Backpack (x2)"
	research_desc = "Dear ambassador. We have new items for you! <br>Brand new backpacks that hold massive items. "
	cost = AVERAGE_RESEARCH_PRICE
	corp = P_CORP_REP

/datum/data/lc13research/pcorpbackpack/ResearchEffect(obj/structure/representative_console/requester)
	new /obj/item/storage/backpack/pcorp(get_turf(requester))
	new /obj/item/storage/backpack/pcorp(get_turf(requester))
	..()

/datum/data/lc13research/bigpcorpbackpack
	research_name = "P Corp XL Backpack (x2)"
	research_desc = "Dear ambassador. We have new items for you! <br>Brand new backpacks that hold massive items. <br>This one holds 5, but slows you down a little more."
	cost = AVERAGE_RESEARCH_PRICE+5
	corp = P_CORP_REP
	required_research = /datum/data/lc13research/pcorpbackpack

/datum/data/lc13research/bigpcorpbackpack/ResearchEffect(obj/structure/representative_console/requester)
	new /obj/item/storage/backpack/pcorpheavy(get_turf(requester))
	new /obj/item/storage/backpack/pcorpheavy(get_turf(requester))
	..()

//Belt lines
/datum/data/lc13research/egobelt
	research_name = "P Corp Twin EGO Belt (x2)"
	research_desc = "Dear ambassador. We have new items for you! <br>A belt that holds twin EGO for the LCorp agents. <br>Ship only to their best. "
	cost = AVERAGE_RESEARCH_PRICE
	corp = P_CORP_REP
	required_research = /datum/data/lc13research/pcorpbackpack

/datum/data/lc13research/egobelt/ResearchEffect(obj/structure/representative_console/requester)
	new /obj/item/storage/belt/egopcorp(get_turf(requester))
	new /obj/item/storage/belt/egopcorp(get_turf(requester))
	..()

/datum/data/lc13research/armorbelt
	research_name = "P Corp EGO Armor Belt (x2)"
	research_desc = "Dear ambassador. We have new items for you! <br>A belt that holds three EGO armor for the LCorp agents. <br>Ship only to their best. "
	cost = AVERAGE_RESEARCH_PRICE
	corp = P_CORP_REP
	required_research = /datum/data/lc13research/pcorpbackpack

/datum/data/lc13research/armorbelt/ResearchEffect(obj/structure/representative_console/requester)
	new /obj/item/storage/belt/egoarmor(get_turf(requester))
	new /obj/item/storage/belt/egoarmor(get_turf(requester))
	..()

//Pockets line
/datum/data/lc13research/pocketpouch
	research_name = "Repurchasable: P Corp Pouch (x2)"
	research_desc = "Dear ambassador. We have new items for you! <br>A pocket extender for the LCorp agents. <br>Ship only to their best. "
	cost = LOW_RESEARCH_PRICE
	corp = P_CORP_REP
	required_research = /datum/data/lc13research/pcorpbackpack

/datum/data/lc13research/pocketpouch/ResearchEffect(obj/structure/representative_console/requester)
	new /obj/item/storage/pcorp_pocket(get_turf(requester))
	new /obj/item/storage/pcorp_pocket(get_turf(requester))

/datum/data/lc13research/pocketpistol
	research_name = "Repurchasable: P Corp Weapon Pouch (x2)"
	research_desc = "Dear ambassador. We have new items for you! <br>A pocket extender for the LCorp agents that holds one small weapon. <br>Ship only to their best. "
	cost = LOW_RESEARCH_PRICE
	corp = P_CORP_REP
	required_research = /datum/data/lc13research/pcorpbackpack

/datum/data/lc13research/pocketpistol/ResearchEffect(obj/structure/representative_console/requester)
	new /obj/item/storage/pcorp_weapon(get_turf(requester))
	new /obj/item/storage/pcorp_weapon(get_turf(requester))


//Gloves line
/datum/data/lc13research/smallgloves
	research_name = "Repurchasable: P Corp Dimensional Gloves"
	research_desc = "Dear ambassador. We have new items for you! <br>Gloves that hold various small EGO weapons. <br>Ship only to their best. "
	cost = AVERAGE_RESEARCH_PRICE
	corp = P_CORP_REP
	required_research = /datum/data/lc13research/pcorpbackpack

/datum/data/lc13research/smallgloves/ResearchEffect(obj/structure/representative_console/requester)
	new /obj/item/clothing/gloves/pcorp(get_turf(requester))

/datum/data/lc13research/pcorpgloves
	research_name = "Repurchasable: P Corp Dimensional Gloves MK2"
	research_desc = "Dear ambassador. We have new items for you! <br>Gloves that can hold a single EGO weapon of any size <br>Ship only to their best. "
	cost = AVERAGE_RESEARCH_PRICE
	corp = P_CORP_REP
	required_research = /datum/data/lc13research/bigpcorpbackpack

/datum/data/lc13research/pcorpgloves/ResearchEffect(obj/structure/representative_console/requester)
	new /obj/item/clothing/gloves/pcorpbig(get_turf(requester))

//Funny Crate
/datum/data/lc13research/crate
	research_name = "P Corp Speed Crate (x2)"
	research_desc = "Dear ambassador. We have new items for you! <br>A crate that speeds you up as you drag it! <br>We're 99% sure it won't explode but you know... <br> Can't make any better guarantees. "
	cost = AVERAGE_RESEARCH_PRICE
	corp = P_CORP_REP
	required_research = /datum/data/lc13research/pcorpbackpack

/datum/data/lc13research/crate/ResearchEffect(obj/structure/representative_console/requester)
	new /obj/structure/closet/crate/pcorp(get_turf(requester))
	new /obj/structure/closet/crate/pcorp(get_turf(requester))
	..()

//Fishing line
/datum/data/lc13research/pond
	research_name = "P Corp Portable Fishing Pond"
	research_desc = "Dear ambassador. We have new items for you! <br>A Fishing Pond compressed into a easily portable device! <br>Inside the pond there is another layer of compression allowing hypothetically infinite fish of infinite variety to exist within. <br>We spent a lot on this, do find a buyer for us."
	cost = AVERAGE_RESEARCH_PRICE
	corp = P_CORP_REP
	required_research = /datum/data/lc13research/pcorpbackpack

/datum/data/lc13research/pond/ResearchEffect(obj/structure/representative_console/requester)
	new /obj/item/pondpod(get_turf(requester))
	..()

/datum/data/lc13research/cannery
	research_name = "P Corp Portable Fish Cannery"
	research_desc = "Dear ambassador. We have new items for you! <br>A Fish Cannery compressed into a easily portable device! <br>This cannery takes the raw parts of a fish and grinds them into canned raw Enkephalin ready for use."
	cost = AVERAGE_RESEARCH_PRICE + 10
	corp = P_CORP_REP
	required_research = /datum/data/lc13research/pond

/datum/data/lc13research/cannery/ResearchEffect(obj/structure/representative_console/requester)
	new /obj/item/cannerypod(get_turf(requester))
	..()

//Safety line
/datum/data/lc13research/locationpreservation
	research_name = "P Corp Safety Beacon"
	research_desc = "Dear ambassador. We have new items for you! <br>A beacon capable of saving it's user and taking them to safety! <br>This beacon was made through a collaboration with W-Corp, so we expect you to find buyers ambassador."
	cost = AVERAGE_RESEARCH_PRICE
	corp = P_CORP_REP
	required_research = /datum/data/lc13research/pcorpbackpack

/datum/data/lc13research/locationpreservation/ResearchEffect(obj/structure/representative_console/requester)
	ItemUnlock(requester.order_list, "Lifevest Safety Beacon",	/obj/item/pcorp_beacon, 500)
	..()
