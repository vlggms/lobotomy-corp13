// Holidays - Christmas
// Shameless copy of mimics. Later ordeals can have gnomes
/mob/living/simple_animal/hostile/ordeal/present
	name = "christmas gift"
	desc = "It could be anything!"
	icon = 'icons/obj/storage.dmi'
	icon_state = "giftdeliverypackage3"
	icon_living = "giftdeliverypackage3"
	maxHealth = 80
	health = 80
	gender = NEUTER
	mob_biotypes = NONE
	move_to_delay = 4
	melee_damage_lower = 4
	melee_damage_upper = 6
	attack_sound = 'sound/effects/ordeals/crimson/noon_bite.ogg'
	emote_taunt = list("growls")
	taunt_chance = 15
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 1.3, BLACK_DAMAGE = 2, PALE_DAMAGE = 1)
	faction = list("christmas")
	del_on_death = 1
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	speak_emote = list("rustles")
	stop_automated_movement = 1
	wander = 0
	///A cap for items in the mimic. Prevents the mimic from eating enough stuff to cause lag when opened.
	var/storage_capacity = 50
	///A cap for mobs. Mobs count towards the item cap. Same purpose as above.
	var/mob_storage_capacity = 10
	var/attempt_open = FALSE
	var/icon/mouth_overlay = icon('ModularTegustation/Teguicons/tegumobs.dmi', icon_state = "mimic_mouth")

// Pickup loot
/mob/living/simple_animal/hostile/ordeal/present/Initialize(mapload)
	. = ..()
	if(mapload)	//eat shit
		for(var/obj/item/I in loc)
			I.forceMove(src)
	addtimer(CALLBACK(src, PROC_REF(ReleaseDeathGas)), rand(60 SECONDS, 65 SECONDS))

/mob/living/simple_animal/hostile/ordeal/present/ListTargets()
	if(attempt_open)
		return ..()
	return ..(1)

/mob/living/simple_animal/hostile/ordeal/present/FindTarget()
	. = ..()
	if(.)
		trigger()

/mob/living/simple_animal/hostile/ordeal/present/AttackingTarget()
	. = ..()

/mob/living/simple_animal/hostile/ordeal/present/proc/trigger()
	overlays += mouth_overlay
	if(!attempt_open)
		visible_message("<b>[src]</b> starts to move!")
		attempt_open = TRUE

/mob/living/simple_animal/hostile/ordeal/present/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	trigger()
	. = ..()

/mob/living/simple_animal/hostile/ordeal/present/LoseTarget()
	..()
	icon_state = initial(icon_state)
	overlays -= mouth_overlay

/mob/living/simple_animal/hostile/ordeal/present/death()
	var/obj/item/a_gift/anything/C = new(get_turf(src))
	// Put loot in present
	for(var/obj/O in src)
		O.forceMove(C)
	..()

//Copied from violet fruit, just prevents ignoring them as a solution
/mob/living/simple_animal/hostile/ordeal/present/proc/ReleaseDeathGas()
	if(stat == DEAD)
		return
	var/turf/target_c = get_turf(src)
	var/list/turf_list = spiral_range_turfs(15, target_c)
	visible_message("<span class='danger'>[src] releases a cloud of nauseating gas!</span>")
	playsound(target_c, 'sound/effects/ordeals/violet/fruit_suicide.ogg', 50, 1, 16)
	adjustWhiteLoss(maxHealth) // Die
	for(var/turf/open/T in turf_list)
		if(prob(25))
			new /obj/effect/temp_visual/revenant(T)
	for(var/mob/living/L in range(15, target_c))
		if(faction_check_mob(L))
			continue
		L.apply_damage(10, WHITE_DAMAGE, null, L.run_armor_check(null, WHITE_DAMAGE))
	for(var/obj/machinery/computer/abnormality/A in urange(15, target_c))
		if(A.can_meltdown && !A.meltdown && A.datum_reference && A.datum_reference.current && A.datum_reference.qliphoth_meter)
			A.datum_reference.qliphoth_change(pick(-999))
