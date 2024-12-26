#define BIGWOLF_COOLDOWN_DASH 30 SECONDS
#define BIGWOLF_COOLDOWN_HOWL 20 SECONDS
#define WOLF_HP_PERCENT 100 * (health / maxHealth)

/mob/living/simple_animal/hostile/abnormality/big_wolf
	name = "Big and Will be Bad Wolf"
	desc = "An abnormality taking the form of a large wolf."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "big_wolf"
	icon_living = "big_wolf"
	icon_dead = "big_wolf_slain"
	portrait = "big_wolf"
	faction = list("hostile")
	speak_emote = list("growls")

	pixel_x = -16
	base_pixel_x = -16

	maxHealth = 2500
	health = 2500
	del_on_death = FALSE
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 1)
	see_in_dark = 10
	stat_attack = HARD_CRIT
	rapid_melee = 1.5
	ranged = TRUE
	ranged_cooldown_time = BIGWOLF_COOLDOWN_DASH
	simple_mob_flags = SILENCE_RANGED_MESSAGE
	wander = FALSE

	move_to_delay = 2
	threat_level = WAW_LEVEL
	can_breach = TRUE
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(40, 40, 45, 45, 50),
		ABNORMALITY_WORK_INSIGHT = list(30, 30, 30, 20, 20),
		ABNORMALITY_WORK_ATTACHMENT = list(45, 50, 50, 55, 55),
		ABNORMALITY_WORK_REPRESSION = 0,
	)
	work_damage_amount = 12
	work_damage_type = RED_DAMAGE
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 20
	melee_damage_upper = 40
	attack_sound = 'sound/abnormalities/big_wolf/Wolf_Scratch.ogg'

	attack_action_types = list(
		/datum/action/innate/abnormality_attack/toggle/wolf_dash_toggle,
		/datum/action/cooldown/wolf_howl,
	)

	ego_list = list(
		/datum/ego_datum/weapon/cobalt,
		/datum/ego_datum/armor/cobalt,
	)
	gift_type =  /datum/ego_gifts/cobalt
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	observation_prompt = "(You see a wolf with patchy fur) <br>\
		I like it here. <br>At least it's better than where I used to live. <br>There are no pigs or chickens, but I don't have to be Big Bad Wolf, at least. <br>\
		You didn't immediately kick me out, so I will tell you my name. <br>My name is..."
	observation_choices = list(
		"Remember the name" = list(TRUE, "It's no use to remember it. <br>Nobody cares about my name. <br>\
			(Even though the wolf said such a thing, it seems happy.)"),
		"Forget the name" = list(FALSE, "You better watch out. <br>I can eat you with one bite if I want to. <br>\
			(The wolf seems unhappy)"),
	)

	var/can_act = TRUE
	//For when the wolf becomes incorporal and flees.
	var/last_reached_health = 75
	//For some reason wolf's AI just turns off when there is if(fleeing_now)
	var/fleeing_now = FALSE
	//Cooldowns for skills
	var/hp_check_cooldown = 0
	var/howl_cooldown = 0
	var/howl_cooldown_time = BIGWOLF_COOLDOWN_HOWL

//Obligatory ability buttons for the dreaded player.
/datum/action/innate/abnormality_attack/toggle/wolf_dash_toggle
	name = "Toggle Dash"
	desc = "Prepare to dash at the enemy dealing 50 RED damage to all in your way."
	button_icon_state = "wolf_toggle0"
	chosen_message = span_notice("You won't dash anymore.")
	chosen_attack_num = 2
	button_icon_toggle_activated = "wolf_toggle1"
	toggle_attack_num = 1
	toggle_message = span_colossus("You prepare your dash.")
	button_icon_toggle_deactivated = "wolf_toggle0"

/datum/action/cooldown/wolf_howl
	name = "Howl"
	desc = "Prepare to howl, dealing WHITE damage to nearby humans and weaken abnormality containment when below 50% health."
	icon_icon = 'icons/mob/actions/actions_abnormality.dmi'
	button_icon_state = "wolf_howl"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = BIGWOLF_COOLDOWN_HOWL

