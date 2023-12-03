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
	desc = "A syringe of kcorp healing nanobots."
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

/obj/item/kcrit/attack_self(mob/living/user)
	..()
	to_chat(user, span_notice("You inject the syringe and instantly feel better."))
	user.hardcrit_threshold+=30
	user.crit_threshold+=30
	qdel(src)
