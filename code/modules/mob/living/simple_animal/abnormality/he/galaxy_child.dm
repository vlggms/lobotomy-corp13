#define STATUS_EFFECT_FRIENDSHIP /datum/status_effect/friendship
/mob/living/simple_animal/hostile/abnormality/galaxy_child
	name = "Child of the Galaxy"
	desc = "A young, lost child."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "galaxy"
	maxHealth = 650
	health = 650
	threat_level = HE_LEVEL
	start_qliphoth = 5
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 45,
		ABNORMALITY_WORK_INSIGHT = 45,
		ABNORMALITY_WORK_ATTACHMENT = 45,
		ABNORMALITY_WORK_REPRESSION = 45
		)
	work_damage_amount = 8
	work_damage_type = BLACK_DAMAGE
	max_boxes = 16

	ego_list = list(
		/datum/ego_datum/weapon/galaxy,
		/datum/ego_datum/armor/galaxy
		)
//	gift_type = /datum/ego_gifts/galaxy

	var/heal_cooldown_time = 2 SECONDS
	var/heal_cooldown
	var/list/galaxy_friend = list()
	var/heal_mod = 0.5
	var/damage_mod = 40
	var/heal_amount
	var/damage_amount

/mob/living/simple_animal/hostile/abnormality/galaxy_child/Life()
	. = ..()
	if(heal_cooldown < world.time)
		heal_cooldown = world.time + heal_cooldown_time
		heal()

/mob/living/simple_animal/hostile/abnormality/galaxy_child/work_complete(mob/living/carbon/human/user, work_type, pe)
	..()
	icon_state = "galaxy"	//I'd run an if statement but It's actually more optimal processor wise to not.

	if(user in galaxy_friend)
		datum_reference.qliphoth_change(1)

	//Does math, gives them the required stuff
	if(!(user in galaxy_friend))
		user.apply_status_effect(STATUS_EFFECT_FRIENDSHIP)
		galaxy_friend += user
		heal_amount += heal_mod
		damage_amount += damage_mod
		RegisterSignal(user, COMSIG_LIVING_DEATH, .proc/FriendDeath)
		user.add_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects32x48.dmi', "galaxy", -MUTATIONS_LAYER))

/mob/living/simple_animal/hostile/abnormality/galaxy_child/zero_qliphoth(mob/living/carbon/human/user)
	if(LAZYLEN(galaxy_friend))
		for (var/mob/living/carbon/human/L in galaxy_friend)
			L.apply_damage(damage_amount, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
			L.remove_status_effect(STATUS_EFFECT_FRIENDSHIP)
			new /obj/effect/temp_visual/revenant/cracks(get_turf(L))
			to_chat(L, "<span class='userdanger'>The pact made is over. The Order of the Galaxy is broken, and all involved have been punished.</span>")
			L.cut_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects32x48.dmi', "galaxy", -MUTATIONS_LAYER))

	//reset everything
	heal_amount = 0
	damage_amount = 0
	galaxy_friend = list()


/mob/living/simple_animal/hostile/abnormality/galaxy_child/proc/heal()
	if(LAZYLEN(galaxy_friend))
		for (var/mob/living/carbon/human/H in galaxy_friend)
			H.adjustBruteLoss(-heal_amount) // It heals everyone a bit every 2 seconds.

/mob/living/simple_animal/hostile/abnormality/galaxy_child/proc/FriendDeath(datum/source, gibbed)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_LIVING_DEATH)
	icon_state = "galaxy_weep"
	datum_reference.qliphoth_change(-4)


//FRIEND
//For now, just a notification. If we ever want to do anything with it, it's here.
/datum/status_effect/friendship
	id = "friend"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1		//Lasts basically forever
	alert_type = /atom/movable/screen/alert/status_effect/friendship

/atom/movable/screen/alert/status_effect/friendship
	name = "Order of the Galaxy"
	desc = "You are a friend of Child of the Galaxy, and will receive healing for it."

#undef STATUS_EFFECT_FRIENDSHIP
