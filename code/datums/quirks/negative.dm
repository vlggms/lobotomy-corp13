//predominantly negative traits

/// Defines for locations of items being added to your inventory on spawn
#define LOCATION_LPOCKET "in your left pocket"
#define LOCATION_RPOCKET "in your right pocket"
#define LOCATION_BACKPACK "in your backpack"
#define LOCATION_HANDS "in your hands"

// we give 1 point to quirks that minorly affect gameplay negativelly, like heavy sleeper that only practical negative shows up with apocalypse birb.
// we give 2 points to quirks that noticably affect gameplay negativelly, like being deaf since you might not hear some very important info on comms, but generally its fine-ish.
// we give 4 points to quirks that completelly change gameplay by taking away important things, or to quirks that will kill you. Like parapalegic that permanently bounds you to speed of a wheelchair or blindness that makes you... well blind.

// Red damage quirks start
/datum/quirk/minor_red
	name = "Minor RED Damage Weakness"
	desc = "You take 10% more RED damage."
	value = -1
	gain_text = "<span class='danger'>You feel a bit weaker to RED damage.</span>"
	medical_record_text = "Patient is observed to take 10% more RED damage."
	hardcore_value = 2

/datum/quirk/minor_red/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	H.physiology.red_mod += 0.10

/datum/quirk/major_red
	name = "Major RED Damage Weakness"
	desc = "You take 25% more RED damage."
	value = -2
	gain_text = "<span class='danger'>You feel weaker to RED damage.</span>"
	medical_record_text = "Patient is observed to take 25% more RED damage."
	hardcore_value = 4

/datum/quirk/major_red/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	H.physiology.red_mod += 0.25

/datum/quirk/fatal_red
	name = "Fatal RED Damage Weakness"
	desc = "You take twice as much RED damage."
	value = -4
	gain_text = "<span class='danger'>You feel extremely weak to RED damage.</span>"
	medical_record_text = "Patient is observed to take twice as much RED damage."
	hardcore_value = 8

/datum/quirk/fatal_red/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	H.physiology.red_mod += 1.00

// White damage quirks start

/datum/quirk/minor_white
	name = "Minor WHITE Damage Weakness"
	desc = "You take 10% more WHITE damage."
	value = -1
	gain_text = "<span class='danger'>You feel a bit weaker to WHITE damage.</span>"
	medical_record_text = "Patient is observed to take 10% more WHITE damage."
	hardcore_value = 2

/datum/quirk/minor_white/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	H.physiology.white_mod += 0.10

/datum/quirk/major_white
	name = "Major WHITE Damage Weakness"
	desc = "You take 25% more WHITE damage."
	value = -2
	gain_text = "<span class='danger'>You feel weaker to WHITE damage.</span>"
	medical_record_text = "Patient is observed to take 25% more WHITE damage."
	hardcore_value = 4

/datum/quirk/major_white/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	H.physiology.white_mod += 0.25

/datum/quirk/fatal_white
	name = "Fatal WHITE Damage Weakness"
	desc = "You take twice as much WHITE damage."
	value = -4
	gain_text = "<span class='danger'>You feel extremely weak to WHITE damage.</span>"
	medical_record_text = "Patient is observed to take twice as much WHITE damage."
	hardcore_value = 8

/datum/quirk/fatal_white/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	H.physiology.white_mod += 1.00

	// Black damage quirks start

/datum/quirk/minor_black
	name = "Minor BLACK Damage Weakness"
	desc = "You take 10% more BLACK damage."
	value = -1
	gain_text = "<span class='danger'>You feel a bit weaker to BLACK damage.</span>"
	medical_record_text = "Patient is observed to take 10% more BLACK damage."
	hardcore_value = 2

/datum/quirk/minor_black/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	H.physiology.black_mod += 0.10

/datum/quirk/major_black
	name = "Major BLACK Damage Weakness"
	desc = "You take 25% more BLACK damage."
	value = -2
	gain_text = "<span class='danger'>You feel weaker to BLACK damage.</span>"
	medical_record_text = "Patient is observed to take 25% more BLACK damage."
	hardcore_value = 4

