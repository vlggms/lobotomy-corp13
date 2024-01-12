//traits with no real impact that can be taken freely
//MAKE SURE THESE DO NOT MAJORLY IMPACT GAMEPLAY. those should be positive or negative traits.

/datum/quirk/nerd
	name = "Nerd"
	desc = "You take 5% less WHITE damage, but take 10% more RED damage. You spend all your free time playing niche video games and reading Korean light novels."
	value = 0
	gain_text = "<span class='notice'>You feel nervous about touching grass.</span>"
	medical_record_text = "Patient displays severe socially avoidant behaviours."

/datum/quirk/nerd/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	H.physiology.red_mod += 0.1
	H.physiology.white_mod -= 0.05

/datum/quirk/brawler
	name = "Brawler"
	desc = "You take 5% less RED damage, but take 10% more WHITE damage. Instead of getting an education, you chose to train and become the best Fixer in the City."
	value = 0
	gain_text = "<span class='notice'>Time to chew ass and kick bubblegum.</span>"
	medical_record_text = "Patient is more physically fit than the average person."

/datum/quirk/brawler/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	H.physiology.red_mod -= 0.05
	H.physiology.white_mod += 0.1

/datum/quirk/family_heirloom // re-naming the quirk in the code causes a lot of problems, so leaving it as-is
	name = "Plushie Lover"
	desc = "You love plushies so much that you take them to work with you. You start with one plushie that changes based on your job."
	value = 0
	var/obj/item/heirloom
	var/where
	medical_record_text = "Patient is highly dependent on a plushie for mental stability."

/datum/quirk/family_heirloom/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/heirloom_type
	switch(quirk_holder.mind.assigned_role)
		// Command
		if("Manager")
			heirloom_type = pick(/obj/item/toy/plush/angela)
		if("Extraction Officer")
			heirloom_type = pick(/obj/item/toy/plush/binah)
		if("Records Officer")
			heirloom_type = pick(/obj/item/toy/plush/hokma)
		if("Agent Captain")
			heirloom_type = pick(/obj/item/toy/plush/mosb, /obj/item/toy/plush/melt)
		if("Sephirah") //Today im NOT giving a GUN to HOD
			heirloom_type = pick(/obj/item/toy/plush/malkuth, /obj/item/toy/plush/netzach, /obj/item/toy/plush/hod, /obj/item/toy/plush/lisa, /obj/item/toy/plush/enoch, /obj/item/toy/plush/yesod, /obj/item/toy/plush/gebura)
		// Common folk
		if("Agent")
			heirloom_type = pick(/obj/item/toy/plush/bigbird, /obj/item/toy/plush/big_bad_wolf, /obj/item/toy/plush/pinocchio)
		if("Agent Intern")
			heirloom_type = pick(/obj/item/toy/plush/scorched)
		if("Clerk")
			heirloom_type = pick(/obj/item/toy/plush/moth)
		// Ruins test
		if("Rabbit Team Leader")
			heirloom_type = pick(/obj/item/toy/plush/myo)
		if("Rabbit Team")
			heirloom_type = pick(/obj/item/toy/plush/rabbit)
	if(!heirloom_type) // non Lobotomy corp gamemode
		heirloom_type = pick(
		/obj/item/toy/plush/carpplushie,
		/obj/item/toy/plush/lizardplushie,
		/obj/item/toy/plush/snakeplushie,
		/obj/item/toy/plush/nukeplushie,
		/obj/item/toy/plush/slimeplushie,
		/obj/item/toy/plush/beeplushie,
		/obj/item/toy/plush/moth,
		/obj/item/toy/plush/rabbit, //some Lobotomy Corp plushes
		/obj/item/toy/plush/bigbird,
		/obj/item/toy/plush/big_bad_wolf,
		/obj/item/toy/plush/fumo)
	heirloom = new heirloom_type(get_turf(quirk_holder))
	var/list/slots = list(
		LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
		LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
		LOCATION_HANDS = ITEM_SLOT_HANDS
	)
	where = H.equip_in_one_of_slots(heirloom, slots, FALSE) || "at your feet"

/datum/quirk/family_heirloom/post_add()
	to_chat(quirk_holder, "<span class='boldnotice'>There is a precious family [heirloom.name] [where], passed down from generation to generation. Keep it safe!</span>")

	var/list/names = splittext(quirk_holder.real_name, " ")
	var/family_name = names[names.len]

	heirloom.AddComponent(/datum/component/heirloom, quirk_holder.mind, family_name)

