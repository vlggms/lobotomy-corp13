/obj/machinery/augment_fabricator/insurgence
	name = "Augment Fabricator"
	desc = "A machine used to design and fabricate custom augments. Requires proper clearance."

	roles = list("Prosthetics Surgeon", "Office Director", "Office Fixer", "Doctor")
	sale_percentages = list(75)
	on_sale_pct = 1
	markup_pct = 0

/obj/machinery/augment_fabricator/make_new_augment()
	return new /obj/item/augment/insurgence

/obj/item/augment/insurgence
	rankAttributeReqs = list(0, 20, 40, 60, 80)

/obj/item/augment/insurgence/ApplyEffects(mob/living/carbon/human/H)
	// add corrosion effect
	..()