/datum/quirk/major_black/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	H.physiology.black_mod += 0.25

/datum/quirk/fatal_black
	name = "Fatal BLACK Damage Weakness"
	desc = "You take twice as much BLACK damage."
	value = -4
	gain_text = "<span class='danger'>You feel extremely weak to BLACK damage.</span>"
	medical_record_text = "Patient is observed to take twice as much BLACK damage."
	hardcore_value = 8

/datum/quirk/fatal_black/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	H.physiology.black_mod += 1.00

	// Pale damage quirks start

/datum/quirk/minor_pale
	name = "Minor PALE Damage Weakness"
	desc = "You take 10% more PALE damage."
	value = -1
	gain_text = "<span class='danger'>You feel a bit weaker to PALE damage.</span>"
	medical_record_text = "Patient is observed to take 10% more PALE damage."
	hardcore_value = 2

/datum/quirk/minor_pale/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	H.physiology.pale_mod += 0.10

/datum/quirk/major_pale
	name = "Major PALE Damage Weakness"
	desc = "You take 25% more PALE damage."
	value = -2
	gain_text = "<span class='danger'>You feel weaker to PALE damage.</span>"
	medical_record_text = "Patient is observed to take 25% more PALE damage."
	hardcore_value = 4

/datum/quirk/major_pale/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	H.physiology.pale_mod += 0.25

/datum/quirk/fatal_pale
	name = "Fatal PALE Damage Weakness"
	desc = "You take twice as much PALE damage."
	value = -4
	gain_text = "<span class='danger'>You feel extremely weak to PALE damage.</span>"
	medical_record_text = "Patient is observed to take twice as much PALE damage."
	hardcore_value = 8

/datum/quirk/fatal_pale/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	H.physiology.pale_mod += 1.00

// Challenge quirks start (they cause players to resort to a unique playstyle.)
/datum/quirk/guns
	name = "Challenge: No Guns"
	desc = "You refuse to use ranged weaponry such as guns. You know better than going into debt from replacing all those bullets."
	value = -1
	mob_trait = TRAIT_NOGUNS
	gain_text = "<span class='danger'>You can't bring yourself to use ranged weapons!</span>"
	medical_record_text = "Patient vehemently refuses to use guns due to \"financial concerns\"."
	hardcore_value = 0

/datum/quirk/healing
	name = "Challenge: No Medipens"
	desc = "You are unable to be healed by chemicals reagents used in medipens and sleepers."
	value = -1
	mob_trait = TRAIT_HEALING
	gain_text = "<span class='danger'>You didn't feel anything when taking those pills...</span>"
	medical_record_text = "Patient is unable to metabolize common medicines."
	hardcore_value = 0

/datum/quirk/nonviolent //Renamed pacifist trait
	name = "Challenge: No Attacking"
	desc = "You are unable to inflict violence against Abnormalities or people. This is a horrible idea."
	value = -1
	mob_trait = TRAIT_PACIFISM
	gain_text = "<span class='danger'>You feel repulsed by the thought of violence!</span>"
	lose_text = "<span class='notice'>You think you can defend yourself again, thank god.</span>"
	medical_record_text = "Patient is incapable of violent acts, no matter the circumstances."
	hardcore_value = 0

// Special quirks end

/datum/quirk/blooddeficiency // mostly dosent affect gameplay, MOSB and mermaid are the only ones affected
	name = "Blood Deficiency"
	desc = "Your body can't produce enough blood to sustain itself."
	value = -1
	gain_text = "<span class='danger'>You feel your vigor slowly fading away.</span>"
	lose_text = "<span class='notice'>You feel vigorous again.</span>"
	medical_record_text = "Patient requires regular treatment for blood loss due to low production of blood."
	hardcore_value = 2

/datum/quirk/blooddeficiency/on_process(delta_time)
	var/mob/living/carbon/human/H = quirk_holder
	if(NOBLOOD in H.dna.species.species_traits) //can't lose blood if your species doesn't have any
		return
	else
		if (H.blood_volume > (BLOOD_VOLUME_SAFE - 25)) // survivable
			H.blood_volume -= 0.275 * delta_time

