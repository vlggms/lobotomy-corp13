/obj/effect/mob_spawn/cuckoo_spawner
	mob_type = 	/mob/living/carbon/human/species/cuckoospawn
	name = "strange egg"
	desc = "A man-sized yellow egg, spawned from some unfathomable creature. A humanoid silhouette lurks within."
	mob_name = "Niaojia-ren"
	icon = 'icons/mob/lavaland/lavaland_monsters.dmi'
	icon_state = "large_egg"
	roundstart = FALSE
	death = FALSE
	move_resist = MOVE_FORCE_NORMAL
	density = FALSE
	short_desc = "You are an niaojia-ren. You must raise your numbers by infecting humans and exexterminating humans who enter your home..."
	flavour_text = "You wake up in this strange location... Filled with unfamiliar sounds... \
	You have seen lights in the distance... they foreshadow the arrival of humans... Humans? In your sacred domain?! \
	Looks like you found some new hosts for your children..."

/obj/effect/mob_spawn/cuckoo_spawner/Initialize()
	. = ..()
	var/area/A = get_area(src)
	if(A)
		notify_ghosts("An cuckoo egg is ready to hatch in \the [A.name].", source = src, action=NOTIFY_ATTACK, flashwindow = FALSE, ignore_key = POLL_IGNORE_ASHWALKER)

/obj/structure/bird_statue
	name = "old bird statue"
	desc = "An statue of great worship, it appears to have sinister around it... If you understood what it means, you could offer stuff to it..."
	icon = 'ModularTegustation/Teguicons/64x64.dmi'
	icon_state = "thunderbird_altar"
	pixel_x = -16
	base_pixel_x = -16
	light_color = LIGHT_COLOR_BLOOD_MAGIC
	light_range = 5
	light_power = 7
	max_integrity = 500
	density = TRUE
	anchored = TRUE
	can_buckle = TRUE
	var/collected_meat = 0

/obj/structure/bird_statue/user_buckle_mob(mob/living/M, mob/user, check_loc)
	if(M.stat != DEAD)
		return FALSE
	if(!istype(user, /mob/living/carbon/human/species/cuckoospawn))
		to_chat(user, span_warning("You have no idea how this works!"))
		return FALSE
	to_chat(user, span_notice("You start offering [M] to your god..."))
	if(do_after(user, 20, target = M))
		if(!istype(M, /mob/living/simple_animal))
			to_chat(user, span_warning("[src] rejects your offering!"))
			return
		to_chat(user, span_nicegreen("[src] is proud of your offering!"))
		playsound(get_turf(M), 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 50, 0, 8)
		new /obj/effect/temp_visual/tbirdlightning(get_turf(M))
		var/datum/effect_system/smoke_spread/S = new
		S.set_up(0, get_turf(M))	//Smoke shouldn't really obstruct your vision
		S.start()
		M.gib()

/obj/structure/bird_statue/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(!istype(user, /mob/living/carbon/human/species/cuckoospawn))
		to_chat(user, span_warning("You have no idea how this works!"))
		return FALSE
	if(istype(I, /obj/item/food/meat/slab)) //How would humans understand?
		playsound(get_turf(src), 'sound/magic/enter_blood.ogg', 30, 1)
		to_chat(user, span_nicegreen("[src] happily accepts your offering!"))
		collected_meat++
		qdel(I)
	if(istype(I, /obj/item/storage)) // Code for storage dumping
		var/obj/item/storage/S = I
		for(var/obj/item/IT in S)
			if(istype(IT, /obj/item/food/meat/slab))
				playsound(get_turf(src), 'sound/magic/enter_blood.ogg', 30, 1)
				to_chat(user, span_nicegreen("[src] happily accepts your offering!"))
				collected_meat++
				qdel(IT)

/obj/structure/bird_statue/examine(mob/user)
	. = ..()
	if(istype(user, /mob/living/carbon/human/species/cuckoospawn))
		. += span_notice("[src] currently has [collected_meat] meat stored inside of it!") // Only the birds are able to understand the bird statue.

