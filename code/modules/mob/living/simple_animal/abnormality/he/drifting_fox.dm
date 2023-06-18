#define STATUS_EFFECT_UMBRELLADEBUFF /datum/status_effect/umbrella_black_debuff
/mob/living/simple_animal/hostile/abnormality/drifting_fox
	name = "Drifting Fox"
	desc = "A light brown, shaggy fox. It has glowing yellow eyes and in it's mouth is an closed umbrella. Stabbed on the fox's back are multiple open umbrellas."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "fox"
	icon_living = "fox"
	icon_dead = "fox_dead"
	del_on_death = FALSE
	maxHealth = 1200
	health = 1200
	speed = 5
	move_to_delay = 6
	rapid_melee = 2
	stop_automated_movement_when_pulled = TRUE
	move_resist = MOVE_FORCE_NORMAL + 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(20, 25, 30, 35, 40),
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = 60,
		ABNORMALITY_WORK_REPRESSION = 0,
						)
	response_help_continuous = "pet"
	response_help_simple = "pet"

	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
	melee_damage_lower = 15
	melee_damage_upper = 35 // stabby stabby into insanity
	melee_damage_type = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	work_damage_amount = 12
	work_damage_type = BLACK_DAMAGE
	attack_verb_continuous = "slices" //TD
	attack_verb_simple = "stabs" // TD
	attack_sound = 'sound/abnormalities/porccubus/porccu_attack.ogg' // has placeholder
	can_breach = TRUE
	can_patrol = FALSE // AE
	start_qliphoth = 3
	threat_level = HE_LEVEL

	faction = list("hostile")
	ego_list = list(
		/datum/ego_datum/weapon/sunshower, // TD
		/datum/ego_datum/armor/sunshower // TD
		)
	gift_type =  /datum/ego_gifts/sunshower
	gift_message = "Luck follows only to those truly kind."
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

/*
SpinAttack
	- Static AOE spinattack in which the fox either Fox.SpinAnimation() or does big AOE effect.. both with medium-big black damage attached
*/

	// var defines spinattack unfinished
	var/umbrella_cooldown_time = 30 SECONDS
	var/umbrella_cooldown
	var/spinattack_cooldown_time = 15 SECONDS
	var/spinattack_cooldown
	var/spinRange = 3 // tf am I gonna do with this
	var/spinDamage = 40
	var/mob/living/carbon/human/NoFriend = null

// *sad_music
/mob/living/simple_animal/hostile/abnormality/drifting_fox/proc/LostFriend(mob/living/carbon/human/user)
	SIGNAL_HANDLER
	UnregisterSignal(NoFriend, COMSIG_LIVING_DEATH)
	datum_reference.qliphoth_change(-1)
	manual_emote("Mourns the death of a friend.")
	NoFriend = null

// You're my friend now DUDUDUUDUUUDUUUUUUUUUU
/mob/living/simple_animal/hostile/abnormality/drifting_fox/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(!IsContained())
		return
	if(user.stat != DEAD && !NoFriend && istype(user) && get_attribute_level(user, TEMPERANCE_ATTRIBUTE) >= 40)
		NoFriend = user
		to_chat(user, "<span class='nicegreen'>Drifting Fox appreciates your kindness.</span>")
		user.Apply_Gift(new gift_type)
		RegisterSignal(user, COMSIG_LIVING_DEATH, .proc/LostFriend)
	return

// Did you work correctly?
/mob/living/simple_animal/hostile/abnormality/drifting_fox/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) >= 40)
		datum_reference.qliphoth_change(-1)
	return
	if(get_attribute_level(user, JUSTICE_ATTRIBUTE) <= 60)
		datum_reference.qliphoth_change(-1)
	return


// lol, you suck
/mob/living/simple_animal/hostile/abnormality/drifting_fox/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-(prob(75)))
	return ..()

//breach
/mob/living/simple_animal/hostile/abnormality/drifting_fox/BreachEffect(mob/living/carbon/human/user)
	..()
	playsound(src, 'sound/abnormalities/porccubus/head_explode_laugh.ogg', 50, FALSE, 4) // has placeholder
	icon_living = "fox"
	icon_state = icon_living
	var/turf/T = pick(GLOB.xeno_spawn)
	forceMove(T)
	umbrella_cooldown = world.time + umbrella_cooldown_time
	spinattack_cooldown = world.time + spinattack_cooldown_time

