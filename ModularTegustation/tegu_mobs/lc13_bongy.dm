//Object psuedo-mob. It's bongy from hell's chicken!
/obj/item/clothing/mask/facehugger/bongy
	name = "bongy"
	desc = "It looks like a raw chicken. An angry raw chicken!"
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "bongy"
	inhand_icon_state = "bongy"
	modifies_speech = TRUE
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDEEYES|HIDEEARS|HIDESNOUT
	var/animal_sounds = list("BAWK!", "BUGAAAWK!", "CLUCK CLUCK!", "BAWK BAWK!")
	var/animal_sounds_alt_probability = 5
	var/animal_sounds_alt = list("SOMEONE HELP ME!!")
	var/guaranteed_butcher_results = /obj/item/food/meat/slab/chicken/bongy

/obj/item/clothing/mask/facehugger/bongy/dead
	icon_state = "bongy_dead"
	inhand_icon_state = "bongy_dead"
	stat = DEAD

/obj/item/clothing/mask/facehugger/bongy/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	return

/obj/item/clothing/mask/facehugger/bongy/Attach(mob/living/M)
	if(!valid_to_attach(M))
		return
	// early returns and validity checks done: attach.
	attached = TRUE
	M.take_bodypart_damage(strength,0) //done here so that humans in helmets take damage
	M.Unconscious(strength) //like 5 ticks
	GoIdle() //so it doesn't jump the people that tear it off

/obj/item/clothing/mask/facehugger/bongy/GoActive()
	if(stat == DEAD || stat == CONSCIOUS)
		return
	stat = CONSCIOUS
	attached = FALSE
	icon_state = "[initial(icon_state)]"

/obj/item/clothing/mask/facehugger/bongy/Leap(mob/living/M)
	. = ..()
	if(.)
		playsound(src, 'sound/creatures/lc13/bongy/kweh.ogg', 70, TRUE)

/obj/item/clothing/mask/facehugger/bongy/attackby(obj/item/O, mob/user, params)
	if(stat == DEAD && O.get_sharpness())
		if(!do_after(user, 12, src))
			return
		new /obj/item/food/meat/slab/chicken/bongy(get_turf(src))
		new /obj/effect/gibspawner/generic/animal(get_turf(src))
		qdel(src)
		return
	return O.attack_obj(src, user)

/obj/item/clothing/mask/facehugger/bongy/Die()
	if(stat == DEAD)
		return
	icon_state = "[initial(icon_state)]_dead"
	inhand_icon_state = "bongy_dead"
	stat = DEAD
	visible_message(span_danger("[src] suddenly stops moving!"))

/obj/item/clothing/mask/facehugger/bongy/handle_speech(datum/source, list/speech_args)
	speech_args[SPEECH_MESSAGE] = pick((prob(animal_sounds_alt_probability) && LAZYLEN(animal_sounds_alt)) ? animal_sounds_alt : animal_sounds)
	playsound(get_turf(src), "sound/creatures/lc13/bongy/chatter[pick(1,3)].ogg", 25, 0)

/obj/item/food/meat/slab/chicken/bongy
	name = "bongy chicken meat"
