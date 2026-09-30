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

//Realized version
/obj/item/ego_weapon/ranged/lovejustice
	name = "love and justice"
	desc = "Idk"
	icon_state = "lovejustice"
	inhand_icon_state = "lovejustice"
	special = "This weapon heals humans in a small area on hit. Successfully healing a human slightly lowers Arcana Slave's cooldown."
	force = 32
	attack_speed = 1
	damtype = BLACK_DAMAGE
	projectile_path = /obj/projectile/ego_bullet/ego_lovejustice
	weapon_weight = WEAPON_MEDIUM
	fire_delay = 15
	max_shots = 10
	ammo_on_reload = 1
	passive_reload = 2.5 SECONDS
	reloadtime = 0.2 SECONDS
	reload_start_sound = 'sound/abnormalities/hatredqueen/gun.ogg'
	reload_text = "The weapon starts to recharge its mana."
	fire_sound = 'sound/abnormalities/hatredqueen/attack.ogg'

	charge = TRUE
	charge_cost = 10
	ability_type = ABILITY_UNIQUE
	custom_charge_gain = "This weapon has charge mechanics and gains a charge upon healing a human with its projectile."
	charge_effect = "Clicking on a target grants them a Mark of Villainy. The mark increases the damage the target takes from this weapon and Arcana Slave."
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 100
							)
	var/mark_cooldown
	var/mark_cooldown_time = 5 SECONDS

/obj/item/ego_weapon/ranged/lovejustice/GunAttackInfo(mob/user)
	return span_notice("Its magic deal [last_projectile_damage] randomly chosen damage.[force_multiplier != 1 ? " (+ [(force_multiplier - 1) * 100]%)" : ""]")

/obj/item/ego_weapon/ranged/lovejustice/afterattack(atom/target, mob/living/user, proximity_flag, clickparams)
	if(!CanUseEgo(user))
		return

	if(!currently_charging)
		return ..()
	if(mark_cooldown <= world.time)
		currently_charging = FALSE
		if(isliving(target))
			var/mob/living/L = target
			if(user.faction_check_mob(L))
				to_chat(user,span_warning("[src] is on your side!"))
				return
			charge_amount -= charge_cost
			L.apply_status_effect(/datum/status_effect/display/villan_mark)
			mark_cooldown = world.time + mark_cooldown_time
			playsound(src, 'sound/abnormalities/hatredqueen/casting.ogg', 65, FALSE, 4)
			to_chat(user,span_nicegreen("You mark [L] as a villan!"))
		return
	to_chat(user,span_warning("You marked someone too recently."))

/obj/item/ego_weapon/ranged/lovejustice/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0, temporary_damage_multiplier = 1)
	if(!CanUseEgo(user))
		return
	. = ..()
	if(!.)
		return
	user.do_attack_animation(target, no_effect = TRUE)


/datum/status_effect/display/villan_mark
	id = "villan_mark"
	status_type = STATUS_EFFECT_REFRESH
	display_name = "villan"
	duration = 300 //30 seconds

//Nihil Upgrade
/obj/item/ego_weapon/ranged/hatred_nihil
	name = "pointless hate"
	desc = "If I am on the side of good, then someone has to be on the side of evil. Without someone to play the villain, I can’t exist."
	icon_state = "hate"
	inhand_icon_state = "hate"
	fire_delay = 1
	autofire = 0.5 SECONDS
	special = "This weapon heals humans that it hits."
	force = 35
	damtype = BLACK_DAMAGE
	weapon_weight = WEAPON_HEAVY
	projectile_path = /obj/projectile/ego_bullet/ego_hatred
	fire_sound = 'sound/abnormalities/hatredqueen/attack.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 120,
							JUSTICE_ATTRIBUTE = 80
							)
	var/can_blast = TRUE
	var/blasting = FALSE
	var/blast_damage = 150

/obj/item/ego_weapon/ranged/hatred_nihil/proc/Recharge(mob/user)
	can_blast = TRUE
	to_chat(user,"<span class='nicegreen'>Arcana beats is ready to fire again.</span>")

/obj/item/ego_weapon/ranged/hatred_nihil/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(!can_blast)
		to_chat(user,"<span class='warning'>You attacked too recently.</span>")
		return
	can_blast = FALSE
	var/obj/effect/qoh_sygil/S = new(get_turf(src))
	S.icon_state = "qoh1"
	switch(user.dir)
		if(EAST)
			S.pixel_x += 16
			var/matrix/new_matrix = matrix()
			new_matrix.Scale(0.5, 1)
			S.transform = new_matrix
			S.layer = (src.layer + 0.1)
		if(WEST)
			S.pixel_x += -16
			var/matrix/new_matrix = matrix()
			new_matrix.Scale(0.5, 1)
			S.transform = new_matrix
			S.layer = (src.layer + 0.1)
		if(SOUTH)
			S.pixel_y += -16
			S.layer = (src.layer + 0.1)
		if(NORTH)
			S.pixel_y += 16
			S.layer -= 0.1
	addtimer(CALLBACK(S, TYPE_PROC_REF(/obj/effect/qoh_sygil, fade_out)), 3 SECONDS)
	if(do_after(user, 15, src))
		var/aoe = blast_damage
		var/justicemod = get_attack_multiplier(user)
		var/firsthit = TRUE //One target takes full damage
		var/turf/stepturf = (get_step(get_step(user, user.dir), user.dir))
		playsound(src, 'sound/abnormalities/hatredqueen/gun.ogg', 65, FALSE, 4)
		aoe*=justicemod
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
	addtimer(CALLBACK(src, PROC_REF(Recharge), user), 15 SECONDS)
