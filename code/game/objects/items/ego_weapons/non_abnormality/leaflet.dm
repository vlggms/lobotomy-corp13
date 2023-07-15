//Leaflet
/obj/item/ego_weapon/city/leaflet
	name = "leaflet base"
	desc = "The Leaflet template."
	icon_state = "leaflet"
	force = 20
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 40,
							TEMPERANCE_ATTRIBUTE = 40,
							JUSTICE_ATTRIBUTE = 40
							)
	var/durability = 25
	var/max_durability = 25
	var/broken = FALSE

/obj/item/ego_weapon/city/leaflet/examine(mob/user)
	. = ..()
	. +="When durability runs out, deal significantly less damage. Use in hand to increase durability."
	. += "Durability: [durability]/[initial(durability)]."

/obj/item/ego_weapon/city/leaflet/attack_self(mob/living/carbon/human/user)
	..()
	if(!CanUseEgo(user))
		return
	if(broken)
		to_chat(user, "<span class='notice'>You start reparing your weapon...</span>")
		if(!do_after(user, 12 SECONDS, src))
			return
		to_chat(user, "<span class='notice'>You finish repairing your weapon</span>")
		durability = max_durability
		force = initial(force)

/obj/item/ego_weapon/city/leaflet/attack(mob/living/target, mob/living/carbon/human/user)
	..()
	if(durability > 0)
		durability -= 1
	else if(durability == 0 && !broken)
		broken = TRUE
		to_chat(user, "<span class='userdanger'>Your weapon has broken!</span>")
		force = force*0.5
		playsound(src, 'sound/weapons/ego/shield1.ogg', 100, FALSE, 4)

//Grade 6 with grade 5 damage This shit breaks
/obj/item/ego_weapon/city/leaflet/round
	name = "leaflet round hammer"
	desc = "A round hammer used by leaflet."
	icon_state = "leaflet_round"
	force = 44

//The Knockback version
/obj/item/ego_weapon/city/leaflet/wide
	name = "leaflet wide hammer"
	desc = "A wide hammer used by leaflet."
	special = "This weapon knocks the enemy back on hit."
	icon_state = "leaflet_wide"
	force = 44
	attack_speed = 1.2

/obj/item/ego_weapon/city/leaflet/wide/attack(mob/living/target, mob/living/carbon/human/user)
	. = ..()
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user)

//Grade 5 with grade 4 damage
/obj/item/ego_weapon/city/leaflet/square
	name = "leaflet square hammer"
	desc = "A square hammer used by leaflet."
	icon_state = "leaflet_hammer"
	force = 55
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

