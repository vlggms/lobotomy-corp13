/obj/item/ego_weapon/template/gauntlet
	name = "gauntlet template"
	desc = "The weapon of someone who can swing their weight around like a truck"
	special = "This weapon deals it's damage after a short windup."
	icon_state = "gauntlettemplate"
	force = 40
	finishedicon = list("finishedgauntlet")
	finishedname = list("fist", "gauntlet", "glove")
	finisheddesc = "A finished gauntlet, ready for use."

//Similar to Gold Rush
/obj/item/ego_weapon/template/gauntlet/attack(mob/living/target, mob/living/user)
	if(!active)
		to_chat(user, span_notice("This weapon is unfinished!"))
		return

	if(!do_after(user, attack_speed * 5, target))
		to_chat(user, "<span class='spider'><b>Your attack was interrupted!</b></span>")
		return

	SEND_SIGNAL(user, COMSIG_MOB_ITEM_ATTACK, target, user, src)
	to_chat(target, span_userdanger("[user] punches you with everything they got!!"))
	to_chat(user, span_danger("You throw your entire body into this punch!"))

	if(specialmod)
		specialmod.ActivateEffect(src, special_count, target, user)

	//I gotta regrab  justice here
	var/userjust = (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE))
	var/justicemod = 1 + userjust/100
	force *= justicemod
	force *= (1 + (user.extra_damage / 100))
	if(src.damtype == RED_DAMAGE)
		force *= (1 + (user.extra_damage_red / 100))
	if(src.damtype == WHITE_DAMAGE)
		force *= (1 + (user.extra_damage_white / 100))
	if(src.damtype == BLACK_DAMAGE)
		force *= (1 + (user.extra_damage_black / 100))
	if(src.damtype == PALE_DAMAGE)
		force *= (1 + (user.extra_damage_pale / 100))

	if(ishuman(target))
		force = min(force, 50)

	if(target.stat != DEAD)
		weapon_xp++

	target.deal_damage(force, damtype) //MASSIVE fuckoff punch

	playsound(src, 'sound/weapons/resonator_blast.ogg', 50, TRUE)
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(target.anchored && !QDELETED(target))
		target.throw_at(throw_target, 2, 4, user) //Bigass knockback.

	force = true_force
	SEND_SIGNAL(user, COMSIG_MOB_ITEM_AFTERATTACK, target, user, TRUE, src)
