	/*-----\
	| Vile |
	\------/

	This mod accumulates corruption that grants a 30% damage buff
	at high levels but must be emptied.*/
/obj/item/workshop_mod/vile
	name = "vile core"
	desc = "This modification allows you to draw vile energy and release it as a burst. You must be mindful to keep this energy from hitting its limit."
	icon_state = "offbeatcore"
	overlay = "offbeat"
	modname = "vile"
	color = "#442047"
	weaponcolor = "#442047"
	var/balance_stat = "NEUTRAL"
	var/balance_mod = 1
	//These are for special abilities or UI elements.
	var/linked_ability
	var/atom/movable/screen/screen_obj
	var/screen_obj_type = /atom/movable/screen/vile_skull
	//Who is using us.
	var/mob/living/current_user
	//What we are installed into.
	var/obj/item/ego_weapon/template/modded_temp

/obj/item/workshop_mod/vile/ActivateEffect(obj/item/ego_weapon/template/T, special_count = 0, mob/living/target, mob/living/carbon/human/user)
	AdjustBalance(T.force * 0.2, user, target)
	..()

/obj/item/workshop_mod/vile/InstallationEffect(obj/item/ego_weapon/template/T)
	modded_temp = T
	if(screen_obj_type)
		RegisterSignal(modded_temp, COMSIG_ITEM_EQUIPPED, PROC_REF(itemGrabbed))
		RegisterSignal(modded_temp, COMSIG_ITEM_DROPPED, PROC_REF(itemDropped))
		applyAbilities()
	..()

/* Should be filled with whatever
	abilities are applied to this weapon. */
/obj/item/workshop_mod/vile/proc/applyAbilities()
	var/obj/effect/proc_holder/ability/aimed/vile_burst/HD = new
	var/datum/action/spell_action/ability/item/A = HD.action
	HD.linkItems(src)
	A.SetItem(modded_temp)
	linked_ability = HD

//Applies stuff when item is picked up.
/obj/item/workshop_mod/vile/proc/itemGrabbed(datum/source, mob/equipper, slot)
	SIGNAL_HANDLER
	if(!iscarbon(equipper) || slot != ITEM_SLOT_HANDS)
		return
	var/mob/living/owner = equipper
	if(screen_obj_type && owner.hud_used && owner && current_user != equipper)
		var/datum/hud/hud = owner.hud_used
		screen_obj = new screen_obj_type
		hud.infodisplay += screen_obj
		hud.show_hud(hud.hud_version)
		//possible way to avoid pocket UI duplication
		current_user = equipper

//Removes stuff when item is put down.
/obj/item/workshop_mod/vile/proc/itemDropped(datum/source, mob/user)
	SIGNAL_HANDLER
	var/mob/living/owner = user
	if(owner.hud_used && owner && screen_obj)
		var/datum/hud/hud = owner.hud_used
		hud.infodisplay -= screen_obj
		hud.show_hud(hud.hud_version)
		qdel(screen_obj)
	current_user = null

//This proc is for changing the icon state of the UI object.
/obj/item/workshop_mod/vile/proc/UpdateUserface(user)
	var/mob/living/owner = user
	if(!(owner.client || owner.hud_used))
		return
	screen_obj.cut_overlays()
	screen_obj.icon_state = UpdateUserfaceIcon()

/* This proc should return what icon state you want.
	If you do if(thing == TRUE) return "yes"
	the icon state of the UI will change to whatever
	that is in the UI icons. */
/obj/item/workshop_mod/vile/proc/UpdateUserfaceIcon()
	switch(balance_stat)
		if("PARTIAL DARK")
			return "corruption"
		if("HEAVY DARK")
			return "corruption_heavy"
		else
			return "no_corruption"

//What happens when you push your limits.
/obj/item/workshop_mod/vile/proc/Consequences(mob/living/user)
	user.adjustRedLoss(50)
	user.visible_message(span_warning("Chunks of [user] dissolve into mist!"), span_warning("Chunks of your flesh dissolve into mist!"))

//For adjusting the numbers.
/obj/item/workshop_mod/vile/proc/AdjustBalance(amount, mob/living/user)
	modded_temp.AlterSpecial(amount, TRUE)
	switch(modded_temp.special_count)
		if(0 to 35)
			if(balance_stat != "NEUTRAL")
				balance_stat = "NEUTRAL"
		if(36 to 74)
			if(balance_stat != "PARTIAL DARK")
				balance_stat = "PARTIAL DARK"
		if(75 to 100)
			if(balance_stat != "HEAVY DARK")
				balance_stat = "HEAVY DARK"
			user.adjustRedLoss(rand(1,3))
	ModDamage(modded_temp)
	if(modded_temp.special_count > 100)
		Consequences(user)
		ResetCesspool()
	UpdateUserface(user)

//Resets the numbers. Primarily after a effect is cast or consequences.
/obj/item/workshop_mod/vile/proc/ResetCesspool(mob/living/user)
	modded_temp.AlterSpecial(0)
	AdjustBalance(0, user)

//Damage buff relies on original damage amount.
/obj/item/workshop_mod/vile/proc/ModDamage(source)
	if(isitem(source))
		var/obj/item/I = source
		I.force /= balance_mod
		switch(balance_stat)
			if("NEUTRAL")
				balance_mod = 1
			if("PARTIAL DARK")
				balance_mod = 1.15
			if("HEAVY DARK")
				balance_mod = 1.3
		I.force *= balance_mod
		return
