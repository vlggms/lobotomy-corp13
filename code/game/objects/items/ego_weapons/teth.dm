/obj/item/ego_weapon/training
	name = "training hammer"
	desc = "E.G.O intended for Manager Education"
	icon_state = "training"
	force = 22
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("smacks", "hammers", "beats")
	attack_verb_simple = list("smack", "hammer", "beat")

/obj/item/ego_weapon/fragment
	name = "fragments from somewhere"
	desc = "The spear often tries to lead the wielder into a long and endless realm of mind, \
	but they must try to not be swayed by it."
	special = "This weapon has a longer reach.\
			This weapon attacks slower than usual."
	icon_state = "fragment"
	force = 22
	reach = 2		//Has 2 Square Reach.
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'

/obj/item/ego_weapon/fragment/melee_attack_chain(mob/user, atom/target, params)
	..()
	user.changeNext_move(CLICK_CD_MELEE * 1.4) // Has Longer reach, should be a little slower

/obj/item/ego_weapon/horn
	name = "horn"
	desc = "As the horn digs deep into the enemy's heart, it will turn blood red to show off the glamor that she couldn't in her life."
	icon_state = "horn"
	force = 22
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'

/obj/item/ego_weapon/lutemia
	name = "dear lutemia"
	desc = "Don't you want your cares to go away?"
	icon_state = "lutemia"
	force = 22
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'

/obj/item/ego_weapon/eyes
	name = "red eyes"
	desc = "It is likely able to hear, touch, smell, as well as see. And most importantly, taste."
	special = "Knocks certain enemies backwards.\
			This weapon hits slower than usual. "
	icon_state = "eyes"
	force = 35					//Still less DPS, replaces baseball bat
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("beats", "smacks")
	attack_verb_simple = list("beat", "smack")

/obj/item/ego_weapon/eyes/melee_attack_chain(mob/user, atom/target, params)
	..()
	user.changeNext_move(CLICK_CD_MELEE * 1.6) // Really Slow, is a baseball bat. Don't want to stunlock people

/obj/item/ego_weapon/eyes/attack(mob/living/target, mob/living/user)
	. = ..()
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user)

/obj/item/ego_weapon/eyeball
	name = "eyeball scooper"
	desc = "Mind if I take them?"
	icon_state = "eyeball1"
	force = 20
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("cuts", "smacks", "bashes")
	attack_verb_simple = list("cuts", "smacks", "bashes")

/obj/item/ego_weapon/eyeball/attack(mob/living/target, mob/living/carbon/human/user)
	var/userfort = (get_attribute_level(user, FORTITUDE_ATTRIBUTE))
	var/fortitude_mod = 1 + userfort/100
	if(userfort>=60)
		icon_state = "eyeball2"
		force = 20 *(1+fortitude_mod)		//Scales with Fortitude

	if(userfort<60)
		icon_state = "eyeball1"				//Cool sprite gone

	if(ishuman(target))
		force*=2						//I've seen Catt one shot someone, This is also only a detriment lol
	..()
	force = initial(force)
	/*So here's how it works, If you got the stats for it, you also scale with fort. It's pretty unremarkable otherwise.
	Why? Because well Catt has been stated to work on WAWs, which means that she's at least level 3-4.
	Why is she still using Eyeball Scooper from a Zayin? Maybe it scales with fortitude?*/

/obj/item/ego_weapon/little_alice
	name = "little alice"
	desc = "You, now in wonderland!"
	icon_state = "little_alice"
	force = 22
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slices", "slashes", "stabs")
	hitsound = 'sound/weapons/bladeslice.ogg'

