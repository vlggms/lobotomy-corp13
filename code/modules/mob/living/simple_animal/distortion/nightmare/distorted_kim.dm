/mob/living/simple_animal/hostile/distortion/kim
	name = "Kaukritya-Aniyata"
	desc = "A humanoid shrouded in darkness full of intent to kill."
	icon = 'ModularTegustation/Teguicons/distorted_kim.dmi'
	icon_state = "Kim"
	icon_living = "Kim"
	icon_dead = "Kim"
	faction = list("hostile")
	maxHealth = 7000
	health = 7000
	pixel_x = 0
	base_pixel_x = 0
	pixel_x = -17
	melee_damage_lower = 46
	melee_damage_upper = 46
	rapid_melee = 2
	attack_verb_continuous = "slices"
	attack_verb_simple = "slice"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	death_sound = 'sound/effects/limbus_death.ogg'
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 0.3, BLACK_DAMAGE = 1, PALE_DAMAGE = 1)
	move_to_delay = 1.5
	ranged = TRUE
//Variables important for distortions
	//The EGO worn by the egoist
	ego_list = list(
		/obj/item/clothing/suit/armor/ego_gear/city/blade_lineage_admin,
		/obj/item/ego_weapon/city/bladelineage
		)
	//The egoist's name, if specified. Otherwise picks a random name.
	egoist_names = list("Mentor Kim")
	//The mob's gender, which will be inherited by the egoist. Can be left unspecified for a random pick.
	gender = MALE
	//The Egoist's outfit, which should usually be civilian unless you want them to be a fixer or something.
	egoist_outfit = /datum/outfit/job/civilian
	//Loot on death; distortions should be valuable targets in general.
	/// Prolonged exposure to a monolith will convert the distortion into an abnormality. Black swan is the most strongly related to this guy, but I might make one for it later.
	monolith_abnormality = /mob/living/simple_animal/hostile/abnormality/clouded_monk //Both hate their time being wasted and that there is a price to it, even if this thing cannot fight back.
	egoist_attributes = 130

	var/can_act = TRUE
	/// When this reaches 400 - begins reflecting damage
	var/damage_reflection = FALSE
	var/hello_cooldown
	var/hello_cooldown_time = 6 SECONDS
	var/hello_damage = 120
	var/list/targets = list()
	var/no_counter = FALSE
	var/sidesteping = FALSE
	var/countering = FALSE
	var/counter_damage = 20
	var/speeded_up = 2
	var/restspeed = 4
	var/speed_duration = 10
	var/weaken_duration = 15
	var/charging = FALSE
	var/charge_ready = FALSE
	var/dash_num = 25
	var/dash_cooldown = 0
	var/dash_cooldown_time = 20 SECONDS
	var/dash_count = 6
	var/current_dash = 1
	var/list/been_hit = list() // Don't get hit twice.
	var/heal_amount = 250
	var/damage_taken
	var/damage_threshold = 450
	var/dash_damage = 50
	var/serumA_damage = 200
	var/charge_sound = 'sound/distortions/Kimprep.ogg'
	var/gibbing = TRUE
	var/counter_cooldown
	var/counter_cooldown_time = 4 SECONDS
	var/finishing = FALSE
	var/serumA_cooldown = 0
	var/serumA_cooldown_time = 10 SECONDS
	var/nightmare_mode = FALSE

/mob/living/simple_animal/hostile/distortion/kim/Login()
	. = ..()
	to_chat(src, "<h1>There is no such thing as honor in this city.</h1><br>\
		<b>|Overthrow|: Dash rapidly towards the target while slashing the area.<br>\
		<br>\
		|Yield my Flesh|:Assume a counter stance, if attacked, respond with...<br>\
		<br>\
		|To claim their bones|: Destroy your targets with a series of attacks if you get hit while using Yield My Flesh\
		</b>")

/datum/action/cooldown/counter
	name = "Yield my Flesh"
	icon_icon = 'ModularTegustation/Teguicons/teguicons.dmi'
	button_icon_state = "hollowpoint_ability"
	desc = "Prepare to counter an attack to deliver a devastating move."
	cooldown_time = 100
	var/countering_duration = 10


