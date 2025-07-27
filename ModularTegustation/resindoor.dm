/obj/structure/mineral_door/resin
	name = "resin door"
	icon = 'ModularTegustation/Teguicons/xenodoors.dmi'
	icon_state = "resin"
	CanAtmosPass = ATMOS_PASS_NO
	openSound = 'ModularTegustation/tegusounds/alien_resin_move1.ogg'
	closeSound = 'ModularTegustation/tegusounds/alien_resin_move1.ogg'
	close_delay = 5 SECONDS

/obj/structure/mineral_door/resin/TryToSwitchState(atom/user)
	if(!isliving(user))
		return
	var/mob/living/M = user
	if(M.getorgan(/obj/item/organ/alien/hivenode))
		return ..()

/obj/structure/mineral_door/resin/wrench_act(mob/living/user, obj/item/I)
	to_chat(user, span_notice("It appears that there are no bolts on the [src]."))
	return

/obj/structure/mineral_door/resin/welder_act(mob/living/user, obj/item/I)
	return

/obj/structure/mineral_door/resin/deconstruct(disassembled)
	qdel(src) //Doesn't drop any sheets.

/obj/structure/mineral_door/attack_alien(mob/living/carbon/alien/humanoid/user)
	if(user.a_intent != INTENT_HARM && TryToSwitchState())
		return
	..()
