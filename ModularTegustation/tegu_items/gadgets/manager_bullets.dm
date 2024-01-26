
	//Defective Manager Bullet PLACEHOLDER OR PROTOTYPE SHIELDS
/obj/item/managerbullet
	name = "prototype manager bullet"
	desc = "Welfare put out a notice that they lost a bunch of manager bullets. This must be one of them."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "sleeper-live"
	var/bullettype = 1

/obj/item/managerbullet/attack(mob/living/M, mob/user)
	M.visible_message(span_notice("[user] smashes [src] against [M]."))
	playsound(get_turf(M), 'sound/effects/pop_expl.ogg', 5, 0, 3)
	bulletshatter(M)
	qdel(src)

/obj/item/managerbullet/attack_self(mob/living/carbon/user) //shields from basegame are Physical Intervention Shield, Trauma Shield, Erosion Shield, Pale Shield
	user.visible_message(span_notice("[user] smashes [src] against their chest."))
	playsound(get_turf(user), 'sound/effects/pop_expl.ogg', 5, 0, 3)
	bulletshatter(user)
	qdel(src)

/obj/item/managerbullet/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(isliving(hit_atom))
		var/mob/living/M = hit_atom
		playsound(get_turf(M), 'sound/effects/pop_expl.ogg', 5, 0, 3)
		bulletshatter(M)
		qdel(src)
	..()

/obj/item/managerbullet/proc/bulletshatter(mob/living/L) //apply effect slot
	return


/datum/status_effect/interventionshield
	id = "physical intervention shield"
	duration = 15 SECONDS
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null
	var/inherentarmorcheck
	var/statuseffectvisual = icon('ModularTegustation/Teguicons/tegu_effects.dmi', "red_shield")
	var/shieldhealth = 100
	var/damagetaken = 0
	var/respectivedamage = RED_DAMAGE
	var/faltering = 0

/datum/status_effect/interventionshield/on_apply()
	. = ..()
	shieldhealth = GetFacilityUpgradeValue(UPGRADE_BULLET_SHIELD_HEALTH)
	owner.add_overlay(statuseffectvisual)
	owner.visible_message(span_notice("[owner]s shield activates!"))
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, PROC_REF(OnApplyDamage)) //stolen from caluan
	RegisterSignal(owner, COMSIG_WORK_STARTED, PROC_REF(Destroy))

/datum/status_effect/interventionshield/proc/OnApplyDamage(datum_source, amount, damagetype, def_zone)
	SIGNAL_HANDLER
	if(damagetype != respectivedamage)
		return

	var/mob/living/carbon/human/H = owner
	var/suitarmor = H.getarmor(null, respectivedamage) / 100
	damagetaken = amount * (1 - suitarmor)
	if(damagetaken <= 0)
		return

	if(damagetaken <= shieldhealth)
		shieldhealth = shieldhealth - damagetaken
		amount = 0
		var/shielddiagnostics = shieldhealth / 100
		if(shielddiagnostics < 0.95 && faltering != 1)
			faltering = 1
		return COMPONENT_MOB_DENY_DAMAGE // This return value completely negates the apply_damage proc
	if(damagetaken >= shieldhealth && faltering != 1) //When you prep a shield before a big attack.
		amount = 0
		owner.visible_message(span_warning("The shield around [owner] focuses all its energy on absorbing the damage."))
		duration = 1 SECONDS
		return COMPONENT_MOB_DENY_DAMAGE
	qdel(src)
	return

/datum/status_effect/interventionshield/be_replaced()
	playsound(get_turf(owner), 'sound/effects/glassbr1.ogg', 50, 0, 10)
	return ..()

/datum/status_effect/interventionshield/on_remove()
	owner.cut_overlay(statuseffectvisual)
	owner.visible_message(span_warning("The shield around [owner] shatters!"))
	playsound(get_turf(owner), 'sound/effects/glassbr1.ogg', 50, 0, 10)
	UnregisterSignal(owner, COMSIG_MOB_APPLY_DAMGE)
	UnregisterSignal(owner, COMSIG_WORK_STARTED)
	return ..()

/datum/status_effect/interventionshield/white
	id = "trauma shield"
	statuseffectvisual = icon('ModularTegustation/Teguicons/tegu_effects.dmi', "white_shield")
	respectivedamage = WHITE_DAMAGE

/datum/status_effect/interventionshield/black
	id = "erosion shield"
	statuseffectvisual = icon('ModularTegustation/Teguicons/tegu_effects.dmi', "black_shield")
	respectivedamage = BLACK_DAMAGE

/datum/status_effect/interventionshield/pale
	id = "pale shield"
	statuseffectvisual = icon('ModularTegustation/Teguicons/tegu_effects.dmi', "pale_shield")
	respectivedamage = PALE_DAMAGE

	//other bullets
/obj/item/managerbullet/red
	name = "red manager bullet"
	desc = "A bullet used in a manager console."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "sleeper-live"
	color = "red"

/obj/item/managerbullet/red/bulletshatter(mob/living/L)
	if(!ishuman(L))
		return
	L.apply_status_effect(/datum/status_effect/interventionshield)

/obj/item/managerbullet/white
	name = "white manager bullet"
	desc = "A bullet used in a manager console."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "sleeper-live"
	color = "grey"

/obj/item/managerbullet/white/bulletshatter(mob/living/L)
	if(!ishuman(L))
		return
	L.apply_status_effect(/datum/status_effect/interventionshield/white)

/obj/item/managerbullet/black
	name = "black manager bullet"
	desc = "A bullet used in a manager console."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "sleeper-live"
	color = "black"

/obj/item/managerbullet/black/bulletshatter(mob/living/L)
	if(!ishuman(L))
		return
	L.apply_status_effect(/datum/status_effect/interventionshield/black)

/obj/item/managerbullet/pale
	name = "pale manager bullet"
	desc = "A bullet used in a manager console."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "sleeper-live"
	color = "blue"

/obj/item/managerbullet/pale/bulletshatter(mob/living/L)
	if(!ishuman(L))
		return
	L.apply_status_effect(/datum/status_effect/interventionshield/pale)

/obj/item/managerbullet/slowdown
	name = "yellow manager bullet"
	desc = "A bullet used in a manager console."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "sleeper-live"
	color = "yellow"

/obj/item/managerbullet/slowdown/bulletshatter(mob/living/L)
	L.apply_status_effect(/datum/status_effect/qliphothoverload)
