//Coded by Coxswain
#define SPHINX_GAZE_COOLDOWN (12 SECONDS)

/mob/living/simple_animal/hostile/abnormality/sphinx
	name = "Sphinx"
	desc = "A gigantic stone feline."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "sphinx"
	icon_living = "sphinx"
	var/icon_aggro = "sphinx_eye"
	portrait = "sphinx"
	speak_emote = list("intones")
	pixel_x = -16
	base_pixel_x = -16
	ranged = TRUE
	maxHealth = 2000
	health = 2000
	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.8, PALE_DAMAGE = 1.5)
	stat_attack = HARD_CRIT
	move_to_delay = 4
	melee_damage_lower = 70
	melee_damage_upper = 100
	attack_sound = 'sound/abnormalities/sphinx/attack.ogg'
	attack_action_types = list(/datum/action/cooldown/sphinx_gaze)
	can_breach = TRUE
	threat_level = WAW_LEVEL
	melee_damage_type = WHITE_DAMAGE
	start_qliphoth = 3
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 35, 35, 40),
		ABNORMALITY_WORK_INSIGHT = list(20, 30, 45, 50, 50),
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 25, 30, 30),
		"Riddle" = 0,		//These should never be used, but they're here for clarity.
		"Make Offering" = 0,
	)
	work_damage_amount = 12
	work_damage_type = WHITE_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/pharaoh,
		/datum/ego_datum/armor/pharaoh,
	)
	gift_type =  /datum/ego_gifts/pharaoh
	abnormality_origin = ABNORMALITY_ORIGIN_ARTBOOK

	//work-related
	var/happy = FALSE
	var/demand
	var/work_cooldown
	var/work_cooldown_time = 3 SECONDS
	var/list/worked = list()
	var/list/satisfied = list(
		"Ipi etog sind lemanto.", //You mind big human
		"Lemantinco kom geng kaskihir etog!", //(Human-honor) show has (not-lazy) mind
	)
	var/list/angry = list(
		"Mi cadu cef ipi por sagmo!", //I king threat you beggar begone
		"Mi thran lemantolly quistramos!", //I angry stupid man (body-coin)
	)
	var/list/translate = list(
		"Ipi etog geng quir.", //You mind paper translate
		"Ipi inspuz geng quir.", //You quest paper translate
	)
	var/list/riddleloot = list(
		/obj/item/golden_needle,
		/obj/item/canopic_jar,
	)
	var/list/demandlist = list(
		/obj/item/clothing/suit/armor/ego_gear,
		/obj/item/ego_weapon,
		/obj/item/reagent_containers/food/drinks,
		/obj/item/food,
	)

	//breach
	var/can_act = TRUE
	var/curse_cooldown
	var/curse_cooldown_time = 12 SECONDS

//Playables buttons
/datum/action/cooldown/sphinx_gaze
	name = "Sphinx's Gaze"
	icon_icon = 'icons/mob/actions/actions_abnormality.dmi'
	button_icon_state = "sphinx"
	check_flags = AB_CHECK_CONSCIOUS
	transparent_when_unavailable = TRUE
	cooldown_time = SPHINX_GAZE_COOLDOWN //12 seconds

/datum/action/cooldown/sphinx_gaze/Trigger()
	if(!..())
		return FALSE
	if(!istype(owner, /mob/living/simple_animal/hostile/abnormality/sphinx))
		return FALSE
	var/mob/living/simple_animal/hostile/abnormality/sphinx/sphinx = owner
	if(sphinx.IsContained()) // No more using cooldowns while contained
		return FALSE
	StartCooldown()
	sphinx.StoneVision(FALSE)
	return TRUE


/mob/living/simple_animal/hostile/abnormality/sphinx/Initialize() //1 in 100 chance for cringe aah aah sphinx by popular demand
	. = ..()
	if(prob(1)) // Why do we live, just to suffer?
		icon = 'ModularTegustation/Teguicons/64x64.dmi'
		icon_state = "sphonx"
		icon_aggro = "sphonx_eye"

