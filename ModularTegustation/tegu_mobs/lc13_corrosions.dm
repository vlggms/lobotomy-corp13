
//Limbus company canto 3 corrosions

/mob/living/simple_animal/hostile/ordeal/NT_corrosion
	name = "everything there of an inquisitor"
	desc = "A humanoid in a suit of armor that is covered in flesh and eyeballs."
	icon = 'ModularTegustation/Teguicons/48x32.dmi'
	icon_state = "everything_there"
	icon_living = "everything_there"
	icon_dead = "dead_generic"
	faction = list("gold_ordeal")
	maxHealth = 3000
	health = 3000
	pixel_x = -8
	base_pixel_x = -8
	melee_damage_lower = 24
	melee_damage_upper = 30
	rapid_melee = 2
	attack_verb_continuous = "slices"
	attack_verb_simple = "slice"
	attack_sound = 'sound/abnormalities/nothingthere/attack.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	damage_coeff = list(RED_DAMAGE = 0, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.3)
	butcher_results = list(/obj/item/food/meat/slab/human = 3)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human = 1)
	move_to_delay = 5
	ranged = TRUE
	var/can_act = TRUE
	/// When this reaches 400 - begins reflecting damage
	var/damage_taken = 0
	var/damage_reflection = FALSE
	var/hello_cooldown
	var/hello_cooldown_time = 6 SECONDS
	var/hello_damage = 120

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/proc/ReflectDamage(mob/living/attacker, attack_type = RED_DAMAGE, damage)
	if(damage < 1)
		return
	if(!damage_reflection)
		return
	var/turf/jump_turf = get_step(attacker, pick(GLOB.alldirs))
	if(jump_turf.is_blocked_turf(exclude_mobs = TRUE))
		jump_turf = get_turf(attacker)
	forceMove(jump_turf)
	playsound(src, 'sound/weapons/ego/sword1.ogg', min(15 + damage, 100), TRUE, 4)
	attacker.visible_message(span_danger("[src] counters [attacker] with a massive blade!"), span_userdanger("[src] counters your attack!"))
	do_attack_animation(attacker)
	attacker.apply_damage(damage, attack_type, null, attacker.getarmor(null, attack_type))
	new /obj/effect/temp_visual/revenant(get_turf(attacker))

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/death(gibbed)
	if(damage_reflection)
		damage_reflection = FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/attack_hand(mob/living/carbon/human/M)
	..()
	if(!.)
		return
	if(damage_reflection && M.a_intent == INTENT_HARM)
		ReflectDamage(M, M?.dna?.species?.attack_type, M?.dna?.species?.punchdamagehigh)

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/attack_paw(mob/living/carbon/human/M)
	..()
	if(damage_reflection && M.a_intent != INTENT_HELP)
		ReflectDamage(M, M?.dna?.species?.attack_type, 5)

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(!damage_reflection)
		return
	if(.)
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		if(damage > 0)
			ReflectDamage(M, M.melee_damage_type, damage)

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/bullet_act(obj/projectile/Proj, def_zone, piercing_hit = FALSE)
	..()
	if(damage_reflection && Proj.firer)
		if(get_dist(Proj.firer, src) < 5)
			ReflectDamage(Proj.firer, Proj.damage_type, Proj.damage)

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!damage_reflection)
		return
	var/damage = I.force
	if(ishuman(user))
		damage *= 1 + (get_attribute_level(user, JUSTICE_ATTRIBUTE)/100)
	ReflectDamage(user, I.damtype, damage)

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0)
		damage_taken += .
	if(QDELETED(src) || stat == DEAD)
		damage_reflection = FALSE
		return
	if(!can_act)
		return
	if(damage_taken > 400 && !damage_reflection)
		StartReflecting()

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/proc/StartReflecting()
	can_act = FALSE
	damage_reflection = TRUE
	damage_taken = 0
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/breach.ogg', 25, 0, 5)
	visible_message(span_warning("[src] assumes a stance!"))
	icon_state = "everything_there_guard"
	ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))
	sleep(2 SECONDS)
	if(QDELETED(src) || stat == DEAD)
		return
	icon_state = icon_living
	ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.3))
	damage_reflection = FALSE
	can_act = TRUE

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/proc/Hello(target)
	if(hello_cooldown > world.time)
		return
	hello_cooldown = world.time + hello_cooldown_time
	can_act = FALSE
	face_atom(target)
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_cast.ogg', 75, 0, 3)
//	icon_state = "everything_there_ranged"
	new /obj/effect/temp_visual/distortedform_shift(get_turf(src))
	var/turf/target_turf = get_turf(target)
	for(var/i = 1 to 3)
		target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
	// Close range gives you more time to dodge
	var/hello_delay = (get_dist(src, target) <= 2) ? (1 SECONDS) : (0.5 SECONDS)
	SLEEP_CHECK_DEATH(hello_delay)
	var/list/been_hit = list()
	var/broken = FALSE
	for(var/turf/T in getline(get_turf(src), target_turf))
		if(T.density)
			if(broken)
				break
			broken = TRUE
		for(var/turf/TF in range(1, T)) // AAAAAAAAAAAAAAAAAAAAAAA
			if(TF.density)
				continue
			new /obj/effect/temp_visual/smash_effect(TF)
			been_hit = HurtInTurf(TF, been_hit, hello_damage, RED_DAMAGE, null, TRUE, FALSE, TRUE, TRUE)
	for(var/mob/living/L in been_hit)
		if(L.health < 0)
			L.gib()
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_bam.ogg', 100, 0, 7)
	playsound(get_turf(src), 'sound/abnormalities/nothingthere/hello_clash.ogg', 75, 0, 3)
	icon_state = icon_living
	can_act = TRUE

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	if((hello_cooldown <= world.time) && prob(35))
		var/turf/target_turf = get_turf(target)
		for(var/i = 1 to 3)
			target_turf = get_step(target_turf, get_dir(get_turf(src), target_turf))
		return Hello(target_turf)
	return ..()

