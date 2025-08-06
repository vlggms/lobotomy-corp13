#define RARITY_SIMPLE "Simple"
#define RARITY_ADVANCED "Advanced"
#define RARITY_ELEGANT "Elegant"
#define RARITY_MASTERPIECE "Masterpiece"

/datum/component/butchering/silkbutchering
	var/mob/living/harvester = null

/datum/component/butchering/silkbutchering/checkButchering(obj/item/source, mob/living/M, mob/living/user)
	harvester = user
	return M.silk_results || ishuman(M)

/datum/component/butchering/silkbutchering/ButcherEffects(mob/living/meat)
	var/turf/T = meat.drop_location()

	// Track silk harvesting for achievement
	if(ishuman(harvester) && harvester.mind)
		var/mob/living/carbon/human/H = harvester
		H.mind.silk_harvested++
		if(H.mind.silk_harvested >= 120)
			H.client?.give_award(/datum/award/achievement/lc13/silk_collector, H)

	if(ishuman(meat))
		// if(meat.client)
		// 	meat.visible_message(span_notice("[meat]'s soul resists the silkweaver!"))
		// 	return FALSE
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
	else
		for(var/S in meat.silk_results)
			var/obj/item/stack/sheet/silk/a_silk = S
			a_silk = new a_silk
			a_silk.loc = T
			a_silk.amount = meat.silk_results[S]
		if(!meat.silk_results)
			var/chosen_silk = rand(1,4)
			if (chosen_silk == 1)
				new /obj/item/stack/sheet/silk/indigo_simple(T)
			else if (chosen_silk == 2)
				new /obj/item/stack/sheet/silk/green_simple(T)
			else if (chosen_silk == 3)
				new /obj/item/stack/sheet/silk/amber_simple(T)
			else
				new /obj/item/stack/sheet/silk/steel_simple(T)


/datum/component/butchering/silkbutchering/proc/CreateSilk(amount, silk_type, T)
	if (amount > 0)
		var/obj/item/stack/sheet/silk/a_silk = new silk_type ()
		a_silk.loc = T
		a_silk.amount = amount

/obj/item/silkknife
	name = "silkweaver"
	desc = "Makes silk by butchering foes, Can't be used on humans with a soul."
	icon_state = "silkweaver"
	inhand_icon_state = "carnival_silkweaver"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	sharpness = TRUE
	force = 0

/obj/item/silkknife/ComponentInitialize()
	AddComponent(/datum/component/butchering/silkbutchering, 80 * toolspeed)


/obj/item/stack/sheet/silk
	name = "silk"
	var/datum/armor/added_armor = null
	/*var/rarity = ""
	var/list/rarities = list(RARITY_SIMPLE = 5,
							RARITY_ADVANCED = 10,
							RARITY_ELEGANT = 15,
							RARITY_MASTERPIECE = 20)*/

/obj/item/stack/sheet/silk/Initialize(mapload, new_amount, merge, list/mat_override, mat_amt)
	. = ..()
	if(islist(added_armor))
		added_armor = getArmor(arglist(added_armor))

/*/obj/item/stack/sheet/silk/New(var/aRarity)
	..()
	rarity = aRarity
	name = aRarity + " " + name
	added_armor = added_armor.modifyAllRatings(rarities[aRarity])*/

//Indigo Silk
/obj/item/stack/sheet/silk/indigo_simple
	name = "Simple Indigo Silk"
	desc = "Silk woven from a unknown scout... Can be used to upgrade your armor.  \n\
		Looks like it is from the simple variety of silk. \n\
		When attached to armor it increases BLACK resistance by 5 and decreases RED by 5."
	added_armor = list(BLACK_DAMAGE = 5, RED_DAMAGE = -5)
	merge_type = /obj/item/stack/sheet/silk/indigo_simple
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "simple_indigo_silk"