/datum/quirk/blindness
	name = "Blind"
	desc = "You are completely blind, nothing can counteract this."
	value = -4
	gain_text = "<span class='danger'>You can't see anything.</span>"
	lose_text = "<span class='notice'>You miraculously gain back your vision.</span>"
	medical_record_text = "Patient has permanent blindness."
	hardcore_value = 15

/datum/quirk/blindness/add()
	quirk_holder.become_blind(ROUNDSTART_TRAIT)

/datum/quirk/blindness/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/clothing/glasses/meson/B = new(get_turf(H))
	if(!H.equip_to_slot_if_possible(B, ITEM_SLOT_EYES, bypass_equip_delay_self = TRUE)) //if you can't put it on the user's eyes, put it in their hands, otherwise put it on their eyes
		H.put_in_hands(B)

	/* A couple of brain tumor stats for anyone curious / looking at this quirk for balancing:
	 * - It takes less 16 minute 40 seconds to die from brain death due to a brain tumor.
	 * - It takes 1 minutes 40 seconds to take 10% (20 organ damage) brain damage.
	 * - 5u mannitol will heal 12.5% (25 organ damage) brain damage
	 */
/datum/quirk/brainproblems
	name = "Brain Tumor"
	desc = "You have a little friend in your brain that is slowly destroying it. Better bring some mannitol!"
	value = -4
	gain_text = "<span class='danger'>You feel smooth.</span>"
	lose_text = "<span class='notice'>You feel wrinkled again.</span>"
	medical_record_text = "Patient has a tumor in their brain that is slowly driving them to brain death."
	hardcore_value = 8
	/// Location of the bottle of pills on spawn
	var/where
	var/where_lob
	var/safety_warning = TRUE

/datum/quirk/brainproblems/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/pills = new /obj/item/storage/pill_bottle/mannitol/braintumor()
	var/lob = new /obj/item/lobotomizer()
	var/list/slots = list(
		LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
		LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
		LOCATION_BACKPACK = ITEM_SLOT_BACKPACK,
		LOCATION_HANDS = ITEM_SLOT_HANDS
	)
	where = H.equip_in_one_of_slots(pills, slots, FALSE) || "at your feet"
	where_lob = H.equip_in_one_of_slots(lob, slots, FALSE) || "at your feet"

/datum/quirk/brainproblems/post_add()
	if(where == LOCATION_BACKPACK || where_lob == LOCATION_BACKPACK)
		var/mob/living/carbon/human/H = quirk_holder
		SEND_SIGNAL(H.back, COMSIG_TRY_STORAGE_SHOW, H)

	to_chat(quirk_holder, "<span class='boldnotice'>There is a bottle of mannitol pills [where] to keep you alive until you can secure a supply of medication. Don't rely on it too much!</span>")
	to_chat(quirk_holder, "<span class='boldnotice'>There is also an experimental lobotomizer [where_lob] to forcefully excise the damaged parts from your brain.</span>")

/datum/quirk/brainproblems/on_process(delta_time)
	if(HAS_TRAIT(quirk_holder, TRAIT_TUMOR_SUPPRESSED))
		return
	quirk_holder.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.2 * delta_time)

	var/brain_loss = quirk_holder.getOrganLoss(ORGAN_SLOT_BRAIN)
	if(brain_loss >= 175 && safety_warning)
		to_chat(quirk_holder, "<span class='userdanger'>It's starting to get hard to form any thoughts, all your senses are failing as well. You feel like your brain is reaching its limit!</span>")
		safety_warning = FALSE
	if(brain_loss < 175 && !(safety_warning))
		safety_warning = TRUE

/datum/quirk/deafness
	name = "Deaf"
	desc = "You are incurably deaf."
	value = -2
	mob_trait = TRAIT_DEAF
	gain_text = "<span class='danger'>You can't hear anything.</span>"
	lose_text = "<span class='notice'>You're able to hear again!</span>"
	medical_record_text = "Patient's cochlear nerve is incurably damaged."
	hardcore_value = 4


