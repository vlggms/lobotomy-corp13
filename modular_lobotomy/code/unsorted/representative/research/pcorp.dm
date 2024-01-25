//-----P_CORP-----
//P Corp sells different storage items
///Backpack Items Line
/datum/data/lc13research/pcorpbackpack
	research_name = "P Corp Large Backpack (x2)"
	research_desc = "Dear ambassador. We have new items for you! <br>Brand new backpacks that hold massive items. "
	cost = AVERAGE_RESEARCH_PRICE
	corp = P_CORP_REP

/datum/data/lc13research/pcorpbackpack/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/storage/backpack/pcorp(get_turf(caller))
	new /obj/item/storage/backpack/pcorp(get_turf(caller))
	..()

/datum/data/lc13research/bigpcorpbackpack
	research_name = "P Corp XL Backpack (x2)"
	research_desc = "Dear ambassador. We have new items for you! <br>Brand new backpacks that hold massive items. <br>This one holds 5, but slows you down a little more."
	cost = AVERAGE_RESEARCH_PRICE+5
	corp = P_CORP_REP
	required_research = /datum/data/lc13research/pcorpbackpack

/datum/data/lc13research/bigpcorpbackpack/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/storage/backpack/pcorpheavy(get_turf(caller))
	new /obj/item/storage/backpack/pcorpheavy(get_turf(caller))
	..()

//Belt lines
/datum/data/lc13research/egobelt
	research_name = "P Corp Twin EGO Belt (x2)"
	research_desc = "Dear ambassador. We have new items for you! <br>A belt that holds twin EGO for the LCorp agents. <br>Ship only to their best. "
	cost = AVERAGE_RESEARCH_PRICE
	corp = P_CORP_REP
	required_research = /datum/data/lc13research/pcorpbackpack

/datum/data/lc13research/egobelt/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/storage/belt/egopcorp(get_turf(caller))
	new /obj/item/storage/belt/egopcorp(get_turf(caller))
	..()

/datum/data/lc13research/armorbelt
	research_name = "P Corp EGO Armor Belt (x2)"
	research_desc = "Dear ambassador. We have new items for you! <br>A belt that holds three EGO armor for the LCorp agents. <br>Ship only to their best. "
	cost = AVERAGE_RESEARCH_PRICE
	corp = P_CORP_REP
	required_research = /datum/data/lc13research/pcorpbackpack

/datum/data/lc13research/armorbelt/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/storage/belt/egoarmor(get_turf(caller))
	new /obj/item/storage/belt/egoarmor(get_turf(caller))
	..()


//Pockets line
/datum/data/lc13research/pocketpouch
	research_name = "Repurchasable: P Corp Pouch (x2)"
	research_desc = "Dear ambassador. We have new items for you! <br>A pocket extender for the LCorp agents. <br>Ship only to their best. "
	cost = LOW_RESEARCH_PRICE
	corp = P_CORP_REP
	required_research = /datum/data/lc13research/pcorpbackpack

/datum/data/lc13research/pocketpouch/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/storage/pcorp_pocket(get_turf(caller))
	new /obj/item/storage/pcorp_pocket(get_turf(caller))

/datum/data/lc13research/pocketpistol
	research_name = "Repurchasable: P Corp Weapon Pouch (x2)"
	research_desc = "Dear ambassador. We have new items for you! <br>A pocket extender for the LCorp agents that holds one small weapon. <br>Ship only to their best. "
	cost = LOW_RESEARCH_PRICE
	corp = P_CORP_REP
	required_research = /datum/data/lc13research/pcorpbackpack

/datum/data/lc13research/pocketpistol/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/storage/pcorp_weapon(get_turf(caller))
	new /obj/item/storage/pcorp_weapon(get_turf(caller))


//Gloves line
/datum/data/lc13research/smallgloves
	research_name = "Repurchasable: P Corp Dimensional Gloves"
	research_desc = "Dear ambassador. We have new items for you! <br>Gloves that hold various small EGO weapons. <br>Ship only to their best. "
	cost = AVERAGE_RESEARCH_PRICE
	corp = P_CORP_REP
	required_research = /datum/data/lc13research/pcorpbackpack

/datum/data/lc13research/smallgloves/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/clothing/gloves/pcorp(get_turf(caller))

/datum/data/lc13research/pcorpgloves
	research_name = "Repurchasable: P Corp Dimensional Gloves MK2"
	research_desc = "Dear ambassador. We have new items for you! <br>Gloves that can hold a single EGO weapon of any size <br>Ship only to their best. "
	cost = AVERAGE_RESEARCH_PRICE
	corp = P_CORP_REP
	required_research = /datum/data/lc13research/bigpcorpbackpack

/datum/data/lc13research/pcorpgloves/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/item/clothing/gloves/pcorpbig(get_turf(caller))



//Funny Crate
/datum/data/lc13research/crate
	research_name = "P Corp Speed Crate (x2)"
	research_desc = "Dear ambassador. We have new items for you! <br>A crate that speeds you up as you drag it! <br>We're 99% sure it won't explode but you know... <br> Can't make any better guarantees. "
	cost = AVERAGE_RESEARCH_PRICE
	corp = P_CORP_REP
	required_research = /datum/data/lc13research/pcorpbackpack

/datum/data/lc13research/crate/ResearchEffect(obj/structure/representative_console/caller)
	new /obj/structure/closet/crate/pcorp(get_turf(caller))
	new /obj/structure/closet/crate/pcorp(get_turf(caller))
	..()