/obj/item/stack/sheet/silk/indigo_advanced
	name = "Advanced Indigo Silk"
	desc = "Silk woven from a sweeper... Can be used to upgrade your armor. \n\
		Looks like it is from the advanced variety of silk. \n\
		When attached to armor it increases BLACK resistance by 10 and decreases RED by 10."
	added_armor = list(BLACK_DAMAGE = 10, RED_DAMAGE = -10)
	merge_type = /obj/item/stack/sheet/silk/indigo_advanced
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "advanced_indigo_silk"

/obj/item/stack/sheet/silk/indigo_elegant
	name = "Elegant Indigo Silk"
	desc = "Silk woven from a sweeper commander... Can be used to upgrade your armor. \n\
		Looks like it is from the elegant variety of silk. \n\
		When attached to armor it increases BLACK resistance by 15 and decreases RED by 15."
	added_armor = list(BLACK_DAMAGE = 15, RED_DAMAGE = -15)
	merge_type = /obj/item/stack/sheet/silk/indigo_elegant
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "elegant_indigo_silk"

/obj/item/stack/sheet/silk/indigo_masterpiece
	name = "Masterpiece Indigo Silk"
	desc = "Silk woven from a (REDACTED)... Can be used to upgrade your armor. \n\
		Looks like it is from the masterpiece variety of silk. \n\
		When attached to armor it increases BLACK resistance by 20 and decreases RED by 20."
	added_armor = list(BLACK_DAMAGE = 20, RED_DAMAGE = -20)
	merge_type = /obj/item/stack/sheet/silk/indigo_masterpiece
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "masterpiece_indigo_silk"

//Green Silk
/obj/item/stack/sheet/silk/green_simple
	name = "Simple Green Silk"
	desc = "Silk woven from a spear bot... Can be used to upgrade your armor.  \n\
		Looks like it is from the simple variety of silk. \n\
		When attached to armor it increases RED resistance by 5 and decreases BLACK by 5."
	added_armor = list(RED_DAMAGE = 5, BLACK_DAMAGE = -5)
	merge_type = /obj/item/stack/sheet/silk/green_simple
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "simple_green_silk"

/obj/item/stack/sheet/silk/green_advanced
	name = "Advanced Green Silk"
	desc = "Silk woven from a gun bot... Can be used to upgrade your armor. \n\
		Looks like it is from the advanced variety of silk. \n\
		When attached to armor it increases RED resistance by 10 and decreases BLACK by 10."
	added_armor = list(RED_DAMAGE = 10, BLACK_DAMAGE = -10)
	merge_type = /obj/item/stack/sheet/silk/green_advanced
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "advanced_green_silk"

/obj/item/stack/sheet/silk/green_elegant
	name = "Elegant Green Silk"
	desc = "Silk woven from a factory... Can be used to upgrade your armor. \n\
		Looks like it is from the elegant variety of silk. \n\
		When attached to armor it increases RED resistance by 15 and decreases BLACK by 15."
	added_armor = list(RED_DAMAGE = 15, BLACK_DAMAGE = -15)
	merge_type = /obj/item/stack/sheet/silk/green_elegant
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "elegant_green_silk"

/obj/item/stack/sheet/silk/green_masterpiece
	name = "Masterpiece Green Silk"
	desc = "Silk woven from a (REDACTED)... Can be used to upgrade your armor. \n\
		Looks like it is from the masterpiece variety of silk. \n\
		When attached to armor it increases RED resistance by 20 and decreases BLACK by 20."
	added_armor = list(RED_DAMAGE = 20, BLACK_DAMAGE = -20)
	merge_type = /obj/item/stack/sheet/silk/green_masterpiece
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "masterpiece_green_silk"

