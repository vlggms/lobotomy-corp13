//Hunker Down
/obj/item/book/granter/action/skill/hunkerdown
	granted_action = /datum/action/cooldown/hunkerdown
	name = "Level 1 Skill: Hunker Down"
	actionname = "Hunker Down"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/hunkerdown
	name = "Hunker Down"
	desc = "Increases armor and decreases movement for 10 seconds."
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "hunkerdown"
	cooldown_time = 30 SECONDS


/datum/action/cooldown/hunkerdown/Trigger()
	. = ..()
	if(!.)
		return FALSE
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		human.add_movespeed_modifier(/datum/movespeed_modifier/hunkerdown)
		addtimer(CALLBACK(human, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/hunkerdown), 10 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		human.physiology.red_mod *= 0.6
		human.physiology.white_mod *= 0.6
		human.physiology.black_mod *= 0.6
		human.physiology.pale_mod *= 0.6
		addtimer(CALLBACK(src, PROC_REF(Recall),), 10 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		StartCooldown()

/datum/action/cooldown/hunkerdown/proc/Recall()
	var/mob/living/carbon/human/human = owner
	human.physiology.red_mod /= 0.6
	human.physiology.white_mod /= 0.6
	human.physiology.black_mod /= 0.6
	human.physiology.pale_mod /= 0.6


/datum/movespeed_modifier/hunkerdown
	variable = TRUE
	multiplicative_slowdown = 1.5


//First aid
/obj/item/book/granter/action/skill/firstaid
	granted_action = /datum/action/cooldown/firstaid
	name = "Level 1 Skill: First Aid"
	actionname = "First Aid"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/firstaid
	name = "First Aid"
	desc = "Increases armor and immobilizes you for 5 seconds, then heals for HP."
	cooldown_time = 1 MINUTES
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "firstaid"
	var/healamount = 30


/datum/action/cooldown/firstaid/Trigger()
	. = ..()
	if(!.)
		return FALSE

	if(ishuman(owner))
		var/mob/living/carbon/human/human = owner
		human.physiology.red_mod *= 0.8
		human.physiology.white_mod *= 0.8
		human.physiology.black_mod *= 0.8
		human.physiology.pale_mod *= 0.8
		addtimer(CALLBACK(src, PROC_REF(Recall),), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		human.Immobilize(50)
		StartCooldown()

/datum/action/cooldown/firstaid/proc/Recall()
	var/mob/living/carbon/human/human = owner
	human.physiology.red_mod /= 0.8
	human.physiology.white_mod /= 0.8
	human.physiology.black_mod /= 0.8
	human.physiology.pale_mod /= 0.8
	human.adjustBruteLoss(-healamount) //Heals you
	new /obj/effect/temp_visual/heal(get_turf(owner), "#FF4444")


//Meditation
/obj/item/book/granter/action/skill/meditation
	granted_action = /datum/action/cooldown/meditation
	name = "Level 1 Skill: Meditation"
	actionname = "Meditation"
	level = 1
	custom_premium_price = 600

/datum/action/cooldown/meditation
	name = "Meditation"
	desc = "Increases armor and immobilizes you for 5 seconds, then heals for SP."
	cooldown_time = 1 MINUTES
	icon_icon = 'icons/hud/screen_skills.dmi'
	button_icon_state = "meditation"
	var/healamount = 30


/datum/action/cooldown/meditation/Trigger()
	. = ..()
	if(!.)
		return FALSE
	if (ishuman(owner))
		var/mob/living/carbon/human/human = owner
		human.physiology.red_mod *= 0.8
		human.physiology.white_mod *= 0.8
		human.physiology.black_mod *= 0.8
		human.physiology.pale_mod *= 0.8
		addtimer(CALLBACK(src, PROC_REF(Recall),), 5 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		human.Immobilize(50)
		StartCooldown()

/datum/action/cooldown/meditation/proc/Recall()
	var/mob/living/carbon/human/human = owner
	human.physiology.red_mod /= 0.8
	human.physiology.white_mod /= 0.8
	human.physiology.black_mod /= 0.8
	human.physiology.pale_mod /= 0.8
	human.adjustSanityLoss(-healamount) //Heals you
	new /obj/effect/temp_visual/heal(get_turf(owner), "#6E6EFF")
