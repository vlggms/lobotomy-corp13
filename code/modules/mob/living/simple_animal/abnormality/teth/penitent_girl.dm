#define STATUS_EFFECT_PENITENCE /datum/status_effect/penitence
//Sorry Lads, not much I can do here - Kirie
//I tried to improve it. - Coxswain
/mob/living/simple_animal/hostile/abnormality/penitentgirl
	name = "Penitent Girl"
	desc = "A girl with hair flowing over her eyes."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "penitent"
	portrait = "penitent"
	maxHealth = 400
	health = 400
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 50,
		ABNORMALITY_WORK_INSIGHT = 50,
		ABNORMALITY_WORK_ATTACHMENT = list(80, 60, 50, 50, 50),
		ABNORMALITY_WORK_REPRESSION = 50,
	)
	is_flying_animal = TRUE
	work_damage_amount = 6
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/sorrow,
		/datum/ego_datum/armor/sorrow,
	)
	gift_type =  /datum/ego_gifts/sorrow
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

//Work Mechanics
/mob/living/simple_animal/hostile/abnormality/penitentgirl/AttemptWork(mob/living/carbon/human/user, work_type)
	//Prudence too high, random damage type time.
	if(get_attribute_level(user, PRUDENCE_ATTRIBUTE) >= 40)
		work_damage_type = pick(WHITE_DAMAGE, RED_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/penitentgirl/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	// you are going to cut your own leg off
	work_damage_type = initial(work_damage_type)
	if((get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 40) && (get_attribute_level(user, PRUDENCE_ATTRIBUTE) < 40))
		user.apply_damage(250, WHITE_DAMAGE, null, user.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)//DIE!

	if(user.sanity_lost)
		user.apply_status_effect(STATUS_EFFECT_PENITENCE)
		user.say("Why can't I have a little bit of freedom? Her shoes look perfect!")
		QDEL_NULL(user.ai_controller)
		user.ai_controller = /datum/ai_controller/insane/wander/penitence
		user.InitializeAIController()
		user.apply_status_effect(/datum/status_effect/panicked_type/wander/penitence)


//Status Effect
/datum/status_effect/penitence
	id = "penitence"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 1 MINUTES
	alert_type = null

/datum/status_effect/penitence/on_apply()
	. = ..()
	if(!ishuman(owner))
		return FALSE //Autoremoves it
	owner.add_overlay(mutable_appearance('icons/mob/clothing/feet.dmi', "red_shoes", -ABOVE_MOB_LAYER)) //Yes I am reusing assets! No, I am not sorry!

/datum/status_effect/penitence/on_remove()
	. = ..()
	owner.cut_overlay(mutable_appearance('icons/mob/clothing/feet.dmi', "red_shoes", -ABOVE_MOB_LAYER))
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	if(!status_holder.sanity_lost) //Are we still insane? If not, we get to keep our legs.
		return
	if(HAS_TRAIT(status_holder, TRAIT_NODISMEMBER))
		return
	var/obj/item/bodypart/left_leg = status_holder.get_bodypart(BODY_ZONE_L_LEG)
	var/obj/item/bodypart/right_leg = status_holder.get_bodypart(BODY_ZONE_R_LEG)
	var/did_the_thing = (left_leg?.dismember() && right_leg?.dismember()) //not all limbs can be removed, so important to check that we did. the. thing.
	if(!did_the_thing)
		return
	if(status_holder.stat < UNCONSCIOUS) //Not unconscious/dead
		status_holder.say("Please forgive me... I'll just cut off my feet.")
	status_holder.adjustBruteLoss(300)//DIE! For real, this time.

/datum/status_effect/penitence/tick()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	if(!status_holder.sanity_lost && !QDELETED(status_holder))
		qdel(src)
	else
		status_holder.emote("spin")

#undef STATUS_EFFECT_PENITENCE

//Sanity Lines
// Insanity lines
/datum/ai_controller/insane/wander/penitence
	lines_type = /datum/ai_behavior/say_line/insanity_penitence

/datum/ai_behavior/say_line/insanity_penitence
	lines = list(
		"Care to join me?",
		"Why do I want to dance? Why do you want to live?",
		"Check out these moves!",
		"Hahaha...",
		"I feel so alive!",
	)

/datum/status_effect/panicked_type/wander/penitence
	icon = "penitence"
