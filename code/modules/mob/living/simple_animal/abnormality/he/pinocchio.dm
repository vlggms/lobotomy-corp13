//Coded by Coxswain
/mob/living/simple_animal/hostile/abnormality/pinocchio
	name = "Pinocchio"
	desc = "A wooden humanoid puppet, it hums to itself with childlike delight."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "pinocchio"
	icon_living = "pinocchio"
	portrait = "pinocchio"
	maxHealth = 600
	health = 600
	threat_level = HE_LEVEL
	can_breach = TRUE
	start_qliphoth = 1
	speak_emote = list("creaks", "snaps")
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = 35,
		ABNORMALITY_WORK_INSIGHT = list(50, 55, 55, 50, 45),
		ABNORMALITY_WORK_ATTACHMENT = 45,
		ABNORMALITY_WORK_REPRESSION = list(40, 45, 45, 40, 40),
		"Lying is Bad!" = 0,
	)

	damage_coeff = list(RED_DAMAGE = 1.2, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.7, PALE_DAMAGE = 0.9)
	work_damage_amount = 8
	work_damage_type = WHITE_DAMAGE
	max_boxes = 16

	ego_list = list(
		/datum/ego_datum/weapon/marionette,
		/datum/ego_datum/armor/marionette,
	)
	gift_type = /datum/ego_gifts/marionette
	abnormality_origin = ABNORMALITY_ORIGIN_RUINA

	observation_prompt = "I've been watching people for as long as I've known them, it's not hard to imitate others. <br>\
		Can I be a human if I mimic humans?"
	observation_choices = list(
		"You will never be a human" = list(TRUE, "Can I... not become a human..? <br>You could've let me fool you, you're too cruel."),
		"You're human" = list(FALSE, "Did I look just like a human? <br>I hope I fooled you, it's other people's fault for falling for my lies."),
	)

	var/lying = FALSE
	var/caught_lie = FALSE
	var/mob/living/carbon/human/species/pinocchio/realboy = null
	var/list/modular_work_chance = list(
		"lie1" = list( //LIES!
			"Instingt" = 0,
			ABNORMALITY_WORK_INSIGHT = 0,
			ABNORMALITY_WORK_ATTACHMENT = 0,
			"Represion" = 0,
			"Lying is Bad!" = 100,
		),
		"lie2" = list(
			ABNORMALITY_WORK_INSTINCT = 0,
			ABNORMALITY_WORK_INSIGHT = 0,
			"Atachment" = 0,
			"Represion" = 0,
			"Lying is Bad!" = 100,
		),
		"lie3" = list(
			"Insignt" = 0,
			ABNORMALITY_WORK_INSIGHT = 0,
			"Attachnent" = 0,
			ABNORMALITY_WORK_REPRESSION = 0,
			"Lying is Bad!" = 100,
		),
		"normal" = list(
			ABNORMALITY_WORK_INSTINCT = 35,
			ABNORMALITY_WORK_INSIGHT = list(50, 55, 55, 50, 45),
			ABNORMALITY_WORK_ATTACHMENT = 45,
			ABNORMALITY_WORK_REPRESSION = list(40, 45, 45, 40, 40),
			"Lying is Bad!" = 0,
		),
	)

//Spawn
/mob/living/simple_animal/hostile/abnormality/pinocchio/PostSpawn()
	..()
	alpha = 0
	pixel_z = 16
	animate(src, alpha = 255,pixel_x = 0, pixel_z = -16, time = 4 SECONDS)
	pixel_z = 0
	if(!datum_reference?.console)
		return
	datum_reference.console.updateUsrDialog()

//Work/Misc
/mob/living/simple_animal/hostile/abnormality/pinocchio/AttemptWork(mob/living/carbon/human/user, work_type)
	if(realboy)
		to_chat(user, span_warning("The abnormality isn't in here!"))
		return FALSE
	if(work_type == "Lying is Bad!")
		if(lying)
			playsound(src, 'sound/abnormalities/pinocchio/success.ogg', 40, 0, 1)
			caught_lie = TRUE
			lying = FALSE
			datum_reference.qliphoth_change(1)
			PostWorkEffect()
			datum_reference.console.updateUsrDialog()
			return
		else
			datum_reference.qliphoth_change(-1)
		return
	return ..()

