#define BLESS_COOLDOWN (5 SECONDS)
/mob/living/simple_animal/hostile/abnormality/despair_knight
	name = "Knight of Despair"
	desc = "A tall humanoid abnormality in a blue dress. \
	Half of her head is black with sharp horn segments protruding out of it."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "despair"
	icon_living = "despair"
	icon_dead = "despair_dead"
	portrait = "despair_knight"
	pixel_x = -8
	base_pixel_x = -8
	ranged = TRUE
	ranged_cooldown_time = 3 SECONDS
	minimum_distance = 2
	maxHealth = 2000
	health = 2000
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 1.0, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.5)
	stat_attack = HARD_CRIT
	del_on_death = FALSE
	death_sound = 'sound/abnormalities/despairknight/dead.ogg'
	threat_level = WAW_LEVEL
	can_patrol = FALSE
	can_breach = TRUE
	start_qliphoth = 1
	move_to_delay = 4

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 0,
		ABNORMALITY_WORK_INSIGHT = 45,
		ABNORMALITY_WORK_ATTACHMENT = list(50, 50, 55, 55, 60),
		ABNORMALITY_WORK_REPRESSION = list(40, 40, 40, 35, 30),
	)
	work_damage_amount = 10
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/despair,
		/datum/ego_datum/armor/despair,
	)
	gift_type =  /datum/ego_gifts/tears
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/wrath_servant = 2,
		/mob/living/simple_animal/hostile/abnormality/hatred_queen = 2,
		/mob/living/simple_animal/hostile/abnormality/greed_king = 2,
		/mob/living/simple_animal/hostile/abnormality/nihil = 1.5,
	)

	observation_prompt = "I once dedicated myself to the justice of this world, to protect my king, the kingdom and the weak. <br>\
		However in the end nothing was truly upheld on my watch. <br>Even so... I still want to protect someone, anyone..."
	observation_choices = list(
		"Refuse it" = list(TRUE, "Am I not needed anymore? <br>\
			No... <br>You're saying I should move on. <br>I don't know how, or if I can, but, perhaps things could turn out for the better. <br>We need only try."),
		"Accept her blessing" = list(FALSE, "Thank you, though I am but a pitiful knight, I still yearn to protect, if I can't protect others, I may as well disappear..."),
	)

	var/mob/living/carbon/human/blessed_human = null
	var/teleport_cooldown
	var/teleport_cooldown_time = 20 SECONDS
	var/swords = 0
	var/nihil_present = FALSE
	var/can_act = TRUE

	attack_action_types = list(
		/datum/action/innate/change_icon_kod,
		/datum/action/cooldown/knightblessing,
	)


/datum/action/innate/change_icon_kod
	name = "Toggle Icon"
	desc = "Toggle your icon between breached and friendly. (Works only for Limbus Company Labratories)"

/datum/action/innate/change_icon_kod/Activate()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		owner.icon_state = "despair_friendly"
		active = 1

/datum/action/innate/change_icon_kod/Deactivate()
	. = ..()
	if(SSmaptype.maptype == "limbus_labs")
		owner.icon_state = "despair_breach"
		active = 0

/datum/action/cooldown/knightblessing
	name = "Give Blessing"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = BLESS_COOLDOWN //5 seconds

/datum/action/cooldown/knightblessing/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/despair_knight))
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/despair_knight/despair_knight = owner
	StartCooldown()
	despair_knight.give_blessing()
	return TRUE

/mob/living/simple_animal/hostile/abnormality/despair_knight/proc/give_blessing()
	var/list/nearby = viewers(7, src) // first call viewers to get all mobs that see us
	if(SSmaptype.maptype == "limbus_labs")
		if (!blessed_human)
			for(var/mob in nearby) // then sanitize the list
				if(mob == src) // cut ourselves from the list
					nearby -= mob
				if(!ishuman(mob)) // cut all the non-humans from the list
					nearby -= mob
				//if(mob.stat == DEAD)
					//nearby -= mob
			var/mob/living/carbon/human/blessed = input(src, "Choose who you want to bless", "Select who you want to protect") as null|anything in nearby // pick someone from the list
			blessed_human = blessed
			RegisterSignal(blessed, COMSIG_LIVING_DEATH, PROC_REF(BlessedDeath))
			RegisterSignal(blessed, COMSIG_HUMAN_INSANE, PROC_REF(BlessedDeath))
			to_chat(blessed, span_nicegreen("You feel protected."))
			blessed.physiology.red_mod *= 0.5
			blessed.physiology.white_mod *= 0.5
			blessed.physiology.black_mod *= 0.5
			blessed.physiology.pale_mod *= 2
			blessed.add_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "despair", -MUTATIONS_LAYER))
			playsound(get_turf(blessed), 'sound/abnormalities/despairknight/gift.ogg', 50, 0, 2)
			blessed.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, -100)
		return