/datum/quirk/artist
	name = "Artist"
	desc = "You are an artist who constantly seek out inspiration in your enviroment. You always carry some art supplies on you."
	value = 0
	medical_record_text = "Patient demonstrates violent tendencies when painting supplies are removed from their possession."

/datum/quirk/artist/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/list/banned = list("rcorp", "wcorp", "city")
	if(SSmaptype.maptype in banned)
		to_chat(H, "<span class='warning'>There was no time to grab your art supplies!</span>")
		return
	var/obj/item/storage/toolbox/artistic/art = new(get_turf(H))
	H.put_in_hands(art)

/datum/quirk/lipstick
	name = "Glossy"
	desc = "You always carry a stick of lipstick with you. Wouldn't want to get caught not looking beautiful."
	value = 0
	medical_record_text = "The patient always has has always shown up to their appointments wearing lipstick"

/datum/quirk/lipstick/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/lipstick/random/lipstick = new(get_turf(H))
	var/list/slots = list(
		LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
		LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
		LOCATION_HANDS = ITEM_SLOT_HANDS
	)
	H.equip_in_one_of_slots(lipstick, slots, FALSE)
// Special quirks end

/datum/quirk/nearsighted //t. errorage
	name = "Nearsighted"
	desc = "You are nearsighted without prescription glasses, but spawn with a pair."
	value = 0
	gain_text = "<span class='danger'>Things far away from you start looking blurry.</span>"
	lose_text = "<span class='notice'>You start seeing faraway things normally again.</span>"
	medical_record_text = "Patient requires prescription glasses in order to counteract nearsightedness."

/datum/quirk/nearsighted/add()
	quirk_holder.become_nearsighted(ROUNDSTART_TRAIT)

/datum/quirk/nearsighted/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/clothing/glasses/regular/glasses = new(get_turf(H))
	if(!H.equip_to_slot_if_possible(glasses, ITEM_SLOT_EYES, bypass_equip_delay_self = TRUE))
		H.put_in_hands(glasses)

/datum/quirk/pushover
	name = "Pushover"
	desc = "Your first instinct is always to let people push you around. Resisting out of grabs will take conscious effort."
	value = 0
	mob_trait = TRAIT_GRABWEAKNESS
	gain_text = "<span class='danger'>You feel like a pushover.</span>"
	lose_text = "<span class='notice'>You feel like standing up for yourself.</span>"
	medical_record_text = "Patient presents a notably unassertive personality and is easy to manipulate."

/datum/quirk/empath
	name = "Empath"
	desc = "Whether it's a sixth sense or careful study of body language, it only takes you a quick glance at someone to understand how they feel."
	value = 0
	mob_trait = TRAIT_EMPATH
	gain_text = "<span class='notice'>You feel in tune with those around you.</span>"
	lose_text = "<span class='danger'>You feel isolated from others.</span>"
	medical_record_text = "Patient is highly perceptive of and sensitive to social cues, or may possibly have ESP. Further testing needed."

/datum/quirk/light_drinker
	name = "Light Drinker"
	desc = "You just can't handle your drinks and get drunk very quickly."
	value = 0
	mob_trait = TRAIT_LIGHT_DRINKER
	gain_text = "<span class='notice'>Just the thought of drinking alcohol makes your head spin.</span>"
	lose_text = "<span class='danger'>You're no longer severely affected by alcohol.</span>"
	medical_record_text = "Patient demonstrates a low tolerance for alcohol. (Wimp)"
	hardcore_value = 3

/datum/quirk/bad_touch
	name = "Bad Touch"
	desc = "You don't like hugs. You'd really prefer if people just left you alone."
	mob_trait = TRAIT_BADTOUCH
	value = 0
	gain_text = "<span class='danger'>You just want people to leave you alone.</span>"
	lose_text = "<span class='notice'>You could use a big hug.</span>"
	medical_record_text = "Patient has disdain for being touched. Potentially has undiagnosed haphephobia."

/datum/quirk/friendly
	name = "Friendly"
	desc = "You give the best hugs, even if they dont matter in this bloodshed enviroment."
	value = 0
	mob_trait = TRAIT_FRIENDLY
	gain_text = "<span class='notice'>You want to hug someone.</span>"
	lose_text = "<span class='danger'>You no longer feel compelled to hug others.</span>"
	medical_record_text = "Patient demonstrates low-inhibitions for physical contact and well-developed arms. Requesting another doctor take over this case."


/datum/quirk/extrovert
	name = "Extrovert"
	desc = "You are energized by talking to others, and enjoy spending your free time in the bar."
	value = 0
	mob_trait = TRAIT_EXTROVERT
	gain_text = "<span class='notice'>You feel like hanging out with other people.</span>"
	lose_text = "<span class='danger'>You feel like you're over the bar scene.</span>"
	medical_record_text = "Patient will not shut the hell up."

