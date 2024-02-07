//This one will get messy.
//Anything Zwei related goes here. That's Zwei, Streetlight and anything else under Zwei.
//Base Zwei is Grade 6, Vet is Grade 5.

/obj/item/ego_weapon/city/zweihander
	name = "zweihander"
	desc = "A zweihander used by the zwei association."
	special = "Use in hand to buff your defense, and those of everyone around you."
	icon_state = "zwei"
	force = 55
	attack_speed = 2
	damtype = RED_DAMAGE

	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	var/ready = TRUE
	var/defense_buff_self = 0.5
	var/defense_buff_others = 0.8
	var/list/buffed_people = list()
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 40,
		TEMPERANCE_ATTRIBUTE = 40,
		JUSTICE_ATTRIBUTE = 40,
	)


/obj/item/ego_weapon/city/zweihander/attack_self(mob/living/carbon/human/user)
	..()
	if(!CanUseEgo(user))
		return

	if(!ready)
		return
	ready = FALSE
	user.Immobilize(3 SECONDS)
	user.physiology.red_mod *= defense_buff_self
	user.physiology.white_mod *= defense_buff_self
	user.physiology.black_mod *= defense_buff_self
	user.physiology.pale_mod *= defense_buff_self
	to_chat(user, span_userdanger("HOLD THE LINE!"))

	buffed_people = list()

	for(var/mob/living/carbon/human/L in orange(5, get_turf(user)))
		L.physiology.red_mod *= defense_buff_others
		L.physiology.white_mod *= defense_buff_others
		L.physiology.black_mod *= defense_buff_others
		L.physiology.pale_mod *= defense_buff_others
		buffed_people += L

		//Visible message just didn't work here. No clue why.
		to_chat(L, span_userdanger("HOLD THE LINE!"))

	playsound(src, 'sound/misc/whistle.ogg', 50, TRUE)
	addtimer(CALLBACK(src, PROC_REF(Return), user), 3 SECONDS)

/obj/item/ego_weapon/city/zweihander/proc/Return(mob/living/carbon/human/user)
	user.physiology.red_mod /= defense_buff_self
	user.physiology.white_mod /= defense_buff_self
	user.physiology.black_mod /= defense_buff_self
	user.physiology.pale_mod /= defense_buff_self
	to_chat(user, span_notice("Your defense buff has expired!"))

	for(var/mob/living/carbon/human/L in buffed_people)
		L.physiology.red_mod /= defense_buff_others
		L.physiology.white_mod /= defense_buff_others
		L.physiology.black_mod /= defense_buff_others
		L.physiology.pale_mod /= defense_buff_others
		to_chat(L, span_notice("Your defense buff has expired!"))

	addtimer(CALLBACK(src, PROC_REF(Cooldown), user), 15 SECONDS)

/obj/item/ego_weapon/city/zweihander/proc/Cooldown(mob/living/carbon/human/user)
	ready = TRUE
	to_chat(user, span_notice("You can use your defense buff again."))

//Vet Zwei
/obj/item/ego_weapon/city/zweihander/vet
	name = "veteran zweihander"
	desc = "A zweihander used by veterans of the zwei association."
	icon_state = "zwei_vet"
	force = 80
	defense_buff_self = 0.3
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

//Mini Zwei
/obj/item/ego_weapon/city/zweihander/knife
	name = "einhander"
	desc = "A shortsword used by some zwei personnel."
	icon_state = "zwei_mini"
	force = 32
	attack_speed = 1

//Noreqs for the ERT
/obj/item/ego_weapon/city/zweihander/noreq
	attribute_requirements = list()

/obj/item/ego_weapon/city/zweihander/vet/noreq
	attribute_requirements = list()

//the funny zwei baton
/obj/item/ego_weapon/city/zweibaton
	name = "zwei association baton"
	desc = "A riot club used by the zwei association."
	special = "Attack a human to stun them after a period of time."
	icon_state = "zwei_baton"
	inhand_icon_state = "zwei_baton"
	force = 30
	attack_speed = 2
	damtype = RED_DAMAGE

	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 40,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)


/obj/item/ego_weapon/city/zweibaton/attack(mob/living/target, mob/living/carbon/human/user)
	..()
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/T = target
	T.Jitter(20)
	T.set_confusion(max(10, T.get_confusion()))
	T.stuttering = max(8, T.stuttering)
	T.apply_damage(force, STAMINA, BODY_ZONE_CHEST)

	SEND_SIGNAL(T, COMSIG_LIVING_MINOR_SHOCK)

	playsound(src, 'sound/weapons/egloves.ogg', 50, TRUE, -1)


