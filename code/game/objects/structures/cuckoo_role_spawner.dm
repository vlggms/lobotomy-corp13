#define STATUS_EFFECT_HUNTER /datum/status_effect/hunter
#define STATUS_EFFECT_PREY /datum/status_effect/prey
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

//TODO: Make it so niaojia-ren can't shove, pull or strip humans, DONE
//TODO: Replace the host revi with the banner for territory banner, DONE
//TODO: Add a skill to the niaojia-ren which gives them a message about how they work. DONE
//TODO: Add a territory gimmick where they can place down banners where they need to be within 12x12 range of another banner to statue to be placed down
//And they can't be within a 5x5 range of another banner. Birds within a 12x12 range of a banner get a buff and outside of it they are weak without it
//Humans get the foggy vision like with GoS, DONE
//TODO: Fix simple mobs being immune to hostile mobs, DONE
//TODO: Make the statue value amber meat at 50% less and doubt meat 100% more, DONE
//TODO: Make the niaojia-ren immune to glass shards DONE
//TODO: Make it so niaojia-ren can't wear outfits. DONE
//TODO: Make it so they can't infect people with the XENO_IMMUNE TRAIT, DONE

/obj/structure/bird_statue
	name = "old bird statue"
	desc = "A statue of great worship, it appears to have sinister aura around it... If you understood what it means, you could offer stuff to it..."
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
	var/list/territory_tiles = list()

/obj/structure/bird_statue/Initialize()
	. = ..()
	for(var/turf/open/available in range(12, src))
		var/obj/effect/niaojia_territory/territory = locate(/obj/effect/niaojia_territory) in available
		if(!territory)
			var/obj/effect/niaojia_territory/NT = new(available)
			territory_tiles += NT

/obj/structure/bird_statue/deconstruct(disassembled = TRUE)
	for(var/obj/effect/niaojia_territory/NT in territory_tiles)
		qdel(NT)
	. = ..()

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
		collected_meat += 2
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
	if(istype(I, /obj/item/food/meat/slab/worm)) //Easy match up and a lot of meat, nerf them.
		playsound(get_turf(src), 'sound/magic/enter_blood.ogg', 30, 1)
		to_chat(user, span_nicegreen("[src] reluctantly accepts your offering!"))
		collected_meat += 0.25
		qdel(I)
	if(istype(I, /obj/item/food/meat/slab/robot)) //Hard match up, reward them for taking it.
		playsound(get_turf(src), 'sound/magic/enter_blood.ogg', 30, 1)
		to_chat(user, span_nicegreen("[src] gleefully accepts your offering!"))
		collected_meat += 2
		qdel(I)
	if(istype(I, /obj/item/food/meat/slab)) //How would humans understand?
		playsound(get_turf(src), 'sound/magic/enter_blood.ogg', 30, 1)
		to_chat(user, span_nicegreen("[src] happily accepts your offering!"))
		collected_meat++
		qdel(I)
	if(istype(I, /obj/item/storage)) // Code for storage dumping
		var/obj/item/storage/S = I
		for(var/obj/item/IT in S)
			if(istype(IT, /obj/item/food/meat/slab/worm))
				playsound(get_turf(src), 'sound/magic/enter_blood.ogg', 30, 1)
				to_chat(user, span_nicegreen("[src] reluctantly accepts your offering!"))
				collected_meat += 0.5
				qdel(IT)
				continue

			if(istype(IT, /obj/item/food/meat/slab/robot))
				playsound(get_turf(src), 'sound/magic/enter_blood.ogg', 30, 1)
				to_chat(user, span_nicegreen("[src] gleefully accepts your offering!"))
				collected_meat += 2
				qdel(IT)
				continue

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
	var/statue_ask = alert("[src] awaits your demand.", "Oh dear ancient elder... If you can grant us a", "niaojia-ren salve (4 Meat)", "niaojia-ren banner (6 Meat)", "niaojia-ren revive (15 Meat)", "Cancel")
	if(statue_ask == "niaojia-ren salve (4 Meat)")
		if(collected_meat >= 4)
			to_chat(user, span_nicegreen("[src] understands your request, and grants your request!"))
			collected_meat -= 4
			new /obj/item/cuckoo_healing (get_turf(user))
		else
			to_chat(user, span_warning("[src] deines your request, it demands more flesh!"))
	else if(statue_ask == "niaojia-ren banner (6 Meat)")
		if(collected_meat >= 6)
			to_chat(user, span_nicegreen("[src] understands your request, and grants your request!"))
			collected_meat -= 6
			new /obj/item/cuckoo_banner (get_turf(user))
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

