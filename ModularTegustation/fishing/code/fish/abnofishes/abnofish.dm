/*
How to add an abnofish:
Make new abnofish
Add it to the respective fishies list on wishwell
Be sure to set an associated_abnormality
Done! :3
*/

/obj/item/food/fish/abnofish
	name = "\improper a abnormal fish"
	desc = "What makes a fish turn abnormal? Lust for water? Depth? Or were they just born with a form of abnormality?"
	icon = 'ModularTegustation/fishing/icons/abnofishes.dmi'
	icon_state = "abnofish"
	fishing_difficulty_modifier = 100
	food_reagents = list(
		/datum/reagent/drug/enkephalin = 4,
	)
	remove_reagents_on_cooked = list()
	tastes = list("abnormal" = 1)
	random_case_rarity = FISH_RARITY_GOOD_LUCK_FINDING_THIS
	habitat = "Wishing Well"
	required_fluid_type = AQUARIUM_FLUID_ENKEPHALIN
	var/associated_abnormality = /mob/living/simple_animal/hostile/abnormality/an_abnormality
	var/bonus_pe_amount = 5

/obj/item/food/fish/abnofish/proc/GetBonusPE()
	return bonus_pe_amount

/obj/item/food/fish/abnofish/proc/TriggerAbnormalityEffect(mob/living/simple_animal/hostile/abnormality/A)
	return

/obj/item/food/fish/abnofish/anfish
	name = "An Fish"
	desc = "The elite fish of the well; Despite being a mere siluriform, it is nonetheless an intimidating fish."
	icon_state = "anfish"
	tastes = list("final" = 1, "deadly" = 1)
	associated_abnormality = /mob/living/simple_animal/hostile/megafauna/arbiter
	food_reagents = list(
		/datum/reagent/medicine/omnizine = 4,
	)

/obj/item/food/fish/abnofish/freifisch
	name = "freifisch"
	desc = "This magical fish can truly flap anywhere, just like you say."
	icon_state = "freifisch"
	tastes = list("bullety" = 1, "metallic" = 1)
	associated_abnormality = /mob/living/simple_animal/hostile/abnormality/der_freischutz

/obj/item/food/fish/abnofish/hairfish
	name = "hairy fish"
	desc = "What seems to be a flapping fish covered in a tangle of hair."
	icon_state = "hairfish"
	tastes = list("like keratin" = 1)
	associated_abnormality = /mob/living/simple_animal/hostile/abnormality/tangle

/obj/item/food/fish/abnofish/hatefish
	name = "queen of fishes"
	desc = "A fish resembling a pale-skinned girl in a rather bizzare skirt. \
	How is a fish wearing a skirt?"
	icon_state = "hatefish"
	tastes = list("magic" = 1)
	associated_abnormality = /mob/living/simple_animal/hostile/abnormality/hatred_queen

/obj/item/food/fish/abnofish/nothingfishy
	name = "nothing fishy"
	desc = "A wicked fish that consists of various fishing parts and baits."
	icon_state = "nothingfishy"
	tastes = list("greetings" = 1, "goodbies" = 1)
	associated_abnormality =  /mob/living/simple_animal/hostile/abnormality/nothing_there

/obj/item/food/fish/abnofish/onefish
	name = "one fish and hundreds of eaten prawns"
	desc = "A giant fish that is attached to a fishing rod, it wears a crown of hooks."
	icon_state = "onefish"
	tastes = list("sacrifice" = 1)
	associated_abnormality = /mob/living/simple_animal/hostile/abnormality/onesin

/obj/item/food/fish/abnofish/sirenfish
	name = "sirenfish"
	desc = "The fish that swims the past."
	icon_state = "stupidshitfish"
	tastes = list("brain damage" = 1, "dementia" = 1)
	associated_abnormality = /mob/living/simple_animal/hostile/abnormality/siren
	bonus_pe_amount = 0

/obj/item/food/fish/abnofish/sirenfish/TriggerAbnormalityEffect(mob/living/simple_animal/hostile/abnormality/A)
	A.datum_reference.qliphoth_meter += 2
	return