/mob/living/simple_animal/hostile/distortion/kim/Moved()
	. = ..()
	if (sidesteping)
		MoveVFX()

/mob/living/simple_animal/hostile/distortion/kim/proc/MoveVFX()
	set waitfor = FALSE
	var/obj/viscon_filtereffect/distortedform_trail/trail = new(src.loc,themob = src, waittime = 5)
	trail.vis_contents += src
	trail.filters += filter(type="drop_shadow", x=0, y=0, size=3, offset=2, color=rgb(0, 250, 229))
	trail.filters += filter(type = "blur", size = 3)
	animate(trail, alpha=120)
	animate(alpha = 0, time = 10)

/datum/action/cooldown/dodge/proc/slowdown()
	if (istype(owner, /mob/living/simple_animal/hostile/distortion/kim))
		var/mob/living/simple_animal/hostile/distortion/kim/H = owner
		H.density = TRUE
		H.sidesteping = FALSE
		H.UpdateSpeed()


/datum/action/cooldown/counter/Trigger()
	if(!..())
		return FALSE
	if (istype(owner, /mob/living/simple_animal/hostile/distortion/kim))
		var/mob/living/simple_animal/hostile/distortion/kim/H = owner
		if(H.no_counter)
			return FALSE
		else
			H.ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))
			H.countering = TRUE
			H.manual_emote("raises their blade...")
			H.color = "#26a2d4"
			playsound(H, 'sound/items/unsheath.ogg', 75, FALSE, 4)
			addtimer(CALLBACK(src, PROC_REF(endcounter)), countering_duration)
			StartCooldown()

/mob/living/simple_animal/hostile/distortion/kim/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if (countering)
		counter()

/mob/living/simple_animal/hostile/distortion/kim/bullet_act(obj/projectile/P, def_zone, piercing_hit = FALSE)
	. = ..()
	if (countering)
		counter()

/mob/living/simple_animal/hostile/distortion/kim/proc/counter()
	var/list/been_hit = list()
	say("Yield my Flesh.")
	playsound(src, 'sound/weapons/fixer/generic/finisher2.ogg', 75, TRUE, 2)
	for(var/turf/T in range(2, src))
		new /obj/effect/temp_visual/smash_effect(T)
		been_hit = HurtInTurf(T, been_hit, counter_damage, BLACK_DAMAGE, check_faction = TRUE, hurt_mechs = TRUE, mech_damage = 15, attack_type = (ATTACK_TYPE_MELEE | ATTACK_TYPE_COUNTER))
		for(var/mob/living/carbon/human/H in T)
			H.Knockdown(20)
	countering = FALSE

/datum/action/cooldown/counter/proc/endcounter()
	if (istype(owner, /mob/living/simple_animal/hostile/distortion/kim))
		var/mob/living/simple_animal/hostile/distortion/kim/H = owner
		H.countering = FALSE
		H.color = null
		H.ChangeResistances(list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1))




/mob/living/simple_animal/hostile/distortion/kim/proc/claimbones(target)
	if(!isliving(target))
		return
	var/mob/living/T = target
	playsound(src, 'sound/abnormalities/crumbling/warning.ogg', 50, 1)
//	icon_state = "cat_prepare" maybe someday we'll have nice things
	can_act = FALSE
	finishing = TRUE
	face_atom(target)
	T.add_overlay(icon('icons/effects/effects.dmi', "zorowarning"))
	addtimer(CALLBACK(T, TYPE_PROC_REF(/atom, cut_overlay), \
							icon('icons/effects/effects.dmi', "zorowarning")), 40)
	say("To claim their bones")
	SLEEP_CHECK_DEATH(5)
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
		SerumA(target)
	can_act = TRUE
	finishing = FALSE


