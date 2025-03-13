/mob/living/simple_animal/hostile/ordeal/dragonskull_corrosion
	name = "Dragon Wizard"
	desc = "A clerk of Lobotomy Corporation that has somehow been corrupted by an abnormality."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "dskull_corrosion"
	icon_living = "dskull_corrosion"
	icon_dead = "dskull_corrosion"
	faction = list("gold_ordeal")
	maxHealth = 200
	health = 200
	melee_damage_type = WHITE_DAMAGE
	melee_damage_lower = 7
	melee_damage_upper = 14
	attack_verb_continuous = "scratches"
	attack_verb_simple = "scratch"
	attack_sound = 'sound/abnormalities/doomsdaycalendar/Doomsday_Slash.ogg'
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	butcher_results = list(/obj/item/stack/sheet/mineral/wood = 5)

/mob/living/simple_animal/hostile/ordeal/dragonskull_corrosion/death()
	playsound(src, 'sound/abnormalities/faelantern/faelantern_breach.ogg', 100)
	color = rgb(145,116,60)
	desc = "A wooden statue of a clerk corroded by [p_their()] E.G.O gear."
	..()

/mob/living/simple_animal/hostile/ordeal/dragonskull_corrosion/AttackingTarget(atom/attacked_target)
	. = ..()
	if(!ishuman(attacked_target))
		return
	var/mob/living/carbon/human/H = attacked_target
	if(H.sanity_lost)
		playsound(get_turf(H), 'sound/abnormalities/faelantern/faelantern_breach.ogg', 200, 1)
		H.petrify(480, list(rgb(145,116,60)), "A distorted and screaming wooden statue.")

/mob/living/simple_animal/hostile/ordeal/tsa_corrosion
	name = "Creek Transporation Agent"
	desc = "A level 2 agent of the central command team that has somehow been corrupted by an abnormality."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "tsa_corrosion"
	icon_living = "tsa_corrosion"
	del_on_death = TRUE
	faction = list("gold_ordeal")
	maxHealth = 600
	health = 600
	ranged = TRUE
	ranged_cooldown_time = 5 SECONDS
	rapid = 50
	rapid_fire_delay = 0.4
	projectilesound = 'sound/weapons/gun/smg/shot.ogg'
	casingtype = /obj/item/ammo_casing/caseless/bigspread
	melee_damage_type = RED_DAMAGE
	melee_damage_lower = 10
	melee_damage_upper = 15
	attack_verb_continuous = "batters"
	attack_verb_simple = "batter"
	attack_sound = 'sound/weapons/fixer/generic/gen1.ogg'
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1, BLACK_DAMAGE = 0.6, PALE_DAMAGE = 0.6)
	butcher_results = list(/obj/item/food/meat/slab/corroded = 1)

//Projectiles
/obj/item/ammo_casing/caseless/bigspread
	name = "assorted casing"
	desc = "a assorted casing"
	projectile_type = /obj/projectile/bigspread
	pellets = 1
	variance = 360
	randomspread = 1

/obj/projectile/bigspread
	name = "assorted bullet"
	desc = "a hodgepodge of live, confiscated rounds."
	damage_type = RED_DAMAGE
	damage = 2
