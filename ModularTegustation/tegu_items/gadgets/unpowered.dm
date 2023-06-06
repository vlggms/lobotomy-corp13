	//Pet Whistle
/obj/item/pet_whistle
	name = "Galtons whistle"
	desc = "A common dog whistle. When used in hand, any nearby creature that is tamed will follow you."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "dogwhistle"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	var/mode = 1

/obj/item/pet_whistle/attack_self(mob/living/carbon/human/user) //i would make it work on actual /pets but those seem to lack the code for movement commands
	to_chat(user, "<span class='nicegreen'>You blow the [src].</span>")
	playsound(get_turf(user), 'sound/effects/whistlereset.ogg', 10, 3, 3)
	for(var/mob/living/simple_animal/hostile/bud in oview(get_turf(user), 7))
		if(!bud.client && bud.tame) //isnt based on faction since this would result in the abnormality Yang and large shrimp gangs following the user.
			switch(mode)
				if(1)
					bud.Goto(user, bud.move_to_delay, 2)
				else
					bud.LoseTarget()
	if(mode != 1)
		mode = 1
	else if(mode == 1)
		mode = 0



	//abnos spawn slower, for maps that suck lol
/obj/item/lc13_abnospawn
	name = "Lobotomy Corporation Radio"
	desc = "A device to call HQ and slow down abnormality arrival rate. Use in hand to activate."
	icon = 'icons/obj/device.dmi'
	icon_state = "gangtool-yellow"

/obj/item/lc13_abnospawn/attack_self(mob/living/carbon/human/user)
	to_chat(user, "<span class='nicegreen'>You feel that you now have more time.</span>")
	SSabnormality_queue.next_abno_spawn_time *= 1.5
	qdel(src)




//Command projector
/obj/item/commandprojector
	name = "handheld command projector"
	desc = "A device that projects holographic images from a distance."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "gadget3"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL
	var/commandtype = 1
	var/commanddelay = 1.5 SECONDS
	var/cooldown = 0
	var/static/list/commandtypes = typecacheof(list(
		/obj/effect/temp_visual/commandMove,
		/obj/effect/temp_visual/commandWarn,
		/obj/effect/temp_visual/commandGaurd,
		/obj/effect/temp_visual/commandHeal,
		/obj/effect/temp_visual/commandFightA,
		/obj/effect/temp_visual/commandFightB
		))

/obj/item/commandprojector/attack_self(mob/user)
	..()
	switch(commandtype)
		if(0) //if 0 change to 1
			to_chat(user, "<span class='notice'>MOVE IMAGE INITIALIZED.</span>")
			commandtype += 1
		if(1)
			to_chat(user, "<span class='notice'>WARN IMAGE INITIALIZED.</span>")
			commandtype += 1
		if(2)
			to_chat(user, "<span class='notice'>GUARD IMAGE INITIALIZED.</span>")
			commandtype += 1
		if(3)
			to_chat(user, "<span class='notice'>HEAL IMAGE INITIALIZED.</span>")
			commandtype += 1
		if(4)
			to_chat(user, "<span class='notice'>FIGHT_LIGHT IMAGE INITIALIZED.</span>")
			commandtype += 1
		if(5)
			to_chat(user, "<span class='notice'>FIGHT_HEAVY IMAGE INITIALIZED.</span>")
			commandtype += 1
		else
			commandtype -= 5
			to_chat(user, "<span class='notice'>MOVE IMAGE INITIALIZED.</span>")
	playsound(src, 'sound/machines/pda_button1.ogg', 20, TRUE)

/obj/item/commandprojector/afterattack(atom/target, mob/user, proximity_flag)
	. = ..()
	if(cooldown <= world.time)
		for(var/obj/effect/temp_visual/V in range(get_turf(target), 0))
			if(is_type_in_typecache(V, commandtypes))
				qdel(V)
				return
		switch(commandtype)
			if(1)
				new /obj/effect/temp_visual/commandMove(get_turf(target))
			if(2)
				new /obj/effect/temp_visual/commandWarn(get_turf(target))
			if(3)
				new /obj/effect/temp_visual/commandGaurd(get_turf(target))
			if(4)
				new /obj/effect/temp_visual/commandHeal(get_turf(target))
			if(5)
				new /obj/effect/temp_visual/commandFightA(get_turf(target))
			if(6)
				new /obj/effect/temp_visual/commandFightB(get_turf(target))
			else
				to_chat(user, "<span class='warning'>CALIBRATION ERROR.</span>")
		cooldown = world.time + commanddelay
	playsound(src, 'sound/machines/pda_button1.ogg', 20, TRUE)




//Deepscanner
/obj/item/deepscanner //intended for ordeals
	name = "deep scan kit"
	desc = "A collection of tools used for scanning the physical form of an entity."
	icon = 'icons/obj/storage.dmi'
	icon_state = "maint_kit"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	color = "gold"
	var/check1a
	var/check1b
	var/check1c
	var/check1d
	var/check1e
	var/deep_scan_log

/obj/item/deepscanner/examine(mob/living/M)
	. = ..()
	if(deep_scan_log)
		to_chat(M, "<span class='notice'>Previous Scan:[deep_scan_log].</span>")

/obj/item/deepscanner/attack(mob/living/M, mob/user)
	user.visible_message("<span class='notice'>[user] takes a tool out of [src] and begins scanning [M].</span>", "<span class='notice'>You set down the deep scanner and begin scanning [M].</span>")
	playsound(get_turf(M), 'sound/misc/box_deploy.ogg', 5, 0, 3)
	if(!do_after(user, 2 SECONDS, target = user))
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/suit = H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
		check1a = H.physiology.red_mod
		check1b = H.physiology.white_mod
		check1c = H.physiology.black_mod
		check1d = H.physiology.pale_mod
		check1e = "Unknown"
		if(suit)
			check1a = 1 - (H.getarmor(null, RED_DAMAGE) / 100)
			check1b = 1 - (H.getarmor(null, WHITE_DAMAGE) / 100)
			check1c = 1 - (H.getarmor(null, BLACK_DAMAGE) / 100)
			check1d = 1 - (H.getarmor(null, PALE_DAMAGE) / 100)
		if(H.job)
			check1e = H.job
		to_chat(user, "<span class='notice'>[check1e] [H] [H.maxHealth] [check1a] [check1b] [check1c] [check1d].</span>")
	else
		var/mob/living/simple_animal/hostile/mon = M
		if((mon.status_flags & GODMODE))
			return
		check1a = mon.damage_coeff[RED_DAMAGE]
		check1b = mon.damage_coeff[WHITE_DAMAGE]
		check1c = mon.damage_coeff[BLACK_DAMAGE]
		check1d = mon.damage_coeff[PALE_DAMAGE]
		to_chat(user, "<span class='notice'>[mon] [mon.maxHealth] [check1a] [check1b] [check1c] [check1d].</span>")
		deep_scan_log = "[mon] [mon.maxHealth] [check1a] [check1b] [check1c] [check1d]"
	playsound(get_turf(M), 'sound/misc/box_deploy.ogg', 5, 0, 3)


//Kcorp Syringe
/obj/item/ksyringe
	name = "k-corp nanomachine ampule"
	desc = "A syringe of kcorp healing nanobots."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "kcorp_syringe"
	slot_flags = ITEM_SLOT_POCKETS
	w_class = WEIGHT_CLASS_SMALL

/obj/item/ksyringe/attack_self(mob/living/user)
	..()
	to_chat(user, "<span class='notice'>You inject the syringe and instantly feel better.</span>")
	user.adjustBruteLoss(-40)
	qdel(src)