/datum/action/cooldown/wolf_howl/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/big_wolf))
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/big_wolf/wolf = owner
	wolf.Howl()
	StartCooldown()
	return TRUE

/mob/living/simple_animal/hostile/abnormality/big_wolf/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(work_type == ABNORMALITY_WORK_INSTINCT && user.stat != DEAD && locate(/mob/living) in contents)
		flick("wolf_sad", src)
		SpewStomach()
	return ..()

/mob/living/simple_animal/hostile/abnormality/big_wolf/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	EatWorker(user)
	return ..()

/mob/living/simple_animal/hostile/abnormality/big_wolf/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	update_icon()

//If the target is little red they will not check faction they WILL fight. -IP
/mob/living/simple_animal/hostile/abnormality/big_wolf/CanAttack(atom/the_target)
	if(istype(the_target, /mob/living/simple_animal/hostile/abnormality/red_hood))
		var/mob/living/L = the_target
		if(L.stat != DEAD)
			return TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/big_wolf/death(gibbed)
	update_icon()
	SpewStomach()
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/big_wolf/Move()
	if(!can_act)
		return FALSE
	..()

/mob/living/simple_animal/hostile/abnormality/big_wolf/update_icon_state()
	if(IsContained())
		icon = initial(icon)
		pixel_x = initial(pixel_x)
		base_pixel_x = initial(base_pixel_x)
		icon_state = initial(icon_state)
	else
		icon = 'ModularTegustation/Teguicons/96x64.dmi'
		pixel_x = -32
		base_pixel_x = -32
		if(stat == DEAD)
			icon_state = icon_dead
		else if(fleeing_now)
			icon_state = "big_wolf_flee"
		else
			icon_state = "big_wolf"
	icon_living = icon_state

/mob/living/simple_animal/hostile/abnormality/big_wolf/handle_automated_action()
	. = ..()
	if(!can_act || IsContained() || stat == DEAD)
		return

	if(target && ranged_cooldown <= world.time)
		OpenFire(target)
		return

	if(fleeing_now != TRUE && hp_check_cooldown <= world.time)
		var/our_hp = WOLF_HP_PERCENT
		if(our_hp <= last_reached_health)
			FleeNow()
			last_reached_health = last_reached_health - 25
		hp_check_cooldown = world.time + (10 SECONDS)
		return

/mob/living/simple_animal/hostile/abnormality/big_wolf/Life()
	. = ..()
	if(!client && can_act && howl_cooldown <= world.time && fleeing_now != TRUE)
		Howl()

/mob/living/simple_animal/hostile/abnormality/big_wolf/OpenFire(atom/A)
	if(!can_act || fleeing_now == TRUE)
		return

	if(client)
		switch(chosen_attack)
			if(1)
				if(ranged_cooldown > world.time)
					var/time_left =  (ranged_cooldown - world.time) / 10
					to_chat(src, span_userdanger("You must wait [time_left] seconds to regain your strength..."))
					return
				ScratchDash(A)
		return

	if(ranged_cooldown <= world.time)
		ScratchDash(A)

//Stuff that is overrided when fleeing
/mob/living/simple_animal/hostile/abnormality/big_wolf/attacked_by(obj/item/I, mob/living/L)
	if(fleeing_now == TRUE)
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/big_wolf/bullet_act(obj/projectile/P)
	if(fleeing_now == TRUE)
		return BULLET_ACT_BLOCK
	..()

//Unique Procs
/* Base Lobotomy Corp wolf will occasionally run away from combat when wounded.
	This is the most tricky to code since the patrol cancels on finding a target.*/
