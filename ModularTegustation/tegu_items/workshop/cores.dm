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

/obj/item/skill_core/bleed
	name = "bleed core"
	desc = "A crystallized essence of bleed. Use it on a workshop attachment or necklace to imbue it with power."
	skill_name = "bleed"
	color = "#8B0000"

/obj/item/skill_core/bleed/lacerate
	name = "lacerate core"
	desc = "A crystallized essence of lacerate. Level 1 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/bleed/lacerate
	skill_name = "lacerate"
	skill_level = 1

/obj/item/skill_core/bleed/sanguine_chain
	name = "sanguine chain core"
	desc = "A crystallized essence of sanguine chain. Level 1 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/bleed/sanguine_chain
	skill_name = "sanguine chain"
	skill_level = 1

/obj/item/skill_core/bleed/bloodletting_strike
	name = "bloodletting strike core"
	desc = "A crystallized essence of bloodletting strike. Level 1 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/bleed/bloodletting_strike
	skill_name = "bloodletting strike"
	skill_level = 1

/obj/item/skill_core/bleed/sanguine_feast
	name = "sanguine feast core"
	desc = "A crystallized essence of sanguine feast. Level 1 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/bleed/sanguine_feast
	skill_name = "sanguine feast"
	skill_level = 1

/obj/item/skill_core/bleed/blood_pool
	name = "blood pool core"
	desc = "A crystallized essence of blood pool. Level 1 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/bleed/blood_pool
	skill_name = "blood pool"
	skill_level = 1

/obj/item/skill_core/bleed/crimson_repulsion
	name = "crimson repulsion core"
	desc = "A crystallized essence of crimson repulsion. Level 1 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/bleed/crimson_repulsion
	skill_name = "crimson repulsion"
	skill_level = 1

/obj/item/skill_core/bleed/hemorrhage
	name = "hemorrhage core"
	desc = "A crystallized essence of hemorrhage. Level 2 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/skill/hemorrhage
	skill_name = "hemorrhage"
	skill_level = 2

/obj/item/skill_core/bleed/crimson_cleave
	name = "crimson cleave core"
	desc = "A crystallized essence of crimson cleave. Level 2 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/skill/crimson_cleave
	skill_name = "crimson cleave"
	skill_level = 2

/obj/item/skill_core/bleed/blood_spike
	name = "blood spike core"
	desc = "A crystallized essence of blood spike. Level 2 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/skill/blood_spike
	skill_name = "blood spike"
	skill_level = 2

/obj/item/skill_core/overheat
	name = "overheat core"
	desc = "A crystallized essence of overheat. Use it on a workshop attachment or necklace to imbue it with power."
	skill_name = "overheat"
	color = "#FF4500"

/obj/item/skill_core/overheat/heat_transfer
	name = "heat transfer core"
	desc = "A crystallized essence of heat transfer. Level 1 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/skill/heat_transfer
	skill_name = "heat transfer"
	skill_level = 1

/obj/item/skill_core/overheat/ignition_burst
	name = "ignition burst core"
	desc = "A crystallized essence of ignition burst. Level 1 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/skill/ignition_burst
	skill_name = "ignition burst"
	skill_level = 1

/obj/item/skill_core/overheat/flame_lance
	name = "flame lance core"
	desc = "A crystallized essence of flame lance. Level 1 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/skill/flame_lance
	skill_name = "flame lance"
	skill_level = 1

/obj/item/skill_core/overheat/cauterize
	name = "cauterize core"
	desc = "A crystallized essence of cauterize. Level 1 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/skill/cauterize
	skill_name = "cauterize"
	skill_level = 1

/obj/item/skill_core/overheat/spreading_ashes
	name = "spreading ashes core"
	desc = "A crystallized essence of spreading ashes. Level 1 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/skill/spreading_ashes
	skill_name = "spreading ashes"
	skill_level = 1

/obj/item/skill_core/overheat/feeding_embers
	name = "feeding embers core"
	desc = "A crystallized essence of feeding embers. Level 1 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/skill/feeding_embers
	skill_name = "feeding embers"
	skill_level = 1

/obj/item/skill_core/overheat/thermal_detonation
	name = "thermal detonation core"
	desc = "A crystallized essence of thermal detonation. Level 2 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/skill/overheat_detonation
	skill_name = "thermal detonation"
	skill_level = 2

/obj/item/skill_core/overheat/molten_strike
	name = "molten strike core"
	desc = "A crystallized essence of molten strike. Level 2 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/skill/molten_strike
	skill_name = "molten strike"
	skill_level = 2

/obj/item/skill_core/overheat/inferno_dash
	name = "inferno dash core"
	desc = "A crystallized essence of inferno dash. Level 2 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/skill/inferno_dash
	skill_name = "inferno dash"
	skill_level = 2

/obj/item/skill_core/tremor
	name = "tremor core"
	desc = "A crystallized essence of tremor. Use it on a workshop attachment or necklace to imbue it with power."
	skill_name = "tremor"
	color = "#8B4513"

/obj/item/skill_core/tremor/aftershock
	name = "aftershock core"
	desc = "A crystallized essence of aftershock. Level 1 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/skill/aftershock
	skill_name = "aftershock"
	skill_level = 1

/obj/item/skill_core/tremor/seismic_wave
	name = "seismic wave core"
	desc = "A crystallized essence of seismic wave. Level 1 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/skill/seismic_wave
	skill_name = "seismic wave"
	skill_level = 1

/obj/item/skill_core/tremor/shattered_resentment
	name = "shattered resentment core"
	desc = "A crystallized essence of shattered resentment. Level 1 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/skill/shattered_resentment
	skill_name = "shattered resentment"
	skill_level = 1

/obj/item/skill_core/tremor/stabilizing_stance
	name = "stabilizing stance core"
	desc = "A crystallized essence of stabilizing stance. Level 1 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/skill/stabilizing_stance
	skill_name = "stabilizing stance"
	skill_level = 1

/obj/item/skill_core/tremor/tectonic_shift
	name = "tectonic shift core"
	desc = "A crystallized essence of tectonic shift. Level 1 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/skill/tectonic_shift
	skill_name = "tectonic shift"
	skill_level = 1

/obj/item/skill_core/tremor/repelling_motion
	name = "repelling motion core"
	desc = "A crystallized essence of repelling motion. Level 1 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/skill/repelling_motion
	skill_name = "repelling motion"
	skill_level = 1

/obj/item/skill_core/tremor/seismic_slam
	name = "seismic slam core"
	desc = "A crystallized essence of seismic slam. Level 2 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/skill/seismic_slam
	skill_name = "seismic slam"
	skill_level = 2

/obj/item/skill_core/tremor/resonant_strike
	name = "resonant strike core"
	desc = "A crystallized essence of resonant strike. Level 2 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/skill/resonant_strike
	skill_name = "resonant strike"
	skill_level = 2

/obj/item/skill_core/tremor/earthbound_hammer
	name = "earthbound hammer core"
	desc = "A crystallized essence of earthbound hammer. Level 2 technique. Use it on a workshop attachment or necklace to imbue it with power."
	skill_type = /datum/action/cooldown/skill/earthbound_hammer
	skill_name = "earthbound hammer"
	skill_level = 2
