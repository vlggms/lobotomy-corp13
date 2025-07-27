/******************** SHUTTLE DATUM ********************/

/datum/map_template/ruin/space/starfury
	id = "starfury"
	suffix = "starfury.dmm"
	name = "Starfury Battle Cruiser"
	placement_weight = 0
	unpickable = TRUE
	description = "Starfury in motion, king of the universe, one of the kind. \
	Absolute terror of all Nanotrasen personnel."

/datum/map_template/shuttle/syndifury //Starfury Battle Cruiser event shuttles
	can_be_bought = FALSE
	port_id = "syndifury"

/datum/map_template/shuttle/syndifury/sbcfighter
	suffix = "sbcfighter"
	name = "Syndicate Fighter"

/datum/map_template/shuttle/syndifury/sbccorvette
	suffix = "sbccorvette"
	name = "Syndicate Corvette"

/******************** AREAS ********************/

/area/shuttle/sbc
	name = "SBC Starfury"
	requires_power = TRUE

/area/shuttle/sbc/starfury
	name = "Syndicate Battle Cruiser Bridge"
	icon_state = "bridge"
	ambientsounds = list('sound/ambience/signal.ogg')

/area/shuttle/sbc/med
	name = "Syndicate Battle Cruiser Medbay"
	icon_state = "medbay_maint_central"
	ambientsounds = AMBIENCE_MEDICAL

/area/shuttle/sbc/engi
	name = "Syndicate Battle Cruiser Engineering"
	icon_state = "yellow"
	ambientsounds = AMBIENCE_ENGI

/area/shuttle/sbc/bay
	name = "Syndicate Battle Cruiser Shuttle Bay"
	icon_state = "cargo_bay"

/area/shuttle/sbc/armory
	name = "Syndicate Battle Cruiser Armory"
	icon_state = "brig"

/area/shuttle/sbc/crew
	name = "Syndicate Battle Cruiser Crew Area"
	icon_state = "bar"

/area/shuttle/sbc/supermatter
	name = "Syndicate Battle Cruiser Engine"
	icon_state = "engine_sm"

/area/shuttle/sbc/fighter1
	name = "SBC Fighter 1"

/area/shuttle/sbc/corvette
	name = "SBC corvette"

/******************** OBJECTIVE ********************/

/datum/objective/syndicatesupermatter
	name = "keep SM intact"
	explanation_text = "Keep the supermatter engine onboard the cruiser intact."

/datum/objective/syndicatesupermatter/check_completion()
	return !!GLOB.syndicate_supermatter_engine

/******************** OBJECTS & ITEMS ********************/

//Turret
/obj/machinery/porta_turret/syndicate/starfury
	shot_delay = 2
	scan_range = 9
	stun_projectile = /obj/projectile/bullet/a556/phasic
	lethal_projectile = /obj/projectile/bullet/a556/phasic
	lethal_projectile_sound = 'sound/weapons/gun/smg/shot_alt.ogg'
	stun_projectile_sound = 'sound/weapons/gun/smg/shot_alt.ogg'
	armor = list("melee" = 60, "bullet" = 60, "laser" = 80, "energy" = 90, "bomb" = 80, "bio" = 0, "rad" = 0, "fire" = 100, "acid" = 90)

//Energy Crowbar
/obj/item/crowbar/combat
	name = "combat crowbar"
	desc = "An advanced crowbar 'borrowed' from the combined union."
	icon = 'ModularTegustation/Teguicons/starfury.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/teguitems_hold_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/teguitems_hold_right.dmi'
	icon_state = "crowbar_combat"
	inhand_icon_state = "crowbar_combat"
	attack_verb_simple = list("devastate", "brutalize", "crowbar")
	attack_verb_continuous = list("dewastates", "brutalizes", "crowbars")
	tool_behaviour = null
	toolspeed = null
	force_opens = FALSE
	var/on = FALSE

