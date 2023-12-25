/*
Coded by nutterbutter, "senior" junior developer, during hell week 2022.
Finally, an abnormality that DOESN'T have to do any fancy movement shit. It's a miracle. Praise be.
Slightly reworked by Mel on Christmas 2023, Merry Christmas!
*/
#define STATUS_EFFECT_MUSIC /datum/status_effect/display/singing_machine

//playStatus defines
#define SILENT 0
#define GRINDING 1
#define PLAYING 2

/mob/living/simple_animal/hostile/abnormality/singing_machine
	name = "Singing Machine"
	desc = "A shiny metallic device with a large hinge. You feel a sense of dread about what might be inside..."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "singingmachine_clean"
	icon_living = "singingmachine_clean"
	portrait = "singing_machine"
	maxHealth = 200
	health = 200
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
	pixel_y = -6
	base_pixel_y = -6
	buckled_mobs = list()
	buckle_lying = TRUE
	max_boxes = 16
	var/statCheckPenalty = 0
	var/bonusRed = 0
	var/grindRed = 4
	var/minceRed = 8
	var/clampRed = 80
	var/playWhite = 50
	var/playTiming = 5 SECONDS
	var/playLength = 60 SECONDS
	var/playStatus = SILENT
	var/playRange = 15
	var/noiseFactor = 2
	var/list/musicalAddicts = list()

	//Sound Vars
	var/datum/looping_sound/singing_grinding/grindNoise
	var/datum/looping_sound/singing_music/musicNoise

	//Visual Vars
	var/obj/effect/singing_machine_hinge/machine_hinge
	var/obj/particle_emitter/singing_note/particle_note
	var/obj/particle_emitter/singing_note_broken/particle_note_broken
	var/obj/particle_emitter/singing_grind/particle_grind
	var/obj/particle_emitter/singing_blood/particle_blood

/mob/living/simple_animal/hostile/abnormality/singing_machine/Initialize()
	..()
	machine_hinge = new(src)
	vis_contents += machine_hinge

/mob/living/simple_animal/hostile/abnormality/singing_machine/Destroy()
	QDEL_NULL(machine_hinge)
	..()

/mob/living/simple_animal/hostile/abnormality/singing_machine/Life()
	if(playStatus == SILENT) // If the machine isn't silent, deal damage to everyone in range.
		return ..()
	noiseEffect()

	if(playStatus != PLAYING) // If the machine is playing music, also deal damage to all addicts and try to make them go insane.
		return ..()
	damageAddicts()
	return ..()

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
		return ..()

	// I see you've failed the stat check, but have also chosen not to feed yourself to the machine.
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) <= 40)
		statCheckPenalty = 3
	else if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) >= 80) // The Fortitude check applies one third of the penalty
		statCheckPenalty = 1
	return ..()

/mob/living/simple_animal/hostile/abnormality/singing_machine/WorkChance(mob/living/carbon/human/user, chance)
	chance -= statCheckPenalty * 5 // Perish. -5% for the Fortitude check, -15% for the Temperance check
	return ..()

