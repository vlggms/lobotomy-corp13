/mob/living/simple_animal/hostile/abnormality/onesin
	name = "One Sin and Hundreds of Good Deeds"
	desc = "A giant skull that is attached to a cross, it wears a crown of thorns."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "onesin_halo_normal"
	icon_living = "onesin_halo_normal"
	portrait = "one_sin"
	maxHealth = 75
	health = 75
	damage_coeff = list(RED_DAMAGE = 1.5, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	melee_damage_lower = 2
	melee_damage_upper = 4
	melee_damage_type = WHITE_DAMAGE
	attack_sound = 'sound/abnormalities/onesin/onesin_attack.ogg'
	attack_verb_continuous = "smites"
	attack_verb_simple = "smite"
	is_flying_animal = TRUE
	threat_level = ZAYIN_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_INSIGHT = list(70, 70, 50, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = 70,
		ABNORMALITY_WORK_REPRESSION = list(50, 40, 30, 30, 30),
		"Confess" = 50,
	)
	work_damage_upper = 2
	work_damage_lower = 1
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/penitence,
		/datum/ego_datum/armor/penitence
	)
	gift_type = /datum/ego_gifts/penitence
	gift_message = "From this day forth, you shall never forget his words."
	abnormality_origin = ABNORMALITY_ORIGIN_LOBOTOMY

	grouped_abnos = list(
		/mob/living/simple_animal/hostile/abnormality/white_night = 5,
	)

	chem_type = /datum/reagent/abnormality/onesin
	harvest_phrase = span_notice("As you hold it up before %ABNO, holy light fills %VESSEL.")
	harvest_phrase_third = "%PERSON holds up %VESSEL, letting it be filled with holy light."

	observation_prompt = "It has great power. It is savior that will judge you, and executioner that will put you in your demise. <br>\
		In its eyes, you find... <br>(Technically, it has no eyes, so in its pitch-black holes you find...)"
	observation_choices = list(
		"Nothing" = list(TRUE, "Darkness. <br>\
			Nothing is there. Have you found the answers you were looking for?"),
		"You find yourself" = list(FALSE, "You are found. <br>\
			You have great power. <br>You willingly lift the axe for the greater good."),
	)

	var/halo_status = "onesin_halo_normal" //used for changing the halo overlays

	var/wn_work = FALSE

//Overlay stuff
/mob/living/simple_animal/hostile/abnormality/onesin/PostSpawn()
	..()
	update_icon()

/mob/living/simple_animal/hostile/abnormality/onesin/update_overlays()
	. = ..()
	. += "onesin" //by the nine this is too cursed

/mob/living/simple_animal/hostile/abnormality/onesin/WorkChance(mob/living/carbon/human/user, chance)
	if(istype(user.ego_gift_list[HAT], gift_type))
		return chance + 10
	if(GetWN())
		return 100
	return chance

/mob/living/simple_animal/hostile/abnormality/onesin/AttemptWork(mob/living/carbon/human/user, work_type)
	if(GetWN())
		if(work_type == "Confess")
			wn_work = TRUE
			user.status_flags |= GODMODE//We really don't want them to die mid work
			user.SetImmobilized(40, ignore_canstun = TRUE)
			for(var/mob/M in GLOB.player_list)
				if(M.client)
					M.playsound_local(get_turf(M), 'sound/abnormalities/onesin/confession_start.ogg', 25, 0)
		else
			to_chat(user, span_warning("The abnormality seems to be ignoring you... maybe try confessing."))
			return FALSE
	return TRUE

/mob/living/simple_animal/hostile/abnormality/onesin/SpeedWorktickOverride(mob/living/carbon/human/user, work_speed, init_work_speed, work_type) //THE RIDE NEVER ENDS
	if(wn_work)
		return 10
	return ..()

/mob/living/simple_animal/hostile/abnormality/onesin/Worktick(mob/living/carbon/human/user)
	if(wn_work)
		user.SetImmobilized(40, ignore_canstun = TRUE)
	return ..()