/obj/item/crowbar/combat/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/crowbar/combat/attack_self(mob/living/user)
	on = !on
	force = on ? 20 : initial(force)
	force_opens = on ? TRUE : initial(force_opens)
	w_class = on ? WEIGHT_CLASS_NORMAL : initial(w_class)
	throwforce = on ? 22 : initial(throwforce)
	tool_behaviour = on ? TOOL_CROWBAR : initial(tool_behaviour)
	toolspeed = on ? 0.2 : initial(toolspeed)
	hitsound = on ? 'sound/weapons/blade1.ogg' : "swing_hit"
	playsound(user, on ? 'sound/weapons/saberon.ogg' : 'sound/weapons/saberoff.ogg', 5, TRUE)
	to_chat(user, span_warning("[src] is now [on ? "active" : "concealed"]."))
	update_icon()

/obj/item/crowbar/combat/update_icon_state()
	icon_state = "[initial(icon_state)][on ? "_on" : ""]"
	inhand_icon_state = "[initial(inhand_icon_state)][on ? "1" : ""]"

//Engi Toolbelt
/obj/item/storage/belt/utility/syndicate/sbc/PopulateContents()
	new /obj/item/screwdriver/nuke(src)
	new /obj/item/wrench/combat(src)
	new /obj/item/weldingtool/largetank(src)
	new /obj/item/crowbar/combat(src)
	new /obj/item/wirecutters(src)
	new /obj/item/multitool(src)
	new /obj/item/inducer/syndicate(src)

//Syndicate medipen box
/obj/item/storage/box/medipens/syndi
	name = "box of medipens"
	desc = "A box full of high-grade medipens."
	icon_state = "syndiebox"
	illustration = "writing_syndie"

/obj/item/storage/box/medipens/syndi/PopulateContents()
	new /obj/item/reagent_containers/hypospray/medipen/salacid(src)
	new /obj/item/reagent_containers/hypospray/medipen/salacid(src)
	new /obj/item/reagent_containers/hypospray/medipen/oxandrolone(src)
	new /obj/item/reagent_containers/hypospray/medipen/oxandrolone(src)
	new /obj/item/reagent_containers/hypospray/medipen/salbutamol(src)
	new /obj/item/reagent_containers/hypospray/medipen/salbutamol(src)
	new /obj/item/reagent_containers/hypospray/medipen/penacid(src)

//Eyepatch
/obj/item/clothing/glasses/hud/eyepatch/admiral
	name = "syndicate thermal eyepatch"
	desc = "An eyepatch with built-in thermal, night-vision optics and security HUD."
	icon_state = "eyepatch"
	inhand_icon_state = "eyepatch"
	vision_flags = SEE_MOBS
	darkness_view = 8
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	glass_colour_type = /datum/client_colour/glass_colour/red
	hud_type = DATA_HUD_SECURITY_ADVANCED
	hud_trait = TRAIT_SECURITY_HUD

//Decals
/obj/effect/turf_decal/starfury
	icon = 'ModularTegustation/Teguicons/starfury.dmi'

/obj/effect/turf_decal/starfury/one
	icon_state = "SBC1"

/obj/effect/turf_decal/starfury/two
	icon_state = "SBC2"

/obj/effect/turf_decal/starfury/three
	icon_state = "SBC3"

/obj/effect/turf_decal/starfury/four
	icon_state = "SBC4"

/obj/effect/turf_decal/starfury/five
	icon_state = "SBC5"

/obj/effect/turf_decal/starfury/six
	icon_state = "SBC6"

/obj/effect/turf_decal/starfury/seven
	icon_state = "SBC7"

/obj/effect/turf_decal/starfury/eight
	icon_state = "SBC8"

/obj/effect/turf_decal/starfury/nine
	icon_state = "SBC9"

/obj/effect/turf_decal/starfury/ten
	icon_state = "SBC10"

/******************** SUPERMATTER ********************/

GLOBAL_DATUM(syndicate_supermatter_engine, /obj/machinery/power/supermatter_crystal/syndicate)

/obj/machinery/power/supermatter_crystal/syndicate
	desc = "Unstable supermatter crystal recovered from earlier Nanotrasen Researches."
	explosion_power = 100 //Big ka-boom
	radio_key = /obj/item/encryptionkey/syndicate
	engineering_channel = "Syndicate"
	common_channel = "Syndicate"

/obj/machinery/power/supermatter_crystal/syndicate/Initialize()
	. = ..()
	GLOB.syndicate_supermatter_engine = src
	AddComponent(/datum/component/gps, "SBC01 - Starfury")
