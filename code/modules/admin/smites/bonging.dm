/datum/smite/Bongin
	name = "Bong Bong"

/datum/smite/Bongin/effect(client/user, mob/living/target)
	. = ..()
	var/mob/living/carbon/human/bong = target
	bong.hairstyle = "Floorlength Bedhead"
	bong.skin_tone = "albino"
	bong.eye_color = "000"
	bong.hair_color = "0033CC"
	bong.real_name = "Bong Bong"
	bong.facial_hairstyle = "Shaved"
	bong.update_hair()
	bong.update_body()
	bong.grant_language(/datum/language/bong, TRUE, TRUE, LANGUAGE_MIND)
