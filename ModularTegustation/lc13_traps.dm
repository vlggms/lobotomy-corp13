
/**
* TRIPWIRE TRAPS
*/
	/* Tripwire Trap
/datum/crafting_recipe/tripwire
	name = "Tripwire"
	result = /obj/structure/destructible/tripwire_trap
	reqs = list(/obj/item/stack/sheet/cotton/cloth = 2, /obj/item/stack/sheet/mineral/wood = 2)
	time = 40
	category = CAT_MISC
*/

/obj/structure/destructible/tripwire_trap
	name = "tripwire"
	desc = "A string attached to two sticks."
	icon = 'ModularTegustation/Teguicons/lc13_structures.dmi'
	icon_state = "tripwire"
	alpha = 100
	break_message = span_warning("The trap falls apart!")
	debris = list(/obj/item/stack/sheet/cotton/cloth = 1)
	var/triggered_attack

/obj/structure/destructible/tripwire_trap/Initialize(mapload)
	. = ..()
	if(!isfloorturf(get_turf(src)))
		qdel(src)
	if(mapload)
		var/obj/item/I = locate(/obj/item) in loc
		if(I)
			I.forceMove(src)
			triggered_attack = 1

/obj/structure/destructible/tripwire_trap/attackby(obj/item/W, mob/user)
	if(!triggered_attack && isitem(W) && user.a_intent != INTENT_HARM)
		visible_message(span_notice("[user] ties [W] to the [src]."))
		W.forceMove(src)
		triggered_attack = 1
		return
	return ..()

/obj/structure/destructible/tripwire_trap/Crossed(atom/movable/AM as mob|obj)
	. = ..()
	if(triggered_attack == 1)
		if(ismob(AM))
			var/mob/MM = AM
			if(!(MM.movement_type & FLYING))
				if(ishuman(AM))
					var/mob/living/carbon/H = AM
					if(H.m_intent == MOVE_INTENT_RUN)
						trapEffect(H)
						H.visible_message(span_warning("[H] accidentally steps on [src]."), \
							span_warning("You accidentally step on [src]"))
				else
					trapEffect(MM)
		else if(AM.density) // For mousetrap grenades, set off by anything heavy
			trapEffect(AM)
	..()

/obj/structure/destructible/tripwire_trap/proc/trapEffect(mob/living/L)
	for(var/obj/item/I in src)
		visible_message(span_notice("[I] swings down."))
		I.forceMove(get_turf(src))
		UniqueItemEffect(I)
		I.throw_impact(L)
		triggered_attack = 0
	deconstruct(TRUE)

/obj/structure/destructible/tripwire_trap/proc/UniqueItemEffect(obj/item/I)
	if(istype(I, /obj/item/grenade))
		var/obj/item/grenade/G = I
		G.arm_grenade(null, G.det_time)