/obj/structure/bird_statue/attack_hand(mob/user)
	. = ..()
	if(!istype(user, /mob/living/carbon/human/species/cuckoospawn))
		to_chat(user, span_warning("You have no idea how this works!"))
		return FALSE
	var/statue_ask = alert("[src] awaits your demand.", "Oh dear ancient elder... If you can grant us a", "niaojia-ren salve (4 Meat)", "host stabilizer (4 Meat)", "niaojia-ren revive (15 Meat)", "Cancel")
	if(statue_ask == "niaojia-ren salve (4 Meat)")
		if(collected_meat >= 4)
			to_chat(user, span_nicegreen("[src] understands your request, and grants your request!"))
			collected_meat -= 4
			new /obj/item/cuckoo_healing (get_turf(user))
		else
			to_chat(user, span_warning("[src] deines your request, it demands more flesh!"))
	else if(statue_ask == "host stabilizer (4 Meat)")
		if(collected_meat >= 4)
			to_chat(user, span_nicegreen("[src] understands your request, and grants your request!"))
			collected_meat -= 4
			new /obj/item/cuckoo_stabilizer (get_turf(user))
		else
			to_chat(user, span_warning("[src] deines your request, it demands more flesh!"))
	else if(statue_ask == "niaojia-ren revive (15 Meat)")
		if(collected_meat >= 15)
			to_chat(user, span_nicegreen("[src] understands your request, and grants your request!"))
			collected_meat -= 15
			new /obj/item/cuckoo_revive (get_turf(user))
		else
			to_chat(user, span_warning("[src] deines your request, it demands more flesh!"))

/obj/item/cuckoo_healing
	name = "niaojia-ren salve"
	desc = "Strange pile of meat, it appears that some birds could eat it to recover..."
	icon_state = "meatproduct"
	icon = 'icons/obj/food/food.dmi'
	w_class = WEIGHT_CLASS_SMALL

/obj/item/cuckoo_healing/attack_self(mob/user)
	. = ..()
	if(istype(user, /mob/living/carbon/human/species/cuckoospawn))
		var/mob/living/carbon/human/species/cuckoospawn/bird_owner = user
		to_chat(bird_owner, span_notice("You start applying the [src] on your wounds..."))
		if(do_after(bird_owner, 30, src))
			bird_owner.adjustBruteLoss(-100)
			to_chat(bird_owner, span_nicegreen("You feel your wounds recover as the salve molds into your flesh!"))
			qdel(src)
	else
		to_chat(user, span_notice("You have no idea on how to apply it!"))

/obj/item/cuckoo_stabilizer
	name = "niaojia-ren stabilizer"
	desc = "Strange object... It would allow some birds to stabilizes their hosts!"
	icon_state = "meatproductsteak"
	icon = 'icons/obj/food/food.dmi'
	w_class = WEIGHT_CLASS_SMALL

/obj/item/cuckoo_stabilizer/attack(mob/M, mob/user)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/human_target = M
		if(!istype(user, /mob/living/carbon/human/species/cuckoospawn))
			to_chat(user, span_notice("You have no idea on how to apply it!"))
			return FALSE
		if(human_target.stat == DEAD && human_target.getorgan(/obj/item/organ/body_egg/cuckoospawn_embryo))
			to_chat(user, span_nicegreen("You start applying [src] to [human_target]..."))
			if(do_after(user, 40, human_target))
				human_target.adjustOxyLoss(-human_target.maxHealth)
				human_target.adjustToxLoss(-human_target.maxHealth)
				human_target.adjustFireLoss(-human_target.maxHealth)
				human_target.adjustBruteLoss(-human_target.maxHealth)
				human_target.updatehealth() // Previous "adjust" procs don't update health, so we do it manually.
				playsound(get_turf(src), 'sound/magic/enter_blood.ogg', 30, 1)
				human_target.revive(full_heal = FALSE, admin_revive = FALSE)
				human_target.emote("gasps")
				human_target.Jitter(100)
				human_target.Paralyze(75)
				to_chat(user, span_nicegreen("[human_target] suddenly shakes awake!"))
				to_chat(human_target, span_nicegreen("You suddenly wake up, as some cool liquid sinks into your body..."))
				qdel(src)

