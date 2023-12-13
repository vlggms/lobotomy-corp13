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
	name = "K-Corp Drone Assmebly Grenade"
	desc = "A quick and easy method of storing K-Corp drones for combat situations. It keeps its orignal programing, hopefully you're a part of K-Corp."
	icon_state = "delivery"
	spawner_type = /mob/living/simple_animal/hostile/kcorp/drone
	deliveryamt = 3
