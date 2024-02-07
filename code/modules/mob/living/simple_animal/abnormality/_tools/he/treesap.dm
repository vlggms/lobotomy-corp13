#define STATUS_EFFECT_TREESAP /datum/status_effect/treesap
#define STATUS_EFFECT_BOOMSAP /datum/status_effect/boomsap
/obj/structure/toolabnormality/treesap
	name = "giant tree sap"
	desc = "A small bottle of red liquid."
	icon_state = "treesap"
	var/list/used = list()

/obj/structure/toolabnormality/treesap/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(reset)), 20 MINUTES)

/obj/structure/toolabnormality/treesap/proc/reset()
	addtimer(CALLBACK(src, PROC_REF(reset)), 20 MINUTES)
	used = list()

	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		to_chat(L, span_danger("The Tree Sap is replenished."))

/obj/structure/toolabnormality/treesap/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(!do_after(user, 6, src))
		return
	to_chat(user, span_danger("You sip of the sap."))

	if(user in used)
		if(prob(20))
			user.apply_status_effect(STATUS_EFFECT_BOOMSAP)
		else
			user.apply_status_effect(STATUS_EFFECT_TREESAP)
	else
		used+=user
		user.apply_status_effect(STATUS_EFFECT_TREESAP)


// Status Effect
/datum/status_effect/treesap
	id = "treesap"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 60 SECONDS
	alert_type = null

/datum/status_effect/treesap/tick()
	. = ..()
	owner.adjustBruteLoss(-12) // Heals 10 HP per tick in LC, so this really should be 20


// Status Effect
/datum/status_effect/boomsap
	id = "boomsap"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 20 SECONDS
	alert_type = null

/datum/status_effect/boomsap/tick()
	. = ..()
	owner.adjustBruteLoss(-12) // Heals 10 HP per tick in LC, so this really should be 20

/datum/status_effect/boomsap/on_remove()
	. = ..()
	owner.gib()
	for(var/mob/living/carbon/human/L in livinginrange(10, src))
		L.apply_damage((60), WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
		to_chat(L, span_danger("Oh god, what the fuck was that!?"))

#undef STATUS_EFFECT_TREESAP
#undef STATUS_EFFECT_BOOMSAP