/datum/quirk/introvert
	name = "Introvert"
	desc = "You are energized by having time to yourself, and enjoy spending your free time in the library."
	value = 0
	mob_trait = TRAIT_INTROVERT
	gain_text = "<span class='notice'>You feel like reading a good book quietly.</span>"
	lose_text = "<span class='danger'>You feel like libraries are boring.</span>"
	medical_record_text = "Patient doesn't seem to say much."

/datum/quirk/no_taste
	name = "Ageusia"
	desc = "You can't taste anything! Toxic food will still poison you."
	value = 0
	mob_trait = TRAIT_AGEUSIA
	gain_text = "<span class='notice'>You can't taste anything!</span>"
	lose_text = "<span class='notice'>You can taste again!</span>"
	medical_record_text = "Patient suffers from ageusia and is incapable of tasting food or reagents."

/datum/quirk/foreigner
	name = "Foreigner"
	desc = "You're not from around here. You don't know Galactic Common!"
	value = 0
	gain_text = "<span class='notice'>The words being spoken around you don't make any sense."
	lose_text = "<span class='notice'>You've developed fluency in Galactic Common."
	medical_record_text = "Patient does not speak Galactic Common and may require an interpreter."

/datum/quirk/foreigner/add()
	var/mob/living/carbon/human/H = quirk_holder
	H.add_blocked_language(/datum/language/common)
	if(ishumanbasic(H))
		H.grant_language(/datum/language/uncommon)

/datum/quirk/foreigner/remove()
	var/mob/living/carbon/human/H = quirk_holder
	H.remove_blocked_language(/datum/language/common)
	if(ishumanbasic(H))
		H.remove_language(/datum/language/uncommon)

/datum/quirk/vegetarian
	name = "Vegetarian"
	desc = "You find the idea of eating meat morally and physically repulsive."
	value = 0
	gain_text = "<span class='notice'>You feel repulsion at the idea of eating meat.</span>"
	lose_text = "<span class='notice'>You feel like eating meat isn't that bad.</span>"
	medical_record_text = "Patient reports a vegetarian diet."

/datum/quirk/vegetarian/add()
	var/mob/living/carbon/human/H = quirk_holder
	var/datum/species/species = H.dna.species
	species.liked_food &= ~MEAT
	species.disliked_food |= MEAT

/datum/quirk/vegetarian/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		var/datum/species/species = H.dna.species
		if(initial(species.liked_food) & MEAT)
			species.liked_food |= MEAT
		if(!(initial(species.disliked_food) & MEAT))
			species.disliked_food &= ~MEAT

/datum/quirk/snob
	name = "Snob"
	desc = "You care about the finer things, if a room doesn't look nice its just not really worth it, is it?"
	value = 0
	gain_text = "<span class='notice'>You feel like you understand what things should look like.</span>"
	lose_text = "<span class='notice'>Well who cares about deco anyways?</span>"
	medical_record_text = "Patient seems to be rather stuck up."
	mob_trait = TRAIT_SNOB

/datum/quirk/pineapple_liker
	name = "Ananas Affinity"
	desc = "You find yourself greatly enjoying fruits of the ananas genus. You can't seem to ever get enough of their sweet goodness!"
	value = 0
	gain_text = "<span class='notice'>You feel an intense craving for pineapple.</span>"
	lose_text = "<span class='notice'>Your feelings towards pineapples seem to return to a lukewarm state.</span>"
	medical_record_text = "Patient demonstrates a pathological love of pineapple."

/datum/quirk/pineapple_liker/add()
	var/mob/living/carbon/human/H = quirk_holder
	var/datum/species/species = H.dna.species
	species.liked_food |= PINEAPPLE

/datum/quirk/pineapple_liker/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		var/datum/species/species = H.dna.species
		species.liked_food &= ~PINEAPPLE

/datum/quirk/pineapple_hater
	name = "Ananas Aversion"
	desc = "You find yourself greatly detesting fruits of the ananas genus. Serious, how the hell can anyone say these things are good? And what kind of madman would even dare putting it on a pizza!?"
	value = 0
	gain_text = "<span class='notice'>You find yourself pondering what kind of idiot actually enjoys pineapples...</span>"
	lose_text = "<span class='notice'>Your feelings towards pineapples seem to return to a lukewarm state.</span>"
	medical_record_text = "Patient is correct to think that pineapple is disgusting."

/datum/quirk/pineapple_hater/add()
	var/mob/living/carbon/human/H = quirk_holder
	var/datum/species/species = H.dna.species
	species.disliked_food |= PINEAPPLE

