
/obj/item/ego_weapon/officer/discipline
	name = "officer buster sword"
	icon_state = "officer_buster"
	desc = "A bulky sword that could leave a large dent into most things. Used by the Disciplinary Officer "
	special = "Use in hand to make your next attack deal more damage."
	force = 15
	attack_speed = 1.8
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleaves", "cuts")
	hitsound = 'sound/weapons/fixer/generic/finisher1.ogg'
	level_to_force = list(15, 22, 35, 47, 68)
	allowed_roles = list("Disciplinary Officer")
	extra_text = "This weapon can only be wielded by the Disciplinary Officer. This weapon also increases in power the more ordeals are defeated."
	swingstyle = WEAPONSWING_LARGESWEEP
	var/charged = FALSE

/obj/item/ego_weapon/officer/discipline/attack(mob/living/M, mob/living/user)
	if(charged)
		force *= 1.5
		hitsound = 'sound/abnormalities/nothingthere/goodbye_attack.ogg'
	..()
	if(charged)
		var/obj/effect/temp_visual/dir_setting/slash/s = new(get_turf(M))
		s.dir = 0
		s.layer = M.layer + 0.1
		to_chat(user, "You cleave through [M]!")
		hitsound = initial(hitsound)
		refresh_stats()
		charged = FALSE

/obj/item/ego_weapon/officer/discipline/attack_self(mob/user)
	. = ..()
	if(!charged)
		if(do_after(user, 10, src))
			charged = TRUE
			to_chat(user,span_warning("You put your strength behind this attack."))

/obj/item/ego_weapon/officer/discipline/get_clamped_volume()
	return 50

/obj/item/ego_weapon/officer/discipline_baton
	name = "disciplinary officer baton"
	desc = "A compact baton that is very robust. Deals triple damage as WHITE damage to panicked employees."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "telebaton_0"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	worn_icon_state = "tele_baton"
	var/on_icon_state = "telebaton_1"
	var/off_icon_state = "telebaton_0"
	var/on_inhand_icon_state = "nullrod"
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	damtype = RED_DAMAGE
	force = 7
	attack_speed = 1.5
	level_to_force = list(7, 12, 17, 23, 34)
	allowed_roles = list("Disciplinary Officer")
	extra_text = "This weapon can only be wielded by the Disciplinary Officer. This weapon also increases in power the more ordeals are defeated."
	var/on = FALSE

/obj/item/ego_weapon/officer/discipline_baton/proc/ToolChecks(mob/user)
	if(user?.mind?.assigned_role != "Disciplinary Officer")
		return FALSE
	return TRUE

/obj/item/ego_weapon/officer/discipline_baton/proc/get_on_description()
	. = list()

	.["local_on"] = "<span class ='warning'>You extend the baton.</span>"
	.["local_off"] = "<span class ='notice'>You collapse the baton.</span>"

	return .

/obj/item/ego_weapon/officer/discipline_baton/attack_self(mob/user)
	if(!ToolChecks(user))
		to_chat(user, span_warning("You cannot use this!."))
		return
	on = !on
	var/list/desc = get_on_description()

	if(on)
		to_chat(user, desc["local_on"])
		icon_state = on_icon_state
		inhand_icon_state = on_inhand_icon_state
		w_class = WEIGHT_CLASS_BULKY
		attack_verb_continuous = list("smacks", "strikes", "cracks", "beats")
		attack_verb_simple = list("smack", "strike", "crack", "beat")
	else
		to_chat(user, desc["local_off"])
		icon_state = off_icon_state
		inhand_icon_state = null //no sprite for concealment even when in hand
		slot_flags = ITEM_SLOT_BELT
		w_class = WEIGHT_CLASS_SMALL
		attack_verb_continuous = list("hits", "pokes")
		attack_verb_simple = list("hit", "poke")
	playsound(src.loc, 'sound/weapons/batonextend.ogg', 50, TRUE)

/obj/item/ego_weapon/officer/discipline_baton/examine(mob/user)
	. = ..()
	. += span_notice("Deals very high WHITE damage to panicked employees when using HARM intent.")
	if(!ToolChecks(user))
		. += span_warning("For the Disciplinary Officer only.")
	else
		. += span_nicegreen("Only you can use this.")


/obj/item/ego_weapon/officer/discipline_baton/attack(mob/living/target, mob/living/user)
	if(!ToolChecks(user))
		to_chat(user, span_warning("You cannot use this!."))
		return
	if(!on)
		force = 0
	else if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.sanity_lost)
			damtype = WHITE_DAMAGE
			force *= 2
	..()
	damtype = initial(damtype)
	force = level_to_force[current_level]

/obj/item/ego_weapon/officer/butcher
	name = "officer blade"
	desc = "A blade for butchering."
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	icon_state = "pierre"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right.dmi'
	force = 3
	w_class = WEIGHT_CLASS_TINY
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = SHARP_EDGED
	toolspeed = 0.25
	allowed_roles = list("Disciplinary Officer")
	level_to_force = list(3, 6, 9, 12, 15)
	var/list/level_to_speed = list(40, 30, 20, 10, 0) // 4-0 second(s) butcher time depending on level. Instant butchering is comparable to the smile E.G.O.
	extra_text = "This tool can only be utilized by the Disciplinary Officer."

/obj/item/ego_weapon/officer/butcher/refresh_stats() // Overridden this to increase the butcher speed.
	force = level_to_force[current_level]
	var/datum/component/butchering/butchering = src.GetComponent(/datum/component/butchering)
	if(!butchering)
		AddComponent(/datum/component/butchering, 50,100, 0)
		refresh_stats()
		return
	butchering.speed = level_to_speed[current_level]
