/obj/item/ego_weapon/template/spear
	name = "spear template"
	desc = "A blank spear workshop template."
	icon_state = "speartemplate"
	force = 20
	reach = 2		//Has 2 Square Reach.
	attack_speed = 1.4
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'

	finishedicon = list("finishedspear", "finishedheavyspear", "finishedglaive")
	finishedname = list("spear", "glaive", "partizan")
	finisheddesc = "A finished spear, ready for use."


/obj/item/ego_weapon/template/sword
	name = "sword template"
	desc = "A blank sword workshop template."
	icon_state = "swordtemplate"
	force = 22
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "slashes", "stabs", "slices", "tears", "lacerates", "rips", "dices", "cuts")
	attack_verb_simple = list("attack", "slash", "stab", "slice", "tear", "lacerate", "rip", "dice", "cut")

	finishedicon = list("finishedrapier","finishedsword", "finishededge")
	finishedname = list("sword", "blade", "edge")
	finisheddesc = "A finished sword, ready for use."


/obj/item/ego_weapon/template/hammer
	name = "hammer template"
	desc = "A blank hammer workshop template."
	icon_state = "hammertemplate"
	force = 26
	attack_speed = 1.8
	aoe_range = 1
	hitsound = 'sound/abnormalities/woodsman/woodsman_attack.ogg'
	attack_verb_continuous = list("bashes", "beats")
	attack_verb_simple = list("bash", "beat")

	finishedicon = list("finishedhammer")
	finishedname = list("hammer")
	finisheddesc = "A finished hammer, ready for use."


/obj/item/ego_weapon/template/javelin
	name = "javelin template"
	desc = "A blank javelin workshop template."
	icon_state = "javelintemplate"
	force = 22
	reach = 2		//Has 2 Square Reach.
	attack_speed = 1.7	//not really for melee and is therefore really slow.
	throwforce = 50
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'

	finishedicon = list("finishedjavelin")
	finishedname = list("javelin", "throwing spear")
	finisheddesc = "A finished javelin, ready for use."


/obj/item/ego_weapon/template/boomerang
	name = "boomerang template"
	desc = "A blank boomerang workshop template."
	icon_state = "boomerangtemplate"
	force = 16
	attack_speed = 0.8	//melee is shit lol
	throwforce = 14	//hits twice for some reason!?
	attack_verb_continuous = list("bonks", "bashes")
	attack_verb_simple = list("bonk", "bash")

	finishedicon = list("finishedboomerang")
	finishedname = list("boomerang")
	finisheddesc = "A finished boomerang, ready for use."

/obj/item/ego_weapon/template/boomerang/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/caught = hit_atom.hitby(src, FALSE, FALSE, throwingdatum=throwingdatum)
	if(thrownby && !caught)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, throw_at), thrownby, throw_range+2, throw_speed, null, TRUE), 1)
	if(caught)
		return
	else
		return ..()

/obj/item/ego_weapon/template/greatsword
	name = "greatsword template"
	desc = "A blank greatsword workshop template."
	icon_state = "greatswordtemplate"
	force = 38
	attack_speed =  2
	hitsound = 'sound/abnormalities/woodsman/woodsman_attack.ogg'
	attack_verb_continuous = list("attacks", "slashes", "cleaves", "slices", "cuts")
	attack_verb_simple = list("attack", "slash", "cleave", "slice", "cut")

	finishedicon = list("finishedgreatsword", "finishedbuster", "finishedzwei", "finishedgreatcleaver")
	finishedname = list("greatsword", "buster")
	finisheddesc = "A finished greatsword, ready for use."

/obj/item/ego_weapon/template/claw
	name = "claw template"
	desc = "A blank claw workshop template."
	icon_state = "clawtemplate"
	force = 20
	attack_speed = 0.7
	attack_verb_continuous = list("rends", "tears", "lacerates", "rips", "cuts")
	attack_verb_simple = list("rend", "tear", "lacerate", "rip", "cut")

	finishedicon = list("finishedclaw")
	finishedname = list("claw")
	finisheddesc = "A finished claw, ready for use."

/obj/item/ego_weapon/template/club
	name = "club template"
	desc = "A blank club workshop template."
	special = "This weapon has knockback."
	icon_state = "clubtemplate"
	force = 26
	attack_speed =  1.6
	attack_verb_continuous = list("pounds", "crushes", "smashes", "whacks", "smacks")
	attack_verb_simple = list("pound", "crush", "smash", "whack", "smack")

	finishedicon = list("finishedclub")
	finishedname = list("club")
	finisheddesc = "A finished club, ready for use."

/obj/item/ego_weapon/template/club/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	. = ..()
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(target && !target?.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user)

