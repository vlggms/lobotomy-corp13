/mob/living/simple_animal/hostile/abnormality/you_strong
	name = "You Must Become Strong"
	desc = "A multicolored factory that smells distinctly of iron... is this thing made of plastic!?"
	icon = 'ModularTegustation/Teguicons/96x64.dmi'
	icon_state = "you_strong_pause"
	icon_living = "you_strong_pause"
	portrait = "grown_strong"
	maxHealth = 200
	health = 200
	threat_level = HE_LEVEL
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 45,
		ABNORMALITY_WORK_INSIGHT = 45,
		ABNORMALITY_WORK_ATTACHMENT = 45,
		ABNORMALITY_WORK_REPRESSION = 0,
		"YES" = 0,
		"NO" = 0,
	)
	work_damage_amount = 8
	work_damage_type = RED_DAMAGE
	ego_list = list(
		/datum/ego_datum/weapon/get_strong,
		/datum/ego_datum/armor/get_strong,
	)
	gift_type = /datum/ego_gifts/get_strong
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

	max_boxes = 16
	speak_emote = list("beeps", "crackles", "buzzes")

	pixel_x = -32
	pixel_y = -8
	layer = OPEN_DOOR_LAYER

	observation_prompt = "I was the weakest person in all the City, even the Rats looked down upon me. <br>\
		'I would never amount to anything in life or in death', I thought until one day I recieved a curious offer, a pamphlet in my mail. <br>\
		\"Have you become strong? Strong for your City? Become Strong! Strong for your City!\" The suspicious pamphlet had an address and I followed it, <br>\
		I detested my weakness and I cared not if I lived or died, I'd take any chance to not be weak. <br>At the address was a most curious machine and an instruction to enter."
	observation_choices = list(
		"Enter the machine" = list(TRUE, "I did as instructed and entered; now I have become strong, strong for my City. <br>I love the City I live in."),
	)

	var/penalize = FALSE
	var/work_count = 0
	var/question = FALSE

	var/taken_parts = list(
		/obj/item/bodypart/l_leg,
		/obj/item/bodypart/r_leg,
		/obj/item/bodypart/l_arm,
		/obj/item/bodypart/r_arm,
		/obj/item/bodypart/head,
	)
	var/rejected_parts = list(
		/obj/item/bodypart/l_leg/robot,
		/obj/item/bodypart/r_leg/robot,
		/obj/item/bodypart/l_arm/robot,
		/obj/item/bodypart/r_arm/robot,
	)
	var/datum/looping_sound/server/soundloop

	var/operating = FALSE

/mob/living/simple_animal/hostile/abnormality/you_strong/Initialize(mapload)
	. = ..()
	soundloop = new(list(src), FALSE)
	soundloop.volume = 75
	soundloop.extra_range = 0

