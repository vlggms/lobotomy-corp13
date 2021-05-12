/obj/item/dark_bible
	name = "dark bible"
	desc = "The darkest of hearts, obtained from the beast made of light. Allows you to perform a ritual to allow other people wield apostle weaponry."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "darkbible"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_NORMAL
	var/uses = 6
	var/audio_cd // To prevent sound abuse

/obj/item/dark_bible/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(proximity_flag && ishuman(target))
		if(user != target)
			if(uses > 0 && audio_cd < world.time)
				var/mob/living/carbon/human/H = target
				if("apostle" in H.faction)
					to_chat(user, "<span class='info'>[H] is already empowered by dark light.</span>")
					return
				user.visible_message("<span class='info'>[user] puts hand on [H]'s shoulder, with [src] in the other hand and starts murmuring something.</span>", \
				"<span class='warning'>You begin spelling the prayer to grant power to [H].</span>", \
				"<span class='hear'>You can hear some sort of a prayer nearby.</span>")
				audio_cd = (world.time + 15 SECONDS)
				playsound(src, 'ModularTegustation/Tegusounds/apostle/antagonist/whisper.ogg', 50, 1)
				if(!do_after(user, 100))
					return
				uses -= 1
				H.faction |= "apostle"
				to_chat(user, "<span class='info'>You finish the prayer, and suddenly, [H] starts to glow witn an ominous light.</span>")
				to_chat(H, "<span class='info'>As soon as [user] finishes reading the prayer, you start glowing with an ominous light.</span>")
				H.set_light_color(COLOR_RED_LIGHT)
				H.set_light(2)
			else
				to_chat(user, "<span class='info'>Pages in [src] seem blank. Perhaps there will be a use for it later?</span>")
		else
			to_chat(user, "<span class='info'>You can't offer a prayer for yourself!</span>")

/obj/item/storage/book/bible
	var/apostle_use = FALSE

/obj/item/storage/book/bible/attack_self(mob/living/carbon/human/user) // Normal bible effect when used by apostle №12.
	for(var/datum/antagonist/apostle/A in user.mind.antag_datums)
		if(A.number == 12)
			var/mob/living/simple_animal/hostile/megafauna/apostle/devil
			for(var/mob/living/simple_animal/hostile/megafauna/apostle/E in GLOB.player_list)
				devil = E
				break
			if(!devil)
				to_chat(user, "<span class='notice'>The evil spirit is already gone.</span>")
				return
			if(devil.apostle_num != 666)
				to_chat(user, "<span class='notice'>You have nothing to ask for. Yet...</span>")
				return
			if(apostle_use)
				return // Avoiding spam.
			apostle_use = TRUE
			var/text_pick = pick("You begin praying for safety of the station...", "You ask the god for forgiveness...", \
			"You wish to abandon the dark ways of the false prophet...", "You shall never be one with him again...")
			user.visible_message("<span class='info'>[user] holds bible close to the chest and starts whispering something.</span>", \
			"<span class='warning'>[text_pick]</span>", \
			"<span class='hear'>You can hear someone whispering...</span>")
			if(!do_after(user, 300))
				apostle_use = FALSE
				return
			playsound(devil.loc, 'sound/machines/clockcult/ark_damage.ogg', 100, TRUE, -1)
			devil.adjustBruteLoss(devil.maxHealth / 12)
			to_chat(devil, "<span class='colossus'>The twelfth is trying to purge us!</span>")
			to_chat(user, "<span class='notice'>You feel weaker, but so is the evil spirit.</span>")
			user.emote("scream")
			user.adjustFireLoss(30)
			user.jitteriness += (50)
			user.do_jitter_animation(user.jitteriness)
			apostle_use = FALSE

/obj/item/clothing/suit/armor/apostle
	name = "paradise lost"
	desc = "Your armor, to protect the holy one."
	worn_icon = 'ModularTegustation/Teguicons/teguclothing_worn.dmi'
	icon_state = "apostlearmor"
	item_flags = DROPDEL
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list(MELEE = 70, BULLET = 50, LASER = 50, ENERGY = 80, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 95, WOUND = 15)
	transparent_protection = HIDEGLOVES|HIDESUITSTORAGE|HIDEJUMPSUIT|HIDESHOES
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	slowdown = 0.4

/obj/item/clothing/suit/armor/apostle/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, "apostle")

