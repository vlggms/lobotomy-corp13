#define STATUS_EFFECT_ACIDIC_GOO  /datum/status_effect/wrath_burning
/mob/living/simple_animal/hostile/abnormality/servant_wrath
	name = "\proper Servant of Wrath"
	desc = "A small girl in a puffy green magical girl outfit. \
		She seems lonely."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "wrath"
	icon_living = "wrath"
	faction = list("wrath")
	speak_emote = list()
	gender = FEMALE

	ranged = TRUE
	maxHealth = 1800
	health = 1800
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.3, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 1.5)

	move_to_delay = 6
	is_flying_animal = TRUE

	threat_level = WAW_LEVEL
	can_breach = TRUE
	start_qliphoth = 5
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 30,
		ABNORMALITY_WORK_INSIGHT = list(40, 45, 50, 55, 60),
		ABNORMALITY_WORK_ATTACHMENT = list(80, 70, 60, 50, 40),
		ABNORMALITY_WORK_REPRESSION = list(30, 30, 40, 40, 50),
		"Request" = 100
	)
	work_damage_amount = 12
	work_damage_type = BLACK_DAMAGE

	armortype = RED_DAMAGE
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 30
	melee_damage_upper = 45
	rapid_melee = 2
	attack_sound = 'sound/abnormalities/wrath_servant/small_smash1.ogg'
	stat_attack = HARD_CRIT

	can_patrol = FALSE

	gift_type = /datum/ego_gifts/blind_rage

	ego_list = list(
		/datum/ego_datum/weapon/blind_rage,
		/datum/ego_datum/armor/blind_rage
	)
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	var/friendly = TRUE
	var/list/friend_ship = list()
	var/instability = 0

	COOLDOWN_DECLARE(dash)
	var/dash_cooldown = 15 SECONDS
	COOLDOWN_DECLARE(smash)
	var/smash_cooldown = 30 SECONDS
	var/smash_damage = 40
	var/smash_damage_type = RED_DAMAGE
	COOLDOWN_DECLARE(stun)
	var/stunned_cooldown = 20 SECONDS


	var/can_act = TRUE
	var/stunned = FALSE
	var/ending = FALSE
	var/hunted_target


/datum/action/innate/abnormality_attack/wrath_smash
	name = "Blind Rage"
	icon_icon = 'icons/obj/ego_weapons.dmi'
	button_icon_state = "blind_rage"
	chosen_message = "<span class='colossus'>You will now smash everything around you.</span>"
	chosen_attack_num = 1

/datum/action/innate/abnormality_attack/wrath_dash
	name = "Dash"
	desc = "Rapidly speed up for a short duration."
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "jetboot"
	chosen_attack_num = 2

/mob/living/simple_animal/hostile/abnormality/servant_wrath/Initialize(mapload)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, .proc/OnMobDeath)

/mob/living/simple_animal/hostile/abnormality/servant_wrath/IsContained()
	if((status_flags & GODMODE) && !stunned)
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/servant_wrath/OpenFire(atom/A)
	if(!can_act || stunned)
		return
	if(client)
		switch(chosen_attack)
			if(1)
				if(COOLDOWN_FINISHED(src, smash))
					Smash()
			if(2)
				if(COOLDOWN_FINISHED(src, dash))
					Dash()
		return

	if(get_dist(src, target) >= 3 && COOLDOWN_FINISHED(src, dash))
		Dash()
		return
	if(get_dist(src, target) > 2 && COOLDOWN_FINISHED(src, smash))
		Smash()
		return