/mob/living/simple_animal/hostile/abnormality/despair_knight/ZeroQliphoth(mob/living/carbon/human/user)
	switch(swords)
		if(0)
			add_overlay(mutable_appearance('ModularTegustation/Teguicons/48x48.dmi', "despair_sword1", -ABOVE_MOB_LAYER))
			playsound(get_turf(src), 'sound/abnormalities/despairknight/attack.ogg', 50, 0, 4)
			datum_reference.qliphoth_change(1)
		if(1)
			add_overlay(mutable_appearance('ModularTegustation/Teguicons/48x48.dmi', "despair_sword2", -ABOVE_MOB_LAYER))
			playsound(get_turf(src), 'sound/abnormalities/despairknight/attack.ogg', 50, 0, 4)
			datum_reference.qliphoth_change(1)
		else
			cut_overlays()
			if(blessed_human)
				BlessedDeath()
			else
				BreachEffect()
			return
	swords += 1

/mob/living/simple_animal/hostile/abnormality/despair_knight/AttackingTarget(atom/attacked_target)
	return OpenFire()

/mob/living/simple_animal/hostile/abnormality/despair_knight/OpenFire()
	if(!can_act)
		return FALSE
	if(ranged_cooldown > world.time)
		return FALSE
	ranged_cooldown = world.time + ranged_cooldown_time
	for(var/i = 1 to 4)
		var/turf/T = get_step(get_turf(src), pick(1,2,4,5,6,8,9,10))
		if(T.density)
			i -= 1
			continue
		var/obj/projectile/despair_rapier/P
		if(nihil_present)
			P = new /obj/projectile/despair_rapier/justice(T)
		else
			P = new(T)
		P.starting = T
		P.firer = src
		P.fired_from = T
		P.yo = target.y - T.y
		P.xo = target.x - T.x
		P.original = target
		P.preparePixelProjectile(target, T)
		addtimer(CALLBACK (P, TYPE_PROC_REF(/obj/projectile, fire)), 3)
	SLEEP_CHECK_DEATH(3)
	playsound(get_turf(src), 'sound/abnormalities/despairknight/attack.ogg', 50, 0, 4)
	return

/mob/living/simple_animal/hostile/abnormality/despair_knight/Life()
	. = ..()
	if(.)
		if(!client)
			if(teleport_cooldown <= world.time)
				TryTeleport()

/mob/living/simple_animal/hostile/abnormality/despair_knight/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/despair_knight/proc/BlessedDeath(datum/source, gibbed)
	SIGNAL_HANDLER
	blessed_human.cut_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "despair", -MUTATIONS_LAYER))
	UnregisterSignal(blessed_human, COMSIG_LIVING_DEATH)
	UnregisterSignal(blessed_human, COMSIG_HUMAN_INSANE)
	blessed_human.physiology.red_mod /= 0.5
	blessed_human.physiology.white_mod /= 0.5
	blessed_human.physiology.black_mod /= 0.5
	blessed_human.physiology.pale_mod /= 2
	blessed_human.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, 50)
	blessed_human = null
	if(nihil_present) //We die during a nihil suppression if our champion dies
		death()
		return TRUE
	BreachEffect()
	return TRUE

/mob/living/simple_animal/hostile/abnormality/despair_knight/proc/TryTeleport()
	if(IsCombatMap())
		return FALSE
	if(teleport_cooldown > world.time)
		return FALSE
	if(target) // Actively fighting
		return FALSE
	teleport_cooldown = world.time + teleport_cooldown_time
	var/targets_in_range = 0
	for(var/mob/living/L in view(10, src))
		if(!faction_check_mob(L) && L.stat != DEAD && !(L.status_flags & GODMODE))
			targets_in_range += 1
	if(targets_in_range >= 3)
		return FALSE
	var/list/teleport_potential = list()
	for(var/turf/T in GLOB.department_centers)
		var/targets_at_tile = 0
		for(var/mob/living/L in view(10, T))
			if(!faction_check_mob(L) && L.stat != DEAD)
				targets_at_tile += 1
		if(targets_at_tile >= 2)
			teleport_potential += T
	if(!LAZYLEN(teleport_potential))
		return FALSE
	var/turf/teleport_target = pick(teleport_potential)
	animate(src, alpha = 0, time = 5)
	new /obj/effect/temp_visual/guardian/phase(get_turf(src))
	SLEEP_CHECK_DEATH(5) // TODO: Add some cool effects here
	animate(src, alpha = 255, time = 5)
	new /obj/effect/temp_visual/guardian/phase/out(teleport_target)
	forceMove(teleport_target)

