//Coded by Lance/REDACTED. Started on 8/2/2022. First time lets do this.
// This is my last attempt at coding this. If this doesn't get merged or even tested in the first place I'm not gonna continue wasting my time.

/mob/living/simple_animal/hostile/abnormality/silent_girl
	name = "Silent Girl"
	desc = "A purple haired girl in a sundress. You see a metalic glint from behind her back..."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "silent_girl"
	maxHealth = 650
	health = 650
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
	var/mob/living/carbon/human/guilty_people = list()
	var/mutable_appearance/guilt_icon  // Icon for the effect

/mob/living/simple_animal/hostile/abnormality/silent_girl/proc/DriveInsane(mob/living/carbon/human/target)
	target.adjustSanityLoss(-500)
	QDEL_NULL(ai_controller)
	target.ai_controller = /datum/ai_controller/insane/release/silent_girl
	ghostize(1)
	target.InitializeAIController()
	addtimer(CALLBACK(src, .proc/killguilty, target), 600) // If panicked after a minute, KILLS THEM | ADDENDUM: Will eventually function like this, given AI removal becomes prevalent
	return

/mob/living/simple_animal/hostile/abnormality/silent_girl/proc/killguilty(mob/living/carbon/human/target)
	target.adjustBruteLoss(500)
	return
	// INSERT AI REMOVAL CODE HERE

/mob/living/simple_animal/hostile/abnormality/silent_girl/proc/guilty_work(datum/source, datum/abnormality/datum_sent, mob/living/carbon/human/user, work_type)
	SIGNAL_HANDLER
	if (((user in guilty_people) == 0) || work_type != ABNORMALITY_WORK_ATTACHMENT)
		return
	guilty_people -= user
	user.physiology.work_success_mod /= 0.75
	user.cut_overlay(guilt_icon)
	if (user.stat == DEAD)
		return
	to_chat(user, "<span class='nicegreen'>You feel a weight lift from your shoulders.</span>")
	playsound(get_turf(user), 'sound/abnormalities/silentgirl/Guilt_Remove.ogg', 50, 0, 2)
	datum_reference.qliphoth_change(1)
	UnregisterSignal(user, COMSIG_WORK_COMPLETED)
	return

/mob/living/simple_animal/hostile/abnormality/silent_girl/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
	if((user in guilty_people) == 1) // In statement uses 0 for not present, 1 for present
		return ..()
	if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) < 60)
		Guilt_Effect(user)
	return ..()

/mob/living/simple_animal/hostile/abnormality/silent_girl/proc/Guilt_Effect(mob/living/carbon/human/user)
	datum_reference.qliphoth_change(-1)
	guilty_people += user
	user.physiology.work_success_mod *= 0.75 // Reduces global success rate by 25%
	to_chat(user, "<span class='userdanger'>You feel a heavy weight upon your shoulders.</span>")
	guilt_icon = mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "guilt", -MUTATIONS_LAYER)
	user.add_overlay(guilt_icon)
	playsound(get_turf(user), 'sound/abnormalities/silentgirl/Guilt_Apply.ogg', 50, 0, 2)
	RegisterSignal(user, COMSIG_WORK_COMPLETED, .proc/guilty_work)
	return

/mob/living/simple_animal/hostile/abnormality/silent_girl/attempt_work(mob/living/carbon/human/user, work_type)
	if ((user in guilty_people) == 1)
		DriveInsane(user) //If a guilty person works on her, they panic.
	return ..()

/mob/living/simple_animal/hostile/abnormality/silent_girl/failure_effect(mob/living/carbon/human/user, work_type, pe)
	Guilt_Effect(user)
	return

/mob/living/simple_animal/hostile/abnormality/silent_girl/zero_qliphoth(mob/living/carbon/human/user)
	if (!LAZYLEN(guilty_people)) // No Guilty on 0 counter? Find a random person and take them <3
		for(var/mob/living/carbon/human/sucker in GLOB.mob_living_list)
			if(!sucker.sanity_lost && sucker.stat != DEAD)
				guilty_people += sucker
				break
	for(var/i in guilty_people) // Drive all Guilty people insane on Qliphoth 0
		DriveInsane(i)
	datum_reference.qliphoth_change(3)
	return

//Whitelake makes a good point with the different lines, so I thought it'd be cool
/datum/ai_controller/insane/release/silent_girl
	lines_type = /datum/ai_behavior/say_line/insanity_silent_girl

/datum/ai_behavior/say_line/insanity_silent_girl
	lines = list(
				"It's all my fault...",
				"Right... I caused this...",
				"I can still hear their voices...",
				"If I do this, will their voices finally end?",
				"The only way to atone is this..."
				)