//Steel Silk
/obj/item/stack/sheet/silk/steel_simple
	name = "Simple Steel Silk"
	desc = "Silk woven from a gene corp remnant... Can be used to upgrade your armor. \n\
		Looks like it is from the simple variety of silk.\n\
		When attached to armor it increases RED resistance by 5 and decreases WHITE by 5."
	added_armor = list(RED_DAMAGE = 5, WHITE_DAMAGE = -5)
	merge_type = /obj/item/stack/sheet/silk/steel_simple
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "simple_steel_silk"

/obj/item/stack/sheet/silk/steel_advanced
	name = "Advanced Steel Silk"
	desc = "Silk woven from a gene corp corporal... Can be used to upgrade your armor. \n\
		Looks like it is from the advanced variety of silk. \n\
		When attached to armor it increases RED resistance by 10 and decrease WHITE by 10."
	added_armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = -10)
	merge_type = /obj/item/stack/sheet/silk/steel_advanced
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "advanced_steel_silk"

/obj/item/stack/sheet/silk/steel_elegant
	name = "Elegant Steel Silk"
	desc = "Silk woven from a gene corp commander... Can be used to upgrade your armor. \n\
		Looks like it is from the elegant variety of silk. \n\
		When attached to armor it increases RED resistance by 15 and decrease WHITE by 15."
	added_armor = list(RED_DAMAGE = 15, WHITE_DAMAGE = -15)
	merge_type = /obj/item/stack/sheet/silk/steel_elegant
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "elegant_steel_silk"

/obj/item/stack/sheet/silk/steel_masterpiece
	name = "Masterpiece Steel Silk"
	desc = "Silk woven from a (REDACTED)... Can be used to upgrade your armor. \n\
		Looks like it is from the masterpiece variety of silk. \n\
		When attached to armor it increases RED resistance by 20 and decrease WHITE by 20."
	added_armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = -20)
	merge_type = /obj/item/stack/sheet/silk/steel_masterpiece
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "masterpiece_steel_silk"

//Amber Silk
/obj/item/stack/sheet/silk/amber_simple
	name = "Simple Amber Silk"
	desc = "Silk woven from a carnivores worm... Can be used to upgrade your armor. \n\
		Looks like it is from the simple variety of silk. \n\
		When attached to armor it decrease WHITE resistance by 5 and increases BLACK by 5."
	added_armor = list(WHITE_DAMAGE = -5, BLACK_DAMAGE = 5)
	merge_type = /obj/item/stack/sheet/silk/amber_simple
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "simple_amber_silk"

/obj/item/stack/sheet/silk/amber_advanced
	name = "Advanced Amber Silk"
	desc = "Silk woven from a ??? Can be used to upgrade your armor. \n\
		Looks like it is from the advanced variety of silk.\n\
		When attached to armor it decrease WHITE resistance by 10 and increases BLACK by 10."
	added_armor = list(WHITE_DAMAGE = -10, BLACK_DAMAGE = 10)
	merge_type = /obj/item/stack/sheet/silk/amber_advanced
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "advanced_amber_silk"

/obj/item/stack/sheet/silk/amber_elegant
	name = "Elegant Amber Silk"
	desc = "Silk woven from a bigger carnivores worm... Can be used to upgrade your armor. \n\
		Looks like it is from the elegant variety of silk.\n\
		When attached to armor it decrease WHITE resistance by 15 and increases BLACK by 15."
	added_armor = list(WHITE_DAMAGE = -15, BLACK_DAMAGE = 15)
	merge_type = /obj/item/stack/sheet/silk/amber_elegant
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "elegant_amber_silk"

/obj/item/stack/sheet/silk/amber_masterpiece
	name = "Masterpiece Amber Silk"
	desc = "Silk woven from a (REDACTED)... Can be used to upgrade your armor. \n\
		Looks like it is from the Masterpiece variety of silk.\n\
		When attached to armor it decrease WHITE resistance by 20 and increases BLACK by 20."
	added_armor = list(WHITE_DAMAGE = -20, BLACK_DAMAGE = 20)
	merge_type = /obj/item/stack/sheet/silk/amber_masterpiece
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "masterpiece_amber_silk"

