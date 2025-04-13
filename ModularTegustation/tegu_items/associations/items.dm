/obj/item/potential_tester
	name = "Hana Association Potential Tester"
	desc = "A device that can check the potential of civilians."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "potential_scanner"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL
	var/list/stats = list(
		FORTITUDE_ATTRIBUTE,
		PRUDENCE_ATTRIBUTE,
		TEMPERANCE_ATTRIBUTE,
		JUSTICE_ATTRIBUTE,
	)

/obj/item/potential_tester/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		var/stattotal
		var/grade
		for(var/attribute in stats)
			stattotal+=get_attribute_level(H, attribute)
		stattotal /= 4	//Potential is an average of stats
		grade = round((stattotal)/20)	//Get the average level-20, divide by 20
		to_chat(user, span_notice("Current Potential - [stattotal]."))

		//Under grade 9 doesn't register
		if(10-grade>=10)
			to_chat(user, span_notice("Potential too low to give grade. Not recommended to issue fixer license."))
			return

		to_chat(user, span_notice("Recommended Grade - [10-grade]."))
		to_chat(user, span_notice("Adjust grade based off accomplishments."))
		return

	to_chat(user, span_notice("No human potential identified."))


/obj/item/storage/box/ids/fixer
	name = "box of spare fixer IDs"
	illustration = "id"

/obj/item/storage/box/ids/fixer/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/card/id/fixercard(src)

/obj/item/storage/box/ids/fixerdirector
	name = "box of spare fixer director IDs"
	illustration = "id"

/obj/item/storage/box/ids/fixerdirector/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/card/id/fixerdirector(src)

//Fixer Leveller
/obj/item/attribute_increase/fixer
	name = "n corp training accelerator"
	desc = "A fluid used to increase the stats of a non-assocaition fixer. Use in hand to activate. Increases stats more the lower your potential."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "tcorp_syringe"
	amount = 1
	var/total_adjust = 0
	var/max_attributes = 130
	var/list/usable_roles = list("Civilian", "Office Director", "Office Fixer")
	var/adjusting = FALSE

/obj/item/attribute_increase/fixer/attack_self(mob/living/carbon/human/user)
	//only civilians can use this.
	if(!adjusting)
		if(!(user?.mind?.assigned_role in usable_roles))
			to_chat(user, span_danger("You cannot use this item, as you must not belong to an association."))
			return

		//max stats can't gain stats
		if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE)>=max_attributes)
			to_chat(user, span_danger("You feel like you won't gain anything."))
			return

		adjusting = TRUE

		//Guarantee one
		total_adjust += amount

		//Adjust by an extra attribute under level 2
		if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE)<=40)
			total_adjust += amount

		//And one more under level 3
		if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE)<=60)
			total_adjust += amount

		//And one last one before L4
		if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE)<=80)
			total_adjust += amount

		if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 40 && get_attribute_level(user, TEMPERANCE_ATTRIBUTE) + total_adjust >= 40)
			var/choice = alert("Are you sure you want to become level 2? This will restrict access to lower level skills.", , "Yes", "No")
			if(choice == "No")
				total_adjust = 0
				adjusting = FALSE
				return

		if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 60 && get_attribute_level(user, TEMPERANCE_ATTRIBUTE) + total_adjust >= 60)
			var/choice = alert("Are you sure you want to become level 3? This will restrict access to lower level skills.", , "Yes", "No")
			if(choice == "No")
				adjusting = FALSE
				total_adjust = 0
				return

		if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 100 && get_attribute_level(user, TEMPERANCE_ATTRIBUTE) + total_adjust >= 100)
			var/choice = alert("Are you sure you want to become level 4? This will restrict access to lower level skills.", , "Yes", "No")
			if(choice == "No")
				adjusting = FALSE
				total_adjust = 0
				return

		to_chat(user, span_nicegreen("You suddenly feel different."))
		user.adjust_all_attribute_levels(total_adjust)
		to_chat(user, "<span class='nicegreen'>You gained [total_adjust] potential!</span>")
		adjusting = FALSE
		qdel(src)
