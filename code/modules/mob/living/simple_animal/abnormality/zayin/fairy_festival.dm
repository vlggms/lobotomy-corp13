/mob/living/simple_animal/hostile/abnormality/fairy_festival
	name = "Fairy Festival"
	desc = "The abnormality is similar to a fairy, having two pairs of wings and a small body. The small fairies around it act as a cluster."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "fairy"
	icon_living = "fairy"
	maxHealth = 83
	health = 83
	is_flying_animal = TRUE
	threat_level = ZAYIN_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 70,
		ABNORMALITY_WORK_INSIGHT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_ATTACHMENT = list(70, 60, 50, 50, 50),
		ABNORMALITY_WORK_REPRESSION = list(50, 40, 30, 30, 30)
		)
	work_damage_amount = 6
	work_damage_type = RED_DAMAGE
	max_boxes = 10

	ego_list = list(
		/datum/ego_datum/weapon/wingbeat,
		/datum/ego_datum/armor/wingbeat
		)
	gift_type =  /datum/ego_gifts/wingbeat
	gift_message = "Fairy Dust covers your hands..."

	var/heal_duration = 90 SECONDS
	var/heal_amount = 0.02
	var/heal_cooldown = 2 SECONDS
	var/heal_cooldown_base = 2 SECONDS
	var/list/mob/living/carbon/human/protected_people = list()

/mob/living/simple_animal/hostile/abnormality/fairy_festival/proc/FairyHeal()
	for(var/mob/living/carbon/human/P in protected_people)
		if(heal_cooldown <= world.time)
			P.adjustBruteLoss(-heal_amount*P.getMaxHealth())
			P.adjustFireLoss(-heal_amount*P.getMaxHealth())
			P.adjustSanityLoss(heal_amount*P.getMaxSanity())
	heal_cooldown = (world.time + heal_cooldown_base)
	return

/mob/living/simple_animal/hostile/abnormality/fairy_festival/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	if(user.stat != DEAD && istype(user))
		if(user in protected_people)
			return
		protected_people += user
		RegisterSignal(user, COMSIG_WORK_STARTED, .proc/FairyGib)
		to_chat(user, "<span class='nicegreen'>You feel at peace under the fairies' care.</span>")
		playsound(get_turf(user), 'sound/abnormalities/fairyfestival/fairylaugh.ogg', 50, 0, 2)
		user.add_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "fairy_heal", -MUTATIONS_LAYER))
		addtimer(CALLBACK(src, .proc/FairyEnd, user), heal_duration)
	return

/mob/living/simple_animal/hostile/abnormality/fairy_festival/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	SuccessEffect(user, work_type, pe)
	return

/mob/living/simple_animal/hostile/abnormality/fairy_festival/Life()
	. = ..()
	if(protected_people.len)
		FairyHeal()

/mob/living/simple_animal/hostile/abnormality/fairy_festival/proc/FairyEnd(mob/living/carbon/human/user)
	protected_people.Remove(user)
	user.cut_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "fairy_heal", -MUTATIONS_LAYER))
	to_chat(user, "<span class='notice'>The fairies giggle before returning to their queen.</span>")
	UnregisterSignal(user, COMSIG_WORK_STARTED)
	return

/mob/living/simple_animal/hostile/abnormality/fairy_festival/proc/FairyGib(datum/source, datum/abnormality/datum_sent, mob/living/carbon/human/user, work_type)
	SIGNAL_HANDLER
	if(((user in protected_people) && datum_sent != datum_reference) && !(GODMODE in user.status_flags))
		to_chat(user, "<span class='userdanger'>With a beat of their wings, the fairies pounce on you and ravenously consume your body!</span>")
		playsound(get_turf(user), 'sound/magic/demon_consume.ogg', 75, 0)
		UnregisterSignal(user, COMSIG_WORK_STARTED)
		protected_people.Remove(user)
		user.gib()
	return


