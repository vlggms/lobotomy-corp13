/obj/item/ego_weapon/template
	name = "blank template"
	desc = "A blank template. You should never see this!"
	icon = 'ModularTegustation/Teguicons/workshop.dmi'
	force = 0
	attack_speed = 1
	damtype = RED_DAMAGE

	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	var/active
	var/finisheddesc = "A finished weapon."
	var/aoe_range = 0
	var/type_overriden = FALSE
	var/special_count //Various vars use this for various things
	var/obj/item/workshop_mod/specialmod
	var/list/finishedname = list()
	var/list/finishedicon = list()

	/// The true base force of the weapon including mods without modifiers
	var/true_force = 0

	//The force bonus made on creation. Adds a flat bonus to weapons.
	var/forcebonus = 0

	var/xp_per_level = 50
	var/weapon_xp = 0
	var/level_xp = 50
	var/weapon_lv = 1
	var/max_lv = 5

/obj/item/ego_weapon/template/Initialize(mob/living/target, mob/living/carbon/human/user)
	true_force = force
	return ..()

/obj/item/ego_weapon/template/attack(mob/living/target, mob/living/carbon/human/user)
	if(!active)
		to_chat(user, span_notice("This weapon is unfinished!"))
		return
	if(specialmod)
		specialmod.ActivateEffect(src, special_count, target, user)
	..()
	if(target.stat != DEAD && !istype(target, /mob/living/simple_animal/hostile/debugdummy))
		weapon_xp++
	force = true_force

/obj/item/ego_weapon/template/attackby(obj/item/I, mob/living/user, params)
	..()
	if(istype(I, /obj/item/workshop_mod) && !active)
		InstallMod(I , user)
		return

/obj/item/ego_weapon/template/attack_self(mob/living/user)
	. = ..()
	if (specialmod)
		specialmod.Toggle()

//Mod Installation Proc: Seperated from attackby so its easier to read and override.
/obj/item/ego_weapon/template/proc/InstallMod(obj/item/workshop_mod/mod, mob/living/carbon/human/user)
	if(!istype(src, /obj/item/ego_weapon/template/fishing) && istype(mod, /obj/item/workshop_mod/fishing))
		to_chat(user, span_notice("You can only use fishing mods with fishing weapons!"))
		return

	//TODO - Make one line
	if(istype(src, /obj/item/ego_weapon/template/fishing) && !istype(mod, /obj/item/workshop_mod/fishing))
		to_chat(user, span_notice("You can only use fishing mods with fishing weapons!"))
		return

	active = TRUE

	// Track weapon forging for achievement (workshop attendant only)
	if(user && user.mind && user.mind.assigned_role == "Workshop Attendant")
		user.mind.weapons_forged++
		if(user.mind.weapons_forged >= 50)
			user.client?.give_award(/datum/award/achievement/lc13/weapon_forger, user)

	//Modify these
	force *= mod.forcemod
	true_force *= mod.forcemod
	attack_speed *= mod.attackspeedmod
	force += forcebonus
	forcebonus = 0

	if(!type_overriden)
		damtype = mod.damagetype
	if(!color)
		// Material color overwrites
		color = mod.weaponcolor
	//throwforce is special
	if(throwforce>10)
		throwforce *= mod.throwforcemod
	else if(mod.throwforcemod > 1)
		throwforce = 30

	/* Calls unique installation proc that the mod has.
		Unsure if i should put all of the above in this proc.*/
	mod.InstallationEffect(src)

	//naming and icon stuff.
	var/newname = pick(finishedname)
	name = "[mod.modname] [newname]"
	if(finishedicon)
		icon_state = pick(finishedicon)
	desc = finisheddesc
	add_overlay("[mod.overlay]")
	specialmod = mod
	//May have to change this later if the contents of the weapon can be accessed.
	mod.forceMove(src)

	if(istype(src, /obj/item/ego_weapon/template/fishing))
		CheckHoroscope()

/obj/item/ego_weapon/template/proc/AlterSpecial(subject, add_to = FALSE)
	if(add_to)
		special_count += subject
	else
		special_count = subject

/obj/item/ego_weapon/template/examine(mob/user)
	. = ..()
	if(forcebonus)
		. += "This weapon will gain +[forcebonus] damage on creation."

	. += "Weapon LV : [weapon_lv]/[max_lv]."
	if(weapon_lv == 5)
		. += "This weapon is fully upgraded!"
		return


	if(weapon_xp < level_xp)
		. += "Weapon XP : [weapon_xp]/[level_xp]."
	else
		. += "Weapon XP : FULL! Bring to a workshop to reforge!"

//Upgrade shit
/obj/item/ego_weapon/template/attackby(obj/item/I, mob/living/user, params)
	..()
	if(istype(I, /obj/item/forginghammer))
		if(!(locate(/obj/structure/table/anvil) in loc))
			to_chat(user, span_warning("You need this to be on an anvil to work it."))
			return

		if(weapon_lv == max_lv)
			to_chat(user, span_warning("This weapon cannot be upgraded."))
			return

		if(weapon_xp < level_xp)
			to_chat(user, span_warning("This weapon does not have enough XP to level up yet."))
			return

		weapon_lv ++
		weapon_xp = 0
		level_xp = weapon_lv * xp_per_level
		force *= 1.1
		true_force *= 1.1

		// Award achievement for maxing out a workshop weapon
		if(weapon_lv >= max_lv && ishuman(user))
			var/mob/living/carbon/human/H = user
			H.client?.give_award(/datum/award/achievement/lc13/workshop_max, H)

//This only is used for fishing weapons
/obj/item/ego_weapon/template/proc/CheckHoroscope()
	force *= 1.3
	true_force *= 1.3

	/*
	maxforce =
	//Then Check each planet. Planets with more phases contribute less per phase
	var/mercurybuff = SSfishing.Mercury*0.75
	var/venusbuff = SSfishing.Venus*0.66
	var/marsbuff = SSfishing.Mars*0.50
	var/jupiterbuff = SSfishing.Jupiter*0.42
	var/saturnbuff = SSfishing.Saturn*0.38
	var/uranusbuff = SSfishing.Uranus*0.32
	var/neptunebuff = SSfishing.Neptune*0.29

	var/moonbuff = SSfishing.moonphase*0.50

	force += force*mercurybuff*venusbuff*marsbuff*jupiterbuff*saturnbuff*uranusbuff*neptunebuff*moonbuff
	force = round(force, 0.1)*/
