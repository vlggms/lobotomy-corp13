/mob/living/simple_animal/hostile/abnormality/thunder_bird
	name = "Thunderbird Altar"
	desc = "An ominous totem built from the corpses of unusual creatures, crowned with the visage of its namesake in wood."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "thunderbird"
	icon_living = "thunderbird"
	icon_dead = "thunderbird_dead"
	core_icon = "thunderbird_dead"
	del_on_death = FALSE
	speak_emote = list("intones")
	gender = NEUTER
	var/list/thunder_bird_lines = list(
		"Prostrate yourself! Harder!",
		"Do you think I am happy, feather? Think again!",
		"You folk, nothing but sacrifices. Sacrifices for me and everyone else here!",
		"Your kind can never be forgiven!",
		"Look around, you monsters! You've destroyed my people and nature!",
	)
	//Ideally it should only glow in its breached state
	light_color = LIGHT_COLOR_BLUE
	light_range = 0
	light_power = 0

	pixel_x = -16
	base_pixel_x = -16

	//suppression info
	maxHealth = 2000
	health = 2000
	move_to_delay = 4
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 0.7)

	//work info
	threat_level = WAW_LEVEL
	can_breach = TRUE
	start_qliphoth = 3
	//Unlike firebird, you're aiming for good results. The success rates are lower overall and it hates attachment work.
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(25, 25, 20, 20, 20),
		ABNORMALITY_WORK_INSIGHT = list(30, 35, 35, 40, 45),
		ABNORMALITY_WORK_ATTACHMENT = list(10, 10, 5, 5, 15),
		ABNORMALITY_WORK_REPRESSION = list(50, 45, 50, 55, 55),
	)
	work_damage_amount = 10
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/warring,
		/datum/ego_datum/weapon/warring2,
		/datum/ego_datum/armor/warring,
	)
	gift_type =  /datum/ego_gifts/warring
	gift_message = "The totem somehow dons a seemingly ridiculous hat on your head."
	abnormality_origin = ABNORMALITY_ORIGIN_ORIGINAL

	observation_prompt = "The totem sits atop a pile of gore and viscera. <br>\
		Human scalps dangle motionlessly, strung to its wings. <br>\
		Though the totem lies still, you feel compelled to answer it."
	observation_choices = list(
		"Remain silent" = list(TRUE, "The disgusting totem answered with silence. <br>\
			The Thunderbird had been defeated long ago, its existence being its only privilege."),
		"Speak" = list(FALSE, "Before you can utter a word, thunder booms within the cell. <br>\
			The Thunderbird can be spoken to, but never reasoned with."),
	)

/*---Combat---*/
	//Melee stats
	attack_sound = 'sound/abnormalities/thunderbird/tbird_peck.ogg'
	stat_attack = HARD_CRIT
	melee_damage_lower = 10
	melee_damage_upper = 15
	melee_damage_type = BLACK_DAMAGE
	rapid_melee = 2
	attack_verb_continuous = "pecks"
	attack_verb_simple = "peck"
	vision_range = 15
	aggro_vision_range = 30
	ranged = TRUE//allows it to attempt charging without being in melee range

	//Zombie list
	var/list/spawned_mobs = list()

	//range and attack speed for thunder bombs, taken from general bee
	var/fire_cooldown_time = 3 SECONDS
	var/fireball_range = 7
	var/fire_cooldown
	var/targetAmount = 0

	//Stolen charge code from helper
	var/charging = FALSE
	var/dash_num = 10//the length of the dash, in tiles
	var/dash_cooldown = 0
	var/dash_cooldown_time = 4 SECONDS
	var/list/been_hit = list() // Don't get hit twice.

/*---Simple Mob Procs---*/
/mob/living/simple_animal/hostile/abnormality/thunder_bird/PostSpawn()
	..()
	if(locate(/obj/structure/tbird_perch) in get_turf(src))
		return
	new /obj/structure/tbird_perch(get_turf(src))

