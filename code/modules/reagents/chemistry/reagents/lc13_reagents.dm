/datum/reagent/toxin/lc13_toxin
	name = "Red Toxin"
	description = "A mixture of solvents used for processing Enkephalin. Highly corrosive."
	reagent_state = LIQUID
	color = "#FF0000"
	toxpwr = 0
	taste_description = "gasoline"
	var/damage = 5
	var/damtype = RED_DAMAGE

/datum/reagent/toxin/lc13_toxin/on_mob_life(mob/living/carbon/M)
	M.deal_damage(damage, damtype)//toxpwr is 1.5 from the toxin subtype
	return ..()

/datum/reagent/toxin/lc13_toxin/expose_mob(mob/living/exposed_mob, methods=VAPOR, reac_volume,  touch_protection=0)
	. = ..()
	reac_volume = round(reac_volume,0.1)
	exposed_mob.deal_damage(min(round(0.4 * reac_volume, 0.1), damage*2), damtype)

/datum/reagent/toxin/lc13_toxin/weak
	name = "Diluted Red Toxin"
	damage = 2
	toxpwr = 0.1

/datum/reagent/toxin/lc13_toxin/strong
	name = "Concentrated Red Toxin"
	damage = 10
	toxpwr = 0.5

/datum/reagent/toxin/lc13_toxin/white
	name = "White Toxin"
	description = "Unrefined Enkephalin can have severe psychoactive effects."
	color = "#F0EBBF"
	taste_description = "mucus"
	damtype = WHITE_DAMAGE

/datum/reagent/toxin/lc13_toxin/white/weak
	name = "Diluted White Toxin"
	damage = 2
	toxpwr = 0.1

/datum/reagent/toxin/lc13_toxin/white/strong
	name = "Concentrated White Toxin"
	damage = 10
	toxpwr = 0.5

/datum/reagent/toxin/lc13_toxin/black
	name = "Black Toxin"
	description = "This disgusting concotion was likely the result of several pipes breaking."
	reagent_state = LIQUID
	color = "#A562AF"
	taste_description = "blood"
	damtype = BLACK_DAMAGE

/datum/reagent/toxin/lc13_toxin/black/weak
	name = "Diluted Black Toxin"
	damage = 2
	toxpwr = 0.1

/datum/reagent/toxin/lc13_toxin/black/strong
	name = "Concentrated Black Toxin"
	damage = 10
	toxpwr = 0.5

/datum/reagent/toxin/lc13_toxin/pale
	name = "Pale Toxin"
	description = "A sample of cogito that is used for repression work. Said to damage the very soul of humans."
	reagent_state = LIQUID
	color = "#3FCDBD"
	taste_description = "bleach"
	damtype = PALE_DAMAGE
	damage = 1
	toxpwr = 0.2

/datum/reagent/toxin/lc13_toxin/pale/weak
	name = "Diluted Pale Toxin"
	damage = 0.5
	toxpwr = 0.1

/datum/reagent/toxin/lc13_toxin/pale/strong
	name = "Concentrated Pale Toxin"
	damage = 5
	toxpwr = 0.5

///I don't know if this is supposed to be here but whatever. Extracted from Amber ordeals meat, only serves to get the parasite out at the moment.
/datum/reagent/amber
	name = "Amber Extract"
	description = "It tastes awful, yet you want more."
	glass_name = "glass of Amber Extract"
	glass_desc = "The liquid shifts with hunger."
	color = "#5c462d"
	taste_description = "starvation"
	can_synth = FALSE
