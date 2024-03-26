//Coded by Kirie Saito! EGO done by Chiemi <3
/mob/living/simple_animal/hostile/abnormality/titania
	name = "Titania"
	desc = "A gargantuan fairy."
	icon = 'ModularTegustation/Teguicons/32x64.dmi'
	icon_state = "titania"
	icon_living = "titania"
	portrait = "titania"
	maxHealth = 3500
	health = 3500
	is_flying_animal = TRUE
	threat_level = ALEPH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 0, 45, 50),
		ABNORMALITY_WORK_INSIGHT = list(0, 0, 0, 30, 40),
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 10, 20, 35),
		ABNORMALITY_WORK_REPRESSION = 0,
	)
	start_qliphoth = 3
	move_to_delay = 4

	work_damage_amount = 16
	work_damage_type = RED_DAMAGE
	can_breach = TRUE

	melee_damage_lower = 92
	melee_damage_upper = 99		//Will never one shot you.
	melee_damage_type = RED_DAMAGE
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1)
	stat_attack = HARD_CRIT

	ego_list = list(
		/datum/ego_datum/weapon/soulmate,
		/datum/ego_datum/armor/soulmate,
	)
	gift_type = /datum/ego_gifts/soulmate
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	var/fairy_spawn_number = 2
	var/fairy_spawn_time = 5 SECONDS
	var/fairy_spawn_limit = 70 // Oh boy, what can go wrong?
	//Fairy spawn limit only matters for the spawn loop, players she kills and spawned via the law don't count
	var/list/spawned_mobs = list()
	var/list/worked = list()
	var/mob/living/carbon/human/nemesis			//Who is her nemesis?
	//The nemesis is referred to as Oberon in the rest of the comments.

	//Laws
	var/list/laws = list("melee", "ranged", "fairy", "armor", "nemesis", "ranged fairy")
	var/currentlaw
	var/nextlaw
	var/law_damage = 30		//Take damage, idiot
	var/law_timer = 60 SECONDS
	var/law_startup = 3 SECONDS
	//Oberon stuff
	var/fused = FALSE

/mob/living/simple_animal/hostile/abnormality/titania/Life()
	. = ..()
	if(fused) // So you can't just spoon her to death while in nobody is.
		adjustBruteLoss(-(maxHealth))

/mob/living/simple_animal/hostile/abnormality/titania/Move()
	if(fused)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/titania/CanAttack(atom/the_target)
	if(fused)
		return FALSE
	return ..()

//Attacking code
/mob/living/simple_animal/hostile/abnormality/titania/AttackingTarget()
	if(fused)
		return FALSE
	var/mob/living/carbon/human/H = target
	//Kills the weak immediately.
	if(get_user_level(H) < 4 && (ishuman(H)))
		say("I rid you of your pain, mere human.")
		H.gib()
		for(var/i=fairy_spawn_number*2, i>=1, i--)	//This counts down.
			var/mob/living/simple_animal/hostile/fairyswarm/V = new(get_turf(target))
			V.faction = faction
			spawned_mobs+=V
		return

	if(target == nemesis)	//Deals pale damage to Oberon, fuck you.
		melee_damage_type = PALE_DAMAGE
		melee_damage_lower = 61
		melee_damage_upper = 72
	else if(nemesis)		//If there's still a nemesis, you need to reset the damage
		melee_damage_type = initial(melee_damage_type)
		melee_damage_lower = initial(melee_damage_lower)
		melee_damage_upper = initial(melee_damage_upper)
	. = ..()

	if(H.stat == DEAD && target == nemesis)		//Does she slay Oberon personally? If so, get buffed.
		SpeedChange(-1)
		melee_damage_lower = 110
		melee_damage_upper = 140
		adjustBruteLoss(-maxHealth) // Round 2, baby

		to_chat(src, span_userdanger("[nemesis], my beloved devil, I finally get my revenge."))
		nemesis = null
		if(!client)
			say("Oberon. The abhorrent taker of my child. You are slain.")


//Spawning Fairies
/mob/living/simple_animal/hostile/abnormality/titania/proc/FairyLoop()
	if(IsCombatMap())
		return
	//Blurb about how many we have spawned
	listclearnulls(spawned_mobs)
	for(var/mob/living/L in spawned_mobs)
		if(L.stat == DEAD)
			qdel(L)
			spawned_mobs -= L
	if(length(spawned_mobs) >= fairy_spawn_limit)
		return

	//Actually spawning them
	for(var/i=fairy_spawn_number, i>=1, i--)	//This counts down.
		var/mob/living/simple_animal/hostile/fairyswarm/V = new(get_turf(src))
		V.faction = faction
		spawned_mobs+=V
	addtimer(CALLBACK(src, PROC_REF(FairyLoop)), fairy_spawn_time)

//Setting the nemesis
/mob/living/simple_animal/hostile/abnormality/titania/proc/ChooseNemesis()
	if(IsCombatMap())
		return

	var/list/potentialmarked = list()
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		if(get_user_level(L) <= 4 )	//Only the strongest.
			continue
		potentialmarked += L
	if(LAZYLEN(potentialmarked))
		nemesis = pick(potentialmarked)

//Cleaning fairies
/mob/living/simple_animal/hostile/abnormality/titania/death(gibbed)
	for(var/mob/living/A in spawned_mobs)
		A.death()
	..()


