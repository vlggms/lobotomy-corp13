//The real clerk lives matter abnormality -Coxswain
#define STATUS_EFFECT_CHOSEN /datum/status_effect/chosen
/mob/living/simple_animal/hostile/abnormality/puss_in_boots
	name = "Puss in Boots"
	desc = "A scraggly looking black cat, it seems like the boots are missing."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "cat_contained"
	var/icon_aggro = "cat_breached"
	var/icon_friendly = "cat_breached_friendly"
	icon_dead = "cat_breached"  //defeated icon? Maybe someday.
	portrait = "puss_in_boots"
	maxHealth = 1000
	health = 1000
	threat_level = HE_LEVEL
	faction = list("neutral")
	del_on_death = FALSE
	attack_sound = 'sound/weapons/ego/rapier1.ogg'
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 5
	melee_damage_upper = 15
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	rapid_melee = 4
	can_breach = TRUE
	ranged = TRUE
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = 0,
		ABNORMALITY_WORK_ATTACHMENT = 45,
		ABNORMALITY_WORK_REPRESSION = list(50, 45, 40, 40, 40),
	)
	work_damage_amount = 10
	work_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/inheritance,
		/datum/ego_datum/armor/inheritance,
	)
	gift_type =  /datum/ego_gifts/inheritance
	abnormality_origin = "Artbook"

	//Work/misc Vars
	var/list/stats = list(
		FORTITUDE_ATTRIBUTE,
		PRUDENCE_ATTRIBUTE,
		TEMPERANCE_ATTRIBUTE,
		JUSTICE_ATTRIBUTE,
	)
	pet_bonus = "meows" //saves a few lines of code by allowing funpet() to be called by attack_hand()
	var/mob/living/carbon/human/blessed_human = null
	var/friendly
	var/ignored = FALSE // If you ignore a meltdown it gets mad
	//Breach Vars
	var/return_timer
	var/finisher_cooldown = 0
	var/finisher_cooldown_time = 60 SECONDS
	var/can_act = TRUE
	var/finishing = FALSE

//Init stuff
/mob/living/simple_animal/hostile/abnormality/puss_in_boots/Initialize()
	. = ..()
	for(var/mob/living/carbon/human/potential_user in GLOB.player_list)
		if(!potential_user.has_status_effect(STATUS_EFFECT_CHOSEN))
			continue
		blessed_human = potential_user
		friendly = TRUE
		return

//Blessing
/mob/living/simple_animal/hostile/abnormality/puss_in_boots/funpet(mob/living/carbon/human/user)
	if(!IsContained(src))
		return
	if(user.stat != DEAD && !blessed_human && istype(user))
		if(get_user_level(user) >= 2)
			say("I cannot teach you anything, human.")
			return
		blessed_human = user
		Blessing(user)
		playsound(get_turf(user), 'sound/abnormalities/pussinboots/gatoblessing.ogg', 50, 0, 2)
		friendly = TRUE
		say("At last, someone worthy!")

/mob/living/simple_animal/hostile/abnormality/puss_in_boots/proc/Blessing(mob/living/carbon/human/user)
	var/datum/status_effect/chosen/status_holder = blessed_human.has_status_effect(/datum/status_effect/chosen)
	if(status_holder)
		return
	user.apply_status_effect(STATUS_EFFECT_CHOSEN)
	RegisterSignal(user, COMSIG_LIVING_DEATH, PROC_REF(BlessedDeath))
	RegisterSignal(user, COMSIG_HUMAN_INSANE, PROC_REF(BlessedDeath))
	RegisterSignal(user, COMSIG_WORK_STARTED, PROC_REF(OnWorkStart))
	RegisterSignal(SSdcs, COMSIG_GLOB_ABNORMALITY_BREACH, PROC_REF(OnAbnoBreach))

/mob/living/simple_animal/hostile/abnormality/puss_in_boots/proc/BlessedDeath(datum/source, gibbed)
	SIGNAL_HANDLER
	blessed_human.remove_status_effect(STATUS_EFFECT_CHOSEN)
	UnregisterSignal(blessed_human, COMSIG_LIVING_DEATH)
	UnregisterSignal(blessed_human, COMSIG_HUMAN_INSANE)
	UnregisterSignal(blessed_human, COMSIG_WORK_STARTED)
	friendly = FALSE
	GoToFriend()
	BreachEffect()
	blessed_human = null
	return TRUE

/mob/living/simple_animal/hostile/abnormality/puss_in_boots/proc/OnWorkStart(datum/source, datum/abnormality/abno_reference, mob/living/carbon/human/user, work_type)
	SIGNAL_HANDLER
	if(abno_reference == datum_reference)
		return FALSE
	BlessedDeath(blessed_human)

