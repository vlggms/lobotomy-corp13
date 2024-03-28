//Cinq Association. Use in hand to backstep for 3 seconds of bonus damage.
/obj/item/ego_weapon/city/cinq
	name = "cinq association rapier"
	desc = "A long rapier."
	special = "Use this weapon in hand to hop backwards. Your next attack has 2 range, and you deal double damage for 3 seconds."
	icon_state = "cinq"
	force = 28
	damtype = RED_DAMAGE

	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/fixer/generic/nail1.ogg'
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 80,
	)
	var/ready = TRUE
	var/multiplier = 2


/obj/item/ego_weapon/city/cinq/attack_self(mob/living/carbon/human/user)
	..()
	if(!CanUseEgo(user))
		return

	if(!ready)
		return
	ready = FALSE
	to_chat(user, span_danger("Allons-y!"))
	force*=multiplier
	reach = 2
	//Dodging backwards
	var/dodgelanding
	if(user.dir == 1)
		dodgelanding = locate(user.x, user.y - 3, user.z)
	if(user.dir == 2)
		dodgelanding = locate(user.x, user.y + 3, user.z)
	if(user.dir == 4)
		dodgelanding = locate(user.x - 3, user.y, user.z)
	if(user.dir == 8)
		dodgelanding = locate(user.x + 3, user.y, user.z)
	user.adjustStaminaLoss(10, TRUE, TRUE)
	user.throw_at(dodgelanding, 3, 2, spin = TRUE)

	addtimer(CALLBACK(src, PROC_REF(Return), user), 5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(Reset), user), 15 SECONDS)


/obj/item/ego_weapon/city/cinq/attack(mob/living/target, mob/living/carbon/human/user)
	..()
	if(reach == 2)
		to_chat(user, span_userdanger("Magnifique!"))
		reach = 1
		target.Immobilize(5)
		//Now rush forwards.
		var/dodgelanding
		if(user.dir == 1)
			dodgelanding = locate(user.x, user.y + 1, user.z)
		if(user.dir == 2)
			dodgelanding = locate(user.x, user.y - 1, user.z)
		if(user.dir == 4)
			dodgelanding = locate(user.x + 1, user.y, user.z)
		if(user.dir == 8)
			dodgelanding = locate(user.x - 1, user.y, user.z)
		user.throw_at(dodgelanding, 1, 1, spin = FALSE)

/obj/item/ego_weapon/city/cinq/proc/Return(mob/living/carbon/human/user)
	force = initial(force)
	reach = 1
	to_chat(user, span_notice("A tout de souffle."))

/obj/item/ego_weapon/city/cinq/proc/Reset(mob/living/carbon/human/user)
	force = initial(force)
	reach = 1
	ready = TRUE
	to_chat(user, span_notice("Pret a nouveau."))