//------------------------------------------------------------------------------
//Fairy Laws
//------------------------------------------------------------------------------

/mob/living/simple_animal/hostile/abnormality/titania/proc/SetLaw()
	if(IsCombatMap())
		return


	var/lawmessage

	if(!nemesis || nemesis.stat == DEAD || fused)
		laws -= "nemesis"
	nextlaw = pick(laws.Copy() - currentlaw)

	switch(nextlaw)
		if("melee")
			lawmessage = "Thou shalt not hit thy queen with melee attacks."
		if("ranged")
			lawmessage = "Thou shalt not hit thy queen with ranged attacks."
		if("fairy")
			lawmessage = "Mine fairies are now heartier."
		if("armor")
			lawmessage = "Thy queen shalt not be hurt by red damage."
		if("nemesis")		//This mostly is so that you can tell who the nemesis is, and to encourage them to fight her.
			lawmessage = "No one but [nemesis] shalt hurt thy queen."
		if("ranged fairy")
			lawmessage = "Mine fairies will come to my aid if you strike me with ranged attacks."

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		to_chat(H, span_colossus("[lawmessage]"))
	addtimer(CALLBACK(src, PROC_REF(ActivateLaw)), law_startup)	//Start Law 3 Seconds


/mob/living/simple_animal/hostile/abnormality/titania/proc/ActivateLaw()
	addtimer(CALLBACK(src, PROC_REF(SetLaw)), law_timer)	//Set Laws in 30 Seconds
	currentlaw = nextlaw
	to_chat(GLOB.clients, span_danger("The new law is now in effect."))

	if(currentlaw == "fairies")
		for(var/mob/living/simple_animal/L in spawned_mobs)
			L.ChangeResistances(list(RED_DAMAGE = 0.2, WHITE_DAMAGE = 0.2, BLACK_DAMAGE = 0.2, PALE_DAMAGE = 1))
	else
		for(var/mob/living/simple_animal/L in spawned_mobs)
			L.ChangeResistances(list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1))


/mob/living/simple_animal/hostile/abnormality/titania/proc/Punishment(mob/living/sinner)
	to_chat(sinner, span_userdanger("You are hurt due to breaking Fairy Law."))
	sinner.apply_damage(law_damage, PALE_DAMAGE, null, sinner.run_armor_check(null, PALE_DAMAGE), spread_damage = TRUE)
	new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(sinner), pick(GLOB.alldirs))

//Ranged stuff
/mob/living/simple_animal/hostile/abnormality/titania/bullet_act(obj/projectile/Proj)
	..()

	if(!ishuman(Proj.firer))
		return

	var/mob/living/carbon/human/H = Proj.firer

	if(currentlaw == "ranged")
		Punishment(Proj.firer)

	if(currentlaw == "armor" && Proj.damage_type == RED_DAMAGE)
		Punishment(Proj.firer)

	if(currentlaw == "nemesis" && H != nemesis)
		Punishment(Proj.firer)

	if(currentlaw == "ranged fairy")
		var/mob/living/simple_animal/hostile/fairyswarm/V = new(get_turf(src))
		V.faction = faction
		spawned_mobs+=V

//Melee stuff
/mob/living/simple_animal/hostile/abnormality/titania/attacked_by(obj/item/I, mob/living/user)
	..()

	if(!user)
		return

	if(currentlaw == "melee")
		Punishment(user)

	if(currentlaw == "armor" && I.damtype == RED_DAMAGE && I.force >= 10)
		Punishment(user)

	if(currentlaw == "nemesis" && user != nemesis)
		Punishment(user)



//Breach, work, 'n' stuff
/mob/living/simple_animal/hostile/abnormality/titania/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	ChooseNemesis()
	addtimer(CALLBACK(src, PROC_REF(FairyLoop)), 10 SECONDS)	//10 seconds from now you start spawning fairies
	addtimer(CALLBACK(src, PROC_REF(SetLaw)), law_timer)	//Set Laws in 30 Seconds
	if(nemesis)
		to_chat(src, span_userdanger("[nemesis], you are to die!"))
	if(!client && nemesis)
		say("[nemesis], you are a monster and I will slay you.")

/mob/living/simple_animal/hostile/abnormality/titania/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(!(user in worked))
		datum_reference.qliphoth_change(-1)
		worked+=user
	return

/mob/living/simple_animal/hostile/abnormality/titania/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)


//The Mini fairies
/mob/living/simple_animal/hostile/fairyswarm
	name = "fairy"
	desc = "A tiny, extremely hungry fairy."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "fairyswarm"
	icon_living = "fairyswarm"
	pass_flags = PASSTABLE | PASSMOB
	is_flying_animal = TRUE
	density = FALSE
	a_intent = INTENT_HARM
	health = 80
	maxHealth = 80
	melee_damage_lower = 12
	melee_damage_upper = 15
	melee_damage_type = RED_DAMAGE
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	attack_verb_continuous = "cuts"
	attack_verb_simple = "cut"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	mob_size = MOB_SIZE_TINY
	del_on_death = TRUE

/mob/living/simple_animal/hostile/fairyswarm/Initialize()
	. = ..()
	pixel_x = rand(-16, 16)
	pixel_y = rand(-16, 16)
