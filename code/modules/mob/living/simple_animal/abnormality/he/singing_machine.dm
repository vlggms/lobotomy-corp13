/*
Coded by nutterbutter, "senior" junior developer, during hell week 2022.
Finally, an abnormality that DOESN'T have to do any fancy movement shit. It's a miracle. Praise be.
*/
#define STATUS_EFFECT_MUSIC /datum/status_effect/display/singing_machine
/mob/living/simple_animal/hostile/abnormality/singing_machine
	name = "Singing Machine"
	desc = "A shiny metallic device with a large hinge. You feel a sense of dread about what might be inside..."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "singingmachine_closed_clean"
	icon_living = "singingmachine_closed_clean"
	portrait = "singing_machine"
	maxHealth = 3000
	health = 3000
	damage_coeff = list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 1)
	threat_level = HE_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(60, 60, 65, 65, 70),
		ABNORMALITY_WORK_INSIGHT = 50,
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = 40,
	)
	// Adjusted the work chances a little to really funnel people through Instinct work. You can do other stuff... sort of.
	work_damage_amount = 12
	work_damage_type = WHITE_DAMAGE
	ego_list = list(
		/datum/ego_datum/weapon/harmony,
		/datum/ego_datum/weapon/rhythm,
		/datum/ego_datum/armor/harmony,
	)
	gift_type = /datum/ego_gifts/harmony
	abnormality_origin = ABNORMALITY_ORIGIN_ALTERED

	pixel_x = -8
	base_pixel_x = -8
	buckled_mobs = list()
	buckle_lying = TRUE
	max_boxes = 16

	observation_prompt = "You know that people die every time this machine sings. <br>\
		Or perhaps this machine sings when people die. <br>Though it has spilled blood of countless people, the song put you in a rapturous mood."
	observation_choices = list(
		"Turn off the machine" = list(TRUE, "You turned the machine off. Silence fills the air."),
		"Listen to the music" = list(FALSE, "Aah. The music gives you sense of warm coziness and relaxation."),
	)

	var/cleanliness = "clean"
	var/statChecked = 0
	var/bonusRed = 0
	var/grindRed = 4
	var/minceRed = 8
	var/playTiming = 5 SECONDS
	var/playLength = 60 SECONDS
	var/playStatus = 0
	var/playRange = 20
	var/noiseFactor = 2
	var/datum/looping_sound/singing_grinding/grindNoise
	var/datum/looping_sound/singing_music/musicNoise
	var/list/musicalAddicts = list()

/mob/living/simple_animal/hostile/abnormality/singing_machine/Life()
	if(playStatus > 0) // If playstatus isn't 0, deal some damage in range.
		for(var/mob/living/carbon/human/H in livinginrange(playRange, src))
			if(faction_check_mob(H))
				continue
			H.deal_damage(rand(playStatus * noiseFactor, playStatus * noiseFactor * 2), WHITE_DAMAGE)
			if(H in musicalAddicts)
				H.deal_damage(rand(playStatus * noiseFactor, playStatus * noiseFactor * 2), WHITE_DAMAGE)
				to_chat(H, span_warning("You can hear it again... it needs more..."))
			else
				to_chat(H, span_warning("That terrible grinding noise..."))
	return ..()

/mob/living/simple_animal/hostile/abnormality/singing_machine/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/singing_machine/CanAttack(atom/the_target)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/singing_machine/AttemptWork(mob/living/carbon/human/user, work_type)
	if(work_type == ABNORMALITY_WORK_INSTINCT)
		if(datum_reference.qliphoth_meter > 0) // Sets bonus damage on instinct work.
			bonusRed = grindRed // Should be weaker, for less lethal grinding.
			manual_emote("makes an odd grinding noise...")
			playsound(src, 'sound/abnormalities/singingmachine/grind.ogg', 40, 0, 1)
		else
			bonusRed = minceRed // Should be stronger, for when working it is EXTRA dangerous.
			manual_emote("makes a horrible grinding noise!") // Oh boy, it's mad.
			playsound(src, 'sound/abnormalities/singingmachine/chew.ogg', 60, 0, 3)
	else if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) >= 80 || get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 60)
		statChecked = 1 // I see you've failed one of the stat checks, but have also chosen not to feed yourself to the machine.
	return ..()

/mob/living/simple_animal/hostile/abnormality/singing_machine/WorkChance(mob/living/carbon/human/user, chance)
	chance -= statChecked * 15 // Perish.
	return ..()

/mob/living/simple_animal/hostile/abnormality/singing_machine/Worktick(mob/living/carbon/human/user)
	if(bonusRed) // If you have bonus red damage to apply...
		user.deal_damage(bonusRed, RED_DAMAGE)
		if(bonusRed < 6 && playStatus == 0)	// Should only happen when the machine isn't dealing damage.
			for(var/mob/living/carbon/human/H in livinginrange(30, src))
				if(faction_check_mob(H))
					continue
				H.adjustSanityLoss(rand(-1,-2))
			for(var/mob/living/carbon/human/H in musicalAddicts)
				H.adjustSanityLoss(rand(-1,-2))
	return ..()

/mob/living/simple_animal/hostile/abnormality/singing_machine/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	bonusRed = 0 // Reset bonus red damage and the stat check.
	statChecked = 0
	if(user.sanity_lost || user.health < 0) // Did they die? Time to force a bad result.
		pe = 0
	if(work_type == ABNORMALITY_WORK_INSTINCT && datum_reference.qliphoth_meter > 0) // At the end of an instinct work that wasn't trying to raise its counter...
		to_chat(user, span_nicegreen("There's something about that sound..."))
		musicalAddicts |= user
		user.apply_status_effect(STATUS_EFFECT_MUSIC) // Time to addict them.
		SEND_SOUND(user, 'sound/abnormalities/singingmachine/addiction.ogg')
		addtimer(CALLBACK(src, PROC_REF(removeAddict), user), 5 MINUTES)
	return

