/obj/item/clothing/suit/armor/ego_gear/city/masquerade_cloak
	name = "masquerade cloak"
	desc = "A cloak worn by the bloodfiends, worn in celebration of something..."
	icon_state = "masqcloak"
	var/normal_state = "masqcloak"
	var/hardblood_state = null
	icon = 'ModularTegustation/Teguicons/blood_fiend_gear.dmi'
	worn_icon = 'ModularTegustation/Teguicons/blood_fiend_gear_worn.dmi'
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 20, BLACK_DAMAGE = 40, PALE_DAMAGE = 20)
	hat = /obj/item/clothing/head/ego_hat/blood_fiend/bird_mask
	neck = /obj/item/clothing/ego_neck/blood_fiend/coagulated_blood
	var/bloodfeast = 0
	var/bloodfeast_max = 200
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/suit/armor/ego_gear/city/masquerade_cloak/Initialize()
	. = ..()
	var/obj/effect/proc_holder/ability/AS = new /obj/effect/proc_holder/ability/bloodfeast
	var/datum/action/spell_action/ability/item/A = AS.action
	A.SetItem(src)

	var/obj/effect/proc_holder/ability/BS = new /obj/effect/proc_holder/ability/bloodart
	var/datum/action/spell_action/ability/item/B = BS.action
	B.SetItem(src)

/obj/item/clothing/suit/armor/ego_gear/city/masquerade_cloak/examine(mob/user)
	. = ..()
	. += span_notice("This outfit currently has [bloodfeast] bloodfeast out of [bloodfeast_max] maximum bloodfeast.")

/obj/effect/proc_holder/ability/bloodfeast
	name = "Bloodfeast"
	desc = "An ability that lets the user drain nearby blood to increase the armor's bloodfeast."
	action_icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	action_icon_state = "lc_bleed"
	base_icon_state = "lc_bleed"
	cooldown_time = 5 SECONDS

/obj/effect/proc_holder/ability/bloodfeast/Perform(target, mob/user)
	playsound(get_turf(user), 'sound/abnormalities/nosferatu/bloodcollect.ogg', 25, 0, 4)
	if (ishuman(user))
		var/mob/living/carbon/human/wielder = user
		var/obj/item/clothing/suit/armor/ego_gear/city/masquerade_cloak/S = wielder.get_item_by_slot(ITEM_SLOT_OCLOTHING)
		for(var/obj/effect/decal/cleanable/blood/B in view(wielder, 2)) //will clean up any blood, but only heals from human blood
			if(B.blood_state == BLOOD_STATE_HUMAN)
				if(B.bloodiness == 100) //Bonus for "pristine" bloodpools, also to prevent footprint spam
					S.bloodfeast += 30
				else
					S.bloodfeast += (max((B.bloodiness**2)/800,1))
			qdel(B)
		if(S.bloodfeast >= S.bloodfeast_max)
			S.bloodfeast = S.bloodfeast_max
	return ..()

/obj/effect/proc_holder/ability/bloodart
	name = "Blood Art"
	desc = "An ability that lets the user spend the armor's bloodfeast to heal."
	action_icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	action_icon_state = "lc_bleed"
	base_icon_state = "lc_bleed"
	cooldown_time = 20 SECONDS

/obj/effect/proc_holder/ability/bloodart/Perform(target, mob/user)
	playsound(get_turf(user), 'sound/abnormalities/nosferatu/bloodcollect.ogg', 25, 0, 4)
	if (ishuman(user))
		var/mob/living/carbon/human/wielder = user
		var/obj/item/clothing/suit/armor/ego_gear/city/masquerade_cloak/S = wielder.get_item_by_slot(ITEM_SLOT_OCLOTHING)
		wielder.adjustBruteLoss(-(S.bloodfeast/2))
		if (S.bloodfeast == S.bloodfeast_max)
			if (S.hardblood_state)
				S.icon_state = S.hardblood_state
			addtimer(CALLBACK(src, PROC_REF(ResetArmor), S), 600)
		S.bloodfeast = 0
	return ..()

/obj/effect/proc_holder/ability/bloodart/proc/ResetArmor(obj/item/clothing/suit/armor/ego_gear/city/masquerade_cloak/A)
	A.icon_state = A.normal_state

/obj/item/clothing/suit/armor/ego_gear/city/masquerade_cloak/masquerade_coat
	name = "masquerade coat"
	desc = "A coat worn by the bloodbags, worn in celebration of something..."
	icon_state = "Driedcoat"
	normal_state = "Driedcoat"
	hardblood_state = "Bloodcoat"
	bloodfeast_max = 100
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 20, BLACK_DAMAGE = 10, PALE_DAMAGE = 0)
	hat = null
	neck = null
	attribute_requirements = list()

/obj/item/clothing/ego_neck/blood_fiend
	icon = 'ModularTegustation/Teguicons/blood_fiend_gear.dmi'
	worn_icon = 'ModularTegustation/Teguicons/blood_fiend_gear_worn.dmi'

/obj/item/clothing/neck/blood_fiend
	icon = 'ModularTegustation/Teguicons/blood_fiend_gear.dmi'
	worn_icon = 'ModularTegustation/Teguicons/blood_fiend_gear_worn.dmi'

/obj/item/clothing/head/ego_hat/blood_fiend
	icon = 'ModularTegustation/Teguicons/blood_fiend_gear.dmi'
	worn_icon = 'ModularTegustation/Teguicons/blood_fiend_gear_worn.dmi'

/obj/item/clothing/neck/blood_fiend/masquerade_tie
	name = "masquerade tie"
	desc = "A tie which fits the masquerade cloak."
	icon_state = "masqtie"

/obj/item/clothing/head/ego_hat/blood_fiend/bird_mask
	name = "masquerade mask"
	desc = "A mask that the bloodfiends have worn during the masquerade..."
	icon_state = "bird_mask"

/obj/item/clothing/ego_neck/blood_fiend/coagulated_blood
	name = "coagulated blood"
	desc = "The coagulated blood of a bloodfiend..."
	icon_state = "coagulated_blood"