//attempts to charge its target regardless of distance with a short cooldown. Can be spammed if distant enough.
/mob/living/simple_animal/hostile/abnormality/thunder_bird/AttackingTarget()
	if(charging)
		return
	if(dash_cooldown <= world.time && prob(10) && !client)
		thunder_bird_dash(target)
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/thunder_bird/Move()
	if(charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/thunder_bird/OpenFire()
	if(client)
		switch(chosen_attack)
			if(1)
				thunder_bird_dash(target)
		return

	if(dash_cooldown <= world.time)
		var/chance_to_dash = 50
		if(prob(chance_to_dash))
			thunder_bird_dash(target)

/mob/living/simple_animal/hostile/abnormality/thunder_bird/update_icon_state()
	if(src.stat == DEAD)
		icon_state = icon_dead
		return
	if(charging)
		icon_state = initial(icon)
	else
		icon_state = "thunderbird_charge"
	..()

/mob/living/simple_animal/hostile/abnormality/thunder_bird/death()
	if(health > 0)
		return
	icon = 'ModularTegustation/Teguicons/abno_cores/waw.dmi'
	density = FALSE
	playsound(src, 'sound/abnormalities/thunderbird/tbird_charge.ogg', 100, 1)
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

//fires bombs that deal 45 black damage towards anyone within 1 tile, they also turn the dead and dying into zombies.
/mob/living/simple_animal/hostile/abnormality/thunder_bird/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if((fire_cooldown < world.time))
		fireshell()

//delete the zombies on death
/mob/living/simple_animal/hostile/abnormality/thunder_bird/Destroy()
	. = ..()
	for(var/mob/living/simple_animal/hostile/thunder_zombie/Z in spawned_mobs)
		QDEL_IN(Z, rand(3) SECONDS)
		spawned_mobs -= Z

/*---Dash Stuff ---*/
/mob/living/simple_animal/hostile/abnormality/thunder_bird/proc/thunder_bird_dash(target)
	if(charging || dash_cooldown > world.time)
		return
	update_icon()
	dash_cooldown = world.time + dash_cooldown_time
	charging = TRUE
	var/dir_to_target = get_dir(get_turf(src), get_turf(target))
	been_hit = list()
	addtimer(CALLBACK(src, PROC_REF(do_dash), dir_to_target, 0), 1.5 SECONDS)//how long it takes for the dash to initiate. Set it back to 1 second when thunderbird gets directional sprites
	playsound(src, 'sound/abnormalities/thunderbird/tbird_charge.ogg', 100, 1)

/mob/living/simple_animal/hostile/abnormality/thunder_bird/proc/do_dash(move_dir, times_ran)
	var/stop_charge = FALSE
	if(times_ran >= dash_num)
		stop_charge = TRUE
	var/turf/T = get_step(get_turf(src), move_dir)
	if(!T)
		charging = FALSE
		return
	if(T.density)
		stop_charge = TRUE
	for(var/obj/structure/window/W in T.contents)
		stop_charge = TRUE
		break
	for(var/obj/machinery/door/D in T.contents)
		if(!D.CanAStarPass(null))
			stop_charge = TRUE
			break
		if(D.density)
			INVOKE_ASYNC(D, TYPE_PROC_REF(/obj/machinery/door, open), 2)
	if(stop_charge)
		playsound(src, 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 75, 1)
		charging = FALSE
		icon_state = "thunderbird_breach"
		return
	forceMove(T)
	playsound(src,"sound/abnormalities/thunderbird/tbird_peck.ogg", rand(50, 70), 1)
	var/list/turfs_to_hit = range(1, T)
	for(var/turf/TF in turfs_to_hit)//Smash AOE visual
		new /obj/effect/temp_visual/smash_effect(TF)
	for(var/mob/living/L in turfs_to_hit)//damage applied to targets in range
		if(!faction_check_mob(L))
			if(L in been_hit)
				continue
			visible_message(span_boldwarning("[src] runs through [L]!"))
			to_chat(L, span_userdanger("[src] rushes past you, arcing electricity throughout the way!"))
			playsound(L, attack_sound, 75, 1)
			var/turf/LT = get_turf(L)
			new /obj/effect/temp_visual/kinetic_blast(LT)
			L.deal_damage(100, BLACK_DAMAGE)
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				H.electrocute_act(1, src, flags = SHOCK_NOSTUN)
			if(!(L in been_hit))
				been_hit += L
	for(var/obj/vehicle/sealed/mecha/V in turfs_to_hit)
		if(V in been_hit)
			continue
		visible_message(span_boldwarning("[src] runs through [V]!"))
		to_chat(V.occupants, span_userdanger("[src] rushes past you, arcing electricity throughout the way!"))
		playsound(V, attack_sound, 75, 1)
		V.take_damage(100, BLACK_DAMAGE, attack_dir = get_dir(V, src))
		been_hit += V
	addtimer(CALLBACK(src, PROC_REF(do_dash), move_dir, (times_ran + 1)), 1)

/*---Qliphoth Counter---*/
//counter goes up when you're above 80% hp on a good result, 50% down otherwise
/mob/living/simple_animal/hostile/abnormality/thunder_bird/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(user.health > (user.maxHealth*0.8))
		datum_reference.qliphoth_change(1)
		user.deal_damage(45, BLACK_DAMAGE)
		playsound(src, 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 50, TRUE)
		say(pick(thunder_bird_lines))
		user.electrocute_act(1, src, flags = SHOCK_NOSTUN)
		user.Knockdown(20)
	else
		if(prob(50))
			datum_reference.qliphoth_change(-1)
			say("Begone, fool!")
	return

/mob/living/simple_animal/hostile/abnormality/thunder_bird/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/thunder_bird/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(50))
		datum_reference.qliphoth_change(-1)
	return

