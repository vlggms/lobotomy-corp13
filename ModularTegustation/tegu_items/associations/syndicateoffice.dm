/obj/item/structurecapsule/syndicate	//index
	name = "Index Capsule"
	desc = "Use this capsule in a designated syndicate hideout area to start your syndicate."
	template_id = "index_base"
	delay_time = 0

/obj/item/structurecapsule/syndicate/attack_self()
	var/ready
	for(var/obj/effect/landmark/syndicatebase/landmark in GLOB.landmarks_list)
		if((get_turf(landmark)) == (get_turf(src)))
			ready = TRUE
			break
	if(!ready)
		src.loc.visible_message("<span class='warning'>\The [src] will not function in this area. Please move to a designated syndicate hideout space.</span>")
		return
	..()

/obj/item/structurecapsule/syndicate/bladelineage
	name = "Blade Lineage Capsule"
	template_id = "bladelineage_base"


/obj/item/structurecapsule/syndicate/thumb
	name = "Thumb Capsule"
	template_id = "thumb_base"

/obj/item/structurecapsule/syndicate/ncorp
	name = "N-Corp Capsule"
	template_id = "ncorp_base"

/obj/item/structurecapsule/syndicate/kurokumo
	name = "Kurokumo Capsule"
	template_id = "kuro_base"




//Office templates
/datum/map_template/shelter/index
	name = "Index Base"
	shelter_id = "index_base"
	description = "A place for index."
	mappath = "_maps/templates/syndicate_office/index.dmm"

/datum/map_template/shelter/bladelineage
	name = "Blade Lineage Base"
	shelter_id = "bladelineage_base"
	description = "A place for blade lineage."
	mappath = "_maps/templates/syndicate_office/blade_lineage.dmm"

/datum/map_template/shelter/thumb
	name = "Thumb Base"
	shelter_id = "thumb_base"
	description = "A place for the thumb."
	mappath = "_maps/templates/syndicate_office/thumb.dmm"

/datum/map_template/shelter/ncorp
	name = "Ncorp Base"
	shelter_id = "ncorp_base"
	description = "A place for the Ncorp Inquisition."
	mappath = "_maps/templates/syndicate_office/ncorp.dmm"

/datum/map_template/shelter/kurokumo
	name = "Kurokumo Base"
	shelter_id = "kuro_base"
	description = "A place for the Kurokumo Clan."
	mappath = "_maps/templates/syndicate_office/kurokumo.dmm"

