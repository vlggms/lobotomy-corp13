/mob/living/simple_animal/hostile/abnormality/shy_look
	name = "Today's Shy Look"
	desc = "A humanoid abnormality that's hiding behind what appears to be human skin that's ecthed with 5 different expressions.  \
	You have a strange urge to look behind the net of skin. But getting a bad feeling, you decide to stop."
	icon = 'icons/mob/shy_look.dmi'
	icon_state = "neutral"
	icon_living = "neutral"

	pixel_x = -16
	base_pixel_x = -16

	maxHealth = 2000
	health = 2000
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 0.1, WHITE_DAMAGE = 0.1, BLACK_DAMAGE = 0.1, PALE_DAMAGE = 0.1)
	ranged = TRUE
	melee_damage_lower = 40
	melee_damage_upper = 60
	attack_verb_simple = "kick"
	attack_verb_continuous = "kicks"
	friendly_verb_continuous = "punts"
	friendly_verb_simple = "punt"
	stat_attack = HARD_CRIT

	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 45, 45, 40, 40),
		ABNORMALITY_WORK_INSIGHT = list(50, 45, 45, 40, 40),
		ABNORMALITY_WORK_ATTACHMENT = list(50, 45, 45, 40, 40),
		ABNORMALITY_WORK_REPRESSION = list(50, 45, 45, 40, 40)
		)
	work_damage_amount = 8
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/shy,
		/datum/ego_datum/armor/shy
		)
	gift_type =  /datum/ego_gifts/shy

	var/chance_modifier = 1
	var/previous_mood
	var/next_mood
	var/mood_cooldown
	var/breach_mood = 1 // 1-5, 5 happiest, 1 angriest
	var/list/breached_moods = list()
	var/obj/item/clothing/mask/shy_look/current_mask = null
	var/can_act = TRUE
	var/scream_cooldown = null
	var/scream_damage = 20
	COOLDOWN_DECLARE(scream)

/mob/living/simple_animal/hostile/abnormality/shy_look/Initialize(mapload)
	. = ..()
	breached_moods = list(
		mutable_appearance('icons/effects/32x64.dmi', "shy_pissed", -HALO_LAYER),
		mutable_appearance('icons/effects/32x64.dmi', "shy_sad", -HALO_LAYER),
		mutable_appearance('icons/effects/32x64.dmi', "shy_neutral", -HALO_LAYER),
		mutable_appearance('icons/effects/32x64.dmi', "shy_happy", -HALO_LAYER),
		mutable_appearance('icons/effects/32x64.dmi', "shy_ecstatic", -HALO_LAYER)
	)

/mob/living/simple_animal/hostile/abnormality/shy_look/work_chance(mob/living/carbon/human/user, chance)
	return chance * chance_modifier

/mob/living/simple_animal/hostile/abnormality/shy_look/Life()
	. = ..()
	if(!(status_flags & GODMODE))
		return
	if(mood_cooldown < world.time && !datum_reference.working)
		ChangeMood()

/mob/living/simple_animal/hostile/abnormality/shy_look/proc/ChangeMood()
	next_mood = rand(1, 5)
	switch(next_mood)
		if(1) //From Smiling to angry
			chance_modifier = 1.3
			work_damage_amount = initial(work_damage_amount)*0.5
		if(2)
			chance_modifier = 1.1
			work_damage_amount = initial(work_damage_amount)
		if(3)
			chance_modifier = 1
			work_damage_amount = initial(work_damage_amount)
		if(4)
			chance_modifier = 0.7
			work_damage_amount = initial(work_damage_amount)*1.5
		if(5)
			chance_modifier = 0.5
			work_damage_amount = initial(work_damage_amount)*2
	ChangeIcon()

/mob/living/simple_animal/hostile/abnormality/shy_look/proc/ChangeIcon()
	// This nonsense code is for animating within the game. Byond doesn't let you pick frames from an animated icon, so I had to make a loop with sleep in between
	var/p = previous_mood
	var/n = next_mood
	if(p < n)
		for(p, p<n, p++)
			icon_state = num2text(p, 1)
			sleep(2)
	if(p > n)
		n = (n-1)
		p = (p-1)
		for(p, n<p, p--)
			icon_state = num2text(p, 1)
			sleep(2)
	switch(next_mood)
		if(1)
			icon_state = "smiling"
		if(2)
			icon_state = "happy"
		if(3)
			icon_state = "neutral"
		if(4)
			icon_state = "sad"
		if(5)
			icon_state = "angry"
	previous_mood = next_mood
	var/mood_cooldown_time = rand(2, 5) SECONDS
	mood_cooldown = world.time + mood_cooldown_time

/mob/living/simple_animal/hostile/abnormality/shy_look/work_complete(mob/living/carbon/human/user, work_type, pe)
	if(previous_mood == 1 && pe > 0) // heals 20% hp&sp
		user.adjustSanityLoss(0.2*user.maxSanity)
		user.adjustBruteLoss(-0.2*user.maxHealth)
	if(previous_mood == 2 && pe > 0)
		user.adjustSanityLoss(0.2*user.maxSanity)
	ChangeMood() //Prevents spamming work on the same mood
	return ..()

/mob/living/simple_animal/hostile/abnormality/shy_look/breach_effect(mob/living/carbon/human/user)
	. = ..()
	src.add_overlay(breached_moods[1])
	current_mask = new /obj/item/clothing/mask/shy_look/sad(get_turf(pick(GLOB.xeno_spawn)))
	scream_cooldown = 15 SECONDS
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "bill" // We love bill
	pixel_x = 0
	base_pixel_x = 0

