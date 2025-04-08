/obj/item/ego_weapon/city/devyat_trunk
	name = "devyat courier trunk"
	desc = "A devyat association-issued delivery trunks."
	special = ""
	icon = 'icons/obj/clothing/ego_gear/devyat_icon.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/devyat_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/devyat_right.dmi'
	icon_state = "s_polu"
	inhand_icon_state = "s_polu"
	force = 27
	damtype = BLACK_DAMAGE
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
	attack_verb_continuous = list("slices", "gashes", "stabs")
	attack_verb_simple = list("slice", "gash", "stab")
	hitsound = 'sound/weapons/fixer/generic/knife3.ogg'
	var/combat_mode = FALSE

	var/courier_trunk = 0
	var/passive_courier_trunk_add = 3
	var/attacking_courier_trunk_add = 1
	var/attack_courier_trunk_cooldown
	var/attack_courier_trunk_cooldown_time = 2 SECONDS

	var/tier1_damage_multiplier = 1.3
	var/tier2_damage_multiplier = 1.6
	var/tier3_damage_multiplier = 2

/obj/item/ego_weapon/city/devyat_trunk/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.allow_quick_gather = TRUE
	STR.allow_quick_empty = TRUE
	STR.display_numerical_stacking = TRUE
	STR.click_gather = TRUE

/obj/item/ego_weapon/city/devyat_trunk/attack_self(mob/living/carbon/human/user)
	..()
	if(combat_mode)
		if(do_after(user, 50, user))
			combat_mode = FALSE
			REMOVE_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
			to_chat(user, "<span class='spider'><b>Combat move deactivated!</b></span>")
	else
		start_combat()

/obj/item/ego_weapon/city/devyat_trunk/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!combat_mode)
		start_combat()
	else
		if(attack_courier_trunk_cooldown < world.time - attack_courier_trunk_cooldown_time)
			attack_courier_trunk_cooldown = world.time
			courier_trunk += attacking_courier_trunk_add

/obj/item/ego_weapon/city/devyat_trunk/proc/start_combat()
	combat_mode = TRUE
	ADD_TRAIT(src, TRAIT_NODROP, STICKY_NODROP)
	addtimer(CALLBACK(src, PROC_REF(passive_courier_trunk)), 5 SECONDS)

/obj/item/ego_weapon/city/devyat_trunk/proc/passive_courier_trunk()
	if(combat_mode)
		courier_trunk += passive_courier_trunk_add
		addtimer(CALLBACK(src, PROC_REF(passive_courier_trunk)), 5 SECONDS)