/obj/item/cuckoo_banner
	name = "niaojia-ren banner"
	desc = "A banner with the niaojia-ren's face on it. Use Z to place it down and mark your territory."
	icon = 'icons/obj/banner.dmi'
	icon_state = "banner_cuckoo"
	inhand_icon_state = "banner_cuckoo"
	attack_verb_continuous = list("forcefully inspires", "violently encourages", "relentlessly galvanizes")
	attack_verb_simple = list("forcefully inspire", "violently encourage", "relentlessly galvanize")
	lefthand_file = 'icons/mob/inhands/equipment/banners_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/banners_righthand.dmi'

/obj/item/cuckoo_banner/attack_self(mob/user)
	. = ..()
	if(!istype(user, /mob/living/carbon/human/species/cuckoospawn))
		to_chat(user, span_warning("You have no idea how this works!"))
		return FALSE
	for(var/obj/structure/destructible/cuckoo_banner/nearby_banner in range(5, src))
		to_chat(user, span_warning("You are too close to another banner, get father away from your banner!"))
		return
	var/turf/current_turf = get_turf(user)
	var/obj/effect/niaojia_territory/territory = locate(/obj/effect/niaojia_territory) in current_turf
	if(!territory)
		to_chat(user, span_warning("You are too far away from any territory, get closer to your banners!"))
		return
	to_chat(user, span_notice("You are planting the banner into the ground..."))
	if(do_after(user, 25, src))
		to_chat(user, span_nicegreen("You plant the banner into the ground!"))
		new /obj/structure/destructible/cuckoo_banner(get_turf(src))
		qdel(src)

/obj/structure/destructible/cuckoo_banner
	name = "niaojia-ren banner"
	desc = "A banner with the niaojia-ren's face on it. Nearby niaojia-ren will be inspired..."
	icon = 'icons/obj/banner.dmi'
	icon_state = "banner_cuckoo"
	anchored = TRUE
	density = FALSE
	layer = 3.1
	max_integrity = 50
	break_message = span_notice("The banner falls apart!")
	break_sound = 'sound/items/wirecutter.ogg'
	debris = list(/obj/item/cuckoo_banner = 1)
	var/list/territory_tiles = list()

/obj/structure/destructible/cuckoo_banner/Initialize()
	. = ..()
	create_territory()

/obj/structure/destructible/cuckoo_banner/attack_hand(mob/user)
	. = ..()
	if(!istype(user, /mob/living/carbon/human/species/cuckoospawn))
		to_chat(user, span_warning("You have no idea how this works!"))
		return FALSE
	to_chat(user, span_nicegreen("You touch the banner, causing it to update it's territory"))
	create_territory()

/obj/structure/destructible/cuckoo_banner/proc/create_territory()
	for(var/turf/open/available in range(12, src))
		var/obj/effect/niaojia_territory/territory = locate(/obj/effect/niaojia_territory) in available
		if(!territory)
			var/obj/effect/niaojia_territory/NT = new(available)
			territory_tiles += NT

/obj/structure/destructible/cuckoo_banner/deconstruct(disassembled = TRUE)
	for(var/obj/effect/niaojia_territory/NT in territory_tiles)
		qdel(NT)
	. = ..()

/obj/effect/niaojia_territory
	name = "niaojia territory"
	icon = 'icons/effects/weather_effects.dmi'
	icon_state = "heavy_fog"
	color = "#3b3b3b"
	mouse_opacity = FALSE
	alpha = 20
	anchored = TRUE

