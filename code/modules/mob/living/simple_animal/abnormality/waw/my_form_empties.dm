#define STATUS_EFFECT_KARMA /datum/status_effect/stacking/karma
/mob/living/simple_animal/hostile/abnormality/my_form_empties
	name = "My Form Empties"
	desc = "A statue created as an idol for worship. It appears to float in the air at all times, showing no particular movement outside of gesturing with one hand."
	icon = 'ModularTegustation/Teguicons/64x96.dmi'
	icon_state = "myform_empties"
	icon_living = "myform_empties"
	icon_dead = "myform_egg"
	core_icon = "myform_egg"
	portrait = "my_form_empties"

	pixel_x = -16
	base_pixel_x = -16

	maxHealth = 2000
	health = 2000
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 1.4, PALE_DAMAGE = 1)

	threat_level = WAW_LEVEL
	can_breach = TRUE
	max_boxes = 22
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 15,
		ABNORMALITY_WORK_INSIGHT = list(25, 25, 55, 55, 55),
		ABNORMALITY_WORK_ATTACHMENT = 25,
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 45, 50, 55),
	)
	work_damage_amount = 10
	work_damage_type = WHITE_DAMAGE

	del_on_death = FALSE
	ranged = TRUE
	ranged_cooldown_time = 3 SECONDS
	environment_smash = FALSE
	ego_list = list(
		/datum/ego_datum/weapon/sunyata,
		/datum/ego_datum/armor/sunyata,
	)
	gift_type =  /datum/ego_gifts/sunyata
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	observation_prompt = "A bell occasionally tolls in the room. <br>\
		It's a heavy, subduing sound. You're unable to recognize its words. <br>\
		But, you feel that whatever it is, is not a joyous thing."
	observation_choices = list(
		"Listen closer" = list(TRUE, "You close your eyes and focus on the sound. What is is saying? <br>\
			This thing is uttering thoughts. Empty oneself by verbalizing one's thoughts. <br>\
			Expel everything within so that nothing remains."),
		"Repeat the mantras" = list(FALSE, "The statue won't move, no matter what happens around it. <br>\
			Though the tone of its mantra remains consistent, you knew its chants are imbued with a curse.")
	)

	var/anatman_state = FALSE
	var/praying = FALSE

	var/pulse_cooldown
	var/pulse_cooldown_time = 12 SECONDS
	var/pulse_damage = 5//this mainly applies karma

	var/staff_range = 1
	var/staff_damage = 60
	var/obj/effect/myform_staff/staff

	var/datum/looping_sound/my_form_empties/soundloop
	var/playstatus = FALSE
	var/playrange = 40

	var/list/possible_minion_list = list(//these should generally be humanoid enemies, maybe dependent on gamemode. In a LC facility, these will be abnormality minions that require a dead human to create. That means no shrimps
		/mob/living/simple_animal/hostile/grown_strong,//TODO: make these require corresponding abnormalities
		/mob/living/simple_animal/hostile/yagaslave,
		/mob/living/simple_animal/hostile/thunder_zombie,
		/mob/living/simple_animal/hostile/azure_stave,
		/mob/living/simple_animal/hostile/ordeal/steel_dusk,//non-abnormality minions
		/mob/living/simple_animal/hostile/ordeal/indigo_noon,
		/mob/living/simple_animal/hostile/humanoid/rat/knife,//lc13_humanoids.dm, replace these with an N corp grosshammer and jefe de los mariachis
	)
	var/list/current_minions = list()
	var/minion_amount = 3

/mob/living/simple_animal/hostile/abnormality/my_form_empties/Initialize()
	. = ..()
	soundloop = new(list(src), FALSE)
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(OnMobDeath))

/mob/living/simple_animal/hostile/abnormality/my_form_empties/Destroy()
	QDEL_NULL(soundloop)
	for(var/mob/living/L in current_minions)
		QDEL_IN(L, rand(3) SECONDS)
		current_minions -= L
	if(!staff)
		return ..()
	qdel(staff)
	return ..()