/mob/living/simple_animal/hostile/abnormality/onesin/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	wn_work = FALSE
	if(work_type == "Confess")
		var/mob/living/simple_animal/hostile/abnormality/white_night/WN = GetWN()
		if(WN)
			to_chat(WN, span_colossus("The twelfth has betrayed us..."))
			sound_to_playing_players('sound/abnormalities/whitenight/apostle_bell.ogg')
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(show_global_blurb), 20, "Have I not chosen you the Twelve? Yet one of you is a devil", 25))
			WN.loot = list() // No loot for you!
			WN.devil = user
			user.status_flags &= ~GODMODE
			sleep(1 SECONDS)
			for(var/i = 1 to 20)
				if(!WN || WN.stat == DEAD)
					break
				sleep(0.8 SECONDS)
				user.SetImmobilized(30, ignore_canstun = TRUE)
				playsound(get_turf(WN), 'sound/machines/clockcult/ark_damage.ogg', 75, TRUE, -1)
				var/obj/effect/temp_visual/onesin_blessing/OB = new(get_turf(WN))
				OB.layer = WN.layer + 0.1
				OB.pixel_x += rand(-6,6)
				WN.deal_damage(3330, PALE_DAMAGE)//Does 666 damage to WN
			sleep(5 SECONDS)
			for(var/mob/M in GLOB.player_list)
				if(M.client)
					M.playsound_local(get_turf(M), 'sound/abnormalities/onesin/confession_end.ogg', 50, 0)
			return

		else
			var/heal_chance = rand(2,pe)

			if(heal_chance > 1)
				flick("onesin_halo_good", src)
				new /obj/effect/temp_visual/onesin_blessing(get_turf(user))
				user.adjustBruteLoss(-user.maxHealth)
				user.adjustSanityLoss(-user.maxSanity)
			else
				flick("onesin_halo_bad", src)
				new /obj/effect/temp_visual/onesin_punishment(get_turf(user))
				user.adjustSanityLoss(user.maxSanity/2)
				playsound(get_turf(user), 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 33, 1)

			playsound(get_turf(user), 'sound/abnormalities/onesin/confession_end.ogg', 50, 0)
	return ..()

/mob/living/simple_animal/hostile/abnormality/onesin/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(work_type != "Confess")
		new /obj/effect/temp_visual/onesin_blessing(get_turf(user))
		user.adjustSanityLoss(-user.maxSanity * 0.5) // It's healing
	if(pe >= datum_reference.max_boxes)
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(H.z != z)
				continue
			if(H == user)
				continue
			new /obj/effect/temp_visual/onesin_blessing(get_turf(H))
			var/heal_factor = 0.5
			if(H.sanity_lost)
				heal_factor = 0.25
			H.adjustSanityLoss(-H.maxSanity * heal_factor)

/mob/living/simple_animal/hostile/abnormality/onesin/BreachEffect(mob/living/carbon/human/user, breach_type)
	if(breach_type == BREACH_MINING)
		update_icon()
		return ..()
	return FALSE // If someone wants him to breach for SOME REASON in the future, then exclude breach_type == BREACH_PINK

/mob/living/simple_animal/hostile/abnormality/onesin/AttackingTarget(atom/attacked_target)
	..()
	new /obj/effect/temp_visual/onesin_punishment(get_turf(attacked_target))

/mob/living/simple_animal/hostile/abnormality/onesin/proc/GetWN()
	var/mob/living/simple_animal/hostile/abnormality/white_night/WN = locate() in GLOB.abnormality_mob_list
	if(WN)
		if(WN.status_flags & GODMODE)
			return
		return WN
	return

/datum/reagent/abnormality/onesin
	name = "Holy Light"
	description = "It's calming, even if you can't quite look at it straight."
	color = "#eff16d"
	sanity_restore = -2
	special_properties = list("may alter sanity of those near the subject")

/datum/reagent/abnormality/onesin/on_mob_life(mob/living/L)
	for(var/mob/living/carbon/human/nearby in livinginview(9, get_turf(L)))
		nearby.adjustSanityLoss(-1)
	return ..()
