/mob/living/simple_animal/hostile/abnormality/branch12/workshop
	name = "Ulies Workshop"
	desc = "A table stands in front of you with some ahn and a blade. a masked figure stands behind it."
	icon = 'ModularTegustation/Teguicons/branch12/32x48.dmi'
	icon_state = "workshop"
	icon_living = "workshop"

	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 35,
		ABNORMALITY_WORK_INSIGHT = 35,
		ABNORMALITY_WORK_ATTACHMENT = 40,
		ABNORMALITY_WORK_REPRESSION = 70,
	)
	work_damage_amount = 7
	work_damage_type = WHITE_DAMAGE
	threat_level = TETH_LEVEL

	ego_list = list(
	//the weapons are the EGO
	/datum/ego_datum/armor/branch12/workshopping
	)
	//gift_type =  /datum/ego_gifts/signal

	abnormality_origin = ABNORMALITY_ORIGIN_BRANCH12

/mob/living/simple_animal/hostile/abnormality/branch12/workshop/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	..()
	Scam_Player(user, work_type)

/mob/living/simple_animal/hostile/abnormality/branch12/workshop/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	..()
	Scam_Player(user, work_type)


/mob/living/simple_animal/hostile/abnormality/branch12/workshop/proc/Scam_Player(mob/living/carbon/human/user, work_type)
	SSlobotomy_corp.AdjustAvailableBoxes(-200)	//Get Scammed, idiot!
	say("Thank you for buying from Ulies Workshop! Come again!")
	var/obj/item/to_spawn
	switch(work_type)
		if(ABNORMALITY_WORK_INSTINCT)
			to_spawn = /obj/item/ego_weapon/branch12/fake_mimicry

		if(ABNORMALITY_WORK_INSIGHT)
			to_spawn = /obj/item/ego_weapon/branch12/fake_reverb

		if(ABNORMALITY_WORK_ATTACHMENT)
			to_spawn = /obj/item/ego_weapon/branch12/fake_purple_tear

		if(ABNORMALITY_WORK_REPRESSION)
			to_spawn = /obj/item/ego_weapon/branch12/fake_whitemoon

	new to_spawn (get_turf(user))


//Weapons
//Mimicry
/obj/item/ego_weapon/branch12/fake_mimicry
	name = "Mimicry"
	desc = "The yearning to imitate the human form is sloppily reflected on the E.G.O, \
	as if it were a reminder that it should remain a mere desire."
	icon_state = "fake_mimicry"
	force = 30
	stuntime = 3
	damtype = RED_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP
	attack_verb_continuous = list("slashes", "slices", "rips", "cuts")
	attack_verb_simple = list("slash", "slice", "rip", "cut")
	hitsound = 'sound/abnormalities/nothingthere/attack.ogg'

//Reverberation
/obj/item/ego_weapon/branch12/fake_reverb
	name = "Elogio Bianco"
	desc = "This Scythe constantly emits a low hum, transfered to things you strike with it. \
		If your Vibration matches the target's, you resonate. This deals Pale Damage instead of White Damage and deals more of it."
	icon_state = "fake_scythe"
	force = 30
	stuntime = 3
	damtype = WHITE_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP
	hitsound = 'sound/weapons/fixer/reverb_normal.ogg'
	attack_verb_continuous = list("slashes", "cuts",)
	attack_verb_simple = list("slash", "cuts")

//Purple Tear
/obj/item/ego_weapon/branch12/fake_purple_tear
	name = "Vipers Blade" //All weapon names are placeholders at the moment, I don't really have better names
	desc = "An extremely sharp blade used by the Purple Tear."
	icon_state = "fake_purple"
	force = 30
	stuntime = 3
	damtype = BLACK_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP
	attack_verb_continuous = list("slashes", "rends")
	attack_verb_simple = list("slash", "rend")
	hitsound = 'sound/weapons/purple_tear/slash1.ogg'

//Knight of the blue moon.
/obj/item/ego_weapon/branch12/fake_whitemoon
	name = "Last Whisper of a Waning Moon"
	desc = "A faintly humming longsword used by the famous Knight of the White Moon. \
		It smells faintly of blood, but you feel no malice coming from it."
	icon_state = "fake_whitemoon"
	force = 30
	stuntime = 7
	damtype = PALE_DAMAGE
	swingstyle = WEAPONSWING_LARGESWEEP
	hitsound = 'sound/weapons/ego/sword1.ogg'
	attack_verb_continuous = list("slashes", "cuts",)
	attack_verb_simple = list("slash", "cuts")
