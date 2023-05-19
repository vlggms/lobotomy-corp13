/obj/item/ego_weapon/penitence
	name = "penitence"
	desc = "A mace meant to purify the evil thoughts."
	icon_state = "penitence"
	force = 14
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("smacks", "strikes", "beats")
	attack_verb_simple = list("smack", "strike", "beat")

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

/obj/item/ego_weapon/doze
	name = "dozing"
	desc = "Knock the daylights out of 'em!"
	icon_state = "doze"
	force = 14
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")

/obj/item/ego_weapon/evening
	name = "evening twilight"
	desc = "I accepted the offer and paid the price."
	icon_state = "evening"
	force = 12
	damtype = PALE_DAMAGE
	armortype = PALE_DAMAGE
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")

/obj/item/ego_weapon/melty_eyeball
	name = "melty eyeball"
	desc = "I felt like I was being dragged deeper into the swamp of gloom as the fight went on."
	icon_state = "melty_eyeball"
	force = 14
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("slams", "strikes", "smashes")
	attack_verb_simple = list("slam", "strike", "smash")
	hitsound = 'sound/abnormalities/blubbering_toad/attack.ogg'

/obj/item/ego_weapon/letter_opener
	name = "letter opener"
	desc = "Trusty aid of a mailman."
	icon_state = "letteropener"
	force = 14
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slices", "slashes", "stabs")
	hitsound = 'sound/weapons/bladeslice.ogg'

//special ego for pile of mail from parcels
/obj/item/ego_weapon/mail_satchel
	name = "envelope"
	desc = "Heavy satchel filled to the brim with letters."
	icon_state = "mailsatchel"
	force = 12
	attack_speed = 1.2
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("slams", "bashes", "strikes")
	attack_verb_simple = list("slams", "bashes", "strikes")
	attribute_requirements = list(TEMPERANCE_ATTRIBUTE = 20) //pesky clerks!

/obj/item/ego_weapon/mail_satchel/attack(atom/A, mob/living/user, proximity_flag, params)
	var/usertemp = (get_attribute_level(user, TEMPERANCE_ATTRIBUTE))
	var/temperance_mod = clamp((usertemp - 20) / 3 + 2, 0, 20)
	force = 12 + temperance_mod
	..()
	force = initial(force)
	damtype = initial(damtype)
	if(prob(30))
		new /obj/effect/temp_visual/maildecal(get_turf(A))