/mob/living/simple_animal/hostile/abnormality/you_strong/WorkComplete(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	. = ..()
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		src.datum_reference.qliphoth_change(-1) // No. Don't.
	work_count++
	icon_state = "you_strong_pause"
	penalize = FALSE
	if(work_count < 3)
		return
	work_count = 0
	say("Do you love the City you live in?")
	question = TRUE
	return

/mob/living/simple_animal/hostile/abnormality/you_strong/AttemptWork(mob/living/carbon/human/user, work_type)
	if(src.datum_reference.qliphoth_meter == 0)
		return FALSE
	if(operating)
		to_chat(user, span_notice("Please wait for current operations to cease."))
		return FALSE
	if(!(work_type in list("YES", "NO")) && !question && ..())
		icon_state = "you_strong_work"
		return TRUE
	if((work_type in list("YES", "NO")) && !question)
		to_chat(user, span_notice("You have not been prompted."))
		return FALSE
	if((work_type in list(ABNORMALITY_WORK_INSTINCT, ABNORMALITY_WORK_INSIGHT, ABNORMALITY_WORK_ATTACHMENT, ABNORMALITY_WORK_REPRESSION) && question))
		say("Do you love the City you live in?")
		playsound(src, 'sound/machines/clockcult/steam_whoosh.ogg', 100)
		return FALSE
	if(work_type == "YES")
		penalize = TRUE
		say("YES. YOU MUST BECOME STRONG FOR YOUR CITY.")
		icon_state = "you_strong_yes"
	else
		src.datum_reference.qliphoth_change(-1)
		say("INVALID INPUT.")
		icon_state = "you_strong_no"
	question = FALSE
	return FALSE

/mob/living/simple_animal/hostile/abnormality/you_strong/WorkChance(mob/living/carbon/human/user, chance, work_type)
	if(penalize)
		return chance /= 2
	return ..()

/mob/living/simple_animal/hostile/abnormality/you_strong/ZeroQliphoth(mob/living/carbon/human/user)
	SLEEP_CHECK_DEATH(2 SECONDS)
	playsound(src, 'sound/machines/clockcult/steam_whoosh.ogg', 100)
	manual_emote("makes a whirling sound.")
	SLEEP_CHECK_DEATH(2 SECONDS)
	soundloop.start()
	icon_state = "you_strong_work"
	SLEEP_CHECK_DEATH(30 SECONDS)
	soundloop.stop()
	src.datum_reference.qliphoth_change(3)
	icon_state = "you_strong_make"
	SLEEP_CHECK_DEATH(6)
	for(var/i = 1 to 3)
		new /mob/living/simple_animal/hostile/grown_strong(get_step(src, EAST))
	SLEEP_CHECK_DEATH(6)
	icon_state = "you_strong_pause"

/mob/living/simple_animal/hostile/abnormality/you_strong/attacked_by(obj/item/I, mob/living/user)
	if(!(I.type in taken_parts))
		return ..()
	if(I.type in rejected_parts)
		to_chat(user, span_notice("[src] rejects [I]."))
		return
	if(src.datum_reference.qliphoth_meter == 0 || src.datum_reference.working || operating)
		to_chat(user, span_notice("Please wait for current operations to cease."))
		return
	visible_message(span_notice("[user.first_name()] starts feeding [I] into [src]."))
	playsound(src, 'sound/machines/clockcult/steam_whoosh.ogg', 100)
	soundloop.start()
	icon_state = "you_strong_work"
	operating = TRUE
	if(!do_after(user, 2 SECONDS, src))
		to_chat(user, span_notice("But you changed your mind..."))
		soundloop.stop()
		icon_state = "you_strong_pause"
		operating = FALSE
		return
	soundloop.stop()
	playsound(src, 'sound/machines/clockcult/steam_whoosh.ogg', 100)
	qdel(I)
	src.datum_reference.stored_boxes += 2
	visible_message(span_nicegreen("[src] produced 2 PE!"))
	manual_emote("begins to emit a whirling noise before quieting down.")
	icon_state = "you_strong_pause"
	operating = FALSE
	return

/mob/living/simple_animal/hostile/abnormality/you_strong/attack_hand(mob/living/carbon/human/M)
	var/selected_part = M.zone_selected
	if(!(selected_part in list(BODY_ZONE_L_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_ARM, BODY_ZONE_R_LEG)))
		return ..()
	if(src.datum_reference.working || src.datum_reference.qliphoth_meter == 0 || operating)
		to_chat(M, span_notice("Please wait for current operations to cease."))
		return
	var/obj/item/bodypart/old_part = M.get_bodypart(selected_part)
	if(old_part.type in list(/obj/item/bodypart/r_leg/grown_strong, /obj/item/bodypart/l_leg/grown_strong, /obj/item/bodypart/r_arm/grown_strong, /obj/item/bodypart/l_arm/grown_strong))
		to_chat(M, span_notice("Only original parts are accepted."))
		return
	playsound(src, 'sound/machines/clockcult/steam_whoosh.ogg', 100)
	soundloop.start()
	visible_message(span_notice("[M.first_name()] plunges their [old_part.name] into [src]..."))
	icon_state = "you_strong_work"
	operating = TRUE
	if(!do_after(M, 5 SECONDS, src))
		visible_message(span_notice("[M.first_name()] pulls out their [old_part.name] before [src] engages!"))
		soundloop.stop()
		playsound(src, 'sound/machines/clockcult/steam_whoosh.ogg', 100)
		icon_state = "you_strong_pause"
		operating = FALSE
		return
	var/obj/item/bodypart/prosthetic
	switch(selected_part)
		if(BODY_ZONE_L_ARM)
			prosthetic = new/obj/item/bodypart/l_arm/grown_strong(M)
		if(BODY_ZONE_L_LEG)
			prosthetic = new/obj/item/bodypart/l_leg/grown_strong(M)
		if(BODY_ZONE_R_ARM)
			prosthetic = new/obj/item/bodypart/r_arm/grown_strong(M)
		if(BODY_ZONE_R_LEG)
			prosthetic = new/obj/item/bodypart/r_leg/grown_strong(M)
		else
			soundloop.stop()
			say("ERROR: FOREIGN OBJECT INSERTED. PLEASE CONTACT MAINTENCE STAFF.")
			playsound(src, 'sound/machines/clockcult/steam_whoosh.ogg', 100)
			icon_state = "you_strong_pause"
			operating = FALSE
			return
	prosthetic.replace_limb(M)
	manual_emote("makes a grinding noise.")
	M.emote("scream")
	M.deal_damage(50, BRUTE) // Bro your [X] just got chopped off, no armor's gonna resist that.
	to_chat(M, span_notice("Your [old_part.name] has been replaced!"))
	qdel(old_part)
	M.regenerate_icons()
	src.datum_reference.qliphoth_change(-1)
	soundloop.stop()
	playsound(src, 'sound/machines/clockcult/steam_whoosh.ogg', 100)
	icon_state = "you_strong_pause"
	operating = FALSE
	return

/mob/living/simple_animal/hostile/grown_strong
	name = "Grown Strong"
	desc = "A humanoid figure reeking of blood and made out of... plastic?"
	icon_state = "grown_strong"
	icon_living = "grown_strong"
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	maxHealth = 500
	health = 500
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 0)

	move_to_delay = 5
	melee_damage_lower = 3
	melee_damage_upper = 5
	melee_damage_type = RED_DAMAGE

	attack_sound = "swing_hit"
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"
	a_intent = "hostile"
	move_resist = 1500

	can_patrol = TRUE

	del_on_death = FALSE

	var/gear = 2
	COOLDOWN_DECLARE(gear_shift)
	var/gear_cooldown = 1 MINUTES
	//tracks speed change even if altered by other speed modifiers.
	var/gear_speed = 0

