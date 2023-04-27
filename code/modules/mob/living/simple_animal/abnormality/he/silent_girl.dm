//Coded by Lance/REDACTED. Started on 8/2/2022. First time lets do this.
// This is my last attempt at coding this. If this doesn't get merged or even tested in the first place I'm not gonna continue wasting my time.

// GUESS WHO, THAT'S RIGHT, IT'S ME! Lance/REDACTED! Back at it 3 months later! Refactor this bitch!

#define STATUS_EFFECT_SG_GUILTY /datum/status_effect/sg_guilty
#define STATUS_EFFECT_SG_ATTONEMENT /datum/status_effect/sg_atonement

/mob/living/simple_animal/hostile/abnormality/silent_girl
	name = "Silent Girl"
	desc = "A purple haired girl in a sundress. You see a metalic glint from behind her back..."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "silent_girl"
	maxHealth = 650
	health = 650
	gender = FEMALE // Is this used basically anywhere? Not that I know of. But seeing "Gender: Male" on Silent Girl doesn't seem right.
	threat_level = HE_LEVEL
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 25,
						ABNORMALITY_WORK_INSIGHT = list(-50, -50, 60, 60, 60),
						ABNORMALITY_WORK_ATTACHMENT = -50,
						ABNORMALITY_WORK_REPRESSION = list(50, 55, 55, 60, 60)
						)
	work_damage_amount = 0
	work_damage_type = WHITE_DAMAGE
	start_qliphoth = 3

	ego_list = list(
		/datum/ego_datum/weapon/remorse,
		/datum/ego_datum/armor/remorse
		)
	gift_type = /datum/ego_gifts/remorse
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK


/mob/living/simple_animal/hostile/abnormality/silent_girl/proc/OnWorkStart(datum/source, datum/abnormality/datum_reference, mob/living/carbon/human/user, work_type)
	SIGNAL_HANDLER
	if(user.stat == DEAD)
		return FALSE
	if(work_type != ABNORMALITY_WORK_ATTACHMENT)
		return FALSE
	if(datum_reference == src.datum_reference)
		return FALSE
	if(user.has_status_effect(STATUS_EFFECT_SG_GUILTY))
		user.remove_status_effect(STATUS_EFFECT_SG_GUILTY)
		datum_reference.qliphoth_change(1)
	else if(user.has_status_effect(STATUS_EFFECT_SG_ATTONEMENT))
		user.remove_status_effect(STATUS_EFFECT_SG_ATTONEMENT)

/mob/living/simple_animal/hostile/abnormality/silent_girl/proc/Guilt_Effect(mob/living/carbon/human/user)
	if ((user.stat == DEAD) || (user.has_status_effect(STATUS_EFFECT_SG_GUILTY)))
		return
	datum_reference.qliphoth_change(-1)
	user.apply_status_effect(STATUS_EFFECT_SG_GUILTY, datum_reference)
	return

/mob/living/simple_animal/hostile/abnormality/silent_girl/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) < 60 && !user.has_status_effect(STATUS_EFFECT_SG_GUILTY))
		Guilt_Effect(user)
	return

/mob/living/simple_animal/hostile/abnormality/silent_girl/AttemptWork(mob/living/carbon/human/user, work_type)
	if (user.has_status_effect(STATUS_EFFECT_SG_GUILTY) || user.has_status_effect(STATUS_EFFECT_SG_ATTONEMENT))
		user.apply_status_effect(STATUS_EFFECT_SG_ATTONEMENT, datum_reference) //If a guilty person works on her, they panic.
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/silent_girl/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	Guilt_Effect(user)
	return

/mob/living/simple_animal/hostile/abnormality/silent_girl/ZeroQliphoth(mob/living/carbon/human/user)
	var/list/guilty_people = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.has_status_effect(STATUS_EFFECT_SG_GUILTY))
			guilty_people += H
	if(guilty_people.len == 0)
		for(var/mob/living/carbon/human/PG in GLOB.player_list)
			if(PG.z != src.z)
				continue
			if(PG.stat >= HARD_CRIT)
				continue
			if(PG.sanity_lost)
				continue
			guilty_people += PG
			break
		if(guilty_people.len == 0)
			manual_emote("giggles.")
			sound_to_playing_players_on_level('sound/voice/human/womanlaugh.ogg', 50, zlevel = z)
	for(var/mob/living/carbon/human/GP in guilty_people) // Drive all Guilty people insane on Qliphoth 0
		GP.apply_status_effect(STATUS_EFFECT_SG_ATTONEMENT, datum_reference)
	datum_reference.qliphoth_change(3)
	return

//Whitelake makes a good point with the different lines, so I thought it'd be cool
/datum/ai_controller/insane/release/silent_girl
	lines_type = /datum/ai_behavior/say_line/insanity_silent_girl

/datum/ai_controller/insane/suicide/silent_girl
	lines_type = /datum/ai_behavior/say_line/insanity_silent_girl

/datum/ai_behavior/say_line/insanity_silent_girl
	lines = list(
				"It's all my fault...",
				"Right... I caused this...",
				"I can still hear their voices...",
				"If I do this, will their voices finally end?",
				"The only way to atone is this..."
				)

/datum/status_effect/sg_guilty
	id = "sg_guilt"
	status_type = STATUS_EFFECT_REPLACE
	// Duration left at default -1
	alert_type = /atom/movable/screen/alert/status_effect/sg_guilty
	var/mutable_appearance/guilt_icon
	var/datum/abnormality/datum_reference = null

/atom/movable/screen/alert/status_effect/sg_guilty
	name = "Guilty"
	desc = "A heavy weight lays upon you. What have you done?"

