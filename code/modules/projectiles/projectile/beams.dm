/obj/projectile/beam
	name = "laser"
	icon_state = "laser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 20
	damage_type = BLACK_DAMAGE
	hitsound = 'sound/weapons/sear.ogg'
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'
	eyeblur = 0
	impact_effect_type = /obj/effect/temp_visual/impact_effect/red_laser
	light_system = MOVABLE_LIGHT
	light_range = 1
	light_power = 1
	light_color = COLOR_SOFT_RED
	ricochets_max = 50	//Honk!
	ricochet_chance = 80
	reflectable = REFLECT_NORMAL
	wound_bonus = -20
	bare_wound_bonus = -10


/obj/projectile/beam/laser
	tracer_type = /obj/effect/projectile/tracer/laser
	muzzle_type = /obj/effect/projectile/muzzle/laser
	impact_type = /obj/effect/projectile/impact/laser
	damage = 12
	wound_bonus = -100
	bare_wound_bonus = -100

/obj/projectile/beam/laser/prehit_pierce(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if("rabbit" in L.faction) // RABBIT
			return PROJECTILE_PIERCE_PHASE
	return ..()

/obj/projectile/beam/laser/red
	damage_type = RED_DAMAGE
	light_color = COLOR_RED

/obj/projectile/beam/laser/white
	damage_type = WHITE_DAMAGE
	light_color = COLOR_WHITE
	icon_state = "whitelaser"
	impact_effect_type = /obj/effect/temp_visual/impact_effect/white_laser

/obj/projectile/beam/laser/black
	damage_type = BLACK_DAMAGE
	light_color = COLOR_PURPLE
	icon_state = "purplelaser"
	impact_effect_type = /obj/effect/temp_visual/impact_effect/purple_laser

/obj/projectile/beam/laser/pale
	damage_type = PALE_DAMAGE
	light_color = COLOR_PALE_BLUE_GRAY
	icon_state = "omnilaser"
	impact_effect_type = /obj/effect/temp_visual/impact_effect/blue_laser

//overclocked laser, does a bit more damage but has much higher wound power
/obj/projectile/beam/laser/hellfire
	name = "hellfire laser"
	wound_bonus = 0
	damage = 25
	speed = 0.6 // higher power = faster, that's how light works right

/obj/projectile/beam/laser/hellfire/Initialize()
	. = ..()
	transform *= 2

/obj/projectile/beam/laser/heavylaser
	name = "heavy laser"
	icon_state = "heavylaser"
	damage = 100
	tracer_type = /obj/effect/projectile/tracer/heavy_laser
	muzzle_type = /obj/effect/projectile/muzzle/heavy_laser
	impact_type = /obj/effect/projectile/impact/heavy_laser

/obj/projectile/beam/laser/heavylaser/red
	damage_type = RED_DAMAGE
	light_color = COLOR_RED

/obj/projectile/beam/laser/heavylaser/white
	damage_type = WHITE_DAMAGE
	light_color = COLOR_WHITE
	icon_state = "whiteheavylaser"
	impact_effect_type = /obj/effect/temp_visual/impact_effect/white_laser

/obj/projectile/beam/laser/heavylaser/black
	damage_type = BLACK_DAMAGE
	light_color = COLOR_PURPLE
	icon_state = "purpleheavylaser"
	impact_effect_type = /obj/effect/temp_visual/impact_effect/purple_laser

/obj/projectile/beam/laser/heavylaser/pale
	damage = 35
	damage_type = PALE_DAMAGE
	light_color = COLOR_PALE_BLUE_GRAY
	icon_state = "blueheavylaser"
	impact_effect_type = /obj/effect/temp_visual/impact_effect/blue_laser

/obj/projectile/beam/weak
	damage = 10

/obj/projectile/beam/weak/penetrator
	armour_penetration = 50

/obj/projectile/beam/practice
	name = "practice laser"
	damage = 0
	nodamage = TRUE

/obj/projectile/beam/scatter
	name = "laser pellet"
	icon_state = "scatterlaser"
	damage = 5

/obj/projectile/beam/xray
	name = "\improper X-ray beam"
	icon_state = "xray"
	damage = 15
	irradiate = 300
	range = 15
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE | PASSCLOSEDTURF | PASSMACHINE | PASSSTRUCTURE

	impact_effect_type = /obj/effect/temp_visual/impact_effect/green_laser
	light_color = LIGHT_COLOR_GREEN
	tracer_type = /obj/effect/projectile/tracer/xray
	muzzle_type = /obj/effect/projectile/muzzle/xray
	impact_type = /obj/effect/projectile/impact/xray

/obj/projectile/beam/disabler
	name = "disabler beam"
	icon_state = "omnilaser"
	damage = 30
	damage_type = WHITE_DAMAGE
	hitsound = 'sound/weapons/tap.ogg'
	eyeblur = 0
	impact_effect_type = /obj/effect/temp_visual/impact_effect/blue_laser
	light_color = LIGHT_COLOR_BLUE
	tracer_type = /obj/effect/projectile/tracer/disabler
	muzzle_type = /obj/effect/projectile/muzzle/disabler
	impact_type = /obj/effect/projectile/impact/disabler

/obj/projectile/beam/pulse
	name = "pulse"
	icon_state = "u_laser"
	damage = 50
	impact_effect_type = /obj/effect/temp_visual/impact_effect/blue_laser
	light_color = LIGHT_COLOR_BLUE
	tracer_type = /obj/effect/projectile/tracer/pulse
	muzzle_type = /obj/effect/projectile/muzzle/pulse
	impact_type = /obj/effect/projectile/impact/pulse
	wound_bonus = 10

/obj/projectile/beam/pulse/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if (!QDELETED(target) && (isturf(target) || istype(target, /obj/structure/)))
		if(isobj(target))
			SSexplosions.med_mov_atom += target
		else
			SSexplosions.medturf += target

/obj/projectile/beam/pulse/shotgun
	damage = 30

/obj/projectile/beam/pulse/heavy
	name = "heavy pulse laser"
	icon_state = "pulse1_bl"
	var/life = 20

/obj/projectile/beam/pulse/heavy/on_hit(atom/target, blocked = FALSE)
	life -= 10
	if(life > 0)
		. = BULLET_ACT_FORCE_PIERCE
	..()

/obj/projectile/beam/emitter
	name = "emitter beam"
	icon_state = "emitter"
	damage = 30
	impact_effect_type = /obj/effect/temp_visual/impact_effect/green_laser
	light_color = LIGHT_COLOR_GREEN
	wound_bonus = -40
	bare_wound_bonus = 70

/obj/projectile/beam/emitter/singularity_pull()
	return //don't want the emitters to miss

/obj/projectile/beam/emitter/hitscan
	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/muzzle/laser/emitter
	tracer_type = /obj/effect/projectile/tracer/laser/emitter
	impact_type = /obj/effect/projectile/impact/laser/emitter
	impact_effect_type = null
	hitscan_light_intensity = 3
	hitscan_light_range = 0.75
	hitscan_light_color_override = COLOR_LIME
	muzzle_flash_intensity = 6
	muzzle_flash_range = 2
	muzzle_flash_color_override = COLOR_LIME
	impact_light_intensity = 7
	impact_light_range = 2.5
	impact_light_color_override = COLOR_LIME

/obj/projectile/beam/lasertag
	name = "laser tag beam"
	icon_state = "omnilaser"
	hitsound = null
	damage = 0
	damage_type = STAMINA
	var/suit_types = list(/obj/item/clothing/suit/redtag, /obj/item/clothing/suit/bluetag)
	impact_effect_type = /obj/effect/temp_visual/impact_effect/blue_laser
	light_color = LIGHT_COLOR_BLUE

/obj/projectile/beam/lasertag/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit))
			if(M.wear_suit.type in suit_types)
				M.adjustStaminaLoss(34)