/mob/living/simple_animal/hostile/abnormality/sphinx/PostSpawn()
	..()
	if((locate(/obj/structure/sacrifice_table) in range(1, src)))
		return
	new /obj/structure/sacrifice_table(get_step(src, SOUTH))

// Work
/mob/living/simple_animal/hostile/abnormality/sphinx/AttemptWork(mob/living/carbon/human/user, work_type)
	if((work_type != "Riddle") && work_type != "Make Offering")
		return ..()
	else if(work_cooldown > world.time)
		return FALSE

	work_cooldown = world.time + work_cooldown_time
	if(work_type == "Riddle")
		if(!(user in worked))
			worked += user
			new /obj/item/paper/fluff/translation_notes(get_turf(user))
			say(pick(translate))
			sleep(10)
		NewQuest() //repeat quest lines or offer new quest
		return FALSE
	else
		var/I = null
		for(var/obj/structure/sacrifice_table/S in range(1, src))
			if(S.showpiece)
				I = S.showpiece
				S.dump()
		if(I)
			to_chat(user, span_warning("[src] seems to be looking at the [I]!"))
		else if(user.get_active_held_item())
			I = user.get_active_held_item()
		else if(user.get_inactive_held_item())
			I = user.get_inactive_held_item()
		if(!I) //both hands are empty and there is no table
			to_chat(user, span_warning("You have nothing to offer to [src]!"))
			return FALSE
		QuestHandler(I,user) //quest item must be either the active hand, or the other hand if active is empty. No guessing.
	return FALSE

/mob/living/simple_animal/hostile/abnormality/sphinx/WorkChance(mob/living/carbon/human/user, chance)
	if(happy)
		chance+=30
	return chance

/mob/living/simple_animal/hostile/abnormality/sphinx/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	if(user.sanity_lost)
		QDEL_NULL(user.ai_controller)
		user.ai_controller = /datum/ai_controller/insane/wander/sphinx
		user.InitializeAIController()
	if(happy)
		happy = FALSE
	else
		say(pick(angry))
		datum_reference.qliphoth_change(-1)

// Riddle/Quest code
/mob/living/simple_animal/hostile/abnormality/sphinx/proc/NewQuest()
	if(!demand)
		demand = pick(demandlist)
	switch(demand)
		if(/obj/item/clothing/suit/armor/ego_gear)
			say("Atan eblak esm quistra utast.")//Bring me an armor EGO
		if(/obj/item/ego_weapon)
			say("Atan eblak esm sommel utast.")//Bring me an weapon EGO
		if(/obj/item/reagent_containers)
			say("Kom eblak mina brit hethre.")//Find me a water with vessel
		if(/obj/item/food)
			say("Atan eblak gorno tai por prin enum gorno.")//Bring me what the beggar consumes and needs (Its food)

/mob/living/simple_animal/hostile/abnormality/sphinx/proc/QuestHandler(obj/item/I, mob/living/carbon/human/user)
	if (!istype(I, demand))
		if(demand)
			QuestPenalty(user)
		else
			to_chat(user, span_warning("[src] is not waiting for an offering at the moment."))
		return

	if(demand == /obj/item/reagent_containers)
		if(I.reagents.has_reagent(/datum/reagent/water))
			qdel(I)
		else
			QuestPenalty(user)
			return

	if(demand == /obj/item/food)
		qdel(I)

	QuestReward()

/mob/living/simple_animal/hostile/abnormality/sphinx/proc/QuestReward()
	say(pick(satisfied))
	happy = TRUE
	demand = null
	datum_reference.qliphoth_change(3)
	var/turf/dispense_turf = get_step(src, pick(GLOB.alldirs))
	var/reward = pick(riddleloot)
	new reward(dispense_turf)

