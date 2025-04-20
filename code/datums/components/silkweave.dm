#define MAX_ARMOR 40
#define MAX_SILKS 20

/datum/component/silkweave
	var/list/silks


/datum/component/silkweave/proc/apply_silk(obj/item/stack/sheet/silk/S, mob/user)
	if(!silks)
		silks = list()
	if(silks.len >= MAX_SILKS) // Limit
		to_chat(user, "<span class='warning'>The armor is already fully upgraded.</span>")
		return
	silks += S
	S.use(1)
	to_chat(user, "<span class='notice'>You have successfully upgraded the armor.</span>")
	// Here, you can modify the armor stats based on the upgrade_item

	var/obj/O = parent
	var/datum/armor/newArmor = O.armor.attachArmor(S.added_armor)
	var/old_red = O.armor.red
	var/old_white = O.armor.white
	var/old_black = O.armor.black
	var/old_pale = O.armor.pale
	var/new_red = newArmor.red
	var/new_white = newArmor.white
	var/new_black = newArmor.black
	var/new_pale = newArmor.pale
	if (new_red > MAX_ARMOR)
		to_chat(user, span_notice("Red armor cannot be upgraded any further."))
		new_red = old_red
	if (new_white > MAX_ARMOR)
		to_chat(user, span_notice("White armor cannot be upgraded any further."))
		new_white = old_white
	if (new_black > MAX_ARMOR)
		to_chat(user, span_notice("Black armor cannot be upgraded any further."))
		new_black = old_black
	if (new_pale > MAX_ARMOR)
		to_chat(user, span_notice("Pale armor cannot be upgraded any further."))
		new_pale = old_pale

	O.armor = newArmor.setRating(red = new_red, white = new_white, black = new_black, pale = new_pale);
	to_chat(user, span_notice("New armor: RED [O.armor.red], WHITE [O.armor.white], BLACK [O.armor.black], PALE [O.armor.pale]."))
