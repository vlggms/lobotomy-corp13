/obj/machinery/regenerator
	name = "regenerator"
	desc = "A machine responsible for slowly restoring the health and sanity of employees in the area."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "regen"
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	layer = ABOVE_OBJ_LAYER //So people dont stand ontop of it when above it

	//Icon States
	var/broken_icon = "regen_dull"
	var/alert_icon = "regen_alert"

	/// How many HP and SP we restore on each process tick
	var/regeneration_amount = 3
	/// Pre-declared variable
	var/modified = FALSE // Whether or not the regenerator is currently undergoing modified action
	var/hp_bonus = 0
	var/sp_bonus = 0
	var/critical_heal = FALSE // Whether it heals people who are in critical condition (sanity loss/health loss)
	var/burst = FALSE // Set to heal in a large burst
	var/burst_cooldown = FALSE // Whether it's operational due to Burst Cooldown
	var/short_duration = 30 SECONDS
	var/long_duration = 60 SECONDS
	var/reset_timer = 0
	var/colored_overlay

/obj/machinery/regenerator/Initialize()
	. = ..()
	GLOB.lobotomy_devices += src
	flags_1 |= NODECONSTRUCT_1

/obj/machinery/regenerator/Destroy()
	GLOB.lobotomy_devices -= src
	..()

/obj/machinery/regenerator/process()
	..()
	if(reset_timer <= world.time)
		burst_cooldown = FALSE
		modified = FALSE
		hp_bonus = 0
		sp_bonus = 0
		critical_heal = FALSE
		cut_overlays()
	if(burst_cooldown)
		icon_state = broken_icon
		cut_overlays()
		return
	var/area/A = get_area(src)
	if(!istype(A))
		return
	var/threat = FALSE
	var/regen_amt = regeneration_amount
	var/regen_mult = 1
	var/regen_add = GetFacilityUpgradeValue(UPGRADE_REGENERATOR_HEALING)
	if(burst)
		regen_mult *= 7.5
		burst = FALSE
		burst_cooldown = TRUE
		reset_timer = short_duration + world.time
	var/list/people_to_heal
	for(var/key, value in A.area_living)
		if(key & MOB_HUMAN_INDEX)
			for(var/mob/living/carbon/human/bro in value)
				if((bro.sanity_lost || bro.health < 0) && !critical_heal)
					continue
				LAZYADD(people_to_heal, bro)
		// We assume that any simple_mob/hostile is, in fact, hostile. (If you do not want your super friendly simplemob/hostile to block regenerators, assign a different area_index var to your mob (code\__DEFINES\areas.dm))
		// This also includes composite indexes that include the hostile or abnormality index.
		if(!threat && (key & (MOB_HOSTILE_INDEX | MOB_ABNORMALITY_INDEX)))
			regen_mult *= 0.5
			icon_state = alert_icon
			threat = TRUE
	if(icon_state != "regen" && !threat)
		icon_state = initial(icon_state)

	if(LAZYLEN(people_to_heal))
		// The math is weird, but it is intentional. Feel free to change it, but be careful as mults on top of base heal increases go wild quick.
		var/hp_amt = ((regen_amt * regen_mult) + regen_add) + hp_bonus
		var/sp_amt = ((regen_amt * regen_mult) + regen_add) + sp_bonus
		new/obj/effect/temp_visual/health(get_turf(src), hp_amt)
		new/obj/effect/temp_visual/health/sanity(get_turf(src), sp_amt)
		for(var/mob/living/carbon/human/dude as anything in people_to_heal)
			dude.adjustBruteLoss(-dude.maxHealth * (hp_amt/100))
			dude.adjustFireLoss(0.1 * (-dude.maxHealth * (hp_amt/100)))	//Heals at 1/10th speed. Supposed to be slower healing than brute and sanity
			dude.adjustSanityLoss(-dude.maxSanity * (sp_amt/100))

/obj/machinery/regenerator/examine(mob/user)
	. = ..()
	if(burst_cooldown)
		. += span_warning("[src] is currently offline!")
		return
	. += span_info("[src] restores [regeneration_amount+hp_bonus+GetFacilityUpgradeValue(UPGRADE_REGENERATOR_HEALING)]% HP and [regeneration_amount+sp_bonus+GetFacilityUpgradeValue(UPGRADE_REGENERATOR_HEALING)]% SP every 2 seconds.")

/obj/machinery/regenerator/proc/ProduceIcon(Icon_Color, Type) //Used to be called ProduceGas but due to me using it for a button i had to change it. ProduceGas was a cooler name. -IP
	var/mutable_appearance/colored_overlay = mutable_appearance(icon, Type)
	colored_overlay.color = Icon_Color
	add_overlay(colored_overlay)

/*----------------\
|Regenerator Modes|
\----------------*/
/obj/machinery/regenerator/proc/HpFocus(mob/living/user)
	if(user)
		to_chat(user, span_notice("[src] is now calibrated to restore dramatically more HP but less SP."))
	hp_bonus = 3
	sp_bonus = -1
	reset_timer = long_duration + world.time
	ProduceIcon("#B90E0A", "regenspores") //Crimson

/obj/machinery/regenerator/proc/SpFocus(mob/living/user)
	if(user)
		to_chat(user, span_notice("[src] is now calibrated to restore dramatically more SP but less HP."))
	hp_bonus = -1
	sp_bonus = 3
	reset_timer = long_duration + world.time
	ProduceIcon("#4ADED", "regenpuffs_heavy") //Teal

/obj/machinery/regenerator/proc/EqualFocus(mob/living/user)
	if(user)
		to_chat(user, span_notice("[src] is now calibrated to restore slightly more HP and SP."))
	hp_bonus = 1
	sp_bonus = 1
	reset_timer = short_duration + world.time
	add_overlay("blueregenlight")
	add_overlay(mutable_appearance('icons/effects/atmospherics.dmi', "miasma_old"))
	ProduceIcon("#AF69EE", "regenpuffs") //Orchid
	ProduceIcon("#B90E0A", "regenspores") //Crimson

/obj/machinery/regenerator/proc/CriticalFocus(mob/living/user)
	if(user)
		to_chat(user, span_notice("[src] is now calibrated to also heal people in critical conditions but at a lower rate."))
	critical_heal = TRUE
	hp_bonus = -1
	sp_bonus = -1
	reset_timer = short_duration + world.time
	add_overlay("redregenlight")
	ProduceIcon("#E30B5D", "regenspores") //Raspberry

/obj/machinery/regenerator/proc/OverloadHeal(mob/living/user)
	if(user)
		to_chat(user, span_warning("You overload [src]’s sensors, causing [src] to rapidly discharge its resources!"))
	burst = TRUE
	ProduceIcon("#800000", "regenpuffs_heavy") //Maroon
	ProduceIcon("#B90E0A", "regenspores_heavy") //Crimson
	// No Timer as it's an "instant" effect. Also handles turning off over there

//Safety Plant Regenerator
/obj/machinery/regenerator/safety
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "regen"
	broken_icon = "regen_dull"
	alert_icon = "regen_alert"
	layer = ABOVE_OBJ_LAYER //So people dont stand ontop of it when above it

//Don't add tutorial regenerators to global list, prevents them from being affected by Safety suppression
/obj/machinery/regenerator/tutorial

/obj/machinery/regenerator/tutorial/Initialize()
	. = ..()
	GLOB.lobotomy_devices -= src