/*---Breach effects---*/
/mob/living/simple_animal/hostile/abnormality/thunder_bird/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	name = "Thunderbird"
	icon_living = "thunderbird_breach"
	icon_state = icon_living
	desc = "A hulking avian wreathed in electricity. It looks angry."
	light_range = 5
	light_power = 7
	set_light_on(TRUE)
	update_light()
	GiveTarget(user)

//thunderbolts
/mob/living/simple_animal/hostile/abnormality/thunder_bird/proc/fireshell()
	fire_cooldown = world.time + fire_cooldown_time
	for(var/mob/living/carbon/human/L in range(fireball_range, src))
		if(faction_check_mob(L, FALSE))
			continue
		if (targetAmount <= 2)
			++targetAmount
			var/obj/effect/thunderbolt/E = new(get_turf(L.loc))//do this for the # of targets + 1
			E.master = src
	targetAmount = 0

//thunderbolt objects
/obj/effect/thunderbolt
	name = "thunder bolt"
	desc = "LOOK OUT!"
	icon = 'icons/effects/effects.dmi'
	icon_state = "tbird_bolt"
	move_force = INFINITY
	pull_force = INFINITY
	generic_canpass = FALSE
	movement_type = PHASING | FLYING
	var/boom_damage = 50
	layer = POINT_LAYER	//Sprite should always be visible
	var/mob/living/simple_animal/hostile/abnormality/thunder_bird/master

/obj/effect/thunderbolt/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(explode)), 3 SECONDS)

//Zombie conversion through lightning bombs
/obj/effect/thunderbolt/proc/Convert(mob/living/carbon/human/H)
	var/can_act = TRUE
	if(!istype(H))
		return
	if(!can_act)
		return
	can_act = FALSE
	playsound(src, 'sound/abnormalities/thunderbird/tbird_zombify.ogg', 45, FALSE, 5)
	var/mob/living/simple_animal/hostile/thunder_zombie/C = new(get_turf(src))
	master.spawned_mobs += C
	C.master = master
	if(!QDELETED(H))
		C.name = "[H.real_name]"//applies the target's name and adds the name to its description
		C.desc = "What appears to be [H.real_name], only charred and screaming incoherently..."
		C.gender = H.gender
		H.gib()
	can_act = TRUE

//Smaller Scorched Girl bomb
/obj/effect/thunderbolt/proc/explode()
	playsound(get_turf(src), 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 50, 0, 8)
	var/list/turfs_to_check = view(1, src)
	for(var/mob/living/carbon/human/H in turfs_to_check)
		H.deal_damage(boom_damage, BLACK_DAMAGE)
		H.electrocute_act(1, src, flags = SHOCK_NOSTUN)
		if(H.health < 0)
			Convert(H)
	for(var/obj/vehicle/V in turfs_to_check)
		V.take_damage(boom_damage, BLACK_DAMAGE)
	new /obj/effect/temp_visual/tbirdlightning(get_turf(src))
	var/datum/effect_system/smoke_spread/S = new
	S.set_up(0, get_turf(src))	//Smoke shouldn't really obstruct your vision
	S.start()
	qdel(src)

