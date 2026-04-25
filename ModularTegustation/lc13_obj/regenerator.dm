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
	var/regeneration_amount = 12
	/// Pre-declared variable
	var/modified = FALSE // Whether or not the regenerator is currently undergoing modified action
	var/threat_detected = FALSE
	var/hp_bonus = 0
	var/sp_bonus = 0
	var/progress = 0 // How close we are to healing everyone
	var/critical_heal = FALSE // Whether it heals people who are in critical condition (sanity loss/health loss)
	var/rapid = FALSE // Set to heal in small bursts
	var/disabled = FALSE
	var/short_duration = 2 MINUTES
	var/long_duration = 4 MINUTES
	var/reset_timer = 0
	var/colored_overlay
	var/area = null

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
		modified = FALSE
		hp_bonus = 0
		sp_bonus = 0
		critical_heal = FALSE
		cut_overlays()
		disabled = FALSE
	if(disabled)
		icon_state = broken_icon
		cut_overlays()
		return
	var/area/A = get_area(src)
	if(!istype(A))
		return
	threat_detected = FALSE
	for(var/key, value in A.area_living)
		// We assume that any simple_mob/hostile is, in fact, hostile. (If you do not want your super friendly simplemob/hostile to block regenerators, assign a different area_index var to your mob (code\__DEFINES\areas.dm))
		// This also includes composite indexes that include the hostile or abnormality index.
		if(!threat_detected && (key & (MOB_HOSTILE_INDEX | MOB_ABNORMALITY_INDEX)))
			icon_state = alert_icon
			threat_detected = TRUE
			break

	progress++

	var/max_progress = rapid ? 1 : 5
	if(progress >= max_progress)
		progress = 0
		Heal(A)

	if(icon_state != "regen" && !threat_detected)
		icon_state = initial(icon_state)

/obj/machinery/regenerator/proc/Heal(area/A)
	var/list/people_to_heal
	for(var/key, value in A.area_living)
		if(key & MOB_HUMAN_INDEX)
			for(var/mob/living/carbon/human/bro in value)
				if(((bro.health <= 0) && !critical_heal) || bro.is_working)
					continue
				LAZYADD(people_to_heal, bro)

	if(LAZYLEN(people_to_heal))
		// The math is weird, but it is intentional. Feel free to change it, but be careful as mults on top of base heal increases go wild quick.
		var/regen_amt = regeneration_amount + GetFacilityUpgradeValue(UPGRADE_REGENERATOR_HEALING)
		var/regen_mult = rapid ? 0.2 : 1
		if(threat_detected)
			regen_mult *= 0.5
		var/hp_amt = (regen_amt + hp_bonus) * regen_mult
		var/sp_amt = (regen_amt + sp_bonus) * regen_mult
		for(var/mob/living/carbon/human/dude as anything in people_to_heal)
			dude.adjustBruteLoss(-hp_amt)
			dude.adjustFireLoss(0.2 * -hp_amt)	//Heals at 1/5th speed. Supposed to be slower healing than brute and sanity
			dude.adjustSanityLoss(-sp_amt)

/obj/machinery/regenerator/examine(mob/user)
	. = ..()
	var/regen_add = GetFacilityUpgradeValue(UPGRADE_REGENERATOR_HEALING)
	var/regen_mult = rapid ? 0.2 : 1
	var/time = rapid ? 2 : 10
	if(threat_detected)
		regen_mult *= 0.5
		. += span_danger("WARNING: Threat Detected. Healing is halved!")
	. += span_info("[src] restores [(regeneration_amount+hp_bonus+regen_add)* regen_mult] HP and [(regeneration_amount+sp_bonus+regen_add)* regen_mult] SP every [time] seconds.")

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
	hp_bonus = 6
	sp_bonus = -3
	reset_timer = long_duration + world.time
	ProduceIcon("#B90E0A", "regenspores") //Crimson

/obj/machinery/regenerator/proc/SpFocus(mob/living/user)
	if(user)
		to_chat(user, span_notice("[src] is now calibrated to restore dramatically more SP but less HP."))
	hp_bonus = -3
	sp_bonus = 6
	reset_timer = long_duration + world.time
	ProduceIcon("#4ADED", "regenpuffs_heavy") //Teal

/obj/machinery/regenerator/proc/EqualFocus(mob/living/user)
	if(user)
		to_chat(user, span_notice("[src] is now calibrated to restore slightly more HP and SP."))
	hp_bonus = 2
	sp_bonus = 2
	reset_timer = short_duration + world.time
	add_overlay("blueregenlight")
	add_overlay(mutable_appearance('icons/effects/atmospherics.dmi', "miasma_old"))
	ProduceIcon("#AF69EE", "regenpuffs") //Orchid
	ProduceIcon("#B90E0A", "regenspores") //Crimson

/obj/machinery/regenerator/proc/CriticalFocus(mob/living/user)
	if(user)
		to_chat(user, span_notice("[src] is now calibrated to also heal people in critical conditions but at a lower rate."))
	critical_heal = TRUE
	hp_bonus = -3
	reset_timer = short_duration + world.time
	add_overlay("redregenlight")
	ProduceIcon("#E30B5D", "regenspores") //Raspberry

/obj/machinery/regenerator/proc/RapidHeal(mob/living/user)
	if(user)
		to_chat(user, span_notice("[src] is now calibrated to heal more often but restore dramatically less SP and HP."))
	reset_timer = short_duration + world.time
	ProduceIcon("#800000", "regenpuffs_heavy") //Maroon
	ProduceIcon("#B90E0A", "regenspores_heavy") //Crimson

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