/mob/living/simple_animal/hostile/abnormality/sphinx/proc/QuestPenalty(mob/living/carbon/human/user)
	say(pick(angry))
	datum_reference.qliphoth_change(-1)
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
	var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
	var/obj/item/organ/tongue/tongue = H.getorganslot(ORGAN_SLOT_TONGUE)
	var/chosenorgan = pick(eyes,ears,tongue)
	while(!chosenorgan)
		if(!eyes && !ears && !tongue)
			to_chat(H, span_warning("With nothing left to lose, you lose your life."))
			H.dust()
			return
		chosenorgan = pick(eyes,ears,tongue)
	if(chosenorgan == eyes)
		to_chat(user, span_warning("A brilliant flash of light is the last thing you see..."))
	if(chosenorgan == ears)
		to_chat(user, span_warning("Suddenly, everything goes quiet..."))
	if(chosenorgan == tongue)
		to_chat(user, span_warning("Your mouth feels uncomfortably hollow..."))
	H.internal_organs -= chosenorgan
	qdel(chosenorgan)

// Breach
/mob/living/simple_animal/hostile/abnormality/sphinx/BreachEffect(mob/living/carbon/human/user, breach_type)
	. = ..()
	AddComponent(/datum/component/knockback, 3, FALSE, TRUE)
	GiveTarget(user)

/mob/living/simple_animal/hostile/abnormality/sphinx/Move()
	if(!can_act)
		return FALSE
	..()

/mob/living/simple_animal/hostile/abnormality/sphinx/PickTarget(list/Targets)
	var/list/priority = list()
	for(var/mob/living/L in Targets)
		if(!CanAttack(L))
			continue
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(H.sanity_lost) //ignore the panicked
				continue
			else
				priority += L
		else
			priority += L
	if(LAZYLEN(priority))
		return pick(priority)

/mob/living/simple_animal/hostile/abnormality/sphinx/AttackingTarget()
	..()
	if(!ishuman(target))
		return

	var/mob/living/carbon/human/H = target
	if(!H.sanity_lost)
		return

	QDEL_NULL(H.ai_controller)
	H.ai_controller = /datum/ai_controller/insane/wander/sphinx
	H.InitializeAIController()
	LoseTarget(H)

/mob/living/simple_animal/hostile/abnormality/sphinx/OpenFire()
	if(!can_act || client)
		return

	if((curse_cooldown <= world.time))
		StoneVision(FALSE)
	return

/mob/living/simple_animal/hostile/abnormality/sphinx/proc/StoneVision(attack_chain)
	if((curse_cooldown > world.time) && !attack_chain)
		return
	if(!attack_chain)
		playsound(get_turf(src), 'sound/abnormalities/sphinx/stone_ready.ogg', 50, 0, 5)
		icon_state = icon_aggro
		can_act = FALSE
		src.set_light(5, 7, "D4FAF37", TRUE)
		for(var/turf/T in view(7, src))
			if(T.density)
				continue
			new /obj/effect/temp_visual/stone_gaze(T)
	curse_cooldown = world.time + curse_cooldown_time
	SLEEP_CHECK_DEATH(12)
	for(var/mob/living/carbon/human/L in viewers(7, src))
		if(L.client && CanAttack(L) && L.stat != DEAD)
			if(!L.is_blind() && is_A_facing_B(L,src))
				StoneCurse(L)
	if(!attack_chain)
		StoneVision(TRUE)
		return
	icon_state = icon_living
	can_act = TRUE
	src.set_light(0, 0, null, FALSE) //using all params takes care of the other procs.
	return

/mob/living/simple_animal/hostile/abnormality/sphinx/proc/StoneCurse(target)
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	if(!(H.has_movespeed_modifier(/datum/movespeed_modifier/petrify_partial)))
		H.add_movespeed_modifier(/datum/movespeed_modifier/petrify_partial)
		addtimer(CALLBACK(H, TYPE_PROC_REF(/mob, remove_movespeed_modifier), /datum/movespeed_modifier/petrify_partial), 3 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)
		to_chat(H, span_warning("Your whole body feels heavy..."))
		playsound(get_turf(H), 'sound/abnormalities/sphinx/petrify.ogg', 50, 0, 5)
	else
		H.petrify()

// Insanity lines
/datum/ai_controller/insane/wander/sphinx
	lines_type = /datum/ai_behavior/say_line/insanity_sphinx