/obj/effect/niaojia_territory/Crossed(atom/movable/AM)
	. = ..()
	if(istype(AM, /mob/living/carbon/human/species/cuckoospawn))
		var/mob/living/carbon/human/species/cuckoospawn/cuckoo = AM
		if(cuckoo.has_status_effect(STATUS_EFFECT_HUNTER))
			return
		cuckoo.apply_status_effect(STATUS_EFFECT_HUNTER)
		return
	if(ishuman(AM))
		var/mob/living/carbon/human/human = AM
		if(human.has_status_effect(STATUS_EFFECT_PREY))
			return
		human.apply_status_effect(STATUS_EFFECT_PREY)

/datum/status_effect/prey
	id = "prey"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/prey

/atom/movable/screen/alert/status_effect/prey
	name = "Prey"
	desc = "You are in within the territory of the niaojia..."
	icon = 'icons/mob/cuckoospawn.dmi'
	icon_state = "bigoleyes"

/datum/status_effect/prey/on_apply()
	owner.become_nearsighted(TRAUMA_TRAIT)
	RegisterSignal(owner, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(Moved))
	return ..()

/datum/status_effect/prey/proc/Moved(mob/user, atom/new_location)
	SIGNAL_HANDLER
	var/turf/newloc_turf = get_turf(new_location)

	var/remove_prey = TRUE
	for(var/obj/effect/niaojia_territory/NT in newloc_turf)
		remove_prey = FALSE
	if(remove_prey)
		qdel(src)

/datum/status_effect/prey/on_remove()
	owner.cure_nearsighted(TRAUMA_TRAIT)
	UnregisterSignal(owner, COMSIG_MOVABLE_PRE_MOVE)
	return ..()

/datum/status_effect/hunter
	id = "hunter"
	status_type = STATUS_EFFECT_UNIQUE
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/hunter
	var/client/C
	var/initial_color

/atom/movable/screen/alert/status_effect/hunter
	name = "Hunter"
	desc = "You are in your own territory, and are buffed."
	icon = 'icons/mob/cuckoospawn.dmi'
	icon_state = "bigoleyes"

/datum/status_effect/hunter/on_apply()
	if(ismob(owner))
		var/mob/M = owner
		if(M.client)
			C = M.client
		else
			return

	if(!istype(C))
		return

	if(istype(owner, /mob/living/carbon/human/species/cuckoospawn))
		var/mob/living/carbon/human/species/cuckoospawn/bird_hunter = owner
		bird_hunter.physiology.red_mod = 0.2
		bird_hunter.physiology.white_mod = 0.5
		bird_hunter.physiology.black_mod = 0.2
		bird_hunter.physiology.pale_mod = 0.5
		to_chat(bird_hunter, span_nicegreen("As you enter your territory, you feel yourself strengthened..."))
	initial_color = C.color
	C.color = "#ffd1d1ff"
	RegisterSignal(owner, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(Moved))
	return ..()

/datum/status_effect/hunter/proc/Moved(mob/user, atom/new_location)
	SIGNAL_HANDLER
	var/turf/newloc_turf = get_turf(new_location)

	var/remove_hunter = TRUE
	for(var/obj/effect/niaojia_territory/NT in newloc_turf)
		remove_hunter = FALSE
	if(remove_hunter)
		qdel(src)

/datum/status_effect/hunter/on_remove()
	C.color = initial_color
	if(istype(owner, /mob/living/carbon/human/species/cuckoospawn))
		var/mob/living/carbon/human/species/cuckoospawn/bird_hunter = owner
		bird_hunter.physiology.red_mod = 0.7
		bird_hunter.physiology.white_mod = 1
		bird_hunter.physiology.black_mod = 0.7
		bird_hunter.physiology.pale_mod = 1.5
		to_chat(bird_hunter, span_warning("As you leave your territory, you feel yourself weaken..."))
	UnregisterSignal(owner, COMSIG_MOVABLE_PRE_MOVE)
	return ..()

#undef STATUS_EFFECT_HUNTER
#undef STATUS_EFFECT_PREY

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
			if(new_bird.revive(full_heal = TRUE, admin_revive = TRUE))
				new_bird.revive(full_heal = TRUE, admin_revive = TRUE)
				new_bird.grab_ghost(force = TRUE) // even suicides
				playsound(get_turf(src), 'sound/magic/enter_blood.ogg', 30, 1)
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
			qdel(src)

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
