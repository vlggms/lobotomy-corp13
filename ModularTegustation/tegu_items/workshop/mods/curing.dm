//These are rare, but they all heal you
/obj/item/workshop_mod/curing
	icon_state = "curecore"
	overlay = "curing"

//Heals both physical and mental damage.
/obj/item/workshop_mod/curing/ActivateEffect(obj/item/ego_weapon/template/T, special_count = 0, mob/living/target, mob/living/carbon/human/user)
	if(!(target.status_flags & GODMODE) && target.stat != DEAD)
		var/heal_amt = T.force*0.04
		if(isanimal(target))
			var/mob/living/simple_animal/S = target
			if(S.damage_coeff[damtype] > 0)
				heal_amt *= S.damage_coeff[damtype]
			else
				heal_amt = 0
		user.adjustSanityLoss(-heal_amt)
		user.adjustBruteLoss(-heal_amt)

/obj/item/workshop_mod/curing/red
	name = "curing red damage mod"
	desc = "A workshop mod to turn a weapon into red damage"
	modname = "triage"
	color = "#FF0000"
	weaponcolor = "#FF0000"
	damagetype = RED_DAMAGE

/obj/item/workshop_mod/curing/white
	name = "curing white damage mod"
	desc = "A workshop mod to turn a weapon into white damage"
	modname = "recovering"
	color = "#deddb6"
	weaponcolor = "#deddb6"
	damagetype = WHITE_DAMAGE

/obj/item/workshop_mod/curing/black
	name = "curing black damage mod"
	desc = "A workshop mod to turn a weapon into black damage"
	color = "#442047"
	modname = "mending"
	weaponcolor = "#442047"
	damagetype = BLACK_DAMAGE

/obj/item/workshop_mod/curing/pale
	name = "curing pale damage mod"
	desc = "A workshop mod to turn a weapon into pale damage"
	forcemod = 0.7
	color = "#80c8ff"
	modname = "convalescent"
	weaponcolor = "#80c8ff"
	damagetype = PALE_DAMAGE
