//This one will get messy.
//Anything Zwei related goes here. That's Zwei, Streetlight and anything else under Zwei.
//Base Zwei is Grade 6, Vet is Grade 5.
//Fixer garbo is Grade 7.

/obj/item/ego_weapon/city/zweihander
	name = "zweihander"
	desc = "A zweihander used by the zwei association."
	special = "Use in hand to buff your defense, and those of everyone around you."
	icon_state = "zwei"
	inhand_icon_state = "zwei"
	force = 55
	attack_speed = 2
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	inhand_icon_state = "claymore"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
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
							JUSTICE_ATTRIBUTE = 40
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
	to_chat(user, "<span class='userdanger'>HOLD THE LINE!</span>")

	buffed_people = list()

	for(var/mob/living/carbon/human/L in orange(5, get_turf(user)))
		L.physiology.red_mod *= defense_buff_others
		L.physiology.white_mod *= defense_buff_others
		L.physiology.black_mod *= defense_buff_others
		L.physiology.pale_mod *= defense_buff_others
		buffed_people += L

		//Visible message just didn't work here. No clue why.
		to_chat(L, "<span class='userdanger'>HOLD THE LINE!</span>")

	playsound(src, 'sound/misc/whistle.ogg', 50, TRUE)
	addtimer(CALLBACK(src, .proc/Return, user), 3 SECONDS)

/obj/item/ego_weapon/city/zweihander/proc/Return(mob/living/carbon/human/user)
	user.physiology.red_mod /= defense_buff_self
	user.physiology.white_mod /= defense_buff_self
	user.physiology.black_mod /= defense_buff_self
	user.physiology.pale_mod /= defense_buff_self
	to_chat(user, "<span class='notice'>Your defense buff has expired!</span>")

	for(var/mob/living/carbon/human/L in buffed_people)
		L.physiology.red_mod /= defense_buff_others
		L.physiology.white_mod /= defense_buff_others
		L.physiology.black_mod /= defense_buff_others
		L.physiology.pale_mod /= defense_buff_others
		to_chat(L, "<span class='notice'>Your defense buff has expired!</span>")

	addtimer(CALLBACK(src, .proc/Cooldown, user), 15 SECONDS)

/obj/item/ego_weapon/city/zweihander/proc/Cooldown(mob/living/carbon/human/user)
	ready = TRUE
	to_chat(user, "<span class='notice'>You can use your defense buff again.</span>")

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

//Noreqs for the ERT
/obj/item/ego_weapon/city/zweihander/noreq
	attribute_requirements = list()

/obj/item/ego_weapon/city/zweihander/vet/noreq
	attribute_requirements = list()

//Streetlight stuff, this is all Grade 7 teth stuff, leader is grade 6.
//They're generic weapons for the refinery, which is fine
/obj/item/ego_weapon/city/streetlight_greatsword
	name = "streetlight greatsword"
	desc = "A greatsword used by the streelight office."
	icon_state = "streetlight_greatsword"
	force = 38
	attack_speed = 2
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	inhand_icon_state = "claymore"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")

/obj/item/ego_weapon/city/streetlight_bat
	name = "streetlight office bat"
	desc = "A yellow and black bat used by the streetlight office."
	icon_state = "streetlight_bat"
	force = 30
	attack_speed = 1.5
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")

/obj/item/ego_weapon/city/streetlight_bat/attack(mob/living/target, mob/living/user)
	if(!..())
		return
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user)

//He has zwei moves in his 2nd iteration, give it to him here.
/obj/item/ego_weapon/city/zweihander/streetlight_baton
	name = "streetlight office baton"
	desc = "A  baton used by the founder of the streetlight office."
	icon_state = "streetlight_founder"
	force = 32
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")
	defense_buff_self = 0.6
	defense_buff_others = 0.9
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 40,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)