/mob/living/simple_animal/hostile/abnormality/despair_knight/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(user.stat != DEAD && !blessed_human && istype(user) && (work_type == ABNORMALITY_WORK_ATTACHMENT))
		blessed_human = user
		RegisterSignal(user, COMSIG_LIVING_DEATH, PROC_REF(BlessedDeath))
		RegisterSignal(user, COMSIG_HUMAN_INSANE, PROC_REF(BlessedDeath))
		to_chat(user, span_nicegreen("You feel protected."))
		user.physiology.red_mod *= 0.5
		user.physiology.white_mod *= 0.5
		user.physiology.black_mod *= 0.5
		user.physiology.pale_mod *= 2
		user.add_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "despair", -MUTATIONS_LAYER))
		playsound(get_turf(user), 'sound/abnormalities/despairknight/gift.ogg', 50, 0, 2)
		user.adjust_attribute_bonus(TEMPERANCE_ATTRIBUTE, -50)
	return

/mob/living/simple_animal/hostile/abnormality/despair_knight/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	icon_living = "despair_breach"
	icon_state = icon_living
	addtimer(CALLBACK(src, PROC_REF(TryTeleport)), 5)
	return

/mob/living/simple_animal/hostile/abnormality/despair_knight/Move()
	if(!can_act)
		return FALSE
	return ..()

//Nihil Event code - TODO: Add friendly summons TODO: Add a way to teleport to nihil
/mob/living/simple_animal/hostile/abnormality/despair_knight/proc/EventStart()
	set waitfor = FALSE
	NihilModeEnable()
	ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))
	SLEEP_CHECK_DEATH(6 SECONDS)
	say("At last, a worthy foe.")
	SLEEP_CHECK_DEATH(6 SECONDS)
	say("All of my work won't be in vain.")
	SLEEP_CHECK_DEATH(6 SECONDS)
	say("You'll answer for your crimes!")
	SLEEP_CHECK_DEATH(6 SECONDS)
	say("To protect our people!")
	ChangeResistances(list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 1.0, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 0.5))

/mob/living/simple_animal/hostile/abnormality/despair_knight/proc/NihilModeEnable()
	NihilIconUpdate()
	nihil_present = TRUE
	fear_level = ZAYIN_LEVEL
	faction = list("neutral")

/mob/living/simple_animal/hostile/abnormality/despair_knight/proc/NihilIconUpdate()
	name = "Magical Girl of Justice"
	desc = "A real magical girl!"
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "despair_friendly"
	pixel_x = -8
	base_pixel_x = -8

/mob/living/simple_animal/hostile/abnormality/despair_knight/Found(atom/A)
	if(istype(A, /mob/living/simple_animal/hostile/abnormality/nihil)) // 1st Priority
		return TRUE
	return ..()

/mob/living/simple_animal/hostile/abnormality/despair_knight/petrify(statue_timer)
	if(!isturf(loc))
		MoveStatue()
	AIStatus = AI_OFF
	icon_state = "despair_breach"
	var/obj/structure/statue/petrified/magicalgirl/S = new(loc, src, statue_timer)
	S.name = "Ossified Despair"
	ADD_TRAIT(src, TRAIT_NOBLEED, MAGIC_TRAIT)
	SLEEP_CHECK_DEATH(1)
	S.icon = src.icon
	S.icon_state = src.icon_state
	S.pixel_x = -4
	S.base_pixel_x = -4
	var/newcolor = list(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
	S.add_atom_colour(newcolor, FIXED_COLOUR_PRIORITY)
	stat = DEAD
	return TRUE

/mob/living/simple_animal/hostile/abnormality/despair_knight/proc/MoveStatue()
	var/list/teleport_potential = list()
	if(!LAZYLEN(GLOB.department_centers))
		for(var/mob/living/L in GLOB.mob_living_list)
			if(L.stat == DEAD || L.z != z || L.status_flags & GODMODE)
				continue
			teleport_potential += get_turf(L)
	if(!LAZYLEN(teleport_potential))
		var/turf/P = pick(GLOB.department_centers)
		teleport_potential += P
	var/turf/teleport_target = pick(teleport_potential)
	new /obj/effect/temp_visual/guardian/phase(get_turf(src))
	new /obj/effect/temp_visual/guardian/phase/out(teleport_target)
	forceMove(teleport_target)

/mob/living/simple_animal/hostile/abnormality/despair_knight/death(gibbed)
	if(!nihil_present)
		return ..()
	adjustBruteLoss(-999999)
	visible_message(span_boldwarning("Oh no, [src] has been defeated!"))
	INVOKE_ASYNC(src, PROC_REF(petrify), 500000)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/despair_knight/gib()
	if(nihil_present)
		death()
		return FALSE
	return ..()

