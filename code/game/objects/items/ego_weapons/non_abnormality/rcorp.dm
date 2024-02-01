/obj/item/ego_weapon/city/rabbit_blade
	name = "high-frequency combat blade"
	desc = "A high-frequency combat blade made for use against abnormalities and other threats in Lobotomy Corporation and the outskirts."
	icon_state = "rabbitblade"
	inhand_icon_state = "rabbit_katana"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	force = 35
	throwforce = 24
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("stabs", "slices")
	attack_verb_simple = list("stab", "slice")
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 55,
		PRUDENCE_ATTRIBUTE = 55,
		TEMPERANCE_ATTRIBUTE = 55,
		JUSTICE_ATTRIBUTE = 55,
	)

/obj/item/ego_weapon/city/rabbit_blade/attack_self(mob/living/user)
	switch(damtype)
		if(RED_DAMAGE)
			damtype = WHITE_DAMAGE
		if(WHITE_DAMAGE)
			damtype = BLACK_DAMAGE
			force = 30
		if(BLACK_DAMAGE)
			damtype = PALE_DAMAGE
			force = 25
		if(PALE_DAMAGE)
			damtype = RED_DAMAGE
			force = 35
	to_chat(user, span_notice("\The [src] will now deal [damtype] damage."))
	playsound(src, 'sound/items/screwdriver2.ogg', 50, TRUE)

//Command Sabre
/obj/item/ego_weapon/city/rabbit_blade/command
	name = "R-corp command sabre"
	desc = "A stronger rcorp blade made for the ground commander."
	icon_state = "rcorp_sabre"
	inhand_icon_state = "multiverse"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	force = 50
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 0,
							JUSTICE_ATTRIBUTE = 100
							)

/obj/item/ego_weapon/city/rabbit_blade/command/attack_self(mob/living/user)
	switch(damtype)
		if(RED_DAMAGE)
			damtype = WHITE_DAMAGE
		if(WHITE_DAMAGE)
			damtype = BLACK_DAMAGE
		if(BLACK_DAMAGE)
			damtype = PALE_DAMAGE
		if(PALE_DAMAGE)
			damtype = RED_DAMAGE
	to_chat(user, span_notice("\The [src] will now deal [damtype] damage."))
	playsound(src, 'sound/items/screwdriver2.ogg', 50, TRUE)


//Reindeer staves
/obj/item/ego_weapon/city/reindeer
	name = "R-corp reindeer staff"
	desc = "A staff used by the reindeer team. The ranged attack does black damage."
	icon_state = "rcorp_staff"
	inhand_icon_state = "staffofstorms"
	lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'
	force = 40
	damtype = WHITE_DAMAGE

	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
	var/ranged_cooldown
	var/ranged_cooldown_time = 1.3 SECONDS

/obj/item/ego_weapon/city/reindeer/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(ranged_cooldown > world.time)
		return
	if(!CanUseEgo(user))
		return
	var/turf/target_turf = get_turf(A)
	if(!istype(target_turf))
		return
	if((get_dist(user, target_turf) < 2) || (get_dist(user, target_turf) > 5))
		return
	..()
	ranged_cooldown = world.time + ranged_cooldown_time
	playsound(target_turf, 'sound/weapons/pulse.ogg', 50, TRUE)
	for(var/turf/open/T in range(target_turf, 0))
		new /obj/effect/temp_visual/smash1(T)
		user.HurtInTurf(T, list(), force, BLACK_DAMAGE)

/obj/item/ego_weapon/city/reindeer/captain
	name = "R-corp reindeer captain staff"
	icon_state = "rcorp_captainstaff"
	force = 60
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)


//Shitty Raven Dagger
/obj/item/ego_weapon/city/rabbit_blade/raven
	name = "R-corp raven dagger"
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 40,
							PRUDENCE_ATTRIBUTE = 40,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)


//Rcorp Guns

/obj/item/gun/energy/e_gun/rabbit
	name = "R-Corporation R-3000 'Mark 2'"
	desc = "An energy gun produced specifically to suppress threats within Lobotomy Corporation, it has four firing modes to switch between."
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	icon_state = "rabbit"
	inhand_icon_state = "rabbit"
	cell_type = /obj/item/stock_parts/cell/infinite
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/red,
		/obj/item/ammo_casing/energy/laser/white,
		/obj/item/ammo_casing/energy/laser/black,
		/obj/item/ammo_casing/energy/laser/pale
		)
	can_charge = FALSE
	weapon_weight = WEAPON_HEAVY // No dual wielding
	pin = /obj/item/firing_pin/implant/mindshield
	//None of these fucking guys can use Rcorp guns
	var/list/banned_roles = list("Raven Squad Captain", "Reindeer Squad Captain","Rhino Squad Captain",
		"R-Corp Berserker Reindeer","R-Corp Medical Reindeer","R-Corp Gunner Rhino","R-Corp Hammer Rhino","R-Corp Scout Raven","R-Corp Support Raven",
		"R-Corp Roadrunner", "Roadrunner Squad Leader")

