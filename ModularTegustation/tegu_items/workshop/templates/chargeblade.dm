//Copypasta of the Wcorp batong
/obj/item/ego_weapon/template/chargeblade
	name = "chargeblade template"
	desc = "A glowing weapon made using Wcorp charge technology."
	icon_state = "chargetemplate"
	force = 18
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")

	finishedicon = list("finishedcharge")
	finishedname = list("sword", "blade", "edge")
	finisheddesc = "A finished chargeblade, ready for use."

	charge = TRUE
	charge_cost = 4
	successfull_activation = "You release your charge, damaging your opponent!"
	charge_effect = "deal an extra attack in damage."

/obj/item/ego_weapon/template/chargeblade/ChargeAttack(mob/living/target, mob/living/user)
	. = ..()
	target.apply_damage(force, damtype, null, target.run_armor_check(null, damtype), spread_damage = TRUE)
