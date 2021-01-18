/obj/structure/mineral_door/resin
	name = "resin door"
	icon = 'icons/Fulpicons/xenodoors.dmi'
	icon_state = "resin"
	CanAtmosPass = ATMOS_PASS_NO
	openSound = 'sound/Fulpsounds/alien_resin_move1.ogg'
	closeSound = 'sound/Fulpsounds/alien_resin_move1.ogg'

/obj/structure/mineral_door/resin/TryToSwitchState(atom/user)
	if(isalien(user))
		return ..()

/obj/structure/mineral_door/resin/deconstruct(disassembled)
	qdel(src) //Doesn't drop any sheets.

/obj/structure/mineral_door/attack_alien(mob/living/carbon/alien/humanoid/user)
	if(user.a_intent != INTENT_HARM && TryToSwitchState())
		return
	..()
