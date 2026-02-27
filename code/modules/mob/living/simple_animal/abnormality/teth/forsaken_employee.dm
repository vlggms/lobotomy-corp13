/mob/living/simple_animal/hostile/abnormality/forsaken_employee
	name = "Forsaken Employee"
	desc = "A person who seems to be wearing an L Corp Uniform covered in chains. A box resembling Enkephalin is stuck on their head."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "forsaken_employee"
	portrait = "forsaken_employee"

	maxHealth = 250
	health = 250
	move_to_delay = 3

	can_breach = TRUE
	threat_level = TETH_LEVEL
	start_qliphoth = 1
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(30, 20, 0, -80, -80),
		ABNORMALITY_WORK_INSIGHT = list(50, 50, 40, 40, 40),
		ABNORMALITY_WORK_ATTACHMENT = list(40, 40, 30, 30, 30),
		ABNORMALITY_WORK_REPRESSION = list(60, 60, 50, 50, 50),
	)
	work_damage_lower = 3
	work_damage_type = BLACK_DAMAGE

	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 1.3, WHITE_DAMAGE = 1.2, BLACK_DAMAGE = 1, PALE_DAMAGE = 2)
	melee_damage_lower = 1
	melee_damage_upper = 3
	melee_damage_type = BLACK_DAMAGE
	attack_sound = 'sound/abnormalities/ichthys/slap.ogg'

	ego_list = list(
		/datum/ego_datum/weapon/denial,
		/datum/ego_datum/armor/denial,
	)
	gift_type =  /datum/ego_gifts/denial
	abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS
	chem_type = /datum/reagent/abnormality/sin/gloom

	var/splash_cooldown
	var/splash_cooldown_time = 2 SECONDS

	//Observation is mostly mirror dungeon but with some changed phrasing
	observation_prompt = "The sound of plastic crashing is accompanied by the sloshing of a liquid. <br>\
		It looks like something that used to be a fellow employee. <br>\
		Its identity is evidenced by the now-worn formal outfit and the employee card. <br>\
		The card is almost too battered and contaminated to recognize. <br>\
		Wearing a box filled with Enkephalin on their head, the employee rams it into what looks like the door to a containment unit. <br>\
		A rubber O-ring is worn around their neck. Could it be there to prevent Enkephalin from spilling?"
	observation_choices = list(
		"Cut the ring" = list(TRUE, "The blade kept bouncing off the slippery O-ring... <br>\
			\"Brgrrgh...\ <br>\
			And the submerged thing pushed you away and ran off. Did it prefer to stay like that? <br>\
			All it left was a small employee card."),
		"Don't cut the ring" = list(FALSE, "Tang- Tang- Tang- The ramming at the door and the sloshing continue. <br>\
			I keep watching and listening. A more attentive hearing reveals that the sounds have a rhythm. Perhaps there is delight to be found in it."),
	)

/mob/living/simple_animal/hostile/abnormality/forsaken_employee/FailureEffect(mob/living/carbon/human/user, work_type, pe, work_time, canceled)
	. = ..()
	datum_reference.qliphoth_change(-1)
	return

/mob/living/simple_animal/hostile/abnormality/forsaken_employee/BreachEffect(mob/living/carbon/human/user, breach_type)
	..()
	AddElement(/datum/element/waddling)
	AddComponent(/datum/component/knockback, 1, FALSE, TRUE)

/mob/living/simple_animal/hostile/abnormality/forsaken_employee/AttackingTarget(atom/attacked_target)
	splash()
	..()

/mob/living/simple_animal/hostile/abnormality/forsaken_employee/Life()
	. = ..()
	if(status_flags & GODMODE)
		return
	if(splash_cooldown <= world.time)
		playsound(src, 'sound/abnormalities/ichthys/hardslap.ogg', 60, 1)
		splash()


/mob/living/simple_animal/hostile/abnormality/forsaken_employee/proc/splash()
	new /obj/effect/gibspawner/generic/silent/wrath_acid/enkephalin(loc)
	splash_cooldown = world.time + splash_cooldown_time

/obj/effect/gibspawner/generic/silent/wrath_acid/enkephalin
	gibtypes = list(/obj/effect/decal/cleanable/wrath_acid/enkephalin)
	gibamounts = list(5)

/obj/effect/decal/cleanable/wrath_acid/enkephalin
	name = "Enkephalin"
	desc = "There are some harsh fumes coming off of it."
	icon_state = "acid_greyscale"
	random_icon_states = list("acid_greyscale")
	color = "#20f8ac"
	duration = 30 SECONDS

/obj/effect/decal/cleanable/wrath_acid/enkephalin/Crossed(atom/movable/AM)
	if(!ishuman(AM))
		return FALSE
	var/mob/living/carbon/human/H = AM
	H.apply_damage(1, WHITE_DAMAGE, null, H.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
	. = ..()