/mob/living/simple_animal/hostile/abnormality/shy_look/Move()
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/shy_look/Moved()
	. = ..()
	switch(breach_mood)
		if(1)
			playsound(get_turf(src), 'sound/abnormalities/nothingthere/walk.ogg', 50, 0, 3) // Angrily stomping around
		if(2)
			playsound(get_turf(src), 'sound/abnormalities/nothingthere/walk.ogg', 25, 0, 3) // Calming down a bit
	return // No others play walking sounds.

/mob/living/simple_animal/hostile/abnormality/shy_look/OpenFire(atom/A)
	if(COOLDOWN_FINISHED(src, scream) && (breach_mood < 3) && can_act)
		COOLDOWN_START(src, scream, scream_cooldown)
		Scream()
	return

/mob/living/simple_animal/hostile/abnormality/shy_look/MeleeAction(patience)
	if(!can_act)
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/abnormality/shy_look/AttackingTarget(atom/attacked_target)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.body_position == LYING_DOWN) // CURB STOMP
			step_towards(src, H)
			melee_damage_lower *= 2
			melee_damage_upper *= 2
			. = ..()
			melee_damage_lower /= 2
			melee_damage_upper /= 2
			H.visible_message("<span class='danger'>[src] stomps on [H]'s head!</span>", "<span class='userdanger'>[src] stomps on your head!</span>")
			if(H.stat == DEAD || H.health < 0)
				var/obj/item/bodypart/head = H.get_bodypart(HEAD)
				if(head)
					head.dismember()
					H.regenerate_icons()
					new /obj/effect/gibspawner/human/bodypartless(get_turf(H))
					QDEL_NULL(head)
			return
		else if(breach_mood < 4)
			melee_damage_lower /= 2
			melee_damage_upper /= 2
			. = ..()
			melee_damage_lower *= 2
			melee_damage_upper *= 2
			if(prob(50/breach_mood))
				H.Knockdown(13, FALSE)
				H.visible_message("<span class='danger'>[src] smashes [H]'s leg in!</span>", "<span class='userdanger'>[src] smashes your leg, knocking you down!</span>")
			return
	return ..()


/mob/living/simple_animal/hostile/abnormality/shy_look/proc/Scream()
	can_act = FALSE
	playsound(get_turf(src), 'sound/voice/human/femalescream_3.ogg', 35*(3-breach_mood), 0, 4)
	for(var/i = 1 to 8)
		new /obj/effect/temp_visual/fragment_song(get_turf(src))
		playsound(get_turf(src), 'sound/abnormalities/nothingthere/walk.ogg', 40, 0, 3) // throwing a temper trantrum
		for(var/mob/living/L in view(8, src))
			if(faction_check_mob(L, FALSE))
				continue
			if(L.stat == DEAD)
				continue
			L.apply_damage(scream_damage, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		SLEEP_CHECK_DEATH(3)
	can_act = TRUE

/mob/living/simple_animal/hostile/abnormality/shy_look/attacked_by(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/clothing/mask/shy_look))
		BreachedMoodChange() // This means you can technically use duplicates but....
		QDEL_NULL(I)
		return
	. = ..()

/mob/living/simple_animal/hostile/abnormality/shy_look/proc/BreachedMoodChange()
	src.cut_overlay(breached_moods[breach_mood])
	breach_mood++
	src.add_overlay(breached_moods[breach_mood])
	melee_damage_upper -= 10
	melee_damage_lower -= 10
	for(var/dam_type in damage_coeff)
		if(dam_type == BRUTE)
			continue
		damage_coeff[dam_type] *= 2
	switch(breach_mood)
		if(2)
			current_mask = new /obj/item/clothing/mask/shy_look/neutral(get_turf(pick(GLOB.xeno_spawn)))
			scream_cooldown = 45 SECONDS
			scream_damage /= 2
		if(3)
			current_mask = new /obj/item/clothing/mask/shy_look/happy(get_turf(pick(GLOB.xeno_spawn)))
		if(4)
			current_mask = new /obj/item/clothing/mask/shy_look/ecstatic(get_turf(pick(GLOB.xeno_spawn)))
			ranged = FALSE

/mob/living/simple_animal/hostile/abnormality/shy_look/death(gibbed)
	QDEL_NULL(current_mask)
	. = ..()

/obj/item/clothing/mask/shy_look
	name = "Skin Mask"
	desc = "Oh, that's really gross... Is she looking for this?"
	icon = 'icons/obj/clothing/masks.dmi'
	worn_icon = 'icons/mob/clothing/mask.dmi'
	lefthand_file = null
	righthand_file = null
	inhand_icon_state = null
	//These are mostly cosmetic if you wanna wear them but otherwise they're for suppression.

/obj/item/clothing/mask/shy_look/sad
	icon_state = "shy_sad"
	worn_icon_state = "shy_sad"

/obj/item/clothing/mask/shy_look/neutral
	icon_state = "shy_neutral"
	worn_icon_state = "shy_neutral"

/obj/item/clothing/mask/shy_look/happy
	icon_state = "shy_happy"
	worn_icon_state = "shy_happy"

/obj/item/clothing/mask/shy_look/ecstatic
	icon_state = "shy_ecstatic"
	worn_icon_state = "shy_ecstatic"
