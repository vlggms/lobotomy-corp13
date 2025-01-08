/obj/item/clothing/suit/armor/ego_gear/city/echo
	name = "Echo outfit"
	desc = "You should not be able to see this."
	icon_state = "maid_dress"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 50, BLACK_DAMAGE = 30, PALE_DAMAGE = 20)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/city/echo/maid_dress
	name = "Neon Maid Dress"
	desc = "I have no reason to deny the greatness and beauty of such an amazing outfit!"
	icon_state = "maid_dress"
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 60, BLACK_DAMAGE = 40, PALE_DAMAGE = 10)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/city/echo/stars
	name = "Reverie Under the Stars"
	desc = "A change has happened."
	icon_state = "stars"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 40, BLACK_DAMAGE = 20, PALE_DAMAGE = 60)
	slowdown = 0.5
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/suit/armor/ego_gear/city/echo/stars/Initialize()
	. = ..()
	var/obj/effect/proc_holder/ability/AS = new /obj/effect/proc_holder/ability/fated_encounters
	var/datum/action/spell_action/ability/item/A = AS.action
	A.SetItem(src)

/obj/effect/proc_holder/ability/fated_encounters
	name = "Fated Encounters"
	desc = "An ability that allows its user to become incredibly defensive and drawning in aggro of all hostiles, at the cost of SP."
	action_icon = 'icons/mob/actions/actions_items.dmi'
	action_icon_state = "flight"
	base_icon_state = "flight"
	cooldown_time = 60 SECONDS

/obj/effect/proc_holder/ability/fated_encounters/Perform(target, mob/user)
	playsound(get_turf(user), 'sound/abnormalities/onesin/bless.ogg', 50, 0, 4)
	if (ishuman(user))
		var/mob/living/carbon/human/wielder = user
		wielder.Stun(12, TRUE, TRUE)
		new /obj/effect/temp_visual/onesin_blessing (get_turf(wielder))
		var/obj/item/clothing/suit/armor/ego_gear/city/echo/stars/S = wielder.get_item_by_slot(ITEM_SLOT_OCLOTHING)
		wielder.adjustSanityLoss(wielder.maxSanity*0.25)
		S.armor = new(red = 90, white = 90, black = 90, pale = 90)
		for(var/mob/living/simple_animal/hostile/H in view(4, wielder))
			if(!H.faction_check_mob(wielder))
				H.GiveTarget(wielder)
				new /obj/effect/temp_visual/galaxy_aura (get_turf(H))
		addtimer(CALLBACK(src, PROC_REF(ResetArmor), S), 100)
	return ..()

/obj/effect/proc_holder/ability/fated_encounters/proc/ResetArmor(var/obj/item/clothing/suit/armor/ego_gear/A)
	A.armor = new(red = 40, white = 40, black = 20, pale = 60)
	playsound(get_turf(A), 'sound/abnormalities/onesin/bless.ogg', 50, 0, 4)
	new /obj/effect/temp_visual/onesin_blessing (get_turf(A))

/obj/item/clothing/suit/armor/ego_gear/city/echo/plated
	name = "Plated Outer Cover"
	desc = "An echo of a past Memory... A painful one at that."
	icon_state = "plated"
	hat = /obj/item/clothing/head/ego_hat/plated
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 20, BLACK_DAMAGE = 60, PALE_DAMAGE = 10)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/head/ego_hat/plated
	name = "Plated Hood"
	desc = "An echo of a past Memory... A painful one at that."
	flags_inv = HIDEHAIR|HIDEMASK|HIDEEARS|HIDEHAIR|HIDEFACIALHAIR
	flags_cover = HEADCOVERSEYES|HEADCOVERSMOUTH
	icon_state = "plated"

/obj/item/clothing/suit/armor/ego_gear/city/echo/faux
	name = "Frilled Maid Outfit/Faux Fur Coat"
	desc = "Seems that layering the two outfits stops the coat from taking any effect, but it at least still protects whatever semi-professional image he's got left."
	icon_state = "faux"
	armor = list(RED_DAMAGE = 60, WHITE_DAMAGE = 40, BLACK_DAMAGE = 20, PALE_DAMAGE = 10)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
