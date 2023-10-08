#define STATUS_EFFECT_TEARS /datum/status_effect/tears
/mob/living/simple_animal/hostile/abnormality/bottle
	name = "Bottle of Tears"
	desc = "A bottle filled with water with a cake on top"
	icon = 'ModularTegustation/modular_abnormalities/zayin/bottle_of_tears/icons/32x32.dmi'
	icon_state = "bottle1"
	icon_living = "bottle1"
	maxHealth = 400
	health = 400
	threat_level = ZAYIN_LEVEL
	work_chances = list( //In the comic they work on it. They say you can do any work as long as you don't eat the cake
		ABNORMALITY_WORK_INSTINCT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_INSIGHT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_ATTACHMENT = list(50, 40, 30, 30, 30),
		ABNORMALITY_WORK_REPRESSION = list(50, 40, 30, 30, 30), //How the fuck do you beat up a cake?
		"Dining" = 100, //You can instead decide to eat the cake.
		"Drink" = 100 //Or Drink the water
		)
	work_damage_amount = 6
	work_damage_type = BLACK_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/little_alice,
		/datum/ego_datum/armor/little_alice
		)
	gift_type = /datum/ego_gifts/alice
	gift_message = "Welcome to your very own Wonderland~"
	abnormality_origin = ABNORMALITY_ORIGIN_WONDERLAB

	max_boxes = 10
	var/cake = 5 //How many cake charges are there (4)
	chem_type = /datum/reagent/abnormality/bottle
	harvest_phrase = "<span class='notice'>You sweep up some crumbs from around %ABNO into %VESSEL.</span>"
	harvest_phrase_third = "%PERSON sweeps up crumbs from around %ABNO into %VESSEL."

/mob/living/simple_animal/hostile/abnormality/bottle/AttemptWork(mob/living/carbon/human/user, work_type)
	if(!cake)
		if(work_type == "Dining")
			return FALSE

	if(work_type == "Drink")
		//it's just work speed
		var/consume_speed = 2 SECONDS / (1 + ((get_attribute_level(user, TEMPERANCE_ATTRIBUTE) + datum_reference.understanding) / 100))
		to_chat(user, "<span class='warning'>You begin to drink the water...</span>")
		datum_reference.working = TRUE
		if(!do_after(user, consume_speed * max_boxes, target = user))
			to_chat(user, "<span class='warning'>You decide to not drink the water.</span>")
			datum_reference.working = FALSE
			return null
		playsound(get_turf(user), 'sound/machines/synth_yes.ogg', 25, FALSE, -4)
		user.apply_status_effect(STATUS_EFFECT_TEARS)
		datum_reference.working = FALSE
		return null

	return TRUE