/datum/quirk/heavy_sleeper
	name = "Heavy Sleeper"
	desc = "You sleep like a rock! Whenever you're put to sleep or knocked unconscious, you take a little bit longer to wake up."
	value = -1
	mob_trait = TRAIT_HEAVY_SLEEPER
	gain_text = "<span class='danger'>You feel sleepy.</span>"
	lose_text = "<span class='notice'>You feel awake again.</span>"
	medical_record_text = "Patient has abnormal sleep study results and is difficult to wake up."
	hardcore_value = 2

/datum/quirk/nyctophobia
	name = "Nyctophobia"
	desc = "As far as you can remember, you've always been afraid of the dark. While in the dark without a light source, you instinctually act careful, and constantly feel a sense of dread."
	value = -1
	medical_record_text = "Patient demonstrates a fear of the dark. (Seriously?)"
	hardcore_value = 5

/datum/quirk/nyctophobia/on_process()
	var/mob/living/carbon/human/H = quirk_holder
	if(H.dna.species.id in list("shadow", "nightmare"))
		return //we're tied with the dark, so we don't get scared of it; don't cleanse outright to avoid cheese
	var/turf/T = get_turf(quirk_holder)
	var/lums = T.get_lumcount()
	if(lums <= 0.2)
		if(quirk_holder.m_intent == MOVE_INTENT_RUN)
			to_chat(quirk_holder, "<span class='warning'>Easy, easy, take it slow... you're in the dark...</span>")
			quirk_holder.toggle_move_intent()

/datum/quirk/paraplegic
	name = "Paraplegic"
	desc = "Your legs do not function. Nothing will ever fix this. But hey, free wheelchair!"
	value = -4
	human_only = TRUE
	gain_text = null // Handled by trauma.
	lose_text = null
	medical_record_text = "Patient has an untreatable impairment in motor function in the lower extremities."
	hardcore_value = 15

/datum/quirk/paraplegic/add()
	var/datum/brain_trauma/severe/paralysis/paraplegic/T = new()
	var/mob/living/carbon/human/H = quirk_holder
	H.gain_trauma(T, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/paraplegic/on_spawn()
	if(quirk_holder.buckled) // Handle late joins being buckled to arrival shuttle chairs.
		quirk_holder.buckled.unbuckle_mob(quirk_holder)

	var/turf/T = get_turf(quirk_holder)
	var/obj/structure/chair/spawn_chair = locate() in T

	var/obj/vehicle/ridden/wheelchair/wheels
	if(quirk_holder.client?.get_award_status(HARDCORE_RANDOM_SCORE) >= 5000) //More than 5k score? you unlock the gamer wheelchair.
		wheels = new /obj/vehicle/ridden/wheelchair/gold(T)
	else
		wheels = new(T)
	if(spawn_chair) // Makes spawning on the arrivals shuttle more consistent looking
		wheels.setDir(spawn_chair.dir)

	wheels.buckle_mob(quirk_holder)

	// During the spawning process, they may have dropped what they were holding, due to the paralysis
	// So put the things back in their hands.

	for(var/obj/item/I in T)
		if(I.fingerprintslast == quirk_holder.ckey)
			quirk_holder.put_in_hands(I)

/datum/quirk/prosopagnosia
	name = "Prosopagnosia"
	desc = "You have a mental disorder that prevents you from being able to recognize faces at all."
	value = -1
	mob_trait = TRAIT_PROSOPAGNOSIA
	medical_record_text = "Patient suffers from prosopagnosia and cannot recognize faces."
	hardcore_value = 5

/datum/quirk/prosthetic_limb
	name = "Prosthetic Limb"
	desc = "An accident caused you to lose one of your limbs. Because of this, you now have a random prosthetic!"
	value = -2
	var/slot_string = "limb"
	medical_record_text = "During physical examination, patient was found to have a prosthetic limb."
	hardcore_value = 3
	var/limb_slot // Tegustation Prosthetic limbs edit - adding a limb slot for those who manually chose a limb

/datum/quirk/prosthetic_limb/on_spawn()
//	var/limb_slot = pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	if(!limb_slot) // Tegustation Prosthetic limbs edit - If it's empty - it will choose random limb.
		limb_slot = pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG) // Tegustation Prosthetic limbs edit - Commented out TG code above, replaced with this
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/bodypart/old_part = H.get_bodypart(limb_slot)
	var/obj/item/bodypart/prosthetic
	switch(limb_slot)
		if(BODY_ZONE_L_ARM)
			prosthetic = new/obj/item/bodypart/l_arm/robot/surplus(quirk_holder)
			slot_string = "left arm"
		if(BODY_ZONE_R_ARM)
			prosthetic = new/obj/item/bodypart/r_arm/robot/surplus(quirk_holder)
			slot_string = "right arm"
		if(BODY_ZONE_L_LEG)
			prosthetic = new/obj/item/bodypart/l_leg/robot/surplus(quirk_holder)
			slot_string = "left leg"
		if(BODY_ZONE_R_LEG)
			prosthetic = new/obj/item/bodypart/r_leg/robot/surplus(quirk_holder)
			slot_string = "right leg"
	prosthetic.replace_limb(H)
	qdel(old_part)
	H.regenerate_icons()