/mob/living/simple_animal/hostile/abnormality/singing_machine/Worktick(mob/living/carbon/human/user)
	if(bonusRed) // If you have bonus red damage to apply...
		user.apply_damage(bonusRed, RED_DAMAGE, null, user.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		if(bonusRed < 6 && playStatus == SILENT)	// Should only happen when the machine isn't dealing damage.
			for(var/mob/living/carbon/human/H in musicalAddicts)
				H.adjustSanityLoss(rand(-2,-4))
	return ..()

/mob/living/simple_animal/hostile/abnormality/singing_machine/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	bonusRed = 0 // Reset bonus red damage and the stat check.
	statCheckPenalty = 0
	if(user.sanity_lost || user.health < 0) // Did they die? Time to force a bad result.
		pe = 0
	if(work_type == ABNORMALITY_WORK_INSTINCT) // At the end of an instinct work...
		for(var/mob/living/carbon/human/H in livinginrange(playRange, src))
			if(H in musicalAddicts)
				continue
			addAddict(H)
	return

/mob/living/simple_animal/hostile/abnormality/singing_machine/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(datum_reference.qliphoth_meter == 0) // You did it! You survived a work at 0 qliphoth!
		manual_emote("rests silent once more...") // The machine is now dormant.
		playsound(src, 'sound/abnormalities/singingmachine/creak.ogg', 50, 0, 1)
		datum_reference.qliphoth_change(2)
		machine_hinge.moveHinge(0 ,1.5 SECONDS, 0, 0)
		stopPlaying()

/mob/living/simple_animal/hostile/abnormality/singing_machine/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	if(datum_reference.qliphoth_meter > 0)
		datum_reference.qliphoth_change(-(prob(40)))// If it's not already mad, it has a chance to get a little more mad.
	else
		machine_hinge.moveHinge(0 ,0.3 SECONDS, 0, 0)
		playsound(src, 'sound/abnormalities/singingmachine/swallow.ogg', 80, 0, 3)
		to_chat(user, span_danger("The machine clamps down on you!"))
		user.apply_damage(clampRed, RED_DAMAGE, null, user.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE) // If its mad, deals a chunk of RED.
		if(user.health < 0)
			eatBody(user) // If it is mad and you die to the clamping damage, you get eaten.
			return ..()
		datum_reference.qliphoth_change(2)
		stopPlaying()
	return ..()

/mob/living/simple_animal/hostile/abnormality/singing_machine/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	if(datum_reference.qliphoth_meter > 0)
		datum_reference.qliphoth_change(-1) // If it's not already completely mad, it gets madder.
	else
		eatBody(user) // If it is, you die.
	return ..()

/mob/living/simple_animal/hostile/abnormality/singing_machine/ZeroQliphoth(mob/living/carbon/human/user) // WARNING: Don't call this on its own. Several zero-qliphoth behaviors rely on its qliphoth actually being 0.
	playsound(src, 'sound/abnormalities/singingmachine/open.ogg', 200, 0, playRange)
	machine_hinge.moveHinge(-90, 1.5 SECONDS, -2, 6)
	particle_note_broken = new(get_turf(src))
	particle_grind = new(get_turf(src))
	grindNoise = new(list(src), TRUE)
	playStatus = GRINDING
	return

/mob/living/simple_animal/hostile/abnormality/singing_machine/proc/noiseEffect()
	for(var/mob/living/carbon/human/H in livinginrange(playRange, src))
		if(faction_check_mob(H))
			continue
		if(playStatus == GRINDING) // If it's mad, damages everyone in it's radius.
			H.apply_damage(rand(playStatus * noiseFactor, playStatus * noiseFactor * 2), WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
			to_chat(H, span_warning("That terrible grinding noise..."))
			continue
		if(H in musicalAddicts) // If it's playing, it spreads the status effect to everyone.
			continue
		addAddict(H)

/mob/living/simple_animal/hostile/abnormality/singing_machine/proc/damageAddicts()
	for(var/mob/living/carbon/human/addict in musicalAddicts)
		addict.apply_damage(rand(playStatus * noiseFactor, playStatus * noiseFactor * 2), WHITE_DAMAGE, null, addict.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
		to_chat(addict, span_warning("You can hear it again... it needs more..."))
		if(!addict.sanity_lost)
			continue
		applySpecialInsanity(addict)

/mob/living/simple_animal/hostile/abnormality/singing_machine/proc/addAddict(mob/living/carbon/human/target)
	target.apply_status_effect(STATUS_EFFECT_MUSIC)
	to_chat(target, span_nicegreen("There's something about that sound..."))
	musicalAddicts |= target
	SEND_SOUND(target, 'sound/abnormalities/singingmachine/addiction.ogg')
	addtimer(CALLBACK(src, .proc/removeAddict, target), 5 MINUTES)

/mob/living/simple_animal/hostile/abnormality/singing_machine/proc/removeAddict(mob/living/carbon/human/addict)
	if(addict)
		musicalAddicts -= addict // Your five minutes are over, you're free.

/mob/living/simple_animal/hostile/abnormality/singing_machine/proc/startPlaying()
	particle_note = new(get_turf(src))
	particle_blood = new(get_turf(src))
	grindNoise = new(list(src), TRUE)
	musicNoise = new(list(src), TRUE)
	driveInsane(musicalAddicts)
	playStatus = PLAYING
	addtimer(CALLBACK(src, .proc/stopPlaying), playLength) // This is the callback from earlier.

/mob/living/simple_animal/hostile/abnormality/singing_machine/proc/stopPlaying()
	playStatus = SILENT // This exists solely because I needed to call it via a callback.
	if(grindNoise)
		QDEL_NULL(grindNoise)
	if(musicNoise)
		QDEL_NULL(musicNoise)
	if(particle_grind)
		particle_grind.fadeout()
	if(particle_note_broken)
		particle_note_broken.fadeout()
	if(particle_note)
		particle_note.fadeout()
	if(particle_blood)
		particle_blood.fadeout()

/mob/living/simple_animal/hostile/abnormality/singing_machine/proc/eatBody(mob/living/carbon/human/user)
	user.gib()
	stopPlaying()
	playsound(src, 'sound/abnormalities/singingmachine/swallow.ogg', 80, 0, 3)
	machine_hinge.bloodySelf()
	icon_state = "singingmachine_bloody"
	icon_living = icon_state
	machine_hinge.moveHinge(0 ,3 SECONDS, 0, 0)
	addtimer(CALLBACK(src, .proc/startPlaying), 3 SECONDS)
	datum_reference.qliphoth_change(2)

/mob/living/simple_animal/hostile/abnormality/singing_machine/proc/applySpecialInsanity(mob/living/carbon/human/addict)
	QDEL_NULL(addict.ai_controller)
	addict.ai_controller = /datum/ai_controller/insane/murder/singing_machine
	addict.InitializeAIController()
	addict.add_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "singing_smile", -MUTATIONS_LAYER))

/mob/living/simple_animal/hostile/abnormality/singing_machine/proc/driveInsane(list/addicts)
	if(!LAZYLEN(addicts))
		return
	for(var/mob/living/carbon/human/addict in addicts)
		addict.apply_damage(playWhite, WHITE_DAMAGE, null, addict.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
		to_chat(addict, span_warning("That beautiful sound... i CRAVE it!"))
		if (!addict.sanity_lost)
			continue
		applySpecialInsanity(addict)
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
	duration = 2 MINUTES
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
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, -5)
	H.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, 15)
	H.physiology.white_mod *= 1.1

