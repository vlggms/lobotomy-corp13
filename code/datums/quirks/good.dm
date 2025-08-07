//predominantly positive traits
//this file is named weirdly so that positive traits are listed above negative ones

/datum/quirk/resistant
	name = "Damage Resistant"
	desc = "You take 5% less damage from all sources."
	value = 6
	gain_text = "<span class='notice'>You feel a little tougher than before.</span>"
	medical_record_text = "Patient has an unnatural endurance and resistance to injuries."
	hardcore_value = -12

/datum/quirk/resistant/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	H.physiology.red_mod -= 0.05
	H.physiology.white_mod -= 0.05
	H.physiology.black_mod -= 0.05
	H.physiology.pale_mod -= 0.05

/datum/quirk/skilled
	name = "Prepared for Anything"
	desc = "You start with an additional 5 Attribute points in every Stat."
	value = 8
	gain_text = "<span class='notice'>You're ready to take on everything the City throws at you!</span>"
	medical_record_text = "Patient demonstrates a capacity for tenacity and grit."
	hardcore_value = -16

/datum/quirk/skilled/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	H.adjust_attribute_buff(FORTITUDE_ATTRIBUTE, 5)
	H.adjust_attribute_buff(PRUDENCE_ATTRIBUTE, 5)
	H.adjust_attribute_buff(TEMPERANCE_ATTRIBUTE, 5)
	H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, 5)

// Special quirks end

/datum/quirk/musician
	name = "Musician"
	desc = "You can tune handheld musical instruments to play melodies that sound sick."
	value = 1
	mob_trait = TRAIT_MUSICIAN
	gain_text = "<span class='notice'>You know everything about musical instruments.</span>"
	lose_text = "<span class='danger'>You forget how musical instruments work.</span>"
	medical_record_text = "Patient brain scans show a highly-developed auditory pathway."

/datum/quirk/musician/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/choice_beacon/music/B = new(get_turf(H))
	var/list/slots = list (
		"backpack" = ITEM_SLOT_BACKPACK,
		"hands" = ITEM_SLOT_HANDS,
	)
	H.equip_in_one_of_slots(B, slots , qdel_on_fail = TRUE)

/datum/quirk/alcohol_tolerance
	name = "Alcohol Tolerance"
	desc = "You become drunk more slowly and suffer fewer drawbacks from alcohol."
	value = 1
	mob_trait = TRAIT_ALCOHOL_TOLERANCE
	gain_text = "<span class='notice'>You feel like you could drink a whole keg!</span>"
	lose_text = "<span class='danger'>You don't feel as resistant to alcohol anymore. Somehow.</span>"
	medical_record_text = "Patient demonstrates a high tolerance for alcohol."

/datum/quirk/drunkhealing
	name = "Drunken Resilience"
	desc = "Nothing like a good drink to make you feel on top of the world. Whenever you're drunk, you slowly recover from injuries."
	value = 4
	mob_trait = TRAIT_DRUNK_HEALING
	gain_text = "<span class='notice'>You feel like a drink would do you good.</span>"
	lose_text = "<span class='danger'>You no longer feel like drinking would ease your pain.</span>"
	medical_record_text = "Patient has unusually efficient liver metabolism and can slowly regenerate wounds by drinking alcoholic beverages."

/datum/quirk/drunkhealing/on_process(delta_time)
	var/mob/living/carbon/C = quirk_holder
	switch(C.drunkenness)
		if (6 to 40)
			C.adjustBruteLoss(-0.1*delta_time, FALSE)
			C.adjustFireLoss(-0.05*delta_time, FALSE)
		if (41 to 60)
			C.adjustBruteLoss(-0.4*delta_time, FALSE)
			C.adjustFireLoss(-0.2*delta_time, FALSE)
		if (61 to INFINITY)
			C.adjustBruteLoss(-0.8*delta_time, FALSE)
			C.adjustFireLoss(-0.4*delta_time, FALSE)


/datum/quirk/freerunning
	name = "Freerunning"
	desc = "You're great at quick moves! You can climb tables more quickly and take no damage from short falls."
	value = 1
	mob_trait = TRAIT_FREERUNNING
	gain_text = "<span class='notice'>You feel lithe on your feet!</span>"
	lose_text = "<span class='danger'>You feel clumsy again.</span>"
	medical_record_text = "Patient scored highly on cardio tests."

/datum/quirk/light_step
	name = "Light Step"
	desc = "You walk with a gentle step; footsteps and stepping on sharp objects is quieter and less painful. Also, your hands and clothes will not get messed in case of stepping in blood."
	value = 1
	mob_trait = TRAIT_LIGHT_STEP
	gain_text = "<span class='notice'>You walk with a little more litheness.</span>"
	lose_text = "<span class='danger'>You start tromping around like a barbarian.</span>"
	medical_record_text = "Patient's dexterity belies a strong capacity for stealth."

/datum/quirk/light_step/on_spawn()
	var/datum/component/footstep/C = quirk_holder.GetComponent(/datum/component/footstep)
	if(C)
		C.volume *= 0.6
		C.e_range -= 2

