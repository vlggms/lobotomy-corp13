///////////
// PANIC //
///////////
// All Panic VFX
/datum/status_effect/panicked
	id = "panicked"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 18
	alert_type = null

/datum/status_effect/panicked/on_apply()
	. = ..()
	owner.add_overlay(mutable_appearance('icons/effects/32x64.dmi', "panicked", -ABOVE_MOB_LAYER))

/datum/status_effect/panicked/on_remove()
	. = ..()
	owner.cut_overlay(mutable_appearance('icons/effects/32x64.dmi', "panicked", -ABOVE_MOB_LAYER))


/datum/status_effect/panicked_lvl_0
	id = "calm"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 20
	alert_type = null

/datum/status_effect/panicked_lvl_0/on_apply()
	. = ..()
	owner.add_overlay(mutable_appearance('icons/effects/32x64.dmi', "calm", -ABOVE_MOB_LAYER))

/datum/status_effect/panicked_lvl_0/on_remove()
	. = ..()
	owner.cut_overlay(mutable_appearance('icons/effects/32x64.dmi', "calm", -ABOVE_MOB_LAYER))


/datum/status_effect/panicked_lvl_1
	id = "nervous"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 20
	alert_type = null

/datum/status_effect/panicked_lvl_1/on_apply()
	. = ..()
	owner.add_overlay(mutable_appearance('icons/effects/32x64.dmi', "nervous", -ABOVE_MOB_LAYER))

/datum/status_effect/panicked_lvl_1/on_remove()
	. = ..()
	owner.cut_overlay(mutable_appearance('icons/effects/32x64.dmi', "nervous", -ABOVE_MOB_LAYER))


/datum/status_effect/panicked_lvl_2
	id = "terrified"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 20
	alert_type = null

/datum/status_effect/panicked_lvl_2/on_apply()
	. = ..()
	owner.add_overlay(mutable_appearance('icons/effects/32x64.dmi', "terrified", -ABOVE_MOB_LAYER))

/datum/status_effect/panicked_lvl_2/on_remove()
	. = ..()
	owner.cut_overlay(mutable_appearance('icons/effects/32x64.dmi', "terrified", -ABOVE_MOB_LAYER))


/datum/status_effect/panicked_lvl_3
	id = "hopeless"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 20
	alert_type = null

/datum/status_effect/panicked_lvl_3/on_apply()
	. = ..()
	owner.add_overlay(mutable_appearance('icons/effects/32x64.dmi', "hopeless", -ABOVE_MOB_LAYER))

/datum/status_effect/panicked_lvl_3/on_remove()
	. = ..()
	owner.cut_overlay(mutable_appearance('icons/effects/32x64.dmi', "hopeless", -ABOVE_MOB_LAYER))


/datum/status_effect/panicked_lvl_4
	id = "overwhelmed"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 20
	alert_type = null

/datum/status_effect/panicked_lvl_4/on_apply()
	. = ..()
	owner.add_overlay(mutable_appearance('icons/effects/32x64.dmi', "overwhelmed", -ABOVE_MOB_LAYER))

/datum/status_effect/panicked_lvl_4/on_remove()
	. = ..()
	owner.cut_overlay(mutable_appearance('icons/effects/32x64.dmi', "overwhelmed", -ABOVE_MOB_LAYER))


/datum/status_effect/panicked_lvl_5
	id = "reverence"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 20
	alert_type = null

/datum/status_effect/panicked_lvl_5/on_apply()
	. = ..()
	owner.add_overlay(mutable_appearance('icons/effects/32x64.dmi', "reverence", -ABOVE_MOB_LAYER))

/datum/status_effect/panicked_lvl_5/on_remove()
	. = ..()
	owner.cut_overlay(mutable_appearance('icons/effects/32x64.dmi', "reverence", -ABOVE_MOB_LAYER))


/datum/status_effect/panicked_type
	id = "panic_state_base"
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null
	var/icon = "berserk"

/datum/status_effect/panicked_type/on_apply()
	. = ..()
	owner.add_overlay(mutable_appearance('icons/effects/effects.dmi', icon, -ABOVE_MOB_LAYER))

/datum/status_effect/panicked_type/on_remove()
	. = ..()
	owner.cut_overlay(mutable_appearance('icons/effects/effects.dmi', icon, -ABOVE_MOB_LAYER))

/datum/status_effect/panicked_type/be_replaced()
	. = ..()
	owner.cut_overlay(mutable_appearance('icons/effects/effects.dmi', icon, -ABOVE_MOB_LAYER))

/datum/status_effect/panicked_type/murder
	icon = "murder"

/datum/status_effect/panicked_type/suicide
	icon = "suicide"

/datum/status_effect/panicked_type/wander
	icon = "wander"

/datum/status_effect/panicked_type/release
	icon = "breach"
