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