/mob/living/simple_animal/hostile/grown_strong/Move(atom/newloc, dir, step_x, step_y)
	if(status_flags & GODMODE)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/grown_strong/AttackingTarget(atom/attacked_target)
	if(status_flags & GODMODE)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/grown_strong/proc/UpdateGear()
	manual_emote("shifts into [gear]\th gear!")
	melee_damage_lower = 3*gear
	melee_damage_upper = 5*gear
	//Reset the speed. First proc changes this only with 0.
	ChangeMoveToDelayBy(gear_speed)
	//Calculate speed change.
	gear_speed = FLOOR(gear / 3, 1)
	//CRANK UP THE SPEED.
	ChangeMoveToDelayBy(-gear_speed)
	rapid_melee = gear > 7 ? 2 : 1

/mob/living/simple_animal/hostile/grown_strong/Life()
	. = ..()
	if(!COOLDOWN_FINISHED(src, gear_shift) || (status_flags & GODMODE))
		return
	gear = clamp(gear + rand(-1, 3), 1, 10)
	UpdateGear()
	src.apply_damage(150, BRUTE, null, 0, spread_damage = TRUE)// OOF OUCH MY BONES
	COOLDOWN_START(src, gear_shift, gear_cooldown)

/mob/living/simple_animal/hostile/grown_strong/death(gibbed)
	if(maxHealth > 200)
		INVOKE_ASYNC(src, PROC_REF(Undie))
		return FALSE
	visible_message(span_notice("[src] explodes into a mess of plastic and gore!"))
	. = ..()
	gib(TRUE, TRUE, TRUE)
	return

