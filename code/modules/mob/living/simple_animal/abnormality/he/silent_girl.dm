//Coded by Lance/REDACTED. Started on 8/2/2022. First time lets do this.
// This is my last attempt at coding this. If this doesn't get merged or even tested in the first place I'm not gonna continue wasting my time.

/mob/living/simple_animal/hostile/abnormality/silent_girl
	name = "Silent Girl"
	desc = "A purple haired girl in a sundress. You see a metalic glint from behind her back..."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "silent_girl"
	maxHealth = 650
	health = 650
	gender = FEMALE // Is this used basically anywhere? Not that I know of. But seeing "Gender: Male" on Silent Girl doesn't seem right.
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.3, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 1.5)
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
	retreat_distance = 0
	faction = list("hostile", "neutral")
	ego_list = list(
		/datum/ego_datum/weapon/remorse,
		/datum/ego_datum/armor/remorse
		)
	gift_type = /datum/ego_gifts/remorse

	var/mob/living/carbon/human/guilty_people = list()
	var/mutable_appearance/guilt_icon  // Icon for the effect
	var/insanity_long = 30 SECONDS
	var/insanity_short = 10 SECONDS
	var/population_threshold = 5
	var/call_cooldown = 20 SECONDS
	var/party_cooldown = 5 MINUTES
	COOLDOWN_DECLARE(backup)
	COOLDOWN_DECLARE(party_leader)

/mob/living/simple_animal/hostile/abnormality/silent_girl/Initialize(mapload)
	. = ..()
	guilt_icon = mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "guilt", -MUTATIONS_LAYER) // Doesn't like me assigning this in the definition, so I assign it here.

/mob/living/simple_animal/hostile/abnormality/silent_girl/Life()
	. = ..()
	if(!.)
		return
	if(status_flags & GODMODE)
		return
	if(COOLDOWN_FINISHED(src, backup))
		var/list/human_list = list()
		for(var/mob/living/carbon/human/H in view(vision_range, src))
			human_list += H
		if(LAZYLEN(human_list))
			better_summon_backup(human_list)
	if(COOLDOWN_FINISHED(src, party_leader))
		for(var/obj/machinery/computer/abnormality/AW in shuffle(range(6, src)))
			if(isnull(AW.datum_reference.current))
				continue
			if(!(AW.datum_reference.current?.status_flags & GODMODE))
				continue
			AW.datum_reference.qliphoth_change(-1, src)
			COOLDOWN_START(src, party_leader, party_cooldown)
			playsound(get_turf(AW), 'sound/voice/human/womanlaugh.ogg', 75, 0, 20, ignore_walls = TRUE)
			break


/mob/living/simple_animal/hostile/abnormality/silent_girl/breach_effect(mob/living/carbon/human/user)
	. = ..()
	fear_level++
	COOLDOWN_START(src, party_leader, party_cooldown)
	COOLDOWN_START(src, backup, call_cooldown)

/mob/living/simple_animal/hostile/abnormality/silent_girl/proc/better_summon_backup(list/human_list = list())
	COOLDOWN_START(src, backup, call_cooldown)
	manual_emote("giggles.")
	playsound(get_turf(src), 'sound/voice/human/womanlaugh.ogg', 50, 0, 20, ignore_walls = TRUE)
	var/allies = 0
	for(var/mob/living/simple_animal/hostile/M in orange(20, src))
		if(faction_check_mob(M))
			if(M.AIStatus == AI_OFF)
				continue
			allies++
			if(LAZYLEN(human_list))
				if(allies > human_list.len)
					continue
				M.GiveTarget(human_list[allies])
				var/mob/living/carbon/human/H = human_list[allies]
				M.Goto(H,M.move_to_delay,M.minimum_distance)
				to_chat(H, "<span class='warning'>You feel a since of dread over take you...</span>")
			else
				M.Goto(src,M.move_to_delay,M.minimum_distance)
		if(allies >= 3 && !LAZYLEN(human_list))
			return

/mob/living/simple_animal/hostile/abnormality/silent_girl/proc/DriveInsane(mob/living/carbon/human/target)
	if (!target.sanity_lost)
		target.adjustSanityLoss(-500)
	QDEL_NULL(target.ai_controller)
	target.ai_controller = /datum/ai_controller/insane/release/silent_girl
	target.InitializeAIController()
	addtimer(CALLBACK(src, .proc/Kill_Guilty, target), 60 SECONDS) // If panicked after a minute, KILLS THEM
	return

/mob/living/simple_animal/hostile/abnormality/silent_girl/proc/Kill_Guilty(mob/living/carbon/human/target)
	if ((target in guilty_people) && target.sanity_lost)
		target.death(FALSE)
	return

/mob/living/simple_animal/hostile/abnormality/silent_girl/proc/Guilty_Work(datum/source, datum/abnormality/datum_sent, mob/living/carbon/human/user, work_type)
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
	if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) < 60 && !(user in guilty_people))
		Guilt_Effect(user)
	return ..()

/mob/living/simple_animal/hostile/abnormality/silent_girl/proc/Guilt_Effect(mob/living/carbon/human/user)
	if ((user.stat == DEAD) || (user in guilty_people))
		return
	datum_reference.qliphoth_change(-1)
	guilty_people += user
	user.physiology.work_success_mod *= 0.75 // Reduces global success rate by 25%
	to_chat(user, "<span class='userdanger'>You feel a heavy weight upon your shoulders.</span>")
	user.add_overlay(guilt_icon)
	playsound(get_turf(user), 'sound/abnormalities/silentgirl/Guilt_Apply.ogg', 50, 0, 2)
	RegisterSignal(user, COMSIG_WORK_COMPLETED, .proc/Guilty_Work)
	return

/mob/living/simple_animal/hostile/abnormality/silent_girl/attempt_work(mob/living/carbon/human/user, work_type)
	if (user in guilty_people)
		DriveInsane(user) //If a guilty person works on her, they panic.
	return ..()

/mob/living/simple_animal/hostile/abnormality/silent_girl/failure_effect(mob/living/carbon/human/user, work_type, pe)
	Guilt_Effect(user)
	return

/mob/living/simple_animal/hostile/abnormality/silent_girl/zero_qliphoth(mob/living/carbon/human/user)
	var/insanity_timer = insanity_short
	var/dead_list = guilty_people
	for(var/mob/living/carbon/human/dead_body in dead_list)
		if(dead_body.stat == DEAD || isnull(dead_body))
			guilty_people -= dead_body
	if (!LAZYLEN(guilty_people)) // No Guilty on 0 counter? Find a random person and take them <3
		var/list/potential_guilt = list()
		for(var/mob/living/carbon/human/H in GLOB.mob_living_list)
			if(H.stat >= HARD_CRIT || H.sanity_lost || z != H.z) // Dead or in hard crit, insane, or on a different Z level.
				continue
			potential_guilt += H
		if(LAZYLEN(potential_guilt))
			if(LAZYLEN(potential_guilt) < population_threshold)
				insanity_timer = insanity_long
			else
				insanity_timer = insanity_short
			Guilt_Effect(pick(potential_guilt))
		else
			manual_emote("giggles.")
			playsound(get_turf(src), 'sound/voice/human/womanlaugh.ogg', 50, 0, 20, ignore_walls = TRUE)
	for(var/mob/living/carbon/human/i in guilty_people) // Drive all Guilty people insane on Qliphoth 0
		to_chat(i, "<span class='userdanger'>You feel your head begin to split!</span>")
		addtimer(CALLBACK(src, .proc/DriveInsane, i), insanity_timer)
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