/mob/living/simple_animal/hostile/ordeal/NT_corrosion/OpenFire()
	if(!can_act)
		return
	if(hello_cooldown <= world.time)
		Hello(target)
	return

/mob/living/simple_animal/hostile/ordeal/snake_corrosion
	name = "wriggling beast"
	desc = "A humanoid in a suit of armor that is covered in snakes."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "wriggling_beast"
	icon_living = "wriggling_beast"
	icon_dead = "dead_generic"
	faction = list("gold_ordeal")
	maxHealth = 2500
	health = 2500
	melee_damage_lower = 30
	melee_damage_upper = 35
	melee_damage_type = BLACK_DAMAGE
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	attack_sound = 'sound/effects/ordeals/brown/cromer_slam.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0, PALE_DAMAGE = 1.5)
	butcher_results = list(/obj/item/food/meat/slab/human = 1, /obj/item/food/meat/slab/human/mutant/lizard = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human = 1)
	move_to_delay = 4
	var/poison_releasing = FALSE
	var/poison_damage = 20
	var/applied_venom = 3
	var/poison_range = 3
	var/can_act = TRUE
	var/guntimer

	ranged = TRUE
	rapid = 1
	rapid_fire_delay = 1
	ranged_cooldown_time = 50
	projectiletype = /obj/projectile/poisonglob
	projectilesound = 'sound/effects/fish_splash.ogg' //TODO: change


/mob/living/simple_animal/hostile/ordeal/snake_corrosion/Life()
	. = ..()
	if(!.)
		return
	if(status_flags & GODMODE)
		return
	if(!poison_releasing)
		return
	SpawnPoison() //Periodically spews out damaging poison while breaching