/datum/quirk/pineapple_hater/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		var/datum/species/species = H.dna.species
		species.disliked_food &= ~PINEAPPLE

/datum/quirk/deviant_tastes
	name = "Deviant Tastes"
	desc = "You dislike food that most people enjoy, and find delicious what they don't."
	value = 0
	gain_text = "<span class='notice'>You start craving something that tastes strange.</span>"
	lose_text = "<span class='notice'>You feel like eating normal food again.</span>"
	medical_record_text = "Patient demonstrates irregular nutrition preferences."

/datum/quirk/deviant_tastes/add()
	var/mob/living/carbon/human/H = quirk_holder
	var/datum/species/species = H.dna.species
	var/liked = species.liked_food
	species.liked_food = species.disliked_food
	species.disliked_food = liked

/datum/quirk/deviant_tastes/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		var/datum/species/species = H.dna.species
		species.liked_food = initial(species.liked_food)
		species.disliked_food = initial(species.disliked_food)

/datum/quirk/monochromatic
	name = "Monochromacy"
	desc = "You suffer from full colorblindness, and perceive nearly the entire world in blacks and whites."
	value = 0
	medical_record_text = "Patient is afflicted with almost complete color blindness."

/datum/quirk/monochromatic/add()
	quirk_holder.add_client_colour(/datum/client_colour/monochrome)

/datum/quirk/monochromatic/post_add()
	if(quirk_holder.mind.assigned_role == "Detective")
		to_chat(quirk_holder, "<span class='boldannounce'>Mmm. Nothing's ever clear on this station. It's all shades of gray...</span>")
		quirk_holder.playsound_local(quirk_holder, 'sound/ambience/ambidet1.ogg', 50, FALSE)

/datum/quirk/monochromatic/remove()
	if(quirk_holder)
		quirk_holder.remove_client_colour(/datum/client_colour/monochrome)

/datum/quirk/phobia
	name = "Phobia"
	desc = "You are irrationally afraid of something."
	value = 0
	medical_record_text = "Patient has an irrational fear of something."

