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
	to_chat(cleaned, span_nicegreen("You feel like new!"))
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

/datum/reagent/abnormality/abno_oil // Generally found in mechanical abnormalities. Increases vulnerability to Black damage. Increases resistance to normal damage.
	name = "Generic Enkephalin Derivate type RO"
	description = "Barely stable, but it exists..."
	color = COLOR_GRAY
	special_properties = list("substance may make the subject gain the defenses of a machine.")
	damage_mods = list(0.8, 0.9, 1.5, 1)

/datum/reagent/abnormality/woe // Eats away at health to restore sanity.
	name = "Generic Enkephalin Derivate type WP"
	description = "Barely stable, but it exists..."
	color = COLOR_GRAY
	// Attempting to balance this by making the hp cost twice the sanity restored.
	health_restore = -4
	sanity_restore = 2
	special_properties = list("substance transforms mental wounds into physical injuries.")

///// Common Abnochems
/datum/reagent/abnormality/odisone // Increases Fort and Justice by 10 while reducing all other stats by 20
	name = "Odisone"
	description = "Deriving from the latin odium, this substance \
		highens the thrill of combat while greatly reducing the \
		subjects ability to think."
	metabolization_rate = 0.8 * REAGENTS_METABOLISM
	color = COLOR_RED
	stat_changes = list(10, -20, -20, 10)

/datum/reagent/abnormality/dyscrasone // Addictive stat buffing. Debuff is in status_effects/debuff.dm
	name = "Dyscrasone"
	description = "This drug increases all of a subjects attributes \
		but induces a heavy withdrawl penalty."
	metabolization_rate = 0.8 * REAGENTS_METABOLISM
	color = COLOR_BUBBLEGUM_RED
	stat_changes = list(10, 10, 10, 10)

/datum/reagent/abnormality/dyscrasone/on_mob_metabolize(mob/living/L)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.remove_status_effect(/datum/status_effect/display/dyscrasone_withdrawl)

/datum/reagent/abnormality/dyscrasone/on_mob_end_metabolize(mob/living/L)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.apply_status_effect(/datum/status_effect/display/dyscrasone_withdrawl)

/datum/reagent/abnormality/serelam // Increases Prudence and Temperance by 10 while reducing all other stats by 20
	name = "Serelam"
	description = "Formed from the mixture of mundance and \
		supernatural fluids, this substance strengthens the \
		users calm in intense situations but also weakens \
		their muscles during combat."
	metabolization_rate = 0.8 * REAGENTS_METABOLISM
	stat_changes = list(-20, 10, 10, -20)

/datum/reagent/abnormality/culpusumidus // Increases Prudence but inflicts sanity damage when exiting system.
	name = "Culpus Umidus"
	description = "This fluid increases prudence but induces \
		a intense feeling of remorse when leaving the subjects system."
	metabolization_rate = 0.8 * REAGENTS_METABOLISM
	color = COLOR_BEIGE
	stat_changes = list(0, 10, 0, 0)

/datum/reagent/abnormality/culpusumidus/on_mob_end_metabolize(mob/living/L)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		to_chat(H, span_warning("You need to suffer for what was done."))
		H.adjustSanityLoss(H.maxSanity * 0.15, TRUE)

/datum/reagent/abnormality/nepenthe // Rapidly restores sanity to those who are insane.
	name = "Lesser Nepenthe"
	description = "Rapidly restores sanity to those who have gone insane. \
		For those who consume this drink, forgetfulness takes away their sorrow."
	metabolization_rate = 1 * REAGENTS_METABOLISM
	color = COLOR_BLUE

/datum/reagent/abnormality/nepenthe/on_mob_life(mob/living/carbon/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.sanity_lost)
			H.adjustSanityLoss((-H.maxSanity*0.05)*REM)
		else
			H.adjustSanityLoss(-1*REM)
	return ..()

/datum/reagent/abnormality/piedrabital // Heals but has a chance of immobalizing the subject
	name = "Piedrabital"
	description = "Closes wounds and heals bruises but sometimes causes \
		muscles to seize up due to tissue build up."
	metabolization_rate = 0.6 * REAGENTS_METABOLISM
	color = COLOR_BUBBLEGUM_RED

/datum/reagent/abnormality/piedrabital/on_mob_life(mob/living/carbon/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(prob(20 + (0.5 * current_cycle)))
			//Chance of stun increases by 0.5 per cycle
			if(!H.IsStun())
				to_chat(H, "Your limbs suddenly spasm and tighten like you have pebbles stuck inside them.")
				H.Stun(10*REM)
		else
			H.adjustBruteLoss(rand(-8,-4)*REM)
	return ..()

/datum/reagent/abnormality/gaspilleur // Heals 2 sanity and health but reduces stats by -40
	name = "Gaspilleur"
	description = "A strange substance that restores the mind and body. \
		Subjects under the effects of this substance report feeling numb \
		physically and emotionally."
	metabolization_rate = 0.8 * REAGENTS_METABOLISM
	color = COLOR_RED
	health_restore = 2
	sanity_restore = 2
	stat_changes = list(-40, -40, -40, -40)

/datum/reagent/abnormality/lesser_sange_rau // Rapidly converts blood into health
	name = "Lesser Sange Rau"
	description = "Theorized to be an element of some abnormalities digestive systems. \
		This fluid inefficently converts blood into regenerative tissue."
	metabolization_rate = 1 * REAGENTS_METABOLISM
	color = COLOR_MAROON

/datum/reagent/abnormality/lesser_sange_rau/on_mob_life(mob/living/carbon/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.blood_volume > (10 * REAGENTS_METABOLISM))
			H.blood_volume -= (10 * REAGENTS_METABOLISM)
			H.adjustBruteLoss(rand(-4,-1)*REM)
	return ..()

		//Subtypes
/datum/reagent/abnormality/heartysyrup
	name = "Hearty Syrup"
	description = "A substance of certain vitamins that can be found in some foods. \
		Increases fortitude by 6 while in system."
	color = COLOR_VIVID_RED
	stat_changes = list(6, 0, 0, 0)

/datum/reagent/abnormality/bittersyrup
	name = "Bitter Syrup"
	description = "A substance that distrupts mental attacks. \
		Increases prudence by 6 while in system."
	color = COLOR_BEIGE
	stat_changes = list(0, 6, 0, 0)

/datum/reagent/abnormality/tastesyrup
	name = "Tasteless Syrup"
	description = "A substance that calms the body and mind. \
		Increases temperance by 6 while in system."
	color = COLOR_PURPLE
	stat_changes = list(0, 0, 6, 0)

/datum/reagent/abnormality/focussyrup
	name = "Focused Syrup"
	description = "A substance that increases reaction time and movement. \
		Increases justice by 6 while in system."
	color = COLOR_CYAN
	stat_changes = list(0, 0, 0, 6)

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
				to_chat(user, span_notice("[abno_count] enkephalin-derived substance[abno_count > 1 ? "s" : ""] found."))
				for (var/datum/reagent/abnormality/abnoChem in A.reagents.reagent_list)
					to_chat(user, span_notice("\t [abnoChem]"))
					last_scan |= abnoChem
				to_chat(user, span_notice("Property analysis <a href='?src=[REF(src)];analysis=1'>available</a>."))
				return
	to_chat(user, span_notice("No enkephalin-derived substances found in [A]."))

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
	new /obj/item/work_console_upgrade/chemical_extraction_attachment(src)