/mob/living/simple_animal/hostile/distortion/kim/proc/Finisher(mob/living/target) //This is super hard to avoid
	target.deal_damage(10, PALE_DAMAGE, src, attack_type = (ATTACK_TYPE_MELEE | ATTACK_TYPE_SPECIAL), blocked = target.run_armor_check(null, RED_DAMAGE)) //10% of your health in red damage
	to_chat(target, span_danger("[src] is trying to cut you in half!"))
	if(!ishuman(target))
		target.deal_damage(100, PALE_DAMAGE, src, attack_type = (ATTACK_TYPE_MELEE | ATTACK_TYPE_SPECIAL)) //bit more than usual DPS in pale damage
		return
	if(target.health > 0)
		return
	var/mob/living/carbon/human/H = target
	new /obj/effect/temp_visual/human_horizontal_bisect(get_turf(H))
	H.set_lying_angle(360) //gunk code I know, but it is the simplest way to override gib_animation() without touching other code. Also looks smoother.
	H.gib()

/mob/living/simple_animal/hostile/distortion/kim/AttackingTarget(atom/attacked_target)
	if(charging)
		return
	if(dash_cooldown <= world.time && !client && charge_ready)
		PrepCharge(attacked_target)
		return
	. = ..()
	if(!ishuman(attacked_target))
		return
	var/mob/living/carbon/human/H = attacked_target
	if(H.health < 0 && gibbing)
		H.gib()
		playsound(src, 'sound/distortions/KimBasicSlash.ogg', 75, 1)
		adjustBruteLoss(-heal_amount)
	return


/mob/living/simple_animal/hostile/distortion/kim/proc/Charge(move_dir, times_ran)
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
		return
	for(var/obj/machinery/door/D in T.contents)
		if(D.density)
			D.open(2)
	forceMove(T)
	for(var/turf/TF in range(1, T))//Smash AOE visual
		new /obj/effect/temp_visual/slice(TF)
	for(var/mob/living/L in range(1, T))//damage applied to targets in range
		if(faction_check_mob(L))
			continue
		if(L in been_hit)
			continue
		if(L.z != z)
			continue
		visible_message(span_boldwarning("[src] slashes [L]!"))
		to_chat(L, span_userdanger("[src] slashes through you!"))
		var/turf/LT = get_turf(L)
		new /obj/effect/temp_visual/slice(LT)
		L.deal_damage(dash_damage, RED_DAMAGE, src, attack_type = (ATTACK_TYPE_MELEE | ATTACK_TYPE_SPECIAL))
		been_hit += L
		playsound(L, 'sound/distortions/KimBasicSlash.ogg', 75, 1)
		if(!ishuman(L))
			continue
		var/mob/living/carbon/human/H = L
		if(H.health < 0 && gibbing)
			new /obj/effect/temp_visual/human_horizontal_bisect(get_turf(H))
			H.set_lying_angle(360) //gunk code I know, but it is the simplest way to override gib_animation() without touching other code. Also looks smoother.
			H.gib()
			adjustBruteLoss(-heal_amount)
			times_ran = dash_num //stop the charge, we got them!
	addtimer(CALLBACK(src, PROC_REF(Charge), move_dir, (times_ran + 1)), 0.5)

/mob/living/simple_animal/hostile/distortion/kim/OpenFire()
	if(nightmare_mode)
		if(dash_cooldown <= world.time && charge_ready)
			var/chance_to_dash = 25
			var/dir_to_target = get_dir(get_turf(src), get_turf(target))
			if(dir_to_target in list(NORTH, SOUTH, WEST, EAST))
				chance_to_dash = 100
			if(prob(chance_to_dash))
				PrepCharge(target)
				claimbones(target)
		else
			var/chance_to_dash = 25
			var/dir_to_target = get_dir(get_turf(src), get_turf(target))
			if(dir_to_target in list(NORTH, SOUTH, WEST, EAST))
				chance_to_dash = 100
			if(prob(chance_to_dash))
				PrepCharge(target)


/mob/living/simple_animal/hostile/distortion/kim/OpenFire(atom/A)
	if(!can_act == TRUE)
		return
	if(ranged_cooldown <= world.time)
		Charge(A)

