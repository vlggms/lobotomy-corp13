/obj/item/ego_weapon/penitence
	name = "penitence"
	desc = "A mace meant to purify the evil thoughts."
	icon_state = "penitence"
	force = 14
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("smacks", "strikes", "beats")
	attack_verb_simple = list("smack", "strike", "beat")
	var/pulse_cooldown
	var/pulse_cooldown_time = 1 SECONDS
	var/pulse_damage = -0.5

/obj/item/ego_weapon/penitence/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/clothing/suit/armor/ego_gear/penitence/P = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	if(istype(P))
		Healpulse()

/obj/item/ego_weapon/penitence/proc/Healpulse()
	pulse_cooldown = world.time + pulse_cooldown_time
	for(var/mob/living/L in livinginview(8, src))
		L.apply_damage(pulse_damage, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)

/obj/item/ego_weapon/little_alice
	name = "little alice"
	desc = "You, now in wonderland!"
	icon_state = "little_alice"
	force = 14
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slices", "slashes", "stabs")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/ego_weapon/wingbeat
	name = "wingbeat"
	desc = "If NAME can show that they are competent, then they may be able to draw Fairy Festival’s attention.."
	icon_state = "wingbeat"
	force = 14
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("smacks", "strikes", "beats")
	attack_verb_simple = list("smack", "strike", "beat")

/obj/item/ego_weapon/change
	name = "change"
	desc = "A hammer made with the desire to change anything"
	icon_state = "change"
	force = 14
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")
