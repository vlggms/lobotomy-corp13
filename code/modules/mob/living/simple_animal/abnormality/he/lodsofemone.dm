/mob/living/simple_animal/hostile/abnormality/lodsofemone
	name = "Lods of Emone"
	desc = "A man constantly ranting about how much money he has."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "" //needs a sprite
	portrait = "" //needs that little work window picture thingy
	maxHealth = 650
	health = 650
	threat_level = HE_LEVEL
	start_qliphoth = 5
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 0,
		ABNORMALITY_WORK_INSIGHT = 55,
		ABNORMALITY_WORK_ATTACHMENT = 75,
		ABNORMALITY_WORK_REPRESSION = 45,
	)
	work_damage_amount = 12
	work_damage_type = BLACK_DAMAGE
	max_boxes = 20

	ego_list = list(
		/datum/ego_datum/weapon/dosh,
		/datum/ego_datum/armor/pocketdosh,
	)

	//////////////////////
	//HEAVILY UNFINISHED//
	//////////////////////
