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
	var/type_overriden = FALSE
	var/forceholder	//holds the force for later
	var/special_count //Various vars use this for various things

/obj/item/ego_weapon/template/attack(mob/living/target, mob/living/carbon/human/user)
	forceholder = force
	if(!active)
		to_chat(user, "<span class='notice'>This weapon is unfinished!</span>")
		return
	specialcheck(target, user)
	..()
	if(forceholder != force)
		force = forceholder

/obj/item/ego_weapon/template/proc/specialcheck(mob/living/target, mob/living/carbon/human/user)
	if(aoe_range)
		aoe(target, user)
	switch(pick(specialmod))
		if("health healing")
			HealHealth(target, user)
		if("sanity healing")
			HealSanity(target, user)
		if("curing")
			Cure(target, user)
		if("split damage")
			Split(target, user)
		if("sharp")		//Uses Special Count for poise.
			sharp(target, user)

/obj/item/ego_weapon/template/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/workshop_mod) || active)
		return
	var/obj/item/workshop_mod/mod = I
	active = TRUE

	//Modify these
	force *= mod.forcemod
	attack_speed *= mod.attackspeedmod
	aoe_range += mod.aoemod

	if(!type_overriden)
		damtype = mod.damagetype
		armortype = mod.damagetype
	if(!color) // Material color overwrites
		color = mod.weaponcolor
	specialmod = mod.specialmod
	//throwforce is special
	if(throwforce>force)
		throwforce *= mod.throwforcemod
	else if(mod.throwforcemod > 1)
		throwforce = 30

	//naming and icon stuff.
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

//Sanity
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


//Curing
/obj/item/ego_weapon/template/proc/Cure(mob/living/target,mob/living/carbon/human/user)
	if(!(target.status_flags & GODMODE) && target.stat != DEAD)
		var/heal_amt = force*0.04
		if(isanimal(target))
			var/mob/living/simple_animal/S = target
			if(S.damage_coeff[damtype] > 0)
				heal_amt *= S.damage_coeff[damtype]
			else
				heal_amt = 0
		user.adjustSanityLoss(-heal_amt)
		user.adjustBruteLoss(-heal_amt)

//AOE
/obj/item/ego_weapon/template/proc/aoe(mob/living/target,mob/living/carbon/human/user)
	for(var/mob/living/L in view(aoe_range, target))
		var/aoe = force/2
		var/userjust = (get_attribute_level(user, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust/100
		aoe*=justicemod
		if(L == user)
			continue
		L.apply_damage(aoe, damtype, null, L.run_armor_check(null, damtype), spread_damage = TRUE)
		new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(L))

//Sharp, works like kuro katana
/obj/item/ego_weapon/template/proc/sharp(mob/living/target,mob/living/carbon/human/user)
	if(target.status_flags & GODMODE || target.stat == DEAD)
		return

	if(special_count>= 20)
		special_count = 20

	//Crit itself.
	if(prob(special_count*2))
		force*=3
		to_chat(user, "<span class='userdanger'>Critical!</span>")
		special_count = 0

//Split damage, currently only red and white
/obj/item/ego_weapon/template/proc/Split(mob/living/target,mob/living/carbon/human/user)
	var/userjust = (get_attribute_level(user, JUSTICE_ATTRIBUTE))
	var/justicemod = 1 + userjust/100
	var/splitdamage = justicemod*force
	var/splitdamagetype
	switch(damtype)
		if(RED_DAMAGE)
			splitdamagetype = PALE_DAMAGE
		if(WHITE_DAMAGE)
			splitdamagetype = BLACK_DAMAGE
	target.apply_damage(splitdamage, splitdamagetype, null, target.run_armor_check(null, splitdamagetype), spread_damage = TRUE)