/mob/living/simple_animal/hostile/abnormality/servant_wrath/Life()
	. = ..()
	if(IsContained() || !can_act)
		return
	if(stunned && COOLDOWN_FINISHED(src, stun))
		for(var/mob/living/L in range(10, src))
			if(istype(L, /mob/living/simple_animal/hostile/azure_hermit) || istype(L, /mob/living/simple_animal/hostile/azure_stave))
				continue
			L.apply_damage(30, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
			var/obj/effect/temp_visual/eldritch_smoke/ES = new(get_turf(L))
			ES.color = COLOR_GREEN
		COOLDOWN_START(src, stun, stunned_cooldown)
	if(stunned)
		return
	var/mob/living/simple_animal/hostile/azure_hermit/AH = locate() in view(5, src)
	if(AH?.status_flags & GODMODE)
		manual_emote("smashes the Azure Hermit with it's hammer.")
		PerformEnding(AH)
		return
	if(isnull(hunted_target) || !hunted_target)
		return
	if(!(hunted_target in livinginview(7, src)))
		var/list/possible_turfs = view(2, hunted_target) - range(1, hunted_target)
		if(!possible_turfs.len)
			possible_turfs += get_turf(hunted_target)
		for(var/turf/T in possible_turfs)
			if(T.density)
				continue
			Teleport(T)
			break

/mob/living/simple_animal/hostile/abnormality/servant_wrath/attack_hand(mob/living/carbon/human/M)
	if(!stunned)
		return ..()
	to_chat(M, "<span class='warning'>You start pulling the staff from the [src]!</span>")
	if(!do_after(M, 2 SECONDS, src) || !stunned)
		to_chat(M, "<span class='warning'>You let go before the staff is free!</span>")
		return
	to_chat(M, "<span class='warning'>The staff rips free from the [src]!</span>")
	Unstun()
	return

/mob/living/simple_animal/hostile/abnormality/servant_wrath/proc/AdjustInstability(amount = 0)
	instability = clamp(instability + amount, (4*length(friend_ship)), 100)
	if(!IsContained())
		return TRUE
	switch(instability)
		if(0 to 10)
			desc = initial(desc)
			icon_state = initial(icon_state)
		if(10 to 20)
			desc = "A small girl in a puffy green magical girl outfit. She smiles as you approach."
			icon_state = initial(icon_state)
		if(20 to 30)
			desc = "A small girl in a puffy orange magical girl outfit. Uncertainty fills the air."
			icon_state = "wrath_1"
		if(30 to 100)
			desc = "A small girl in a puffy red magical girl outfit. It seems she has a headache."
			icon_state = "wrath_2"
	return TRUE

/mob/living/simple_animal/hostile/abnormality/servant_wrath/proc/Unstun()
	if(!stunned)
		return
	status_flags &= ~GODMODE
	adjustBruteLoss(-maxHealth)
	stunned = FALSE
	icon_state = icon_living
	desc = "A large red monster with white bandages hanging from it. It's flesh oozes a bubble acid."
	manual_emote("begins to move once more!")

/mob/living/simple_animal/hostile/abnormality/servant_wrath/Move()
	if(!can_act || stunned)
		return FALSE
	..()

/mob/living/simple_animal/hostile/abnormality/servant_wrath/Found(atom/A)
	if(istype(A, /mob/living/simple_animal/hostile/azure_stave)) // 1st Priority
		return TRUE
	if(istype(A, /mob/living/simple_animal/hostile/azure_hermit)) // 2nd Priority
		return TRUE
	return FALSE // Everything Else

/mob/living/simple_animal/hostile/abnormality/servant_wrath/PickTarget(list/Targets)
	if(!isnull(hunted_target))
		return hunted_target
	return ..()

/mob/living/simple_animal/hostile/abnormality/servant_wrath/AttackingTarget(atom/attacked_target)
	if(!can_act || stunned)
		return
	if(COOLDOWN_FINISHED(src, smash) && prob(30) && !client)
		Smash()
		return
	if(prob(5))
		if(friendly)
			new /obj/effect/gibspawner/generic/silent/wrath_acid(get_turf(target))
		else
			new /obj/effect/gibspawner/generic/silent/wrath_acid/bad(get_turf(target))
	. = ..()
	attack_sound = pick('sound/abnormalities/wrath_servant/small_smash1.ogg','sound/abnormalities/wrath_servant/small_smash2.ogg')
	if(!isliving(target) || (get_dist(target, src) > 1))
		return
	var/mob/living/L = target
	L.apply_damage(rand(10, 15), BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
	if(!istype(target, /mob/living/simple_animal/hostile/azure_hermit))
		return
	var/mob/living/simple_animal/hostile/azure_hermit/AZ = target
	if(AZ.health > 120)
		return
	PerformEnding(AZ)

/mob/living/simple_animal/hostile/abnormality/servant_wrath/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	. = ..()
	if(prob(instability))
		datum_reference.qliphoth_change(-1)
		if(LAZYLEN(friend_ship))
			var/mob/living/L = pick(friend_ship)
			say("I... I shouldn't be treating them this way... [L.first_name()]...")
		else
			say("No... I must keep my mind in check. I'm sorry, [user.first_name()].")
	switch(work_type)
		if(ABNORMALITY_WORK_ATTACHMENT)
			AdjustInstability(4) // Was 2
			if(!(user in friend_ship) && (pe >= datum_reference.success_boxes))
				say(pick("You want to be my friend..?", "'Friend' is not a word in the book of law...", "I can be a friend that you deserve."))
				friend_ship += user
				AdjustInstability(8) // Was 5
				return
		if(ABNORMALITY_WORK_REPRESSION)
			instability = clamp(instability - max(instability*0.2, 2), (4*length(friend_ship)), 100)
			return
	if(pe >= src.datum_reference.success_boxes)
		AdjustInstability(3) // Was 2
	if(user in friend_ship)
		say("It was good to see you again, [user.first_name()].")
		to_chat(user, "<span class='nicegreen'>A light green light flows over you... You feel better!</span>")
		user.adjustBruteLoss(-20)
		user.adjustSanityLoss(-20)
		AdjustInstability(3) // Was 1
	return

/mob/living/simple_animal/hostile/abnormality/servant_wrath/AttemptWork(mob/living/carbon/human/user, work_type)
	if(work_type != "Request")
		return ..()
	if(!(user in friend_ship))
		say("All are to be treated equally, even those you keep in cages. You are no exception, [user.first_name()].")
		return FALSE
	if(!IsContained())
		to_chat(user, "<span>There's no one here to make a request of...</span>")
		return FALSE
	if(src.datum_reference.qliphoth_meter <= 2)
		friendly = FALSE
		say("I must... uphold balance... I...")
		SLEEP_CHECK_DEATH(1 SECONDS)
		say("I've made a mistake once again!!!")
		SLEEP_CHECK_DEATH(1 SECONDS)
		BreachEffect(user)
		say("I-I... What a foolish deed I've done...")
		return FALSE
	friendly = TRUE
	BreachEffect(user)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/servant_wrath/ZeroQliphoth(mob/living/carbon/human/user)
	friendly = FALSE
	BreachEffect()
	return

/mob/living/simple_animal/hostile/abnormality/servant_wrath/BreachEffect(mob/living/carbon/human/user)
	if(friendly)
		instability += 10
		icon_state = icon_living
		var/list/possible_targets = list()
		for(var/mob/living/simple_animal/hostile/H in GLOB.mob_living_list)
			if(H.status_flags & GODMODE)
				continue
			if(H.z != z) // ANTI-ADMEME MEASURE
				continue
			if(H.stat == DEAD)
				continue
			possible_targets += H
			break
		var/list/highest_params = list(0, 0)
		for(var/mob/living/simple_animal/hostile/H in possible_targets) // This SHOULD hunt the biggest dude around
			if(H == src)
				continue
			if(faction_check_mob(H))
				continue
			if(H.damage_coeff[RED_DAMAGE] <= 0) // Can't be hurt (Feasibly)
				continue
			if(H.health < highest_params[1])
				continue
			if(H.health == highest_params[1])
				if(H.getMaxHealth() <= highest_params[2])
					continue
			if(H.melee_damage_type == WHITE_DAMAGE)
				highest_params = list(H.health*0.5, H.getMaxHealth()*0.5) // Reduced odds of hunting a white-damage target.
			else
				highest_params = list(H.health, H.getMaxHealth())
			hunted_target = H
		if(!hunted_target)
			return FALSE
		say("If it's to help a friend...")
		SLEEP_CHECK_DEATH(8)
		src.datum_reference.qliphoth_change(-2)
		src.faction = list("neutral")
		fear_level = TETH_LEVEL
		toggle_ai(AI_ON)
		status_flags &= ~GODMODE
		Teleport(get_turf(hunted_target))
		return
	can_act = FALSE
	instability = 0
	REMOVE_TRAIT(src, TRAIT_MOVE_FLYING, ROUNDSTART_TRAIT)
	src.faction = list("wrath")
	src.icon = 'ModularTegustation/Teguicons/96x64.dmi'
	icon_state = "wrath"
	pixel_x = -32
	base_pixel_x = -32
	fear_level = WAW_LEVEL
	speak_emote = list("growls")
	friendly = FALSE
	adjustBruteLoss(-src.getMaxHealth())
	playsound(src, 'sound/abnormalities/wrath_servant/enrage.ogg', 100, FALSE, 40, falloff_distance = 20)
	toggle_ai(AI_ON)
	status_flags &= ~GODMODE
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_ABNORMALITY_BREACH, src)
	FearEffect()
	say("EMBODIMENTS OF EVIL!!!")
	desc = "A large red monster with white bandages hanging from it. It's flesh oozes a bubble acid."
	can_act = TRUE
	for(var/turf/dep in GLOB.department_centers)
		if(get_dist(src, dep) < 30)
			continue
		new /mob/living/simple_animal/hostile/azure_hermit(dep)
		playsound(dep, 'sound/abnormalities/wrath_servant/hermit_magic.ogg', 60, FALSE, 10)
		break

/mob/living/simple_animal/hostile/abnormality/servant_wrath/proc/Dash()
	TemporarySpeedChange(-4, 1 SECONDS)
	COOLDOWN_START(src, dash, dash_cooldown)

/mob/living/simple_animal/hostile/abnormality/servant_wrath/proc/Smash()
	if(!can_act || stunned)
		return FALSE
	can_act = FALSE
	var/list/turf/hit_turfs = list()
	COOLDOWN_START(src, smash, smash_cooldown)
	if(!friendly)
		icon_state = "wrath_charge"
		playsound(src, 'sound/abnormalities/wrath_servant/enrage.ogg', 75, FALSE, 20, falloff_distance = 10)
	manual_emote("raises [friendly ? "their" : "it's"] hammers!")
	var/list/show_area = list()
	show_area |= range(3, src)
	show_area |= view(5, src)
	for(var/turf/sT in show_area)
		new /obj/effect/temp_visual/cult/sparks(sT)
	SLEEP_CHECK_DEATH(1.5 SECONDS)
	if(stunned)
		can_act = TRUE
		icon_state = "wrath_stun"
		return
	if(!friendly)
		icon_state = "wrath_smash"
	for(var/x = 1 to 3)
		var/list/been_hit = list()
		playsound(src, "sound/abnormalities/wrath_servant/big_smash[x].ogg", 75, FALSE, 20, falloff_distance = 10) // heard from a distance
		for(var/i = 1 to 5)
			if(i < 4)
				hit_turfs = (range(i, src) - range(i-1, src)) // Ignores walls for first 3
				if(i == 1)
					hit_turfs += get_turf(src)
			else
				hit_turfs = (view(i, src) - range(i-1, src)) // Respects walls for last 2
			for(var/turf/T in hit_turfs)
				for(var/mob/living/L in T)
					if(L in been_hit)
						continue
					if(faction_check_mob(L) || L == src)
						continue
					been_hit += L
					L.apply_damage(smash_damage, smash_damage_type, null, L.run_armor_check(null, smash_damage_type), spread_damage = TRUE)
				new /obj/effect/temp_visual/kinetic_blast(T)
				if(prob(3))
					if(friendly)
						new /obj/effect/gibspawner/generic/silent/wrath_acid(T)
					else
						new /obj/effect/gibspawner/generic/silent/wrath_acid/bad(T)
			SLEEP_CHECK_DEATH(1)
	icon_state = icon_living
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/servant_wrath/proc/Teleport(turf/location)
	can_act = FALSE
	animate(src, alpha = 0, time = 5)
	new /obj/effect/temp_visual/guardian/phase(get_turf(src))
	SLEEP_CHECK_DEATH(1 SECONDS)
	forceMove(get_turf(location))
	animate(src, alpha = 255, time = 5)
	new /obj/effect/temp_visual/guardian/phase/out(location)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/servant_wrath/proc/OnMobDeath(datum/source, mob/living/died, gibbed)
	if(died != hunted_target)
		return
	ReturnHome()

/mob/living/simple_animal/hostile/abnormality/servant_wrath/proc/ReturnHome()
	can_act = FALSE
	hunted_target = null
	say("For our friendship...")
	SLEEP_CHECK_DEATH(1 SECONDS)
	Teleport(src.datum_reference.landmark)
	can_act = FALSE
	SLEEP_CHECK_DEATH(1 SECONDS)
	breach_affected = list()
	adjustBruteLoss(-maxHealth)
	toggle_ai(AI_OFF)
	status_flags |= GODMODE
	dir = EAST
	can_act = TRUE
	friendly = FALSE
	AdjustInstability()

/mob/living/simple_animal/hostile/abnormality/servant_wrath/proc/PerformEnding(mob/living/simple_animal/hostile/azure_hermit/target = null)
	ending = TRUE
	can_act = FALSE
	target.gib(TRUE)
	adjustBruteLoss(-maxHealth)
	toggle_ai(AI_OFF)
	status_flags |= GODMODE
	density = FALSE
	say("Justice and balance finaly restored. We...")
	SLEEP_CHECK_DEATH(2 SECONDS)
	animate(src, alpha = 0, time = 5)
	new /obj/effect/temp_visual/guardian/phase(get_turf(src))
	SLEEP_CHECK_DEATH(5)
	animate(src, alpha = 255, time = 5)
	new /obj/effect/temp_visual/guardian/phase/out(get_turf(src))
	icon_state = "wrath_end"
	speak_emote = list()
	say("We were true friends... Right?")
	SLEEP_CHECK_DEATH(4.5 SECONDS)
	Teleport(src.datum_reference.landmark)
	can_act = FALSE
	animate(src, alpha = 0, time = 5)
	new /obj/effect/temp_visual/guardian/phase(get_turf(src))
	SLEEP_CHECK_DEATH(5)
	icon = initial(icon)
	icon_state = initial(icon_state)
	desc = initial(desc)
	pixel_x = initial(pixel_x)
	base_pixel_x = initial(base_pixel_x)
	ADD_TRAIT(src, TRAIT_MOVE_FLYING, ROUNDSTART_TRAIT)
	animate(src, alpha = 255, time = 5)
	new /obj/effect/temp_visual/guardian/phase/out(get_turf(src))
	friend_ship = list()
	breach_affected = list()
	src.datum_reference.qliphoth_change(5)
	density = TRUE
	can_act = TRUE
	dir = EAST
	ending = FALSE

/mob/living/simple_animal/hostile/abnormality/servant_wrath/proc/Downed()
	can_act = FALSE
	status_flags |= GODMODE
	if(friendly)
		say("I've... failed. S-Sorry...")
		SLEEP_CHECK_DEATH(1 SECONDS)
		Teleport(src.datum_reference.landmark)
		breach_affected = list()
		toggle_ai(AI_OFF)
		adjustBruteLoss(-maxHealth)
		can_act = TRUE
		return FALSE
	say("GR-RRAHHH!!!")
	visible_message("<span class='warning'>[src] falls down!</span>")
	icon_state = "wrath_stun"
	SLEEP_CHECK_DEATH(15 SECONDS)
	status_flags &= ~GODMODE
	icon_state = icon_living
	adjustBruteLoss(-maxHealth)
	visible_message("<span class='warning'>[src] gets back up!</span>")
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/servant_wrath/death(gibbed)
	if(isnull(src.datum_reference))
		var/mob/living/simple_animal/hostile/azure_hermit/AH = locate() in GLOB.mob_living_list
		if(AH)
			AH.gib(TRUE)
		..()
		return
	if(ending)
		return FALSE
	INVOKE_ASYNC(src, .proc/Downed)
	return FALSE

/mob/living/simple_animal/hostile/abnormality/servant_wrath/gib()
	if(ending)
		return FALSE
	death()
	return FALSE

/mob/living/simple_animal/hostile/azure_hermit
	name = "Hermit of the Azure Forest"
	desc = "Please make way, I am here to meet a dear friend."
	icon = 'ModularTegustation/Teguicons/32x48.dmi'
	icon_state = "hermit"
	icon_living = "hermit"
	icon_dead = "hermit_dead"

	speak_emote = list("crones")
	faction = list("hostile", "azure")
	can_patrol = TRUE

	maxHealth = 1500
	health = 1500
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.2)

	a_intent = INTENT_HARM
	move_resist = MOVE_FORCE_STRONG
	move_to_delay = 5

	ranged = TRUE
	ranged_cooldown = 15 SECONDS

	melee_damage_lower = 20
	melee_damage_upper = 30
	rapid_melee = 2
	melee_damage_type = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_sound = 'sound/abnormalities/wrath_servant/hermit_attack.ogg'

	COOLDOWN_DECLARE(conjure)
	var/conjure_cooldown = 90 SECONDS
	var/max_conjured = 12
	var/list/staves = list()

	var/can_act = TRUE

/mob/living/simple_animal/hostile/azure_hermit/Initialize()
	. = ..()
	COOLDOWN_START(src, conjure, conjure_cooldown)

/mob/living/simple_animal/hostile/azure_hermit/Found(atom/A)
	if(!istype(A, /mob/living/simple_animal/hostile/abnormality/servant_wrath))
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/servant_wrath/SW = A
	if(SW.stunned) // OUR WORK HERE IS DONE.
		return FALSE
	return TRUE

/mob/living/simple_animal/hostile/azure_hermit/Life()
	. = ..()
	if(!can_act || (status_flags & GODMODE))
		return
	if(COOLDOWN_FINISHED(src, conjure))
		Conjure()

/mob/living/simple_animal/hostile/azure_hermit/OpenFire(atom/A)
	if(!can_act)
		return
	if(get_dist(src, target) > 4)
		return
	Befuddle()
	ranged_cooldown = world.time + ranged_cooldown_time

/mob/living/simple_animal/hostile/azure_hermit/AttackingTarget(atom/attacked_target)
	if(!can_act || (status_flags & GODMODE))
		return
	if(istype(target, /mob/living/simple_animal/hostile/abnormality/servant_wrath))
		var/mob/living/simple_animal/hostile/abnormality/servant_wrath/SW = target
		if(SW.stunned)
			return
		if(SW.health > 400)
			playsound(SW, 'sound/abnormalities/wrath_servant/hermit_attack_hard.ogg', 75, FALSE, 15, falloff_distance = 5)
			SW.apply_damage(100, WHITE_DAMAGE, null, SW.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE) // We win these
			var/list/show_area = list()
			show_area |= view(3, src)
			for(var/turf/sT in show_area)
				new /obj/effect/temp_visual/cult/sparks(sT)
			SLEEP_CHECK_DEATH(1 SECONDS)
			if(!can_act || (status_flags & GODMODE))
				return
			playsound(src, 'sound/abnormalities/wrath_servant/hermit_magic.ogg', 60, FALSE, 10)
			var/list/been_hit = list()
			for(var/i = 1 to 3)
				for(var/turf/T in (view(i, SW)-view(i-1,SW)))
					for(var/mob/living/L in T)
						if(L in been_hit)
							continue
						if(faction_check_mob(L))
							continue
						been_hit += L
						L.apply_damage(10, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
					new /obj/effect/temp_visual/small_smoke/halfsecond(T)
				SLEEP_CHECK_DEATH(3)
		else
			playsound(SW, 'sound/abnormalities/wrath_servant/enrage.ogg', 100, FALSE, 40, falloff_distance = 20)
			visible_message("<span class='userdanger'>[src] plunges their staff into [SW]'s chest!</span>")
			SW.stunned = TRUE
			addtimer(CALLBACK(SW, /mob/living/simple_animal/hostile/abnormality/servant_wrath/proc/Unstun), 3 MINUTES)
			SW.status_flags |= GODMODE
			SW.icon_state = "wrath_staff_stun"
			SW.desc = "A large red monster with white bandages hanging from it. It's flesh oozes a bubble acid. A wooden staff is impaled in it's chest, it can't seem to move!"
		return
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(get_user_level(H) < 3)
			say("Pardon me.")
			var/turf/TT = get_turf(H)
			H.gib(TRUE, TRUE, TRUE)
			var/mob/living/simple_animal/hostile/azure_stave/AS = new(TT)
			staves += AS
			AS = new(TT)
			staves += AS
			return
	return ..()

/mob/living/simple_animal/hostile/azure_hermit/Move(atom/newloc, dir, step_x, step_y)
	if(!can_act)
		return
	if(status_flags & GODMODE)
		return
	..()
	return

/mob/living/simple_animal/hostile/azure_hermit/proc/Conjure()
	for(var/mob/living/simple_animal/hostile/staff in staves)
		if(QDELETED(staff) || isnull(staff))
			staves -= staff
	if(staves.len >= max_conjured)
		return
	var/list/valid_turfs = list()
	valid_turfs += view(2, src)
	for(var/turf/T in view(2, src))
		if(T.density)
			valid_turfs -= T
	playsound(src, 'sound/abnormalities/wrath_servant/hermit_magic.ogg', 60, FALSE, 10)
	for(var/i = 0 to min(rand(1, 3), valid_turfs.len))
		var/mob/living/simple_animal/hostile/azure_stave/AS = new(pick(valid_turfs))
		staves += AS
	COOLDOWN_START(src, conjure, conjure_cooldown)
	return

/mob/living/simple_animal/hostile/azure_hermit/proc/Befuddle()
	if(!can_act || (status_flags & GODMODE))
		return
	can_act = FALSE
	var/list/show_area = list()
	show_area |= view(4, src)
	for(var/turf/sT in show_area)
		new /obj/effect/temp_visual/cult/sparks(sT)
	SLEEP_CHECK_DEATH(1.5 SECONDS)
	playsound(src, 'sound/abnormalities/wrath_servant/hermit_magic.ogg', 75, FALSE, 10)
	for(var/mob/living/L in view(4, src))
		if(faction_check_mob(L))
			continue
		new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(L))
		L.apply_damage(40, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
	can_act = TRUE
	return

/mob/living/simple_animal/hostile/azure_hermit/proc/Downed()
	say("Fufu~ If you're so insistent, I'll have a bit of a rest.")
	manual_emote("sits down.")
	icon_state = "hermit_stun"
	density = FALSE
	status_flags |= GODMODE
	SLEEP_CHECK_DEATH(20 SECONDS)
	status_flags &= ~GODMODE
	icon_state = icon_living
	adjustBruteLoss(-maxHealth)
	density = TRUE

/mob/living/simple_animal/hostile/azure_hermit/death()
	INVOKE_ASYNC(src, .proc/Downed)

/mob/living/simple_animal/hostile/azure_hermit/gib(real = FALSE)
	if(!real)
		death()
		return
	can_act = FALSE
	manual_emote("crumbles apart.")
	icon_state = icon_dead
	density = FALSE
	status_flags |= GODMODE
	for(var/mob/living/L in staves)
		L.visible_message("<span class='notice'>[L] crumbles before you!</span>")
		qdel(L)
	animate(src, alpha = 0, time = (15 SECONDS))
	QDEL_IN(src, 15 SECONDS)
	return

/mob/living/simple_animal/hostile/azure_stave
	name = "Hermit's Staff"
	desc = "This wood's blueish hue almost resembles a person..."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "stave"
	icon_living = "stave"
	maxHealth = 250
	health = 250
	deathmessage = "crumples to dust."

	a_intent = INTENT_HARM
	move_resist = MOVE_FORCE_STRONG
	can_patrol = TRUE // The dudes roam! That sucks!

	faction = list("hostile", "azure")
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.5, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)

	move_to_delay = 4

	melee_damage_lower = 10
	melee_damage_upper = 20
	melee_damage_type = RED_DAMAGE
	armortype = RED_DAMAGE
	rapid_melee = 2
	stat_attack = HARD_CRIT

	del_on_death = TRUE

/obj/effect/decal/cleanable/wrath_acid/
	name = "Not-so Acidic Goo"
	desc = "Ah, that kinda stings..."
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "wrath_acid"
	random_icon_states = list("wrath_acid")
	mergeable_decal = TRUE
	var/duration = 2 MINUTES
	var/delling = FALSE

/obj/effect/decal/cleanable/wrath_acid/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	START_PROCESSING(SSobj, src)
	duration += world.time

/obj/effect/decal/cleanable/wrath_acid/process(delta_time)
	if(world.time > duration)
		Remove()

/obj/effect/decal/cleanable/wrath_acid/proc/Remove()
	STOP_PROCESSING(SSobj, src)
	animate(src, time = (5 SECONDS), alpha = 0)
	QDEL_IN(src, 5 SECONDS)

/obj/effect/decal/cleanable/wrath_acid/proc/streak(list/directions, mapload=FALSE)
	set waitfor = FALSE
	var/direction = pick(directions)
	for(var/i in 0 to pick(0, 200; 1, 150; 2, 50; 3, 17; 50)) //the 3% chance of 50 steps is intentional and played for laughs.
		if (!mapload)
			sleep(2)
		if(!step_to(src, get_step(src, direction), 0))
			break

/obj/effect/decal/cleanable/wrath_acid/Crossed(atom/movable/AM)
	. = ..()
	if(ishuman(AM))
		return FALSE
	if(!isliving(AM))
		return FALSE
	if(istype(AM, /mob/living/simple_animal/hostile/abnormality/servant_wrath))
		return
	var/mob/living/L = AM
	L.apply_status_effect(STATUS_EFFECT_ACIDIC_GOO)

/obj/effect/decal/cleanable/wrath_acid/bad/
	name = "Acidic Goo"
	desc = "It seems to burn whatever it touches, best to stay away!"

/obj/effect/decal/cleanable/wrath_acid/bad/Crossed(atom/movable/AM)
	. = ..()
	if(!isliving(AM))
		return
	var/mob/living/L = AM
	L.apply_status_effect(STATUS_EFFECT_ACIDIC_GOO)

/obj/effect/gibspawner/generic/silent/wrath_acid
	gibtypes = list(/obj/effect/decal/cleanable/wrath_acid)
	gibamounts = list(3)

/obj/effect/gibspawner/generic/silent/wrath_acid/bad
	gibtypes = list(/obj/effect/decal/cleanable/wrath_acid/bad)

/obj/effect/gibspawner/generic/silent/wrath_acid/Initialize()
	if(!gibdirections.len)
		gibdirections = list(list(WEST, NORTHWEST, SOUTHWEST, NORTH))
	. = ..()
	return

/datum/status_effect/wrath_burning
	id = "wrath_burning"
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/wrath_burning
	duration = 4 SECONDS // Hits 8 times
	tick_interval = 0.5 SECONDS

/atom/movable/screen/alert/status_effect/wrath_burning
	name = "Acidic Goo"
	desc = "The goo has stuck to you and burns your flesh and mind!"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "acid_goo"

/datum/status_effect/wrath_burning/tick()
	. = ..()
	if(!isliving(owner))
		return
	var/mob/living/L = owner
	L.apply_damage(5, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
	if(!ishuman(L))
		return
	if((L.sanityhealth <= 0) || (L.health <= 0))
		var/turf/T = get_turf(L)
		L.gib(TRUE, TRUE, TRUE)
		new /mob/living/simple_animal/hostile/azure_stave(T)

#undef STATUS_EFFECT_ACIDIC_GOO
