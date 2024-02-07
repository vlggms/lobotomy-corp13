// Threats appropriate for a single grade 5-3 fixer, or multiple weaker fixers.
// Around this point in time you can start awarding WAW equipment as a standard

//Coded by Coxswain, sprited by stcopycat "Roman"
/mob/living/simple_animal/hostile/distortion/bunnyman
	name = "The Bunnyman"
	desc = "Looks like a carnival mascot."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "bunnyman"
	maxHealth = 2000 //low health, high damage
	health = 2000
	pixel_x = -16
	base_pixel_x = -16
	fear_level = WAW_LEVEL
	move_to_delay = 3
	damage_coeff = list(RED_DAMAGE = 0.2, WHITE_DAMAGE = 1, BLACK_DAMAGE = 1, PALE_DAMAGE = 1.5)
	melee_damage_lower = 25
	melee_damage_upper = 30
	melee_damage_type = RED_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = 'sound/weapons/ego/axe2.ogg'
	attack_verb_continuous = "chops"
	attack_verb_simple = "chop"

//Variables important for distortions
	//The EGO worn by the egoist
	ego_list = list(
		/obj/item/ego_weapon/animalism,
		/obj/item/clothing/suit/armor/ego_gear/waw/totalitarianism
		)
	//The egoist's name, if specified. Otherwise picks a random name.
	egoist_names = list("Douglas Grifon")
	//The mob's gender, which will be inherited by the egoist. Can be left unspecified for a random pick.
	gender = MALE
	//The Egoist's outfit, which should usually be civilian unless you want them to be a fixer or something.
	egoist_outfit = /datum/outfit/job/butcher
	//The Egoist's starting stats, all across the board. MUST BE AT LEAST THE MINIMUM TO EQUIP THE EGO_GEAR IF ANY
	egoist_attributes = 80
	//Loot on death; distortions should be valuable targets in general.
	loot = list(/obj/item/documents/ncorporation, /obj/item/documents/ncorporation) //Placeholder, we need more loot items
	//Custon unmanifest effect
	unmanifest_effect = /obj/effect/gibspawner/human

	var/can_act = TRUE
	var/transformed = FALSE

//Proc that can be used for additional effects on unmanifest
/mob/living/simple_animal/hostile/distortion/bunnyman/PostUnmanifest(mob/living/carbon/human/egoist)
	playsound(src, 'sound/effects/blobattack.ogg', 150, FALSE, 4)
	for(var/turf/TF in orange(2, get_turf(src))) //spawns blood effects
		if(TF.density)
			continue
		var/obj/effect/decal/cleanable/blood/B  = new(TF)
		B.bloodiness = 100
	return

//Unmanifesting is not linked to any proc by default, if you want it to happen during gameplay, it must be called manually.
/mob/living/simple_animal/hostile/distortion/bunnyman/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/food/grown/carrot))
		qdel(I)
		say("That's all I ever wanted!")
		can_act = FALSE
		addtimer(CALLBACK(src, PROC_REF(Unmanifest)),3 SECONDS)


/mob/living/simple_animal/hostile/distortion/bunnyman/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/waddling)


/mob/living/simple_animal/hostile/distortion/bunnyman/Move()
	if(!can_act)
		return FALSE
	..()

/mob/living/simple_animal/hostile/distortion/bunnyman/AttackingTarget()
	if(!can_act)
		return FALSE
	..()

/mob/living/simple_animal/hostile/distortion/bunnyman/Life()
	. = ..()
	if(transformed)
		return
	if(health <= maxHealth * 0.7)
		Transform()

/mob/living/simple_animal/hostile/distortion/bunnyman/proc/Transform() //BERSERKER!
	if(transformed)
		return
	transformed = TRUE
	SLEEP_CHECK_DEATH(5)
	playsound(src, 'sound/effects/blobattack.ogg', 150, FALSE, 4)
	playsound(src, 'sound/weapons/chainsawhit.ogg', 250, FALSE, 4)
	attack_sound = 'sound/abnormalities/helper/attack.ogg'
	ChangeResistances(list(RED_DAMAGE = 0.7, WHITE_DAMAGE = 1.5, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2))
	melee_damage_lower = 30
	melee_damage_upper = 45
	rapid_melee = 3
	move_to_delay = 2
	icon_state = "bunnyman_enraged"
