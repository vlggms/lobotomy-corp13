/obj/item/ego_weapon/city/insurgence_baton
	name = "insurgence baton"
	desc = "A gray baton used by transport agents."
	special = "This weapon inflicts 5 tremor on hit, and tremor bursts when the target has 40+ tremor"
	icon = 'ModularTegustation/Teguicons/lc13_insurgence.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/lc13_insurgence_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_insurgence_right.dmi'
	icon_state = "ibatong"
	inhand_icon_state = "ibatong"
	force = 32
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")
	attack_speed = 1.25
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/city/insurgence_baton/attack(mob/living/target, mob/living/user)
	. = ..()
	target.apply_lc_tremor(5, 40)

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

/obj/item/ego_weapon/shield/insurgence_shield/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(. && istype(I, /obj/item/ego_weapon/city/insurgence_baton))
		playsound(src, 'sound/weapons/ego/gasharpoon_queeblock.ogg', 50, TRUE)
		visible_message(span_warning("[src] emits an intimidating sound as it's struck!"))

/obj/item/ego_weapon/city/insurgence_nightwatch
	name = "nightwatch blade"
	desc = "A specialized blade used by insurgence nightwatch agents."
	special = "If the target has 15+ tremor, tremor burst twice. Deals 20% more damage to targets above 50% HP."
	icon_state = "hfrequency1"
	inhand_icon_state = "hfrequency1"
	icon = 'icons/obj/items_and_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	force = 49
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("slashes", "cleaves")
	attack_verb_simple = list("slash", "cleave")
	attack_speed = 0.75
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)
	var/burst_cooldown = 0
	var/burst_cooldown_time = 20 SECONDS

/obj/item/ego_weapon/city/insurgence_nightwatch/attack(mob/living/target, mob/living/user)
	var/force_mod = 1
	if(target.health > target.maxHealth * 0.5)
		force_mod = 1.2

	// Check if user is wearing nightwatch armor with cloak active
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/clothing/suit/armor/ego_gear/city/insurgence_nightwatch/armor = H.wear_suit
		if(istype(armor))
			force_mod *= armor.GetDamageModifier()

	force = initial(force) * force_mod
	. = ..()
	force = initial(force)

	if(!istype(target))
		return

	var/datum/status_effect/stacking/lc_tremor/T = target.has_status_effect(/datum/status_effect/stacking/lc_tremor)
	if(T && T.stacks >= 15 && world.time > burst_cooldown)
		burst_cooldown = world.time + burst_cooldown_time
		to_chat(user, span_notice("Your blade resonates with [target]'s trembling form!"))
		var/old_tremor_stack = T.stacks
		T.TremorBurst()
		target.apply_lc_tremor(old_tremor_stack, 55)
		addtimer(CALLBACK(src, PROC_REF(SecondBurst), target), 5)

/obj/item/ego_weapon/city/insurgence_nightwatch/proc/SecondBurst(mob/living/target)
	if(!target || QDELETED(target))
		return
	var/datum/status_effect/stacking/lc_tremor/T = target.has_status_effect(/datum/status_effect/stacking/lc_tremor)
	if(T)
		T.TremorBurst()
