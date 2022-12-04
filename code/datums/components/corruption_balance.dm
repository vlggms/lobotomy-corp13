//An component inspired. or a cheap ripoff of, by The Secret World Legends blood magic mechanic.
//Apply to a item to give it a capacity for two binary energies the enhance your attacks but also effect your body.
//Corruption destroys the body while Purity destroys the mind.
//it turns out that components can be unique to each iteration while attached elements are unified.
/datum/component/corruption_balance
	var/balance_cesspool
	var/balance_stat
	var/balance_consequences = 1
	var/balance_damage
	var/balance_mod = 1
	var/atom/movable/screen/balance/screen_obj
	var/backlash_setting //do you want the power of this weapon to slowly effect its user?
	var/linked_ability
	var/current_user

/datum/component/corruption_balance/Initialize(consequence_setting = 1, backlash = 0)
	. = ..()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	balance_damage = 1
	backlash_setting = backlash
	balance_consequences = consequence_setting
	if(isitem(parent))
		if(!isgun(parent)) //guns benifit from the damage bonus but i cant seem to make the ability override the bullet fire.
			var/obj/effect/proc_holder/ability/aimed/corruptionpurity_release/HD = new
			var/datum/action/spell_action/ability/item/A = HD.action
			HD.component_link(src)
			A.SetItem(parent)
			linked_ability = HD
		RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, .proc/itemGrabbed)
		RegisterSignal(parent, COMSIG_ITEM_DROPPED, .proc/itemDropped)
		RegisterSignal(parent, COMSIG_ITEM_ATTACK, .proc/corruption_attack)
		RegisterSignal(parent, COMSIG_GUN_FIRED, .proc/corruption_projectile)
		RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, .proc/corruption_attack_self)

/datum/component/corruption_balance/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, list(COMSIG_ITEM_ATTACK, COMSIG_ITEM_ATTACK_SELF, COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED, COMSIG_GUN_FIRED))

/datum/component/corruption_balance/proc/itemGrabbed(datum/source, mob/living/carbon/user)
	SIGNAL_HANDLER
	var/mob/living/owner = user
	if(owner.hud_used && owner && current_user != user)
		var/datum/hud/hud = owner.hud_used
		screen_obj = new
		hud.infodisplay += screen_obj
		hud.show_hud(hud.hud_version)
		current_user = user //possible way to avoid pocket UI duplication

/datum/component/corruption_balance/proc/itemDropped(datum/source, mob/living/carbon/user)
	SIGNAL_HANDLER
	var/mob/living/owner = user
	if(owner.hud_used && owner)
		var/datum/hud/hud = owner.hud_used
		hud.infodisplay -= screen_obj
		hud.show_hud(hud.hud_version)
	current_user = null

/datum/component/corruption_balance/proc/consequences(balance, mob/living/user)
	if(balance < -100)
		user.adjustWhiteLoss(50)
		user.visible_message("<span class='warning'>[user] coughs up some white power.</span>", "<span class='warning'>You cough up a white powder.</span>")
	if(balance > 100)
		user.adjustRedLoss(50)
		user.visible_message("<span class='warning'>Chunks of [user] fall to the floor and crawl away!</span>", "<span class='warning'>Chunks of your flesh falls to the floor and crawl away!</span>")

/datum/component/corruption_balance/proc/backlash(balance_stat, mob/living/user)
	if(!backlash_setting)
		return
	switch(balance_stat)
		if("HEAVY LIGHT")
			user.adjustWhiteLoss(rand(3,5))
		if("PARTIAL LIGHT")
			user.adjustWhiteLoss(rand(1,3))
		if("PARTIAL DARK")
			user.adjustRedLoss(rand(1,3))
		if("HEAVY DARK")
			user.adjustRedLoss(rand(3,5))