/datum/status_effect/sg_guilty/on_creation(mob/living/new_owner, ...)
	src.datum_reference = args[2]
	guilt_icon = mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "guilt", -MUTATIONS_LAYER)
	return ..()

/datum/status_effect/sg_guilty/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		to_chat(H, "<span class='userdanger'>You feel a heavy weight upon your shoulders.</span>")
		playsound(get_turf(H), 'sound/abnormalities/silentgirl/Guilt_Apply.ogg', 50, 0, 2)
		H.add_overlay(guilt_icon)
		H.physiology.work_success_mod *= 0.75
		RegisterSignal(H, COMSIG_WORK_STARTED, .proc/OnWorkStart)

/datum/status_effect/sg_guilty/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		to_chat(H, "<span class='nicegreen'>You feel a weight lift from your shoulders.</span>")
		playsound(get_turf(H), 'sound/abnormalities/silentgirl/Guilt_Remove.ogg', 50, 0, 2)
		H.cut_overlay(guilt_icon)
		H.physiology.work_success_mod /= 0.75
		UnregisterSignal(H, COMSIG_WORK_STARTED)

/datum/status_effect/sg_guilty/be_replaced()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.cut_overlay(guilt_icon)
		H.physiology.work_success_mod /= 0.75
		UnregisterSignal(H, COMSIG_WORK_STARTED)
	return ..()

/datum/status_effect/sg_guilty/proc/OnWorkStart(datum/source, datum/abnormality/abno_reference, mob/living/carbon/human/user, work_type)
	SIGNAL_HANDLER
	if(work_type != ABNORMALITY_WORK_ATTACHMENT)
		return FALSE
	if(abno_reference == datum_reference)
		return FALSE
	if(!isnull(datum_reference))
		addtimer(CALLBACK(datum_reference, /datum/abnormality/proc/qliphoth_change, 1))
	UnregisterSignal(user, COMSIG_WORK_STARTED)
	user.remove_status_effect(src)

// End GUILTY //

/datum/status_effect/sg_atonement
	id = "sg_guilt"
	status_type = STATUS_EFFECT_REPLACE
	// Duration left at default -1
	alert_type = /atom/movable/screen/alert/status_effect/sg_atonement
	var/mutable_appearance/guilt_icon
	var/datum/abnormality/datum_reference = null
	var/insanity_time = 0
	var/death_time = 0
	var/driven_insane = FALSE

/atom/movable/screen/alert/status_effect/sg_atonement
	name = "Atonement"
	desc = "I can't believe I've done all these horrible things... All those people..."

/datum/status_effect/sg_atonement/on_creation(mob/living/new_owner, ...)
	src.datum_reference = args[2]
	guilt_icon = mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "guilt", -MUTATIONS_LAYER)
	insanity_time = (GLOB.player_list.len <= 5 ? 30 SECONDS : 10 SECONDS) + world.time
	death_time = insanity_time + 45 SECONDS
	return ..()

/datum/status_effect/sg_atonement/tick()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner // Get human version of owner
	if(driven_insane && !H.sanity_lost) // If we drove them insane and they're no longer insane, revert to normal debuff.
		H.apply_status_effect(STATUS_EFFECT_SG_GUILTY, datum_reference)
		return
	if((insanity_time < world.time) && !driven_insane)
		H.adjustSanityLoss(H.sanityhealth*2) // Do double their current sanity in damage, driving them insane instantly.
		QDEL_NULL(H.ai_controller)
		H.ai_controller = /datum/ai_controller/insane/release/silent_girl
		H.InitializeAIController()
		H.apply_status_effect(/datum/status_effect/panicked_type/release)
		driven_insane = TRUE
	if((death_time < world.time) && H.sanity_lost) // If they're past the time and still insane, they go into suicide panic
		if(HAS_AI_CONTROLLER_TYPE(H, /datum/ai_controller/insane/release/silent_girl))
			QDEL_NULL(H.ai_controller)
			H.ai_controller = /datum/ai_controller/insane/suicide/silent_girl
			H.InitializeAIController()
			H.apply_status_effect(/datum/status_effect/panicked_type/suicide)


/datum/status_effect/sg_atonement/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		playsound(get_turf(H), 'sound/abnormalities/silentgirl/Guilt_Apply.ogg', 50, 0, 2)
		to_chat(H, "<span class='userdanger'>You feel your head begin to split!</span>")
		H.add_overlay(guilt_icon)
		RegisterSignal(H, COMSIG_WORK_STARTED, .proc/OnWorkStart)

/datum/status_effect/sg_atonement/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		to_chat(H, "<span class='nicegreen'>You feel a weight lift from your shoulders.</span>")
		playsound(get_turf(H), 'sound/abnormalities/silentgirl/Guilt_Remove.ogg', 50, 0, 2)
		H.cut_overlay(guilt_icon)
		UnregisterSignal(H, COMSIG_WORK_STARTED)

/datum/status_effect/sg_atonement/be_replaced()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.cut_overlay(guilt_icon)
		UnregisterSignal(H, COMSIG_WORK_COMPLETED)
	return ..()

/datum/status_effect/sg_atonement/proc/OnWorkStart(datum/source, datum/abnormality/abno_reference, mob/living/carbon/human/user, work_type)
	SIGNAL_HANDLER
	if(work_type != ABNORMALITY_WORK_ATTACHMENT)
		return FALSE
	if(abno_reference == datum_reference)
		return FALSE
	if(!isnull(datum_reference))
		addtimer(CALLBACK(datum_reference, /datum/abnormality/proc/qliphoth_change, 1))
	UnregisterSignal(user, COMSIG_WORK_STARTED)
	user.remove_status_effect(src)

#undef STATUS_EFFECT_SG_GUILTY
#undef STATUS_EFFECT_SG_ATTONEMENT
