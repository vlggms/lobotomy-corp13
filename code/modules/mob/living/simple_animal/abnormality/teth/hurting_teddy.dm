#define STATUS_EFFECT_POWERHEXED /datum/status_effect/powerhexed
#define STATUS_EFFECT_WEAKHEX /datum/status_effect/weakhex
/mob/living/simple_animal/hostile/abnormality/hurting_teddy
  name = "Hurting Teddy Bear"
  desc = "A large worn out teddy bear that has been impaled with nails. Its faded grey fur is coated in grime."
  icon = 'ModularTegustation/Teguicons/64x64.dmi'
  icon_state = "hurting_teddy"
  icon_living = "hurting_teddy"
  portrait = "hurting_teddy"
  pixel_x = -16
  base_pixel_x = -16
  maxHealth = 1500 //it's a teddy bear that's been abused all its life, it should have some HP. It also has two pieces of rank bump equipment.
  health = 1500
  rapid_melee = 1
  melee_queue_distance = 3
  move_to_delay = 5 // it's tanky for a TETH. It should be slow.
  damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 2)
  can_breach = TRUE
  melee_damage_lower = 12
  melee_damage_upper = 18
  melee_damage_type = BLACK_DAMAGE
  stat_attack = HARD_CRIT
  attack_sound = 'sound/weapons/ego/mace1.ogg'
  attack_verb_continuous = "smashes"
  attack_verb_simple = "smash"
  friendly_verb_continuous = "squeezes"
  friendly_verb_simple = "squeeze"
  can_breach = TRUE
  threat_level = TETH_LEVEL
  start_qliphoth = 3
  max_boxes = 14
  work_chances = list(
  	ABNORMALITY_WORK_INSTINCT = 55,
  	ABNORMALITY_WORK_INSIGHT = 55,
  	ABNORMALITY_WORK_ATTACHMENT = 60,
  	ABNORMALITY_WORK_REPRESSION = 10 //It's already been hurt enough, man! if you do this, we're not longer friends!
  ) //only one person can work on it with these rates so they're higher than normal. everyone else will only get low/common rates.
  work_damage_amount = 5
  work_damage_type = BLACK_DAMAGE
  chem_type = /datum/reagent/abnormality/sin/envy //all of its EGO is envy. makes sense to me.
  ego_list = list(
  	/datum/ego_datum/weapon/hexnail,
  	/datum/ego_datum/armor/hexnail
  )
  //gift_type = /datum/ego_gifts/hex_nail
  abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

  observation_prompt = "A teddy bear suffers from having nails lodged into its body. <br>\
  	The bloodstains decorating it are a telling sign of all the time it spent in pain. <br>\
  	The holes where its eyes should be are empty. Nothing but dry red marks remain inside. <br>\
  	In spite of that, it stands with its arms wide, endeavoring to fulfill its duty of giving hugs."
  observation_choices = list(
	"Remove the nails" = list(TRUE, "You removed the nails from the teddy bear. <br>\
			Bloody pus pours out of the holes. <br>\
			Once the plush had finished its copious exudation, only a dark cavity remained within. <br>\
			It is an empty void.."),
	"Bandage its wounds" = list(FALSE, "You applied bandages to the holes in its chest. <br>\
			Blood leaks and saturates them. The wound still seems sore. <br>\
			You gave it some extra dressing, making sure that it’ll last a good while. Yet you know the wound will only continue to fester.")
	) //basically just a slightly edited version of its mirror dungeon event. don't feel like writing a whole new thing for it.

var/bearfriended //the one who can work on it safely
var/mob/living/carbon/human/hug_victim = null
var/release_threshold = 200 //Total raw damage needed to break a player out of a grab (from any source)
var/release_damage = 0
var/hug_progress = 0
var/hug_damage = 8
var/crush_damage = 3
var/can_act = TRUE

//Work Mechanics

/mob/living/simple_animal/hostile/abnormality/hurting_teddy/AttemptWork(mob/living/carbon/human/user, work_type)
	if (user == bearfriended) //small reward to the bearfriend. it's a TETH, after all.
		to_chat(user, span_nicegreen("Hurting Teddy Bear offers you an embrace!"))
		user.adjustBruteLoss(-15)
		user.adjustSanityLoss(-15)
	return ..()

/mob/living/simple_animal/hostile/abnormality/hurting_teddy/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if (bearfriended == null)
		bearfriended = user
		to_chat(user, span_nicegreen("Hurting Teddy Bear becomes your friend!"))

	if (user != bearfriended) //get punished.
		to_chat(user, span_warning("Hurting Teddy Bear already has a friend! You've been hexed for intruding!"))
		user.apply_status_effect(STATUS_EFFECT_POWERHEXED)

	if(work_type == ABNORMALITY_WORK_REPRESSION && user == bearfriended) //you can use this to swap the bearfriend if you're fine losing the counter on a bad or a neutral
		bearfriended = null
		to_chat(user, span_warning("Hurting Teddy Bear isn't your friend anymore! You feel bad for betraying it..."))
		user.apply_status_effect(STATUS_EFFECT_WEAKHEX)
	return ..()