//Human Silk
/obj/item/stack/sheet/silk/human_simple
	name = "Simple Human Silk"
	desc = "Silk woven from a... Human? How horrific... Can be used to upgrade your armor. \n\
		Looks like it is from the simple variety of silk. \n\
		When attached to armor it increases PALE resistance by 5 and decreases RED and WHITE by 2.5."
	added_armor = list(PALE_DAMAGE = 5, WHITE_DAMAGE = -2.5, RED_DAMAGE = -2.5)
	merge_type = /obj/item/stack/sheet/silk/human_simple
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "simple_human_silk"

/obj/item/stack/sheet/silk/human_advanced
	name = "Advanced Human Silk"
	desc = "Silk woven from a... Human? How horrific... Can be used to upgrade your armor. \n\
		Looks like it is from the advanced variety of silk.\n\
		When attached to armor it increases PALE resistance by 10 and decreases RED and WHITE by 5."
	added_armor = list(PALE_DAMAGE = 10, WHITE_DAMAGE = -5, RED_DAMAGE = -5)
	merge_type = /obj/item/stack/sheet/silk/human_advanced
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "advanced_human_silk"

/obj/item/stack/sheet/silk/human_elegant
	name = "Elegant Human Silk"
	desc = "Silk woven from a... Human? How horrific... Can be used to upgrade your armor. \n\
		Looks like it is from the elegant variety of silk.\n\
		When attached to armor it increases PALE resistance by 15 and decreases RED and WHITE by 7.5."
	added_armor = list(PALE_DAMAGE = 15, WHITE_DAMAGE = -7.5, RED_DAMAGE = -7.5)
	merge_type = /obj/item/stack/sheet/silk/human_elegant
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "elegant_human_silk"

/obj/item/stack/sheet/silk/human_masterpiece
	name = "Masterpiece Human Silk"
	desc = "Silk woven from a... Human? How horrific... Can be used to upgrade your armor. \n\
		Looks like it is from the masterpiece variety of silk. The best of the best.\n\
		When attached to armor it increases PALE resistance by 20 and decreases RED and WHITE by 10."
	added_armor = list(PALE_DAMAGE = 20, WHITE_DAMAGE = -10, RED_DAMAGE = -10)
	merge_type = /obj/item/stack/sheet/silk/human_masterpiece
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "masterpiece_human_silk"

//Azure Silk
/obj/item/stack/sheet/silk/azure_simple
	name = "Simple Azure Silk"
	desc = "Silk woven from a Resurgence Clan Scout... Can be used to upgrade your armor. \n\
		Looks like it is from the simple variety of silk. \n\
		When attached to armor it increases RED resistance by 2.5 and BLACK resistance by 2.5, But decreases WHITE by 5."
	added_armor = list(RED_DAMAGE = 2.5, BLACK_DAMAGE = 2.5, WHITE_DAMAGE = -5)
	merge_type = /obj/item/stack/sheet/silk/azure_simple
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "simple_azure_silk"

/obj/item/stack/sheet/silk/azure_advanced
	name = "Advanced Azure Silk"
	desc = "Silk woven from a Resurgence Clan Defender... Can be used to upgrade your armor. \n\
		Looks like it is from the advanced variety of silk.\n\
		When attached to armor it increases RED resistance by 5 and BLACK resistance by 5, But decreases WHITE by 10."
	added_armor = list(RED_DAMAGE = 5, BLACK_DAMAGE = 5, WHITE_DAMAGE = -10)
	merge_type = /obj/item/stack/sheet/silk/azure_advanced
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "advanced_azure_silk"

