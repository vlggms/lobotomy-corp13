//See Ncorp file
/obj/item/limit_increase/lcorp
	name = "lcorp agent limit breaker"
	icon_state = "oddity7_firewater"


//Officer limit increase
/obj/item/officerlimit_increase
	name = "officer limit breaker"
	desc = "A fluid used to increase the user's maximum potential. Use in hand to activate."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "oddity7_gween"
	var/amount = 80
	var/list/allowed_roles = list("Records Officer", "Extraction Officer")

/obj/item/officerlimit_increase/attack_self(mob/living/carbon/human/user)
	if(!(user?.mind?.assigned_role in allowed_roles))
		to_chat(user, "<span class='notice'>This is not for you.</span>")
		return
	to_chat(user, "<span class='nicegreen'>You feel like you can become even more powerful.</span>")
	user.set_attribute_limit(amount)
	qdel(src)


/obj/item/understandingbooster
	name = "abnormality scanner"
	desc = "A machine used on abnormalities to increase understanding"
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "understanding"
	slot_flags = ITEM_SLOT_POCKETS

/obj/item/understandingbooster/attack(mob/living/M, mob/user)
	if(!(istype(M, /mob/living/simple_animal/hostile/abnormality)))
		to_chat(user, "<span class='notice'>You cannot scan this.</span>")
		return
	var/mob/living/simple_animal/hostile/abnormality/A = M
	to_chat(user, "<span class='notice'>You begin the scan.</span>")
	if(!do_after(user, 15 SECONDS, src))
		return
	A.datum_reference.understanding = min(A.datum_reference.understanding + 10, 100)