/mob/living/simple_animal/hostile/ordeal/snake_corrosion/proc/SpawnPoison()
	var/turf/target_turf = get_turf(src)
	for(var/turf/T in view(poison_range, target_turf))
		if(prob(30))
			continue
		new /obj/effect/temp_visual/mustardgas(T)
		for(var/mob/living/H in T)
			if(faction_check_mob(H))
				continue
			H.apply_damage(poison_damage, BLACK_DAMAGE, null, H.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
			H.apply_venom(2)

/mob/living/simple_animal/hostile/ordeal/snake_corrosion/apply_damage(damage, damagetype, def_zone, blocked, forced, spread_damage, wound_bonus, bare_wound_bonus, sharpness, white_healable)
	. = ..()
	if(poison_releasing)
		return
	if(health <= (maxHealth * 0.5))
		poison_releasing = TRUE
		visible_message(span_warning("[src]'s body breaks, releasing toxic fumes!"), span_boldwarning("Your poison gland breaks!"))
		playsound(src, 'sound/effects/limbus_death.ogg', 40, 0, FALSE)
		rapid += 1

/mob/living/simple_animal/hostile/ordeal/snake_corrosion/Move()
	if(!can_act)
		return FALSE
	..()

/mob/living/simple_animal/hostile/ordeal/snake_corrosion/AttackingTarget(atom/attacked_target)
	if(!can_act)
		return FALSE
	. = ..()
	if(isliving(attacked_target))
		var/mob/living/H = attacked_target
		H.apply_venom(applied_venom)

/mob/living/simple_animal/hostile/ordeal/snake_corrosion/OpenFire()
	if(get_dist(src, target) > 4)
		return
	. = ..()
	can_act = FALSE
	guntimer = addtimer(CALLBACK(src, PROC_REF(StartMoving)), (5), TIMER_STOPPABLE)

/mob/living/simple_animal/hostile/ordeal/snake_corrosion/proc/StartMoving()
	can_act = TRUE
	deltimer(guntimer)

/mob/living/simple_animal/hostile/ordeal/snake_corrosion/death(gibbed)
	. = ..()
	if(guntimer)
		deltimer(guntimer)
	poison_releasing = FALSE

/mob/living/simple_animal/hostile/ordeal/snake_corrosion/bullet_act(obj/projectile/P)
	if(!P.firer)
		return ..()
	if((get_dist(P.firer, src) > 4))
		new /obj/effect/temp_visual/healing/no_dam(get_turf(src))
		visible_message(span_userdanger("[src] blocks \the [P]!"))
		P.Destroy()
	return ..()

#define STATUS_EFFECT_VENOM /datum/status_effect/stacking/venom
/datum/status_effect/stacking/venom
	id = "stacking_venom"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/venom
	max_stacks = 10
	tick_interval = 5 SECONDS
	consumed_on_threshold = FALSE

/atom/movable/screen/alert/status_effect/venom
	name = "Venom"
	desc = "Your veins feel like they are on fire!"
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "venom"

/datum/status_effect/stacking/venom/can_have_status()
	return (owner.stat != DEAD || !(owner.status_flags & GODMODE))

/datum/status_effect/stacking/venom/on_apply()
	. = ..()
	owner.playsound_local(owner, 'sound/effects/venom_apply.ogg', 50, TRUE)
	to_chat(owner, "<span class='warning'>You have been envenomed!</span>")

//Deals brute damage, maybe one day we can make it deal toxin instead
/datum/status_effect/stacking/venom/tick()
	if(!can_have_status())
		qdel(src)
	owner.playsound_local(owner, 'sound/effects/venom.ogg', 50, TRUE)
	if(ishuman(owner))
		owner.adjustBruteLoss(max(0, stacks))
	else
		owner.adjustBruteLoss(stacks*4) // x4 on non humans

	//Halves stacks after every tick
	stacks = round(stacks/2)
	if(stacks <= 1)
		qdel(src)

//Mob Proc
/mob/living/proc/apply_venom(stacks)
	var/datum/status_effect/stacking/venom/V = src.has_status_effect(/datum/status_effect/stacking/venom)
	if(!V)
		src.apply_status_effect(/datum/status_effect/stacking/venom, stacks)
	else
		V.add_stacks(stacks)

/mob/living/simple_animal/hostile/ordeal/snake_corrosion/strong
	name = "slithering inquisitor"
	desc = "A humanoid in a suit of armor that is covered in snakes... A lot of snakes!"
	icon_state = "slithering_beast"
	icon_living = "slithering_beast"
	icon_dead = "dead_generic"
	maxHealth = 4000
	health = 4000
	melee_damage_lower = 40
	melee_damage_upper = 50
	damage_coeff = list(RED_DAMAGE = 0.8, WHITE_DAMAGE = 0.8, BLACK_DAMAGE = 0, PALE_DAMAGE = 1.3)
	poison_range = 6
	poison_damage = 25
	rapid = 2
	applied_venom = 5

/mob/living/simple_animal/hostile/ordeal/dog_corrosion
	name = "crawling inquisitor"
	desc = "A four-legged creature in what looks like a set of armor for humans."
	icon = 'ModularTegustation/Teguicons/48x32.dmi'
	icon_state = "crawling_beast"
	icon_living = "crawling_beast"
	icon_dead = "dead_generic"
	var/icon_aggro = "crawling_beast"
	faction = list("gold_ordeal")
	maxHealth = 2000
	health = 2000
	pixel_x = -8
	base_pixel_x = -8
	melee_damage_lower = 16
	melee_damage_upper = 18
	rapid_melee = 3
	attack_verb_continuous = "slices"
	attack_verb_simple = "slice"
	attack_sound = 'sound/abnormalities/big_wolf/Wolf_Scratch.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 1.5)
	butcher_results = list(/obj/item/food/meat/slab/human = 1, /obj/item/food/meat/slab/pug = 1)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human = 1)
	move_to_delay = 3
	ranged = TRUE
	var/charging = FALSE
	var/charge_ready = FALSE
	var/dash_num = 25
	var/dash_cooldown = 0
	var/dash_cooldown_time = 4 SECONDS
	var/dash_count = 2
	var/current_dash = 1
	var/list/been_hit = list() // Don't get hit twice.
	var/heal_amount = 250
	var/damage_taken
	var/damage_threshold = 450
	var/dash_damage = 80
	var/charge_sound = 'sound/effects/ordeals/gold/growl1.ogg'
	var/gibbing = TRUE