/mob/living/simple_animal/hostile/abnormality/bottle/PostWorkEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	if(work_type == "Dining" && !canceled)
		cake -= 1 //Eat some cake
		if(cake > 0)
			user.adjustBruteLoss(-500) // It heals you to full if you eat it
			to_chat(user, "<span class='nicegreen'>You consume the cake. Delicious!</span>")
			icon_state = "bottle2" //cake looks eaten
		else
			//Drowns you like Wellcheers does, so I mean the code checks out
			for(var/turf/open/T in view(7, src))
				new /obj/effect/temp_visual/water_waves(T)
			playsound(get_turf(user), 'ModularTegustation/modular_abnormalities/zayin/bottle_of_tears/sound/bottledrown.ogg', 80, 0)
			icon_state = "bottle3" //cake all gone

			/* "I get it now. There's no reason to have any emotions or a heart."
			"Abandon reason and protect Catt! That's how you survive in this wonderland!"
			Catt was a low level agent with temperance and fortitude. She sought to abandon that temperance in exchange for justice.
			Thus, bottle will check for those. Overall low level, high temperance, high fortitude.
			Keep in mind that this event can happen ONCE PER ROUND. The spoon is already jokingly called the protagonist weapon, so it can bend the rules a bit, right?*/

			new /obj/item/ego_weapon/eyeball(get_turf(user))

			var/fortitude = get_attribute_level(user, FORTITUDE_ATTRIBUTE)
			var/prudence = get_attribute_level(user, PRUDENCE_ATTRIBUTE)
			var/temperance = get_attribute_level(user, TEMPERANCE_ATTRIBUTE)
			var/justice = get_attribute_level(user, JUSTICE_ATTRIBUTE)
			var/goal_damage = 0
			if(temperance >= (fortitude + prudence + justice) / 1.5) // If your temperance is at least twice your average stat, you aren't hurt, but lose temperance.
				to_chat(user, "<span class='userdanger'>The room is filling with water... but you feel oddly unconcerned.</span>")
				user.adjust_attribute_level(TEMPERANCE_ATTRIBUTE, 20 - temperance)
				// This is a PERMANENT stat change, VERY significant. But it can happen only once per round. You're The Protagonist, after all.
				var/stat_change = 0
				stat_change = temperance - 20
				user.adjust_attribute_buff(JUSTICE_ATTRIBUTE, stat_change) // Gain benefit from what you lost.
				addtimer(CALLBACK(src, .proc/DecayProtagonistBuff, user, stat_change), 20 SECONDS) // Short grace period. 10s of this happens while you're asleep.
			else
				to_chat(user, "<span class='userdanger'>The room is filling with water! Are you going to drown?!</span>")
				goal_damage = 99999 // DIE.
				if(fortitude >= (prudence + justice)) // Like the temperance calculation, but high temperance doesn't actively hurt your odds.
					goal_damage = 120 + fortitude // Hurt bad, but never lethally.

			user.AdjustSleeping(10 SECONDS)
			user.adjustBruteLoss(goal_damage)
			if(user.stat == DEAD)
				animate(user, alpha = 0, time = 2 SECONDS)
				QDEL_IN(user, 3.5 SECONDS)
			else
				user.adjustBruteLoss(-(goal_damage * 0.25)) // If you didn't die instantly, heal up some.
	return

/mob/living/simple_animal/hostile/abnormality/bottle/proc/DecayProtagonistBuff(mob/living/carbon/human/buffed, justice = 0)
	// Goes faster when the buff is higher, so you don't have an overwhelming buff for an overwhelming length of time.
	if(justice <= 0 || !buffed)
		return FALSE
	var/factor = justice / 10
	var/timing = 10 + max(0, (100 - factor * factor))
	buffed.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -1)
	if(prob(10))
		buffed.adjust_attribute_level(JUSTICE_ATTRIBUTE, 1) // 10% chance for justice buff to become real justice as it decays.
	addtimer(CALLBACK(src, .proc/DecayProtagonistBuff, buffed, justice - 1), timing)

/datum/status_effect/tears
	id = "tears"
	status_type = STATUS_EFFECT_MULTIPLE	//You should be able to stack this, I hope
	duration = 3000 //Lasts 5 minutes.
	alert_type = /atom/movable/screen/alert/status_effect/tears

/atom/movable/screen/alert/status_effect/tears
	name = "Tearful"
	desc = "Your attributes are weakened for a short period of time."
	icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
	icon_state = "tearful"

/datum/status_effect/tears/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		to_chat(owner, "<span class='danger'>Something once important to you is gone now. You feel like crying.</span>")
		L.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, -20)
		L.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, -20)
		L.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, -20)
		L.adjust_attribute_buff(JUSTICE_ATTRIBUTE, -20)

/datum/status_effect/tears/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/L = owner
		to_chat(owner, "<span class='nicegreen'>You feel your strength return to you.</span>")
		L.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 20)
		L.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 20)
		L.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 20)
		L.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 20)

#undef STATUS_EFFECT_TEARS

/datum/reagent/abnormality/bottle
	name = "Crumbs"
	description = "A small pile of slightly soggy crumbs."
	reagent_state = SOLID
	color = "#ad8978"
	health_restore = 2
	stat_changes = list(-4, -4, -4, -4)
