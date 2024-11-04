//has a cleave attack.
/obj/item/ego_weapon/template/axe
	name = "axe template"
	desc = "A blank axe workshop template."
	special = "Use this weapon in hand to charge a cleave attack."
	icon_state = "axetemplate"
	force = 30
	attack_speed = 1.5
	hitsound = 'sound/abnormalities/woodsman/woodsman_attack.ogg'
	attack_verb_continuous = list("attacks", "slashes", "cleaves", "slices", "cuts")
	attack_verb_simple = list("attack", "slash", "cleave", "slice", "cut")

	finishedicon = list("finishedaxe")
	finishedname = list("hand axe", "axe", "battleaxe")
	finisheddesc = "A finished axe, ready for use."

/obj/item/ego_weapon/template/axe/attack_self(mob/user)
	if(force != true_force)
		return

	if(do_after(user, attack_speed*10))
		force *= 1.2
		to_chat(user, span_info("You charge a cleave, and your next attack will deal bonus damage."))