/datum/status_effect/display/singing_machine/tick()
	if(!(world.time % addictionTick == 0 && ishuman(owner))) // Give or take one, this will fire off as many times as if I set up a proper timer variable.
		return
	var/mob/living/carbon/human/H = owner
	H.adjustSanityLoss(rand(addictionSanityMax, addictionSanityMin))

/datum/status_effect/display/singing_machine/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, 5)
	H.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, -15)
	H.physiology.white_mod /= 1.1

/obj/effect/singing_machine_hinge
	name = "Singing machine's hinge"
	desc = "You don't want to see this move..."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "singingmachine_hinge_clean"
	layer = FLOAT_LAYER
	move_force = INFINITY
	pull_force = INFINITY

/obj/effect/singing_machine_hinge/proc/moveHinge(angle,animation_time,target_pixel_x,target_pixel_y)
	animate(src, transform = turn(matrix(), angle), pixel_x = target_pixel_x, pixel_y = target_pixel_y, time = animation_time, flags = SINE_EASING | EASE_OUT)

/obj/effect/singing_machine_hinge/proc/bloodySelf()
	if(icon_state == "singingmachine_hinge_bloody")
		return
	icon_state = "singingmachine_hinge_bloody"
	moveHinge(-90, 0, -2, 6)

#undef SILENT
#undef GRINDING
#undef PLAYING
#undef STATUS_EFFECT_MUSIC
