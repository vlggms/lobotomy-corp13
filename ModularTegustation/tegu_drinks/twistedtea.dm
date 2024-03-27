//***********************************************************
//**** Twisted Tea - Glubtok, Jan 2021
//***********************************************************


/obj/item/melee/twistedtea
	name = "Twisted Tea"
	desc = "A single-use, non-lethal incapacitation device."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "sodawater"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	inhand_icon_state = "sodawater"
	w_class = WEIGHT_CLASS_SMALL
	hitsound = 'sound/weapons/teasmack.ogg'
	force = 0
	wound_bonus = -10
	throwforce = 0
	attack_verb_continuous = list("obliterates", "destroys")
	attack_verb_simple = list("obliterate", "destroy")
	var/attack_verb_continuous_broken = list("taps", "hits", "pokes")
	var/attack_verb_simple_broken = list("tap", "hit", "poke")
	var/power = 5 //Maximum distance launched water will travel
	var/broken = FALSE
	var/unlimiteduse = FALSE
	var/chem = /datum/reagent/water
	var/broken_icon = 'icons/obj/janitor.dmi'
	var/broken_icon_state = "sodawater"



//Some variants:

/obj/item/melee/twistedtea/clownops
	name = "SpaceLube Tea"
	desc = "A single-use, non-lethal incapacitation device. This syndicate-manufactured version is filled with a pressurized payload of space-lube."
	chem = /datum/reagent/lube
	unlimiteduse = FALSE
	power = 10

/obj/item/melee/twistedtea/incendiary
	name = "Incendiary Tea"
	desc = "Temporarily incapacitates a target while spraying an incendiary liquid in front of you."
	chem = /datum/reagent/phlogiston
	unlimiteduse = FALSE

/obj/item/melee/twistedtea/unlimited
	name = "Bottomless Twisted Tea"
	desc = "An unlimited-use, non-lethal incapacitation device. This is a really bad idea..."
	unlimiteduse = TRUE





//Throws broken item away
/obj/item/melee/twistedtea/attack_self(mob/user)
	if(!broken)
		return
	to_chat(usr, span_warning("You crumple up and throw away the [src]."))
	qdel(src)





/obj/item/melee/twistedtea/attack(mob/living/target, mob/living/user)
	. = ..()

	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		return

	if(broken)
		to_chat(usr, span_warning("The [src] has been used and is no longer functional."))
		return

	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	var/obj/item/bodypart/affecting = target.get_bodypart(BODY_ZONE_CHEST)
	var/armor_block = target.run_armor_check(affecting, MELEE)

	target.apply_damage(rand(40,50), STAMINA, affecting, armor_block)
	target.Knockdown(90)

	playsound(src, hitsound, 60, TRUE)

	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user)

	playsound(src.loc, 'sound/effects/extinguish.ogg', 60, TRUE, -3)

	var/direction = get_dir(user,target)

	//Get all the turfs that can be shot at
	var/turf/T = get_turf(target.loc)
	var/turf/T1 = get_step(T,turn(direction, 90))
	var/turf/T2 = get_step(T,turn(direction, -90))
	var/turf/T3 = get_step(T1,turn(direction, 90))
	var/turf/T4 = get_step(T2,turn(direction, -90))
	var/list/the_targets = list(T,T1,T2,T3,T4)

	var/list/reagent_particles=list()
	for(var/a=0, a<5, a++)
		var/obj/effect/particle_effect/water/W = new /obj/effect/particle_effect/water(get_turf(src))
		var/my_target = pick(the_targets)
		reagent_particles[W] = my_target
		var/datum/reagents/R = new/datum/reagents(5)
		W.reagents = R
		R.my_atom = W
		W.reagents.add_reagent(chem, 1)

	//Make em move dat ass, hun
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/melee/twistedtea, move_particles), reagent_particles), 2)

	if(!unlimiteduse)
		broken = TRUE
		name = "Broken " + name
		icon = broken_icon
		icon_state = broken_icon_state
		attack_verb_continuous = attack_verb_continuous_broken
		attack_verb_simple = attack_verb_simple_broken




//Particle movement loop
/obj/item/melee/twistedtea/proc/move_particles(list/particles, repetition=0)
	//Check if there's anything in here first
	if(!particles || particles.len == 0)
		return
	// Second loop: Get all the water particles and make them move to their target
	for(var/obj/effect/particle_effect/water/W in particles)
		var/turf/my_target = particles[W]
		if(!W)
			continue
		step_towards(W,my_target)
		if(!W.reagents)
			continue
		W.reagents.expose(get_turf(W))
		for(var/A in get_turf(W))
			W.reagents.expose(A)
		if(W.loc == my_target)
			particles -= W
	if(repetition < power)
		repetition++
		addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/melee/twistedtea, move_particles), particles, repetition), 2)





/obj/item/melee/twistedtea/examine(mob/user)
	. = ..()

	if(broken)
		. += "It has already been used and no longer functions."





/obj/item/melee/twistedtea/suicide_act(mob/user)
	if(broken)
		user.visible_message(span_suicide("[user] stuffs [src] into [user.p_their()] mouth! It looks like [user.p_theyre()] trying to commit suicide... but nothing happens."))
		return SHAME

	var/mob/living/carbon/human/H = user
	var/obj/item/organ/brain/B = H.getorgan(/obj/item/organ/brain)

	user.visible_message(span_suicide("[user] stuffs [src] into [user.p_their()] mouth and pulls on the tab. It looks like [user.p_theyre()] trying to commit suicide!"))


	playsound(src, hitsound, 60, TRUE)
	add_fingerprint(user)
	sleep(3)

	qdel(src)

	if (!QDELETED(H))
		if(!QDELETED(B))
			H.internal_organs -= B
			qdel(B)
		new /obj/effect/gibspawner/generic(H.drop_location(), H)
		return (BRUTELOSS)





//Crafting recipes

/datum/crafting_recipe/twistedtea
	name = "Twisted Tea"
	result = /obj/item/melee/twistedtea
	reqs = list(/datum/reagent/fuel = 30,
				/datum/reagent/water = 20,
				/obj/item/reagent_containers/food/drinks/soda_cans = 1,
				/obj/item/assembly/igniter = 1)
	time = 15
	category = CAT_WEAPONRY
	subcategory = CAT_WEAPON




//Uplink data

/datum/uplink_item/dangerous/spacelubetea
	name = "SpaceLube Tea"
	desc = "A special twisted tea filled with a pressurized space lube payload."
	cost = 2
	item = /obj/item/melee/twistedtea/clownops
	surplus = 0
	include_modes = list(/datum/game_mode/nuclear/clown_ops)


/datum/uplink_item/dangerous/incendiarytea
	name = "Incendiary Tea"
	desc = "A special twisted tea filled with a pressurized phlogiston payload."
	cost = 2
	item = /obj/item/melee/twistedtea/incendiary
	surplus = 0


//***********************************************************
//**** Twisted Tea - Glubtok, Jan 2021 - END
//***********************************************************