/mob/living/simple_animal/hostile/abnormality/pinocchio/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
	if(lying)
		playsound(src, 'sound/abnormalities/pinocchio/lie.ogg', 40, 0, 1)
		datum_reference.qliphoth_change(-1)
		new /obj/effect/temp_visual/pinocchio/lies(get_turf(src))
		return
	if(caught_lie)
		caught_lie = FALSE
		var/list/new_work_chances = modular_work_chance["normal"]
		work_chances = new_work_chances.Copy()
		datum_reference.available_work = work_chances
		new /obj/effect/temp_visual/pinocchio/caught(get_turf(src))
		return
	playsound(src, 'sound/abnormalities/pinocchio/activate.ogg', 40, 0, 1)
	new /obj/effect/temp_visual/pinocchio(get_turf(src))
	if(!lying && prob(30))
		var/lienumber = pick("lie1","lie2","lie3")
		var/list/new_work_chances = modular_work_chance[lienumber]
		lying = TRUE
		work_chances = new_work_chances.Copy()
		datum_reference.available_work = work_chances

//Breach
/mob/living/simple_animal/hostile/abnormality/pinocchio/BreachEffect(mob/living/carbon/human/user, breach_type)
	playsound(src, 'sound/abnormalities/pinocchio/activate.ogg', 40, 0, 1)
	density = FALSE
	animate(src, alpha = 0,pixel_x = 0, pixel_z = 16, time = 4 SECONDS)
	SLEEP_CHECK_DEATH(1 SECONDS)
	realboy = new (get_turf(src)) //Technically the breach version is a separate entity, requires a lot of tinkering but works.
	RegisterSignal(realboy, COMSIG_LIVING_DEATH, PROC_REF(PuppetDeath))
	realboy.name = "Pinocchio the Liar"
	realboy.real_name = "Pinocchio the Liar"
	realboy.adjust_all_attribute_levels(100)
	realboy.adjust_attribute_bonus(FORTITUDE_ATTRIBUTE, 400) // 600 health
	realboy.health = realboy.maxHealth
	realboy.alpha = 0
	realboy.pixel_z = 16
	animate(realboy, alpha = 255,pixel_x = 0, pixel_z = -16, time = 0.5 SECONDS)
	realboy.pixel_z = 0
	realboy.physiology.red_mod *= 1.2 //Matches wearing its own E.G.O.
	realboy.physiology.white_mod *= 0.5
	realboy.physiology.black_mod *= 0.7
	realboy.physiology.pale_mod *= 0.9
	realboy.put_in_l_hand(new /obj/item/ego_weapon/marionette/abnormality(realboy))
	ADD_TRAIT(realboy, TRAIT_COMBATFEAR_IMMUNE, "Abnormality")
	ADD_TRAIT(realboy, TRAIT_WORK_FORBIDDEN, "Abnormality")
	ADD_TRAIT(realboy, TRAIT_IGNOREDAMAGESLOWDOWN, "Abnormality")
	ADD_TRAIT(realboy, TRAIT_NODROP, "Abnormality")
	realboy.update_icon()

	//--Side Gamemodes stuff--
	//For playable abnormalities, directly lets the playing currently controlling pinocchio get control of the spawned mob
	if(client)
		mind.transfer_to(realboy)
	//Prevents pinocchio from going insane on Rcorp.
	if(!IsCombatMap())
		realboy.ai_controller = /datum/ai_controller/insane/murder/puppet
		realboy.InitializeAIController()
		realboy.apply_status_effect(/datum/status_effect/panicked_type/puppet)
	//Destroys the invisible pinocchio, as it is unecessary in Rcorp, also gives him NV goggles and shoes.
	else
		realboy.equip_to_slot(new /obj/item/clothing/glasses/night/rabbit, ITEM_SLOT_EYES)
		realboy.equip_to_slot(new /obj/item/clothing/shoes/combat, ITEM_SLOT_FEET)
		qdel(src)
	return TRUE

/mob/living/simple_animal/hostile/abnormality/pinocchio/proc/PuppetDeath(gibbed) //we die when the puppet mob dies
	UnregisterSignal(realboy, COMSIG_LIVING_DEATH)
	if(!QDELETED(realboy))
		realboy.dropItemToGround(realboy.get_inactive_held_item())
		realboy.dropItemToGround(realboy.get_active_held_item())
		QDEL_IN(realboy, 15) //In theory we could do an egg transformation at this point but I have no sprite.
	death()

/mob/living/simple_animal/hostile/abnormality/pinocchio/CreateAbnoCore()//The simple mob created will leave a core behind when regular conditions are fulfilled ie. when this proc is called
	realboy.core_enabled = TRUE
	return