/obj/item/stack/sheet/silk/azure_elegant
	name = "Elegant Azure Silk"
	desc = "Silk woven from a Resurgence Clan... Can be used to upgrade your armor. \n\
		Looks like it is from the elegant variety of silk.\n\
		When attached to armor it increases RED resistance by 7.5 and BLACK resistance by 7.5, But decreases WHITE by 15."
	added_armor = list(RED_DAMAGE = 7.5, BLACK_DAMAGE = 7.5, WHITE_DAMAGE = -15)
	merge_type = /obj/item/stack/sheet/silk/azure_elegant
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "elegant_azure_silk"

/obj/item/stack/sheet/silk/azure_masterpiece
	name = "Masterpiece Azure Silk"
	desc = "Silk woven from a Resurgence Clan... Can be used to upgrade your armor. \n\
		Looks like it is from the masterpiece variety of silk. The best of the best.\n\
		When attached to armor it increases RED resistance by 10 and BLACK resistance by 10, But decreases WHITE by 20."
	added_armor = list(RED_DAMAGE = 10, BLACK_DAMAGE = 10, WHITE_DAMAGE = -20)
	merge_type = /obj/item/stack/sheet/silk/azure_masterpiece
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "masterpiece_azure_silk"

//Shrimple Silk
/obj/item/stack/sheet/silk/shrimple_simple
	name = "Simple Shrimple Silk"
	desc = "Silk woven from a ???... Can be used to upgrade your armor. \n\
		Looks like it is from the simple variety of silk. \n\
		When attached to armor it decreases RED resistance by 2.5 and BLACK resistance by 2.5, But increases WHITE by 5."
	added_armor = list(RED_DAMAGE = -2.5, BLACK_DAMAGE = -2.5, WHITE_DAMAGE = 5)
	merge_type = /obj/item/stack/sheet/silk/shrimple_simple
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "simple_shrimple_silk"

/obj/item/stack/sheet/silk/shrimple_advanced
	name = "Advanced Shrimple Silk"
	desc = "Silk woven from a ???... Can be used to upgrade your armor. \n\
		Looks like it is from the advanced variety of silk. \n\
		When attached to armor it decreases RED resistance by 5 and BLACK resistance by 5, But increases WHITE by 10."
	added_armor = list(RED_DAMAGE = -5, BLACK_DAMAGE = -5, WHITE_DAMAGE = 10)
	merge_type = /obj/item/stack/sheet/silk/shrimple_advanced
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "advanced_shrimple_silk"

/obj/item/stack/sheet/silk/shrimple_elegant
	name = "Elegant Shrimple Silk"
	desc = "Silk woven from a ???... Can be used to upgrade your armor. \n\
		Looks like it is from the elegant variety of silk. \n\
		When attached to armor it decreases RED resistance by 7.5 and BLACK resistance by 7.5, But increases WHITE by 15."
	added_armor = list(RED_DAMAGE = -7.5, BLACK_DAMAGE = -7.5, WHITE_DAMAGE = 15)
	merge_type = /obj/item/stack/sheet/silk/shrimple_elegant
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "elegant_shrimple_silk"

/obj/item/stack/sheet/silk/shrimple_masterpiece
	name = "Masterpiece Shrimple Silk"
	desc = "Silk woven from a ???... Can be used to upgrade your armor. \n\
		Looks like it is from the masterpiece variety of silk. \n\
		When attached to armor it decreases RED resistance by 10 and BLACK resistance by 10, But increases WHITE by 20."
	added_armor = list(RED_DAMAGE = -10, BLACK_DAMAGE = -10, WHITE_DAMAGE = 20)
	merge_type = /obj/item/stack/sheet/silk/shrimple_masterpiece
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "masterpiece_shrimple_silk"


//Violet Silk
/obj/item/stack/sheet/silk/violet_simple
	name = "Simple Violet Silk"
	desc = "Silk woven from a ???... Can be used to upgrade your armor. \n\
		Looks like it is from the simple variety of silk. \n\
		When attached to armor it increases WHITE resistance by 5, But decreases BLACK by 5."
	added_armor = list(BLACK_DAMAGE = -5, WHITE_DAMAGE = 5)
	merge_type = /obj/item/stack/sheet/silk/violet_simple
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "simple_violet_silk"

