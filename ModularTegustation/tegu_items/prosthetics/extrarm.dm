
/obj/item/bodypart/chest/robot/extraarm
	name = "extra arms torso"
	desc = "A heavily reinforced case containing cyborg logic boards, with space for a standard power cell."
	inhand_icon_state = "buildpipe"
	icon = 'icons/mob/augmentation/augments.dmi'
	custom_premium_price = 1400

/obj/item/bodypart/chest/robot/extraarm/set_owner(new_owner)
	..()
	playsound(get_turf(owner), 'sound/weapons/circsawhit.ogg', 50, TRUE)
	var/limbs = owner.held_items.len
	owner.change_number_of_hands(limbs+1)


//Mechandrites for the Mechanicus

/obj/item/mechandrites
	name = "\improper Mechandrite Implanter"
	desc = "An implanter for mechandrites, allowing a follower of the Omnissiah to gain newly found dexterity and handiness"
	icon = 'icons/obj/device.dmi'
	icon_state = "autoimplanter"
	var/uses = 1

/obj/item/mechandrites/attack_self(mob/user)
	if(!uses)
		to_chat(user, "<span class='alert'>[src] has already been used. The tools are dull and won't reactivate.</span>")
		return
	var/limbs = user.held_items.len
	if(limbs >= 4)
		to_chat(user, "<span class='alert'>You already have an extra arm.</span>")
		return
	user.change_number_of_hands(limbs+1)
	user.visible_message("<span class='notice'>[user] presses a button on [src], and you hear a short mechanical noise.</span>", "<span class='notice'>You feel a sharp sting as [src] plunges into your body.</span>")
	to_chat(user, "Your mechandrites whirr with life")
	playsound(get_turf(user), 'sound/weapons/circsawhit.ogg', 50, TRUE)
	if(uses == 1)
		uses--
	if(!uses)
		desc = "[initial(desc)] Looks like it's been used up."
