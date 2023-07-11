//Copypasta of the Wcorp batong
/obj/item/ego_weapon/template/chargeblade
	name = "chargeblade template"
	desc = "A glowing weapon made using Wcorp charge technology."
	icon_state = "chargetemplate"
	force = 18
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")

	finishedicon = list("finishedcharge")
	finishedname = list("sword", "blade", "edge")
	finisheddesc = "A finished chargeblade, ready for use."
	var/release_message = "You release your charge, damaging your opponent!"
	var/charge_effect = "deal an extra attack in damage."
	var/charge_cost = 4
	var/charge
	var/activated

/obj/item/ego_weapon/template/chargeblade/attack_self(mob/user)
	..()
	if(charge>=charge_cost)
		to_chat(user, "<span class='notice'>You prepare to release your charge.</span>")
		activated = TRUE
	else
		to_chat(user, "<span class='notice'>You don't have enough charge.</span>")

/obj/item/ego_weapon/template/chargeblade/examine(mob/user)
	. = ..()
	. += "Spend [charge]/[charge_cost] charge to [charge_effect]"

/obj/item/ego_weapon/template/chargeblade/attack(mob/living/target, mob/living/user)
	..()
	if(charge<20 && target.stat != DEAD)
		charge+=1
	if(activated)
		charge -= charge_cost
		release_charge(target, user)
		activated = FALSE

/obj/item/ego_weapon/template/chargeblade/proc/release_charge(mob/living/target, mob/living/user)
	to_chat(user, "<span class='notice'>[release_message].</span>")
	sleep(2)
	target.apply_damage(force, damtype, null, target.run_armor_check(null, damtype), spread_damage = TRUE)
	playsound(src, 'sound/abnormalities/thunderbird/tbird_bolt.ogg', 50, TRUE)
	var/turf/T = get_turf(target)
	new /obj/effect/temp_visual/justitia_effect(T)