/obj/item/stack/sheet/silk/violet_advanced
	name = "Advanced Violet Silk"
	desc = "Silk woven from a ???... Can be used to upgrade your armor. \n\
		Looks like it is from the advanced variety of silk. \n\
		When attached to armor it increases WHITE resistance by 10, But decreases BLACK by 10."
	added_armor = list(BLACK_DAMAGE = -10, WHITE_DAMAGE = 10)
	merge_type = /obj/item/stack/sheet/silk/violet_advanced
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "advanced_violet_silk"

/obj/item/stack/sheet/silk/violet_elegant
	name = "Elegant Violet Silk"
	desc = "Silk woven from a ???... Can be used to upgrade your armor. \n\
		Looks like it is from the elegant variety of silk. \n\
		When attached to armor it increases WHITE resistance by 15, But decreases BLACK by 15."
	added_armor = list(BLACK_DAMAGE = -15, WHITE_DAMAGE = 15)
	merge_type = /obj/item/stack/sheet/silk/violet_elegant
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "elegant_violet_silk"

/obj/item/stack/sheet/silk/violet_masterpiece
	name = "Masterpiece Violet Silk"
	desc = "Silk woven from a ???... Can be used to upgrade your armor. \n\
		Looks like it is from the masterpiece variety of silk. \n\
		When attached to armor it increases WHITE resistance by 20, But decreases BLACK by 20."
	added_armor = list(BLACK_DAMAGE = -20, WHITE_DAMAGE = 20)
	merge_type = /obj/item/stack/sheet/silk/violet_masterpiece
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "masterpiece_violet_silk"

//Crimson Silk
/obj/item/stack/sheet/silk/crimson_simple
	name = "Simple Crimson Silk"
	desc = "Silk woven from a ???... Can be used to upgrade your armor. \n\
		Looks like it is from the simple variety of silk. \n\
		When attached to armor it increases WHITE resistance by 5, But decreases RED by 5."
	added_armor = list(RED_DAMAGE = -5, WHITE_DAMAGE = 5)
	merge_type = /obj/item/stack/sheet/silk/crimson_simple
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "simple_crimson_silk"

/obj/item/stack/sheet/silk/crimson_advanced
	name = "Advanced Crimson Silk"
	desc = "Silk woven from a ???... Can be used to upgrade your armor. \n\
		Looks like it is from the advanced variety of silk. \n\
		When attached to armor it increases WHITE resistance by 10, But decreases RED by 10."
	added_armor = list(RED_DAMAGE = -10, WHITE_DAMAGE = 10)
	merge_type = /obj/item/stack/sheet/silk/crimson_advanced
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "advanced_crimson_silk"

/obj/item/stack/sheet/silk/crimson_elegant
	name = "Elegant Crimson Silk"
	desc = "Silk woven from a ???... Can be used to upgrade your armor. \n\
		Looks like it is from the elegant variety of silk. \n\
		When attached to armor it increases WHITE resistance by 15, But decreases RED by 15."
	added_armor = list(RED_DAMAGE = -15, WHITE_DAMAGE = 15)
	merge_type = /obj/item/stack/sheet/silk/crimson_elegant
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "elegant_crimson_silk"

/obj/item/stack/sheet/silk/crimson_masterpiece
	name = "Masterpiece Crimson Silk"
	desc = "Silk woven from a ???... Can be used to upgrade your armor. \n\
		Looks like it is from the masterpiece variety of silk. \n\
		When attached to armor it increases WHITE resistance by 20, But decreases RED by 20."
	added_armor = list(RED_DAMAGE = -20, WHITE_DAMAGE = 20)
	merge_type = /obj/item/stack/sheet/silk/crimson_masterpiece
	icon = 'icons/obj/carnival_silk.dmi'
	icon_state = "masterpiece_crimson_silk"