// I can use this for the aoe attack right?
/mob/living/simple_animal/hostile/abnormality/drifting_fox/AttackingTarget(atom/attacked_target)
	if(spinattack_cooldown <= world.time)
		spinAttack()
	..()

// This should work right?
/mob/living/simple_animal/hostile/abnormality/drifting_fox/Life()
	. = ..()
	if(status_flags & GODMODE)
		return
	if(umbrella_cooldown <= world.time)
		FoxUmbrella()


/mob/living/simple_animal/hostile/abnormality/drifting_fox/proc/FoxUmbrella(mob/living/carbon/human/user)
	playsound(src, 'sound/machines/clockcult/steam_whoosh.ogg', 100) // has placeholder
	manual_emote("whines in pain.")
	SLEEP_CHECK_DEATH(2)
	new /mob/living/simple_animal/hostile/umbrella(get_step(src, EAST))
	new /mob/living/simple_animal/hostile/umbrella(get_step(src, WEST))
	umbrella_cooldown = world.time + umbrella_cooldown_time

/mob/living/simple_animal/hostile/umbrella
	name = "Umbrella"
	desc = "An old and worn out umbrella."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "umbrella" // has placeholder
	icon_living = "umbrella" // has placeholder
	faction = list("hostile")
	maxHealth = 125
	health = 125
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
	move_to_delay = 5
	melee_damage_lower = 5
	melee_damage_upper = 15
	melee_damage_type = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	L.apply_status_effect(/datum/status_effect/umbrella_black_debuff) // how do I apply it to the guy they hit
	attack_sound = 'sound/abnormalities/porccubus/porccu_attack.ogg' // placeholder
	attack_verb_continuous = "slashes"
	attack_verb_simple = "cut"
	robust_searching = TRUE
	del_on_death = FALSE

/mob/living/simple_animal/hostile/umbrella/AfterAttack(atom/the_target)
	if(isliving(target) && !ishuman(target))
		var/mob/living/L = target
		if(L.stat == DEAD)
			return FALSE
	return ..()

//umbrella debuff stuff
/datum/status_effect/umbrella_black_debuff
	id = "umbrella_black_debuff"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 15 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/umbrella_black_debuff

/datum/status_effect/umbrella_black_debuff/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.physiology.black_mod /= 1.3
		return
	var/mob/living/simple_animal/M = owner
	if(M.damage_coeff[BLACK_DAMAGE] <= 0)
		qdel(src)
		return
	M.damage_coeff[BLACK_DAMAGE] += 0.3

/datum/status_effect/umbrella_black_debuff/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.physiology.black_mod *= 1.3
		return
	var/mob/living/simple_animal/M = owner
	M.damage_coeff[BLACK_DAMAGE] -= 0.3

/atom/movable/screen/alert/status_effect/umbrella_black_debuff
	name = "False Kindness"
	desc = "Your half hearted actions have made you more vulnerable to BLACK attacks."
	icon = 'icons/mob/actions/actions_ability.dmi'
	icon_state = "falsekindness"


// Will this make him spin?
/mob/living/simple_animal/hostile/abnormality/drifting_fox/proc/spinAttack()
	if (get_dist(src, target) > 3)
		return
	spinattack_cooldown = world.time + spinattack_cooldown_time
	playsound(src, 'sound/abnormalities/redbuddy/redbuddy_howl.ogg', 100, FALSE, 8)
	for(var/i = 1 to 4)
		addtimer(CALLBACK(src, .proc/spinAttackDamage), 1 SECONDS * (i))

/mob/living/simple_animal/hostile/abnormality/drifting_fox/proc/spinAttackDamage()
	for(var/mob/living/L in view(spinRange, src))
		new /obj/effect/temp_visual/smash_effect(L)
		if(faction_check_mob(L, FALSE))
			continue
		if(L.stat == DEAD)
			continue
		L.apply_damage(spinDamage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)

// umbrella death
/mob/living/simple_animal/hostile/umbrella/death(gibbed)
	visible_message("<span class='notice'>[src] falls to the ground with the umbrella closing on itself!</span>")
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	. = ..()

// you killed him, how could you?
/mob/living/simple_animal/hostile/abnormality/drifting_fox/death(gibbed)
	visible_message("<span class='notice'>[src] falls to the ground, umbrellas closing as he whines in his last breath!</span>")
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

#undef STATUS_EFFECT_UMBRELLADEBUFF
