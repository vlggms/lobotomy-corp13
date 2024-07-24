/obj/item/ego_weapon/city/mirage
	name = "mirage weapon"
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
/obj/item/ego_weapon/city/mirage/sodom
	name = "sodom"
	desc = "Soon, All of the wicked shall be punished..."
	special = "Upon hit the targets WHITE vulnerability is increased by 0.2."
	hitsound = 'sound/weapons/fixer/generic/knife3.ogg'
	icon_state = "sodom"
	force = 20
	attack_speed = 0.5
	damtype = WHITE_DAMAGE

	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 80,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 60,
	)

/obj/item/ego_weapon/city/mirage/sodom/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	if(isliving(target))
		var/mob/living/simple_animal/M = target
		if(!ishuman(M) && !M.has_status_effect(/datum/status_effect/rend_white))
			new /obj/effect/temp_visual/cult/sparks(get_turf(M))
			M.apply_status_effect(/datum/status_effect/rend_white)

/obj/item/ego_weapon/city/mirage/sodom/gomorrah
	name = "gomorrah"

//Metal Fixer Weapons
/obj/item/ego_weapon/shield/eria
	name = "eria"
	desc = "It has been quiet a while since I last used you two. I missed the feeling."
	special = "This weapon restores health on a successful block."
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
	source.adjustBruteLoss(-10)
	source.adjustSanityLoss(-10)
	..()

/obj/item/ego_weapon/city/mirage/iria
	name = "iria"
	desc = "Experiences have shaped me this way."
	icon_state = "iria"
	force = 50
	attack_speed = 1.5
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("bashes", "hammers", "smacks")
	attack_verb_simple = list("bash", "hammer", "smack")
	hitsound = 'sound/weapons/fixer/generic/fist1.ogg'
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 60,
	)

//Flame Fixer Weapon
/obj/item/ego_weapon/city/mirage/sunstrike
	name = "sunstrike"
	desc = "A heavy spear decorated with vibrant patterns on the head. Etched with the name 'Helios' on the grip."
	special = "This weapon inflicts burn on hit."
	icon_state = "sunstrike"
	force = 42
	attack_speed = 1.5
	reach = 2
	stuntime = 5
	damtype = RED_DAMAGE
	var/inflict_burn = 2
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 60,
	)

/obj/item/ego_weapon/city/mirage/sunstrike/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	..()
	target.apply_lc_burn(inflict_burn)
