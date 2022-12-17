/obj/projectile/ego_bullet/ego_correctional
	name = "correctional"
	damage = 10
	damage_type = BLACK_DAMAGE

/obj/projectile/ego_bullet/ego_hornet
	name = "hornet"
	damage = 40
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_hatred
	name = "magic beam"
	icon_state = "qoh1"
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE
	damage = 50
	spread = 10

/obj/projectile/ego_bullet/ego_hatred/on_hit(atom/target, blocked = FALSE)
	if(ishuman(target) && isliving(firer))
		var/mob/living/carbon/human/H = target
		var/mob/living/user = firer
		if(firer==target)
			return BULLET_ACT_BLOCK
		if(user.faction_check_mob(H)) // Our faction
			switch(damage_type)
				if(WHITE_DAMAGE)
					H.adjustSanityLoss(damage*0.2)
				if(BLACK_DAMAGE)
					H.adjustBruteLoss(-damage*0.1)
					H.adjustSanityLoss(damage*0.1)
				else // Red or pale
					H.adjustBruteLoss(-damage*0.2)
			H.visible_message("<span class='warning'>[src] vanishes on contact with [H]!</span>")
			qdel(src)
			return BULLET_ACT_BLOCK
	..()

/obj/projectile/ego_bullet/ego_hatred/Initialize()
	. = ..()
	icon_state = "qoh[pick(1,2,3)]"
	damage_type = pick(RED_DAMAGE, WHITE_DAMAGE, BLACK_DAMAGE, PALE_DAMAGE)
	flag = damage_type

/obj/projectile/ego_bullet/ego_magicbullet
	name = "magic bullet"
	icon_state = "magic_bullet"
	damage = 80
	speed = 0.1
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE
	projectile_piercing = PASSMOB

/obj/projectile/ego_bullet/ego_solemnlament
	name = "solemn lament"
	icon_state = "whitefly"
	damage = 15
	speed = 0.35
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/ego_solemnvow
	name = "solemn vow"
	icon_state = "blackfly"
	damage = 15
	speed = 0.35
	damage_type = BLACK_DAMAGE

//Smartgun
/obj/projectile/ego_bullet/ego_loyalty
	name = "loyalty"
	icon_state = "loyalty"
	damage = 5
	speed = 0.2
	nodamage = TRUE	//Damage is calculated later
	damage_type = RED_DAMAGE
	flag = RED_DAMAGE
	projectile_piercing = PASSMOB

/obj/projectile/ego_bullet/ego_loyalty/on_hit(atom/target, blocked = FALSE)
	if(!ishuman(target))
		nodamage = FALSE
	else
		return
	..()
	if(!ishuman(target))
		qdel(src)

/obj/projectile/ego_bullet/ego_executive
	name = "executive"
	damage = 10
	damage_type = PALE_DAMAGE	//hehe

/obj/projectile/ego_bullet/ego_crimson
	name = "crimson"
	damage = 9
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_ecstasy
	name = "ecstasy"
	icon_state = "ecstasy"
	damage_type = WHITE_DAMAGE
	flag = WHITE_DAMAGE
	damage = 10
	speed = 1.3
	range = 6

/obj/projectile/ego_bullet/ego_ecstasy/Initialize()
	. = ..()
	color = pick(COLOR_RED, COLOR_YELLOW, COLOR_LIME, COLOR_CYAN, COLOR_MAGENTA, COLOR_ORANGE)

//Smartpistol
/obj/projectile/ego_bullet/ego_praetorian
	name = "praetorian"
	icon_state = "loyalty"
	damage = 21
	nodamage = TRUE	//Damage is calculated later
	damage_type = RED_DAMAGE
	flag = RED_DAMAGE
	projectile_piercing = PASSMOB

/obj/projectile/ego_bullet/ego_praetorian/on_hit(atom/target, blocked = FALSE)
	if(!ishuman(target))
		nodamage = FALSE
	else
		return
	..()
	if(!ishuman(target))
		qdel(src)

/obj/projectile/ego_bullet/ego_magicpistol
	name = "magic pistol"
	icon_state = "magic_bullet"
	damage = 62
	speed = 0.1
	damage_type = BLACK_DAMAGE
	flag = BLACK_DAMAGE
	projectile_piercing = PASSMOB

//tommygun
/obj/projectile/ego_bullet/ego_intention
	name = "good intentions"
	damage = 8
	speed = 0.2
	damage_type = RED_DAMAGE
	flag = RED_DAMAGE

//laststop
/obj/projectile/ego_bullet/ego_laststop
	name = "laststop"
	damage = 145
	damage_type = RED_DAMAGE
	flag = RED_DAMAGE

/obj/projectile/ego_bullet/ego_aroma
	name = "aroma"
	icon_state = "arrow_aroma"
	damage = 140
	damage_type = WHITE_DAMAGE
	flag = WHITE_DAMAGE

//Assonance, our one hitscan laser
/obj/projectile/beam/assonance
	name = "assonance"
	icon_state = "omnilaser"
	hitsound = null
	damage = 35
	damage_type = WHITE_DAMAGE
	flag = WHITE_DAMAGE
	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/muzzle/laser/white
	tracer_type = /obj/effect/projectile/tracer/laser/white
	impact_type = /obj/effect/projectile/impact/laser/white
	wound_bonus = -100
	bare_wound_bonus = -100

//feather of honor
/obj/projectile/ego_bullet/ego_feather
	name = "feather"
	icon_state = "lava"
	damage = 40
	damage_type = WHITE_DAMAGE
	flag = WHITE_DAMAGE
	homing = TRUE
	speed = 1.5

//Exuviae
/obj/projectile/ego_bullet/ego_exuviae
	name = "serpents exuviae"
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "nakednest_serpent"
	desc = "A sterile naked nest serpent"
	damage = 120
	damage_type = RED_DAMAGE
	flag = RED_DAMAGE
	hitsound = "sound/effects/wounds/pierce1.ogg"

/obj/projectile/ego_bullet/ego_exuviae/on_hit(target)
	. = ..()
	if(isliving(target))
		var/mob/living/simple_animal/M = target
		if(!ishuman(M) && !M.has_status_effect(/datum/status_effect/rendRedArmor))
			new /obj/effect/temp_visual/cult/sparks(get_turf(M))
			M.apply_status_effect(/datum/status_effect/rendRedArmor)

/datum/status_effect/rendRedArmor
	id = "rend red armor"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 30 //3 seconds
	alert_type = null
	var/original_armor

/datum/status_effect/rendRedArmor/on_apply()
	. = ..()
	var/mob/living/simple_animal/M = owner
	original_armor = M.damage_coeff[RED_DAMAGE]
	if(original_armor > 0)
		M.damage_coeff[RED_DAMAGE] = original_armor + 0.2

/datum/status_effect/rendRedArmor/on_remove()
	. = ..()
	var/mob/living/simple_animal/M = owner
	if(M.damage_coeff[RED_DAMAGE] == original_armor + 0.2)
		M.damage_coeff[RED_DAMAGE] = original_armor