/obj/item/clothing/mask/gas/apostle
	name = "paradise lost"
	desc = "The eyes of light."
	worn_icon = 'ModularTegustation/Teguicons/teguclothing_worn.dmi'
	icon_state = "apostlemask"
	item_flags = DROPDEL
	visor_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	visor_flags_inv = HIDEFACIALHAIR
	visor_flags_cover = MASKCOVERSMOUTH
	armor = list(MELEE = 70, BULLET = 50, LASER = 50, ENERGY = 80, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 95, WOUND = 45) // Wound bonus so you can't remove their head.
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	heat_protection = HEAD
	body_parts_covered = HEAD
	resistance_flags = FIRE_PROOF | LAVA_PROOF

/obj/item/clothing/mask/gas/apostle/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, "apostle")

/obj/item/clothing/mask/gas/apostle/guardian
	desc = "Let none harm the holy one, for I am his right hand."
	icon_state = "apostlemask_guardian"

/obj/item/clothing/mask/gas/apostle/heretic
	desc = "Perhaps it's not too late to ask for forgiveness?"
	icon_state = "apostlemask_12"

/obj/item/nullrod/scythe/apostle
	chaplain_spawnable = FALSE // Mistakes were made.
	icon_state = "ap_scythe"
	inhand_icon_state = "ap_scythe"
	lefthand_file = 'ModularTegustation/Teguicons/teguitems_hold_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/teguitems_hold_right.dmi'
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	name = "holy scythe"
	desc = "None shall harm us."
	hitsound = 'ModularTegustation/Tegusounds/apostle/antagonist/scythe.ogg'
	force = 34
	throwforce = 14 // Why are you throwing scythe anyway?
	armour_penetration = 25
	block_chance = 15
	wound_bonus = 10
	bare_wound_bonus = 20
	sharpness = SHARP_EDGED
	var/faction_needed = "apostle"

/obj/item/nullrod/scythe/apostle/attack_hand(mob/living/user)
	. = ..()
	if(!(faction_needed in user.faction))
		user.Paralyze(50)
		user.dropItemToGround(src, TRUE)
		user.visible_message("<span class='warning'>A powerful force shoves [user] away from [src]!</span>", \
		"<span class='danger'>You shall not attempt to harm us</span>")

/obj/item/nullrod/scythe/apostle/attack(mob/living/target, mob/living/carbon/human/user)
	if(faction_needed in target.faction)
		to_chat(user, "<span class='userdanger'>Careful with the holy weapon...</span>")
		return
	if(target.health <= HEALTH_THRESHOLD_DEAD || target.stat == DEAD)
		user.changeNext_move(CLICK_CD_MELEE * 0.4) // Le funny destruction of corpses.
		user.heal_bodypart_damage(3,3) // Free heals.
	..()

/obj/item/nullrod/scythe/apostle/guardian
	name = "guardian scythe"
	desc = "The divine light will grant you protection."
	force = 38
	throwforce = 18
	armour_penetration = 40
	block_chance = 30
	var/recharge_time
	var/recharge_base = 6 SECONDS
	var/spell_radius = 1
	var/spin_force = 75

/obj/item/nullrod/scythe/apostle/guardian/attack_self(mob/living/carbon/user)
	var/list/target_turfs = list()
	if(recharge_time > world.time)
		to_chat(user, "<span class='warning'>You are not ready to purge heretics yet.</span>")
		return
	for(var/i in range(spell_radius, user))
		if(isturf(i))
			new /obj/effect/temp_visual/cult/sparks(i)
			target_turfs += i
			continue
	recharge_time = (world.time + (recharge_base * 0.5))
	user.visible_message("<span class='warning'>[user] takes a defensive stance and digs [src] into the ground!</span>", \
	"<span class='warning'>We prepare to annihilate everything next to us.</span>", \
	"<span class='hear'>You can hear a wild metal screech nearby.</span>")
	if(!do_after(user, 15))
		return
	var/init_force = force
	force = spin_force
	user.emote("spin")
	user.emote("flip")
	playsound(src, 'ModularTegustation/Tegusounds/apostle/antagonist/scythe_spell.ogg', 150, 1)
	visible_message("<span class='boldwarning'>[user] spins wildly with [src] in hands!</span>")
	for(var/turf/open/K in target_turfs)
		new /obj/effect/temp_visual/kinetic_blast(K)
		for(var/mob/living/L in K.contents)
			if(!(faction_needed in L.faction) && !(L.health <= -200)) // Don't attack super-dead people. Preventing le funny dilation spikes.
				shake_camera(L, 2, 1)
				melee_attack_chain(user, L)
	recharge_time = (world.time + recharge_base)
	force = init_force