/datum/quirk/prosthetic_limb/post_add()
	to_chat(quirk_holder, "<span class='boldannounce'>Your [slot_string] has been replaced with a surplus prosthetic. It is fragile and will easily come apart under duress. Additionally, \
	you need to use a welding tool and cables to repair it, instead of bruise packs and ointment.</span>")

/datum/quirk/insanity
	name = "Reality Dissociation Syndrome"
	desc = "You suffer from a severe disorder that causes very vivid hallucinations. Mindbreaker toxin can suppress its effects, and you are immune to mindbreaker's hallucinogenic properties. <b>This is not a license to grief.</b>"
	value = -4
	//no mob trait because it's handled uniquely
	gain_text = "<span class='userdanger'>...</span>"
	lose_text = "<span class='notice'>You feel in tune with the world again.</span>"
	medical_record_text = "Patient suffers from acute Reality Dissociation Syndrome and experiences vivid hallucinations."
	hardcore_value = 6

/datum/quirk/insanity/on_process(delta_time)
	if(quirk_holder.reagents.has_reagent(/datum/reagent/toxin/mindbreaker, needs_metabolizing = TRUE))
		quirk_holder.hallucination = 0
		return
	if(DT_PROB(2, delta_time)) //we'll all be mad soon enough
		madness()

/datum/quirk/insanity/proc/madness()
	quirk_holder.hallucination += rand(10, 25)

/datum/quirk/insanity/post_add() //I don't /think/ we'll need this but for newbies who think "roleplay as insane" = "license to kill" it's probably a good thing to have
	if(!quirk_holder.mind || quirk_holder.mind.special_role)
		return
	to_chat(quirk_holder, "<span class='big bold info'>Please note that your dissociation syndrome does NOT give you the right to attack people or otherwise cause any interference to \
	the round. You are not an antagonist, and the rules will treat you the same as other crewmembers.</span>")

/datum/quirk/social_anxiety
	name = "Social Anxiety"
	desc = "Talking to people is very difficult for you, and you often stutter or even lock up."
	value = -1
	gain_text = "<span class='danger'>You start worrying about what you're saying.</span>"
	lose_text = "<span class='notice'>You feel easier about talking again.</span>" //if only it were that easy!
	medical_record_text = "Patient is usually anxious in social encounters and prefers to avoid them."
	hardcore_value = 4
	mob_trait = TRAIT_ANXIOUS
	var/dumb_thing = TRUE

/datum/quirk/social_anxiety/add()
	RegisterSignal(quirk_holder, COMSIG_MOB_EYECONTACT, PROC_REF(eye_contact))
	RegisterSignal(quirk_holder, COMSIG_MOB_EXAMINATE, PROC_REF(looks_at_floor))

/datum/quirk/social_anxiety/remove()
	UnregisterSignal(quirk_holder, list(COMSIG_MOB_EYECONTACT, COMSIG_MOB_EXAMINATE))