/mob/living/simple_animal/hostile/abnormality/singing_machine/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(datum_reference.qliphoth_meter == 0) // You did it! You survived a work at 0 qliphoth!
		manual_emote("rests silent once more...") // The machine is now dormant.
		playsound(src, 'sound/abnormalities/singingmachine/creak.ogg', 50, 0, 1)
		datum_reference.qliphoth_change(2)
		icon_state = "singingmachine_closed_[cleanliness]"
		icon_living = icon_state
		stopPlaying()
		update_icon()

/mob/living/simple_animal/hostile/abnormality/singing_machine/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	if(datum_reference.qliphoth_meter > 0)
		datum_reference.qliphoth_change(-(prob(40)))// If it's not already mad, it has a chance to get a little more mad.
	else
		eatBody(user) // If it is mad, you die.
	return ..()

/mob/living/simple_animal/hostile/abnormality/singing_machine/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	if(datum_reference.qliphoth_meter > 0)
		datum_reference.qliphoth_change(-1) // If it's not already completely mad, it gets madder.
	else
		eatBody(user) // If it is, you die.
	return ..()

/mob/living/simple_animal/hostile/abnormality/singing_machine/ZeroQliphoth(mob/living/carbon/human/user) // WARNING: Don't call this on its own. Several zero-qliphoth behaviors rely on its qliphoth actually being 0.
	icon_state = "singingmachine_open_[cleanliness]" // Machine opens and starts making horrible empty grinding noises.
	icon_living = icon_state
	update_icon()
	playsound(src, 'sound/abnormalities/singingmachine/open.ogg', 200, 0, playRange)
	grindNoise = new(list(src), TRUE)
	playStatus = 1
	return

/mob/living/simple_animal/hostile/abnormality/singing_machine/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_MINING)
		ZeroQliphoth()

/mob/living/simple_animal/hostile/abnormality/singing_machine/proc/removeAddict(mob/living/carbon/human/addict)
	if(addict)
		musicalAddicts -= addict // Your five minutes are over, you're free.

/mob/living/simple_animal/hostile/abnormality/singing_machine/proc/stopPlaying()
	if(grindNoise)
		QDEL_NULL(grindNoise)
	if(musicNoise)
		QDEL_NULL(musicNoise)
	playStatus = 0 // This exists solely because I needed to call it via a callback.

/mob/living/simple_animal/hostile/abnormality/singing_machine/proc/eatBody(mob/living/carbon/human/user)
	user.gib()
	stopPlaying()
	playsound(src, 'sound/abnormalities/singingmachine/swallow.ogg', 80, 0, 3)
	cleanliness = "bloody"
	icon_state = "singingmachine_closed_[cleanliness]"
	icon_living = icon_state
	update_icon()
	driveInsane(musicalAddicts)
	playStatus = 2
	datum_reference.qliphoth_change(2)
	grindNoise = new(list(src), TRUE)
	musicNoise = new(list(src), TRUE)
	addtimer(CALLBACK(src, PROC_REF(stopPlaying)), playLength) // This is the callback from earlier.

/mob/living/simple_animal/hostile/abnormality/singing_machine/proc/driveInsane(list/addicts)
	if(LAZYLEN(addicts))
		for(var/mob/living/carbon/human/target in addicts)
			if (!target.sanity_lost)
				target.adjustSanityLoss(500)
			QDEL_NULL(target.ai_controller)
			target.ai_controller = /datum/ai_controller/insane/murder/singing_machine
			target.InitializeAIController()
			addicts -= target

/datum/ai_controller/insane/murder/singing_machine
	lines_type = /datum/ai_behavior/say_line/insanity_singing_machine

/datum/ai_behavior/say_line/insanity_singing_machine
	lines = list(
		"A corpse, I need a corpse...",
		"I'll listen to that song at any cost.",
		"Don't struggle, you'll love its melodies too.",
		"I'm sorry, but I have to hear that song again.",
		"Now, I am reborn.",
	)

/datum/status_effect/display/singing_machine
	id = "music"
	status_type = STATUS_EFFECT_REFRESH
	duration = 5 MINUTES // Just like WCCA
	alert_type = /atom/movable/screen/alert/status_effect/singing_machine
	display_name = "musical_addiction"
	var/addictionTick = 10 SECONDS
	var/addictionTimer = 0
	var/addictionSanityMin = 2
	var/addictionSanityMax = 6

/atom/movable/screen/alert/status_effect/singing_machine
	name = "Musical Addiction"
	desc = "Your experience with that machine has etched its music into your body and your mind..."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "musical_addiction"

/datum/status_effect/display/singing_machine/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, -5)
	status_holder.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, -5)
	status_holder.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, 10)
	status_holder.physiology.white_mod *= 1.1

/datum/status_effect/display/singing_machine/tick()
	if(world.time % addictionTick == 0 && ishuman(owner)) // Give or take one, this will fire off as many times as if I set up a proper timer variable.
		var/mob/living/carbon/human/H = owner
		H.adjustSanityLoss(rand(addictionSanityMax, addictionSanityMin))

/datum/status_effect/display/singing_machine/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, 5)
	status_holder.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, 5)
	status_holder.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, -10)
	status_holder.physiology.white_mod /= 1.1

#undef STATUS_EFFECT_MUSIC
