//Coded by Coxswain, sprite by Mel
/mob/living/simple_animal/hostile/abnormality/beanstalk
	name = "Beanstalk without Jack"
	desc = "A gigantic stem that reaches higher than the eye can see."
	icon = 'ModularTegustation/Teguicons/64x98.dmi'
	icon_state = "beanstalk"
	portrait = "beanstalk"
	maxHealth = 500
	health = 500
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(35, 45, 55, 0, 10),
		ABNORMALITY_WORK_INSIGHT = 55,
		ABNORMALITY_WORK_ATTACHMENT = 55,
		ABNORMALITY_WORK_REPRESSION = 35,
	)
	pixel_x = -16
	base_pixel_x = -16
	work_damage_amount = 7
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/bean,
		/datum/ego_datum/weapon/giant,
		/datum/ego_datum/armor/bean,
	)
	gift_type = /datum/ego_gifts/bean
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

	observation_prompt = "You remember an employee was obsessed with this abnormality. <br>\"\
		If you reach the top, you'll find what you've been looking for!\", He'd tell every employee. <br>\
		One day he did climb the beanstalk, and never came back down. <br>Perhaps he's doing okay up there."
	observation_choices = list("Climb the beanstalk", "Chop it down")
	correct_choices = list("Chop it down") //TODO: Make this event a bit special
	observation_success_message = "If something's too big to understand, it's too big to be allowed to exist. The axe bites into the stem..."
	observation_fail_message = "You begin to climb the beanstalk, but no matter how much you climb there's always more stalk. You peer at the clouds, squinting your eyes, but still can't see anyone..."

	var/climbing = FALSE
	var/giant_countdown = 0

//Performing instinct work at >4 fortitude starts a special work
/mob/living/simple_animal/hostile/abnormality/beanstalk/AttemptWork(mob/living/carbon/human/user, work_type)
	if((get_attribute_level(user, FORTITUDE_ATTRIBUTE) >= 80) && (work_type == ABNORMALITY_WORK_INSTINCT))
		work_damage_amount = 25 //hope you put on some armor
		climbing = TRUE
	return TRUE

//When working at <2 Temperance and Prudence, or when panicking it is an instant death.
/mob/living/simple_animal/hostile/abnormality/beanstalk/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(get_attribute_level(user, TEMPERANCE_ATTRIBUTE) < 40 && get_attribute_level(user, PRUDENCE_ATTRIBUTE) < 40 || user.sanity_lost)
		user.Stun(30 SECONDS)
		step_towards(user, src)
		sleep(0.5 SECONDS)
		if(QDELETED(user))
			return
		step_towards(user, src)
		sleep(0.5 SECONDS)
		if(QDELETED(user))
			return
		animate(user, alpha = 0,pixel_x = 0, pixel_z = 16, time = 3 SECONDS)
		to_chat(user, span_userdanger("You will make it to the top, no matter what!"))
		QDEL_IN(user, 3.5 SECONDS)

//The special work, if you survive you get a powerful EGO gift.
	if(climbing)
		if(user.sanity_lost || user.stat >= SOFT_CRIT || user.stat == DEAD)
			work_damage_amount = 7
			climbing = FALSE
			return

		user.Stun(3 SECONDS)
		step_towards(user, src)
		sleep(0.5 SECONDS)
		if(QDELETED(user))
			work_damage_amount = 7
			climbing = FALSE
			return
		step_towards(user, src)
		sleep(0.5 SECONDS)
		if(QDELETED(user))
			work_damage_amount = 7
			climbing = FALSE
			return
		to_chat(user, span_userdanger("You start to climb!"))
		animate(user, alpha = 1,pixel_x = 0, pixel_z = 16, time = 3 SECONDS)
		user.pixel_z = 16
		user.Stun(10 SECONDS)
		sleep(6 SECONDS)
		if(QDELETED(user))
			work_damage_amount = 7
			climbing = FALSE
			return
		var/datum/ego_gifts/giant/BWJEG = new
		BWJEG.datum_reference = datum_reference
		user.Apply_Gift(BWJEG)
		animate(user, alpha = 255,pixel_x = 0, pixel_z = -16, time = 3 SECONDS)
		user.pixel_z = 0
		to_chat(user, span_userdanger("You return with the giant's treasure!"))
		INVOKE_ASYNC(src, PROC_REF(Check_Treasure_Count), user)

	work_damage_amount = 7
	climbing = FALSE

