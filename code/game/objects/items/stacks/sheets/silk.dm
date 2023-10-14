#define RARITY_SIMPLE "Simple"
#define RARITY_ADVANCED "Advanced"
#define RARITY_ELEGANT "Elegant"
#define RARITY_MASTERPIECE "Masterpiece"

/obj/item/stack/sheet/silk
	name = "silk"
	var/datum/armor/added_armor = null
	/*var/rarity = ""
	var/list/rarities = list(RARITY_SIMPLE = 5,
							RARITY_ADVANCED = 10,
							RARITY_ELEGANT = 15,
							RARITY_MASTERPIECE = 20)*/

/*/obj/item/stack/sheet/silk/New(var/aRarity)
	..()
	rarity = aRarity
	name = aRarity + " " + name
	added_armor = added_armor.modifyAllRatings(rarities[aRarity])*/

/obj/item/stack/sheet/silk/indigo_simple
	name = "Simple Indigo Silk"
	desc = "Silk woven from a unknown scout... Can be used to upgrade your armor. Looks like it is from the simple variety of silk. Increases BLACK resistance by 5, Decreases RED by 5 when attached to armor."
	added_armor = new(black = 5, red = -5)
	merge_type = /obj/item/stack/sheet/silk/indigo_simple
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "simple_indigo_silk"

/obj/item/stack/sheet/silk/indigo_advanced
	name = "Advanced Indigo Silk"
	desc = "Silk woven from a sweeper... Can be used to upgrade your armor. Looks like it is from the advanced variety of silk. Increases BLACK resistance by 10, Decreases RED by 10 when attached to armor."
	added_armor = new(black = 10, red = -10)
	merge_type = /obj/item/stack/sheet/silk/indigo_advanced
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "advanced_indigo_silk"

/obj/item/stack/sheet/silk/indigo_elegant
	name = "Elegant Indigo Silk"
	desc = "Silk woven from a sweeper commander... Can be used to upgrade your armor. Looks like it is from the advanced variety of silk. Increases BLACK resistance by 15, Decreases RED by 15 when attached to armor."
	added_armor = new(black = 15, red = -15)
	merge_type = /obj/item/stack/sheet/silk/indigo_elegant
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "elegant_indigo_silk"

/obj/item/stack/sheet/silk/green_simple
	name = "Simple Green Silk"
	desc = "Silk woven from a spear bot... Can be used to upgrade your armor. Looks like it is from the simple variety of silk Increases RED resistance by 5, Decreases BLACK by 5 when attached to armor."
	added_armor = new(red = 5, black = -5)
	merge_type = /obj/item/stack/sheet/silk/green_simple
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "simple_green_silk"

/obj/item/stack/sheet/silk/green_advanced
	name = "Advanced Green Silk"
	desc = "Silk woven from a gun bot... Can be used to upgrade your armor. Looks like it is from the advanced variety of silk Increases RED resistance by 10, Decreases BLACK by 10 when attached to armor."
	added_armor = new(red = 10, black = -10)
	merge_type = /obj/item/stack/sheet/silk/green_advanced
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "advanced_green_silk"

/obj/item/stack/sheet/silk/green_elegant
	name = "Elegant Green Silk"
	desc = "Silk woven from a factory... Can be used to upgrade your armor. Looks like it is from the advanced variety of silk Increases RED resistance by 15, Decreases BLACK by 15 when attached to armor."
	added_armor = new(red = 15, black = -15)
	merge_type = /obj/item/stack/sheet/silk/green_elegant
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "elegant_green_silk"

/obj/item/stack/sheet/silk/steel_simple
	name = "Simple Steel Silk"
	desc = "Silk woven from a gene corp remnant... Can be used to upgrade your armor. Looks like it is from the simple variety of silk. Increases RED resistance by 5, Decreases WHITE by 5 when attached to armor."
	added_armor = new(red = 5, white = -5)
	merge_type = /obj/item/stack/sheet/silk/steel_simple
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "simple_steel_silk"

/obj/item/stack/sheet/silk/steel_advanced
	name = "Advanced Steel Silk"
	desc = "Silk woven from a gene corp corporal... Can be used to upgrade your armor. Looks like it is from the simple variety of silk Increases RED resistance by 10, Decrease WHITE by 10 when attached to armor."
	added_armor = new(red = 10, white = -10)
	merge_type = /obj/item/stack/sheet/silk/steel_advanced
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "advanced_steel_silk"

/obj/item/stack/sheet/silk/amber_simple
	name = "Simple Amber Silk"
	desc = "Silk woven from a carnivores worm... Can be used to upgrade your armor. Looks like it is from the simple variety of silk Decrease WHITE resistance by 5, Increases BLACK by 5 when attached to armor."
	added_armor = new(white = -5, black = 5)
	merge_type = /obj/item/stack/sheet/silk/amber_simple
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "simple_amber_silk"