/datum/quirk/night_vision
	name = "Night Vision"
	desc = "You can see slightly more clearly in full darkness than most people."
	value = 2
	mob_trait = TRAIT_NIGHT_VISION
	gain_text = "<span class='notice'>The shadows seem a little less dark.</span>"
	lose_text = "<span class='danger'>Everything seems a little darker.</span>"
	medical_record_text = "Patient's eyes show above-average acclimation to darkness."

/datum/quirk/night_vision/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/organ/eyes/eyes = H.getorgan(/obj/item/organ/eyes)
	if(!eyes || eyes.lighting_alpha)
		return
	eyes.refresh() //refresh their eyesight and vision

/datum/quirk/selfaware
	name = "Self-Aware"
	desc = "You know your body well, and can accurately assess the extent of your wounds."
	value = 4
	mob_trait = TRAIT_SELF_AWARE
	medical_record_text = "Patient demonstrates an uncanny knack for self-diagnosis."

/datum/quirk/skittish
	name = "Skittish"
	desc = "You're easy to startle, and hide frequently. Run into a closed locker to jump into it, as long as you have access. You can walk to avoid this."
	value = 4 //People used this in the past to hide from enemies
	mob_trait = TRAIT_SKITTISH
	medical_record_text = "Patient demonstrates a high aversion to danger and has described hiding in containers out of fear."

/datum/quirk/voracious
	name = "Voracious"
	desc = "Nothing gets between you and your food. You eat faster and can binge on junk food! Being fat suits you just fine."
	value = 1
	mob_trait = TRAIT_VORACIOUS
	gain_text = "<span class='notice'>You feel HONGRY.</span>"
	lose_text = "<span class='danger'>You no longer feel HONGRY.</span>"

/datum/quirk/nerd
	name = "Nerd"
	desc = "You take 5% less WHITE damage, but take 10% more RED damage. You spend all your free time playing niche video games and reading Korean light novels."
	value = 1
	gain_text = "<span class='notice'>You feel nervous about touching grass.</span>"
	medical_record_text = "Patient displays severe socially avoidant behaviours."

/datum/quirk/nerd/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	H.physiology.red_mod += 0.1
	H.physiology.white_mod -= 0.05

/datum/quirk/brawler
	name = "Brawler"
	desc = "You take 5% less RED damage, but take 10% more WHITE damage. Instead of getting an education, you chose to train and become the best Fixer in the City."
	value = 1
	gain_text = "<span class='notice'>Time to chew ass and kick bubblegum.</span>"
	medical_record_text = "Patient is more physically fit than the average person."

/datum/quirk/brawler/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	H.physiology.red_mod -= 0.05
	H.physiology.white_mod += 0.1

/datum/quirk/no_taste
	name = "Ageusia"
	desc = "You can't taste anything! Toxic food will still poison you."
	value = 1
	mob_trait = TRAIT_AGEUSIA
	gain_text = "<span class='notice'>You can't taste anything!</span>"
	lose_text = "<span class='notice'>You can taste again!</span>"
	medical_record_text = "Patient suffers from ageusia and is incapable of tasting food or reagents."

/datum/quirk/fan_clown
	name = "Clown Fan"
	desc = "You enjoy clown antics and get a mood boost from wearing your clown pin."
	value = 1
	mob_trait = TRAIT_FAN_CLOWN
	gain_text = "<span class='notice'>You are a big fan of clowns.</span>"
	lose_text = "<span class='danger'>The clown doesn't seem so great.</span>"
	medical_record_text = "Patient reports being a big fan of clowns."

/datum/quirk/fan_clown/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/clothing/accessory/fan_clown_pin/B = new(get_turf(H))
	var/list/slots = list (
		"backpack" = ITEM_SLOT_BACKPACK,
		"hands" = ITEM_SLOT_HANDS,
	)
	H.equip_in_one_of_slots(B, slots , qdel_on_fail = TRUE)
	var/datum/atom_hud/fan = GLOB.huds[DATA_HUD_FAN]
	fan.add_hud_to(H)

/datum/quirk/fan_mime
	name = "Mime Fan"
	desc = "You enjoy mime antics and get a mood boost from wearing your mime pin."
	value = 1
	mob_trait = TRAIT_FAN_MIME
	gain_text = "<span class='notice'>You are a big fan of the Mime.</span>"
	lose_text = "<span class='danger'>The mime doesn't seem so great.</span>"
	medical_record_text = "Patient reports being a big fan of mimes."

/datum/quirk/fan_mime/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/clothing/accessory/fan_mime_pin/B = new(get_turf(H))
	var/list/slots = list (
		"backpack" = ITEM_SLOT_BACKPACK,
		"hands" = ITEM_SLOT_HANDS,
	)
	H.equip_in_one_of_slots(B, slots , qdel_on_fail = TRUE)
	var/datum/atom_hud/fan = GLOB.huds[DATA_HUD_FAN]
	fan.add_hud_to(H)
