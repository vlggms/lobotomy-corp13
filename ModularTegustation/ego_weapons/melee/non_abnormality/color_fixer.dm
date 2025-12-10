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
	force = 45
	damtype = RED_DAMAGE

	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 120,
		PRUDENCE_ATTRIBUTE = 120,
		TEMPERANCE_ATTRIBUTE = 120,
		JUSTICE_ATTRIBUTE = 120,
	)
	/// Are we currently using our ability?
	var/using_ability = FALSE

	/// The mobs we dont want to scale damage to
	var/list/mob_blacklist = list(/mob/living/simple_animal/hostile/naked_nest_serpent_friend)


/obj/item/ego_weapon/city/vermillion/attack_self(mob/living/carbon/human/user)
	..()
	if(!CanUseEgo(user))
		return

	if(using_ability)
		return

	using_ability = TRUE
	to_chat(user, span_userdanger("READY."))
	force *= 1.5
	user.adjustBruteLoss(user.maxHealth*0.5)
	addtimer(CALLBACK(src, PROC_REF(Return), user), 15 SECONDS)


/obj/item/ego_weapon/city/vermillion/attack(mob/living/target, mob/living/carbon/human/user)
	if(target.stat == DEAD)
		return ..()

	for(var/mob/living/alive_mob in mob_blacklist)
		if(target == alive_mob)
			return ..()

	. = ..()

	if(target.stat != DEAD)
		return

	user.adjustSanityLoss(-30)

	if(!using_ability)
		return

	user.adjustBruteLoss(-user.maxHealth*0.1)
	to_chat(user, span_userdanger("ANOTHER."))
	force *= 1.5

/obj/item/ego_weapon/city/vermillion/proc/Return(mob/living/carbon/human/user)
	force = initial(force)
	using_ability = FALSE
	to_chat(user, span_notice("I AM NOT SATED."))
