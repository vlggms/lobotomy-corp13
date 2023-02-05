//I think I want to do the idea of temptation.
//The works are always max but you can only do it 3 times per person.	-Kirie
/mob/living/simple_animal/hostile/abnormality/fan
	name = "F.A.N."
	desc = "It appears to be an office fan."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "fan"
	maxHealth = 400
	health = 400
	threat_level = HE_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 100,
		ABNORMALITY_WORK_INSIGHT = 100,
		ABNORMALITY_WORK_ATTACHMENT = 100,
		ABNORMALITY_WORK_REPRESSION = 100
	)
	work_damage_amount = 5	//This literally does not matter
	work_damage_type = RED_DAMAGE
	max_boxes = 12

	ego_list = list(
		/datum/ego_datum/weapon/metal,
		/datum/ego_datum/armor/metal
	)
	var/list/safe = list()
	var/list/warning = list()
	var/list/danger = list()
	var/successcount

/mob/living/simple_animal/hostile/abnormality/fan/WorkChance(mob/living/carbon/human/user, chance)
	return 100 - (successcount*2)

/mob/living/simple_animal/hostile/abnormality/fan/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	..()
	successcount+=1

/mob/living/simple_animal/hostile/abnormality/fan/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user in danger)
		to_chat(user, "<span class='danger'>Oh.</span>")
		user.throw_at(src, 10, 10, user, spin = TRUE, gentle = FALSE, quickstart = TRUE)
		SLEEP_CHECK_DEATH(3)
		playsound(loc, 'sound/machines/juicer.ogg', 100, TRUE)
		user.gib()

	else if(user in warning)
		danger+=user
		to_chat(user, "<span class='nicegreen'>You feel elated.</span>")

	else if(user in safe)
		warning+=user
		to_chat(user, "<span class='nicegreen'>You feel refreshed.</span>")

	else
		safe+=user
		to_chat(user, "<span class='nicegreen'>You could use some more.</span>")
