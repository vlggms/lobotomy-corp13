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