/mob/living/simple_animal/hostile/grown_strong/proc/Undie()
	manual_emote("shudders to a hault, insides whirling...")
	src.maxHealth = max(maxHealth - 100, 200)
	src.adjustBruteLoss(-9999)
	status_flags |= GODMODE
	SLEEP_CHECK_DEATH(3 SECONDS)
	status_flags &= ~GODMODE
	src.adjustBruteLoss(-9999)
	gear = clamp(gear + 2, 1, 10)
	manual_emote("shudders back to life!")
	UpdateGear()

////// Parts! //////

/obj/item/bodypart/r_leg/grown_strong
	name = "grown strong right leg"
	desc = "a fleshy limb encased in plastic"
	icon = 'icons/mob/human_parts_greyscale.dmi'
	icon_state = "human_r_leg"
	var/buff_type

/obj/item/bodypart/r_leg/grown_strong/Initialize(mapload)
	. = ..()
	color = pick(
		COLOR_ASSEMBLY_RED,
		COLOR_ASSEMBLY_GREEN,
		COLOR_ASSEMBLY_BLUE,
		COLOR_ASSEMBLY_YELLOW,
		COLOR_ASSEMBLY_BGRAY,
		COLOR_ASSEMBLY_PURPLE,
	)
	buff_type = pick(
		FORTITUDE_ATTRIBUTE,
		PRUDENCE_ATTRIBUTE,
		TEMPERANCE_ATTRIBUTE,
		JUSTICE_ATTRIBUTE,
	)

/obj/item/bodypart/r_leg/grown_strong/drop_limb(special)
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(buff_type, -2)
	..()

/obj/item/bodypart/r_leg/grown_strong/attach_limb(mob/living/carbon/C, special)
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(buff_type, 2)

/obj/item/bodypart/r_leg/grown_strong/get_limb_icon(dropped)
	icon_state = ""
	. = list()
	var/image_dir = 0
	if(dropped)
		image_dir = SOUTH
	var/image/limb = image(layer = -BODYPARTS_LAYER, dir = image_dir)
	. += limb
	limb.icon = 'icons/mob/human_parts_greyscale.dmi'
	limb.icon_state = "human_r_leg"
	limb.color = src.color // Is this VIOLENTLY incompatible with other races? Yeah. Does that matter for us? No... Right?

/obj/item/bodypart/l_leg/grown_strong
	name = "grown strong left leg"
	desc = "a fleshy limb encased in plastic"
	icon = 'icons/mob/human_parts_greyscale.dmi'
	icon_state = "human_l_leg"
	var/buff_type

/obj/item/bodypart/l_leg/grown_strong/Initialize(mapload)
	. = ..()
	color = pick(
		COLOR_ASSEMBLY_RED,
		COLOR_ASSEMBLY_GREEN,
		COLOR_ASSEMBLY_BLUE,
		COLOR_ASSEMBLY_YELLOW,
		COLOR_ASSEMBLY_BGRAY,
		COLOR_ASSEMBLY_PURPLE,
	)
	buff_type = pick(
		FORTITUDE_ATTRIBUTE,
		PRUDENCE_ATTRIBUTE,
		TEMPERANCE_ATTRIBUTE,
		JUSTICE_ATTRIBUTE,
	)

/obj/item/bodypart/l_leg/grown_strong/drop_limb(special)
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(buff_type, -2)
	..()

/obj/item/bodypart/l_leg/grown_strong/attach_limb(mob/living/carbon/C, special)
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(buff_type, 2)

/obj/item/bodypart/l_leg/grown_strong/get_limb_icon(dropped)
	icon_state = ""
	. = list()
	var/image_dir = 0
	if(dropped)
		image_dir = SOUTH
	var/image/limb = image(layer = -BODYPARTS_LAYER, dir = image_dir)
	. += limb
	limb.icon = 'icons/mob/human_parts_greyscale.dmi'
	limb.icon_state = "human_l_leg"
	limb.color = src.color // Is this VIOLENTLY incompatible with other races? Yeah. Does that matter for us? No... Right?

