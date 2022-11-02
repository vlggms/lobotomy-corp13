/*
Coded by nutterbutter, "senior" junior developer, during hell week 2022.
Finally, an abnormality that DOESN'T have to do any fancy movement shit. It's a miracle. Praise be.
TODO:
1. EGO. (Currently deferred.)
2. Instinct work inflicts red AND white damage; gives new status effect
3. Counter 0 behavior; harsher works, ranged white
4. Counter restoration pass/fail effects
*/

/mob/living/simple_animal/hostile/abnormality/singing_machine
	name = "Singing Machine"
	desc = "A shiny metallic device with a large hinge. You feel a sense of dread about what might be inside..."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "singingmachine_closed_clean"
	icon_living = "singingmachine_closed_clean"
	maxHealth = 200
	health = 200
	threat_level = HE_LEVEL
	start_qliphoth = 2
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(55, 55, 60, 60, 65),
		ABNORMALITY_WORK_INSIGHT = 40,
		ABNORMALITY_WORK_ATTACHMENT = 0,
		ABNORMALITY_WORK_REPRESSION = 40
	)
	// Slightly nerfed Insight work to make Instinct the blatant best option. Also nerfed high-level Attachment.
	work_damage_amount = 12
	work_damage_type = WHITE_DAMAGE
	ego_list = list(
		)
	pixel_x = -8
	base_pixel_x = -8
	buckled_mobs = list()
	buckle_lying = TRUE
	var/deniedFort = 0
	var/grinding = FALSE
	var/bonusRed = 0
	var/grindRed = 4
	var/minceRed = 12
	var/workSpeed

/mob/living/simple_animal/hostile/abnormality/singing_machine/neutral_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-(prob(50)))
	return ..()

/mob/living/simple_animal/hostile/abnormality/singing_machine/failure_effect(mob/living/carbon/human/user, work_type, pe)
	datum_reference.qliphoth_change(-1)
	return ..()

/mob/living/simple_animal/hostile/abnormality/singing_machine/attempt_work(mob/living/carbon/human/user, work_type)
	if(work_type == ABNORMALITY_WORK_INSTINCT)
		workSpeed = 2 SECONDS / (1 + ((get_attribute_level(user, TEMPERANCE_ATTRIBUTE) + datum_reference.understanding) / 100))
		say("calculated workspeed is [workSpeed]")
		addtimer(CALLBACK(src, .proc/doBonusDamage, user), workSpeed/2)
		if(datum_reference.qliphoth_meter > 0)
			bonusRed = grindRed
		else
			bonusRed = minceRed
	else if(get_attribute_level(user, FORTITUDE_ATTRIBUTE) >= 80) // I see your fortitude is high, but you're choosing another work type. Well, fuck you too.
		deniedFort = get_attribute_level(user, FORTITUDE_ATTRIBUTE) - 80
	return ..()

/mob/living/simple_animal/hostile/abnormality/singing_machine/work_complete(mob/living/carbon/human/user, work_type, pe)
	if(bonusRed)
		bonusRed = 0
	return ..()

/mob/living/simple_animal/hostile/abnormality/singing_machine/proc/doBonusDamage(mob/living/carbon/human/user)
	if(datum_reference.working)
		addtimer(CALLBACK(src, .proc/doBonusDamage, user), workSpeed)
		user.apply_damage(bonusRed, RED_DAMAGE, null, user.run_armor_check(null, RED_DAMAGE))
		user.say("ow.")
