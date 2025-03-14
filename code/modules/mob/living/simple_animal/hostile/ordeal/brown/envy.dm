
/*
/// Envy peccatulum copy human players, but use a set skillset depending on a chosen outfit
/// Due to its complexity compared to the rest of the ordeal, information on this mobtype is contained in its own separate file.
*/

/mob/living/simple_animal/hostile/ordeal/sin_envy
	name = "Peccatulum Invidiae"
	desc = "A strange, pulsating mass of flesh with an eye in the middle."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "envysin"
	icon_living = "envysin"
	icon_dead = "lovetown_dead" // temporary
	faction = list("brown_ordeal")
	maxHealth = 100
	health = 100
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 9
	melee_damage_upper = 15
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bashes"
	attack_sound = 'sound/weapons/fixer/generic/club3.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	butcher_results = list(/obj/item/food/meat/slab/sinnew = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/sinnew = 1)
	var/list/candidate_list = list()
	var/outfit = /datum/outfit/job/scavenger/envy

/mob/living/simple_animal/hostile/ordeal/sin_envy/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(CopyPlayer)), 1)

/mob/living/simple_animal/hostile/ordeal/sin_envy/say(message, bubble_type, list/spans, sanitize, datum/language/language, ignore_spam, forced)
	if(stat == DEAD)
		return
	if(!client)
		message = stars(message, 100)
		playsound(src, "sound/effects/ordeals/brown/envy[pick(1,2,3)].ogg", 75, FALSE, 4)
	. = ..()

/mob/living/simple_animal/hostile/ordeal/sin_envy/check_emote(message, forced)
	if(!client)
		return FALSE
	. = ..()

/mob/living/simple_animal/hostile/ordeal/sin_envy/proc/CopyPlayer()
	var/mob/living/target_mob = null
	var/mobprefs = null
	for(var/mob/living/M in GLOB.player_list)
		candidate_list += M
	if(LAZYLEN(candidate_list))
		target_mob = pick(candidate_list)
		mobprefs = target_mob.client.prefs
	candidate_list = list()
	var/dummy_key = "envypecca_[target_mob]"
	gender = "[target_mob ? target_mob.gender : gender]"
	appearance = get_flat_human_icon(null, null, mobprefs, dummy_key, outfit_override = outfit)
	clear_human_dummy(dummy_key)
	new /obj/effect/temp_visual/distortedform_shift(get_turf(src))
	if(target_mob)
		name = "[target_mob.name]?"
	else
		name = random_unique_name(gender, 1)
	desc = "Is that really [name]?"

/mob/living/simple_animal/hostile/ordeal/sin_envy/death(gibbed)
	appearance = initial(appearance) // Remove our human overlay
	desc = "A miserable pile of secrets."
	..()

/datum/outfit/job/scavenger/envy // Just a normal rat but with a hammer
	r_hand = /obj/item/ego_weapon/city/rats
