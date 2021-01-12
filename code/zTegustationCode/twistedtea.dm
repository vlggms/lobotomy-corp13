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
	var/max_water = 20
	attack_verb_continuous = list("obliterates", "destroys")
	attack_verb_simple = list("obliterate", "destroy")
	var/power = 5 //Maximum distance launched water will travel
	var/precision = TRUE
	var/chem = /datum/reagent/water
	var/tanktype = /obj/structure/reagent_dispensers/watertank
	var/broken = FALSE


/obj/item/melee/twistedtea/proc/refill()
	if(!chem)
		return
	create_reagents(max_water, AMOUNT_VISIBLE)
	reagents.add_reagent(chem, max_water)		


/obj/item/melee/twistedtea/Initialize()
	. = ..()
	refill()
	
	
/obj/item/melee/twistedtea/attack(mob/living/target, mob/living/user)
	. = ..()
	
	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		return
	
	if(broken)
		to_chat(usr, "<span class='warning'>\The [src]'s igniter has been used and is no longer functional.</span>")
		return
	
	if (src.reagents.total_volume < max_water) // Just in case we somehow get rid of the water
		to_chat(usr, "<span class='warning'>\The [src] does not contain enough water!</span>")
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
	var/list/the_targets = list(T,T1,T2)
	if(precision)
		var/turf/T3 = get_step(T1, turn(direction, 90))
		var/turf/T4 = get_step(T2,turn(direction, -90))
		the_targets.Add(T3,T4)

	var/list/water_particles=list()
	for(var/a=0, a<max_water, a++)
		var/obj/effect/particle_effect/water/W = new /obj/effect/particle_effect/water(get_turf(src))
		var/my_target = pick(the_targets)
		water_particles[W] = my_target
		var/datum/reagents/R = new/datum/reagents(5)
		W.reagents = R
		R.my_atom = W
		reagents.trans_to(W,1, transfered_by = user)

	//Make em move dat ass, hun
	addtimer(CALLBACK(src, /obj/item/melee/twistedtea/proc/move_particles, water_particles), 2)	
	
	broken = TRUE



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
		addtimer(CALLBACK(src, /obj/item/melee/twistedtea/proc/move_particles, particles, repetition), 2)



/obj/item/melee/twistedtea/examine(mob/user)
	. = ..()
	
	if(broken)
		. += "It has already been used and no longer functions."
		
		

/obj/item/melee/twistedtea/suicide_act(mob/user)	
	if(broken)
		user.visible_message("<span class='suicide'>[user] stuffs [src] into [user.p_their()] mouth! It looks like [user.p_theyre()] trying to commit suicide... but nothing happens.</span>")
		return SHAME
		
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/brain/B = H.getorgan(/obj/item/organ/brain)
	
	user.visible_message("<span class='suicide'>[user] stuffs [src] into [user.p_their()] mouth and pulls on the tab. It looks like [user.p_theyre()] trying to commit suicide!</span>")
	
	
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

//***********************************************************
//**** Twisted Tea - Glubtok, Jan 2021 - END
//***********************************************************
