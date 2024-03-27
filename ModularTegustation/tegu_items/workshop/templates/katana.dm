/obj/item/ego_weapon/template/katana
	name = "katana template"
	desc = "A blank katana workshop template."
	special = "Use this weapon in hand to stun yourself to deal 2x damage for the next attack."
	icon_state = "katanatemplate"
	force = 22
	attack_speed = 1.3
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")

	finishedicon = list("finishedkatana","finishedkatanastr")
	finishedname = list("tachi", "katana", "uchigatana", "wakizashi")
	finisheddesc = "A finished katana, ready for use."
	var/ready = TRUE

/obj/item/ego_weapon/template/katana/attack_self(mob/living/carbon/human/user)
	..()
	if(!CanUseEgo(user))
		return

	if(!ready)
		return
	ready = FALSE
	user.Immobilize(attack_speed*attack_speed*10)
	to_chat(user, span_userdanger("From moonlight."))
	force*=2
	addtimer(CALLBACK(src, PROC_REF(Return), user), attack_speed*attack_speed*30)

/obj/item/ego_weapon/template/katana/attack(mob/living/target, mob/living/carbon/human/user)
	..()
	if(force != initial(force))
		to_chat(user, span_userdanger("Over the sea."))
		force = initial(force)

/obj/item/ego_weapon/template/katana/proc/Return(mob/living/carbon/human/user)
	force = initial(force)
	ready = TRUE
	to_chat(user, span_notice("Your blade is ready."))