/*--Zombies!--*/
//zombie mob
/mob/living/simple_animal/hostile/thunder_zombie
	name = "Thunderbird Worshipper"
	desc = "What appears to be human, only charred and screaming incoherently..."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "thunder_zombie"
	icon_living = "thunder_zombie"
	icon_dead = "thunder_zombie_dead"
	speak_emote = list("groans", "moans", "howls", "screeches", "grunts")
	gender = NEUTER
	attack_verb_continuous = "attacks"
	attack_verb_simple = "attack"
	attack_sound = 'sound/abnormalities/thunderbird/tbird_zombieattack.ogg'

	/*Zombie Stats */
	health = 250//subject to change; they all die when thunderbird is suppressed
	maxHealth = 250
	obj_damage = 60
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.5)
	melee_damage_type = BLACK_DAMAGE
	melee_damage_lower = 20
	melee_damage_upper = 30
	speed = 5
	move_to_delay = 3
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = FALSE
	density = TRUE
	guaranteed_butcher_results = list(/obj/item/food/badrecipe = 1)
	var/list/breach_affected = list()
	var/can_act = TRUE
	var/mob/living/simple_animal/hostile/abnormality/thunder_bird/master

//Zombie conversion from zombie kills
/mob/living/simple_animal/hostile/thunder_zombie/AttackingTarget(atom/attacked_target)
	. = ..()
	if(!can_act)
		return
	if(!ishuman(attacked_target))
		return
	var/mob/living/carbon/human/H = attacked_target
	if(H.stat >= SOFT_CRIT || H.health < 0)
		Convert(H)

/mob/living/simple_animal/hostile/thunder_zombie/Initialize()
	. = ..()
	if(IsCombatMap())
		icon_state = "thunder_zombie2"
		icon_living = "thunder_zombie2"
		icon_dead = "thunder_zombie_dead2"
	playsound(get_turf(src), 'sound/abnormalities/thunderbird/tbird_charge.ogg', 50, 1, 4)

/mob/living/simple_animal/hostile/thunder_zombie/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if(status_flags & GODMODE)
		return FALSE

//reanimated if thunderbird isn't suppressed within 30 seconds
/mob/living/simple_animal/hostile/thunder_zombie/death(gibbed)
	addtimer(CALLBACK(src, PROC_REF(resurrect)), 30 SECONDS)
	return ..()

/mob/living/simple_animal/hostile/thunder_zombie/proc/resurrect()
	if(QDELETED(src))
		return
	revive(full_heal = TRUE, admin_revive = FALSE)
	visible_message(span_boldwarning("[src] staggers back on their feet!"))
	playsound(get_turf(src), 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 50, 0, 8)

//Zombie conversion from other zombies
/mob/living/simple_animal/hostile/thunder_zombie/proc/Convert(mob/living/carbon/human/H)
	if(!istype(H))
		return
	if(!can_act)
		return
	can_act = FALSE
	forceMove(get_turf(H))
	playsound(src, 'sound/abnormalities/thunderbird/tbird_zombify.ogg', 45, FALSE, 5)
	SLEEP_CHECK_DEATH(3)
	for(var/i = 1 to 4)
		new /obj/effect/temp_visual/sparks(get_turf(src))
		SLEEP_CHECK_DEATH(5.5)
	if(!QDELETED(H))
		if(!H.real_name)
			return FALSE
		var/mob/living/simple_animal/hostile/thunder_zombie/C = new(get_turf(src))
		if(master)
			master.spawned_mobs += C
			C.master = master
		C.name = "[H.real_name]"//applies the target's name and adds the name to its description
		C.desc = "What appears to be [H.real_name], only charred and screaming incoherently..."
		C.gender = H.gender
		C.faction = src.faction
		H.gib()
	can_act = TRUE

//The perch
/obj/structure/tbird_perch
	name = "thunderbird altar"
	desc = "An idol bloodied by the creature who stood upon it.."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "thunderbird_altar"
	pixel_x = -16
	base_pixel_x = -16
	anchored = TRUE
	density = FALSE
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	resistance_flags = INDESTRUCTIBLE
	mouse_opacity = 0
