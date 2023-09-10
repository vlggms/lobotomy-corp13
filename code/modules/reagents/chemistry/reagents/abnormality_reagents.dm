///// Basic abnochem systems!

/datum/reagent/abnormality // The base abnormality chemical, with several "easy" modular traits that people can enable and disable with variables.
	name = "Raw Enkephalin" // If you don't change anything else, CHANGE THIS.
	description = "You don't think you should be seeing this." // And this too.
	reagent_state = LIQUID // For logic's sake, change this.
	color = "#6baf65" // For presentation purposes, change this.
	metabolization_rate = 0.5 * REAGENTS_METABOLISM // Change at your own peril!
	taste_mult = 0
	var/list/special_properties = list() // Describe your custom-made properties as you want them to appear when analyzed. One string per line.
	var/health_restore = 0 // % of health restored per tick. For reference, Salicylic Acid is 4. Set to negative and it'll hurt!
	var/sanity_restore = 0 // % of sanity restored per tick. For reference, Mental Stabilizator is 5. Set to negative and it'll hurt!
	var/list/stat_changes = list(0, 0, 0, 0) // Fortitude, Prudence, Temperance, Justice, in order. Positive and negative both work.
	var/list/armor_mods = list(0, 0, 0, 0) // Red, white, black, pale, in order. 10 = I, 50 = V, 100 = X. Applies additively. (Or subtractively, if negative.) USE SPARINGLY!
	var/list/damage_mods = list(1, 1, 1, 1) // Same order as armor_mods, but multiplicative. Applied after armor. Knight of Despair's blessed has 0.5, 0.5, 0.5, 2.0, for reference.

/datum/reagent/abnormality/on_mob_life(mob/living/L)
	if(!ishuman(L))
		return
	var/mob/living/carbon/human/H = L
	if(health_restore != 0)
		H.adjustBruteLoss(-health_restore*REM)
	if(sanity_restore != 0)
		H.adjustSanityLoss(-sanity_restore*REM)
	return ..()

/datum/reagent/abnormality/on_mob_metabolize(mob/living/L)
	if(!ishuman(L)) // I don't know why you're trying to give a simple mob armor or stats via a chem, but Please Don't Do That.
		return
	var/mob/living/carbon/human/H = L
	if((stat_changes[1] || stat_changes[2] || stat_changes[3] || stat_changes[4]) != 0)
		H.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, stat_changes[1])
		H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, stat_changes[2])
		H.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, stat_changes[3])
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, stat_changes[4])
	if((armor_mods[1] || armor_mods[2] || armor_mods[3] || armor_mods[4]) != 0)
		H.physiology.armor = H.physiology.armor.modifyRating(red = armor_mods[1], white = armor_mods[2], black = armor_mods[3], pale = armor_mods[4])
	if((damage_mods[1] || damage_mods[2] || damage_mods[3] || damage_mods[4]) != 1)
		H.physiology.red_mod *= damage_mods[1]
		H.physiology.white_mod *= damage_mods[2]
		H.physiology.black_mod *= damage_mods[3]
		H.physiology.pale_mod *= damage_mods[4]

/datum/reagent/abnormality/on_mob_end_metabolize(mob/living/L)
	if(!ishuman(L))
		return
	var/mob/living/carbon/human/H = L
	if((stat_changes[1] || stat_changes[2] || stat_changes[3] || stat_changes[4]) != 0)
		H.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -stat_changes[1])
		H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -stat_changes[2])
		H.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -stat_changes[3])
		H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -stat_changes[4])
	if((armor_mods[1] || armor_mods[2] || armor_mods[3] || armor_mods[4]) != 0)
		H.physiology.armor = H.physiology.armor.modifyRating(red = -armor_mods[1], white = -armor_mods[2], black = -armor_mods[3], pale = -armor_mods[4])
	if((damage_mods[1] || damage_mods[2] || damage_mods[3] || damage_mods[4]) != 1)
		H.physiology.red_mod /= damage_mods[1]
		H.physiology.white_mod /= damage_mods[2]
		H.physiology.black_mod /= damage_mods[3]
		H.physiology.pale_mod /= damage_mods[4]

///// Dummy chems that will be produced when harvesting from an abnormality that has no unique chem.

/datum/reagent/abnormality/nutrition // Restores some HP, but you go hungry faster.
	name = "Generic Enkephalin Derivate type NT"
	description = "Barely stable, but it exists..."
	color = "#e56f3e"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	health_restore = 2
	special_properties = list("substance may alter subject metabolism")

/datum/reagent/abnormality/nutrition/on_mob_life(mob/living/L)
	if(!ishuman(L))
		return
	var/mob/living/carbon/human/H = L
	H.adjust_nutrition(-1 * HUNGER_FACTOR)
	return ..()

/datum/reagent/abnormality/cleanliness // Damages you, but cleans you off. (This is a meme.)
	name = "Generic Enkephalin Derivate type CN"
	description = "Barely stable, but it exists..."
	color = "#2ca369"
	health_restore = -1
	special_properties = list("substance may alter subject's physical appearance")

/datum/reagent/abnormality/cleanliness/on_mob_metabolize(mob/living/L)
	var/atom/cleaned = L
	cleaned.wash(CLEAN_WASH)
	to_chat(cleaned, "<span class='nicegreen'>You feel like new!</span>")
	return ..()

