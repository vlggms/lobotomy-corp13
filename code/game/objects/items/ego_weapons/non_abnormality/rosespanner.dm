//Like this so we can add a charge mechanic to one of them and have it carry down.
/obj/item/ego_weapon/city/charge/rosespanner
	name = "rosespanner template"
	desc = "A template for the rosespanner workshop"
	icon_state = "rosespanner"
	inhand_icon_state = "rosespanner"
	force = 18
	damtype = RED_DAMAGE

	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")
	release_message = "You release your charge, dealing a massive burst of damage!"
	charge_effect = "spend charge to deal an AOE in the current damage type."
	charge_cost = 15
	var/overcharged
	var/charged

/obj/item/ego_weapon/city/charge/rosespanner/attack_self(mob/user)
	..()
	if(charge>=charge_cost)
		to_chat(user, span_notice("You prepare to release your charge."))
		activated = TRUE
	else
		to_chat(user, span_notice("You don't have enough charge."))

/obj/item/ego_weapon/city/charge/rosespanner/examine(mob/user)
	. = ..()
	. += "Overcharging it will result in explosive aftereffects."

/obj/item/ego_weapon/city/charge/rosespanner/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!istype(I, /obj/item/rosespanner_gear))
		return
	to_chat(user, span_notice("You apply a gear to your weapon, changing its damage type."))
	damtype = I.damtype
	charged = TRUE
	qdel(I)

/obj/item/ego_weapon/city/charge/rosespanner/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if(charge == 20)
		overcharged = TRUE
		activated = TRUE
	if(activated)
		release_charge(target, user)
		activated = FALSE

/obj/item/ego_weapon/city/charge/rosespanner/release_charge(mob/living/target, mob/living/user)
	..()
	sleep(2)
	target.apply_damage(force, damtype, null, target.run_armor_check(null, damtype), spread_damage = TRUE)
	playsound(src, 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 50, TRUE)

	if(overcharged)
		to_chat(user, span_danger("You overcharged your weapon!."))

	var/aoe = force * (1 + (get_attribute_level(user, JUSTICE_ATTRIBUTE))/100)
	for(var/turf/T in view(2, target))
		new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(T))
		for(var/mob/living/L in T)
			if(!overcharged && (L == user || ishuman(L)))
				continue
			L.apply_damage(aoe, damtype, null, L.run_armor_check(null, damtype), spread_damage = TRUE)

	overcharged = FALSE
	charged = FALSE
	damtype = initial(damtype)

//Grade 5
/obj/item/ego_weapon/city/charge/rosespanner/minihammer
	name = "rosespanner mini hammer"
	desc = "A hammer from the rosespanner workshop. Fits in your EGO belt."
	icon_state = "rosespanner_minihammer"
	inhand_icon_state = "rosespanner_minihammer"
	force = 44
	attack_speed = 1
	charge_cost = 7	//Takes fucking forever, you can charge it a little faster
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

//Grade 5
/obj/item/ego_weapon/city/charge/rosespanner/hammer
	name = "rosespanner hammer"
	desc = "A hammer from the rosespanner workshop"
	icon_state = "rosespanner_hammer"
	inhand_icon_state = "rosespanner_hammer"
	force = 88	//Slow but rosespanners a detriment, so
	attack_speed = 2
	charge_cost = 10	//Takes fucking forever, you can charge it a little faster
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

//Grade 5
/obj/item/ego_weapon/city/charge/rosespanner/spear
	name = "rosespanner spear"
	desc = "A spear from the rosespanner workshop"
	icon_state = "rosespanner_spear"
	inhand_icon_state = "rosespanner_spear"
	force = 44	//Slow but rosespanners a detriment, so
	attack_speed = 1.2
	charge_cost = 14	//slow weapon, you can charge it faster
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)


//Gears that give the weapons a damage type
/obj/item/rosespanner_gear
	name = "rosespanner red gear"
	desc = "A gear used by Rosespanner workshop. Use them on a rosespanner weapon to augment the weapon."
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	icon_state = "redgear"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right.dmi'
	damtype = RED_DAMAGE


/obj/item/rosespanner_gear/white
	name = "rosespanner white gear"
	icon_state = "whitegear"
	damtype = WHITE_DAMAGE


/obj/item/rosespanner_gear/black
	name = "rosespanner black gear"
	icon_state = "blackgear"
	damtype = BLACK_DAMAGE


/obj/item/rosespanner_gear/pale
	name = "rosespanner pale gear"
	icon_state = "palegear"
	damtype = PALE_DAMAGE