/datum/ai_behavior/say_line/insanity_sphinx
	lines = list(
		"Utast tom tai beos... Utast tom esm cadu!",
		"TAI ARKUR AGAL TOM LUVRI!!!",
		"Mi tai hur... Mi tai hur... Mi tai hur... Mi tai hur...",
		"Mies geng thran utast lemantomos!",
		"Ipi manba geng mosleti atan brit utast!",
	)

// Objects - Items
/obj/item/golden_needle
	name = "golden needle"
	desc = "A pair of golden needles, can treat total petrification or grant immunity to stuns for a short time. \
	It could be helpful even if you aren't petrified..."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "gold_needles"

/obj/item/golden_needle/pre_attack(atom/A, mob/living/user, params)
	. = ..()
	if(istype(A,/obj/structure/statue/petrified))
		playsound(A, 'sound/effects/break_stone.ogg', rand(10,50), TRUE)
		A.visible_message(span_danger("[A] returns to normal!"), span_userdanger("You break free of the stone!"))
		A.Destroy()
		qdel(src)
		return TRUE

/obj/item/golden_needle/attack_self(mob/user)
	var/mob/living/carbon/human/H = user
	H.reagents.add_reagent(/datum/reagent/medicine/theonic_gold, 15)
	playsound(H, 'sound/effects/ordeals/green/stab.ogg', rand(10,50), TRUE)
	to_chat(H, span_warning("You jab the golden needles into your vein!"))
	to_chat(user, span_userdanger("You feel unstoppable!"))
	qdel(src)
	return

/obj/item/canopic_jar
	name = "canopic jar"
	desc = "An ominous and foul-smelling jar, the contents can supposedly be consumed to replace missing organs. \
	An extra heart could be useful, too..."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "canopic_jar"

/obj/item/canopic_jar/attack_self(mob/user)
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/ears/ears = user.getorganslot(ORGAN_SLOT_EARS)
	var/obj/item/organ/tongue/tongue = user.getorganslot(ORGAN_SLOT_TONGUE)
	var/obj/item/organ/eyes/eyes = user.getorganslot(ORGAN_SLOT_EYES)
	for(var/organ in H.internal_organs)
		if(!eyes || !ears || !tongue)
			H.regenerate_organs()
		else
			H.reagents.add_reagent(/datum/reagent/medicine/ichor, 15)
			to_chat(user, span_userdanger("You feel your heart rate increase!"))
		playsound(H, 'sound/items/eatfood.ogg', rand(25,50), TRUE)
		to_chat(H, span_warning("You hold your nose and quaff the contents of the jar!"))
		qdel(src)
		return

/obj/item/paper/fluff/translation_notes //most of these are just fluff
	name = "Translation Notes"
	info = {"<h1><center>You may find this helpful when interpreting the sphinx's demands.</center></h1><br>
	-A-	<br>
	agal: gate	<br>
	arkur: city	<br>
	atan: bring	<br><br>
	-B-	<br>
	beos: law	<br>
	brit: with	<br><br>
	-C-	<br>
	cadu: king	<br>
	ceffe: threat	<br>
	cihir: lazy	<br><br>
	-E-	<br>
	eblak: me	<br>
	enum: and	<br>
	esm: a	<br>
	etog: will/mind	<br><br>
	-G-	<br>
	geng: has/owns	<br>
	gorno: needs	<br><br>
	-H-	<br>
	hethre: vessel/boat	<br>
	hur: scared/cowardly<br>
	huw: old	<br><br>
	-I-	<br>
	ipi: you	<br>
	inspuz: quest	<br><br>
	-K-	<br>
	kas: no	<br>
	kom: show	<br><br>
	-L-	<br>
	lemanto: human	<br>
	leti: gave	<br>
	luvri : open	<br><br>
	-M-	<br>
	manba: came	<br>
	medon: kill	<br>
	mina: water	<br>
	mos: coin	<br>
	mi: I	<br><br>
	-N-	<br>
	naar: fire	<br>
	neu: papyrus/textile	<br><br>
	-P-	<br>
	por: beggar/starving	<br>
	prin: consume	<br>
	puwun: to	<br><br>
	-Q-	<br>
	quir: translate	<br>
	quistra: body/armor	<br><br>
	-S-	<br>
	sagmo: begone	<br>
	sinco: honor/value	<br>
	sommel: weapon/stick	<br><br>
	-T-	<br>
	tai: the	<br>
	thran: angry	<br>
	tolly: stupid	<br>
	tom: to 	<br><br>
	-U-	<br>
	ucaf: lands	<br>
	utast: abnormality/shell"}

// Chems
/datum/reagent/medicine/ichor //from jar
	name = "Ichor"
	description = "an anomalous substance"
	reagent_state = LIQUID
	color = "#D2FFFA"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 30

/datum/reagent/medicine/ichor/on_mob_metabolize(mob/living/L)
	..()
	L.add_movespeed_modifier(/datum/movespeed_modifier/reagent/ichor_boost)

/datum/reagent/medicine/ichor/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/ichor_boost)
	..()