/datum/component/corruption_balance/proc/adjust_balance(amount, mob/living/user)
	balance_cesspool += amount
	switch(balance_cesspool)
		if(-100 to -75)
			if(balance_stat != "HEAVY LIGHT")
				balance_stat = "HEAVY LIGHT"
			backlash(balance_stat, user)
		if(-74 to -21)
			if(balance_stat != "PARTIAL LIGHT")
				balance_stat = "PARTIAL LIGHT"
			backlash(balance_stat, user)
		if(-20 to 20)
			if(balance_stat != "NEUTRAL")
				balance_stat = "NEUTRAL"
		if(21 to 74)
			if(balance_stat != "PARTIAL DARK")
				balance_stat = "PARTIAL DARK"
			backlash(balance_stat, user)
		if(75 to 100)
			if(balance_stat != "HEAVY DARK")
				balance_stat = "HEAVY DARK"
			backlash(balance_stat, user)
	if(balance_consequences && (balance_cesspool > 100 || balance_cesspool < -100))
		consequences(balance_cesspool, user)
		reset_cesspool()
	update_balance_icon(balance_stat, user)

/datum/component/corruption_balance/proc/reset_cesspool() //can i turn this into a signal? I would problobly use the same signal for other item specific components
	balance_cesspool = 0
	balance_stat = "NEUTRAL"

/datum/component/corruption_balance/proc/corruption_projectile(obj/item/gun/weapon, mob/living/user, atom/target, params, zone_override)
	SIGNAL_HANDLER
	switch(balance_damage)
		if(1)
			adjust_balance(rand(1, 5), user)
			modify_damage(weapon)
		else
			adjust_balance(rand(-1, -5), user)
			modify_damage(weapon)

/datum/component/corruption_balance/proc/corruption_attack(datum/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER
	switch(balance_damage)
		if(1)
			adjust_balance(rand(1, 5), user, target)
			modify_damage(source)
		else
			adjust_balance(rand(-1, -5), user, target)
			modify_damage(source)

/datum/component/corruption_balance/proc/corruption_attack_self(datum/source, mob/user)
	SIGNAL_HANDLER
	switch(balance_damage)
		if(0)
			balance_damage = 1
			to_chat(user, "<span class='notice'>You attune the item to dark.</span>")
		else
			balance_damage = 0
			to_chat(user, "<span class='notice'>You attune the item to light.</span>")

/datum/component/corruption_balance/proc/update_balance_icon(balance_state, user)
	var/mob/living/owner = user
	if(!(owner.client || owner.hud_used))
		return
	screen_obj.cut_overlays()
	screen_obj.icon_state = initial(screen_obj.icon_state)
	switch(balance_state)
		if("HEAVY LIGHT")
			screen_obj.icon_state = "purified_heavy"
		if("PARTIAL LIGHT")
			screen_obj.icon_state = "purified"
		if("PARTIAL DARK")
			screen_obj.icon_state = "corruption"
		if("HEAVY DARK")
			screen_obj.icon_state = "corruption_heavy"
		else
			return

/datum/component/corruption_balance/proc/modify_damage(source) //Damage buff relies on original damage amount. Best to fix.
	if(isgun(source))
		var/obj/item/gun/P = source
		P.projectile_damage_multiplier /= balance_mod
		switch(balance_stat)
			if("HEAVY LIGHT")
				balance_mod = 1.3
			if("PARTIAL LIGHT")
				balance_mod = 1.15
			if("NEUTRAL")
				balance_mod = 1
			if("PARTIAL DARK")
				balance_mod = 1.15
			if("HEAVY DARK")
				balance_mod = 1.3
		P.projectile_damage_multiplier *= balance_mod
		return
	if(isitem(source))
		var/obj/item/I = source
		I.force /= balance_mod
		switch(balance_stat)
			if("HEAVY LIGHT")
				balance_mod = 1.3
			if("PARTIAL LIGHT")
				balance_mod = 1.15
			if("NEUTRAL")
				balance_mod = 1
			if("PARTIAL DARK")
				balance_mod = 1.15
			if("HEAVY DARK")
				balance_mod = 1.3
		I.force *= balance_mod
		return