/mob/living/simple_animal/hostile/ordeal/dog_corrosion/Move()
	if(charging)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/ordeal/dog_corrosion/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0)
		damage_taken += .
	if(damage_taken >= damage_threshold && !charge_ready)
		charge_ready = TRUE
		new /obj/effect/temp_visual/cult/sparks(get_turf(src))
		damage_taken = 0

/mob/living/simple_animal/hostile/ordeal/dog_corrosion/Life()
	. = ..()
	if(.) //Builds up the ability to charge over time even if ignored
		damage_taken += 20

/mob/living/simple_animal/hostile/ordeal/dog_corrosion/bullet_act(obj/projectile/P)
	if(charging || charge_ready)
		new /obj/effect/temp_visual/healing/no_dam(get_turf(src))
		visible_message(span_userdanger("[src] swiftly avoids \the [P]!"))
		P.Destroy()
		return
	..()

/mob/living/simple_animal/hostile/ordeal/dog_corrosion/AttackingTarget(atom/attacked_target)
	if(charging)
		return
	if(dash_cooldown <= world.time && !client && charge_ready)
		PrepCharge(attacked_target)
		return
	. = ..()
	if(!ishuman(attacked_target))
		return
	var/mob/living/carbon/human/H = attacked_target
	if(H.health < 0 || gibbing)
		H.gib()
		playsound(src, "sound/abnormalities/clouded_monk/eat.ogg", 75, 1)
		adjustBruteLoss(-heal_amount)
	return

/mob/living/simple_animal/hostile/ordeal/dog_corrosion/OpenFire()
	if(dash_cooldown <= world.time && charge_ready)
		var/chance_to_dash = 25
		var/dir_to_target = get_dir(get_turf(src), get_turf(target))
		if(dir_to_target in list(NORTH, SOUTH, WEST, EAST))
			chance_to_dash = 100
		if(prob(chance_to_dash))
			PrepCharge(target)

