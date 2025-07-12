/obj/item/skill_core
	name = "skill core"
	desc = "A crystallized essence of combat technique. Use it on a workshop attachment or necklace to imbue it with power."
	icon = 'ModularTegustation/Teguicons/workshop.dmi'
	icon_state = "blankcore"
	w_class = WEIGHT_CLASS_SMALL
	color = "#FFFFFF"
	var/skill_type = null
	var/skill_name = "unknown"
	var/skill_level = 1

/obj/item/skill_core/Initialize()
	. = ..()
	update_name()
	update_desc()

/obj/item/skill_core/proc/update_name()
	name = "[skill_name] core"

/obj/item/skill_core/proc/update_desc()
	desc = "A crystallized essence of [skill_name]. Level [skill_level] technique. Use it on a workshop attachment or necklace to imbue it with power."

/obj/item/skill_core/bleed
	skill_name = "bleed"
	color = "#8B0000"

/obj/item/skill_core/bleed/lacerate
	skill_type = /datum/action/cooldown/bleed/lacerate
	skill_name = "lacerate"
	skill_level = 1

/obj/item/skill_core/bleed/sanguine_chain
	skill_type = /datum/action/cooldown/bleed/sanguine_chain
	skill_name = "sanguine chain"
	skill_level = 1

/obj/item/skill_core/bleed/bloodletting_strike
	skill_type = /datum/action/cooldown/bleed/bloodletting_strike
	skill_name = "bloodletting strike"
	skill_level = 1

/obj/item/skill_core/bleed/sanguine_feast
	skill_type = /datum/action/cooldown/bleed/sanguine_feast
	skill_name = "sanguine feast"
	skill_level = 1

/obj/item/skill_core/bleed/blood_pool
	skill_type = /datum/action/cooldown/bleed/blood_pool
	skill_name = "blood pool"
	skill_level = 1

/obj/item/skill_core/bleed/crimson_repulsion
	skill_type = /datum/action/cooldown/bleed/crimson_repulsion
	skill_name = "crimson repulsion"
	skill_level = 1

/obj/item/skill_core/bleed/hemorrhage
	skill_type = /datum/action/cooldown/skill/hemorrhage
	skill_name = "hemorrhage"
	skill_level = 2

/obj/item/skill_core/bleed/crimson_cleave
	skill_type = /datum/action/cooldown/skill/crimson_cleave
	skill_name = "crimson cleave"
	skill_level = 2

/obj/item/skill_core/bleed/blood_spike
	skill_type = /datum/action/cooldown/skill/blood_spike
	skill_name = "blood spike"
	skill_level = 2

/obj/item/skill_core/overheat
	skill_name = "overheat"
	color = "#FF4500"

/obj/item/skill_core/overheat/heat_transfer
	skill_type = /datum/action/cooldown/skill/heat_transfer
	skill_name = "heat transfer"
	skill_level = 1

/obj/item/skill_core/overheat/ignition_burst
	skill_type = /datum/action/cooldown/skill/ignition_burst
	skill_name = "ignition burst"
	skill_level = 1

/obj/item/skill_core/overheat/flame_lance
	skill_type = /datum/action/cooldown/skill/flame_lance
	skill_name = "flame lance"
	skill_level = 1

/obj/item/skill_core/overheat/cauterize
	skill_type = /datum/action/cooldown/skill/cauterize
	skill_name = "cauterize"
	skill_level = 1

/obj/item/skill_core/overheat/spreading_ashes
	skill_type = /datum/action/cooldown/skill/spreading_ashes
	skill_name = "spreading ashes"
	skill_level = 1

/obj/item/skill_core/overheat/feeding_embers
	skill_type = /datum/action/cooldown/skill/feeding_embers
	skill_name = "feeding embers"
	skill_level = 1

/obj/item/skill_core/overheat/thermal_detonation
	skill_type = /datum/action/cooldown/skill/overheat_detonation
	skill_name = "thermal detonation"
	skill_level = 2

/obj/item/skill_core/overheat/molten_strike
	skill_type = /datum/action/cooldown/skill/molten_strike
	skill_name = "molten strike"
	skill_level = 2

/obj/item/skill_core/overheat/inferno_dash
	skill_type = /datum/action/cooldown/skill/inferno_dash
	skill_name = "inferno dash"
	skill_level = 2

/obj/item/skill_core/tremor
	skill_name = "tremor"
	color = "#8B4513"

/obj/item/skill_core/tremor/aftershock
	skill_type = /datum/action/cooldown/skill/aftershock
	skill_name = "aftershock"
	skill_level = 1

/obj/item/skill_core/tremor/seismic_wave
	skill_type = /datum/action/cooldown/skill/seismic_wave
	skill_name = "seismic wave"
	skill_level = 1

/obj/item/skill_core/tremor/shattered_resentment
	skill_type = /datum/action/cooldown/skill/shattered_resentment
	skill_name = "shattered resentment"
	skill_level = 1

/obj/item/skill_core/tremor/stabilizing_stance
	skill_type = /datum/action/cooldown/skill/stabilizing_stance
	skill_name = "stabilizing stance"
	skill_level = 1

/obj/item/skill_core/tremor/tectonic_shift
	skill_type = /datum/action/cooldown/skill/tectonic_shift
	skill_name = "tectonic shift"
	skill_level = 1

/obj/item/skill_core/tremor/repelling_motion
	skill_type = /datum/action/cooldown/skill/repelling_motion
	skill_name = "repelling motion"
	skill_level = 1

/obj/item/skill_core/tremor/seismic_slam
	skill_type = /datum/action/cooldown/skill/seismic_slam
	skill_name = "seismic slam"
	skill_level = 2

/obj/item/skill_core/tremor/resonant_strike
	skill_type = /datum/action/cooldown/skill/resonant_strike
	skill_name = "resonant strike"
	skill_level = 2

/obj/item/skill_core/tremor/earthbound_hammer
	skill_type = /datum/action/cooldown/skill/earthbound_hammer
	skill_name = "earthbound hammer"
	skill_level = 2
