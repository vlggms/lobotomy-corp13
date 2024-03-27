/obj/projectile/ego_bullet/ego_correctional
	name = "correctional"
	damage = 10
	damage_type = BLACK_DAMAGE

/obj/projectile/ego_bullet/ego_hornet
	name = "hornet"
	damage = 29
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_hatred
	name = "magic beam"
	icon_state = "qoh1"
	damage_type = BLACK_DAMAGE
	damage = 50
	spread = 10

/obj/projectile/ego_bullet/ego_hatred/on_hit(atom/target, blocked = FALSE)
	if(ishuman(target) && isliving(firer))
		var/mob/living/carbon/human/H = target
		var/mob/living/user = firer
		if(firer==target)
			return BULLET_ACT_BLOCK
		if(user.faction_check_mob(H)) // Our faction
			if(H.is_working)
				H.visible_message("<span class='warning'>[src] vanishes on contact with [H]... but nothing happens!</span>")
				qdel(src)
				return BULLET_ACT_BLOCK
			switch(damage_type)
				if(WHITE_DAMAGE)
					H.adjustSanityLoss(-damage*0.2)
				if(BLACK_DAMAGE)
					H.adjustBruteLoss(-damage*0.1)
					H.adjustSanityLoss(-damage*0.1)
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

/obj/projectile/ego_bullet/ego_magicbullet
	name = "magic bullet"
	icon_state = "magic_bullet"
	damage = 80
	speed = 0.1
	damage_type = BLACK_DAMAGE
	projectile_piercing = PASSMOB
	range = 18 // Don't want people shooting it through the entire facility
	hit_nondense_targets = TRUE

/obj/projectile/ego_bullet/ego_solemnlament
	name = "solemn lament"
	icon_state = "whitefly"
	damage = 18
	speed = 0.35
	damage_type = WHITE_DAMAGE

/obj/projectile/ego_bullet/ego_solemnvow
	name = "solemn vow"
	icon_state = "blackfly"
	damage = 18
	speed = 0.35
	damage_type = BLACK_DAMAGE

//Smartgun
/obj/projectile/ego_bullet/ego_loyalty
	name = "loyalty"
	icon_state = "loyalty"
	damage = 4
	speed = 0.2
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_loyalty/iff
	name = "loyalty IFF"
	damage = 3
	nodamage = TRUE	//Damage is calculated later
	projectile_piercing = PASSMOB

/obj/projectile/ego_bullet/ego_loyalty/iff/on_hit(atom/target, blocked = FALSE)
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
	damage = 18
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_ecstasy
	name = "ecstasy"
	icon_state = "ecstasy"
	damage_type = WHITE_DAMAGE
	damage = 7
	speed = 1.3
	range = 6

/obj/projectile/ego_bullet/ego_ecstasy/Initialize()
	. = ..()
	color = pick(COLOR_RED, COLOR_YELLOW, COLOR_LIME, COLOR_CYAN, COLOR_MAGENTA, COLOR_ORANGE)

//Smartpistol
/obj/projectile/ego_bullet/ego_praetorian
	name = "praetorian"
	icon_state = "loyalty"
	damage = 3
	nodamage = TRUE	//Damage is calculated later
	damage_type = RED_DAMAGE
	projectile_piercing = PASSMOB
	homing = TRUE
	homing_turn_speed = 30		//Angle per tick.
	var/homing_range = 9

/obj/projectile/ego_bullet/ego_praetorian/on_hit(atom/target, blocked = FALSE)
	if(!ishuman(target))
		nodamage = FALSE
	else
		return
	..()
	if(!ishuman(target))
		qdel(src)

/obj/projectile/ego_bullet/ego_praetorian/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(fireback)), 3)

/obj/projectile/ego_bullet/ego_praetorian/proc/fireback()
	var/list/targetslist = list()
	for(var/mob/living/L in range(homing_range, src))
		if(ishuman(L) || isbot(L))
			continue
		if(L.stat == DEAD)
			continue
		if(L.status_flags & GODMODE)
			continue
		targetslist+=L
	if(!LAZYLEN(targetslist))
		return
	homing_target = pick(targetslist)

/obj/projectile/ego_bullet/ego_magicpistol
	name = "magic pistol"
	icon_state = "magic_bullet"
	damage = 40
	speed = 0.1
	damage_type = BLACK_DAMAGE
	projectile_piercing = PASSMOB

//tommygun
/obj/projectile/ego_bullet/ego_intention
	name = "good intentions"
	damage = 5
	speed = 0.2
	damage_type = RED_DAMAGE

//laststop
/obj/projectile/ego_bullet/ego_laststop
	name = "laststop"
	damage = 145
	damage_type = RED_DAMAGE

/obj/projectile/ego_bullet/ego_aroma
	name = "aroma"
	icon_state = "arrow_aroma"
	damage = 140
	damage_type = WHITE_DAMAGE

