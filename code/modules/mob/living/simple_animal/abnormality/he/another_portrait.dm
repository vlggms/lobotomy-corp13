#define STATUS_EFFECT_PORTRAIT /datum/status_effect/portrait
#define STATUS_EFFECT_PORTRAIT_MARKED /datum/status_effect/portrait_marked
//Note its sort of the inverse from how it is in lcorp since it would be aids if it linking worked 1 to 1 outside of the breach - Crabby
/mob/living/simple_animal/hostile/abnormality/another_portrait
	name = "Portrait of Another World"
	desc = "An old and unused canvas."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "portrait"
	portrait = "another_portrait"
	maxHealth = 130
	health = 130
	threat_level = HE_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 0,
		ABNORMALITY_WORK_INSIGHT = list(10, 35, 45, 40, 45),
		ABNORMALITY_WORK_ATTACHMENT = 40,//has Special mechanics
		ABNORMALITY_WORK_REPRESSION = list(40, 45, 50, 50, 50),
	)
	work_damage_amount = 5
	work_damage_type = BLACK_DAMAGE
	chem_type = /datum/reagent/abnormality/sin/pride
	start_qliphoth = 2

	ego_list = list(
		///datum/ego_datum/weapon/,
		///datum/ego_datum/armor/,
	)
	//gift_type = /datum/ego_gifts/
	abnormality_origin = ABNORMALITY_ORIGIN_ALTERED

	var/degradation_damage = 0
	var/degradation_stage = 0
	var/meltdown_cooldown_time = 30 SECONDS
	var/meltdown_cooldown
	var/mob/living/carbon/human/linked_target = null
	var/linked_amount = 2

	//Taken Vars from NI
	var/obj/effect/reflection/headicon
	var/list/longhair = list( // EXTREMELY TEMPORARY but easier to do than figuring out complex image manipulation
		"Floorlength Bedhead",
		"Long Side Part",
		"Long Bedhead",
		"Drill Hair (Extended)",
		"Long Hair 2",
		"Silky",
	)
	var/list/longbeard = list("Beard (Very Long)")

/mob/living/simple_animal/hostile/abnormality/another_portrait/AttemptWork(mob/living/carbon/human/user, work_type)
	work_damage_amount = 5
	if(linked_target)
		work_damage_amount = 3
		to_chat(linked_target, span_bolddanger("A strange feeling is spreading all over your body!"))
	return ..()

/mob/living/simple_animal/hostile/abnormality/another_portrait/WorkChance(mob/living/carbon/human/user, chance, work_type)
	if(linked_target)
		if(user != linked_target)
			if(work_type != ABNORMALITY_WORK_ATTACHMENT)
				chance += 10
		else
			if(work_type == ABNORMALITY_WORK_REPRESSION)
				chance -= 30
			else
				chance += 20
	return chance

/mob/living/simple_animal/hostile/abnormality/another_portrait/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	CheckDegradationStage()
	switch(work_type)
		if(ABNORMALITY_WORK_REPRESSION)
			if(user == linked_target)
				Remove_Target()
				return
		if(ABNORMALITY_WORK_ATTACHMENT)
			if(!linked_target)
				to_chat(user, span_warning("A portrait of yourself is etched into [src]!"))
				ReflectTarget(user)
				RegisterSignal(linked_target, COMSIG_LIVING_DEATH, PROC_REF(Remove_Target))
				RegisterSignal(linked_target, COMSIG_PARENT_PREQDELETED, PROC_REF(Remove_Target))
				return
	switch(degradation_stage)
		if(1)
			if(prob(10))
				datum_reference.qliphoth_change(-1)
		if(2)
			if(prob(30))
				datum_reference.qliphoth_change(-1)

/mob/living/simple_animal/hostile/abnormality/another_portrait/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	if(prob(20))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/another_portrait/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/another_portrait/ZeroQliphoth(mob/living/carbon/human/user)
	Remove_Target()
	datum_reference.qliphoth_change(2) //no need for qliphoth to be stuck at 0
	if(meltdown_cooldown > world.time)
		return
	meltdown_cooldown = world.time + meltdown_cooldown_time
	MeltdownEffect()
	return