/datum/quirk/social_anxiety/on_process(delta_time)
	if(HAS_TRAIT(quirk_holder, TRAIT_FEARLESS))
		return
	var/nearby_people = 0
	for(var/mob/living/carbon/human/H in oview(3, quirk_holder))
		if(H.client)
			nearby_people++
	var/mob/living/carbon/human/H = quirk_holder
	if(DT_PROB(2 + nearby_people, delta_time))
		H.stuttering = max(3, H.stuttering)
	else if(DT_PROB(min(3, nearby_people), delta_time) && !H.silent)
		to_chat(H, "<span class='danger'>You retreat into yourself. You <i>really</i> don't feel up to talking.</span>")
		H.silent = max(10, H.silent)
	else if(DT_PROB(0.5, delta_time) && dumb_thing)
		to_chat(H, "<span class='userdanger'>You think of a dumb thing you said a long time ago and scream internally.</span>")
		dumb_thing = FALSE //only once per life
		if(prob(1))
			new/obj/item/food/spaghetti/pastatomato(get_turf(H)) //now that's what I call spaghetti code

// small chance to make eye contact with inanimate objects/mindless mobs because of nerves
/datum/quirk/social_anxiety/proc/looks_at_floor(datum/source, atom/A)
	SIGNAL_HANDLER

	var/mob/living/mind_check = A
	if(prob(85) || (istype(mind_check) && mind_check.mind))
		return

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), quirk_holder, "<span class='smallnotice'>You make eye contact with [A].</span>"), 3)

/datum/quirk/social_anxiety/proc/eye_contact(datum/source, mob/living/other_mob, triggering_examiner)
	SIGNAL_HANDLER

	if(prob(75))
		return
	var/msg
	if(triggering_examiner)
		msg = "You make eye contact with [other_mob], "
	else
		msg = "[other_mob] makes eye contact with you, "

	switch(rand(1,3))
		if(1)
			quirk_holder.Jitter(10)
			msg += "causing you to start fidgeting!"
		if(2)
			quirk_holder.stuttering = max(3, quirk_holder.stuttering)
			msg += "causing you to start stuttering!"
		if(3)
			quirk_holder.Stun(2 SECONDS)
			msg += "causing you to freeze up!"

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), quirk_holder, "<span class='userdanger'>[msg]</span>"), 3) // so the examine signal has time to fire and this will print after
	return COMSIG_BLOCK_EYECONTACT


/datum/quirk/junkie
	name = "Junkie"
	desc = "You can't get enough of hard drugs."
	value = -1
	gain_text = "<span class='danger'>You suddenly feel the craving for drugs.</span>"
	medical_record_text = "Patient has a history of hard drugs."
	hardcore_value = 4
	var/drug_list = list(/datum/reagent/drug/crank, /datum/reagent/drug/krokodil, /datum/reagent/medicine/morphine, /datum/reagent/drug/happiness, /datum/reagent/drug/methamphetamine) //List of possible IDs
	var/datum/reagent/reagent_type //!If this is defined, reagent_id will be unused and the defined reagent type will be instead.
	var/datum/reagent/reagent_instance //! actual instanced version of the reagent
	var/where_drug //! Where the drug spawned
	var/obj/item/drug_container_type //! If this is defined before pill generation, pill generation will be skipped. This is the type of the pill bottle.
	var/where_accessory //! where the accessory spawned
	var/obj/item/accessory_type //! If this is null, an accessory won't be spawned.
	var/process_interval = 30 SECONDS //! how frequently the quirk processes
	var/next_process = 0 //! ticker for processing

