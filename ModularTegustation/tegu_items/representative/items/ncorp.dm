//Ncorp levelers
/obj/item/attribute_increase
	name = "training accelerator"
	desc = "A fluid used to increase the user's stats. Use in hand to activate."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "tcorp_syringe"
	var/amount = 1

/obj/item/attribute_increase/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("You suddenly feel different."))
	user.adjust_all_attribute_levels(amount)
	qdel(src)


/obj/item/attribute_increase/small
	name = "ncorp small training accelerator"
	icon_state = "ncorp_syringe1"
	amount = 3

/obj/item/attribute_increase/medium
	name = "ncorp medium training accelerator"
	icon_state = "ncorp_syringe2"
	amount = 5

/obj/item/attribute_increase/large
	name = "ncorp large training accelerator"
	icon_state = "ncorp_syringe3"
	amount = 10

/obj/item/attribute_increase/xtralarge
	name = "ncorp extra large training accelerator"
	icon_state = "ncorp_syringe4"
	amount = 20

//Limit increaser
/obj/item/limit_increase
	name = "ncorp limit breaker"
	desc = "A fluid used to increase an agent's maximum potential. Use in hand to activate."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "ncorp_syringe5"
	var/amount = 140
	var/list/allowed_roles = list()

/obj/item/limit_increase/Initialize()
	..()
	if(!LAZYLEN(allowed_roles))
		allowed_roles = GLOB.security_positions // defaults to agents.

/obj/item/limit_increase/attack_self(mob/living/carbon/human/user)
	if(user?.mind?.assigned_role in allowed_roles)
		to_chat(user, span_nicegreen("You feel like you can become even more powerful."))
		user.set_attribute_limit(amount)
		qdel(src)
		return
	to_chat(user, span_notice("This is not for you."))
	return

//Officer limit increase.
/obj/item/limit_increase/officer
	name = "officer limit breaker"
	desc = "A fluid used to increase the limit of L-Corp officer's potential. Use in hand to activate."
	icon_state = "oddity7_gween"
	amount = 80
	allowed_roles = list("Records Officer", "Extraction Officer")

//Temporary attributes
/obj/item/attribute_temporary/justicesmall
	name = "ncorp small fading justice accelerator"
	desc = "A fluid used to increase the user's justice temporarily. Use in hand to activate."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "tcorp_syringe"

/obj/item/attribute_temporary/justicesmall/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("You suddenly feel different."))
	user.apply_status_effect(/datum/status_effect/njustice)
	qdel(src)

/datum/status_effect/njustice
	id = "NJUSTICE"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/njustice
	duration = 300 SECONDS

/atom/movable/screen/alert/status_effect/njustice
	name = "N-Corp Experience"
	desc = "Increases justice by 15."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "bg_template"

/datum/status_effect/njustice/on_apply()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 15)

/datum/status_effect/njustice/on_remove()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -15)

/obj/item/attribute_temporary/temperancesmall
	name = "ncorp small fading temperance  accelerator"
	desc = "A fluid used to increase the user's temperance temporarily. Use in hand to activate."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "tcorp_syringe"

/obj/item/attribute_temporary/temperancesmall/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("You suddenly feel different."))
	user.apply_status_effect(/datum/status_effect/ntemperance)
	qdel(src)

/datum/status_effect/ntemperance
	id = "NTEMPERANCE"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/ntemperance
	duration = 300 SECONDS

/atom/movable/screen/alert/status_effect/ntemperance
	name = "N-Corp Experience"
	desc = "Increases temperance by 15."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "bg_template"

/datum/status_effect/ntemperance/on_apply()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 15)

/datum/status_effect/ntemperance/on_remove()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -15)

/obj/item/attribute_temporary/fortitudesmall
	name = "ncorp small fading fortitude accelerator"
	desc = "A fluid used to increase the user's fortitude temporarily. Use in hand to activate."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "tcorp_syringe"

/obj/item/attribute_temporary/fortitudesmall/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("You suddenly feel different."))
	user.apply_status_effect(/datum/status_effect/nfortitude)
	qdel(src)

/datum/status_effect/nfortitude
	id = "NFORTITUDE"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/nfortitude
	duration = 300 SECONDS

/atom/movable/screen/alert/status_effect/nfortitude
	name = "N-Corp Experience"
	desc = "Increases fortitude by 15."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "bg_template"

/datum/status_effect/nfortitude/on_apply()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 15)

/datum/status_effect/nfortitude/on_remove()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -15)

/obj/item/attribute_temporary/prudencesmall
	name = "ncorp small fading prudence accelerator"
	desc = "A fluid used to increase the user's prudence temporarily. Use in hand to activate."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "tcorp_syringe"

