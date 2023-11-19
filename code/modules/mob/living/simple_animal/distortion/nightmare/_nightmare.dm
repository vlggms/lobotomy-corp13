// Threats appropriate for a single grade 3-1 fixer, or multiple weaker fixers.
#define SONG_COOLDOWN (25 SECONDS)
/mob/living/simple_animal/hostile/distortion/false_hydra
	name = "Flase Hydra"
	desc = "A pale monster with 7 blank human heads..."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "false_hydra"
	maxHealth = 2000
	health = 2000
	pixel_x = -16
	base_pixel_x = -16
	fear_level = WAW_LEVEL
	move_to_delay = 2
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.7, WHITE_DAMAGE = -1, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 1.5)
	melee_damage_lower = 25
	melee_damage_upper = 30
	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = 'sound/abnormalities/scarecrow/attack.ogg'
	attack_verb_continuous = "slashs"
	attack_verb_simple = "slash"
	var/revealed = TRUE
	var/can_act = TRUE
	var/backstab_damage = 40

	attack_action_types = list(/datum/action/cooldown/cloak)
	//Variables important for distortions
	//The EGO worn by the egoist
	ego_list = list(
		/obj/item/ego_weapon/waging,
		/obj/item/clothing/suit/armor/ego_gear/teth/waging
		)
	//The egoist's name, if specified. Otherwise picks a random name.
	egoist_names = list("Maria Sal", "Lora Sal")
	//The mob's gender, which will be inherited by the egoist. Can be left unspecified for a random pick.
	gender = FEMALE
	//The Egoist's outfit, which should usually be civilian unless you want them to be a fixer or something.
	egoist_outfit = /datum/outfit/job/civilian
	//Loot on death; distortions should be valuable targets in general.
	loot = list(/obj/item/documents/ncorporation)

/datum/action/cooldown/cloak
	name = "Song of Oblivion"
	icon_icon = 'icons/mob/actions/actions_abnormality.dmi'
	button_icon_state = "swan"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = SONG_COOLDOWN

/datum/action/cooldown/cloak/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/distortion/false_hydra))
		return FALSE
	var/mob/living/simple_animal/hostile/distortion/false_hydra/hydra = owner
	hydra.Cloak()
	StartCooldown()
	return TRUE

/mob/living/simple_animal/hostile/distortion/Initialize(mapload)
	. = ..()
	for(var/action_type in attack_action_types)
		var/datum/action/innate/abnormality_attack/attack_action = new action_type()
		attack_action.Grant(src)

//Proc that can be used for additional effects on unmanifest
/mob/living/simple_animal/hostile/distortion/false_hydra/PostUnmanifest()
	new /obj/item/clothing/neck/tie/horrible(get_turf(src))
	return

//Unmanifesting is not linked to any proc by default, if you want it to happen during gameplay, it must be called manually.
/mob/living/simple_animal/hostile/distortion/false_hydra/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	var/value
	if(istype(I, /obj/item/holochip))
		var/obj/item/holochip/H = I
		value = H.credits
	if(istype(I, /obj/item/stack/spacecash))
		var/obj/item/stack/spacecash/H = I
		value = H.value
	if(!value)
		return
	if(value <= 250)
		say("That's not enough! It is never enough!")
		user.visible_message("<span class='danger'>[src] is not fazed by [user]'s offering!</span>", "<span class='userdanger'>Your peace offering is rejected by [src]!</span>")
	else
		qdel(I)
		say("You really mean it? A paid vacation?")
		can_act = FALSE
		addtimer(CALLBACK(src,.proc/Unmanifest),3 SECONDS)

/mob/living/simple_animal/hostile/distortion/false_hydra/Move()
	if(!can_act)
		return FALSE
	..()

/mob/living/simple_animal/hostile/distortion/false_hydra/AttackingTarget()
	if(!can_act)
		return FALSE

	if(target == src)
		to_chat(src, "<span class='warning'>You almost bite yourself, but then decide against it.</span>")
		return

	if(!revealed)
		//Will want this to be crazy
		say("He.. P, Me...")

		Decloak()
		SLEEP_CHECK_DEATH(3)

		var/mob/living/V = target
		//Backstab
		if(target in range(1,src))
			visible_message(span_danger("\The [src] rips out [target]'s guts!"))
			V.apply_damage(backstab_damage, WHITE_DAMAGE, null, V.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
			V.Stun(3)
			SLEEP_CHECK_DEATH(20)
			Cloak()
			//Remove target
			FindTarget()

	if(istype(target, /turf/closed/wall))
		var/turf/closed/wall/thewall = target
		to_chat(src, "<span class='warning'>You begin tearing through the wall...</span>")
		playsound(src, 'sound/machines/airlock_alien_prying.ogg', 100, TRUE)
		var/timetotear = 40
		if(istype(target, /turf/closed/wall/r_wall))
			timetotear = 120
		if(do_after(src, timetotear, target = thewall))
			if(istype(thewall, /turf/open))
				return
			thewall.dismantle_wall(1)
			playsound(src, 'sound/effects/meteorimpact.ogg', 100, TRUE)
		return
	if(isliving(target)) //Swallows corpses like a snake to regain health.
		var/mob/living/L = target
		if(L.stat == DEAD)
			to_chat(src, "<span class='warning'>You begin to swallow [L] whole...</span>")
			if(do_after(src, 30, target = L))
				if(eat(L))
					adjustHealth(-L.maxHealth * 0.5)
			return
	. = ..()
	..()

/mob/living/simple_animal/hostile/distortion/false_hydra/proc/eat(atom/movable/A)
	if(A && A.loc != src)
		playsound(src, 'sound/magic/demon_attack1.ogg', 100, TRUE)
		visible_message("<span class='warning'>[src] swallows [A] whole!</span>")
		A.forceMove(src)
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/distortion/false_hydra/attackby(obj/item/I, mob/living/user, params)
	..()
	Decloak()

/mob/living/simple_animal/hostile/distortion/false_hydra/bullet_act(obj/projectile/P)
	..()
	Decloak()

/mob/living/simple_animal/hostile/distortion/false_hydra/proc/Cloak()
	alpha = 0
	revealed = FALSE
	density = FALSE

/mob/living/simple_animal/hostile/distortion/false_hydra/proc/Decloak()
	alpha = 255
	revealed = TRUE
	density = TRUE
