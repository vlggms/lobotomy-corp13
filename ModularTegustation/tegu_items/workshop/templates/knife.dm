//Has a dodge ability
/obj/item/ego_weapon/template/knife
	name = "knife template"
	desc = "A blank knife workshop template."
	special = "Use this weapon in hand to perform a dodgeroll."
	icon_state = "knifetemplate"
	force = 18
	attack_speed = 0.7
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")

	finishedicon = list("finishedknife","finishedstiletto")
	finishedname = list("dagger", "knife", "mail breaker")
	finisheddesc = "A finished knife, ready for use."
	var/dodgelanding

/obj/item/ego_weapon/template/knife/attack_self(mob/living/carbon/user)
	if(!active)
		to_chat(user, span_notice("This weapon is unfinished!"))
		return
	if(user.dir == 1)
		dodgelanding = locate(user.x, user.y + 5, user.z)
	if(user.dir == 2)
		dodgelanding = locate(user.x, user.y - 5, user.z)
	if(user.dir == 4)
		dodgelanding = locate(user.x + 5, user.y, user.z)
	if(user.dir == 8)
		dodgelanding = locate(user.x - 5, user.y, user.z)
	user.adjustStaminaLoss(10, TRUE, TRUE)
	user.throw_at(dodgelanding, 3, 2, spin = TRUE)