/mob/living/simple_animal/hostile/abnormality/another_portrait/WorktickFailure(mob/living/carbon/human/user)
	. = ..()
	if(linked_target)
		if(user == linked_target)
			work_damage_amount = initial(work_damage_amount) + ((degradation_stage-1) * 2)
			if(degradation_stage == 2)
				work_damage_amount += floor(degradation_damage/20)
			degradation_damage += work_damage_amount
		else
			var/damage_amount = 5 + ((degradation_stage - 1) * 2)
			if(degradation_stage == 2)
				damage_amount += floor(degradation_damage/20)
			if(linked_target.is_working)
				damage_amount = floor(damage_amount/2)
			var/mob/living/carbon/human/H = linked_target
			degradation_damage += damage_amount
			H.apply_damage(damage_amount, BLACK_DAMAGE, null, H.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)//ehh they can heal
		if(linked_target.sanity_lost || linked_target.stat == DEAD)
			linked_target.gib()
			datum_reference.qliphoth_change(-2)
	return

/mob/living/simple_animal/hostile/abnormality/another_portrait/proc/MeltdownEffect(mob/living/carbon/human/user)
	var/list/marked = list()
	sound_to_playing_players_on_level('sound/abnormalities/crumbling/globalwarning.ogg', 25, zlevel = z)
	for(var/mob/living/carbon/human/L in GLOB.player_list)
		if(faction_check_mob(L, FALSE) || L.stat >= HARD_CRIT || L.sanity_lost || z != L.z) // Dead or in hard crit, insane, or on a different Z level.
			continue
		marked += L
	if(marked.len > 1)
		var/mob/living/carbon/human/L = pick(marked)
		marked -= L
		var/mob/living/carbon/human/L2 = pick(marked)
		var/datum/status_effect/portrait/P = L.apply_status_effect(STATUS_EFFECT_PORTRAIT)
		P.linkee = L2
		var/datum/status_effect/portrait_marked/PM = L2.apply_status_effect(STATUS_EFFECT_PORTRAIT_MARKED)
		PM.linkee = L

/mob/living/simple_animal/hostile/abnormality/another_portrait/proc/Remove_Target()
	if(linked_target)
		UnregisterSignal(linked_target, COMSIG_LIVING_DEATH, PROC_REF(Remove_Target))
		UnregisterSignal(linked_target, COMSIG_PARENT_PREQDELETED, PROC_REF(Remove_Target))
		visible_message(span_notice("[linked_target]'s face melts away to nothingness on [src]."))
		linked_target = null
		CheckPortraitIcon()
		degradation_damage = 0
		degradation_stage = 0

/mob/living/simple_animal/hostile/abnormality/another_portrait/proc/CheckDegradationStage()
	if(degradation_damage >= 100 && degradation_stage != 2)
		if(degradation_stage == 0)
			degradation_damage = 0
			degradation_stage = 1
			ReflectTarget(linked_target)
			visible_message(span_warning("[linked_target]'s face on [src] is looking a bit melted!"))
		else if(degradation_stage == 1)
			degradation_damage = 0
			degradation_stage = 2
			ReflectTarget(linked_target)
			visible_message(span_warning("[linked_target]'s face on [src] is becomes heavily melted and warped!"))