/obj/item/attribute_temporary/prudencesmall/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("You suddenly feel different."))
	user.apply_status_effect(/datum/status_effect/nprudence)
	qdel(src)

/datum/status_effect/nprudence
	id = "NPRUDENCE"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/nprudence
	duration = 300 SECONDS

/atom/movable/screen/alert/status_effect/nprudence
	name = "N-Corp Experience"
	desc = "Increases prudence by 15."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "bg_template"

/datum/status_effect/nprudence/on_apply()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 15)

/datum/status_effect/nprudence/on_remove()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -15)

//Generalized temporary ampules
/obj/item/attribute_temporary/stattemporary
	name = "ncorp medium fading accelerator"
	desc = "A fluid used to increase the user's stats temporarily. Use in hand to activate."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "ncorp_syringe2"

/obj/item/attribute_temporary/stattemporary/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("You suddenly feel different."))
	user.apply_status_effect(/datum/status_effect/nstats)
	qdel(src)

/datum/status_effect/nstats
	id = "NSTATS"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/nstats
	duration = 120 SECONDS

/atom/movable/screen/alert/status_effect/nstats
	name = "N-Corp Experience"
	desc = "Increases all stats by 15."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "bg_template"

/datum/status_effect/njustice/on_apply()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 15)
	H.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 15)
	H.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 15)
	H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 15)

/datum/status_effect/njustice/on_remove()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -15)
	H.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -15)
	H.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -15)
	H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -15)

/obj/item/attribute_temporary/justicebig
	name = "ncorp large fading justice accelerator"
	desc = "A fluid used to increase the user's justice temporarily. Use in hand to activate."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "ncorp_syringe3"

/obj/item/attribute_temporary/justicebig/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("You suddenly feel different."))
	user.apply_status_effect(/datum/status_effect/njusticebig)
	qdel(src)

/datum/status_effect/njusticebig
	id = "NJUSTICEBIG"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/njusticebig
	duration = 300 SECONDS

/atom/movable/screen/alert/status_effect/njusticebig
	name = "N-Corp Experience"
	desc = "Increases justice by 20."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "bg_template"

/datum/status_effect/njustice/on_apply()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 20)

/datum/status_effect/njustice/on_remove()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -20)

/obj/item/attribute_temporary/temperancebig
	name = "ncorp large fading temperance  accelerator"
	desc = "A fluid used to increase the user's temperance temporarily. Use in hand to activate."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "ncorp_syringe3"

/obj/item/attribute_temporary/temperancebig/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("You suddenly feel different."))
	user.apply_status_effect(/datum/status_effect/ntemperancebig)
	qdel(src)

/datum/status_effect/ntemperancebig
	id = "NTEMPERANCEBIG"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/ntemperancebig
	duration = 300 SECONDS

/atom/movable/screen/alert/status_effect/ntemperancebig
	name = "N-Corp Experience"
	desc = "Increases temperance by 20."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "bg_template"

/datum/status_effect/ntemperancebig/on_apply()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 20)

/datum/status_effect/ntemperancebig/on_remove()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -20)

/obj/item/attribute_temporary/fortitudebig
	name = "ncorp large fading fortitude accelerator"
	desc = "A fluid used to increase the user's fortitude temporarily. Use in hand to activate."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "ncorp_syringe3"

/obj/item/attribute_temporary/fortitudebig/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("You suddenly feel different."))
	user.apply_status_effect(/datum/status_effect/nfortitudebig)
	qdel(src)

/datum/status_effect/nfortitudebig
	id = "NFORTITUDEBIG"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/nfortitudebig
	duration = 300 SECONDS

/atom/movable/screen/alert/status_effect/nfortitudebig
	name = "N-Corp Experience"
	desc = "Increases fortitude by 20."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "bg_template"

/datum/status_effect/nfortitudebig/on_apply()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 20)

/datum/status_effect/nfortitudebig/on_remove()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -20)

/obj/item/attribute_temporary/prudencebig
	name = "ncorp large fading prudence accelerator"
	desc = "A fluid used to increase the user's prudence temporarily. Use in hand to activate."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "ncorp_syringe3"

/obj/item/attribute_temporary/prudencebig/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("You suddenly feel different."))
	user.apply_status_effect(/datum/status_effect/nprudencebig)
	qdel(src)

/datum/status_effect/nprudencebig
	id = "NPRUDENCEBIG"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/nprudencebig
	duration = 300 SECONDS

/atom/movable/screen/alert/status_effect/nprudencebig
	name = "N-Corp Experience"
	desc = "Increases prudence by 20."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "bg_template"

/datum/status_effect/nprudencebig/on_apply()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 20)

/datum/status_effect/nprudencebig/on_remove()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -20)

