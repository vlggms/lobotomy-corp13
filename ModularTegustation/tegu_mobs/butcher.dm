/mob/living/simple_animal/hostile/butcher
	name = "The Butcher"
	desc = "A delusional man, pursuing the taste of human meat."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "butcher"
	icon_living = "butcher"
	icon_dead = "syndicate_dead"
	icon_gib = "syndicate_gib"
	speak_chance = 0
	turns_per_move = 5
	speed = 0
	stat_attack = HARD_CRIT
	robust_searching = 1
	maxHealth = 150
	health = 150
	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "slashes at"
	attack_verb_simple = "slash at"
	attack_sound = 'sound/effects/wounds/pierce1.ogg'
	a_intent = INTENT_HARM
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	loot = list(/obj/effect/mob_spawn/human/corpse/butcher, /obj/item/kitchen/knife/butcher/deadly)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 0
	faction = list("hostile")
	check_friendly_fire = 1
	status_flags = CANPUSH
	del_on_death = 1
	var/obj/item/kitchen/knife/butcher/deadly/weapon

/mob/living/simple_animal/hostile/butcher/Initialize()
	. = ..()
	weapon = new(src)

/mob/living/simple_animal/hostile/butcher/AttackingTarget()
	face_atom(target)
	weapon.melee_attack_chain(src, target)
	return TRUE

/obj/item/kitchen/knife/butcher/deadly
	name = "\improper Butcher"
	desc = "A huge knife that is used to dismembering humans."
	force = 18
	throwforce = 16
	wound_bonus = 5
	bare_wound_bonus = 15
	armour_penetration = 20
	sharpness = SHARP_EDGED

/obj/effect/mob_spawn/human/corpse/butcher
	name = "butcher"
	mob_name = "The Butcher"
	mob_species = /datum/species/skeleton
	outfit = /datum/outfit/butcher

/datum/outfit/butcher
	name = "Butcher"
	mask = /obj/item/clothing/mask/animal/pig
	uniform = /obj/item/clothing/under/rank/civilian/chef
	suit = /obj/item/clothing/suit/apron/surgical
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/color/plasmaman/robot
