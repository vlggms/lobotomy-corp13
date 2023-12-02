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
		to_chat(user, span_notice("You cannot scan this."))
		return
	var/mob/living/simple_animal/hostile/abnormality/A = M
	to_chat(user, span_notice("You begin the scan."))
	if(!do_after(user, 30 SECONDS, src))
		return

	A.datum_reference?.UpdateUnderstanding(10)
