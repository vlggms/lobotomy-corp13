//Coded by Lance/REDACTED. Started on 8/2/2022. First time lets do this.

/mob/living/simple_animal/hostile/abnormality/silent_girl
	name = "Silent Girl"
	desc = "A purple haired girl in a sundress. You see a metalic glint from behind her back..."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "silent_girl"
	maxHealth = 650
	health = 650
	threat_level = HE_LEVEL
	work_chances = list(
						ABNORMALITY_WORK_INSTINCT = 10,
						ABNORMALITY_WORK_INSIGHT = list(-50, -50, 40, 45, 50),
						ABNORMALITY_WORK_ATTACHMENT = -50,
						ABNORMALITY_WORK_REPRESSION = list(40, 45, 50, 55, 60)
						)
	work_damage_amount = 0
	work_damage_type = WHITE_DAMAGE
	start_qliphoth = 4

	ego_list = list(
		/datum/ego_datum/weapon/remorse,
		/datum/ego_datum/armor/remorse
		)
	var/mob/living/carbon/human/guilty_people = list()
	var/mutable_appearance/guiltIcon  // Icon for the effect

/mob/living/simple_animal/hostile/abnormality/silent_girl/proc/DriveInsane(mob/living/carbon/human/target)
	target.adjustSanityLoss(-500)
	QDEL_NULL(ai_controller)
	target.ai_controller = /datum/ai_controller/insane/release/silent_girl
	ghostize(1)
	target.InitializeAIController()
	addtimer(CALLBACK(src, .proc/killguilty, target), 600) // If panicked after a minute, KILLS THEM | ADDENDUM: Will eventually function like this
	return

/mob/living/simple_animal/hostile/abnormality/silent_girl/proc/killguilty(mob/living/carbon/human/target)
	target.adjustBruteLoss(500)
	return
	// INSERT AI REMOVAL CODE HERE

/mob/living/simple_animal/hostile/abnormality/silent_girl/proc/guilty_work(mob/living/carbon/human/user)
	if ((user in guilty_people) == 0)
		return
	if (user.stat == DEAD)
		guilty_people -= user
		user.physiology.work_success_mod += 0.25
		user.cut_overlay(guiltIcon)
		return
	if (user.sanity_lost)
		addtimer(CALLBACK(src, .proc/guilty_work, user), 150)
		return
	guilty_people -= user
	user.physiology.work_success_mod += 0.25
	user.cut_overlay(guiltIcon)
	to_chat(user, "<span class='nicegreen'>You feel a weight lift from your shoulders.</span>")
	playsound(get_turf(user), 'sound/abnormalities/silentgirl/Guilt_Remove.ogg', 50, 0, 2)
	datum_reference.qliphoth_change(1)
	return

/mob/living/simple_animal/hostile/abnormality/silent_girl/work_complete(mob/living/carbon/human/user, work_type, pe, work_time)
	if((user in guilty_people) == 1) // In statement uses 0 for not present, 1 for present
		return ..()
	if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) < 60)
		datum_reference.qliphoth_change(-1)
		guilty_people += user
		user.physiology.work_success_mod -= 0.25 // Reduces global success rate by 25%
		to_chat(user, "<span class='userdanger'>You feel a heavy weight upon your shoulders.</span>")
		guiltIcon = mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "guilt", -MUTATIONS_LAYER)
		user.add_overlay(guiltIcon)
		addtimer(CALLBACK(src, .proc/guilty_work, user), 600) // Lasts for 1 minute. Temporary until Signals get fixed.
		playsound(get_turf(user), 'sound/abnormalities/silentgirl/Guilt_Apply.ogg', 50, 0, 2)
	return ..()

/mob/living/simple_animal/hostile/abnormality/silent_girl/attempt_work(mob/living/carbon/human/user, work_type)
	if ((user in guilty_people) == 0)
		return ..()
	DriveInsane(user) //If a guilty person works on her, they panic.
	return FALSE

/mob/living/simple_animal/hostile/abnormality/silent_girl/zero_qliphoth(mob/living/carbon/human/user)
	var/i
	for(i in guilty_people) // Drive all Guilty people insane on Qliphoth 0
		DriveInsane(i)
	datum_reference.qliphoth_change(4)
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