//Assonance, our one hitscan laser
/obj/projectile/beam/assonance
	name = "assonance"
	icon_state = "omnilaser"
	hitsound = null
	damage = 50
	damage_type = WHITE_DAMAGE
	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/muzzle/laser/white
	tracer_type = /obj/effect/projectile/tracer/laser/white
	impact_type = /obj/effect/projectile/impact/laser/white
	wound_bonus = -100
	bare_wound_bonus = -100

/obj/projectile/beam/assonance/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(pierce_hit)
		return
	if(!ishostile(target))
		return
	var/mob/living/simple_animal/hostile/H = target
	if(H.stat == DEAD || H.status_flags & GODMODE)
		return
	for(var/mob/living/carbon/human/Yin in view(7, H))
		var/obj/item/ego_weapon/discord/D = Yin.get_active_held_item()
		if(istype(D, /obj/item/ego_weapon/discord))
			if(!D.CanUseEgo(Yin))
				continue
			Yin.adjustBruteLoss(-10)
			Yin.adjustSanityLoss(-10)
			new /obj/effect/temp_visual/healing(get_turf(Yin))
			break
	return

//feather of honor
/obj/projectile/ego_bullet/ego_feather
	name = "feather"
	icon_state = "lava"
	damage = 40
	damage_type = WHITE_DAMAGE
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
	hitsound = "sound/effects/wounds/pierce1.ogg"

/obj/projectile/ego_bullet/ego_exuviae/on_hit(target)
	. = ..()
	if(isliving(target))
		var/mob/living/simple_animal/M = target
		if(!ishuman(M) && !M.has_status_effect(/datum/status_effect/rend_red))
			new /obj/effect/temp_visual/cult/sparks(get_turf(M))
			M.apply_status_effect(/datum/status_effect/rend_red)

//feather of valor
/obj/projectile/ego_bullet/ego_warring
	name = "feather of valor"
	icon_state = "arrow"
	damage = 75
	damage_type = BLACK_DAMAGE

/obj/projectile/ego_bullet/ego_warring/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/obj/item/gun/ego_gun/warring/bow = fired_from
	var/mob/living/L = target
	if(!isliving(target))
		return
	if((L.stat == DEAD) || L.status_flags & GODMODE)//if the target is dead or godmode
		return FALSE
	bow.Build_Charge()
	return

//feather of valor cont'd
/obj/projectile/ego_bullet/ego_warring2
	name = "feather of valor"
	icon_state = "lava"
	hitsound = null
	damage = 125
	damage_type = BLACK_DAMAGE
	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/muzzle/laser/warring
	tracer_type = /obj/effect/projectile/tracer/warring
	impact_type = /obj/effect/projectile/impact/laser/warring

/obj/effect/projectile/muzzle/laser/warring
	name = "lightning flash"
	icon_state = "muzzle_warring"
/obj/effect/projectile/tracer/warring
	name = "lightning beam"
	icon_state = "warring"
/obj/effect/projectile/impact/laser/warring
	name = "lightning impact"
	icon_state = "impact_warring"

/obj/projectile/ego_bullet/ego_warring2/on_hit(atom/target, blocked = FALSE)
	. = ..()
	var/mob/living/carbon/human/H = target
	var/mob/living/user = firer
	if(user.faction_check_mob(H))//player faction
		H.adjustSanityLoss(-damage*0.2)
		H.electrocute_act(1, src, flags = SHOCK_NOSTUN)
		H.Knockdown(50)
		return BULLET_ACT_BLOCK
	qdel(src)

/obj/projectile/ego_bullet/ego_banquet
	name = "banquet"
	icon_state = "pulse0"
	damage = 120
	damage_type = BLACK_DAMAGE


/obj/projectile/ego_bullet/ego_blind_rage
	name = "blind rage"
	icon_state = "blind_rage"
	damage = 15
	damage_type = BLACK_DAMAGE

/obj/projectile/ego_bullet/ego_blind_rage/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(!isliving(target))
		return
	var/mob/living/L = target
	L.apply_status_effect(/datum/status_effect/wrath_burning)

/obj/projectile/ego_bullet/ego_hookah
	name = "lethargy"
	icon_state = "smoke"
	damage = 2
	damage_type = PALE_DAMAGE
	speed = 2
	range = 6

/obj/projectile/ego_bullet/ego_innocence
	name = "innocence"
	icon_state = "energy"
	damage = 7 //Can dual wield, full auto
	damage_type = WHITE_DAMAGE


/obj/projectile/ego_bullet/ego_hypocrisy
	name = "hypocrisy"
	icon_state = "arrow_greyscale"
	color = "#AAFF00"
	damage = 90 //50 damage is transfered to the spawnable trap
	damage_type = RED_DAMAGE


/obj/projectile/ego_bullet/ego_bride
	name = "bride"
	icon_state = "bride"
	damage = 25
	damage_type = WHITE_DAMAGE