/obj/item/nullrod/scythe/apostle/guardian/light // An overpowered piece of shit, granted to whoever defeats the apostle with a crusher.
	name = "heavenly scythe"
	desc = "A particle of light, obtained from the heart of the evil."
	icon_state = "ap_scythe_light"
	inhand_icon_state = "ap_scythe_light"
	force = 45
	throwforce = 24
	armour_penetration = 60
	block_chance = 40
	recharge_base = 5 SECONDS
	spell_radius = 2
	spin_force = 90
	faction_needed = "hero" // Yep. A hero.
	var/bound = FALSE // If it's true - nobody can gain the faction required to use it.

/obj/item/nullrod/scythe/apostle/guardian/light/attack_hand(mob/living/user)
	if(!bound && !(faction_needed in user.faction))
		user.faction |= faction_needed
		to_chat(user, "<span class='userdanger'>[user.real_name]. You deserve it.</span>")
		SEND_SOUND(user, 'ModularTegustation/Tegusounds/apostle/mob/apostle_bell.ogg')
		flash_color(user, flash_color = "#FF4400", flash_time = 100)
		bound = TRUE
	. = ..()

/obj/item/gun/magic/staff/apostle
	name = "staff of light"
	desc = "Let none approach the holy one."
	icon_state = "staffofchaos"
	inhand_icon_state = "staffofchaos"
	ammo_type = /obj/item/ammo_casing/magic/arcane_barrage/apostle
	charges = 150
	max_charges = 150
	recharge_rate = 1
	burst_size = 15
	fire_delay = 1.5
	spread = 16
	var/charge_cooldown // To avoid sound spam.

/obj/item/gun/magic/staff/apostle/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(!("apostle" in user.faction))
		user.Paralyze(50)
		user.dropItemToGround(src, TRUE)
		user.visible_message("<span class='warning'>A powerful force shoves [user] away from [target]!</span>", \
		"<span class='danger'>You shall not attempt to harm us</span>")
		return
	if(charge_cooldown > world.time)
		to_chat(user, "<span class='warning'>You are not ready to charge the staff yet.</span>")
		return
	charge_cooldown = (world.time + 5 SECONDS)
	playsound(src, 'ModularTegustation/Tegusounds/apostle/antagonist/staff_charge.ogg', 100, 1)
	new /obj/effect/temp_visual/dir_setting/curse/grasp_portal/fading(target)
	user.visible_message("<span class='warning'>[user] points [src] towards [target]!</span>", \
	"<span class='warning'>We start channeling the power of [src].</span>", \
	"<span class='hear'>You can hear an ominous buzzing.</span>")
	if(!do_after(user, 30))
		return
	charge_cooldown = (world.time + 5 SECONDS) // To keep it a proper cooldown
	return ..()

/obj/item/ammo_casing/magic/arcane_barrage/apostle
	projectile_type = /obj/projectile/magic/arcane_barrage/apostle

/obj/projectile/magic/arcane_barrage/apostle
	damage = 16
	damage_type = BURN
	armour_penetration = 25

/obj/projectile/magic/arcane_barrage/apostle/on_hit(target)
	if(ismob(target))
		var/mob/H = target
		if("apostle" in H.faction)
			H.visible_message("<span class='warning'>[src] vanishes on contact with [H]!</span>")
			qdel(src)
			return BULLET_ACT_BLOCK
	. = ..()

