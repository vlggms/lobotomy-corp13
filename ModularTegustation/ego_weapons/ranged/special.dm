//My sweet orange tree - The cure
/obj/item/ego_weapon/ranged/flammenwerfer
	name = "flamethrower"
	desc = "A shitty flamethrower, great for clearing out infested areas and people."
	special = "Use this in-hand to cover yourself in flames. To prevent infection, of course."
	icon = 'icons/obj/flamethrower.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/flamethrower_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/flamethrower_righthand.dmi'
	icon_state = "flamethrower1"
	inhand_icon_state = "flamethrower_1"
	projectile_path = /obj/projectile/ego_bullet/flammenwerfer
	weapon_weight = WEAPON_HEAVY
	spread = 50
	fire_sound = 'sound/effects/burn.ogg'
	autofire = 0.08 SECONDS
	fire_sound_volume = 5

/obj/item/ego_weapon/ranged/flammenwerfer/attack_self(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(do_after(H, 12, src))
		to_chat(H,"<span class='warning'>You cover yourself in flames!</span>")
		H.playsound_local(get_turf(H), 'sound/effects/burn.ogg', 100, 0)
		H.deal_damage(5, RED_DAMAGE)
		H.adjust_fire_stacks(1)
		H.IgniteMob()

//Nihil Upgrade
/obj/item/ego_weapon/ranged/hatred_nihil
	name = "pointless hate"
	desc = "If I am on the side of good, then someone has to be on the side of evil. Without someone to play the villain, I can’t exist."
	icon_state = "hate"
	inhand_icon_state = "hate"
	fire_delay = 7
	special = "This weapon's projectile has IFF and heals the user and humans near the user on hit."
	force = 35
	attack_speed = 1
	damtype = BLACK_DAMAGE
	weapon_weight = WEAPON_MEDIUM
	projectile_path = /obj/projectile/ego_bullet/hatred_nihil
	fire_sound = 'sound/abnormalities/hatredqueen/attack.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 120,
							JUSTICE_ATTRIBUTE = 80
							)
	max_shots = 25
	ammo_on_reload = 1
	passive_reload = 3 SECONDS
	reloadtime = 0.2 SECONDS
	reload_start_sound = 'sound/abnormalities/hatredqueen/gun.ogg'
	reload_text = "The weapon starts to recharge its mana."

	alternate_fire_name = "Arcane Beats"
	alternate_info = "This weapon will charge up for a short ranged, black AOE attack that knocks away enemies hit."
	alternate_reload_type = RELOADTYPE_SHARED_MAGAZINE
	alternate_toggle_sound = 'sound/abnormalities/hatredqueen/casting.ogg'
	alternate_toggle_sound_volume = 65
	alternate_toggle_enabled_message = span_notice("You will now cast Arcana Beats.")
	alternate_toggle_disabled_message = span_notice("You will no longer cast Arcana Beats.")
	var/obj/effect/qoh_sygil/sygil
	var/blast_damage = 230

	//Take Damage to gain damage. More damage you take the longer it lasts and the stronger the effect
	var/damage_timer = null
	var/damage_cap = 1.4
	var/time_per_hit = 0.5 SECONDS
	var/damage_per_hit = 0.004
	var/damage_decay_amount = 0.04

	var/max_mult_time = 10 SECONDS
	var/min_mult_time = 0.1 SECONDS
	var/current_time = 0

/obj/item/ego_weapon/ranged/hatred_nihil/GunAttackInfo()
	var/damage_type = damtype
	var/base_damage = blast_damage
	if(!alternate_selected)
		return ..()
	var/damage = round(base_damage * force_multiplier * projectile_damage_multiplier, 0.1)
	if(GLOB.damage_type_shuffler?.is_enabled && IsColorDamageType(damage_type))
		var/datum/damage_type_shuffler/shuffler = GLOB.damage_type_shuffler
		var/new_damage_type = shuffler.mapping_offense[damage_type]
		damage_type = new_damage_type
	return span_notice("Arcane Beats deal [damage] [damage_type] damage.[force_multiplier != 1 ? " (+ [(force_multiplier - 1) * 100]%)" : ""]")


/obj/item/ego_weapon/ranged/hatred_nihil/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!user)
		return
	RegisterSignal(user, COMSIG_MOB_AFTER_APPLY_DAMGE, PROC_REF(PostDamage))