//Special item
/obj/item/ego_weapon/marionette/abnormality
	name = "liar's lyre"
	desc = "A wooden axe, somehow wickedly sharp. Looks fragile."
	damtype = WHITE_DAMAGE

	item_flags = ABSTRACT
	var/delete_timer

/obj/item/ego_weapon/marionette/abnormality/attack(mob/living/M, mob/living/user)
	if(ishuman(M))
		var/mob/living/carbon/human/L = M
		if(L.sanity_lost)
			damtype = RED_DAMAGE
	..()
	damtype = WHITE_DAMAGE

/obj/item/ego_weapon/marionette/abnormality/dropped(mob/user)
	. = ..()
	if(!QDELING(src))
		delete_timer = addtimer(CALLBACK(src, PROC_REF(TryDelete), user), 3 SECONDS, TIMER_STOPPABLE)

/obj/item/ego_weapon/marionette/abnormality/proc/TryDelete(mob/user)
	if(!delete_timer)
		return
	deltimer(delete_timer)
	delete_timer = null
	qdel(src)

/obj/item/ego_weapon/marionette/abnormality/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(delete_timer)
		deltimer(delete_timer)
		delete_timer = null
	if(user.dna.species.id != "puppet")
		to_chat(user, span_warning("The [src] collapses into splinters in your hands!"))
		qdel(src)
		return


//Effects
/obj/effect/temp_visual/pinocchio
	icon = 'ModularTegustation/Teguicons/tegu_effects.dmi'
	icon_state = "curiosity"
	duration = 15

/obj/effect/temp_visual/pinocchio/Initialize()
	. = ..()
	animate(src, alpha = 255,pixel_x = 0, pixel_z = 24, time = 0 SECONDS)
	src.pixel_z = 24

/obj/effect/temp_visual/pinocchio/lies
	icon_state = "lies"

/obj/effect/temp_visual/pinocchio/caught
	icon_state = "long-nosed"

//Special panic type for carbon mob
/datum/ai_controller/insane/murder/puppet
	lines_type = /datum/ai_behavior/say_line/insanity_murder/puppet
	continue_processing_when_client = FALSE //Prevents playable pinocchio from going around murdering everyone.

/datum/ai_controller/insane/murder/puppet/CanTarget(atom/movable/thing)
	. = ..()
	var/mob/living/living_pawn = pawn
	if(. && isliving(thing) && living_pawn.faction_check_mob(thing))
		return FALSE

/datum/status_effect/panicked_type/puppet
	icon = null

/datum/ai_behavior/say_line/insanity_murder/puppet
	lines = list(
		"I'm keen to learn as usual. Would you like to see me learn?",
		"Lalala... I sing along to the song of lies all the people sing.",
		"Did I look just like a human? I hope I did...",
		"It's people's fault for falling for my lies.",
	)

//Carbon code
/mob/living/carbon/human/species/pinocchio //a real boy. Compatiable with being spawned by admins to boot! Can't panic outside of fear, though.
	race = /datum/species/puppet
	faction = list("hostile")
	var/core_enabled = FALSE

/mob/living/carbon/human/species/pinocchio/Initialize(mapload, cubespawned=FALSE, mob/spawner) //There is basically no documentation for bodyparts and hair, so this was the next best thing.
	. = ..()
	var/strings = icon('icons/mob/mutant_bodyparts.dmi', "strings_pinnochio_ADJ")
	src.add_overlay(strings)

/mob/living/carbon/human/species/pinocchio/adjustBlackLoss(amount, updating_health = TRUE, forced = FALSE, white_healable = FALSE)
	if(amount > 0 && !forced)
		new /obj/effect/temp_visual/damage_effect/black(get_turf(src))
	return adjustBruteLoss(amount, forced = forced) // Override, otherwise we'd end up taking damage twice.

/mob/living/carbon/human/species/pinocchio/adjustWhiteLoss(amount, updating_health = TRUE, forced = FALSE, white_healable = FALSE)
	if(amount > 0 && !forced)
		new /obj/effect/temp_visual/damage_effect/white(get_turf(src))
	return adjustBruteLoss(amount, forced = forced) // Override with the parent, sanity damage is now just brute damage

/mob/living/carbon/human/species/pinocchio/adjustPaleLoss(amount, updating_health = TRUE, forced = FALSE)
	if(amount > 0 && !forced)
		new /obj/effect/temp_visual/damage_effect/pale(get_turf(src))
	return adjustBruteLoss(amount, forced = forced) // No % pale damage

/mob/living/carbon/human/species/pinocchio/canBeHandcuffed()
	return FALSE