//Qliphoth Stuff
/mob/living/simple_animal/hostile/abnormality/puss_in_boots/proc/OnAbnoBreach(datum/source, mob/living/simple_animal/hostile/abnormality/abno)
	SIGNAL_HANDLER
	if(!IsContained(src))
		return
	if(abno == src)
		if(client)
			to_chat(src, span_notice("You start feeling a bit impatient."))
		else
			manual_emote("perks up for a moment, then settles back down, looking annoyed.")
		return
	if(datum_reference.qliphoth_meter > 1)
		if(client)
			to_chat(src, span_notice("You hear something..."))
		else
			manual_emote("perks up slightly, as though it hears something.")
	datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/puss_in_boots/MeltdownStart()
	. = ..()
	ignored = TRUE

/mob/living/simple_animal/hostile/abnormality/puss_in_boots/ZeroQliphoth(mob/living/carbon/human/user)
	if(ignored && blessed_human)
		BlessedDeath(blessed_human)
		return
	..()

/mob/living/simple_animal/hostile/abnormality/puss_in_boots/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	ignored = FALSE

//Breach
/mob/living/simple_animal/hostile/abnormality/puss_in_boots/Life()
	. = ..()
	if(!blessed_human)
		return

	if(get_user_level(blessed_human) >= 2) //no buffing to get ahead
		BlessedDeath(blessed_human)
		return

/mob/living/simple_animal/hostile/abnormality/puss_in_boots/Move()
	if(!can_act)
		return FALSE
	..()

/mob/living/simple_animal/hostile/abnormality/puss_in_boots/AttackingTarget()
	if(!can_act)
		return FALSE
	..()

/mob/living/simple_animal/hostile/abnormality/puss_in_boots/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	desc = "He's got a sword!"
	if(friendly)
		fear_level = ZAYIN_LEVEL
		health = 300 //He's pretty tough at max HP
		addtimer(CALLBACK(src, PROC_REF(escape)), 45 SECONDS)
		GoToFriend()
		density = FALSE
		icon_state = icon_friendly
		update_icon()
		return
	if(!density) //sanity check for if he was friendly breaching and is no longer friendly
		density = TRUE
		fear_level = HE_LEVEL
		FearEffect()
		src.visible_message(span_warning("[src] is looking around, eyes wild with rage!"))
	icon_state = icon_aggro
	update_icon()
	faction = list("hostile") //he's gone feral!
	return

/mob/living/simple_animal/hostile/abnormality/puss_in_boots/proc/GoToFriend()
	if(!blessed_human)
		return
	var/turf/origin = get_turf(blessed_human)
	var/list/all_turfs = RANGE_TURFS(2, origin)
	for(var/turf/T in all_turfs)
		if(T == origin)
			continue
		var/available_turf
		var/list/blessed_human_line = getline(T, blessed_human)
		for(var/turf/line_turf in blessed_human_line) //checks if there's a valid path between the turf and the friend
			if(line_turf.is_blocked_turf(exclude_mobs = TRUE))
				available_turf = FALSE
				break
			available_turf = TRUE
		if(!available_turf)
			continue
		playsound(src, 'sound/weapons/fwoosh.ogg', 250, FALSE, 4)
		forceMove(T)
		if(friendly)
			src.visible_message(span_nicegreen("[src] looks ready to help [blessed_human]!"))
		else
			src.visible_message(span_warning("[src] looks angrily at [blessed_human]!"))
		LoseTarget()
		for(var/mob/living/enemy in oview(src, vision_range))
			if(enemy == blessed_human)
				continue
			if(friendly && ishuman(enemy))
				continue
			if(enemy.stat != DEAD)
				GiveTarget(enemy) //the moment he teleports he's already on the offensive
				break
		return

//Attacks
/mob/living/simple_animal/hostile/abnormality/puss_in_boots/proc/Execute(target)
	if(finisher_cooldown > world.time)
		return
	if(!isliving(target))
		return
	var/mob/living/T = target
	finisher_cooldown = world.time + finisher_cooldown_time
	playsound(src, 'sound/abnormalities/crumbling/warning.ogg', 50, 1)
//	icon_state = "cat_prepare" maybe someday we'll have nice things
	can_act = FALSE
	finishing = TRUE
	face_atom(target)
	T.add_overlay(icon('icons/effects/effects.dmi', "zorowarning"))
	addtimer(CALLBACK(T, TYPE_PROC_REF(/atom, cut_overlay), \
							icon('icons/effects/effects.dmi', "zorowarning")), 40)
	say("En garde!")
	SLEEP_CHECK_DEATH(40)
