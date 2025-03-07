
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

/*-------------\
| SIGNAL TRAPS |
\-------------*/

/obj/structure/sigsystem
	name = "incomplete signal system"
	desc = "Someone tried to make a signal system here."
	density = FALSE
	anchored = TRUE
	var/fire_cooldown = 0
	var/fire_delay = 3
	var/signaller_freq = FREQ_PRESSURE_PLATE
	var/signaller_code = 111
	var/obj/item/assembly/signaler/system/sigdev
	var/list/list_triggers = list()

/obj/structure/sigsystem/Initialize()
	. = ..()
	sigdev = new(src)
	sigdev.set_frequency(signaller_freq)
	sigdev.code = signaller_code

/obj/structure/sigsystem/proc/pulse()
	if(fire_cooldown > world.time)
		return FALSE
	return TRUE

/*-----------------------\
|Trap Projectile Launcher|
\-----------------------*/
/obj/structure/sigsystem/projectile_launcher
	name = "launching mechanism"
	desc = "A hole that launches a projectile when supplied with a signal."
	icon = 'ModularTegustation/Teguicons/lc13_structures.dmi'
	icon_state = "hole"


	var/projectile_type = /obj/projectile/bullet/shotgun_beanbag
	var/projectile_sound = 'sound/weapons/sonic_jackhammer.ogg'

/obj/structure/sigsystem/projectile_launcher/pulse()
	. = ..()
	if(!.)
		return FALSE
	var/obj/projectile/P = new projectile_type(get_step(get_turf(src), dir))
	playsound(src, projectile_sound, 50, TRUE)
	P.firer = src
	P.fired_from = src
	P.fire(dir2angle(dir))
	fire_cooldown = world.time + fire_delay
	return P