/obj/item/stack/sheet/silk/amber_advanced
	name = "Advanced Amber Silk"
	desc = "Silk woven from a, Wait... How did they get it? Can be used to upgrade your armor. Looks like it is from the simple variety of silk Decrease WHITE resistance by 10, Increases BLACK by 10 when attached to armor."
	added_armor = new(white = -10, black = 10)
	merge_type = /obj/item/stack/sheet/silk/amber_advanced
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "advanced_amber_silk"

/obj/item/stack/sheet/silk/human_simple
	name = "Simple Human Silk"
	desc = "Silk woven from a... Human? How horrific... Can be used to upgrade your armor. Looks like it is from the simple variety of silkIncreases PALE resistance by 5, Decreases RED and WHITE by 2.5 when attached to armor."
	added_armor = new(pale = 5, white = -2.5, red = -2.5)
	merge_type = /obj/item/stack/sheet/silk/human_simple
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "simple_human_silk"

/obj/item/stack/sheet/silk/human_advanced
	name = "Advanced Human Silk"
	desc = "Silk woven from a... Human? How horrific... Can be used to upgrade your armor. Looks like it is from the advanced variety of silk Increases PALE resistance by 10, Decreases RED and WHITE by 5 when attached to armor."
	added_armor = new(pale = 10, white = -5, red = -5)
	merge_type = /obj/item/stack/sheet/silk/human_advanced
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "advanced_human_silk"

/obj/item/stack/sheet/silk/human_elegant
	name = "Elegant Human Silk"
	desc = "Silk woven from a... Human? How horrific... Can be used to upgrade your armor. Looks like it is from the elegant variety of silk Increases PALE resistance by 15, Decreases RED and WHITE by 7.5 when attached to armor."
	added_armor = new(pale = 15, white = -7.5, red = -7.5)
	merge_type = /obj/item/stack/sheet/silk/human_elegant
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "elegant_human_silk"

/obj/item/stack/sheet/silk/human_masterpiece
	name = "Masterpiece Human Silk"
	desc = "Silk woven from a... Human? How horrific... Can be used to upgrade your armor. Looks like it is from the masterpiece variety of silk. The best of the best Increases PALE resistance by 20, Decreases RED and WHITE by 10 when attached to armor."
	added_armor = new(pale = 20, white = -10, red = -10)
	merge_type = /obj/item/stack/sheet/silk/human_masterpiece
	icon = 'icons/obj/stack_objects.dmi'
	icon_state = "masterpiece_human_silk"

/datum/component/butchering/silkbutchering

/datum/component/butchering/silkbutchering/checkButchering(obj/item/source, mob/living/M, mob/living/user)
	return M.silk_results || ishuman(M)

/datum/component/butchering/silkbutchering/ButcherEffects(mob/living/meat)
	var/turf/T = meat.drop_location()
	if(ishuman(meat))
		var/mob/living/carbon/human/H = meat
		var/total = get_attribute_level(H, FORTITUDE_ATTRIBUTE) + get_attribute_level(H, PRUDENCE_ATTRIBUTE) + get_attribute_level(H, TEMPERANCE_ATTRIBUTE) + get_attribute_level(H, JUSTICE_ATTRIBUTE)

		// Simple Human, 1 Simple.
		// Advanced Human, 1 Advanced, 2 Simple
		// Elegant Human, 1 Elegant, 2 advanced, 4 Simple
		// Masterpiece Human, 1 Masterpiece, 2 Elegant, 4 Advanced, 8 Simple
		var/simple_silk = 0
		var/adv_silk = 0
		var/elegant_silk = 0
		var/master_silk = 0

		if (total < 240)
			simple_silk = 1
		else if (total < 320)
			simple_silk = 2
			adv_silk = 1
		else if (total < 400)
			simple_silk = 4
			adv_silk = 2
			elegant_silk = 1
		else
			simple_silk = 8
			adv_silk = 4
			elegant_silk = 2
			master_silk = 1

		CreateSilk(simple_silk, /obj/item/stack/sheet/silk/human_simple, T)
		CreateSilk(adv_silk, /obj/item/stack/sheet/silk/human_advanced, T)
		CreateSilk(elegant_silk, /obj/item/stack/sheet/silk/human_elegant, T)
		CreateSilk(master_silk, /obj/item/stack/sheet/silk/human_masterpiece, T)

	for(var/S in meat.silk_results)
		var/obj/item/stack/sheet/silk/a_silk = S
		a_silk = new a_silk
		a_silk.loc = T
		a_silk.amount = meat.silk_results[S]

/datum/component/butchering/silkbutchering/proc/CreateSilk(amount, silk_type, T)
	if (amount > 0)
		var/obj/item/stack/sheet/silk/a_silk = new silk_type ()
		a_silk.loc = T
		a_silk.amount = amount

/obj/item/silkknife
	name = "Silkweaver"
	desc = "Makes silk by butchering foes"
	icon_state = "silkweaver"
	inhand_icon_state = "carnival_silkweaver"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	sharpness = TRUE
	force = 0



/obj/item/silkknife/ComponentInitialize()
	AddComponent(/datum/component/butchering/silkbutchering, 80 * toolspeed)
