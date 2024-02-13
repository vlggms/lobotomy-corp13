#define STATUS_EFFECT_VOID /datum/status_effect/stacking/void
//Coded by Coxswain, sprites by nutterbutter
/mob/living/simple_animal/hostile/abnormality/nihil
	name = "The Jester of Nihil"
	desc = "What the heck is this... A clown?"
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "nihil"
	icon_living = "nihil"
	portrait = "nihil"
	pixel_x = -16
	base_pixel_x = -16
	maxHealth = 15000
	health = 15000
	move_to_delay = 4
	rapid_melee = 1
	threat_level = ALEPH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 30, 35, 40),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 30, 35, 40),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 30, 35, 40),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 30, 35, 40),
	)
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.3, PALE_DAMAGE = 0.5) //change on phase
	melee_damage_lower = 55
	melee_damage_upper = 65
	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT
	work_damage_amount = 16
	work_damage_type = RED_DAMAGE
	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	faction = list("hostile, nihil")
	attack_sound = 'sound/abnormalities/nihil/attack.ogg'
	can_spawn = FALSE //not ready yet
//	can_breach = TRUE not yet.
	start_qliphoth = 4
	ranged = TRUE

	ego_list = list(
		/datum/ego_datum/weapon/nihil,
		/datum/ego_datum/armor/nihil,
	)
	gift_type = /datum/ego_gifts/nihil

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/hatred_queen = 5,
		/mob/living/simple_animal/hostile/abnormality/despair_knight = 5,
		/mob/living/simple_animal/hostile/abnormality/greed_king = 5,
		/mob/living/simple_animal/hostile/abnormality/wrath_servant = 5,
	)

	// Range ofthe debuff
	var/debuff_range = 40
	var/list/quotes = list(
		"Everybody's agony becomes one.",
		"Leading the way through foolishness, there's not a thing to guide me.",
		"I slowly traced the road back. It's the road you would've taken.",
		"Where is the right path? Where do I go?",
		"I look just like them, and they look just like me when they're together.",
		"My mind is a void, my thoughts empty.",
		"I become more fearless as they become more vacant.",
		"In the end, all returns to nihil.",
	)

//work code
/mob/living/simple_animal/hostile/abnormality/nihil/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-2)
	return

//In the future, this negative qliphoth change will be tied to whether or not magical girls are present, based on work type..
/mob/living/simple_animal/hostile/abnormality/nihil/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(50))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/nihil/AttemptWork(mob/living/carbon/human/user, work_type)
	if(work_damage_amount < 16)
		work_damage_amount = 16
	switch(work_type)
		if(ABNORMALITY_WORK_INSTINCT)
			work_damage_type = RED_DAMAGE
		if(ABNORMALITY_WORK_INSIGHT)
			work_damage_type = WHITE_DAMAGE
		if(ABNORMALITY_WORK_ATTACHMENT)
			work_damage_type = BLACK_DAMAGE
		if(ABNORMALITY_WORK_REPRESSION)
			work_damage_type = PALE_DAMAGE
			work_damage_amount = 13
	return ..()

//breach
/mob/living/simple_animal/hostile/abnormality/nihil/ZeroQliphoth(mob/living/carbon/human/user)
	Debuff()

/mob/living/simple_animal/hostile/abnormality/nihil/proc/Debuff(attack_count)
	if(attack_count > 13)
		datum_reference.qliphoth_change(3)
		return
	if(!attack_count)
		sound_to_playing_players_on_level("sound/abnormalities/nihil/attack.ogg", 30, zlevel = z)
	for(var/mob/living/carbon/human/L in livinginrange(debuff_range, get_turf(src)))
		var/datum/status_effect/stacking/void/V = L.has_status_effect(/datum/status_effect/stacking/void)
		if(!V)
			L.apply_status_effect(STATUS_EFFECT_VOID)
		else
			V.add_stacks(1)
			V.refresh()
			playsound(L, 'sound/abnormalities/nihil/filter.ogg', 15, FALSE, -3)
			to_chat(L, span_warning("[pick(quotes)]"))
	if(attack_count == 3) //in the future this will be a magical girls check, going off if there are none.
		SSlobotomy_corp.InitiateMeltdown((SSlobotomy_corp.all_abnormality_datums.len), TRUE)
	SLEEP_CHECK_DEATH(4 SECONDS)
	attack_count += 1
	Debuff(attack_count)

//VOID
//Decrease everyone's attributes, petrify magical girls. In the future, this will inversely scale with the number of magical girls in the facility.
/datum/status_effect/stacking/void
	id = "stacking_void"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 20 SECONDS
	alert_type = null
	stack_decay = 0
	stacks = 1
	max_stacks = 13
	on_remove_on_mob_delete = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/void
	consumed_on_threshold = FALSE

/atom/movable/screen/alert/status_effect/void
	name = "Void"
	desc = "Where is the right path? Where do I go?"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "nihil"

/datum/status_effect/stacking/void/on_apply()
	. = ..()
	to_chat(owner, span_warning("The whole world feels dark and empty... You hear voices in your head."))
	if(owner.client)
		owner.add_client_colour(/datum/client_colour/monochrome)

/datum/status_effect/stacking/void/add_stacks(stacks_added)
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, -10 * stacks_added)
	status_holder.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, -10 * stacks_added)
	status_holder.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, -10 * stacks_added)
	status_holder.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, -10 * stacks_added)

/datum/status_effect/stacking/void/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, 10 * stacks)
	status_holder.adjust_attribute_bonus(PRUDENCE_ATTRIBUTE, 10 * stacks)
	status_holder.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, 10 * stacks)
	status_holder.adjust_attribute_bonus(JUSTICE_ATTRIBUTE, 10 * stacks)
	to_chat(owner, span_nicegreen("You feel normal again."))
	if(owner.client)
		owner.remove_client_colour(/datum/client_colour/monochrome)

//items
/obj/item/nihil
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	desc = "A playing card that seems to resonate with certain E.G.O."
	var/special

/obj/item/nihil/examine(mob/user)
	. = ..()
	if(special)
		. += span_notice("[special]")

/obj/item/nihil/heart
	name = "ace of hearts"
	icon_state = "nihil_heart"
	special = "Someone has to be the villain..."

/obj/item/nihil/spade
	name = "ace of spades"
	icon_state = "nihil_spade"
	special = "If I can't protect others, I may as well disappear..."

/obj/item/nihil/diamond
	name = "ace of diamonds"
	icon_state = "nihil_diamond"
	special = "I feel empty inside... Hungry. I want more things!"

/obj/item/nihil/club
	name = "ace of clubs"
	icon_state = "nihil_club"
	special = "Sinners of the otherworlds! Embodiments of evil!!!"

#undef STATUS_EFFECT_VOID
