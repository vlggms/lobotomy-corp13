//Sinner weapons - TETH
/obj/item/ego_weapon/mini/hayong
	name = "ha yong"
	desc = "Have you heard of the taxidermied genius?"
	special = "This weapon attacks very fast. Use this weapon in hand to dodgeroll."
	icon_state = "hayong"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	force = 7
	attack_speed = 0.3
	damtype = WHITE_DAMAGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	var/dodgelanding

/obj/item/ego_weapon/mini/hayong/attack_self(mob/living/carbon/user)
	if(user.dir == 1)
		dodgelanding = locate(user.x, user.y + 5, user.z)
	if(user.dir == 2)
		dodgelanding = locate(user.x, user.y - 5, user.z)
	if(user.dir == 4)
		dodgelanding = locate(user.x + 5, user.y, user.z)
	if(user.dir == 8)
		dodgelanding = locate(user.x - 5, user.y, user.z)
	user.adjustStaminaLoss(20, TRUE, TRUE)
	user.throw_at(dodgelanding, 3, 2, spin = TRUE)

/obj/item/ego_weapon/shield/walpurgisnacht
	name = "walpurgisnacht"
	desc = "Man errs so long as he strives."
	icon_state = "walpurgisnacht"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	force = 35
	attack_speed = 1.6
	damtype = WHITE_DAMAGE

	attack_verb_continuous = list("cuts", "smacks", "bashes")
	attack_verb_simple = list("cuts", "smacks", "bashes")
	hitsound = 'sound/weapons/bladeslice.ogg'
	reductions = list(20, 30, 10, 0) // 60
	projectile_block_duration = 1 SECONDS
	block_duration = 1 SECONDS
	block_cooldown = 3 SECONDS
	block_sound = 'sound/weapons/ego/clash1.ogg'
	projectile_block_message = "You swat the projectile out of the air!"
	block_message = "You attempt to parry the attack!"
	hit_message = "parries the attack!"
	block_cooldown_message = "You rearm your blade."

/obj/item/ego_weapon/lance/suenoimpossible
	name = "sueno impossible"
	desc = "To reach the unreachable star!"
	icon_state = "sueno_impossible"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/96x96_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/96x96_righthand.dmi'
	inhand_x_dimension = 96
	inhand_y_dimension = 96
	force = 22
	reach = 2		//Has 2 Square Reach.
	attack_speed = 1.8// really slow
	damtype = RED_DAMAGE

	attack_verb_continuous = list("bludgeons", "whacks")
	attack_verb_simple = list("bludgeon", "whack")
	hitsound = 'sound/weapons/fixer/generic/spear2.ogg'

/obj/item/ego_weapon/shield/sangria
	name = "S.A.N.G.R.I.A"
	desc = "Succinct abbreviation naturally germinates rather immaculate art."
	icon_state = "sangria"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	hitsound = 'sound/weapons/bladeslice.ogg'
	force = 13
	attack_speed = 0.5
	damtype = BLACK_DAMAGE

	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	reductions = list(20, 20, 20, 0) // 60 - Diet Diet Daredevil
	projectile_block_duration = 0 SECONDS //No ranged parry
	block_duration = 0.5 SECONDS
	block_cooldown = 3 SECONDS
	block_sound = 'sound/weapons/parry.ogg'
	block_message = "You attempt to parry the attack!"
	hit_message = "parries the attack!"
	block_cooldown_message = "You rearm your blade."

/obj/item/ego_weapon/shield/sangria/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	return 0 //Prevents ranged  parry

/obj/item/ego_weapon/mini/soleil
	name = "soleil"
	desc = "Today I killed my mother, or maybe it was yesterday?"
	icon_state = "soleil"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	force = 11
	attack_speed = 0.5
	damtype = RED_DAMAGE


/obj/item/ego_weapon/taixuhuanjing
	name = "tai xuhuan jing"
	desc = "Jade has its flaws, and life its vicissitudes."
	icon_state = "tai_xuhuan_jing"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	force = 22
	reach = 2		//Has 2 Square Reach.
	attack_speed = 1.2
	damtype = WHITE_DAMAGE

	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/sword1.ogg'

/obj/item/ego_weapon/revenge
	name = "revenge"
	desc = "I have not broken your heart - YOU have; and in breaking it, you have broken mine."
	icon_state = "revenge"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	force = 35
	attack_speed = 1.6
	damtype = BLACK_DAMAGE

	attack_verb_continuous = list("beats", "smacks")
	attack_verb_simple = list("beat", "smack")

/obj/item/ego_weapon/revenge/attack(mob/living/target, mob/living/user)
	. = ..()
	if(!.)
		return FALSE
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user)