/datum/quirk/phobia/post_add()
	var/mob/living/carbon/human/H = quirk_holder
	H.gain_trauma(new /datum/brain_trauma/mild/phobia(H.client?.prefs.phobia), TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/phobia/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		H.cure_trauma_type(/datum/brain_trauma/mild/phobia, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/needswayfinder
	name = "Navigationally Challenged"
	desc = "Lacking familiarity with certain stations, you start with a wayfinding pinpointer where available."
	value = 0
	medical_record_text = "Patient demonstrates a keen ability to get lost."

	var/obj/item/pinpointer/wayfinding/wayfinder
	var/where

/datum/quirk/needswayfinder/on_spawn()
	if(!GLOB.wayfindingbeacons.len)
		return
	var/mob/living/carbon/human/H = quirk_holder

	wayfinder = new /obj/item/pinpointer/wayfinding
	wayfinder.owner = H.real_name
	wayfinder.roundstart = TRUE

	var/list/slots = list(
		"in your left pocket" = ITEM_SLOT_LPOCKET,
		"in your right pocket" = ITEM_SLOT_RPOCKET,
		"in your backpack" = ITEM_SLOT_BACKPACK
	)
	where = H.equip_in_one_of_slots(wayfinder, slots, FALSE) || "at your feet"

/datum/quirk/needswayfinder/post_add()
	if(!GLOB.wayfindingbeacons.len)
		return
	if(where == "in your backpack")
		var/mob/living/carbon/human/H = quirk_holder
		SEND_SIGNAL(H.back, COMSIG_TRY_STORAGE_SHOW, H)

	to_chat(quirk_holder, "<span class='notice'>There is a pinpointer [where], which can help you find your way around. Click in-hand to activate.</span>")

/datum/quirk/bald
	name = "Smooth-Headed"
	desc = "You have no hair and are quite insecure about it! Keep your wig on, or at least your head covered up."
	value = 0
	mob_trait = TRAIT_BALD
	gain_text = "<span class='notice'>Your head is as smooth as can be, it's terrible.</span>"
	lose_text = "<span class='notice'>Your head itches, could it be... growing hair?!</span>"
	medical_record_text = "Patient starkly refused to take off headwear during examination."
	///The user's starting hairstyle
	var/old_hair

/datum/quirk/bald/add()
	var/mob/living/carbon/human/H = quirk_holder
	old_hair = H.hairstyle
	H.hairstyle = "Bald"
	H.update_hair()

/datum/quirk/bald/remove()
	var/mob/living/carbon/human/H = quirk_holder
	H.hairstyle = old_hair
	H.update_hair()

/datum/quirk/bald/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/clothing/head/wig/natural/W = new(get_turf(H))
	if (old_hair == "Bald")
		W.hairstyle = pick(GLOB.hairstyles_list - "Bald")
	else
		W.hairstyle = old_hair
	W.update_icon()
	var/list/slots = list (
		"head" = ITEM_SLOT_HEAD,
		"backpack" = ITEM_SLOT_BACKPACK,
		"hands" = ITEM_SLOT_HANDS,
	)
	H.equip_in_one_of_slots(W, slots , qdel_on_fail = TRUE)


/datum/quirk/tongue_tied
	name = "Tongue Tied"
	desc = "Due to a past incident, your ability to communicate has been relegated to your hands."
	value = 0
	medical_record_text = "During physical examination, patient's tongue was found to be uniquely damaged."

//Adds tongue & gloves
/datum/quirk/tongue_tied/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/organ/tongue/old_tongue = locate() in H.internal_organs
	var/obj/item/organ/tongue/tied/new_tongue = new(get_turf(H))
	var/obj/item/clothing/gloves/radio/gloves = new(get_turf(H))
	old_tongue.Remove(H)
	new_tongue.Insert(H)
	qdel(old_tongue)
	if(!H.equip_to_slot_if_possible(gloves, ITEM_SLOT_GLOVES, bypass_equip_delay_self = TRUE))
		H.put_in_hands(gloves)

/datum/quirk/tongue_tied/post_add()
	to_chat(quirk_holder, "<span class='boldannounce'>Because you speak with your hands, having them full hinders your ability to communicate!</span>")

/datum/quirk/photographer
	name = "Photographer"
	desc = "You carry your camera and personal photo album everywhere you go, and your scrapbooks are legendary among your coworkers."
	value = 0
	mob_trait = TRAIT_PHOTOGRAPHER
	gain_text = "<span class='notice'>You know everything about photography.</span>"
	lose_text = "<span class='danger'>You forget how photo cameras work.</span>"
	medical_record_text = "Patient mentions photography as a stress-relieving hobby."

/datum/quirk/photographer/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/storage/photo_album/personal/photo_album = new(get_turf(H))
	var/list/album_slots = list (
		"backpack" = ITEM_SLOT_BACKPACK,
		"hands" = ITEM_SLOT_HANDS
	)
	H.equip_in_one_of_slots(photo_album, album_slots , qdel_on_fail = TRUE)
	photo_album.persistence_id = "personal_[H.mind.key]" // this is a persistent album, the ID is tied to the account's key to avoid tampering
	photo_album.persistence_load()
	photo_album.name = "[H.real_name]'s photo album"
	var/obj/item/camera/camera = new(get_turf(H))
	var/list/camera_slots = list (
		"neck" = ITEM_SLOT_NECK,
		"left pocket" = ITEM_SLOT_LPOCKET,
		"right pocket" = ITEM_SLOT_RPOCKET,
		"backpack" = ITEM_SLOT_BACKPACK,
		"hands" = ITEM_SLOT_HANDS
	)
	H.equip_in_one_of_slots(camera, camera_slots , qdel_on_fail = TRUE)
	H.regenerate_icons()

/datum/quirk/colorist
	name = "Colorist"
	desc = "You like carrying around a hair dye spray to quickly apply color patterns to your hair."
	value = 0
	medical_record_text = "Patient enjoys dyeing their hair with pretty colors."

/datum/quirk/colorist/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/dyespray/spraycan = new(get_turf(H))
	H.put_in_hands(spraycan)
	H.equip_to_slot(spraycan, ITEM_SLOT_BACKPACK)
	H.regenerate_icons()

/datum/quirk/bongin
	name = "Bong Bong"
	desc = "Bong Bong, Bong, Bongbong."
	value = 0
	gain_text = "<span class='notice'>Bong, Bong Bong.</span>"
	lose_text = "<span class='danger'>Bong.</span>"
	///The user's starting stuffs, for smiting purpose, obviously
	var/old_hair
	var/old_facial
	var/old_skin_tone
	var/old_eyes
	var/old_name

/datum/quirk/bongin/add()
	if(isnull(quirk_holder))
		return
	var/mob/living/carbon/human/H = quirk_holder
	H.grant_language(/datum/language/bong, TRUE, TRUE, LANGUAGE_MIND)

/datum/quirk/bongin/remove()
	if(isnull(quirk_holder))
		return
	var/mob/living/carbon/human/H = quirk_holder
	H.remove_language(/datum/language/bong, TRUE, TRUE, LANGUAGE_MIND)