/mob/living/simple_animal/hostile/abnormality/big_wolf/proc/FleeNow()
	playsound(get_turf(src), 'sound/abnormalities/big_wolf/Wolf_FogChange.ogg', 75, 1)
	ADD_TRAIT(src, TRAIT_MOVE_PHASING, "fleeing")
	AIStatus = AI_OFF
	target = null
	walk_to(src, 0)
	TemporarySpeedChange(-2, 3 SECONDS)
	fleeing_now = TRUE
	//stolen from patrol select
	var/turf/target_center
	var/list/potential_centers = list()
	for(var/pos_targ in GLOB.department_centers)
		var/possible_center_distance = get_dist(src, pos_targ)
		if(possible_center_distance > 4 && possible_center_distance < 46)
			potential_centers += pos_targ
	if(LAZYLEN(potential_centers))
		target_center = pick(potential_centers)
	if(target_center)
		patrol_to(target_center)
		//Used to be in patrol_reset until i learned that patrol reset is inside patrol_to.
		update_icon()
		addtimer(CALLBACK(src, PROC_REF(StopFleeing)), 3 SECONDS)
		return
	StopFleeing()

/mob/living/simple_animal/hostile/abnormality/big_wolf/proc/StopFleeing()
	playsound(get_turf(src), 'sound/magic/ethereal_exit.ogg', 75, 1)
	fleeing_now = FALSE
	color = initial(color)
	REMOVE_TRAIT(src, TRAIT_MOVE_PHASING, "fleeing")
	AIStatus = AI_ON
	update_icon()

/* This activates whenever a bad work is preformed. So rarely ever. It places the human inside the wolf and applies
	several traits in order to keep them alive. Apparently the insides of mobs dont have air. Due to a early
	suggestion the persons headset radio is dropped when they are chomped.*/
/mob/living/simple_animal/hostile/abnormality/big_wolf/proc/EatWorker(mob/living/L)
	if(!L)
		return FALSE
	playsound(get_turf(src), 'sound/effects/ordeals/crimson/noon_bite.ogg', 75, 1)
	var/obj/item/radio/headset/radio = L.get_item_by_slot(ITEM_SLOT_EARS)
	if(radio)
		radio.forceMove(get_turf(L))
	ADD_TRAIT(L, TRAIT_NOBREATH, type)
	ADD_TRAIT(L, TRAIT_INCAPACITATED, type)
	ADD_TRAIT(L, TRAIT_IMMOBILIZED, type)
	ADD_TRAIT(L, TRAIT_HANDS_BLOCKED, type)
	L.forceMove(src)
	return TRUE

/* Spew Stomach procs when the wolf dies. Since people who ghost are essentially dead we do not drop
	their lifeless bodies but instead the items in their back, suit, suit storage, and belt slot due
	to that being where most ego or tools are stored. If the worker stays in their body due to having
	something valueable in their pockets they will just suffer a minor knockdown when vomited.*/
/mob/living/simple_animal/hostile/abnormality/big_wolf/proc/SpewStomach()
	var/spew_turf = pick(get_adjacent_open_turfs(src))
	playsound(get_turf(src), 'sound/abnormalities/big_wolf/Wolf_EatOut.ogg', 75, 1)
	for(var/atom/movable/i in contents)
		if(isliving(i))
			var/mob/living/L = i
			if(!L.client)
				dropHardClothing(L, spew_turf)
				qdel(L)
				continue
			L.Knockdown(10, FALSE)
			REMOVE_TRAIT(L, TRAIT_NOBREATH, type)
			REMOVE_TRAIT(L, TRAIT_INCAPACITATED, type)
			REMOVE_TRAIT(L, TRAIT_IMMOBILIZED, type)
			REMOVE_TRAIT(L, TRAIT_HANDS_BLOCKED, type)
		i.forceMove(spew_turf)

