/mob/living/simple_animal/hostile/abnormality/someones_portrait
	name = "Someone's Portrait"
	desc = "A simple portrait, with a head, with red eyes, staring to somewhere or someone."
	pixel_y = 64
	base_pixel_y = 64
	density = FALSE
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "someones_portrait"
	icon_living = "someones_portrait"
	portrait = "someonesportrait"
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = list(30, 20, 10, 0, 0),
		ABNORMALITY_WORK_ATTACHMENT = list(45, 45, 40, 40, 40),
		ABNORMALITY_WORK_REPRESSION = list(55, 55, 50, 50, 50),
	)
	work_damage_amount = 7
	work_damage_type = WHITE_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)

	ego_list = list(
		/datum/ego_datum/weapon/snapshot,
		/datum/ego_datum/armor/snapshot,
	)
	gift_type = /datum/ego_gifts/snapshot
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

//TODO: Resprite + redo of this
	observation_prompt = "The portrait has been in our family's possession for a long time. <br>\
		They say it was of a very important relative of ours, but we do not recognize anyone present. <br>I've always hated the picture, why couldn't anyone else see it was just biding its time, waiting to strike?"
	observation_choices = list(
		"Destroy the picture" = list(TRUE, "One night, when everyone else was asleep, I snuck out of my room and found myself before that horrible thing. <br>\
			Retrieving a lighter from my pocket I flicked it on and held it to the painting... <br>\
			It turned out I was right, it was waiting to attack and I got into its striking range when no one else was around..."),
	)

//Initialize
/mob/living/simple_animal/hostile/abnormality/someones_portrait/PostSpawn()
	..()
	DestroyLights()

//Work
/mob/living/simple_animal/hostile/abnormality/someones_portrait/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) < 40 && get_attribute_level(user, PRUDENCE_ATTRIBUTE) < 40)
		PanicUser(user)
	DestroyLights()

/mob/living/simple_animal/hostile/abnormality/someones_portrait/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if (!(user.sanity_lost))
		PanicUser(user, TRUE)

/mob/living/simple_animal/hostile/abnormality/someones_portrait/Worktick(mob/living/carbon/human/user) //We apply hallucination every worktick due to varying work time
	if(!user.hallucination)
		user.hallucination += 3 //Attempt to get them to cancel work out of paranoia.

//Procs
/mob/living/simple_animal/hostile/abnormality/someones_portrait/proc/DestroyLights()
	for(var/obj/machinery/light/L in range(3, src)) //blows out the lights
		L.on = 1
		L.break_light_tube()

/mob/living/simple_animal/hostile/abnormality/someones_portrait/proc/PanicUser(mob/living/carbon/human/user, workfailure) //its over bros...
	to_chat(user, span_userdanger("He's going to get you! You've got to run!"))
	playsound(get_turf(user), 'sound/abnormalities/someonesportrait/panic.ogg', 40, FALSE, -5)
	user.adjustSanityLoss(user.maxSanity)
	if(!workfailure)
		addtimer(CALLBACK(src, PROC_REF(PanicCheck), user), 1) //Gives sanity time to update for forced panic type

/mob/living/simple_animal/hostile/abnormality/someones_portrait/proc/PanicCheck(mob/living/carbon/human/user) //forced wander panic
	var/mob/living/carbon/human/H = user
	if (H.sanity_lost)
		QDEL_NULL(H.ai_controller)
		H.ai_controller = /datum/ai_controller/insane/wander
		H.InitializeAIController()
		H.apply_status_effect(/datum/status_effect/panicked_type/wander)
		return