/obj/item/ego_weapon/mini/hearse
	name = "hearse"
	desc = "That bastard's still alive out there..."
	icon_state = "hearse"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	force = 33				//Lots of damage, way less DPS
	damtype = WHITE_DAMAGE

	attack_speed = 2 // Really Slow
	attack_verb_continuous = list("smashes", "bludgeons", "crushes")
	attack_verb_simple = list("smash", "bludgeon", "crush")

/obj/item/ego_weapon/shield/hearse
	name = "hearse"
	desc = "Call me Ishmael."
	special = "This weapon has a slow attack speed and deals atrocious damage."
	icon_state = "hearse_shield"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	force = 40
	damtype = WHITE_DAMAGE

	attack_verb_continuous = list("shoves", "bashes")
	attack_verb_simple = list("shove", "bash")
	hitsound = 'sound/weapons/genhit2.ogg'
	reductions = list(40, 20, 30, 0) // 90
	projectile_block_duration = 3 SECONDS
	block_duration = 3 SECONDS
	block_cooldown = 3 SECONDS
	block_sound_volume = 30

/obj/item/ego_weapon/raskolot //horn but a boomerang
	name = "raskolot"
	desc = "If only she could forget everything and begin afresh."
	icon_state = "raskolot"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	force = 22
	throwforce = 50
	throw_speed = 1
	throw_range = 7
	damtype = RED_DAMAGE

	hitsound = 'sound/weapons/ego/axe2.ogg'

/obj/item/ego_weapon/raskolot/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/caught = hit_atom.hitby(src, FALSE, FALSE, throwingdatum=throwingdatum)
	if(thrownby && !caught)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, throw_at), thrownby, throw_range+2, throw_speed, null, TRUE), 1)
	if(caught)
		return
	else
		return ..()

/obj/item/ego_weapon/vogel
	name = "vogel"
	desc = "The world of evil had begun there, right in the middle of our house."
	icon_state = "vogel"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	force = 22
	reach = 2		//Has 2 Square Reach.
	attack_speed = 1.2
	damtype = RED_DAMAGE

	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/axe2.ogg'

/obj/item/ego_weapon/nobody
	name = "nobody"
	desc = "I am nothing at all."
	special = "This E.G.O. functions as both a gun and a melee weapon."
	icon_state = "nobody"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	force = 20
	damtype = RED_DAMAGE

	attack_speed = 0.8
	attack_verb_continuous = list("cuts", "slices")
	attack_verb_simple = list("cuts", "slices")
	hitsound = 'sound/weapons/ego/sword2.ogg'

	var/gun_cooldown
	var/blademark_cooldown
	var/gunmark_cooldown
	var/gun_cooldown_time = 1.2 SECONDS

/obj/item/ego_weapon/nobody/Initialize()
	RegisterSignal(src, COMSIG_PROJECTILE_ON_HIT, PROC_REF(projectile_hit))
	..()

/obj/item/ego_weapon/nobody/afterattack(atom/target, mob/living/user, proximity_flag, clickparams)
	if(!CanUseEgo(user))
		return
	if(!proximity_flag && gun_cooldown <= world.time)
		var/turf/proj_turf = user.loc
		if(!isturf(proj_turf))
			return
		var/obj/projectile/ego_bullet/nobody/G = new /obj/projectile/ego_bullet/nobody(proj_turf)
		G.fired_from = src //for signal check
		playsound(user, 'sound/weapons/gun/shotgun/shot_alt.ogg', 100, TRUE)
		G.firer = user
		G.preparePixelProjectile(target, user, clickparams)
		G.fire()
		gun_cooldown = world.time + gun_cooldown_time
		return

/obj/item/ego_weapon/nobody/proc/projectile_hit(atom/fired_from, atom/movable/firer, atom/target, Angle)
	SIGNAL_HANDLER
	return TRUE

/obj/projectile/ego_bullet/nobody
	name = "gunblade bullet"
	damage = 20
	damage_type = RED_DAMAGE


/obj/item/ego_weapon/ungezifer
	name = "ungezifer"
	desc = "As I awoke one morning from uneasy dreams I found myself transformed in my bed into a gigantic insect."
	icon_state = "ungezifer"
	icon = 'icons/obj/limbus_weapons.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/limbus_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/limbus_righthand.dmi'
	force = 38				//Lots of damage, way less DPS
	damtype = BLACK_DAMAGE

	attack_speed = 2 // Really Slow
	attack_verb_continuous = list("smashes", "bludgeons", "crushes")
	attack_verb_simple = list("smash", "bludgeon", "crush")
	hitsound = 'sound/weapons/ego/justitia2.ogg'