/obj/item/bodypart/r_arm/grown_strong
	name = "grown strong right arm"
	desc = "a fleshy limb encased in plastic"
	icon = 'icons/mob/human_parts_greyscale.dmi'
	icon_state = "human_r_arm"
	var/buff_type

/obj/item/bodypart/r_arm/grown_strong/Initialize(mapload)
	. = ..()
	color = pick(
		COLOR_ASSEMBLY_RED,
		COLOR_ASSEMBLY_GREEN,
		COLOR_ASSEMBLY_BLUE,
		COLOR_ASSEMBLY_YELLOW,
		COLOR_ASSEMBLY_BGRAY,
		COLOR_ASSEMBLY_PURPLE,
	)
	buff_type = pick(
		FORTITUDE_ATTRIBUTE,
		PRUDENCE_ATTRIBUTE,
		TEMPERANCE_ATTRIBUTE,
		JUSTICE_ATTRIBUTE,
	)

/obj/item/bodypart/r_arm/grown_strong/drop_limb(special)
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(buff_type, -2)
	..()

/obj/item/bodypart/r_arm/grown_strong/attach_limb(mob/living/carbon/C, special)
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(buff_type, 2)

/obj/item/bodypart/r_arm/grown_strong/get_limb_icon(dropped)
	icon_state = ""
	. = list()
	var/image_dir = 0
	if(dropped)
		image_dir = SOUTH
	var/image/limb = image(layer = -BODYPARTS_LAYER, dir = image_dir)
	var/image/aux
	. += limb
	limb.icon = 'icons/mob/human_parts_greyscale.dmi'
	limb.icon_state = "human_r_arm"
	limb.color = src.color // Is this VIOLENTLY incompatible with other races? Yeah. Does that matter for us? No... Right?
	if(aux_zone)
		aux = image(limb.icon, "human_r_hand", -aux_layer, image_dir)
		aux.color = limb.color
		. += aux

/obj/item/bodypart/l_arm/grown_strong
	name = "grown strong left arm"
	desc = "a fleshy limb encased in plastic"
	icon = 'icons/mob/human_parts_greyscale.dmi'
	icon_state = "human_l_arm"
	var/buff_type

/obj/item/bodypart/l_arm/grown_strong/Initialize(mapload)
	. = ..()
	color = pick(
		COLOR_ASSEMBLY_RED,
		COLOR_ASSEMBLY_GREEN,
		COLOR_ASSEMBLY_BLUE,
		COLOR_ASSEMBLY_YELLOW,
		COLOR_ASSEMBLY_BGRAY,
		COLOR_ASSEMBLY_PURPLE,
	)
	buff_type = pick(
		FORTITUDE_ATTRIBUTE,
		PRUDENCE_ATTRIBUTE,
		TEMPERANCE_ATTRIBUTE,
		JUSTICE_ATTRIBUTE,
	)

/obj/item/bodypart/l_arm/grown_strong/drop_limb(special)
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(buff_type, -2)
	..()

/obj/item/bodypart/l_arm/grown_strong/attach_limb(mob/living/carbon/C, special)
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	H.adjust_attribute_buff(buff_type, 2)

/obj/item/bodypart/l_arm/grown_strong/get_limb_icon(dropped)
	icon_state = ""
	. = list()
	var/image_dir = 0
	if(dropped)
		image_dir = SOUTH
	var/image/limb = image(layer = -BODYPARTS_LAYER, dir = image_dir)
	var/image/aux
	. += limb
	limb.icon = 'icons/mob/human_parts_greyscale.dmi'
	limb.icon_state = "human_l_arm"
	limb.color = src.color // Is this VIOLENTLY incompatible with other races? Yeah. Does that matter for us? No... Right?
	if(aux_zone)
		aux = image(limb.icon, "human_l_hand", -aux_layer, image_dir)
		aux.color = limb.color
		. += aux
