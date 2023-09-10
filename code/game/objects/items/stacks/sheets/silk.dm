#define RARITY_COMMON "Common"
#define RARITY_UNCOMMON "Uncommon"

/obj/item/stack/sheet/silk
	name = "silk"
	var/datum/armor/added_armor = null
	var/rarity = ""
	var/list/rarities = list(RARITY_COMMON = 5,
							RARITY_UNCOMMON = 10)

/obj/item/stack/sheet/silk/New(var/aRarity)
	..()
	rarity = aRarity
	name = aRarity + " " + name
	added_armor = added_armor.modifyAllRatings(rarities[aRarity])

/obj/item/stack/sheet/silk/indigo
	name = "Indigo"
	added_armor = new(red = 50)

/*/obj/item/stack/sheet/silk/indigo
	name = "Indigo"
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 50, BLACK_DAMAGE = 20, PALE_DAMAGE = 20)

/obj/item/stack/sheet/silk/indigo
	name = "Indigo"
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 50, BLACK_DAMAGE = 20, PALE_DAMAGE = 20)

/obj/item/stack/sheet/silk/indigo
	name = "Indigo"
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 50, BLACK_DAMAGE = 20, PALE_DAMAGE = 20)
*/

/datum/component/butchering/silkbutchering


/datum/component/butchering/silkbutchering/ButcherEffects(mob/living/meat)
	var/turf/T = meat.drop_location()
	for(var/S in meat.silk_results)
		var/obj/item/stack/sheet/silk/a_silk = S
		var/amount = meat.silk_results[a_silk]
		for(var/_i in 1 to amount)
			a_silk = new("Common")
			a_silk.loc = T


/obj/item/silkknife
	name = "silkknife"
	desc = "Makes silk"
	icon_state = "claymore"
	inhand_icon_state = "claymore"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	color = "#444444" // Because I can and it's temporary
	hitsound = 'sound/weapons/fixer/durandal1.ogg'
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	sharpness = TRUE
	force = 0




/obj/item/silkknife/ComponentInitialize()
	AddComponent(/datum/component/butchering/silkbutchering, 80 * toolspeed)
