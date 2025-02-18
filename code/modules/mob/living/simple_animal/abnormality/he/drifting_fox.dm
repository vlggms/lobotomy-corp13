// this was a mistake.
// By yours truely, Mori.
#define STATUS_EFFECT_FALSEKIND /datum/status_effect/false_kindness
/mob/living/simple_animal/hostile/abnormality/drifting_fox
	name = "Drifting Fox"
	desc = "A large shaggy fox with gleaming yellow eyes; And torn umbrellas lodged into its back."
	icon = 'ModularTegustation/Teguicons/96x96.dmi'
	icon_state = "drifting_fox"
	icon_living = "drifting_fox"
	icon_dead = "fox_egg"
	core_icon = "fox_egg"
	portrait = "drifting_fox"
	death_message = "Collapses into a glass egg"
	death_sound = 'sound/abnormalities/drifting_fox/fox_death_sound.ogg'
	pixel_x = -24
	pixel_y = -26
	base_pixel_x = -24
	base_pixel_y = -26
	del_on_death = FALSE
	maxHealth = 1000
	health = 1000
	rapid_melee = 2
	move_to_delay = 7
	damage_coeff = list( RED_DAMAGE = 0.9, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.5 )
	melee_damage_lower = 5
	melee_damage_upper = 15 // Idea taken from the old PR, have a large damage range to immitate its fucked rolls and crit chance.
	melee_damage_type = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = 'sound/abnormalities/drifting_fox/fox_melee_sound.ogg'
	attack_verb_simple = "thwacks"
	attack_verb_continuous = "thwacks"
	can_breach = TRUE
	threat_level = HE_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 45,
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = list(15, 20, 25, 30, 35),
		ABNORMALITY_WORK_REPRESSION = 15,
	)
	work_damage_amount = 10
	work_damage_type = BLACK_DAMAGE
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	ego_list = list(
		/datum/ego_datum/weapon/sunshower,
		/datum/ego_datum/armor/sunshower,
	)
	gift_type = /datum/ego_gifts/sunshower
	gift_message = "The fox plucks an umbrella from its back and gives it to you, perhaphs as thanks?"

	observation_prompt = "An alleyway garbage dump. <br.\
		Its atmosphere is stuffy and unpleasant thanks to the humidity from the rain. <br.\
		A pile of old and torn umbrellas sits in a corner. <br.\
		The umbrellas jiggled. <br.\
		Looking closer, there’s a large fox underneath. <br.\
		The umbrellas’ rusted iron blades have firmly rooted themselves in its back."
	observation_choices = list(
		"Pet the fox" = list(TRUE, "Its growl recedes. <br.\
			You stroke it once more, <br.\
			and it closes its eyes, pleased. <br.\
			You stroke it once more, <br.\
			and it settles on the ground, comforted. <br.\
			You stroke it once more, <br.\
			and it shrinks to become a statue."),
		"Pull out the umbrellas" = list(FALSE, "Those umbrellas seem to be causing it pain. <br.\
			When you pull them out with force, bits of its flesh come off with them. <br.\
			The fox yelped sharply and gave us a glare. <br.\
			Then, it smacked you with the umbrella in its mouth. <br.\
			It seemed to reprimand your attitude of pursuing resolution without forethought."),
	)

	var/list/pet = list()
	pet_bonus = "yips"
	var/umbrella_spawn_number = 1
	var/umbrella_spawn_time = 5 SECONDS
	var/umbrella_spawn_limit = 4
	var/list/spawned_mobs = list()
	var/initial_mobs_spawned

/mob/living/simple_animal/hostile/abnormality/drifting_fox/funpet(mob/petter)
	pet += petter
	return ..()

/mob/living/simple_animal/hostile/abnormality/drifting_fox/WorkChance(mob/living/carbon/human/user, chance, work_type)
	if(user in pet)
		if(work_type == ABNORMALITY_WORK_ATTACHMENT)
			chance += 30
			pet -= user
			to_chat(user, span_notice("The abnormality seems to like this type of work more than usual!"))
		else
			chance -= 10
			to_chat(user, span_warning("The abnormality does not seem happy with your choice of work."))
		return chance

/mob/living/simple_animal/hostile/abnormality/drifting_fox/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user in pet)
		pet -= user
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 40)
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/drifting_fox/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/drifting_fox/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	icon_living = "fox_breach"
	icon_state = icon_living
	pixel_y = -6

/mob/living/simple_animal/hostile/abnormality/drifting_fox/death(gibbed)
	icon = 'ModularTegustation/Teguicons/abno_cores/he.dmi'
	pixel_x = -16
	pixel_y = 0
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/drifting_fox/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(health <= 900 && !initial_mobs_spawned)
		playsound(src, 'sound/abnormalities/drifting_fox/fox_aoe_sound.ogg', 50, FALSE, 4)
		initial_mobs_spawned = TRUE
		addtimer(CALLBACK(src, PROC_REF(UmbrellaLoop)), 30 SECONDS)
		for(var/i=4, i>=1, i--) //spawn 4 umbrellas right off the bat
			var/mob/living/simple_animal/hostile/umbrella/newmob = new(get_turf(src))
			newmob.faction = faction
			spawned_mobs+=newmob
			newmob.friend = src
			newmob.GoToFox()
			newmob.ranged_cooldown_time = rand(20,80)
			move_to_delay = clamp(move_to_delay - 1, 3, 7) //Speed up