/obj/item/nullrod/spear/apostle
	chaplain_spawnable = FALSE
	name = "heavenly spear"
	desc = "A holy weapon capable of piercing the sky."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/teguitems_hold_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/teguitems_hold_right.dmi'
	icon_state = "ap_spear"
	inhand_icon_state = "ap_spear"
	hitsound = 'ModularTegustation/Tegusounds/apostle/antagonist/spear.ogg'
	force = 17 // Weaker in melee, but kills everyone with its active ability.
	throwforce = 34 // That's a spear after all.
	armour_penetration = 15
	wound_bonus = 20
	bare_wound_bonus = 40
	throw_speed = 4
	throw_range = 8
	embedding = list("impact_pain_mult" = 2, "remove_pain_mult" = 4, "jostle_chance" = 2.5)
	attack_verb_continuous = list("attacks", "impales", "pierces", "tears", "lacerates", "gores")
	attack_verb_simple = list("attack", "impale", "pierce", "tear", "lacerate", "gore")
	sharpness = SHARP_EDGED
	var/dash_distance = 6
	var/recharge_time_base = 8 SECONDS // You can dash every 8 seconds.
	var/recharge_time = 0
	var/dash_force = 65 // Temporary force for dash ability.
	var/list/target_turfs = list()

/obj/item/nullrod/spear/apostle/attack_self(mob/living/carbon/user)
	if(recharge_time > world.time)
		to_chat(user, "<span class='warning'>You are not ready to dash forward yet.</span>")
		return
	var/turf/T = get_step(get_turf(src), user.dir)
	var/turf/final_T // Where the user will actually teleport.
	target_turfs = list(T)
	new /obj/effect/temp_visual/cult/sparks(T)
	for(var/i in 1 to dash_distance)
		T = get_step(T, user.dir)
		new /obj/effect/temp_visual/cult/sparks(T)
		if(T.density)
			to_chat(user, "<span class='warning'>There appears to be a wall in your path!</span>")
			return
		target_turfs += T
		if(i == dash_distance)
			final_T = get_step(T, user.dir)
	recharge_time = (world.time + (recharge_time_base * 0.5)) // This one here to avoid spam
	to_chat(user, "<span class='warning'>You change your stance and prepare to dash forward.</span>")
	playsound(src, 'ModularTegustation/Tegusounds/apostle/antagonist/spear_charge.ogg', 100, 1)
	if(!do_after(user, 36))
		return
	recharge_time = (world.time + recharge_time_base) // The real cooldown
	user.forceMove(final_T)
	playsound(src, 'ModularTegustation/Tegusounds/apostle/antagonist/spear_dash.ogg', 100, 1)
	var/actual_force = force // Saving force var.
	force = dash_force // Changing force to dash_force variable.
	for(var/turf/open/K in target_turfs)
		new /obj/effect/temp_visual/small_smoke/halfsecond(K)
		for(var/mob/living/L in K.contents)
			if(!("apostle" in L.faction) && !(L.health <= -200)) // Don't attack super-dead people. Preventing le funny dilation spikes.
				new /obj/effect/temp_visual/cleave(K)
				visible_message("<span class='boldwarning'>[user] runs through [L]!</span>")
				shake_camera(L, 4, 3)
				melee_attack_chain(user, L)
	force = actual_force // After dash is complete - change it all back.

/obj/item/nullrod/spear/apostle/attack_hand(mob/living/user)
	. = ..()
	if(!("apostle" in user.faction))
		user.Paralyze(50)
		user.dropItemToGround(src, TRUE)
		user.visible_message("<span class='warning'>A powerful force shoves [user] away from [src]!</span>", \
		"<span class='danger'>You shall not attempt to harm us</span>")

/obj/item/nullrod/spear/apostle/attack(mob/living/target, mob/living/carbon/human/user)
	if("apostle" in target.faction)
		to_chat(user, "<span class='userdanger'>Careful with the holy weapon...</span>")
		return
	..()

/datum/outfit/apostle
	name = "Apostle"
	suit = /obj/item/clothing/suit/armor/apostle
	mask = /obj/item/clothing/mask/gas/apostle
	uniform = /obj/item/clothing/under/color/black // Mostly for admin spawn and when apostle was dead without any items.
	shoes = /obj/item/clothing/shoes/sneakers/black

/datum/outfit/apostle/equip(mob/living/carbon/human/H, visualsOnly = FALSE) // Drops parts of equipment crucial to event.
	H.dropItemToGround(H.wear_mask)
	H.dropItemToGround(H.wear_suit)
	. = ..()

/datum/outfit/apostle_heretic
	name = "Apostle Heretic"
	mask = /obj/item/clothing/mask/gas/apostle/heretic
	uniform = /obj/item/clothing/under/suit/burgundy // Mostly for admin spawn and when apostle was dead without any items.
	shoes = /obj/item/clothing/shoes/combat