/obj/item/cuckoo_revive
	name = "niaojia-ren bolus"
	desc = "Strange round object... It would allow the cukoo birds revive their fallen members!"
	icon_state = "egg-mime"
	color = "#292929"
	icon = 'icons/obj/food/food.dmi'
	w_class = WEIGHT_CLASS_SMALL

/obj/item/cuckoo_revive/attack(mob/M, mob/user)
	. = ..()
	if(!istype(user, /mob/living/carbon/human/species/cuckoospawn))
		to_chat(user, span_notice("You have no idea on how to apply it!"))
		return FALSE
	if(istype(M, /mob/living/carbon/human/species/cuckoospawn))
		var/mob/living/carbon/human/species/cuckoospawn/new_bird = M
		to_chat(user, span_nicegreen("You start applying [src] to [new_bird]..."))
		if(do_after(user, 60, new_bird))
			new_bird.adjustOxyLoss(-new_bird.maxHealth)
			new_bird.adjustToxLoss(-new_bird.maxHealth)
			new_bird.adjustFireLoss(-new_bird.maxHealth)
			new_bird.adjustBruteLoss(-new_bird.maxHealth)
			new_bird.updatehealth()
			playsound(get_turf(src), 'sound/magic/enter_blood.ogg', 30, 1)
			new_bird.revive(full_heal = FALSE, admin_revive = FALSE)
			new_bird.emote("gasps")
			new_bird.Jitter(100)
			new_bird.Paralyze(75)
			to_chat(user, span_nicegreen("[new_bird] suddenly shakes awake!"))
			to_chat(new_bird, span_nicegreen("You suddenly wake up, as something warm enters your mouth..."))
			qdel(src)
	else
		to_chat(user, span_notice("The target is not compatible with this bolus!"))

/obj/item/cuckoo_revive/attack_self(mob/user)
	. = ..()
	if(istype(user, /mob/living/carbon/human/species/cuckoospawn))
		var/mob/living/carbon/human/species/cuckoospawn/bird_owner = user
		to_chat(user, span_nicegreen("You start applying [src] to [bird_owner]..."))
		if(do_after(user, 60, src))
			bird_owner.adjustBruteLoss(-bird_owner.maxHealth)
			to_chat(bird_owner, span_nicegreen("You feel your wounds recover as you devour the bolus!"))
			qdel(src)
	else
		if(ishuman(user))
			var/mob/living/carbon/human/implanted_human = user
			implanted_human.adjustBruteLoss(-implanted_human.maxHealth)
			to_chat(implanted_human, span_info("It has a strange taste..."))
			var/obj/item/bodypart/chest/LC = implanted_human.get_bodypart(BODY_ZONE_CHEST)
			if((!LC || LC.status != BODYPART_ROBOTIC) && !implanted_human.getorgan(/obj/item/organ/body_egg/cuckoospawn_embryo) && prob(75))
				new /obj/item/organ/body_egg/cuckoospawn_embryo(implanted_human)
				var/turf/TT = get_turf(implanted_human)
				log_game("[key_name(implanted_human)] was impregnated by [src] at [loc_name(TT)]")

/obj/machinery/door/keycard/cuckoo_nest
	desc = "A dusty, scratched door with a thick lock attached."
	icon = 'icons/obj/doors/puzzledoor/wood.dmi'
	puzzle_id = "cuckoo_jail"
	open_message = "The door opens with a loud creak."
	armor = list(MELEE = 50, BULLET = 50, LASER = 50, ENERGY = 50, BOMB = 50, BIO = 50, RAD = 50, FIRE = 50, ACID = 50)
	resistance_flags = FIRE_PROOF | ACID_PROOF | LAVA_PROOF

/obj/machinery/door/keycard/cuckoo_nest/attackby(obj/item/I, mob/user, params)
	if(istype(I,/obj/item/keycard))
		var/obj/item/keycard/key = I
		if((!puzzle_id || puzzle_id == key.puzzle_id) && !density)
			to_chat(user, span_notice("This door closes shut."))
			close()
			return
	. = ..()

/obj/item/keycard/cuckoo_jail
	name = "golden key"
	desc = "A dull, golden key."
	icon_state = "golden_key"
	puzzle_id = "cuckoo_jail"
