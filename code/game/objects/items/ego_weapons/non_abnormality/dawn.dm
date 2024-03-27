//Dawn Office uses an AOE flame after hitting two different things. Grade 5
/obj/item/ego_weapon/city/dawn
	name = "dawn office template"
	desc = "A template for dawn office weapons."
	special = "Hit one enemy, then the other to unleash a weak aoe attack."
	icon_state = "philip"
	inhand_icon_state = "philip"
	damtype = RED_DAMAGE

	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")
	var/aoe_range
	var/aoe_target
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 80,
	)

/obj/item/ego_weapon/city/dawn/attack(mob/living/target, mob/living/user)
	..()
	//not if they're dead
	if(target.stat == DEAD)
		return
	if(aoe_target && (target != aoe_target))
		playsound(src, 'sound/weapons/ego/cannon.ogg', 50, TRUE)
		for(var/turf/T in view(aoe_range, target))
			if(prob(30))
				new /obj/effect/temp_visual/fire/fast(T)
			user.HurtInTurf(T, list(), force*0.2, damtype, hurt_mechs = TRUE)
	aoe_target = target

//Philip's Sword
/obj/item/ego_weapon/city/dawn/sword
	name = "dawn office sword"
	desc = "A plain sword. Oddly enough, there's a broken heating mechanism in the hilt."
	icon_state = "philip"
	inhand_icon_state = "philip"
	force = 35
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
	aoe_range = 2

//Yuna's Cello Case
/obj/item/ego_weapon/city/dawn/cello
	name = "dawn office cello case"
	desc = "A cello case custom-made for a fixer of the Dawn Office. The inside is filled with extendable blades..."
	icon_state = "yuna"
	inhand_icon_state = "yuna"
	force = 40		//Bigger range, less force
	attack_speed = 1.5
	aoe_range = 5

//Salvador's Zweihander
/obj/item/ego_weapon/city/dawn/zwei
	name = "dawn office zweihander"
	desc = "A zweihander fitted with a heating mechanism. The blade burns your enemy."
	icon_state = "salvador"
	inhand_icon_state = "salvador"
	force = 50		//Bigger range, less force
	attack_speed = 2
	aoe_range = 7
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")
