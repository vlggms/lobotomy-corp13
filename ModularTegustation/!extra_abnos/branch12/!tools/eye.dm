/obj/structure/toolabnormality/eye
	name = "eye for an eye"
	desc = "A set of scales on a table. One is rusted iron, and the other is polished gold."
	icon = 'ModularTegustation/Teguicons/branch12/32x32.dmi'
	icon_state = "eye"
	anchored = FALSE
	drag_slowdown = 1.5
	var/list/users = list()
	var/list/double_users = list()

/obj/structure/toolabnormality/eye/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(reset)), 10 MINUTES)

/obj/structure/toolabnormality/eye/proc/reset()
	addtimer(CALLBACK(src, PROC_REF(reset)), 10 MINUTES)
	users = list()
	double_users = list()

	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		to_chat(L, span_danger("The scales have been reset."))

/obj/structure/toolabnormality/eye/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(!do_after(user, 2))
		return

	to_chat(user, span_notice("You tip the scales in your favor."))
	//check your users, make them mad
	if(user in users)
		double_users+=user
		user.adjustSanityLoss(999)
		user.adjustBruteLoss(-user.maxHealth)
		return

	//check your users, make them dead
	if(user in double_users)
		user.adjustBruteLoss(999)
		return

	//okay now let's change HP and SP
	users+=user
	//store current sanity
	var/stored_sanity = user.sanityhealth
	var/stored_health = user.health

	//heal to full
	user.adjustBruteLoss(-user.maxHealth)
	user.adjustSanityLoss(-user.maxSanity)

	//Invert Sanity
	stored_sanity = (stored_sanity-user.maxSanity)*-1

	//invert HP
	stored_health = (stored_health-user.maxHealth)*-1

	//Deal inverted Sanity damage to health
	user.adjustBruteLoss(stored_sanity)

	//Deal inverted Health damage to sanity
	user.adjustSanityLoss(stored_health)