/datum/reagent/abnormality/consensus // Restores some SP, but renders you weaker to white damage.
	name = "Generic Enkephalin Derivate type CS"
	description = "Barely stable, but it exists..."
	color = "#469e93"
	sanity_restore = 2
	damage_mods = list(1, 1.2, 1, 1)

/datum/reagent/abnormality/amusement // Increases Prudence and Fortitude, penalizes Justice.
	name = "Generic Enkephalin Derivate type AM"
	description = "Barely stable, but it exists..."
	color = "#df7685"
	stat_changes = list(5, 5, 0, -10)

/datum/reagent/abnormality/violence // Damages you, but increases justice.
	name = "Generic Enkephalin Derivate type VL"
	description = "Barely stable, but it exists..."
	color = "#dd3e3b"
	health_restore = -2
	stat_changes = list(0, 0, 0, 10)

///// Abnochem scanner!

/obj/item/enkephalin_scanner
	name = "enkephalin-derived substance scanner"
	desc = "Scans and analyzes substances harvested from abnormalities."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "abnochem_scanner"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	var/list/last_scan = list()

/obj/item/enkephalin_scanner/afterattack(atom/A as mob|obj, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(!isnull(A.reagents))
		last_scan = list()
		if(A.reagents.reagent_list.len > 0)
			var/abno_count = 0
			for (var/datum/reagent/abnormality/abnoChem in A.reagents.reagent_list) // I need to do TWO for loops through the same list uuuuuugh
				abno_count += 1
			if(abno_count)
				to_chat(user, "<span class='notice'>[abno_count] enkephalin-derived substance[abno_count > 1 ? "s" : ""] found.</span>")
				for (var/datum/reagent/abnormality/abnoChem in A.reagents.reagent_list)
					to_chat(user, "<span class='notice'>\t [abnoChem]</span>")
					last_scan |= abnoChem
				to_chat(user,"<span class='notice'>Property analysis <a href='?src=[REF(src)];analysis=1'>available</a>.</span>")
				return
	to_chat(user, "<span class='notice'>No enkephalin-derived substances found in [A].</span>")

/obj/item/enkephalin_scanner/Topic(href, href_list)
	. = ..()
	if(href_list["analysis"])
		var/list/readout1 = list()
		var/list/readout2 = list()
		for(var/datum/reagent/abnormality/abnoChem in last_scan)
			var/special = abnoChem.special_properties
			for(var/property in special)
				readout1 |= "- [property]"
			if(abnoChem.health_restore > 0) // This code looks awful. This code IS awful. But it's the best I can figure out...
				readout2 |= "- substance may physically heal subject"
			else if(abnoChem.health_restore < 0)
				readout2 |= "- substance may physically harm subject"
			if(abnoChem.sanity_restore > 0)
				readout2 |= "- substance may improve subject mental stability"
			else if(abnoChem.health_restore < 0)
				readout2 |= "- substance may reduce subject mental stability"
			if((abnoChem.stat_changes[1] || abnoChem.stat_changes[2] || abnoChem.stat_changes[3] || abnoChem.stat_changes[4]) != 0)
				readout2 |= "- substance may alter subject's abilities"
			if((abnoChem.armor_mods[1] || abnoChem.armor_mods[2] || abnoChem.armor_mods[3] || abnoChem.armor_mods[4]) != 0 || (abnoChem.damage_mods[1] || abnoChem.damage_mods[2] || abnoChem.damage_mods[3] || abnoChem.damage_mods[4]) != 1)
				readout2 |= "- substance may alter subject's durability"
		for(var/reportLine in readout1)
			to_chat(usr, reportLine)
		for(var/reportLine in readout2)
			to_chat(usr, reportLine)

/obj/item/chemical_extraction_attachment
	name = "chemical extraction cell upgrade"
	desc = "Attaches to the abnormality cell console of completely understood abnormalities and allows for the extraction of enkephalin-derived substances."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "abnochem_attachment"

/obj/machinery/computer/abnormality/attackby(obj/O, mob/user, params)
	if(istype(O, /obj/item/chemical_extraction_attachment))
		if(datum_reference.understanding < datum_reference.max_understanding)
			to_chat(user, "<span class='notice'>Abnormality [datum_reference.current] is not yet fully understood.</span>")
			return ..()
		var/obj/item/chemical_extraction_attachment/attachment = locate() in contents
		if(attachment)
			to_chat(user, "<span class='notice'>This cell already has a chemical extraction upgrade installed.</span>")
			return ..()
		to_chat(user, "<span class='notice'>You start attaching \the [O] to \the [src]...</span>")
		if(do_after(user, 5 SECONDS, src))
			user.transferItemToLoc(O, src)
			src.desc += "\nIt seems to be equipped with a chemical extraction upgrade."
	return ..()

/obj/structure/closet/crate/science/abnochem_startercrate
	name = "Abnormality chemistry crate"
	desc = "A crate containing abnormality chemistry materials."

/obj/structure/closet/crate/science/abnochem_startercrate/PopulateContents()
	new /obj/item/enkephalin_scanner(src)
	new /obj/item/enkephalin_scanner(src)
	new /obj/item/paper/guides/jobs/abnochem(src)
	new /obj/item/paper/guides/jobs/abnochem_effects_generic(src)
	new /obj/item/paper/guides/jobs/abnochem_effects_zayin(src)
	new /obj/item/paper/guides/jobs/abnochem_effects_he(src)
	new /obj/item/storage/box/beakers(src)
	new /obj/item/storage/box/beakers(src)