/mob/living/simple_animal/hostile/abnormality/beanstalk/proc/Check_Treasure_Count(mob/living/carbon/human/user)
	giant_countdown += 1
	switch(giant_countdown)
		if(1)
			//change this to a sack of gold coins, or something to that effect
			new /obj/item/coin/gold(get_turf(user))
		if(2)
			var/obj/structure/musician/harp_magic/H = new(get_turf(user))
			H.say("Help master! A boy is stealing me!")
		if(3)
			new /mob/living/simple_animal/hostile/retaliate/goose/golden(get_turf(user))
			sleep(3 SECONDS)
			var/mob/living/simple_animal/hostile/abnormality/giant/G = new(get_turf(src))
			visible_message(span_boldwarning("You hear leaves rustling far above the cell!"))
			G.TryJump(user)
			for(var/mob/M in GLOB.player_list)
				var/check_z = M.z
				if(isatom(M.loc))
					check_z = M.loc.z // So it plays even when you are in a locker/sleeper
				if((check_z == z) && M.client)
					to_chat(M, span_userdanger("Fee-fi-fo-fum, I smell the blood of an Englishman! Be he alive, be he dead, I'll grind his bones to make my bread!"))

/datum/ego_gifts/giant
	name = "Giant"
	icon_state = "giant"
	fortitude_bonus = 8
	slot = LEFTBACK

/mob/living/simple_animal/hostile/retaliate/goose/golden
	name = "a goose that lays golden eggs"
	desc = "We're rich!"
	var/egg_type = /obj/item/food/egg/golden
	health = 1500
	maxHealth = 1500
	faction = list("passive")
	random_retaliate = FALSE
	var/eggsleft = 3
	var/eggsFertile = FALSE
	var/list/layMessage = EGG_LAYING_MESSAGES
	var/attr_list = list()
	var/list/feedMessages = list("She honks happily.")
	food_type = list(/obj/item/food/grown/wheat, /obj/item/food/breadslice)

/mob/living/simple_animal/hostile/retaliate/goose/golden/attackby(obj/item/O, mob/user, params)//re-used chicken code
	if(is_type_in_list(O, food_type))
		if(!stat && eggsleft < 8)
			var/feedmsg = "[user] feeds [O] to [name]! [pick(feedMessages)]"
			user.visible_message(feedmsg)
			qdel(O)
			eggsleft += 0.2
		else
			to_chat(user, span_warning("[name] doesn't seem hungry!"))
	else
		..()

/mob/living/simple_animal/hostile/retaliate/goose/golden/Life()
	. =..()
	if(!.)
		return
	if((!stat && prob(3) && eggsleft > 0) && egg_type)
		visible_message(span_alertalien("[src] [pick(layMessage)]"))
		eggsleft--
		var/obj/item/E = new egg_type(get_turf(src))
		E.pixel_x = rand(-6,6)
		E.pixel_y = rand(-6,6)
		if(eggsFertile)
			START_PROCESSING(SSobj, E)

//*** Treasures ***//
/obj/item/food/egg/golden
	name = "golden egg"
	desc = "A golden egg!"
	icon_state = "goldenegg"
	food_reagents = list(/datum/reagent/consumable/eggyolk = 5, /datum/reagent/abnormality/ambrosia = 5)
	tastes = list("your favorite food" = 4, "childhood memories" = 1)
	microwaved_type = /obj/item/food/boiledegg
	foodtypes = MEAT
	w_class = WEIGHT_CLASS_TINY
	var/stat_bonus = 5

/obj/item/food/egg/golden/attack_self(mob/living/user)//_attribute.dm for references to these procs
	var/mob/living/carbon/human/H = user
	if(!ishuman(user))
		return
	var/atr_list = shuffle(H.attributes)
	for(var/atr_type in atr_list)//generate a random list of attributes. You want this every time an egg is used to it picks random attributes.
		var/datum/attribute/atr = H.attributes[atr_type]
		if(!istype(atr))
			continue
		if(atr.level >= 130)//too high? go for the next random attribute
			continue
		if(atr.level_limit < 130)
			atr.level_limit += stat_bonus
		if(atr.adjust_level(H, stat_bonus))
			to_chat(H, span_nicegreen("You eat the delicious [src], raising your [atr] attribute by [stat_bonus]!"))
			qdel(src)
			return
	to_chat(H, span_warning("Your attributes are too high for the [src] to benefit you."))

/obj/item/food/egg/golden/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!..()) //was it caught by a mob?
		var/turf/T = get_turf(hit_atom)
		new /obj/effect/decal/cleanable/food/egg_smudge(T)
		reagents.expose(hit_atom, TOUCH)
		qdel(src)

/obj/structure/musician/harp_magic
	name = "magical harp"
	desc = "A magical harp that can continue playing while unattended. It may impose beneficial effects on its listeners."
	icon = 'icons/obj/musician.dmi'
	icon_state = "harp"
	anchored = FALSE
	density = TRUE
	allowed_instrument_ids = list("sine")
	can_play_unanchored = TRUE
	var/is_healing

/obj/structure/musician/harp_magic/interact(mob/user)//Janky, just like instrument code!
	..()
	INVOKE_ASYNC(src, PROC_REF(healing_pulse),user)

/obj/structure/musician/harp_magic/proc/healing_pulse(mob/living/user)
	if(is_healing)
		return
	is_healing = TRUE
	while(song.playing == TRUE)
		for(var/mob/living/carbon/human/H in view(15))
			H.adjustSanityLoss(-1)
		sleep(1 SECONDS)
	is_healing = FALSE
