#define MAX_ARMOR 80
#define MAX_SILKS 80

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
	if (newArmor.red > MAX_ARMOR)
		newArmor.red = MAX_ARMOR
	if (newArmor.white > MAX_ARMOR)
		newArmor.white = MAX_ARMOR
	if (newArmor.black > MAX_ARMOR)
		newArmor.black = MAX_ARMOR
	if (newArmor.pale > MAX_ARMOR)
		newArmor.pale = MAX_ARMOR

	O.armor = newArmor;
