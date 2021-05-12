#define IS_APOSTLE(apostle) (apostle.mind && apostle.mind.has_antag_datum(/datum/antagonist/apostle))

/datum/antagonist/apostle
	name = "Apostle"
	roundend_category = "apostles"
	antagpanel_category = "Apostle"
	job_rank = "Apostle"
	antag_hud_type = ANTAG_HUD_SHADOW
	antag_hud_name = "shadowling"
	antag_moodlet = /datum/mood_event/focused
	var/number = 1 // Number of apostle, obviously. Used for finale
	var/datum/team/apostles/ap_team
	show_to_ghosts = TRUE

/datum/antagonist/apostle/New()
	. = ..()
	GLOB.apostles |= src

/datum/antagonist/apostle/on_gain()
	. = ..()

/datum/team/apostles
	name = "Apostles"

/datum/antagonist/apostle/get_team()
	return ap_team

/datum/antagonist/apostle/create_team(datum/team/apostles/new_team)
	if(!new_team)
		for(var/datum/antagonist/apostle/P in GLOB.antagonists)
			if(!P.owner)
				continue
			if(P.ap_team)
				ap_team = P.ap_team
				return
		ap_team = new /datum/team/apostles
		return
	if(!istype(new_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	ap_team = new_team

/datum/antagonist/apostle/apply_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	add_antag_hud(antag_hud_type, antag_hud_name, M)
	handle_clown_mutation(M, mob_override ? null : "The holy light grants you supreme power, allowing you to wield weapons once again.")

/datum/antagonist/apostle/remove_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	remove_antag_hud(antag_hud_type, M)
	handle_clown_mutation(M, removing = FALSE)

/datum/antagonist/apostle/proc/rapture()
	var/mob/living/carbon/human/H = owner.current
	var/datum/outfit/ApostleFit = new /datum/outfit/apostle
	var/obj/item/wep_type
	var/obj/effect/proc_holder/spell/spell_type = /obj/effect/proc_holder/spell/targeted/summonitem
	switch(number)
		if(1, 11) // Guardian
			wep_type = /obj/item/nullrod/scythe/apostle/guardian
			ApostleFit.mask = /obj/item/clothing/mask/gas/apostle/guardian
		if(2, 3) // Scythe
			wep_type = /obj/item/nullrod/scythe/apostle
		if(4, 5, 6) // Staff
			wep_type = /obj/item/gun/magic/staff/apostle
		if(7, 8, 9, 10) // Spear
			wep_type = /obj/item/nullrod/spear/apostle
		if(12) // Heretic
			H.dropItemToGround(H.wear_mask)
			spell_type = null
			ApostleFit = /datum/outfit/apostle_heretic
	H.equipOutfit(ApostleFit)
	if(wep_type)
		var/obj/item/held = H.get_active_held_item()
		var/obj/item/wep = new wep_type(H, silent)
		H.dropItemToGround(held) // First - drop current item.
		H.put_in_hands(wep) // Then put an epic one.
	if(spell_type)
		for(var/obj/effect/proc_holder/spell/knownspell in H.mind.spell_list)
			if(knownspell == spell_type)
				return // Don't grant spells that we already know
		var/obj/effect/proc_holder/spell/G = new spell_type
		H.mind.AddSpell(G)

/datum/antagonist/apostle/proc/prophet_death()
	var/mob/living/carbon/human/H = owner.current
	to_chat(H, "<span class='colossus'>The prophet is dead...</span>")
	H.visible_message("<span class='danger'>[H.real_name] briefly looks above...</span>", "<span class='userdanger'>You see the light above...</span>")
	H.emote("scream")
	H.Immobilize(200)
	addtimer(CALLBACK(src, .proc/soundd_in), (number * 6))

/datum/antagonist/apostle/proc/soundd_in()
	var/mob/living/carbon/human/H = owner.current
	var/turf/T = get_turf(H)
	playsound(H, 'ModularTegustation/Tegusounds/apostle/mob/apostle_death_final.ogg', 200, TRUE, TRUE)
	new /obj/effect/temp_visual/cult/sparks(T)
	addtimer(CALLBACK(src, .proc/drop_dust), 25)

/datum/antagonist/apostle/proc/drop_dust()
	var/mob/living/carbon/human/H = owner.current
	GLOB.apostles -= src
	for(var/obj/item/W in H)
		if(!H.dropItemToGround(W))
			qdel(W)
	H.dust()

/datum/team/apostles/roundend_report()
	var/list/parts = list("<span class='header'>The holy apostles were:</span>")
	var/list/members = get_team_antags(/datum/antagonist/apostle,TRUE)
	for(var/datum/antagonist/apostle/A in members)
		var/mod = "st"
		switch(A.number)
			if(1)
				mod = "st"
			if(2)
				mod = "nd"
			if(3)
				mod = "rd"
			else
				mod = "th"
		parts += "[printplayer(A.owner.current.mind)]; The [A.number][mod] apostle."
	if(members.len > 11)
		parts += "<span class='greentext'>The rapture was successful!</span>"
	else
		parts += "<span class='redtext'>The apostles didn't manage to achieve rapture!</span>"

	return "<div class='panel redborder'>[parts.Join("<br>")]</div>"