/mob/living/simple_animal/hostile/abnormality/hurting_teddy/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(70)) // Non-friend Agents + lucky Repression works by bearfriends will have a high chance of lowering the counter.
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/hurting_teddy/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/hurting_teddy/WorkChance(mob/living/carbon/human/user, chance, work_type)
	if (bearfriended == null)  //the first work should always have the high work rates. once a friend is made, anyone else who works on it suffers
		return chance
	if (user == bearfriended)
		return chance + 10 //YAY!!! FRIEND!!! Might be unnecessary?
	else
		return chance - 20 //FUCK OFF YOU'RE NOT A FRIEND!!!

//breach mechanics
/mob/living/simple_animal/hostile/abnormality/hurting_teddy/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	bearfriended = null //like staining rose, it's cleanup. Lets another chump work on it if you don't feel like repressing.
	GiveTarget(user)

/mob/living/simple_animal/hostile/abnormality/hurting_teddy/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return
	. = ..()
	if(ishuman(attacked_target))
		if(hug_progress > 4)
			HugAttack(attacked_target)
			hug_progress = 0
			return
		hug_progress += 1

/mob/living/simple_animal/hostile/abnormality/hurting_teddy/Move()
	if(!can_act)
		return FALSE
	return ..()

//mostly renamed and slightly tweaked Brown Noon noon code.

/mob/living/simple_animal/hostile/abnormality/hurting_teddy/proc/HugAttack(mob/living/carbon/human/victim)
	if(!istype(victim))
		return
	hug_victim = victim
	Strangle()
	can_act = FALSE

/mob/living/simple_animal/hostile/abnormality/hurting_teddy/proc/Strangle()
	set waitfor = FALSE
	release_damage = 0
	hug_victim.Immobilize(10)
	if(hug_victim.sanity_lost)
		hug_victim.Stun(10)
	hug_victim.forceMove(get_turf(src))
	SLEEP_CHECK_DEATH(5)
	to_chat(hug_victim, span_userdanger("[src] has grabbed you! Attack [src] to break free!"))
	StrangleHit(1)

/mob/living/simple_animal/hostile/abnormality/hurting_teddy/proc/StrangleHit(count)
	if(!hug_victim)
		ReleaseHug()
		return
	if(hug_victim.health < 0)
		ReleaseHug()
		return
	do_attack_animation(get_step(src, dir), no_effect = TRUE)
	hug_victim.deal_damage(hug_damage, BLACK_DAMAGE)
	new /obj/effect/temp_visual/smash1(get_turf(src))
	hug_victim.deal_damage(crush_damage, BRUTE)
	hug_victim.Immobilize(10)
	playsound(get_turf(src), 'sound/abnormalities/sweethome/smash.ogg', 50, 1)
	switch(count)
		if(0 to 3)
			playsound(get_turf(src), 'sound/effects/wounds/crack1.ogg', 200, 0, 7)
			to_chat(hug_victim, span_userdanger("You are being crushed!"))
		if(4)  //apply more damage
			playsound(get_turf(src), 'sound/effects/wounds/crackandbleed.ogg', 200, 0, 7)
			to_chat(hug_victim, span_userdanger("It hurts so much!"))
			hug_victim.deal_damage(crush_damage, BRUTE)
		else      //Apply ramping damage
			playsound(get_turf(src), 'sound/effects/wounds/crackandbleed.ogg', 200, 0, 7)
			hug_victim.deal_damage((crush_damage * (3 - count)), BRUTE)
	count += 1
	if(hug_victim.sanity_lost)
		hug_victim.Stun(10)
	SLEEP_CHECK_DEATH(10)
	StrangleHit(count)

/mob/living/simple_animal/hostile/abnormality/hurting_teddy/proc/ReleaseHug()
	if(hug_victim)
		hug_victim = null
		can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/hurting_teddy/apply_damage(damage, damagetype, def_zone, blocked, forced, spread_damage, wound_bonus, bare_wound_bonus, sharpness, white_healable)
	. = ..()
	if(hug_victim)
		release_damage = clamp (release_damage + damage, 0, release_threshold)
	if(release_damage >= release_threshold)
		ReleaseHug()

//**   STATUS EFFECTS  **//
//POWERHEXED
//Clingy abnos punishment
/datum/status_effect/powerhexed
	id = "Hexed"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 3 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/powerhexed

/atom/movable/screen/alert/status_effect/powerhexed
	name = "Hexed"
	desc = "You take more RED and BLACK damage"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "schismatic"

/datum/status_effect/powerhexed/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.red_mod /= 0.8
	status_holder.physiology.black_mod /= 0.8

/datum/status_effect/powerhexed/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.red_mod *= 0.8
	status_holder.physiology.black_mod *= 0.8


//WEAKHEX
//Inflicts when you BETRAY your FRIEND you MONSTER!
/datum/status_effect/weakhex
	id = "Hexed"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 2 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/weakhex

/atom/movable/screen/alert/status_effect/weakhex
	name = "Hexed"
	desc = "You take more RED and BLACK damage"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "sacrifice"

/datum/status_effect/weakhex/on_apply()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.red_mod /= 0.9
	status_holder.physiology.black_mod /= 0.9

/datum/status_effect/weakhex/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	status_holder.physiology.red_mod *= 0.9
	status_holder.physiology.black_mod *= 0.9

#undef STATUS_EFFECT_POWERHEXED
#undef STATUS_EFFECT_WEAKHEX





