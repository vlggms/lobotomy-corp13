/obj/structure/itemselling
	name = "Item Selling machine"
	desc = "A machine used to sell items to the greater city"
	icon = 'ModularTegustation/Teguicons/refiner.dmi'
	icon_state = "machine2"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/list/output = list(
		// ZAYIN
		/obj/item/documents 				= /obj/item/stack/spacecash/c1000,
		/obj/item/folder/syndicate	 		= /obj/item/stack/spacecash/c1000,
		/obj/item/raw_anomaly_core	 		= /obj/item/stack/spacecash/c1000,
		/obj/item/ego_weapon	 			= /obj/item/stack/spacecash/c200,
		/obj/item/food/meat/slab/robot		= /obj/item/stack/spacecash/c50,
		/obj/item/food/meat/slab/sweeper	= /obj/item/stack/spacecash/c50,
		/obj/item/food/meat/slab/worm		= /obj/item/stack/spacecash/c50,
		/obj/item/food/fish					= /obj/item/stack/spacecash/c10,
		)


/obj/structure/itemselling/examine(mob/user)
	. = ..()
	. += "Prices:"
	. += "Secret Documents - 1000 Ahn"
	. += "Secret Documents Folders - 1000 Ahn"
	. += "Raw Anomaly Core - 1000 Ahn"
	. += "Melee weapons - 200 Ahn"
	. += "Sweeper/Robot/Worm Meat - 50 Ahn"
	. += "Fish - 10 Ahn"

/obj/structure/itemselling/attackby(obj/item/I, mob/living/user, params)
	var/spawntype

	if(I.type == /obj/item/ego_weapon/template)
		return

	if(!(I.type in output))
		to_chat(user, "<span class='warning'>This cannot be sold.</span>")
		return

	if(spawntype)
		qdel(I)
	new spawntype (get_turf(src))
	if(prob(5))
		new /obj/structure/lootcrate/tres (get_turf(src))

	var/atom/item_out = output[I.type]
	to_chat(user, "<span class='notice'>The input accepts your item.</span>")

	qdel(I)
	new item_out(get_turf(user))


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

