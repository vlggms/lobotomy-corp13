/obj/item/ego_weapon/template
	name = "blank template"
	desc = "A blank template. You should never see this!"
	icon = 'ModularTegustation/Teguicons/workshop.dmi'
	force = 0
	attack_speed = 1
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	var/active
	var/list/finishedname = list()
	var/list/finishedicon = list()
	var/finisheddesc = "A finished weapon."
	var/specialmod
	var/aoe_range

/obj/item/ego_weapon/template/attack(mob/living/target, mob/living/carbon/human/user)
	if(!active)
		to_chat(user, "<span class='notice'>This weapon is unfinished!</span>")
		return
	specialcheck(target, user)
	..()

/obj/item/ego_weapon/template/proc/specialcheck(mob/living/target, mob/living/carbon/human/user)
	switch(pick(specialmod))
		if("health healing")
			HealHealth(target, user)
		if("sanity healing")
			HealSanity(target, user)

/obj/item/ego_weapon/template/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/workshop_mod) || active)
		return
	var/obj/item/workshop_mod/mod = I
	active = TRUE
	force *= mod.forcemod
	attack_speed *= mod.attackspeedmod
	damtype = mod.damagetype
	armortype = mod.damagetype
	aoe_range += mod.aoemod
	color = mod.weaponcolor
	specialmod = mod.specialmod
	//throwforce is special
	if(throwforce>force)
		throwforce *= mod.throwforcemod
	else if(mod.throwforcemod > 1)
		throwforce = 30
	var/newname = pick(finishedname)
	name = "[mod.modname] [newname]"
	if(finishedicon)
		icon_state = pick(finishedicon)
	desc = finisheddesc
	add_overlay("[mod.overlay]")
	qdel(I)
	return


//Special Mod Procs

//Healing
/obj/item/ego_weapon/template/proc/HealHealth(mob/living/target,mob/living/carbon/human/user)
	if(!(target.status_flags & GODMODE) && target.stat != DEAD)
		var/heal_amt = force*0.10
		if(isanimal(target))
			var/mob/living/simple_animal/S = target
			if(S.damage_coeff[damtype] > 0)
				heal_amt *= S.damage_coeff[damtype]
			else
				heal_amt = 0
		user.adjustBruteLoss(-heal_amt)

/obj/item/ego_weapon/template/proc/HealSanity(mob/living/target,mob/living/carbon/human/user)
	if(!(target.status_flags & GODMODE) && target.stat != DEAD)
		var/heal_amt = force*0.10
		if(isanimal(target))
			var/mob/living/simple_animal/S = target
			if(S.damage_coeff[damtype] > 0)
				heal_amt *= S.damage_coeff[damtype]
			else
				heal_amt = 0
		user.adjustSanityLoss(-heal_amt)