/mob/living/simple_animal/hostile/distortion/kim/Life()
	. = ..()
	if(!.) // Dead
		return FALSE
	if((counter_cooldown > world.time))
		return
	counter_cooldown = world.time + counter_cooldown_time

/mob/living/simple_animal/hostile/distortion/kim/proc/PrepCharge(target, forced)
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
	playsound(src, charge_sound)

/obj/projectile/ripper_dash_effect
	speed = 0.32
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "ripper_dash"
	projectile_piercing = ALL


/obj/projectile/ripper_dash_effect/on_hit(atom/target, blocked = FALSE)
	return

/mob/living/simple_animal/hostile/distortion/kim/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(. > 0)
		damage_taken += .
	if(damage_taken >= 480 && !damage_reflection)
		StartReflecting()

/mob/living/simple_animal/hostile/distortion/kim/death(gibbed)
	if(damage_reflection)
		damage_reflection = FALSE
	return ..()

/mob/living/simple_animal/hostile/distortion/kim/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/distortion/kim/attack_hand(mob/living/carbon/human/M)
	..()
	if(!.)
		return
	if(damage_reflection && M.a_intent == INTENT_HARM)
		ReflectDamage(M, M?.dna?.species?.attack_type, M?.dna?.species?.punchdamagehigh)

/mob/living/simple_animal/hostile/distortion/kim/attack_paw(mob/living/carbon/human/M)
	..()
	if(damage_reflection && M.a_intent != INTENT_HELP)
		ReflectDamage(M, M?.dna?.species?.attack_type, 5)

/mob/living/simple_animal/hostile/distortion/kim/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(!damage_reflection)
		return
	if(.)
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		if(damage > 0)
			ReflectDamage(M, M.melee_damage_type, damage)

/mob/living/simple_animal/hostile/distortion/kim/bullet_act(obj/projectile/Proj, def_zone, piercing_hit = FALSE)
	..()
	if(damage_reflection && Proj.firer)
		if(get_dist(Proj.firer, src) < 5)
			ReflectDamage(Proj.firer, Proj.damage_type, Proj.damage)

/mob/living/simple_animal/hostile/distortion/kim/attackby(obj/item/I, mob/living/user, params)
	..()
	if(!damage_reflection)
		return
	var/damage = I.force
	if(ishuman(user))
		damage *= 1 + (get_attribute_level(user, JUSTICE_ATTRIBUTE)/100)
	ReflectDamage(user, I.damtype, damage)
	claimbones()

/mob/living/simple_animal/hostile/distortion/kim/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
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

/mob/living/simple_animal/hostile/distortion/kim/proc/StartReflecting()
	say("Yield my flesh...")
	can_act = TRUE
	damage_reflection = TRUE
	damage_taken = 0
	playsound(get_turf(src), 'sound/distortions/Kimprep.ogg', 25, 0, 5)
	visible_message(span_warning("[src] assumes a stance!"))
	icon_state = "Kim"
	ChangeResistances(list(RED_DAMAGE = 0, WHITE_DAMAGE = 0, BLACK_DAMAGE = 0, PALE_DAMAGE = 0))
	sleep(2 SECONDS)
	if(QDELETED(src) || stat == DEAD)
		return
	icon_state = icon_living
	ChangeResistances(list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1))
	damage_reflection = FALSE
	can_act = TRUE

/mob/living/simple_animal/hostile/distortion/kim/proc/ReflectDamage(mob/living/attacker, attack_type = RED_DAMAGE, damage)
	if(QDELETED(src) || stat == DEAD)
		return
	if(damage < 1)
		return
	if(!damage_reflection)
		return
	for(var/turf/T in RANGE_TURFS(1, src))
	playsound(src, 'sound/effects/ordeals/white/white_reflect.ogg', min(15 + damage, 100), TRUE, 4)
	attacker.deal_damage(damage, attack_type, src, attack_type = (ATTACK_TYPE_COUNTER))

