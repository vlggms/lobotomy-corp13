//Coded by Kirie!
//Loosely based off LOR13's Lantern Office, and sprited by the same.
/mob/living/simple_animal/hostile/distortion/lantern
	name = "Misguiding Light"
	desc = "A figure holding a lantern, his light is blinding."
	icon = 'ModularTegustation/Teguicons/32x32.dmi'
	icon_state = "lantern"
	maxHealth = 2000 //low health, has AOE blindness
	health = 2000
	fear_level = ALEPH_LEVEL
	move_to_delay = 3
	damage_coeff = list(RED_DAMAGE = 1, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 0.5, PALE_DAMAGE = 0.5)
	melee_damage_lower = 25
	melee_damage_upper = 30
	melee_damage_type = BLACK_DAMAGE
	stat_attack = HARD_CRIT
	attack_sound = 'sound/weapons/ego/axe2.ogg'
	attack_verb_continuous = "bashes"
	attack_verb_simple = "bash"

//Variables important for distortions
	//The EGO worn by the egoist
	ego_list = list(
		/obj/item/ego_weapon/lamp,
		/obj/item/clothing/suit/armor/ego_gear/waw/lamp
		)
	egoist_outfit = /datum/outfit/job/civilian
	egoist_attributes = 80
	loot = list(/obj/item/documents/ncorporation, /obj/item/documents/ncorporation) //Placeholder, we need more loot items
	unmanifest_effect = /obj/effect/gibspawner/human
	light_color = COLOR_YELLOW
	light_range = 5
	light_power = 7


//Proc that can be used for additional effects on unmanifest
/mob/living/simple_animal/hostile/distortion/lantern/PostUnmanifest(mob/living/carbon/human/egoist)
	playsound(src, 'sound/effects/blobattack.ogg', 150, FALSE, 4)
	for(var/turf/TF in orange(2, get_turf(src))) //spawns blood effects
		if(TF.density)
			continue
		var/obj/effect/decal/cleanable/blood/B  = new(TF)
		B.bloodiness = 100
	return

//Unmanifesting is not linked to any proc by default, if you want it to happen during gameplay, it must be called manually.
/mob/living/simple_animal/hostile/distortion/lantern/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/food/grown/carrot))
		qdel(I)
		say("That's all I ever wanted!")
		can_act = FALSE
		addtimer(CALLBACK(src,.proc/Unmanifest),3 SECONDS)


/mob/living/simple_animal/hostile/distortion/lantern/AttackingTarget()
	..()
	if(prob(70))
		return
	for(var/mob/living/carbon/C in view(8, src))
		if(faction_check_mob(C, FALSE))
			continue
		if(!CanAttack(C))
			continue
		C.blur_eyes(5)
		addtimer(CALLBACK (C, .mob/proc/blind_eyes, 2), 2 SECONDS)
		var/new_overlay = mutable_appearance('ModularTegustation/Teguicons/tegu_effects.dmi', "enchanted", -HALO_LAYER)
		C.add_overlay(new_overlay)
		addtimer(CALLBACK (C, .atom/proc/cut_overlay, new_overlay), 4 SECONDS)