/obj/item/ego_weapon/ranged/hatred_nihil/Destroy(mob/user)
	UnregisterSignal(user, COMSIG_MOB_AFTER_APPLY_DAMGE)
	RemoveSygil(user)
	deltimer(damage_timer)
	return ..()

/obj/item/ego_weapon/ranged/hatred_nihil/dropped(mob/user)
	. = ..()
	UnregisterSignal(user, COMSIG_MOB_AFTER_APPLY_DAMGE)
	RemoveSygil(user)

/obj/item/ego_weapon/ranged/hatred_nihil/EnableAltfire(mob/user, silent = TRUE)
	. = ..()
	fire_delay = 25
	passive_reload = 6 SECONDS
	ammo_per_shot = 5
	chargetime = 15

/obj/item/ego_weapon/ranged/hatred_nihil/DisableAltfire(mob/user, silent = TRUE)
	. = ..()
	fire_delay = 7
	passive_reload = 3 SECONDS
	ammo_per_shot = 1
	chargetime = 0


/obj/item/ego_weapon/ranged/hatred_nihil/attack(mob/living/target, mob/living/carbon/human/user)
	force = initial(force) * projectile_damage_multiplier
	. = ..()

/obj/item/ego_weapon/ranged/hatred_nihil/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, temporary_damage_multiplier = 1)
	if(!alternate_selected)
		. = ..()
		if(!.)
			return
		user.do_attack_animation(target, no_effect = TRUE)
		return
	if(!CanUseEgo(user))
		return

	if(HAS_TRAIT(user, TRAIT_PACIFISM) && lethal) // If the user has the pacifist trait, then they won't be able to fire [src] if the [lethal] var is TRUE.
		to_chat(user, span_warning("[src] is lethal! You don't want to risk harming anyone..."))
		return

	if(user)
		SEND_SIGNAL(user, COMSIG_MOB_FIRED_GUN, src, target, params, zone_override)

	SEND_SIGNAL(src, COMSIG_GUN_FIRED, user, target, params, zone_override)

	add_fingerprint(user)

	if(semicd)
		return
	//Code here
	ArcanaBeats(user)
	process_chamber(user)
	semicd = TRUE
	addtimer(CALLBACK(src, PROC_REF(reset_semicd)), fire_delay)

	if(user)
		user.update_inv_hands()
	SSblackbox.record_feedback("tally", "gun_fired", 1, type)

	if(click_cooldown_override)
		user.changeNext_move(click_cooldown_override)
	else
		user.changeNext_move(CLICK_CD_RANGE)
	user.newtonian_move(get_dir(target, user))

	return TRUE

/obj/item/ego_weapon/ranged/hatred_nihil/ChargeUp(mob/living/user)
	if(!CanUseEgo(user))
		return
	is_charging = TRUE
	if(passive_reload)
		BufferPassiveTimer(chargetime, user) // We don't really want the weapon to reload while its charging up
	SpawnSygil(user)
	playsound(user, charge_sound, charge_sound_volume, vary_fire_sound)
	if(do_after(user, chargetime, src))
		to_chat(user, span_nicegreen("You cast Arcana Beats."))
		is_charging = FALSE
		RemoveSygil(user)
		process_fire(user, user)
		return
	RemoveSygil(user)
	is_charging = FALSE
	to_chat(user, span_warning("You need to wait before casting with Arcana Beats!"))

/obj/item/ego_weapon/ranged/hatred_nihil/OnCharged(mob/living/user)
	process_fire(user, user)

/obj/item/ego_weapon/ranged/hatred_nihil/proc/SpawnSygil(mob/user)
	if(sygil)
		return
	var/obj/effect/qoh_sygil/S = new(get_turf(src))
	S.icon_state = "qoh1"
	sygil = S
	RegisterSignal(user, COMSIG_ATOM_DIR_CHANGE, PROC_REF(AjdustSygil))
	AjdustSygil(user)

