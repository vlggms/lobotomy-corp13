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
#define STATUS_EFFECT_FORTITUDE /datum/status_effect/ncorp/fortitude
#define STATUS_EFFECT_PRUDENCE /datum/status_effect/ncorp/prudence
#define STATUS_EFFECT_TEMPERANCE /datum/status_effect/ncorp/temperance
#define STATUS_EFFECT_JUSTICE /datum/status_effect/ncorp/justice

/atom/movable/screen/alert/status_effect/ncorp
	name = "N-Corp Fading Ampules"
	desc = "Your attributes are temporarily buffed."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "bg_template"

/datum/status_effect/ncorp
	id = "ncorptemp"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 3000		//Lasts 5 minutes
	alert_type = /atom/movable/screen/alert/status_effect/ncorp
	var/attribute_buff = FORTITUDE_ATTRIBUTE

/datum/status_effect/ncorp/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.adjust_attribute_buff(attribute_buff, 15)

/datum/status_effect/ncorp/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.adjust_attribute_buff(attribute_buff, -15)

/datum/status_effect/ncorp/fortitude

/datum/status_effect/ncorp/prudence
	attribute_buff = PRUDENCE_ATTRIBUTE

/datum/status_effect/ncorp/temperance
	attribute_buff = TEMPERANCE_ATTRIBUTE

/datum/status_effect/ncorp/justice
	attribute_buff = JUSTICE_ATTRIBUTE

/obj/item/attribute_temporary/justicesmall
	name = "ncorp small fading justice accelerator"
	desc = "A fluid used to increase the user's justice temporarily. Use in hand to activate."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "tcorp_syringe"

/obj/item/attribute_temporary/justicesmall/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("You suddenly feel different."))
	user.apply_status_effect(STATUS_EFFECT_JUSTICE)
	qdel(src)

/obj/item/attribute_temporary/temperancesmall
	name = "ncorp small fading temperance  accelerator"
	desc = "A fluid used to increase the user's temperance temporarily. Use in hand to activate."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "tcorp_syringe"

/obj/item/attribute_temporary/temperancesmall/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("You suddenly feel different."))
	user.apply_status_effect(STATUS_EFFECT_TEMPERANCE)
	qdel(src)

/obj/item/attribute_temporary/fortitudesmall
	name = "ncorp small fading fortitude accelerator"
	desc = "A fluid used to increase the user's fortitude temporarily. Use in hand to activate."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "tcorp_syringe"

/obj/item/attribute_temporary/fortitudesmall/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("You suddenly feel different."))
	user.apply_status_effect(STATUS_EFFECT_FORTITUDE)
	qdel(src)

/obj/item/attribute_temporary/prudencesmall
	name = "ncorp small fading prudence accelerator"
	desc = "A fluid used to increase the user's prudence temporarily. Use in hand to activate."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "tcorp_syringe"

/obj/item/attribute_temporary/prudencesmall/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("You suddenly feel different."))
	user.apply_status_effect(STATUS_EFFECT_PRUDENCE)
	qdel(src)

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
	id = "nstats"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/ncorp
	duration = 1200

/datum/status_effect/nstats/on_apply()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 15)
	H.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 15)
	H.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 15)
	H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 15)

/datum/status_effect/nstats/on_remove()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -15)
	H.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -15)
	H.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -15)
	H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -15)

//Focused Ncorp ampules
#define STATUS_EFFECT_FORTITUDE_FOCUS /datum/status_effect/nfocus/fortitude
#define STATUS_EFFECT_PRUDENCE_FOCUS /datum/status_effect/nfocus/prudence
#define STATUS_EFFECT_TEMPERANCE_FOCUS /datum/status_effect/nfocus/temperance
#define STATUS_EFFECT_JUSTICE_FOCUS /datum/status_effect/nfocus/justice

/datum/status_effect/nfocus
	id = "nfocus"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 3000		//Lasts 5 minutes
	alert_type = /atom/movable/screen/alert/status_effect/ncorp
	var/attribute_buff = FORTITUDE_ATTRIBUTE

/datum/status_effect/ncorp/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.adjust_attribute_buff(attribute_buff, 20)

/datum/status_effect/ncorp/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		L.adjust_attribute_buff(attribute_buff, -20)

/datum/status_effect/nfocus/fortitude

/datum/status_effect/nfocus/prudence
	attribute_buff = PRUDENCE_ATTRIBUTE

/datum/status_effect/nfocus/temperance
	attribute_buff = TEMPERANCE_ATTRIBUTE

/datum/status_effect/nfocus/justice
	attribute_buff = JUSTICE_ATTRIBUTE

/obj/item/attribute_temporary/justicebig
	name = "ncorp large fading justice accelerator"
	desc = "A fluid used to increase the user's justice temporarily. Use in hand to activate."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "ncorp_syringe3"

/obj/item/attribute_temporary/justicebig/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("You suddenly feel different."))
	user.apply_status_effect(STATUS_EFFECT_JUSTICE_FOCUS)
	qdel(src)

/obj/item/attribute_temporary/temperancebig
	name = "ncorp large fading temperance  accelerator"
	desc = "A fluid used to increase the user's temperance temporarily. Use in hand to activate."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "ncorp_syringe3"

/obj/item/attribute_temporary/temperancebig/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("You suddenly feel different."))
	user.apply_status_effect(STATUS_EFFECT_TEMPERANCE_FOCUS)
	qdel(src)

/obj/item/attribute_temporary/fortitudebig
	name = "ncorp large fading fortitude accelerator"
	desc = "A fluid used to increase the user's fortitude temporarily. Use in hand to activate."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "ncorp_syringe3"

/obj/item/attribute_temporary/fortitudebig/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("You suddenly feel different."))
	user.apply_status_effect(STATUS_EFFECT_FORTITUDE_FOCUS)
	qdel(src)

/obj/item/attribute_temporary/prudencebig
	name = "ncorp large fading prudence accelerator"
	desc = "A fluid used to increase the user's prudence temporarily. Use in hand to activate."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "ncorp_syringe3"

/obj/item/attribute_temporary/prudencebig/attack_self(mob/living/carbon/human/user)
	to_chat(user, span_nicegreen("You suddenly feel different."))
	user.apply_status_effect(STATUS_EFFECT_PRUDENCE_FOCUS)
	qdel(src)

