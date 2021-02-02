// Advanced mulligan. Basically, a device that acts just like changeling's sting and transformation ability.
// Only one use to mutate, but can be reused unlimited amount of times to store another DNA before transformation.

/obj/item/adv_mulligan
	name = "advanced mulligan"
	desc = "Toxin that permanently changes your DNA into the one of last injected person."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "dnainjector0"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	var/used = FALSE
	var/mob/living/carbon/human/stored

/obj/item/adv_mulligan/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	return //Stealth

/obj/item/adv_mulligan/afterattack(atom/movable/AM, mob/living/carbon/human/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(!istype(user))
		return
	if(used)
		to_chat(user, "<span class='warning'>[src] has been already used, you can't activate it again!</span>")
		return
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(user.real_name != H.dna.real_name)
			stored = H
			to_chat(user, "<span class='notice'>You stealthly stab [H.name] with [src].</span>")
			desc = "Toxin that permanently changes your DNA into the one of last injected person. It has DNA of <span class='blue'>[stored.dna.real_name]</span> inside."
			icon_state = "dnainjector"
		else
			if(stored)
				mutate(user)
			else
				to_chat(user, "<span class='warning'>You can't stab yourself with [src]!</span>")

/obj/item/adv_mulligan/attack_self(mob/living/carbon/user)
	mutate(user)

/obj/item/adv_mulligan/proc/mutate(mob/living/carbon/user)
	if(used)
		to_chat(user, "<span class='warning'>[src] has been already used, you can't activate it again!</span>")
		return
	if(!used)
		if(stored)
			user.visible_message("<span class='warning'>[user.name] shivers in pain and soon transform into [stored.dna.real_name]!</span>", \
			"<span class='notice'>You inject yourself with [src] and suddenly become a copy of [stored.dna.real_name].</span>")

			user.real_name = stored.real_name
			stored.dna.transfer_identity(user, transfer_SE=1)
			user.updateappearance(mutcolor_update=1)
			user.domutcheck()
			used = TRUE

			icon_state = "dnainjector0"
			desc = "Toxin that permanently changes your DNA into the one of last injected person. This one is used up."

		else
			to_chat(user, "<span class='warning'>[src] doesn't have any DNA loaded in it!</span>")

// A "nuke op" kit for Gorlex Infiltrators, available for 15 TC.
/obj/item/storage/backpack/duffelbag/syndie/flukeop/PopulateContents()
	new /obj/item/clothing/suit/space/hardsuit/syndi(src) //8 TC
	new /obj/item/storage/box/syndie_kit/imp_microbomb(src) //2 TC
	new /obj/item/clothing/glasses/night(src)
	new /obj/item/radio/headset/syndicate/alt(src)
	new /obj/item/clothing/gloves/combat(src) //1 TC?
	new /obj/item/gun/ballistic/automatic/pistol(src) //7 TC
