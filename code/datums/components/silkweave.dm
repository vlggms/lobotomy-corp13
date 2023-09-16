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
	to_chat(user, "<span class='notice'>You have successfully upgraded the armor to [S.added_armor.tag].</span>")
	// Here, you can modify the armor stats based on the upgrade_item

	var/obj/O = parent
	var/datum/armor/newArmor = O.armor.attachArmor(S.added_armor)
	to_chat(user, "<span class='notice'>New armor [newArmor.tag].</span>")
	if (newArmor.red > MAX_ARMOR)
		to_chat(user, "<span class='notice'>Max armor [newArmor.red].</span>")
		newArmor.red = MAX_ARMOR
	if (newArmor.white > MAX_ARMOR)
		to_chat(user, "<span class='notice'>Max armor [newArmor.white].</span>")
		newArmor.white = MAX_ARMOR
	if (newArmor.black > MAX_ARMOR)
		to_chat(user, "<span class='notice'>Max armor [newArmor.black].</span>")
		newArmor.black = MAX_ARMOR
	if (newArmor.pale > MAX_ARMOR)
		to_chat(user, "<span class='notice'>Max armor [newArmor.pale].</span>")
		newArmor.pale = MAX_ARMOR

	O.armor = newArmor;
