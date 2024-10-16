/obj/item/organ/cyberimp/arm/chainsword
	name = "chainsword implant"
	desc = "A chainsword that can be retracted into your arm.."
	contents = newlist(/obj/item/ego_weapon/city/handchainsword)
	syndicate_implant = TRUE
	//Doesn't need a nerf, the gun's kinda shit lmao

/obj/item/organ/cyberimp/arm/chainsword/l
	zone = BODY_ZONE_L_ARM


/obj/item/ego_weapon/city/handchainsword
	name = "chainsword"
	desc = "This weapon attacks many times, grafted to your hand."
	icon = 'ModularTegustation/tegu_items/prosthetics/icons/generic.dmi'
	icon_state = "hand_chainsword"
	hitsound = 'sound/weapons/bladeslice.ogg'
	flags_1 = CONDUCT_1
	force = 15
	attack_speed = 2
	damtype = RED_DAMAGE
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")


/obj/item/ego_weapon/city/handchainsword/equipped(mob/user, slot, initial)
	. = ..()
	if(slot != ITEM_SLOT_HANDS)
		return
	var/side = user.get_held_index_of_item(src)

	if(side == LEFT_HANDS)
		transform = null
	else
		transform = matrix(-1, 0, 0, 0, 1, 0)
	//little bit of stam loss
	var/mob/living/carbon/human/H = user
	H.adjustStaminaLoss(H.maxHealth*0.5, TRUE, TRUE)


/obj/item/ego_weapon/city/handchainsword/attack(mob/living/target, mob/living/user)
	if(!..())
		return
	user.Immobilize(15)
	for(var/i = 1 to 3)
		sleep(2)
		if(target in view(reach,user))
			playsound(loc, hitsound, get_clamped_volume(), TRUE, extrarange = stealthy_audio ? SILENCED_SOUND_EXTRARANGE : -1, falloff_distance = 0)
			user.do_attack_animation(target)
			target.attacked_by(src, user)
			log_combat(user, target, pick(attack_verb_continuous), src.name, "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(damtype)])")

