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

	var/heal_duration = 120 SECONDS
	var/heal_amount = 0.05
	var/heal_cooldown = 2 SECONDS
	var/heal_cooldown_base = 2 SECONDS
	var/list/mob/living/carbon/human/protected_people = list()
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/fairy_gentleman = 1.5,
		/mob/living/simple_animal/hostile/abnormality/fairy_longlegs = 1.5,
		// Fae Lantern = 1.5
	)

	chem_type = /datum/reagent/abnormality/fairy_festival
	harvest_phrase = span_notice("A fairy presents you a small flower, then pours its contents into %VESSEL.")
	harvest_phrase_third = "A fairy presents %PERSON with a small flower, then pours it into %VESSEL."

/mob/living/simple_animal/hostile/abnormality/fairy_festival/proc/FairyHeal()
	for(var/mob/living/carbon/human/P in protected_people)
		if(heal_cooldown <= world.time)
			P.adjustBruteLoss(-heal_amount*P.getMaxHealth())
			P.adjustFireLoss(-heal_amount*P.getMaxHealth())
	heal_cooldown = (world.time + heal_cooldown_base)
	return

/mob/living/simple_animal/hostile/abnormality/fairy_festival/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	if(user.stat != DEAD && istype(user))
		if(user in protected_people)
			return
		flick("fairy_blessing",src)
		protected_people += user
		RegisterSignal(user, COMSIG_WORK_STARTED, .proc/FairyPause)
		RegisterSignal(user, COMSIG_WORK_COMPLETED, .proc/FairyRestart)
		to_chat(user, span_nicegreen("You feel at peace under the fairies' care."))
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
	to_chat(user, span_notice("The fairies giggle before returning to their queen."))
	UnregisterSignal(user, COMSIG_WORK_STARTED)
	UnregisterSignal(user, COMSIG_WORK_COMPLETED)
	return

/mob/living/simple_animal/hostile/abnormality/fairy_festival/proc/FairyPause(datum/source, datum/abnormality/datum_sent, mob/living/carbon/human/user, work_type)
	SIGNAL_HANDLER
	if (datum_sent != datum_reference)
		return
	to_chat(user, span_notice("The fairies suddenly go eerily quiet."))
	protected_people.Remove(user)

/mob/living/simple_animal/hostile/abnormality/fairy_festival/proc/FairyRestart(datum/source, datum/abnormality/datum_sent, mob/living/carbon/human/user, work_type)
	SIGNAL_HANDLER
	to_chat(user, span_nicegreen("The fairies start giggling and playing once more."))
	protected_people += user
	playsound(get_turf(user), 'sound/abnormalities/fairyfestival/fairylaugh.ogg', 50, 0, 2)

//not called by anything anymore, left here if somebody wants to readd it later for any reason.
/mob/living/simple_animal/hostile/abnormality/fairy_festival/proc/FairyGib(datum/source, datum/abnormality/datum_sent, mob/living/carbon/human/user, work_type)
	SIGNAL_HANDLER
	if(((user in protected_people) && datum_sent != datum_reference) && !(GODMODE in user.status_flags))
		to_chat(user, span_userdanger("With a beat of their wings, the fairies pounce on you and ravenously consume your body!"))
		playsound(get_turf(user), 'sound/magic/demon_consume.ogg', 75, 0)
		UnregisterSignal(user, COMSIG_WORK_STARTED)
		UnregisterSignal(user, COMSIG_WORK_COMPLETED)
		protected_people.Remove(user)
		user.gib()
	return

/datum/reagent/abnormality/fairy_festival
	name = "Nectar of an Unknown Flower"
	description = "The fairies got this for you..."
	color = "#e4d0b2"
	health_restore = 2
	armor_mods = list(-2, 0, 0, 0)
