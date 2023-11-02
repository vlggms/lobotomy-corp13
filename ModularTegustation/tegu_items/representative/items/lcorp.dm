//See Ncorp file
/obj/item/limit_increase/lcorp
	name = "lcorp agent limit breaker"
	icon_state = "oddity7_firewater"

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