//Combat Skills
// Simple dash attack that deals 50 damage to all those nearby. This is optimized for AI rather than players.
/mob/living/simple_animal/hostile/abnormality/big_wolf/proc/ScratchDash(dash_target)
	ranged_cooldown = world.time + ranged_cooldown_time
	can_act = FALSE
	if(IsContained())
		return
	var/turf/target_turf = get_turf(dash_target)
	var/list/hit_mob = list()
	do_shaky_animation(2)
	if(do_after(src, 1 SECONDS, target = src))
		var/turf/wallcheck = get_turf(src)
		var/enemy_direction = get_dir(src, target_turf)
		for(var/i = 0 to 7)
			if(get_turf(src) != wallcheck || stat == DEAD || IsContained())
				break
			wallcheck = get_step(src, enemy_direction)
			if(!ClearSky(wallcheck))
				break
			//without this the attack happens instantly
			sleep(1)
			forceMove(wallcheck)
			playsound(wallcheck, 'sound/abnormalities/doomsdaycalendar/Lor_Slash_Generic.ogg', 20, 0, 4)
			for(var/turf/T in orange(get_turf(src), 1))
				if(isclosedturf(T))
					continue
				new /obj/effect/temp_visual/slice(T)
				hit_mob = HurtInTurf(T, hit_mob, 50, RED_DAMAGE, null, TRUE, FALSE, TRUE, hurt_structure = TRUE)
				for(var/mob/living/simple_animal/hostile/abnormality/red_hood/mercenary in hit_mob)
					mercenary.deal_damage(100, RED_DAMAGE) //triple damge to red
	can_act = TRUE

//Used in Steel noons for if they are allowed to fly through something.
/mob/living/simple_animal/hostile/abnormality/big_wolf/ClearSky(turf/T)
	. = ..()
	if(.)
		if(locate(/obj/structure/table) in T.contents)
			return FALSE
		if(locate(/obj/structure/railing) in T.contents)
			return FALSE

// Very simple ranged howl that applies white damage.
/mob/living/simple_animal/hostile/abnormality/big_wolf/proc/Howl()
	if(IsContained())
		return
	howl_cooldown = world.time + howl_cooldown_time
	var/our_health = WOLF_HP_PERCENT
	var/mutable_appearance/visual_overlay = mutable_appearance('icons/effects/effects.dmi', "blip")
	visual_overlay.pixel_x = -pixel_x
	visual_overlay.pixel_y = -pixel_y
	add_overlay(visual_overlay)
	can_act = FALSE
	if(do_after(src, 2 SECONDS, target = src))
		new /obj/effect/temp_visual/fragment_song(get_turf(src))
		var/list/turfs_to_check = orange(20, src)
		for(var/mob/living/L in turfs_to_check)
			if(isabnormalitymob(L) && our_health < 50)
				var/mob/living/simple_animal/hostile/abnormality/ABNO = L
				if(ABNO.IsContained())
					//Spot for when little red is added so we can breach her when she hears us.
					ABNO.datum_reference.qliphoth_change(-1)
					if(!istype(ABNO, /mob/living/simple_animal/hostile/abnormality/red_hood))
						continue
			if(istype(L, /mob/living/simple_animal/hostile/abnormality/red_hood))
				var/mob/living/simple_animal/hostile/abnormality/red_hood/mercenary = L
				if(mercenary.IsContained())
					mercenary.BreachEffect()
				mercenary.priority_target = src
				mercenary.deal_damage(150, WHITE_DAMAGE) //She takes triple damage from the wolf, becauser her resistances are high
				mercenary.RageUpdate(2)
			if(faction_check_mob(L, FALSE))
				continue
			if(L.stat == DEAD)
				continue
			L.deal_damage(50, WHITE_DAMAGE)
		for(var/obj/vehicle/V in turfs_to_check)
			V.take_damage(50, WHITE_DAMAGE)
		playsound(get_turf(src), 'sound/abnormalities/big_wolf/Wolf_Howl.ogg', 30, 0, 4)
	cut_overlay(visual_overlay)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/big_wolf/AttackingTarget(atom/attacked_target)
	if(istype(attacked_target, /mob/living/simple_animal/hostile/abnormality/red_hood)) //Red takes triple damage from the wolf, becauser her resistances are high
		var/mob/living/simple_animal/hostile/abnormality/red_hood/mercenary = attacked_target
		var/bonus_damage_dealt = 2 * (rand(melee_damage_lower,melee_damage_upper))
		mercenary.deal_damage(bonus_damage_dealt, RED_DAMAGE)
	return ..()

#undef BIGWOLF_COOLDOWN_HOWL
#undef BIGWOLF_COOLDOWN_DASH
#undef WOLF_HP_PERCENT
