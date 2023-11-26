/obj/structure/toolabnormality/golden_bough
	name = "golden bough"
	desc = "You feel it calling for you. You MUST grab it"
	icon_state = "realization"

/obj/structure/toolabnormality/golden_bough/examine(mob/user)
	. = ..()
	. += "<span class='info'>Pressing it while on help intent will breach all abnormalities instead of ending the shift.</span>"

//I had to.
/obj/structure/toolabnormality/golden_bough/attack_hand(mob/living/carbon/human/user)
	for(var/mob/M in GLOB.player_list)
		to_chat(M, "<span class='userdanger'>[uppertext(user.real_name)] is gathering the bough!.</span>")
	if(do_after(src, 30 SECONDS))
		RoundEndEffect(user)

/obj/structure/toolabnormality/golden_bough/proc/RoundEndEffect(mob/living/carbon/human/user)
	SSticker.force_ending = 1
	for(var/mob/M in GLOB.player_list)
		to_chat(M, "<span class='userdanger'>[uppertext(user.real_name)] has gathered the bough! Limbus Company is successful!.</span>")

/obj/effect/mob_spawn/human/lccb
	name = "LCCB Agent"
	desc = "A humming cryo pod. You can barely recognise an engineering uniform underneath the built up ice. The machine is attempting to wake up its occupant."
	mob_name = "an lccb agent"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	roundstart = FALSE
	death = FALSE
	mob_species = /datum/species/human
	short_desc = "You are an LCCB Agent, assisting in a suppression."
	flavour_text = "You have a goal - To Shoot.."
	uniform = /obj/item/clothing/under/rank/security/officer/grey
	suit = /obj/item/clothing/suit/armor/vest
	l_hand = /obj/item/gun/ego_gun/sodashotty
	shoes = /obj/item/clothing/shoes/workboots
	id = /obj/item/card/id/away/old/eng
	assignedrole = "LCCB Agent"

/obj/effect/mob_spawn/human/lccb/Destroy()
	return