/mob/living/simple_animal/hostile/ordeal/dog_corrosion/proc/PrepCharge(target, forced)
	if(charging || dash_cooldown > world.time && (!forced))
		return
	new /obj/effect/temp_visual/distortedform_shift(get_turf(src))
	dash_cooldown = world.time + dash_cooldown_time
	charging = TRUE
	var/dir_to_target = get_dir(get_turf(src), get_turf(target))
	been_hit = list()
	dash_num = (get_dist(src, target) + 3)
	addtimer(CALLBACK(src, PROC_REF(Charge), dir_to_target, 0), 8)
	charge_ready = FALSE
	playsound(src, charge_sound, 100, 1)

/mob/living/simple_animal/hostile/ordeal/dog_corrosion/proc/Charge(move_dir, times_ran)
	var/stop_charge = FALSE
	if(times_ran >= dash_num)
		stop_charge = TRUE
	var/turf/T = get_step(get_turf(src), move_dir)
	if(!T || stat == DEAD)
		charging = FALSE
		return
	if(T.density)
		stop_charge = TRUE
	for(var/obj/structure/window/W in T.contents)
		stop_charge = TRUE
	for(var/obj/machinery/door/poddoor/P in T.contents)//FIXME: Still opens the "poddoor" secure shutters
		stop_charge = TRUE
		continue
	if(stop_charge)
		if((current_dash < dash_count) && target)
			current_dash += 1
			addtimer(CALLBACK(src, PROC_REF(PrepCharge), target, TRUE), 2)
		else
			current_dash = 1
		charging = FALSE
		icon_state = icon_aggro
		return
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			D.open(2)
	forceMove(T)
	for(var/turf/TF in range(1, T))//Smash AOE visual
		new /obj/effect/temp_visual/smash_effect(TF)
	for(var/mob/living/L in range(1, T))//damage applied to targets in range
		if(faction_check_mob(L))
			continue
		if(L in been_hit)
			continue
		if(L.z != z)
			continue
		visible_message(span_boldwarning("[src] bites [L]!"))
		to_chat(L, span_userdanger("[src] takes a bite out of you!"))
		var/turf/LT = get_turf(L)
		new /obj/effect/temp_visual/kinetic_blast(LT)
		L.apply_damage(dash_damage,RED_DAMAGE, null, L.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)
		been_hit += L
		playsound(L, 'sound/effects/ordeals/brown/cromer_stab.ogg', 75, 1)
		if(!ishuman(L))
			continue
		var/mob/living/carbon/human/H = L
		if(H.health < 0 || gibbing)
			H.gib()
			playsound(src, "sound/abnormalities/clouded_monk/eat.ogg", 75, 1)
			adjustBruteLoss(-heal_amount)
			times_ran = dash_num //stop the charge, we got them!
	addtimer(CALLBACK(src, PROC_REF(Charge), move_dir, (times_ran + 1)), 0.5)

/mob/living/simple_animal/hostile/ordeal/dog_corrosion/strong
	name = "four-legged beast"
	desc = "A massive four-legged creature in what looks like a set of armor for humans."
	icon_state = "ravenous_beast"
	icon_living = "ravenous_beast"
	faction = list("gold_ordeal")
	maxHealth = 3000
	health = 3000
	melee_damage_lower = 18
	melee_damage_upper = 20
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 1.3)
	butcher_results = list(/obj/item/food/meat/slab/human = 3)
	guaranteed_butcher_results = list(/obj/item/food/meat/slab/human = 1)
	dash_num = 30
	dash_cooldown_time = 3 SECONDS
	dash_damage = 100
	dash_count = 3
	charge_sound = 'sound/effects/ordeals/gold/growl2.ogg'

#undef STATUS_EFFECT_VENOM

/obj/projectile/poisonglob
	name = "poison glob"
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	hitsound = 'sound/abnormalities/ichthys/jump.ogg'
	damage = 20
	speed = 0.7
	damage_type = BLACK_DAMAGE
	color = "#218a18"

/obj/projectile/poisonglob/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(isliving(target))
		var/mob/living/H = target
		H.apply_venom(3)