//	icon_state = "cat_dash" //ditto
	if(target in view(10, src))
		var/turf/jump_turf = get_step(target, pick(GLOB.alldirs))
		if(jump_turf.is_blocked_turf(exclude_mobs = TRUE))
			jump_turf = get_turf(target)
		T.add_overlay(icon('icons/effects/effects.dmi', "zoro"))
		addtimer(CALLBACK(T, TYPE_PROC_REF(/atom, cut_overlay), \
								icon('icons/effects/effects.dmi', "zoro")), 14)
		playsound(target, 'sound/abnormalities/pussinboots/slash.ogg', 50, 0, 2)
		forceMove(jump_turf)
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			H.Stun(9)
		else
			can_act = TRUE
		SLEEP_CHECK_DEATH(3)
		playsound(target, 'sound/abnormalities/pussinboots/counterslash.ogg', 50, 0, 2)
		SLEEP_CHECK_DEATH(6)
		playsound(target, 'sound/abnormalities/crumbling/attack.ogg', 50, 1)
		Finisher(target)
	can_act = TRUE
	finishing = FALSE
	if(friendly)
		icon_state = icon_friendly
		return
	icon_state = icon_aggro

/mob/living/simple_animal/hostile/abnormality/puss_in_boots/proc/Finisher(mob/living/target) //This is super easy to avoid
	target.apply_damage(50, PALE_DAMAGE, null, target.run_armor_check(null, RED_DAMAGE)) //50% of your health in red damage
	to_chat(target, span_danger("[src] is trying to cut you in half!"))
	if(!ishuman(target))
		target.apply_damage(100, PALE_DAMAGE, null, target.run_armor_check(null, PALE_DAMAGE)) //bit more than usual DPS in pale damage
		return
	if(target.health > 0)
		return
	var/mob/living/carbon/human/H = target
	new /obj/effect/temp_visual/human_horizontal_bisect(get_turf(H))
	H.set_lying_angle(360) //gunk code I know, but it is the simplest way to override gib_animation() without touching other code. Also looks smoother.
	H.gib()

/mob/living/simple_animal/hostile/abnormality/puss_in_boots/OpenFire()
	if(!can_act)
		return
	if((finisher_cooldown < world.time) && prob(50))
		Execute(target)
	return

//Death/Defeat
/mob/living/simple_animal/hostile/abnormality/puss_in_boots/death(gibbed)
	if(health <= 0)
		playsound(get_turf(src), 'sound/abnormalities/doomsdaycalendar/Limbus_Dead_Generic.ogg', 50, 0, 2)
	density = FALSE
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/puss_in_boots/proc/escape()
	if(!friendly)
		return
	if(finishing) //we dont wanna interrupt
		addtimer(CALLBACK(src, PROC_REF(escape)), 7 SECONDS)
		return
	death()

//Status Effects
/datum/status_effect/chosen
	id = "chosen"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = null
	var/attribute_bonus = 0
	tick_interval = 600 //stats update every 60s
	var/obj/item/ego_weapon/lance/chosen_arms = null

/datum/status_effect/chosen/on_apply()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/user = owner
	to_chat(user, span_nicegreen("You feel protected."))
	user.add_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "inheritance", -MUTATIONS_LAYER))
	StatUpdate(user)
	user.physiology.red_mod *= 0.8
	user.physiology.white_mod *= 0.8
	user.physiology.black_mod *= 0.8
	user.physiology.pale_mod *= 0.8
	chosen_arms = new /obj/item/ego_weapon/lance/famiglia(get_turf(user))
	return ..()

/datum/status_effect/chosen/on_remove()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/user = owner
	user.cut_overlay(mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "inheritance", -MUTATIONS_LAYER))
	user.physiology.red_mod /= 0.8
	user.physiology.white_mod /= 0.8
	user.physiology.black_mod /= 0.8
	user.physiology.pale_mod /= 0.8
	for(var/attribute in user.attributes)
		user.adjust_attribute_buff(attribute, -attribute_bonus)
	QDEL_IN(chosen_arms, 30)
	return ..()

/datum/status_effect/chosen/tick()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/user = owner
	StatUpdate(user)
	return ..()

/datum/status_effect/chosen/proc/StatUpdate(mob/living/carbon/human/user)
	var/new_bonus = 0
	if(world.time >= 75 MINUTES) // Full facility expected
		new_bonus = 80
	else if(world.time >= 60 MINUTES) // More than one ALEPH
		new_bonus = 60
	else if(world.time >= 45 MINUTES) // Wowzer, an ALEPH?
		new_bonus = 50
	else if(world.time >= 30 MINUTES) // Expecting WAW
		new_bonus = 40
	else if(world.time >= 15 MINUTES) // Usual time for HEs
		new_bonus = 30
	else
		new_bonus = 20
	if(new_bonus <= attribute_bonus)
		return
	for(var/attribute in user.attributes)
		user.adjust_attribute_buff(attribute, (new_bonus - attribute_bonus)) //should keep the bonus dynamically updated
	attribute_bonus = new_bonus
	return

#undef STATUS_EFFECT_CHOSEN