/obj/item/gun/energy/e_gun/rabbit/Initialize()
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.16 SECONDS)


/obj/item/gun/energy/e_gun/rabbit/process_fire(atom/target, mob/living/user, message, params, zone_override, bonus_spread)
	if(user.mind)
		if(user.mind.assigned_role in banned_roles)
			to_chat(user, span_notice("You are not trained to use Rcorp firearms!"))
			return FALSE
	..()

/obj/item/gun/energy/e_gun/rabbit/captain
	name = "R-Corporation R-4000 'Mark 3'"
	desc = "An energy gun produced especially for the rabbit captain. This weapon can be fired with one hand."
	icon_state = "rabbitcaptain"
	weapon_weight = WEAPON_LIGHT
	pin = /obj/item/firing_pin

//you really shouldn't be having this as a spawned in rabbit
/obj/item/gun/energy/e_gun/rabbit/nopin
	name = "R-Corporation R-2800 'Mark 1'"
	desc = "An energy gun produced specifically to suppress threats with a variety of damage types. This one is an older model, and only has 3 modes."
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/red,
		/obj/item/ammo_casing/energy/laser/white,
		/obj/item/ammo_casing/energy/laser/black
		)
	pin = /obj/item/firing_pin

/obj/item/gun/energy/e_gun/rabbit/minigun
	name = "R-Corporation X-15 Minigun"
	desc = "An energy machinegun that is extremely heavy, and fires bullets extremely quickly."
	icon_state = "rabbitmachinegun"
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/red,
		)
	pin = /obj/item/firing_pin
	projectile_damage_multiplier = 0.4
	item_flags = SLOWS_WHILE_IN_HAND
	fire_delay = 0
	drag_slowdown = 3
	slowdown = 2

/obj/item/gun/energy/e_gun/rabbit/minigun/Initialize()
	. = ..()
	AddComponent(/datum/component/automatic_fire, 0.05 SECONDS)

/obj/item/gun/energy/e_gun/rabbit/minigun/tricolor
	name = "R-Corporation R-3500 Minigun"
	desc = "An energy machinegun that is extremely heavy, and fires bullets extremely quickly."
	icon_state = "rabbitmachinegun"
	projectile_damage_multiplier = 0.7
	ammo_type = list(
		/obj/item/ammo_casing/energy/laser/red,
		/obj/item/ammo_casing/energy/laser/white,
		/obj/item/ammo_casing/energy/laser/black
		)

/obj/item/ego_weapon/city/rabbit_rush
	name = "rush dagger"
	desc = "A high-frequency combat blade made for use against abnormalities and other threats in Lobotomy Corporation and the outskirts. This only has one mode"
	special = "Use in hand to activate teleport mode. Click on a target in teleport mode to do a teleport attack."
	icon_state = "rabbitdash"
	inhand_icon_state = "rabbit_katana"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	force = 20
	throwforce = 24
	damtype = PALE_DAMAGE

	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("stabs", "slices")
	attack_verb_simple = list("stab", "slice")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 55,
							PRUDENCE_ATTRIBUTE = 55,
							TEMPERANCE_ATTRIBUTE = 55,
							JUSTICE_ATTRIBUTE = 55
							)
	var/teleporting

/obj/item/ego_weapon/city/rabbit_rush/attack_self(mob/user)
	if(!CanUseEgo(user))
		return

	if(!do_after(user, 10, src))
		return
	if(teleporting)
		teleporting = FALSE
		to_chat(user,span_warning("You disable teleport."))
	else
		teleporting = TRUE
		to_chat(user,span_warning("You prepare to teleport."))

/obj/item/ego_weapon/city/rabbit_rush/afterattack(atom/A, mob/living/user, proximity_flag, params)
	var/turf/target_turf = get_turf(A)
	if(!istype(target_turf))
		return
	if(get_dist(user, target_turf) < 2)
		return
	..()

	//Are you currently trying to teleport?
	if(!teleporting)
		return

	var/targetfound
	playsound(target_turf, 'sound/weapons/rapierhit.ogg', 100, TRUE)
	if(LAZYLEN(user.HurtInTurf(target_turf, list(), force*2, PALE_DAMAGE)))
		targetfound = TRUE
	//So you can't fucking teleport into a place where you are immune to all damage
	if(!targetfound)
		to_chat(user,span_warning("No target found!"))
		return

	new /obj/effect/temp_visual/kinetic_blast(target_turf)

	//actually teleport
	var/list/teleport_targets = list()
	for(var/turf/open/Y in orange(1, target_turf))
		teleport_targets+=Y
	if(!LAZYLEN(teleport_targets))
		to_chat(user,span_warning("Failed to Teleport!"))
		return

	new /obj/effect/temp_visual/guardian/phase (get_turf(user))
	user.forceMove(pick(teleport_targets))

	//set all to 0
	teleporting = FALSE