/obj/projectile/beam/lasertag/redtag
	icon_state = "laser"
	suit_types = list(/obj/item/clothing/suit/bluetag)
	impact_effect_type = /obj/effect/temp_visual/impact_effect/red_laser
	light_color = COLOR_SOFT_RED
	tracer_type = /obj/effect/projectile/tracer/laser
	muzzle_type = /obj/effect/projectile/muzzle/laser
	impact_type = /obj/effect/projectile/impact/laser

/obj/projectile/beam/lasertag/redtag/hitscan
	hitscan = TRUE

/obj/projectile/beam/lasertag/bluetag
	icon_state = "bluelaser"
	suit_types = list(/obj/item/clothing/suit/redtag)
	tracer_type = /obj/effect/projectile/tracer/laser/blue
	muzzle_type = /obj/effect/projectile/muzzle/laser/blue
	impact_type = /obj/effect/projectile/impact/laser/blue

/obj/projectile/beam/lasertag/bluetag/hitscan
	hitscan = TRUE

/obj/projectile/beam/instakill
	name = "instagib laser"
	icon_state = "purple_laser"
	damage = 200
	damage_type = PALE_DAMAGE
	impact_effect_type = /obj/effect/temp_visual/impact_effect/purple_laser
	light_color = LIGHT_COLOR_PURPLE

