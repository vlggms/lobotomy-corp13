//AOE L1
/obj/item/workshop_mod/aoe
	icon_state = "aoecore"
	overlay = "aoe"
	aoemod = 1
	attackspeedmod = 1.3

/obj/item/workshop_mod/aoe/InstallationEffect(obj/item/ego_weapon/template/T)
	aoemod += T.aoe_range
	..()

/obj/item/workshop_mod/aoe/ActivateEffect(obj/item/ego_weapon/template/T, special_count = 0, mob/living/target, mob/living/carbon/human/user)
	for(var/mob/living/L in view(aoemod, get_turf(target)))
		var/aoe_damage = T.force / 2
		var/userjust = (get_attribute_level(user, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust/100
		aoe_damage*=justicemod
		if(L == user)
			continue
		L.apply_damage(aoe_damage, damtype, null, L.run_armor_check(null, damtype), spread_damage = TRUE)
		new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(L))

/obj/item/workshop_mod/aoe/red
	name = "aoe red damage mod"
	desc = "A workshop mod to turn a weapon into red damage"
	modname = "wide"
	color = "#FF0000"
	weaponcolor = "#FF0000"
	damagetype = RED_DAMAGE

/obj/item/workshop_mod/aoe/white
	name = "aoe white damage mod"
	desc = "A workshop mod to turn a weapon into white damage"
	modname = "broad"
	color = "#deddb6"
	weaponcolor = "#deddb6"
	damagetype = WHITE_DAMAGE

/obj/item/workshop_mod/aoe/black
	name = "aoe black damage mod"
	desc = "A workshop mod to turn a weapon into black damage"
	color = "#442047"
	modname = "extensive"
	weaponcolor = "#442047"
	damagetype = BLACK_DAMAGE

/obj/item/workshop_mod/aoe/pale
	name = "aoe pale damage mod"
	desc = "A workshop mod to turn a weapon into pale damage"
	forcemod = 0.7
	color = "#80c8ff"
	modname = "scopic"
	weaponcolor = "#80c8ff"
	damagetype = PALE_DAMAGE


//AOE L2
/obj/item/workshop_mod/aoe/large
	icon_state = "bigaoecore"
	overlay = "bigaoe"
	aoemod = 2
	attackspeedmod = 1.6

/obj/item/workshop_mod/aoe/large/red
	name = "large aoe red damage mod"
	desc = "A workshop mod to turn a weapon into red damage"
	modname = "massive"
	color = "#FF0000"
	weaponcolor = "#FF0000"
	damagetype = RED_DAMAGE

/obj/item/workshop_mod/aoe/large/white
	name = "large aoe white damage mod"
	desc = "A workshop mod to turn a weapon into white damage"
	modname = "sizable"
	color = "#deddb6"
	weaponcolor = "#deddb6"
	damagetype = WHITE_DAMAGE

/obj/item/workshop_mod/aoe/large/black
	name = "large aoe black damage mod"
	desc = "A workshop mod to turn a weapon into black damage"
	color = "#442047"
	modname = "substantial"
	weaponcolor = "#442047"
	damagetype = BLACK_DAMAGE

/obj/item/workshop_mod/aoe/large/pale
	name = "large aoe pale damage mod"
	desc = "A workshop mod to turn a weapon into pale damage"
	forcemod = 0.7
	color = "#80c8ff"
	modname = "grand"
	weaponcolor = "#80c8ff"
	damagetype = PALE_DAMAGE