//Stolen from NI
/mob/living/simple_animal/hostile/abnormality/another_portrait/proc/ReflectTarget(mob/living/carbon/human/reflect_target)
	CheckPortraitIcon()
	linked_target = reflect_target
	if(!linked_target || !IsContained())
		return
	var/obj/item/bodypart/HD = linked_target.get_bodypart("head")
	if (!istype(HD))
		return
	if((linked_target.hairstyle in longhair) || (linked_target.facial_hairstyle in longbeard))
		var/oldhair = linked_target.hairstyle
		var/oldbeard = linked_target.facial_hairstyle
		linked_target.hairstyle = pick("Bedhead", "Bedhead 2", "Bedhead 3")
		linked_target.facial_hairstyle = "shaved"
		HD.update_limb()
		linked_target.hairstyle = oldhair
		linked_target.facial_hairstyle = oldbeard
	headicon = new(get_turf(src))
	headicon.dir = EAST
	headicon.add_overlay(HD.get_limb_icon(TRUE,TRUE))
	var/offset_x = 2
	var/offset_y = -8
	headicon.pixel_y -= 8
	headicon.pixel_x += 2
	headicon.alpha = 150
	headicon.desc = "It looks like [linked_target] is depicted in the portrait."
	HD.update_limb()
	if(degradation_stage== 1)
		headicon.color = COLOR_GRAY
		headicon.desc = "It looks like a faded and grayed depiction of [linked_target]."
		headicon.alpha = 120
	else if(degradation_stage == 2)
		headicon.desc = "A distorted mess that vaguely looks like a depiction of [linked_target]."
		headicon.color = COLOR_BLACK
		headicon.alpha = 100
		headicon.transform = matrix(0.7, 1.3, MATRIX_SCALE)
		offset_y = -13
		headicon.pixel_y -= 5
	//Handles connected structure part
	datum_reference.connected_structures = list(headicon = list(offset_x,offset_y))

/mob/living/simple_animal/hostile/abnormality/another_portrait/proc/CheckPortraitIcon()
	if(headicon) //Grab their head. Literally, and grab the icons from it; discard our old icon if we have one.
		qdel(headicon)
		headicon = null
		datum_reference.connected_structures = list()

//Debuff Status Effect

/atom/movable/screen/alert/status_effect/portrait
	name = "A potrait of you"
	desc = "Damage you take will be transferred to "
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "Potrait" //Bit of a placeholder sprite, it works-ish so

/datum/status_effect/portrait
	id = "portrait"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 60 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/portrait
	var/mob/living/linkee = null

/datum/status_effect/portrait/on_apply()
	. = ..()
	var/mob/living/carbon/human/L = owner
	if(linkee)
		linked_alert.desc = initial(linked_alert.desc)+"[linkee]!"
		RegisterSignal(L, COMSIG_MOB_APPLY_DAMGE, PROC_REF(DamageTransfer))
		RegisterSignal(linkee, COMSIG_LIVING_DEATH, PROC_REF(On_Linkee_Death))
		RegisterSignal(linkee, COMSIG_PARENT_PREQDELETED, PROC_REF(On_Linkee_Death))

/datum/status_effect/portrait/proc/On_Linkee_Death()
	var/mob/living/carbon/human/L = owner
	L.gib()
	qdel(src)

/datum/status_effect/portrait/proc/DamageTransfer(datum/source, damage, damagetype, def_zone)
	if(linkee)
		damage *= 1.5
		source = linkee

/datum/status_effect/portrait/on_remove()
	var/mob/living/carbon/human/L = owner
	if(linkee)
		RegisterSignal(L, COMSIG_MOB_APPLY_DAMGE, PROC_REF(DamageTransfer))
		UnregisterSignal(linkee, COMSIG_LIVING_DEATH, PROC_REF(On_Linkee_Death))
		UnregisterSignal(linkee, COMSIG_PARENT_PREQDELETED, PROC_REF(On_Linkee_Death))
		linkee = null

/atom/movable/screen/alert/status_effect/portrait_marked
	name = "A potrait of someome"
	desc = ""
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "Potrait" //Bit of a placeholder sprite, it works-ish so

/datum/status_effect/portrait_marked
	id = "portrait_marked"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 60 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/portrait_marked
	var/mob/living/linkee = null

/datum/status_effect/portrait_marked/on_apply()
	. = ..()
	var/mob/living/carbon/human/L = owner
	if(linkee)
		linked_alert.desc = "Damage [linkee] takes will damage you instead!"
		RegisterSignal(L, COMSIG_LIVING_DEATH, PROC_REF(On_Death))
		RegisterSignal(L, COMSIG_PARENT_PREQDELETED, PROC_REF(On_Death))

/datum/status_effect/portrait_marked/proc/On_Death()
	qdel(src)

/datum/status_effect/portrait_marked/on_remove()
	var/mob/living/carbon/human/L = owner
	UnregisterSignal(L, COMSIG_LIVING_DEATH, PROC_REF(On_Death))
	UnregisterSignal(L, COMSIG_PARENT_PREQDELETED, PROC_REF(On_Death))
	linkee = null
