// Advanced mulligan. Basically, a device that acts just like changeling's sting and transformation ability.
// Only one use to mutate, but can be reused unlimited amount of times to store another DNA before transformation.

/obj/item/adv_mulligan
	name = "advanced mulligan"
	desc = "Toxin that permanently changes your DNA into the one of last injected person."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "dnainjector0"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	var/used = FALSE
	var/mob/living/carbon/human/stored

/obj/item/adv_mulligan/attack(mob/living/carbon/human/M, mob/living/carbon/human/user)
	return //Stealth

/obj/item/adv_mulligan/afterattack(atom/movable/AM, mob/living/carbon/human/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(!istype(user))
		return
	if(used)
		to_chat(user, "<span class='warning'>[src] has been already used, you can't activate it again!</span>")
		return
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(user.real_name != H.dna.real_name)
			stored = H
			to_chat(user, "<span class='notice'>You stealthly stab [H.name] with [src].</span>")
			desc = "Toxin that permanently changes your DNA into the one of last injected person. It has DNA of <span class='blue'>[stored.dna.real_name]</span> inside."
			icon_state = "dnainjector"
		else
			if(stored)
				mutate(user)
			else
				to_chat(user, "<span class='warning'>You can't stab yourself with [src]!</span>")

/obj/item/adv_mulligan/attack_self(mob/living/carbon/user)
	mutate(user)

/obj/item/adv_mulligan/proc/mutate(mob/living/carbon/user)
	if(used)
		to_chat(user, "<span class='warning'>[src] has been already used, you can't activate it again!</span>")
		return
	if(!used)
		if(stored)
			user.visible_message("<span class='warning'>[user.name] shivers in pain and soon transform into [stored.dna.real_name]!</span>", \
			"<span class='notice'>You inject yourself with [src] and suddenly become a copy of [stored.dna.real_name].</span>")

			user.real_name = stored.real_name
			stored.dna.transfer_identity(user, transfer_SE=1)
			user.updateappearance(mutcolor_update=1)
			user.domutcheck()
			used = TRUE

			icon_state = "dnainjector0"
			desc = "Toxin that permanently changes your DNA into the one of last injected person. This one is used up."

		else
			to_chat(user, "<span class='warning'>[src] doesn't have any DNA loaded in it!</span>")

// A "nuke op" kit for Gorlex Infiltrators, available for 15 TC.
/obj/item/storage/backpack/duffelbag/syndie/flukeop/PopulateContents()
	new /obj/item/clothing/suit/space/hardsuit/syndi(src) //8 TC
	new /obj/item/storage/box/syndie_kit/imp_microbomb(src) //2 TC
	new /obj/item/clothing/glasses/night(src)
	new /obj/item/radio/headset/syndicate/alt(src)
	new /obj/item/clothing/gloves/combat(src) //1 TC?
	new /obj/item/gun/ballistic/automatic/pistol(src) //7 TC

// Advanced hypno-flash. For psychologists.
/obj/item/assembly/flash/hypnotic/adv
	desc = "A modified flash device, used to beam preprogrammed orders directly into the target's mind."
	light_color = COLOR_RED_LIGHT
	var/hypno_cooldown = 59 SECONDS // Big damn cooldown
	var/hypno_cooldown_current
	var/hypno_message // User can change it by alt-clicking the flash.

/obj/item/assembly/flash/hypnotic/adv/flash_carbon(mob/living/carbon/M, mob/user, power = 15, targeted = TRUE, generic_message = FALSE)
	if(!istype(M))
		return
	if(user)
		log_combat(user, M, "[targeted? "hypno-flashed(targeted)" : "hypno-flashed(AOE)"]", src)
	else //caused by emp/remote signal
		M.log_message("was [targeted? "hypno-flashed(targeted)" : "hypno-flashed(AOE)"]",LOG_ATTACK)
	if(generic_message && M != user)
		to_chat(M, "<span class='notice'>[src] emits a red, sharp light!</span>")
	if(targeted)
		if(M.flash_act(1, 1))
			if(user)
				user.visible_message("<span class='danger'>[user] blinds [M] with the flash!</span>", "<span class='danger'>You hypno-flash [M]!</span>")

			if(hypno_cooldown_current > world.time) // Still on cooldown
				to_chat(M, "<span class='hypnophrase'>The light makes you feel oddly relaxed...</span>")
				M.add_confusion(min(M.get_confusion() + 10, 20))
				M.dizziness += min(M.dizziness + 10, 20)
				M.drowsyness += min(M.drowsyness + 10, 20)
				M.apply_status_effect(STATUS_EFFECT_PACIFY, 100)
			else
				if(!hypno_message) // Aka default settings
					hypno_message = "You are a secret agent, working for [user.real_name]. \
					You must do anything they ask of you, and you must never attempt to harm them, nor allow harm to come to them."
				hypno_cooldown_current = world.time + hypno_cooldown
				M.apply_status_effect(STATUS_EFFECT_PACIFY, 30)
				M.cure_trauma_type(/datum/brain_trauma/hypnosis, TRAUMA_RESILIENCE_SURGERY) //clear previous hypnosis
				addtimer(CALLBACK(M, /mob/living/carbon.proc/gain_trauma, /datum/brain_trauma/hypnosis, TRAUMA_RESILIENCE_SURGERY, hypno_message), 10)
				addtimer(CALLBACK(M, /mob/living.proc/Stun, 60, TRUE, TRUE), 15)


		else if(user)
			user.visible_message("<span class='warning'>[user] fails to blind [M] with the flash!</span>", "<span class='warning'>You fail to hypno-flash [M]!</span>")
		else
			to_chat(M, "<span class='danger'>[src] fails to blind you!</span>")

	else if(M.flash_act())
		to_chat(M, "<span class='notice'>Such a pretty light...</span>")
		M.add_confusion(min(M.get_confusion() + 4, 20))
		M.dizziness += min(M.dizziness + 4, 20)
		M.drowsyness += min(M.drowsyness + 4, 20)
		M.apply_status_effect(STATUS_EFFECT_PACIFY, 40)

/obj/item/assembly/flash/hypnotic/adv/AltClick(mob/user)
	hypno_message = stripped_input(user, "What order will be given to hypnotised people?", \
	"You are a secret agent, working for [user.real_name]. You must do anything they ask of you, \
	and you must never attempt to harm them, nor allow harm to come to them.", "Hypnosis message")
	to_chat(user, "<span class='notice'>New message is: [hypno_message]</span>")

// Virology bottles
/obj/item/reagent_containers/glass/bottle/accelerant_ts
	name = "Fast transmitability virus accelerant"
	desc = "A small bottle containing TCS-TSA strain."
	spawned_disease = /datum/disease/advance/adv_ts

/obj/item/reagent_containers/glass/bottle/accelerant_mp
	name = "Multi-purpose virus accelerant"
	desc = "A small bottle containing TCS-MPA strain."
	spawned_disease = /datum/disease/advance/adv_mp

/obj/item/reagent_containers/glass/bottle/accelerant_sr
	name = "Resistant stealth virus accelerant"
	desc = "A small bottle containing TCS-SRA strain."
	spawned_disease = /datum/disease/advance/adv_sr

/obj/item/reagent_containers/glass/bottle/fake_oxygen
	name = "Self-Respiratory Detonator bottle"
	desc = "A small bottle containing rare disease that tries to disguise as self-respiration strain."
	spawned_disease = /datum/disease/advance/fake_oxygen

// Syndi-kit
/obj/item/storage/box/syndie_kit/virology
	name = "virology kit"

/obj/item/storage/box/syndie_kit/virology/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 10

/obj/item/storage/box/syndie_kit/virology/PopulateContents()
	new /obj/item/reagent_containers/glass/bottle/accelerant_ts(src)
	new /obj/item/reagent_containers/glass/bottle/accelerant_mp(src)
	new /obj/item/reagent_containers/glass/bottle/accelerant_sr(src)
	new /obj/item/reagent_containers/glass/bottle/fake_oxygen(src)
	new /obj/item/reagent_containers/glass/bottle/formaldehyde(src)
	new /obj/item/reagent_containers/glass/bottle/synaptizine(src)
	new /obj/item/reagent_containers/glass/beaker/large(src)
	new /obj/item/reagent_containers/glass/beaker/large(src)
	new /obj/item/reagent_containers/dropper(src)
	new /obj/item/reagent_containers/syringe(src)

/obj/item/melee/sabre/breadstick
	name = "Breadstick"
	desc = "Listen never forget, when you’re here you’re family. Breadstick?"
	icon_state = "breadstick"
	icon = 'ModularTegustation/Teguicons/breadstick.dmi'
	lefthand_file = "icons/mob/inhands/misc/food_lefthand.dmi"
	righthand_file = "icons/mob/inhands/misc/food_righthand.dmi"
	inhand_icon_state = "baguette"
	force = 10

/obj/item/staff/roadsign
	name = "road sign"
	desc = "It obviously isn't supposed to be used like that, huh?"
	force = 15
	throwforce = 18
	sharpness = SHARP_EDGED
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/teguitems_hold_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/teguitems_hold_right.dmi'
	icon_state = "roadsign"
	inhand_icon_state = "roadsign"
	armour_penetration = 20
	block_chance = 20
	attack_verb_continuous = list("bludgeons", "whacks", "slices", "impales")
	attack_verb_simple = list("bludgeon", "whack", "slice", "impale")
	w_class = WEIGHT_CLASS_BULKY
	var/attack_speed_mod = 0.4

/obj/item/staff/roadsign/melee_attack_chain(mob/living/user, atom/target, params)
	..()
	if(user.mad_shaking > 0)
		user.changeNext_move(CLICK_CD_MELEE * attack_speed_mod)
	else
		user.changeNext_move(CLICK_CD_MELEE * 2)

// A kit for clown
/obj/item/storage/box/hug/mad_clown
	name = "clown's box"

/obj/item/storage/box/hug/mad_clown/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_w_class = WEIGHT_CLASS_BULKY
	STR.max_items = 3

/obj/item/storage/box/hug/mad_clown/PopulateContents()
	new /obj/item/reagent_containers/glass/bottle/accelerant_ts(src)
	new /obj/item/staff/roadsign(src)
