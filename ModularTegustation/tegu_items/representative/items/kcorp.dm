//Kcorp Syringes
/obj/item/ksyringe
	name = "k-corp nanomachine ampule"
	desc = "A syringe of kcorp healing nanobots."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "kcorp_syringe"
	slot_flags = ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL

/obj/item/ksyringe/attack_self(mob/living/user)
	..()
	to_chat(user, span_notice("You inject the syringe and instantly feel better."))
	user.adjustBruteLoss(-40)
	qdel(src)

/obj/item/krevive
	name = "k-corp nanomachine ampule"
	desc = "A syringe of kcorp healing nanobots. This one revives any fallen bodies."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "kcorp_syringe2"
	slot_flags = ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL

/obj/item/krevive/attack(mob/living/M, mob/user)
	to_chat(user, span_notice("You inject the syringe."))
	if(M.revive(full_heal = TRUE, admin_revive = TRUE))
		M.revive(full_heal = TRUE, admin_revive = TRUE)
		M.grab_ghost(force = TRUE) // even suicides
		to_chat(M, span_notice("You rise with a start, you're alive!!!"))
	qdel(src)

/obj/item/kcrit
	name = "k-corp adrenaline shot"
	desc = "A syringe of kcorp adrenaline. Increases crit threshold."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "kcorp_syringe3"
	slot_flags = ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL

// This injector isnt in K-corp research anymore. Only used in R-corp
/obj/item/kcrit/attack_self(mob/living/user)
	..()
	to_chat(user, span_notice("You inject the syringe and instantly feel better."))
	user.hardcrit_threshold+=30
	user.crit_threshold+=30
	qdel(src)

/obj/item/khpboost
	name = "k-corp health booster"
	desc = "A syringe of experimental kcorp nanobots. Increases your Max Health."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "kcorp_syringe3"
	slot_flags = ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL

/obj/item/khpboost/attack_self(mob/living/carbon/human/user)
	..()
	to_chat(user, span_notice("You inject the syringe and instantly feel stronger."))
	user.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 20)
	qdel(src)

// For Asset Reclimation
/obj/item/grenade/spawnergrenade/kcorpdrone
	name = "K-Corp Drone Assembly Grenade"
	desc = "A quick and easy method of storing K-Corp drones for combat situations. It keeps its orignal programing, hopefully you're a part of K-Corp."
	icon_state = "delivery"
	spawner_type = /mob/living/simple_animal/hostile/kcorp/drone
	deliveryamt = 3

//healing drone
/mob/living/simple_animal/hostile/khealing
	name = "K-Corporation healing drone"
	desc = "A floating bot used by K-Corp to heal it's agents."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "khealing"
	icon_living = "khealing"
	faction = list("kcorp")
	health = 500	//They're here to help
	maxHealth = 500
	melee_damage_type = STAMINA
	damage_coeff = list(RED_DAMAGE = 0.4, WHITE_DAMAGE = 0.7, BLACK_DAMAGE = 1.2, PALE_DAMAGE = 1)
	melee_damage_lower = 14
	melee_damage_upper = 18
	robust_searching = TRUE
	stat_attack = HARD_CRIT
	del_on_death = TRUE
	attack_verb_continuous = "jabs"
	attack_verb_simple = "jabs"
	attack_sound = 'sound/weapons/bite.ogg'
	can_patrol = TRUE
	is_flying_animal = TRUE


/mob/living/simple_animal/hostile/khealing/CanAttack(atom/the_target)
	if(!ishuman(the_target))
		return FALSE
	var/mob/living/H = the_target
	if(H.health != H.maxHealth)
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/khealing/AttackingTarget(atom/attacked_target)
	..()
	if(!ishuman(attacked_target))
		return
	var/mob/living/H = attacked_target
	H.adjustBruteLoss(-20)


// For Asset Reclimation
/obj/item/grenade/spawnergrenade/khealing
	name = "K-Corp Drone Assmebly Grenade"
	desc = "A quick and easy method of storing K-Corp drones for combat situations. It keeps its orignal programing, hopefully you're a part of K-Corp."
	icon_state = "delivery"
	spawner_type = /mob/living/simple_animal/hostile/khealing
	deliveryamt = 3