/mob/living/carbon/human/species/pinocchio/UnarmedAttack(atom/A, proximity)
	if((istype(A, /obj/structure/toolabnormality/touch)) || (istype(A, /obj/structure/bough)))
		to_chat(src, span_userdanger("YOUR FOOLISHNESS IS IMPRESSIVE."))
		return
	. = ..()

/mob/living/carbon/human/species/pinocchio/Destroy()
	if(core_enabled)
		CreateAbnoCore()
	..()

/mob/living/carbon/human/species/pinocchio/proc/CreateAbnoCore()//this is at the carbon level
	var/obj/structure/abno_core/C = new(get_turf(src))
	C.name = "Pinocchio Core"
	C.desc = "The core of Pinocchio"
	C.icon_state = ""//core icon goes here
	C.contained_abno = /mob/living/simple_animal/hostile/abnormality/pinocchio//release()ing or extract()ing this core will spawn the abnormality, making it a valid core.
	C.threat_level = 3
	C.icon = 'ModularTegustation/Teguicons/abno_cores/he.dmi'

/datum/species/puppet
	name = "Puppet"
	id = "puppet"
	sexes = FALSE
	hair_color = "352014"
	say_mod = "creaks, snaps"
	attack_verb = "slash"
	attack_sound = 'sound/abnormalities/pinocchio/attack.ogg'
	miss_sound = 'sound/abnormalities/pinocchio/attack.ogg'
	meat = /obj/item/stack/sheet/mineral/wood
	knife_butcher_results = list(/obj/item/stack/sheet/mineral/wood = 5)
	species_traits = list(NO_UNDERWEAR,NOBLOOD,NOEYESPRITES)
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER,TRAIT_NOMETABOLISM,TRAIT_TOXIMMUNE,TRAIT_NOBREATH,TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_RADIMMUNE,TRAIT_GENELESS,\
	TRAIT_NOHUNGER,TRAIT_XENO_IMMUNE,TRAIT_NOCLONELOSS)
	punchdamagelow = 10
	punchdamagehigh = 15
	bodypart_overides = list(
	BODY_ZONE_L_ARM = /obj/item/bodypart/l_arm/puppet,\
	BODY_ZONE_R_ARM = /obj/item/bodypart/r_arm/puppet,\
	BODY_ZONE_HEAD = /obj/item/bodypart/head/puppet,\
	BODY_ZONE_L_LEG = /obj/item/bodypart/l_leg/puppet,\
	BODY_ZONE_R_LEG = /obj/item/bodypart/r_leg/puppet,\
	BODY_ZONE_CHEST = /obj/item/bodypart/chest/puppet)
	speedmod = 1.3
	changesource_flags = MIRROR_BADMIN | WABBAJACK

/datum/species/puppet/check_roundstart_eligible()
	return FALSE //heck no

/obj/item/bodypart/head/puppet
	name = "puppet abnormality head"
	desc = "a head made of ...wood?"
	icon = 'icons/mob/human_parts.dmi'
	icon_state = "puppet_head"
	dismemberable = FALSE
	can_be_disabled = FALSE

/obj/item/bodypart/chest/puppet
	name = "puppet abnormality torso"
	desc = "a torso made of ...wood?"
	icon = 'icons/mob/human_parts.dmi'
	icon_state = "puppet_chest"

/obj/item/bodypart/l_arm/puppet
	name = "puppet abnormality left arm"
	desc = "a limb made of ...wood?"
	icon = 'icons/mob/human_parts.dmi'
	icon_state = "puppet_l_arm"
	dismemberable = FALSE
	can_be_disabled = FALSE

/obj/item/bodypart/r_arm/puppet
	name = "puppet abnormality right arm"
	desc = "a limb made of ...wood?"
	icon = 'icons/mob/human_parts.dmi'
	icon_state = "puppet_r_arm"
	dismemberable = FALSE
	can_be_disabled = FALSE

/obj/item/bodypart/l_leg/puppet
	name = "puppet abnormality left leg"
	desc = "a limb made of ...wood?"
	icon = 'icons/mob/human_parts.dmi'
	icon_state = "puppet_l_leg"
	dismemberable = FALSE
	can_be_disabled = FALSE

/obj/item/bodypart/r_leg/puppet
	name = "puppet abnormality right leg"
	desc = "a limb made of ...wood?"
	icon = 'icons/mob/human_parts.dmi'
	icon_state = "puppet_r_leg"
	dismemberable = FALSE
	can_be_disabled = FALSE
