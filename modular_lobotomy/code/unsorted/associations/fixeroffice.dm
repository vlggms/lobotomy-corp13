/obj/item/structurecapsule
	name = "structure capsule"
	desc = "A bluespace capsule that stores a schematic of a building."
	icon_state = "capsule"
	icon = 'icons/obj/mining.dmi'
	w_class = WEIGHT_CLASS_TINY
	var/template_id = "shelter_alpha"
	var/datum/map_template/shelter/template
	var/used = FALSE
	var/delay_time = 50

/obj/item/structurecapsule/proc/get_template()
	if(template)
		return
	template = SSmapping.shelter_templates[template_id]
	if(!template)
		WARNING("Shelter template ([template_id]) not found!")
		qdel(src)

/obj/item/structurecapsule/Destroy()
	template = null // without this, capsules would be one use. per round.
	. = ..()

/obj/item/structurecapsule/examine(mob/user)
	. = ..()
	get_template()
	. += "This capsule has the [template.name] stored."
	. += template.description

/obj/item/structurecapsule/attack_self()
	//Can't grab when capsule is New() because templates aren't loaded then
	get_template()
	if(!used)
		loc.visible_message(span_warning("\The [src] begins to shake. Stand back!"))
		used = TRUE
		sleep(delay_time)
		var/turf/deploy_location = get_turf(src)
		var/status = template.check_deploy(deploy_location)
		switch(status)
			if(SHELTER_DEPLOY_BAD_AREA)
				src.loc.visible_message(span_warning("\The [src] will not function in this area."))
			if(SHELTER_DEPLOY_BAD_TURFS, SHELTER_DEPLOY_ANCHORED_OBJECTS)
				var/width = template.width
				var/height = template.height
				src.loc.visible_message(span_warning("\The [src] doesn't have room to deploy! You need to clear a [width]x[height] area!"))
		if(status != SHELTER_DEPLOY_ALLOWED)
			used = FALSE
			return
		playsound(src, 'sound/effects/phasein.ogg', 100, TRUE)
		template.load(deploy_location, centered = TRUE)
		new /obj/effect/particle_effect/smoke(get_turf(src))
		qdel(src)


/obj/item/structurecapsule/fixer
	name = "Fishing Office Capsule"
	desc = "Use this capsule in a designated fixer office area to start your fishing fixer office."
	template_id = "fishingfixers_office"
	delay_time = 0

/obj/item/structurecapsule/fixer/attack_self()
	var/ready
	for(var/obj/effect/landmark/fixerbase/landmark in GLOB.landmarks_list)
		if((get_turf(landmark)) == (get_turf(src)))
			ready = TRUE
			break
	if(!ready)
		src.loc.visible_message(span_warning("\The [src] will not function in this area. Please move to a designated fixer office space."))
		return
	..()


/obj/item/structurecapsule/fixer/combat
	name = "Combat Office Capsule"
	template_id = "combatfixers_office"


/obj/item/structurecapsule/fixer/protection
	name = "Protection Office Capsule"
	template_id = "protectionfixers_office"

/obj/item/structurecapsule/fixer/workshop
	name = "Workshop Office Capsule"
	template_id = "workshopfixers_office"

/obj/item/structurecapsule/fixer/recon
	name = "Recon Office Capsule"
	template_id = "reconfixers_office"

/obj/item/structurecapsule/fixer/peacekeeper
	name = "Peacekeeper Office Capsule"
	template_id = "peacekeeperfixers_office"




//Office templates
/datum/map_template/shelter/fishingfixers
	name = "Fishing Office"
	shelter_id = "fishingfixers_office"
	description = "A fixer office made for fishhook fixers."
	mappath = "_maps/templates/fixer_office/fishingfixers.dmm"

/datum/map_template/shelter/combatfixers
	name = "Combat Office"
	shelter_id = "combatfixers_office"
	description = "A fixer office made for combat oriented fixers."
	mappath = "_maps/templates/fixer_office/combatfixers.dmm"

/datum/map_template/shelter/protectionfixers
	name = "Protection Office"
	shelter_id = "protectionfixers_office"
	description = "A fixer office made for protection oriented fixers."
	mappath = "_maps/templates/fixer_office/protectionfixers.dmm"

/datum/map_template/shelter/workshopfixers
	name = "Workshop Office"
	shelter_id = "workshopfixers_office"
	description = "A fixer office made for workshop oriented fixers."
	mappath = "_maps/templates/fixer_office/workshopfixers.dmm"

/datum/map_template/shelter/reconfixers
	name = "Recon Office"
	shelter_id = "reconfixers_office"
	description = "A fixer office made for recon oriented fixers."
	mappath = "_maps/templates/fixer_office/reconfixers.dmm"

/datum/map_template/shelter/peacefixerskeeper
	name = "Peacekeeper Office"
	shelter_id = "peacekeeperfixers_office"
	description = "A fixer office made for peacekeeping oriented fixers."
	mappath = "_maps/templates/fixer_office/peacekeepingfixers.dmm"





//Armor
/obj/item/storage/box/miscarmor
	name = "Misc Armor - 1"
	desc = "A kit containing misc gear."

/obj/item/storage/box/miscarmor/PopulateContents()
	new /obj/item/clothing/suit/armor/ego_gear/city/misc(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc(src)
	new /obj/item/storage/firstaid/regular(src)


/obj/item/storage/box/miscarmor/two
	name = "Misc Armor - 2"

/obj/item/storage/box/miscarmor/two/PopulateContents()
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/second(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/second(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/second(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/second(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/second(src)
	new /obj/item/storage/firstaid/regular(src)


/obj/item/storage/box/miscarmor/three
	name = "Misc Armor - 3"

/obj/item/storage/box/miscarmor/three/PopulateContents()
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/third(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/third(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/third(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/third(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/third(src)
	new /obj/item/storage/firstaid/regular(src)


/obj/item/storage/box/miscarmor/four
	name = "Misc Armor - 4"

/obj/item/storage/box/miscarmor/four/PopulateContents()
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/fourth(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/fourth(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/fourth(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/fourth(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/fourth(src)
	new /obj/item/storage/firstaid/regular(src)



/obj/item/storage/box/miscarmor/five
	name = "Misc Armor - 5"

/obj/item/storage/box/miscarmor/five/PopulateContents()
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/fifth(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/fifth(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/fifth(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/fifth(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/fifth(src)
	new /obj/item/storage/firstaid/regular(src)


/obj/item/storage/box/miscarmor/six
	name = "Misc Armor - 6"

/obj/item/storage/box/miscarmor/six/PopulateContents()
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/sixth(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/sixth(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/sixth(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/sixth(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/misc/sixth(src)
	new /obj/item/storage/firstaid/regular(src)
