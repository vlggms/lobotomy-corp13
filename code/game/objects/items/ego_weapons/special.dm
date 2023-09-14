//Abnormality rewards
//Bottle of Tears
/obj/item/ego_weapon/eyeball
	name = "eyeball scooper"
	desc = "Mind if I take them?"
	special = "This weapon grows more powerful as you do, but its potential is limited if you possess any other EGO weapons."
	icon_state = "eyeball1"
	force = 20
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("cuts", "smacks", "bashes")
	attack_verb_simple = list("cuts", "smacks", "bashes")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 20		//It's 20 to keep clerks from using it
							)

/obj/item/ego_weapon/eyeball/attack(mob/living/target, mob/living/carbon/human/user)
	var/userfort = (get_attribute_level(user, FORTITUDE_ATTRIBUTE))
	var/fortitude_mod = clamp((userfort - 40) / 2 + 2, 0, 50) // 2 at 40 fortitude, 12 at 60 fortitude, 22 at 80 fortitude, 32 at 100 fortitude
	var/extra_mod = clamp((userfort - 80) * 1.3 + 2, 0, 28) // 2 at 80 fortitude, 28 at 100 fortitude
	var/list/search_area = user.contents.Copy()
	for(var/obj/item/storage/spare_space in search_area)
		search_area |= spare_space.contents
	for(var/obj/item/gun/ego_gun/disloyal_gun in search_area)
		extra_mod = 0
		break
	for(var/obj/item/ego_weapon/disloyal_weapon in search_area)
		if(disloyal_weapon == src)
			continue
		extra_mod = 0
		break
	force = 20 + fortitude_mod + extra_mod
	if(extra_mod > 0)
		var/resistance = target.run_armor_check(null, damtype)
		icon_state = "eyeball2"				// Cool sprite
		if(isanimal(target))
			var/mob/living/simple_animal/S = target
			if(S.damage_coeff[damtype] <= 0)
				resistance = 100
		if(resistance >= 100) // If the eyeball wielder is going no-balls and using one fucking weapon, let's throw them a bone.
			force *= 0.1
			armortype = MELEE //Armor-piercing
	else
		icon_state = "eyeball1"				//Cool sprite gone
	if(ishuman(target))
		force*=1.3						//I've seen Catt one shot someone, This is also only a detriment lol
	..()
	force = initial(force)
	armortype = initial(armortype)

	/*Here's how it works. It scales with Fortitude. This is more balanced than it sounds. Think of it as if Fortitude adjusted base force.
	Once you get yourself to 80, an additional scaling factor begins to kick in that will let you keep up through the endgame.
	This scaling factor only applies if it's the only weapon in your inventory, however. Use it faithfully, and it can cut through even enemies immune to black.
	Why? Because well Catt has been stated to work on WAWs, which means that she's at least level 3-4.
	Why is she still using Eyeball Scooper from a Zayin? Maybe it scales with fortitude?*/

//Puss in Boots
/obj/item/ego_weapon/lance/famiglia
	name = "famiglia"
	desc = "Do not be cast down, for I will provide for your well-being as well as mine."
	icon_state = "famiglia"
	lefthand_file = 'icons/mob/inhands/96x96_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/96x96_righthand.dmi'
	inhand_x_dimension = 96
	inhand_y_dimension = 96
	force = 33
	reach = 2		//Has 2 Square Reach.
	attack_speed = 1.8// really slow
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("bludgeons", "whacks")
	attack_verb_simple = list("bludgeon", "whack")
	hitsound = 'sound/weapons/ego/mace1.ogg'

/obj/item/ego_weapon/lance/famiglia/CanUseEgo(mob/living/carbon/human/user)
	. = ..()
	var/datum/status_effect/chosen/C = user.has_status_effect(/datum/status_effect/chosen)
	if(!C)
		to_chat(user, "<span class='notice'>You cannot use [src], only the abnormality's chosen can!</span>")
		return FALSE

/obj/item/ego_weapon/lance/famiglia/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	. = ..()
	if(raised)
		var/atom/throw_target = get_edge_target_turf(target, user.dir)
		if(!target.anchored)
			var/whack_speed = (prob(60) ? 1 : 4)
			target.throw_at(throw_target, rand(1, 2), whack_speed, user)

/obj/item/ego_weapon/lance/famiglia/LowerLance(mob/user)
	hitsound = 'sound/weapons/ego/spear1.ogg'
	..()

/obj/item/ego_weapon/lance/famiglia/RaiseLance(mob/user)
	hitsound = 'sound/weapons/ego/mace1.ogg'
	..()

//Event rewards
/obj/item/ego_weapon/goldrush/nihil
	name = "worthless greed"
	desc = "The magical girl, who was no longer a magical girl, ate many things. \
	Authority, money, fame, and many other forms of pleasure. She ended up eating away anything in her sight."
	special = "This weapon deals its damage after a short windup, unless combo is enabled."
	hitsound = 'sound/weapons/fixer/generic/fist2.ogg'
	icon_state = "greed"
	force = 40
	finisher_on = FALSE
	var/dash_cooldown
	var/dash_cooldown_time = 3 SECONDS
	var/dash_range = 7
	var/combo = 0
	var/combo_time
	var/combo_wait = 10

