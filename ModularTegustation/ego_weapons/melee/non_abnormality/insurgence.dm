/obj/item/ego_weapon/city/insurgence_baton
	name = "insurgence baton"
	desc = "A gray baton used by transport agents."
	special = "This weapon inflicts 3 tremor on hit, and tremor bursts when the target has 40+ tremor"
	icon_state = "kbatong"
	inhand_icon_state = "kbatong"
	force = 30
	damtype = RED_DAMAGE
	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
	var/inflicted_tremor = 3
	var/tremor_update
	var/tremor_cooldown = 5 SECONDS

/obj/item/ego_weapon/city/insurgence_baton/attack(mob/living/target, mob/living/user)
	. = ..()
	target.apply_lc_tremor(3, 40)

/obj/item/ego_weapon/shield/insurgence_shield
	name = "insurgence energy shield"
	desc = "A shield used by insurgence transport agents."
	special = "This shield can be concealed by alt clicking it."
	icon = 'icons/obj/shields.dmi'
	icon_state = "kshield"
	base_icon_state = "eshield" // [base_icon_state]1 for expanded, [base_icon_state]0 for contracted
	lefthand_file = 'icons/mob/inhands/equipment/shields_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/shields_righthand.dmi'
	force = 5
	damtype = RED_DAMAGE
	attack_verb_continuous = list("shoves", "bashes")
	attack_verb_simple = list("shove", "bash")
	hitsound = 'sound/weapons/genhit2.ogg'
	reductions = list(10, 10, 10, 10) // 120 when active, HE?
	projectile_block_duration = 5 SECONDS
	block_cooldown = 4 SECONDS
	block_duration = 2 SECONDS
	w_class = WEIGHT_CLASS_TINY
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
	var/on_force = 15
	var/active = 0

/obj/item/ego_weapon/shield/insurgence_shield/Initialize()
	. = ..()
	icon_state = "[base_icon_state]0"

/obj/item/ego_weapon/shield/insurgence_shield/attack_self(mob/user)
	. = ..()
	if(!CanUseEgo(user))
		to_chat(user, span_warning("You can't use [src]!"))
		return FALSE
	if(!active)
		active = !active
		force = on_force
		w_class = WEIGHT_CLASS_BULKY
		reductions = list(40, 30, 30, 20)
		playsound(user, 'sound/weapons/saberon.ogg', 35, TRUE)
		to_chat(user, span_notice("[src] is now active."))
		icon_state = "[base_icon_state][active]"

/obj/item/ego_weapon/shield/insurgence_shield/AltClick(mob/user)
	. = ..()
	if(!CanUseEgo(user))
		to_chat(user, span_warning("You can't use [src]!"))
		return FALSE
	if(active)
		active = !active
		force = initial(force)
		w_class = WEIGHT_CLASS_TINY
		reductions = list(10, 10, 10, 10)
		playsound(user, 'sound/weapons/saberoff.ogg', 35, TRUE)
		to_chat(user, span_notice("[src] can now be concealed."))
		icon_state = "[base_icon_state][active]"
