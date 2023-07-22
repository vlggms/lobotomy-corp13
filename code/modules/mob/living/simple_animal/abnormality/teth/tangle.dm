GLOBAL_LIST_EMPTY(hair_list)

/mob/living/simple_animal/hostile/abnormality/tangle
	name = "Tangle"
	desc = "An abnormality with extremely long, flowing hair."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "tangle_asleep"
	maxHealth = 300
	health = 300
	start_qliphoth = 2
	can_breach = TRUE
	wander = 0
	can_patrol = FALSE
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = 70,
		ABNORMALITY_WORK_REPRESSION = 30
		)

	work_damage_amount = 7
	work_damage_type = WHITE_DAMAGE
	ego_list = list(
//		/datum/ego_datum/weapon/? CHANGE to actual ego gear and gift
//		/datum/ego_datum/armor/?
	)
//	gift_type = /datum/ego_gifts/?
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

/obj/structure/tangled_hair
	gender = PLURAL
	name = "tangled hair"
	desc = "Long golden hair has been let down."
	icon = 'icons/effects/effects.dmi'
	icon_state = "tangled_hair"

/mob/living/simple_animal/hostile/abnormality/tangle/PostSpawn()
	..()
	var/list/hair_area = range(1, src)
	for(var/turf/open/O in hair_area)
		new /obj/structure/tangled_hair(O)

/mob/living/simple_animal/hostile/abnormality/tangle/WorkChance(mob/living/carbon/human/user, chance)
	if(HAS_TRAIT(user, TRAIT_BALD))
		if(prob(20))
			datum_reference.qliphoth_change(-1)
		return chance -10
	return chance

/////////////////////////////////////// find a way to make this drop on a random living player on breach
var/list/workedTangle = list()

/mob/living/simple_animal/hostile/abnormality/tangle/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(!(user in workedTangle))
		workedTangle+=user
		new /obj/item/hairbrush(get_turf(user))
///////////////////////////////////////

/mob/living/simple_animal/hostile/abnormality/tangle/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	if(prob(80))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/tangle/OnQliphothChange()
	if(datum_reference.qliphoth_meter == 1)
		icon_state = "tangle_awake"
		return

/mob/living/simple_animal/hostile/abnormality/tangle/BreachEffect()
		SpreadHair()
		Transform()
//		dropBrush()
		return

/mob/living/simple_animal/hostile/abnormality/tangle/proc/Transform()
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	return

	//breach effect: spreading hair

/mob/living/simple_animal/hostile/abnormality/tangle/proc/SpreadHair()
	say("Successfully procced hair")
	if(!isturf(loc) || isspaceturf(loc))
		return
	if(locate(/obj/structure/spreading/tangled_hair) in get_turf(src))
		return
	new /obj/structure/spreading/tangled_hair(loc)
	return

/obj/structure/spreading/tangled_hair
	gender = PLURAL
	name = "tangled hair"
	desc = "Long golden hair has been let down."
	icon = 'icons/effects/effects.dmi'
	icon_state = "tangled_hair"
	resistance_flags = FLAMMABLE
	base_icon_state = "tangled_hair"
	color = "#E8BE77"
	//strictly for crossed proc
	var/list/static/ignore_typecache
	var/list/static/atom_remove_condition

/obj/structure/spreading/tangled_hair/Initialize() //borrowed from snow white's apple
	. = ..()

	GLOB.hair_list += src

	if(!atom_remove_condition)
		atom_remove_condition = typecacheof(list(
			/obj/projectile/ego_bullet/ego_match,
			/mob/living/simple_animal/hostile/abnormality/helper,
			/mob/living/simple_animal/hostile/abnormality/greed_king,
			/mob/living/simple_animal/hostile/abnormality/dimensional_refraction,
			/obj/vehicle/sealed/mecha))

	if(!ignore_typecache)
		ignore_typecache = typecacheof(list(
			/obj/effect,
			/mob/dead))

/obj/structure/spreading/tangled_hair/Destroy()
	GLOB.hair_list -= src
	return ..()

/obj/structure/spreading/tangled_hair/Crossed(atom/movable/AM)
	. = ..()
	if(is_type_in_typecache(AM, atom_remove_condition))
		take_damage(4, BRUTE, "melee", 1)
	if(is_type_in_typecache(AM, ignore_typecache))		// Don't want the traps triggered by sparks, ghosts or projectiles.
		return
	if(isliving(AM))
		hair_effect(AM)

/obj/structure/spreading/tangled_hair/proc/hair_effect(mob/living/L)
	if(ishuman(L))
		var/mob/living/carbon/human/lonely = L
		var/obj/item/trimming = lonely.get_active_held_item()
		if(!isnull(trimming))
			if(istype(trimming, /obj/item/ego_weapon/stem))
				return
			var/weeding = trimming.get_sharpness()
			if(weeding == SHARP_EDGED && trimming.force >= 5)
				if(prob(10))
					to_chat(lonely, "<span class='warning'>You cut back the [name] as it reaches for you.</span>")
				lonely.adjustStaminaLoss(5)
				qdel(src)
				return
			return
	if(prob(10))
		to_chat(L, "<span class='warning'>The [name] tightens around you.</span>")
	L.adjustStaminaLoss(10, TRUE, TRUE)

	//breach effect: spawn hairbrush
/obj/item/hairbrush
	name = "hairbrush"
	desc = "A dainty hairbrush."
	icon = 'ModularTegustation/Teguicons/hairbrush.dmi'
	icon_state = "hairbrush"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	force = 0

/*mob/living/simple_animal/hostile/abnormality/tangle/proc/dropBrush() //borrowed from parasite tree
	SIGNAL_HANDLER

	var/list/potentialBrusher = list()
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(!faction_check_mob(L) && L.stat != DEAD && L.z == z)
			potentialBrusher += L
			potentialBrusher[L] = 1
	if(potentialBrusher.len)
		var/mob/living/carbon/human/chosen_agent = pickweight(potentialBrusher)
		to_chat(chosen_agent, "<span class='nicegreen'>A dainty hairbrush appears nearby. Did someone lose it?</span>")
		new /obj/item/hairbrush(get_turf(chosen_agent))
		return*/

	//recontain procedure: brushie brushie
/mob/living/simple_animal/hostile/abnormality/tangle/attackby(obj/item/hairbrush, mob/user)
	if(!datum_reference.qliphoth_meter)
		to_chat(user, "<span class='nicegreen'>You brush out the tangled hair, and the abnormality calms.</span")
		datum_reference.qliphoth_change(2)
		icon = 'ModularTegustation/Teguicons/32x32.dmi'
		icon_state = "tangle_asleep"
		qdel(src)
		//qdel(hairbrush)
		return
