
///// Chems that will be produced by mixing basic sins

/datum/reagent/abnormality/nutrition // Restores some HP, but you go hungry faster.
	name = "Generic Enkephalin Derivate type NT"
	description = "Barely stable, but it exists..."
	color = "#e56f3e"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	health_restore = 4
	special_properties = list("substance may alter subject metabolism")

/datum/reagent/abnormality/nutrition/on_mob_life(mob/living/L)
	if(!ishuman(L))
		return
	var/mob/living/carbon/human/H = L
	H.adjust_nutrition(-0.5 * HUNGER_FACTOR)
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
	sanity_restore = 3
	damage_mods = list(1, 1.2, 1, 1)

/datum/reagent/abnormality/amusement // Increases Prudence and Fortitude, penalizes Justice.
	name = "Generic Enkephalin Derivate type AM"
	description = "Barely stable, but it exists..."
	color = "#df7685"
	stat_changes = list(10, 10, 0, -10)

/datum/reagent/abnormality/violence // Damages you, but increases justice.
	name = "Generic Enkephalin Derivate type VL"
	description = "Barely stable, but it exists..."
	color = "#dd3e3b"
	health_restore = -0.2
	stat_changes = list(0, 0, 0, 15)

/datum/reagent/abnormality/abno_oil // Generally found in mechanical abnormalities. Increases vulnerability to Black damage. Increases resistance to normal damage.
	name = "Generic Enkephalin Derivate type RO"
	description = "Barely stable, but it exists..."
	color = COLOR_GRAY
	special_properties = list("substance may make the subject gain the defenses of a machine.")
	damage_mods = list(0.8, 0.9, 1.2, 1)

/datum/reagent/abnormality/woe // Eats away at health to restore sanity.
	name = "Generic Enkephalin Derivate type WP"
	description = "Barely stable, but it exists..."
	color = COLOR_GRAY
	health_restore = -1
	sanity_restore = 3
	special_properties = list("substance transforms mental wounds into physical injuries.")