/datum/reagent/medicine/ichor/overdose_process(mob/living/carbon/M)
	if(prob(25))
		M.reagents.remove_reagent(type, metabolization_rate*15)
		M.vomit(20, TRUE, TRUE, 1, FALSE, FALSE, FALSE, TRUE) //copied from vomitting extra organs

/datum/movespeed_modifier/reagent/ichor_boost
	multiplicative_slowdown = -0.25

/datum/reagent/medicine/theonic_gold //from needle
	name = "Theonic gold"
	description = "an anomalous substance"
	reagent_state = LIQUID
	color = "#D2FFFA"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 30

/datum/reagent/medicine/theonic_gold/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_STUNRESISTANCE, type)
	L.adjustStaminaLoss(-10, 0)

/datum/reagent/medicine/theonic_gold/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_STUNRESISTANCE, type)
	..()

/datum/reagent/medicine/theonic_gold/overdose_process(mob/living/carbon/M)
	if(prob(3) && iscarbon(M))
		M.visible_message(span_danger("[M] starts having a seizure!"), span_userdanger("You have a seizure!"))
		M.Unconscious(100)
		M.Jitter(350)

// Objects - Effects
/obj/effect/temp_visual/stone_gaze
	name = "stone gaze"
	icon_state = "ironfoam"
	duration = 2 SECONDS

/obj/effect/temp_visual/stone_gaze/Initialize()
	. = ..()
	alpha = rand(75,255)
	animate(src, alpha = 0, time = 20)

/datum/movespeed_modifier/petrify_partial
	variable = TRUE
	multiplicative_slowdown = 2

// Objects - Structures
/obj/structure/sacrifice_table
	name = "sacrificial altar"
	desc = "It looks impossibly ancient."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "altar"
	anchored = TRUE
	density = TRUE
	layer = TURF_LAYER
	plane = FLOOR_PLANE
	resistance_flags = INDESTRUCTIBLE
	var/obj/item/showpiece = null

/obj/structure/sacrifice_table/examine(mob/user)
	. = ..()
	if(showpiece)
		. += span_notice("There's \a [showpiece] inside.")

/obj/structure/sacrifice_table/update_overlays()
	. = ..()
	if(showpiece)
		var/mutable_appearance/showpiece_overlay = mutable_appearance(showpiece.icon, showpiece.icon_state)
		showpiece_overlay.copy_overlays(showpiece)
		showpiece_overlay.transform *= 0.7
		. += showpiece_overlay

/obj/structure/sacrifice_table/proc/insert_showpiece(obj/item/wack, mob/user)
	if(user.transferItemToLoc(wack, src))
		showpiece = wack
		to_chat(user, span_notice("You put [wack] on display."))
		update_icon()

/obj/structure/sacrifice_table/proc/dump()
	if(!QDELETED(showpiece))
		showpiece.forceMove(drop_location())
	showpiece = null
	update_icon()

/obj/structure/sacrifice_table/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	if (showpiece)
		to_chat(user, span_notice("You remove [showpiece]."))
		dump()
		add_fingerprint(user)
		return

/obj/structure/sacrifice_table/attackby(obj/item/W, mob/user, params)
	if(!showpiece)
		insert_showpiece(W, user)
	else
		return ..()

#undef SPHINX_GAZE_COOLDOWN
