//Coded by me, Kirie Saito!

//Remind me to give it contract features later.....
/mob/living/simple_animal/hostile/abnormality/contract
	name = "A Contract, Signed"
	desc = "A man with a flaming head sitting behind a desk."
	icon = 'ModularTegustation/Teguicons/64x48.dmi'
	icon_state = "firstfold"
	threat_level = WAW_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(0, 0, 40, 50, 50),
		ABNORMALITY_WORK_INSIGHT = 0,
		ABNORMALITY_WORK_ATTACHMENT = list(0, 0, 30, 40, 40),
		ABNORMALITY_WORK_REPRESSION = list(0, 0, 50, 45, 45),
			)
	pixel_x = -16
	base_pixel_x = -16
	start_qliphoth = 2
	work_damage_amount = 7
	work_damage_type = PALE_DAMAGE	//Lawyers take your fucking soul

	ego_list = list(
		/datum/ego_datum/weapon/infinity,
		/datum/ego_datum/armor/infinity,
		)
	gift_type = /datum/ego_gifts/infinity


	var/list/spawnables = list()

/mob/living/simple_animal/hostile/abnormality/contract/Initialize()
	. = ..()
	//We need a list of all abnormalities that are TETH and HE level and Can breach.

	var/list/queue = subtypesof(/mob/living/simple_animal/hostile/abnormality)
	for(var/i in queue)
		var/mob/living/simple_animal/hostile/abnormality/abno = i
		if(!(initial(abno.can_spawn)) || !(initial(abno.can_breach)))
			continue

		if((initial(abno.threat_level)) <= HE_LEVEL)
			spawnables += abno


//Meltdown
/mob/living/simple_animal/hostile/abnormality/contract/ZeroQliphoth(mob/living/carbon/human/user)
	// Don't need to lazylen this. If this is empty there is a SERIOUS PROBLEM.
	var/mob/living/simple_animal/hostile/abnormality/spawning =	pick(spawnables)
	var/mob/living/simple_animal/hostile/abnormality/spawned = new spawning(get_turf(src))
	spawned.BreachEffect()
	spawned.color = "#000000"	//Make it black to look cool
	spawned.name = "???"
	spawned.desc = "What is that thing?"
	datum_reference.qliphoth_change(2)

/* Work effects */
/mob/living/simple_animal/hostile/abnormality/contract/NeutralEffect(mob/living/carbon/human/user, work_type, pe)
	if(prob(40))
		datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/contract/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return
