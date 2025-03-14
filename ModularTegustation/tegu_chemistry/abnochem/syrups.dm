//Syrups
/datum/reagent/abnormality/heartysyrup
	name = "Hearty Syrup"
	description = "A substance of certain vitamins that can be found in some foods. \
		Increases fortitude by 6 while in system."
	color = COLOR_VIVID_RED
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
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
