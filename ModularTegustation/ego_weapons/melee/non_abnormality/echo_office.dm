/obj/item/ego_weapon/city/echo
	name = "echo weapon"
	desc = "You should not see this."
	icon_state = "miraecane"
	force = 50
	damtype = WHITE_DAMAGE

	attack_verb_continuous = list("slashes", "cuts")
	attack_verb_simple = list("slash", "cut")
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 80,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 60,
	)

//Electric Fixer Weapons
/obj/item/ego_weapon/city/echo/twins
	name = "twins"
	desc = "Soon, All of the wicked shall be punished..."
	special = "If you are wearing the Neon Maid Dress armor, Upon hit the targets WHITE vulnerability is increased by 0.2. \
		When using both sodom and gomorrah, increase their attack speed by 0.2"
	hitsound = 'sound/weapons/fixer/generic/knife3.ogg'
	icon_state = "sodom"
	force = 18
	attack_speed = 0.5
	damtype = WHITE_DAMAGE
	var/attack_speed_buff = 0.2

	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 80,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 60,
	)

/obj/item/ego_weapon/city/echo/twins/attack(mob/living/target, mob/living/user)
	var/old_attack_speed = attack_speed
	if ((locate(/obj/item/ego_weapon/city/echo/twins/gomorrah) in user.held_items) && (locate(/obj/item/ego_weapon/city/echo/twins/sodom) in user.held_items))
		attack_speed -= attack_speed_buff

	. = ..()

	if(!.)
		return FALSE

	attack_speed = old_attack_speed

	var/mob/living/carbon/human/wielder = user
	var/obj/item/clothing/suit/armor/ego_gear/city/echo/maid_dress/Y = wielder.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(Y))
		if(isliving(target))
			var/mob/living/simple_animal/M = target
			if(!ishuman(M) && !M.has_status_effect(/datum/status_effect/rend_white))
				new /obj/effect/temp_visual/cult/sparks(get_turf(M))
				M.apply_status_effect(/datum/status_effect/rend_white)

/obj/item/ego_weapon/city/echo/twins/gomorrah
	name = "gomorrah"
	icon_state = "gomorrah"

/obj/item/ego_weapon/city/echo/twins/sodom
	name = "sodom"
	icon_state = "sodom"


//Metal Fixer Weapons
/obj/item/ego_weapon/shield/eria
	name = "eria"
	desc = "It has been quite a while since I last used you two. I missed the feeling."
	special = "This weapon restores health on a successful block. If you are also wearing Plated Outer Cover armor, increase the healing on a successful block by 150%."
	icon_state = "eria"
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right.dmi'
	force = 30
	attack_speed = 1.5
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("bashes", "hammers", "smacks")
	attack_verb_simple = list("bash", "hammer", "smack")
	hitsound = 'sound/weapons/fixer/generic/club2.ogg'
	reductions = list(40, 20, 80, 10) // 150
	projectile_block_duration = 0.5 SECONDS
	block_duration = 1 SECONDS
	block_cooldown = 3 SECONDS
	block_sound = 'sound/weapons/ego/clash1.ogg'
	projectile_block_message ="Your shield swats the projectile away!"
	block_message = "You attempt to block the attack!"
	hit_message = "blocks the attack!"
	block_cooldown_message = "You rearm your sheild"
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 60,
	)

/obj/item/ego_weapon/shield/eria/attack_self(mob/user)//FIXME: Find a better way to use this override!
	if(block == 0) //Extra check because shields returns nothing on 1
		if(..())
			RegisterSignal(user, COMSIG_ATOM_ATTACK_HAND, PROC_REF(NoParry), override = TRUE)//creates runtimes without overrides, double check if something's fucked
			RegisterSignal(user, COMSIG_PARENT_ATTACKBY, PROC_REF(NoParry), override = TRUE)//728 and 729 must be able to unregister the signal of 730
			return TRUE
		else
			return FALSE

/obj/item/ego_weapon/shield/eria/proc/NoParry(mob/living/carbon/human/user, obj/item/L)//Disables AnnounceBlock when attacked by an item or a human
	SIGNAL_HANDLER
	UnregisterSignal(user, COMSIG_MOB_APPLY_DAMGE)//y'all can't behave

/obj/item/ego_weapon/shield/eria/AnnounceBlock(mob/living/carbon/human/source, damage, damagetype, def_zone)
	if (damagetype == PALE_DAMAGE)
		to_chat(source,span_nicegreen("Your [src] withers at the touch of death!"))
		return ..()
	to_chat(source,span_nicegreen("You are healed by [src]."))
	var/mob/living/carbon/human/wielder = source
	var/obj/item/clothing/suit/armor/ego_gear/city/echo/plated/Y = wielder.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(Y))
		wielder.adjustBruteLoss(-25)
	else
		wielder.adjustBruteLoss(-10)
	..()

/obj/item/ego_weapon/city/echo/iria
	name = "iria"
	desc = "Experiences have shaped me this way."
	icon_state = "iria"
	special = "If you are also wearing Plated Outer Cover armor, deal 30% more damage and increase the knockback caused by iria. When attacking while using both iria and eria, you heal a bit of HP on hit."
	force = 45
	attack_speed = 2
	damtype = BLACK_DAMAGE
	var/healing_on_hit = 5
	var/damage_multiplier = 1.3
	attack_verb_continuous = list("bashes", "hammers", "smacks")
	attack_verb_simple = list("bash", "hammer", "smack")
	hitsound = 'sound/weapons/fixer/generic/fist1.ogg'
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 60,
	)

/obj/item/ego_weapon/city/echo/iria/attack(mob/living/target, mob/living/user)
	var/old_force_multiplier = force_multiplier
	var/mob/living/carbon/human/wielder = user
	var/obj/item/clothing/suit/armor/ego_gear/city/echo/plated/Y = wielder.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(Y))
		force_multiplier = damage_multiplier
		knockback = KNOCKBACK_MEDIUM
	. = ..()
	if(!.)
		return FALSE
	if ((locate(/obj/item/ego_weapon/city/echo/iria) in wielder.held_items) && (locate(/obj/item/ego_weapon/shield/eria) in wielder.held_items))
		wielder.adjustBruteLoss(-healing_on_hit)
	force_multiplier = old_force_multiplier
	knockback = KNOCKBACK_LIGHT

//Flame Fixer Weapon
/obj/item/ego_weapon/city/echo/sunstrike
	name = "sunstrike"
	desc = "A heavy spear decorated with vibrant patterns on the head. Etched with the name 'Helios' on the grip."
	special = "This weapon inflicts 6 burn on hit, If you are wearing the Frilled Maid Outfit/Faux Fur Coat outfit, Double the burn inflicted."
	icon_state = "sunstrike"
	force = 42
	attack_speed = 1.5
	reach = 2
	stuntime = 5
	damtype = RED_DAMAGE
	var/inflict_burn = 6
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 60,
	)

/obj/item/ego_weapon/city/echo/sunstrike/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	..()
	var/mob/living/carbon/human/wielder = user
	var/obj/item/clothing/suit/armor/ego_gear/city/echo/faux/Y = wielder.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(Y))
		target.apply_lc_burn(inflict_burn*2)
	else
		target.apply_lc_burn(inflict_burn)