/obj/item/ego_weapon/goldrush/nihil/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/nihil))
		return
	..()

/obj/item/ego_weapon/goldrush/nihil/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(finisher_on)
		..()
		return
	if(world.time > combo_time)
		combo = 0
	combo_time = world.time + combo_wait
	if(combo==4)
		combo = 0
		user.changeNext_move(CLICK_CD_MELEE * 2)
		force *= 5	// Should actually keep up with normal damage.
		playsound(src, 'sound/weapons/fixer/generic/finisher2.ogg', 50, FALSE, 9)
		to_chat(user,"<span class='warning'>You are offbalance, you take a moment to reset your stance.</span>")
	else
		user.changeNext_move(CLICK_CD_MELEE * 0.4)
	..()
	combo += 1
	force = initial(force)

/obj/item/ego_weapon/goldrush/nihil/attack_self(mob/user)
	..()
	if(finisher_on)
		to_chat(user,"<span class='warning'>You will now perform a combo attack instead of a heavy attack.</span>")
		finisher_on = FALSE
		force = 40
		return

	to_chat(user,"<span class='warning'>You will now perform a heavy attack instead of a combo attack.</span>")
	finisher_on =TRUE
	force = 140

/obj/item/ego_weapon/goldrush/nihil/afterattack(atom/A, mob/living/user, proximity_flag, params)
	if(!CanUseEgo(user))
		return
	if(!isliving(A))
		return
	if(dash_cooldown > world.time)
		to_chat(user, "<span class='warning'>Your dash is still recharging!")
		return
	if((get_dist(user, A) < 4) || (!(can_see(user, A, dash_range))))
		return
	..()
	dash_cooldown = world.time + dash_cooldown_time
	for(var/i in 2 to get_dist(user, A))
		step_towards(user,A)
	if((get_dist(user, A) < 2))
		playsound(src, 'sound/weapons/fwoosh.ogg', 300, FALSE, 9)
		A.attackby(src,user)
	to_chat(user, "<span class='warning'>You dash to [A]!")

/obj/item/ego_weapon/shield/despair_nihil
	name = "meaningless despair"
	desc = "When Justice turns its back once more, several dozen blades will rove without a purpose. \
	The swords will eventually point at those she could not protect."
	special = "This weapon has a combo system."
	icon_state = "despair_nihil"
	force = 40
	attack_speed = 1
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("stabs", "attacks", "slashes")
	attack_verb_simple = list("stab", "attack", "slash")
	hitsound = 'sound/weapons/ego/rapier1.ogg'
	reductions = list(90, 90, 90, 50)
	projectile_block_duration = 1 SECONDS
	block_duration = 1 SECONDS
	block_cooldown = 3 SECONDS
	block_message = "You attempt to parry the attack!"
	hit_message = "parries the attack!"
	block_cooldown_message = "You rearm your blade."
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)
	var/combo = 0
	var/combo_time
	var/combo_wait = 10

//This is like an anime character attacking like 4 times with the 4th one as a finisher attack.
/obj/item/ego_weapon/shield/despair_nihil/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time)
		combo = 0
	combo_time = world.time + combo_wait
	if(combo==4)
		combo = 0
		user.changeNext_move(CLICK_CD_MELEE * 2)
		force *= 5	// Should actually keep up with normal damage.
		playsound(src, 'sound/weapons/fixer/generic/sword5.ogg', 50, FALSE, 9)
		to_chat(user,"<span class='warning'>You are offbalance, you take a moment to reset your stance.</span>")
	else
		user.changeNext_move(CLICK_CD_MELEE * 0.4)
	..()
	combo += 1
	force = initial(force)

/obj/item/ego_weapon/blind_rage/nihil
	name = "senseless wrath"
	desc = "The Servant of Wrath valued justice and balance more than anyone, but she began sharing knowledge with the \
	Hermit - an enemy of her realm, becoming friends with her in secret."
	icon_state = "wrath"
	force = 80
	attack_speed = 1.2
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)
	aoe_damage = 30
	aoe_range = 3

/obj/item/ego_weapon/blind_rage/nihil/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/nihil))
		return
	..()

//Tutorial
/obj/item/ego_weapon/tutorial
	name = "rookie dagger"
	desc = "E.G.O intended for Agent Education"
	icon_state = "rookie"
	force = 7
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("cuts", "stabs", "slashes")
	attack_verb_simple = list("cuts", "stabs", "slashes")

/obj/item/ego_weapon/tutorial/white
	name = "fledgling dagger"
	icon_state = "fledgling"
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE

/obj/item/ego_weapon/tutorial/black
	name = "apprentice dagger"
	icon_state = "apprentice"
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE

/obj/item/ego_weapon/tutorial/pale
	name = "freshman dagger"
	icon_state = "freshman"
	damtype = PALE_DAMAGE
	armortype = PALE_DAMAGE