/obj/item/ego_weapon/ranged/hatred_nihil/proc/AjdustSygil(mob/user)
	if(!sygil)
		return
	switch(user.dir)
		if(EAST)
			sygil.pixel_x = 0
			sygil.pixel_y = -16
			var/matrix/new_matrix = matrix()
			new_matrix.Scale(0.5, 1)
			sygil.transform = new_matrix
			sygil.layer = (user.layer + 0.1)
		if(WEST)
			sygil.pixel_x = -32
			sygil.pixel_y = -16
			var/matrix/new_matrix = matrix()
			new_matrix.Scale(0.5, 1)
			sygil.transform = new_matrix
			sygil.layer = (user.layer + 0.1)
		if(SOUTH)
			sygil.pixel_x = -16
			sygil.pixel_y = -32
			var/matrix/new_matrix = matrix()
			sygil.transform = new_matrix
			sygil.layer = (user.layer + 0.1)
		if(NORTH)
			sygil.pixel_x = -16
			sygil.pixel_y = 0
			var/matrix/new_matrix = matrix()
			sygil.transform = new_matrix
			sygil.layer = (user.layer - 0.1)

/obj/item/ego_weapon/ranged/hatred_nihil/proc/RemoveSygil(mob/user)
	if(!sygil)
		return
	UnregisterSignal(user, COMSIG_ATOM_DIR_CHANGE, PROC_REF(AjdustSygil))
	sygil.fade_out()
	sygil = null

/obj/item/ego_weapon/ranged/hatred_nihil/proc/ArcanaBeats(mob/user)
	var/aoe = blast_damage
	var/justicemod = get_attack_multiplier(user)
	var/firsthit = TRUE //One target takes full damage
	var/turf/stepturf = (get_step(get_step(user, user.dir), user.dir))
	playsound(src, 'sound/abnormalities/hatredqueen/gun.ogg', 65, FALSE, 4)
	aoe*=justicemod*force_multiplier*projectile_damage_multiplier
	for(var/turf/T in range(2, stepturf))
		new /obj/effect/temp_visual/revenant(T)
	for(var/mob/living/L in range(2, stepturf)) //knocks enemies away from you
		if(L == user || ishuman(L))
			continue
		L.deal_damage(aoe, BLACK_DAMAGE, user, attack_type = (ATTACK_TYPE_SPECIAL))
		if(firsthit)
			aoe = (aoe / 2)
			firsthit = FALSE
		var/throw_target = get_edge_target_turf(L, get_dir(L, get_step_away(L, src)))
		if(!L.anchored)
			var/whack_speed = (prob(60) ? 1 : 4)
			L.throw_at(throw_target, rand(1, 2), whack_speed, user)

/obj/item/ego_weapon/ranged/hatred_nihil/proc/HealingAura(mob/user, amt)
	if(!user)
		return
	for(var/mob/living/carbon/human/H in view(1, user))
		if(!user.faction_check_mob(H) || H.is_working)
			continue
		if((H.stat == DEAD) || H.status_flags & GODMODE)//if the target was already dead or godmode. We don't want someone to farm charge off of a dead body
			continue
		H.adjustBruteLoss(-amt)
		H.adjustSanityLoss(-amt)

/obj/item/ego_weapon/ranged/hatred_nihil/proc/PostDamage(mob/living/carbon/human/user, damage_amount, damage_type, def_zone, attacker, damage_flags, attack_type)
	if(user.is_working)
		return
	if(damage_amount <= 0 || !isliving(attacker) || user == attacker || (attack_type & (ATTACK_TYPE_COUNTER | ATTACK_TYPE_ENVIRONMENT | ATTACK_TYPE_STATUS)))
		return
	new /obj/effect/temp_visual/revenant(get_turf(user))
	shotsleft = min(shotsleft + ceil(damage_amount/4), max_shots)
	UpdateAmmoCounter()
	var/damage_increase = damage_per_hit * damage_amount
	projectile_damage_multiplier = min(projectile_damage_multiplier + damage_increase, damage_cap)

	var/time_amount = time_per_hit * damage_amount
	if(damage_timer)
		time_amount += timeleft(damage_timer)
	time_amount = min(time_amount, max_mult_time)
	current_time = time_amount

	deltimer(damage_timer)
	damage_timer = addtimer(CALLBACK(src, PROC_REF(DecayDamage)), current_time, TIMER_STOPPABLE)

/obj/item/ego_weapon/ranged/hatred_nihil/proc/DecayDamage()
	if(!damage_timer)
		return
	projectile_damage_multiplier = max(projectile_damage_multiplier - damage_decay_amount, 1)
	deltimer(damage_timer)
	if(projectile_damage_multiplier <= 1)
		return
	current_time = max(min_mult_time, current_time/2)
	damage_timer = addtimer(CALLBACK(src, PROC_REF(DecayDamage)), current_time, TIMER_STOPPABLE)
