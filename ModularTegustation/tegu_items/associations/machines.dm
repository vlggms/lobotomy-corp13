/obj/structure/itemselling
	name = "Item Selling machine"
	desc = "A machine used to sell items to the greater city"
	icon = 'ModularTegustation/Teguicons/refiner.dmi'
	icon_state = "machine2"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/list/objective = list(
			/obj/item/documents,
			/obj/item/folder/syndicate,
			/obj/item/raw_anomaly_core,
			)

	var/list/spare_equip = list(
			/obj/item/clothing/suit/armor/ego_gear,
			/obj/item/ego_weapon,
			/obj/item/gun/ego_gun,
			)


	var/list/ordealmeat = list(
			/obj/item/food/meat/slab/robot,
			/obj/item/food/meat/slab/sweeper,
			/obj/item/food/meat/slab/worm,)

	var/list/cantsell = list(/obj/item/ego_weapon/template,
		/obj/item/clothing/suit/armor/ego_gear/city/misc)


/obj/structure/itemselling/examine(mob/user)
	. = ..()
	. += "Prices:"
	. += "Secret Documents - 1000 Ahn"
	. += "Secret Documents Folders - 1000 Ahn"
	. += "Raw Anomaly Core - 1000 Ahn"
	. += "Melee weapons - 200 Ahn"
	. += "Ranged Weapons - 200 Ahn"
	. += "Armor - 200 Ahn"
	. += "Sweeper/Robot/Worm Meat - 50 Ahn"
	. += "Fish - 10 Ahn"

/obj/structure/itemselling/attackby(obj/item/I, mob/living/user, params)
	var/spawntype

	if(I.type in cantsell)
		to_chat(user, "<span class='hear'>You cannot sell this.</span>")
		return


	if(I.type in objective)
		spawntype = /obj/item/stack/spacecash/c1000

	else if(I.type in spare_equip)
		spawntype = /obj/item/stack/spacecash/c200

	else if(I.type in ordealmeat)
		spawntype = /obj/item/stack/spacecash/c50

	else if(istype(I, /obj/item/food/fish))
		spawntype = /obj/item/stack/spacecash/c10

	if(!spawntype)
		return

	qdel(I)
	new spawntype (get_turf(src))
	if(prob(5))
		new /obj/structure/lootcrate/tres (get_turf(src))



/obj/structure/potential
	name = "Potential estimation machine"
	desc = "A machine used to estimate your poential"
	icon = 'ModularTegustation/Teguicons/refiner.dmi'
	icon_state = "machine3"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/list/stats = list(FORTITUDE_ATTRIBUTE,
			PRUDENCE_ATTRIBUTE,
			TEMPERANCE_ATTRIBUTE,
			JUSTICE_ATTRIBUTE)

/obj/structure/potential/attackby(obj/item/I, mob/living/user, params)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/stattotal
		var/grade
		for(var/attribute in stats)
			stattotal+=get_attribute_level(H, attribute)
		stattotal /= 4	//Potential is an average of stats
		grade = round((stattotal)/20)	//Get the average level-20, divide by 20
		//Under grade 9 doesn't register
		if(10-grade>=10)
			to_chat(user, "<span class='notice'>Potential too low to give grade. Not recommended to issue fixer license.</span>")
			return

		to_chat(user, "<span class='notice'>Recommended Grade - [10-grade].</span>")
		to_chat(user, "<span class='notice'>This grade may be adjusted by your local Hana representative.</span>")
		return

	to_chat(user, "<span class='notice'>No human potential identified.</span>")