/mob/living/simple_animal/hostile/abnormality/drifting_fox/proc/UmbrellaLoop()
	listclearnulls(spawned_mobs)
	for(var/mob/living/L in spawned_mobs)
		if(L.stat == DEAD)
			spawned_mobs -= L
	if(length(spawned_mobs) >= umbrella_spawn_limit)
		return
	var/mob/living/simple_animal/hostile/umbrella/newmob = new(get_turf(src))
	newmob.faction = faction
	spawned_mobs+=newmob
	newmob.friend = src
	newmob.GoToFox()
	newmob.ranged_cooldown_time = rand(20,80)
	move_to_delay = clamp(move_to_delay - 1, 3, 7) //Speed up
	addtimer(CALLBACK(src, PROC_REF(UmbrellaLoop)), umbrella_spawn_time)

//Summons
/mob/living/simple_animal/hostile/umbrella
	name = "Umbrella"
	desc = "A tattered and worn umbrella; The fox seems to have many to spare."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "foxbrella"
	icon_living = "foxbrella"
	faction = list("hostile")
	maxHealth = 125
	health = 125
	density = FALSE
	status_flags = MUST_HIT_PROJECTILE // Allows projectiles to hit non-dense mob
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 2)
	del_on_death = FALSE
	ranged = TRUE
	ranged_cooldown_time = 3 SECONDS
	var/teleport_cooldown_time = 10 SECONDS
	var/teleport_cooldown
	/// The drifting fox
	var/mob/living/simple_animal/hostile/abnormality/friend

/// Deal damge to the fox
/mob/living/simple_animal/hostile/umbrella/death(gibbed)
	visible_message(span_notice("[src] falls to the ground as the umbrella closes in on itself!"))
	if(friend)
		friend.deal_damage(100, BLACK_DAMAGE)
		friend.move_to_delay = clamp(move_to_delay + 1, 3, 7) //Slowdown
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	return ..()

///checks if the fox is in view every 10 seconds, and if not teleports to it
/mob/living/simple_animal/hostile/umbrella/Life()
	. = ..()
	if(!friend || stat == DEAD) //for some reason life() works on death ain't that something
		return
	if(QDELETED(friend) || friend.status_flags & GODMODE) //Fox died, we're gone too
		death()
		return
	if(teleport_cooldown < world.time)
		teleport_cooldown = world.time + teleport_cooldown_time
		if(!can_see(src, friend, vision_range))
			GoToFox()

/mob/living/simple_animal/hostile/umbrella/proc/GoToFox()
	if(!friend)
		return
	var/turf/move_turf = get_step(friend, pick(1,2,4,5,6,8,9,10))
	if(!isopenturf(move_turf))
		move_turf = get_turf(friend)
	forceMove(move_turf)
	LoseTarget()

/mob/living/simple_animal/hostile/umbrella/OpenFire()
	ranged_cooldown_time = rand(20,80) //keeps them attacking asynchronously
	if(!isliving(target))
		LoseTarget()
		return
	var/turf/target_turf = get_turf(target)
	for(var/turf/L in view(1, target_turf))
		new /obj/effect/temp_visual/cult/sparks(L)
	SLEEP_CHECK_DEATH(6)
	for(var/turf/T in view(1, target_turf))
		new /obj/effect/temp_visual/small_smoke/halfsecond(T)
		for(var/mob/living/carbon/human/H in HurtInTurf(T, list(), 15, BLACK_DAMAGE, null, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE))
			H.apply_status_effect(STATUS_EFFECT_FALSEKIND)
	playsound(target_turf, 'sound/abnormalities/drifting_fox/fox_umbrella.ogg', 25, TRUE, 4)
	ranged_cooldown = world.time + ranged_cooldown_time

/mob/living/simple_animal/hostile/umbrella/Move()
	return FALSE

/mob/living/simple_animal/hostile/umbrella/AttackingTarget(atom/attacked_target)
	OpenFire()
	return

/datum/status_effect/false_kindness // MAYBE the black sunder shti works this time.
	id = "false_kindness"
	duration = 2 SECONDS //lasts 2 seconds becuase this is for an AI that attacks fast as shit, its not meant to fuck you up with other things.
	alert_type = /atom/movable/screen/alert/status_effect/false_kindness
	status_type = STATUS_EFFECT_REFRESH

/atom/movable/screen/alert/status_effect/false_kindness
	name = "False Kindness"
	desc = "You feel the weight of your mistakes."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "false_kindness" //Bit of a placeholder sprite, it works-ish so

/datum/status_effect/false_kindness/on_apply() //" Borrowed " from Ptear blade, courtesy of gong.
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner //Stolen from Ptear Blade, MAYBE works on people?
	to_chat(status_holder, span_userdanger("You feel the foxes gaze upon you!"))
	status_holder.physiology.black_mod *= 1.3

/datum/status_effect/false_kindness/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/status_holder = owner
	to_chat(status_holder, span_userdanger("You feel as though its gaze has lifted.")) //stolen from PT wep, but I asked so this 100% ok.
	status_holder.physiology.black_mod /= 1.3

#undef STATUS_EFFECT_FALSEKIND