/obj/projectile/beam/instakill/blue
	icon_state = "blue_laser"
	impact_effect_type = /obj/effect/temp_visual/impact_effect/blue_laser
	light_color = LIGHT_COLOR_BLUE

/obj/projectile/beam/instakill/red
	icon_state = "red_laser"
	impact_effect_type = /obj/effect/temp_visual/impact_effect/red_laser
	light_color = COLOR_SOFT_RED

/obj/projectile/beam/instakill/on_hit(atom/target)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.visible_message(span_danger("[M] explodes into a shower of gibs!"))
		M.gib()

//a shrink ray that shrinks stuff, which grows back after a short while.
/obj/projectile/beam/shrink
	name = "shrink ray"
	icon_state = "blue_laser"
	hitsound = 'sound/weapons/shrink_hit.ogg'
	damage = 0
	damage_type = STAMINA
	impact_effect_type = /obj/effect/temp_visual/impact_effect/shrink
	light_color = LIGHT_COLOR_BLUE
	var/shrink_time = 90

/obj/projectile/beam/shrink/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(isopenturf(target) || istype(target, /turf/closed/indestructible))//shrunk floors wouldnt do anything except look weird, i-walls shouldn't be bypassable
		return
	target.AddComponent(/datum/component/shrink, shrink_time)

/obj/projectile/beam/fairy
	name = "fairy"
	icon_state = "fairy"
	damage = 50
	damage_type = BLACK_DAMAGE
	hit_stunned_targets = TRUE
	white_healing = FALSE
	projectile_piercing = PASSMOB
	projectile_phasing = (ALL & (~PASSMOB) & (~PASSCLOSEDTURF))

	light_color = LIGHT_COLOR_YELLOW
	beam_type = list("fairy", 'icons/effects/beam.dmi')
	hitscan = TRUE
	hitscan_light_intensity = 2
	hitscan_light_range = 1
	hitscan_light_color_override = LIGHT_COLOR_YELLOW
	muzzle_flash_intensity = 3
	muzzle_flash_range = 2
	muzzle_flash_color_override = LIGHT_COLOR_YELLOW
	impact_light_intensity = 4
	impact_light_range = 3
	impact_light_color_override = LIGHT_COLOR_YELLOW

/obj/projectile/beam/nobody
	name = "whip"
	icon_state = "nobody"
	damage = 30
	hitsound = 'sound/weapons/slash.ogg'
	hitsound_wall = 'sound/weapons/slash.ogg'
	damage_type = BLACK_DAMAGE
	hit_stunned_targets = TRUE
	white_healing = FALSE
	projectile_piercing = PASSMOB
	projectile_phasing = (ALL & (~PASSMOB) & (~PASSCLOSEDTURF))
	hitscan = TRUE
	tracer_type = /obj/effect/projectile/tracer/laser/nobody
	muzzle_type = /obj/effect/projectile/tracer/laser/nobody
	impact_type = /obj/effect/projectile/impact/laser/nobody

/obj/effect/projectile/tracer/laser/nobody
	name = "whip tracer"
	icon_state = "nobody"

/obj/effect/projectile/impact/laser/nobody
	name = "whip impact"
	icon_state = "nobody"

/obj/projectile/beam/oberon
	name = "whip"
	icon_state = "nobody"
	damage = 15
	hitsound = 'sound/weapons/slash.ogg'
	hitsound_wall = 'sound/weapons/slash.ogg'
	damage_type = BLACK_DAMAGE
	hit_stunned_targets = TRUE
	white_healing = FALSE
	projectile_piercing = PASSMOB
	projectile_phasing = (ALL & (~PASSMOB) & (~PASSCLOSEDTURF))
	hitscan = TRUE
	tracer_type = /obj/effect/projectile/tracer/laser/nobody
	muzzle_type = /obj/effect/projectile/tracer/laser/nobody
	impact_type = /obj/effect/projectile/impact/laser/nobody

/obj/projectile/beam/oberon/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.apply_damage(15, RED_DAMAGE, null, M.run_armor_check(null, RED_DAMAGE), spread_damage = TRUE)

/obj/projectile/beam/nobody_friendly
	name = "whip"
	icon_state = "nobody"
	damage = 30
	hitsound = 'sound/weapons/slash.ogg'
	hitsound_wall = 'sound/weapons/slash.ogg'
	damage_type = BLACK_DAMAGE
	hit_stunned_targets = TRUE
	white_healing = FALSE
	hitscan = TRUE
	tracer_type = /obj/effect/projectile/tracer/laser/nobody
	muzzle_type = /obj/effect/projectile/tracer/laser/nobody
	impact_type = /obj/effect/projectile/impact/laser/nobody
