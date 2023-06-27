/mob/living/simple_animal/hostile/abnormality/fairy_gentleman
	name = "Fairy Gentleman"
	desc = "A very wide humanoid with long arms made of green, dripping slime."
	icon = 'ModularTegustation/Teguicons/96x64.dmi'
	icon_state = "fairy_gentleman"
	maxHealth = 600
	health = 600
	threat_level = TETH_LEVEL
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 60,
		ABNORMALITY_WORK_INSIGHT = 45,
		ABNORMALITY_WORK_ATTACHMENT = list(50, 50, 55, 55, 60),
		ABNORMALITY_WORK_REPRESSION = list(30, 25, 25, 20, 15)
			)
	pixel_x = -32
	base_pixel_x = -32
	work_damage_amount = 8
	work_damage_type = RED_DAMAGE

	//ego_list = list(
	//	/datum/ego_datum/weapon/sloshing,
	//	/datum/ego_datum/armor/sloshing
	//)
	//gift_type = /datum/ego_gifts/sloshing
	gift_message = "This wine tastes quite well..."
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS
	var/list/give_drink = list(
				"You quite an interesting one, Feel free to take this drink! It is on the house!",
				"Aright, I think you deserve this drink! Drink as much as you can!",
				"HA HA HA HA!!! That was quite funny of you, Feel free to take this drink from my hands.",
				"Come on now, No need to worry about this drink. I made it so you can just relax...",
				"*Burp* Oh, That was quite rude of me. Here is a drink as an apology for my behavior"
				)
	var/list/disappointed = list(
				"Really now? I don't think this will help any of us if you continue like this.",
				"Okay, This is not funny, What did I do to you? I just offer drinks to people unlike the other ones.",
				"This is quite sad, This is how you treat me after giving you all of you my finest drinks?",
				"Come on now, Please try a bit better. Don't you want a free drink from me?",
				"Hm... Let me just ask you this. Are you okay? What happend which caused you to work like this?"
				)

/mob/living/simple_animal/hostile/abnormality/fairy_gentleman/SuccessEffect(mob/living/carbon/human/user, work_type, pe)
	var/turf/dispense_turf = get_step(src, pick(1,2,4,5,6,8,9,10))
	new/obj/item/reagent_containers/food/drinks/fairywine(dispense_turf)
	visible_message("<span class='notice'>[src] gives out some fairy wine.</span>")
	say(pick(give_drink))
	return

/mob/living/simple_animal/hostile/abnormality/fairy_gentleman/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time)
	switch(work_type)
		if(ABNORMALITY_WORK_INSTINCT)
			user.reagents.add_reagent(/datum/reagent/consumable/ethanol/fairywine, 10)
			visible_message("<span class='notice'>You take a drink with the fairy gentleman. </span>")
			say("Quite a lot of thanks for sharing this drink with me. Not many people often want to share this drink with me.")
	return

/mob/living/simple_animal/hostile/abnormality/fairy_gentleman/FailureEffect(mob/living/carbon/human/user, work_type, pe)
	say(pick(disappointed))