/datum/quirk/junkie/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	if (!reagent_type)
		reagent_type = pick(drug_list)
	reagent_instance = new reagent_type()
	for(var/addiction in reagent_instance.addiction_types)
		H.mind.add_addiction_points(addiction, 1000) ///Max that shit out
	var/current_turf = get_turf(quirk_holder)
	if (!drug_container_type)
		drug_container_type = /obj/item/storage/pill_bottle
	var/obj/item/drug_instance = new drug_container_type(current_turf)
	if (istype(drug_instance, /obj/item/storage/pill_bottle))
		var/pill_state = "pill[rand(1,20)]"
		for(var/i in 1 to 7)
			var/obj/item/reagent_containers/pill/P = new(drug_instance)
			P.icon_state = pill_state
			P.reagents.add_reagent(reagent_type, 3)

	var/obj/item/accessory_instance
	if (accessory_type)
		accessory_instance = new accessory_type(current_turf)
	var/list/slots = list(
		LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
		LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
		LOCATION_BACKPACK = ITEM_SLOT_BACKPACK
	)
	where_drug = H.equip_in_one_of_slots(drug_instance, slots, FALSE) || "at your feet"
	if (accessory_instance)
		where_accessory = H.equip_in_one_of_slots(accessory_instance, slots, FALSE) || "at your feet"
	announce_drugs()

/datum/quirk/junkie/post_add()
	if(where_drug == LOCATION_BACKPACK || where_accessory == LOCATION_BACKPACK)
		var/mob/living/carbon/human/H = quirk_holder
		SEND_SIGNAL(H.back, COMSIG_TRY_STORAGE_SHOW, H)

/datum/quirk/junkie/remove()
	if(quirk_holder && reagent_instance)
		for(var/addiction_type in subtypesof(/datum/addiction))
			quirk_holder.mind.remove_addiction_points(addiction_type, MAX_ADDICTION_POINTS) //chat feedback here. No need of lose_text.

/datum/quirk/junkie/proc/announce_drugs()
	to_chat(quirk_holder, "<span class='boldnotice'>There is a [initial(drug_container_type.name)] of [initial(reagent_type.name)] [where_drug]. Better hope you don't run out...</span>")

/datum/quirk/junkie/on_process()
	if(HAS_TRAIT(quirk_holder, TRAIT_NOMETABOLISM))
		return
	var/mob/living/carbon/human/H = quirk_holder
	if(world.time > next_process)
		next_process = world.time + process_interval
		var/deleted = QDELETED(reagent_instance)
		var/missing_addiction = FALSE
		for(var/addiction_type in reagent_instance.addiction_types)
			if(!LAZYACCESS(H.mind.active_addictions, addiction_type))
				missing_addiction = TRUE
		if(deleted || missing_addiction)
			if(deleted)
				reagent_instance = new reagent_type()
			to_chat(quirk_holder, "<span class='danger'>You thought you kicked it, but you feel like you're falling back onto bad habits..</span>")
			for(var/addiction in reagent_instance.addiction_types)
				H.mind.add_addiction_points(addiction, 1000) ///Max that shit out

/datum/quirk/junkie/smoker
	name = "Smoker"
	desc = "Sometimes you just really want a smoke. Probably not great for your lungs."
	value = -1
	gain_text = "<span class='danger'>You could really go for a smoke right about now.</span>"
	medical_record_text = "Patient is a current smoker."
	reagent_type = /datum/reagent/drug/nicotine
	accessory_type = /obj/item/lighter/greyscale
	hardcore_value = 1

/datum/quirk/junkie/smoker/on_spawn()
	drug_container_type = pick(/obj/item/storage/fancy/cigarettes,
		/obj/item/storage/fancy/cigarettes/cigpack_midori,
		/obj/item/storage/fancy/cigarettes/cigpack_uplift,
		/obj/item/storage/fancy/cigarettes/cigpack_robust,
		/obj/item/storage/fancy/cigarettes/cigpack_robustgold,
		/obj/item/storage/fancy/cigarettes/cigpack_carp)
	quirk_holder?.mind?.store_memory("Your favorite cigarette packets are [initial(drug_container_type.name)]s.")
	. = ..()

/datum/quirk/junkie/smoker/announce_drugs()
	to_chat(quirk_holder, "<span class='boldnotice'>There is a [initial(drug_container_type.name)] [where_drug], and a lighter [where_accessory].</span>")


#undef LOCATION_LPOCKET
#undef LOCATION_RPOCKET
#undef LOCATION_BACKPACK
#undef LOCATION_HANDS