/mob/living/simple_animal/hostile/distortion/kim/attack_hand(mob/living/carbon/human/M)
	. = ..()
	if(!.)
		return
	if(damage_reflection && M.a_intent == INTENT_HARM)
		ReflectDamage(M, M?.dna?.species?.attack_type, M?.dna?.species?.punchdamagehigh)

/mob/living/simple_animal/hostile/distortion/kim/attack_paw(mob/living/carbon/human/M)
	. = ..()
	if(damage_reflection && M.a_intent != INTENT_HELP)
		ReflectDamage(M, M?.dna?.species?.attack_type, 5)

/mob/living/simple_animal/hostile/distortion/kim/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(!damage_reflection)
		return
	if(.)
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		if(damage > 0)
			ReflectDamage(M, M.melee_damage_type, damage)

/mob/living/simple_animal/hostile/distortion/kim/bullet_act(obj/projectile/Proj, def_zone, piercing_hit = FALSE)
	. = ..()
	if(damage_reflection && Proj.firer)
		ReflectDamage(Proj.firer, Proj.damage_type, Proj.damage)

/mob/living/simple_animal/hostile/distortion/kim/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(!damage_reflection)
		return
	var/damage = I.force
	if(ishuman(user))
		damage *= 1 + (get_modified_attribute_level(user, JUSTICE_ATTRIBUTE) / 100)
	ReflectDamage(user, I.damtype, damage)
	claimbones(target)


/mob/living/simple_animal/hostile/distortion/kim/proc/SerumA(mob/living/target)
	if(serumA_cooldown > world.time)
		return
	if(!isliving(target) || QDELETED(target))
		return
	var/mob/living/LT = target
	serumA_cooldown = world.time + serumA_cooldown_time
	playsound(src, 'sound/abnormalities/redshoes/RedShoes_Kill.ogg', 100, 1)
	icon_state = "Kim"
	charging = TRUE
	new /obj/effect/temp_visual/dir_setting/cult/phase(get_turf(LT))
	face_atom(LT)
	SLEEP_CHECK_DEATH(5)
	icon_state = "Kim"
	for(var/i = 1 to 8)
		if(!isliving(LT) || QDELETED(LT))
			break
		INVOKE_ASYNC(src, PROC_REF(blink), LT)
		SLEEP_CHECK_DEATH(2)
	icon_state = icon_living
	charging = FALSE

/mob/living/simple_animal/hostile/distortion/kim/proc/blink(mob/living/LT)
	if(!istype(LT) || QDELETED(LT))
		var/list/potential_people = list()
		for(var/mob/living/L in view(9, src))
			if(faction_check_mob(L))
				continue
			if(L == src)
				continue
			if(L.stat == DEAD)
				continue
			potential_people += L
		if(!LAZYLEN(potential_people))
			return FALSE
		LT = pick(potential_people)
	var/turf/start_turf = get_turf(src)
	var/turf/target_turf = get_step(get_turf(LT), pick(1,2,4,5,6,8,9,10))
	for(var/i = 1 to 2) // For fancy effect
		target_turf = get_step(target_turf, get_dir(get_turf(start_turf), get_turf(target_turf)))
	for(var/turf/T in getline(start_turf, target_turf))
		new /obj/effect/temp_visual/cult/sparks(T) // Telegraph the attack
	face_atom(target_turf)
	SLEEP_CHECK_DEATH(1)
	if(!istype(LT) || QDELETED(LT))
		return
	forceMove(target_turf)
	playsound(src,'sound/distortions/kim_bone_claim.ogg', 100, 1)
	for(var/turf/B in getline(start_turf, target_turf))
		for(var/turf/TT in range(B, 1))
			new /obj/effect/temp_visual/small_smoke/halfsecond(TT)
			for(var/mob/living/target in TT)
				to_chat(target, span_userdanger("\The [src] slashes you!"))
				target.deal_damage(serumA_damage, PALE_DAMAGE, src)
				new /obj/effect/temp_visual/cleave(target.loc)
				playsound(target, 'sound/distortions/kim_bone_claim.ogg', 25, 0, 5)

