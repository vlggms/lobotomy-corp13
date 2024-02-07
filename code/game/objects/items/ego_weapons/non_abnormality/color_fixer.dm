//Color fixer stuff is all Grade 1
/obj/item/ego_weapon/city/vermillion
	name = "Vermillion Cross"
	desc = "Ashes to ashes, dust to dust."
	special = "Use in hand to cut HP in half. Each kill for the next 15 seconds increases damage by 1.5x, and heals you 10%."
	icon_state = "vermillion"
	inhand_icon_state = "vermillion"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left_64x64.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right_64x64.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 90
	damtype = RED_DAMAGE

	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 120,
		PRUDENCE_ATTRIBUTE = 120,
		TEMPERANCE_ATTRIBUTE = 120,
		JUSTICE_ATTRIBUTE = 120,
	)
	var/ready = TRUE


/obj/item/ego_weapon/city/vermillion/attack_self(mob/living/carbon/human/user)
	..()
	if(!CanUseEgo(user))
		return

	if(!ready)
		return
	ready = FALSE
	to_chat(user, span_userdanger("READY."))
	force*=1.5
	user.adjustBruteLoss(user.maxHealth*0.5)
	addtimer(CALLBACK(src, PROC_REF(Return), user), 15 SECONDS)


/obj/item/ego_weapon/city/vermillion/attack(mob/living/target, mob/living/carbon/human/user)
	var/living
	if(target.stat != DEAD)
		living = TRUE
	..()
	if(target.stat == DEAD && living)
		user.adjustSanityLoss(-30)
		living = FALSE

	if(force != initial(force) && !living)
		to_chat(user, span_userdanger("ANOTHER."))
		force*=1.5
		user.adjustBruteLoss(-user.maxHealth*0.1)

/obj/item/ego_weapon/city/vermillion/proc/Return(mob/living/carbon/human/user)
	force = initial(force)
	ready = TRUE
	to_chat(user, span_notice("I AM NOT SATED."))

/obj/item/ego_weapon/mimicry/kali
	name = "True Mimicry"
	desc = "What is the meaning of 'Human'? Does it matter?"
	icon = 'ModularTegustation/Teguicons/lc13_weapons.dmi'
	icon_state = "mimicry"
	inhand_icon_state = "mimisword"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left_64x64.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right_64x64.dmi'
	force = 100
	attack_speed = 1.2
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 120,
							PRUDENCE_ATTRIBUTE = 120,
							TEMPERANCE_ATTRIBUTE = 120,
							JUSTICE_ATTRIBUTE = 120
							)