/mob/living/simple_animal/hostile/abnormality/my_form_empties/death(gibbed)
	RemoveKarma()
	icon = 'ModularTegustation/Teguicons/abno_cores/waw.dmi'
	QDEL_NULL(soundloop)
	animate(src, alpha = 0, time = 5 SECONDS)
	QDEL_IN(src, 5 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/my_form_empties/Move()
	return FALSE

/mob/living/simple_animal/hostile/abnormality/my_form_empties/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if((pulse_cooldown < world.time) && !(status_flags & GODMODE))
		KarmaDing()
		if(LAZYLEN(current_minions))//heal with every pulse. This is intentional
			for(var/mob/living/L in current_minions)
				L.adjustBruteLoss(-2000)

/mob/living/simple_animal/hostile/abnormality/my_form_empties/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	if(!LAZYLEN(current_minions))
		..()
		return
	var/damage_penalty = LAZYLEN(current_minions)
	if(damage_penalty >= 3)
		amount = 0
	else
		amount -= amount * (0.3 * damage_penalty)
	..()

/mob/living/simple_animal/hostile/abnormality/my_form_empties/AttackingTarget(atom/attacked_target)
	return OpenFire()//staff attacks go here

/mob/living/simple_animal/hostile/abnormality/my_form_empties/OpenFire()
	..()
	StaffAttack(target)

/mob/living/simple_animal/hostile/abnormality/my_form_empties/proc/StaffAttack(target)
	if(!staff)
		return
	var/list/been_hit = list()
	for(var/turf/T in view(staff_range, get_turf(target)))
		new /obj/effect/temp_visual/cult/sparks(T)
	staff.Move(get_turf(target))
	var/staff_angle = 0
	switch(staff.dir)
		if(EAST)
			staff_angle = 345
		if(WEST)
			staff_angle = 15
	animate(staff, transform = turn(matrix(), staff_angle) ,time = 2)
	playsound(get_turf(staff), 'sound/abnormalities/myformempties/MFEattack.ogg', 30, 0, 4)
	SLEEP_CHECK_DEATH(10)
	for(var/turf/T in view(staff_range, get_turf(staff)))
		new /obj/effect/temp_visual/smash_effect(T)
		been_hit = HurtInTurf(T, been_hit, staff_damage, WHITE_DAMAGE, check_faction = FALSE, hurt_mechs = TRUE, mech_damage = staff_damage)
		for(var/mob/living/L in T)
			ApplyKarma(L, 15)
	animate(staff, transform = turn(matrix(), 15) ,time = 2)
	if(!staff.Move(get_ranged_target_turf(src, EAST, 1)))
		staff.forceMove(get_ranged_target_turf(src, EAST, 1))

/mob/living/simple_animal/hostile/abnormality/my_form_empties/proc/KarmaDing()
	pulse_cooldown = world.time + pulse_cooldown_time
	for(var/mob/living/L in livinginrange(48, src))
		if(L.z != z)
			continue
		if(faction_check_mob(L))
			continue
		L.deal_damage(pulse_damage, WHITE_DAMAGE)//apply karma here
		ApplyKarma(L, 5)
		extended_flash_color(L, flash_color = "#FDAE8B", flash_time = 1,maintain_time = 115)
		if(!ishuman(L))
			continue
//		var/mob/living/carbon/human/H = L//TODO: turn panicked humans into additional thralls. This is optional
//		if(H.sanity_lost)
//			H.death()//karma panic goes here

/mob/living/simple_animal/hostile/abnormality/my_form_empties/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	var/turf/T = pick(GLOB.department_centers)
	icon_state = icon_living
	soundloop.start()
	if(breach_type != BREACH_MINING)
		forceMove(T)
	for(var/i = 1, i <= minion_amount ,i++)
		var/karma_vis = new /obj/effect/karma_halo
		var/picked = pick(pick(possible_minion_list))
		var/mob/living/minion = new picked(get_turf(src))
		minion.name = "Lured " + "[minion.name]"
		minion.maxHealth = 2000
		minion.faction = faction
		minion.vis_contents += karma_vis
		current_minions += minion
	if(!staff)
		T = get_ranged_target_turf(T, EAST, 1)
		staff = new(T)

/mob/living/simple_animal/hostile/abnormality/my_form_empties/proc/OnMobDeath(datum/source, mob/living/died, gibbed)
	if(!(died in current_minions))
		return
	died.gib()
	current_minions -= died

/mob/living/simple_animal/hostile/abnormality/my_form_empties/AttemptWork(mob/living/carbon/human/user, work_type)
	if(praying)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/my_form_empties/WorkChance(mob/living/carbon/human/user, chance, work_type)
	var/newchance = chance // Set default return to chance
	if(anatman_state)
		newchance += 15
	return newchance

/mob/living/simple_animal/hostile/abnormality/my_form_empties/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(anatman_state)
		datum_reference.qliphoth_change(-1)
	else
		Pray(user)
	return

/mob/living/simple_animal/hostile/abnormality/my_form_empties/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(anatman_state)
		datum_reference.qliphoth_change(1)
	else  if(prob(25))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/my_form_empties/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/my_form_empties/OnQliphothChange(mob/living/carbon/human/user)
	. = ..()
	if(datum_reference.qliphoth_meter == 1)
		icon_state = "myform_empties_anatman"
		anatman_state = TRUE
	else
		icon_state = "myform_empties"
		anatman_state = FALSE

/mob/living/simple_animal/hostile/abnormality/my_form_empties/proc/Pray(mob/living/carbon/human/user)
	set waitfor = FALSE
	praying = TRUE
	while (PlayerCheck(user))
		for(var/mob/living/carbon/human/H in view(3, src))
			//Heal 5% for every 3 seconds you're here
			H.adjustSanityLoss(-(H.maxSanity*0.05))
		to_chat(user, span_notice("[src] chants something, but you can't recognize its words."))
		SLEEP_CHECK_DEATH(30)
	praying = FALSE

/mob/living/simple_animal/hostile/abnormality/my_form_empties/proc/PlayerCheck(mob/living/carbon/human/user)
	if(user in view(5, src))
		return TRUE
	else
		return FALSE

/mob/living/simple_animal/hostile/abnormality/my_form_empties/proc/ApplyKarma(mob/living/target, stacks)
	if(target == src)
		return
	if((target.stat == DEAD) || (target.status_flags & GODMODE))
		return
	var/datum/status_effect/stacking/karma/K = target.has_status_effect(/datum/status_effect/stacking/karma)
	if(!K)//applying the buff for the first time (it lasts for one minute)
		new /obj/effect/temp_visual/karma_hit(get_turf(target))
		var/datum/status_effect/stacking/karma/KK = target.apply_status_effect(STATUS_EFFECT_KARMA)
		if(KK)
			KK.add_stacks(stacks)
		return
	else//if the employee already has the buff
		K.add_stacks(stacks)
		K.refresh()
	to_chat(target, span_warning("You have gained [stacks] karma!"))
	new /obj/effect/temp_visual/karma_hit(get_turf(target))
	return

/mob/living/simple_animal/hostile/abnormality/my_form_empties/proc/RemoveKarma()
	for(var/mob/living/carbon/human/L in GLOB.player_list) // cleanse debuffs
		if(faction_check_mob(L, FALSE) || L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		var/datum/status_effect/actor/S = L.has_status_effect(/datum/status_effect/stacking/karma)
		if(S)
			qdel(S)

//***Buff Definitions***
//For now, just a notification. If we ever want to do anything with it, it's here.
/datum/status_effect/stacking/karma
	id = "karma"
	status_type = STATUS_EFFECT_MULTIPLE
	duration = 500
	stack_decay = 0
	stack_threshold = 108
	max_stacks = 255
	consumed_on_threshold = TRUE
	stacks = 5
	on_remove_on_mob_delete = FALSE
	alert_type = /atom/movable/screen/alert/status_effect/karma
	var/datum/dc_change/karma/karma_mod
	var/physiology_mod
	var/karma_transfer_rate = 5
	var/hp_limit = 2000

/atom/movable/screen/alert/status_effect/karma
	name = "Karma"
	desc = "You are being judged by a divine being. Damage taken will be increased by "
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "karma"

/datum/status_effect/stacking/karma/threshold_cross_effect()
	var/mob/living/user = owner
	if(isliving(user) && user.maxHealth <= 2000)//Nice try! You can't kill DF with this
		user.gib()

/datum/status_effect/stacking/karma/on_apply()
	. = ..()
	if(!owner)
		return
	var/mob/living/carbon/human/H = owner
	physiology_mod = (stacks / 50)//up to 2.16 to physiology
	if(ishuman(H))
		H.physiology.red_mod += physiology_mod
		H.physiology.white_mod += physiology_mod
		H.physiology.black_mod += physiology_mod
		H.physiology.pale_mod += physiology_mod
		RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(TransferKarma))
		return
	if(!isanimal(owner))
		return
	var/mob/living/simple_animal/A = owner
	A.AddModifier(/datum/dc_change/karma)

/datum/status_effect/stacking/karma/add_stacks(stacks_added)//update your weaknesses
	. = ..()
	if(!owner)
		return
	linked_alert.desc = initial(linked_alert.desc)+"[stacks*2]%!"
	var/mob/living/carbon/human/H = owner
	if(ishuman(H))
		if(physiology_mod)//removes the existing karma modifier, before the damage modifier is updated
			H.physiology.red_mod -= physiology_mod
			H.physiology.white_mod -= physiology_mod
			H.physiology.black_mod -= physiology_mod
			H.physiology.pale_mod -= physiology_mod
		physiology_mod = (stacks / 50)//up to 3.16x in total
		H.physiology.red_mod += physiology_mod
		H.physiology.white_mod += physiology_mod
		H.physiology.black_mod += physiology_mod
		H.physiology.pale_mod += physiology_mod
		return
	if(!isanimal(owner))
		return
	var/mob/living/simple_animal/A = owner
	var/datum/dc_change/karma/mod = A.HasDamageMod(/datum/dc_change/karma)
	mod.potency = 1+(stacks / 50)//this is roughly +0.1 damage coeff for every 5 stacks, on average
	A.UpdateResistances()

/datum/status_effect/stacking/karma/on_remove()
	. = ..()
	if(!owner)
		return
	UnregisterSignal(owner, COMSIG_ITEM_ATTACK)
	var/mob/living/carbon/human/H = owner
	if(ishuman(H))
		H.physiology.red_mod -= physiology_mod//a runtime occurs here if you were gibbed by karma's effect
		H.physiology.white_mod -= physiology_mod
		H.physiology.black_mod -= physiology_mod
		H.physiology.pale_mod -= physiology_mod
		return
	var/mob/living/simple_animal/A = owner
	if(A.HasDamageMod(karma_mod))
		A.RemoveModifier(/datum/dc_change/karma)

/datum/status_effect/stacking/karma/proc/TransferKarma(datum/source, mob/living/target, mob/living/user)
	if(target == owner || !isliving(target))
		return
	if((target.stat == DEAD) || (target.status_flags & GODMODE))
		return
	if(istype(target, /mob/living/simple_animal/hostile/abnormality/my_form_empties))
		return
	var/datum/status_effect/stacking/karma/K = target.has_status_effect(/datum/status_effect/stacking/karma)
	to_chat(owner, span_warning("You have transferred [karma_transfer_rate] karma to [target]!"))
	if(!K)//applying the buff for the first time (it lasts for one minute)
		target.apply_status_effect(STATUS_EFFECT_KARMA)
		return
	else//if the employee already has the buff
		K.add_stacks(karma_transfer_rate)
		K.refresh()
	add_stacks(-(karma_transfer_rate))//subtract karma from yourself
	return

/obj/effect/myform_staff//the staff
	name = "khakkhara"
	desc = "A staff holding spiritual significance. It floats in a similar manner to the abnormality, and appears to be sentient."
	icon = 'ModularTegustation/Teguicons/32x96.dmi'
	icon_state = "myform_staff"

/obj/effect/myform_staff/Initialize()
	. = ..()
	animate(src, transform = turn(matrix(), 15) ,time = 2)

/obj/effect/karma_halo
	name = "karma"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "karma_nobg"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pixel_y = 16
	base_pixel_y = 16

/obj/effect/temp_visual/karma_hit
	name = "karma halo"
	icon = 'icons/effects/cult_effects.dmi'
	icon_state = "rune1words"
	color = "#3F3936"
	duration = 10

/obj/effect/temp_visual/karma_hit/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(fade_out)), 5)

/obj/effect/temp_visual/karma_hit/proc/fade_out()
	animate(src, alpha = 0, time = 5)

#undef STATUS_EFFECT_KARMA
