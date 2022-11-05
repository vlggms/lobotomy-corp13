/obj/item/ego_weapon/lamp
	name = "lamp"
	desc = "Big Bird's eyes gained another in number for every creature it saved. \
	On this weapon, the radiant pride is apparent."
	special = "This weapon has a slightly slower attack speed. \
			This weapon attacks all non-humans in an AOE. \
			This weapon deals double damage on direct attack."
	icon_state = "lamp"
	force = 25
	attack_speed = 1.3
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("slams", "attacks")
	attack_verb_simple = list("slam", "attack")
	hitsound = 'sound/weapons/ego/hammer.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/lamp/attack(mob/living/M, mob/living/user)
	..()
	for(var/mob/living/L in livinginrange(1, M))
		var/aoe = 25
		var/userjust = (get_attribute_level(user, JUSTICE_ATTRIBUTE))
		var/justicemod = 1 + userjust/100
		aoe*=justicemod
		if(L == user || ishuman(L))
			continue
		L.apply_damage(aoe, BLACK_DAMAGE, null, L.run_armor_check(null, BLACK_DAMAGE), spread_damage = TRUE)
		new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(L))


/obj/item/ego_weapon/despair
	name = "sword sharpened with tears"
	desc = "A sword suitable for swift thrusts. \
	Even someone unskilled in dueling can rapidly puncture an enemy using this E.G.O with remarkable agility."
	special = "This weapon has a combo system. To turn off this combo system, use in hand. \
			This weapon has a fast attack speed"
	icon_state = "despair"
	force = 20
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("stabs", "attacks", "slashes")
	attack_verb_simple = list("stab", "attack", "slash")
	hitsound = 'sound/weapons/ego/rapier1.ogg'
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 80
							)
	var/combo = 0
	var/combo_time
	var/combo_wait = 10
	var/combo_on = TRUE

/obj/item/ego_weapon/despair/attack_self(mob/user)
	..()
	if(combo_on)
		to_chat(user,"<span class='warning'>You swap your grip, and will no longer perform a finisher.</span>")
		combo_on = FALSE
		return
	if(!combo_on)
		to_chat(user,"<span class='warning'>You swap your grip, and will now perform a finisher.</span>")
		combo_on =TRUE
		return

//This is like an anime character attacking like 4 times with the 4th one as a finisher attack.
/obj/item/ego_weapon/despair/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time || !combo_on)	//or you can turn if off I guess
		combo = 0
	combo_time = world.time + combo_wait
	if(combo==4)
		combo = 0
		user.changeNext_move(CLICK_CD_MELEE * 2)
		force *= 5	// Should actually keep up with normal damage.
		playsound(src, 'sound/weapons/fwoosh.ogg', 300, FALSE, 9)
		to_chat(user,"<span class='warning'>You are offbalance, you take a moment to reset your stance.</span>")
	else
		user.changeNext_move(CLICK_CD_MELEE * 0.4)
	..()
	combo += 1
	force = initial(force)

/obj/item/ego_weapon/totalitarianism
	name = "totalitarianism"
	desc = "When one is oppressed, sometimes they try to break free."
	special = "This weapon attacks extremely slowly. Use in hand to unlock it's full power."
	icon_state = "totalitarianism"
	force = 80
	attack_speed = 3
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleaves", "cuts")
	hitsound = 'sound/weapons/ego/hammer.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)
	var/charged = FALSE

/obj/item/ego_weapon/totalitarianism/attack(mob/living/M, mob/living/user)
	..()
	force = 80
	charged = FALSE

/obj/item/ego_weapon/totalitarianism/attack_self(mob/user)
	if(do_after(user, 12))
		charged = TRUE
		force = 120	//FULL POWER
		to_chat(user,"<span class='warning'>You put your strength behind this attack.</span>")

/obj/item/ego_weapon/oppression
	name = "oppression"
	desc = "Even light forms of contraint can be considered totalitarianism"
	special = "This weapon builds up charge on every hit. Use the weapon in hand to charge the blade."
	icon_state = "oppression"
	force = 13
	attack_speed = 0.3
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleaves", "cuts")
	hitsound = 'sound/weapons/slash.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 80
							)
	var/charged = FALSE
	var/meter = 0
	var/meter_counter = 1

/obj/item/ego_weapon/oppression/attack_self(mob/user)
	if (!charged)
		charged = TRUE
		to_chat(user,"<span class='warning'>You focus your energy, adding [meter] damage to your next attack.</span>")
		force += meter
		meter = 0

/obj/item/ego_weapon/oppression/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	meter += meter_counter
	meter_counter += 1

	meter = min(meter, 60)
	..()
	if(charged == TRUE)
		charged = FALSE
		force = 15
		meter_counter = 0

/obj/item/ego_weapon/remorse
	name = "remorse"
	desc = "A hammer and nail, unwieldy and impractical against most. \
	Any crack, no matter how small, will be pried open by this E.G.O."
	special = "This weapon hits slower than usual."
	icon_state = "remorse"
	special = "Use this weapon in hand to change it's mode. \
		The Nail mode marks targets for death. \
		The Hammer mode deals bonus damage to all marked."
	force = 30	//Does more damage later.
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("Smashes", "Pierces", "Cracks")
	attack_verb_simple = list("Smash", "Pierce", "Crack")
	hitsound = 'sound/weapons/ego/remorse.ogg'
	attribute_requirements = list(
							PRUDENCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)
	var/list/targets = list()
	var/ranged_damage = 60	//Fuckload of white on ability. Be careful!
	var/mode = FALSE		//False for nail, true for hammer

/obj/item/ego_weapon/remorse/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return

	if(!mode)
		if(!(M in targets))
			targets+= M

	if(mode)
		if(M in targets)
			playsound(M, 'sound/weapons/slice.ogg', 100, FALSE, 4)
			M.apply_damage(ranged_damage, WHITE_DAMAGE, null, M.run_armor_check(null, WHITE_DAMAGE), spread_damage = TRUE)
			new /obj/effect/temp_visual/remorse(get_turf(M))
			targets -= M
	..()

/obj/item/ego_weapon/remorse/attack_self(mob/user)
	if(!CanUseEgo(user))
		return
	if(mode)	//Turn to nail
		mode = FALSE
		to_chat(user,"<span class='warning'>You swap to nail mode, clearing all marks.</span>")
		targets = list()
		return

	if(!mode)	//Turn to hammer
		mode = TRUE
		to_chat(user,"<span class='warning'>You swap to hammer mode.</span>")
		return

/obj/item/ego_weapon/mini/crimson
	name = "crimson claw"
	desc = "It's more important to deliver a decisive strike in blind hatred without hesitation than to hold on to insecure courage. "
	icon_state = "crimsonclaw"
	force = 32
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60
							)

/obj/item/ego_weapon/thirteen
	name = "for whom the bell tolls"
	desc = "There is nothing else than now. There is neither yesterday, certainly, nor is there any tomorrow."
	special = "This weapon deals an absurd amount of damage on the 13th hit."
	icon_state = "thirteen"
	force = 35
	damtype = PALE_DAMAGE
	armortype = PALE_DAMAGE
	attack_verb_continuous = list("cuts", "attacks", "slashes")
	attack_verb_simple = list("cut", "attack", "slash")
	hitsound = 'sound/weapons/rapierhit.ogg'
	attribute_requirements = list(
							JUSTICE_ATTRIBUTE = 60
							)
	var/combo = 0
	var/combo_time
	var/combo_wait = 3 SECONDS

//On the 13th hit, Deals user justice x 2
/obj/item/ego_weapon/thirteen/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time)
		combo = 0
	combo_time = world.time + combo_wait
	if(combo >= 13)
		combo = 0
		force = get_attribute_level(user, JUSTICE_ATTRIBUTE)
		new /obj/effect/temp_visual/thirteen(get_turf(M))
		playsound(src, 'sound/weapons/ego/price_of_silence.ogg', 25, FALSE, 9)
	..()
	combo += 1
	force = initial(force)



/obj/item/ego_weapon/stem
	name = "green stem"
	desc = "All personnel involved in the equipment's production wore heavy protection to prevent them from being influenced by the entity."
	special = "This weapon has a longer reach. \
			This weapon attacks slower than usual."
	icon_state = "green_stem"
	force = 32 //original 8-16
	reach = 2		//Has 2 Square Reach.
	attack_speed = 1.2
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'
	equip_sound = 'sound/creatures/venus_trap_hit.ogg'
	pickup_sound = 'sound/creatures/venus_trap_hurt.ogg'
	attribute_requirements = list(
							TEMPERANCE_ATTRIBUTE = 60
							)
	var/vine_cooldown
	var/vine_delay = 1 SECONDS

/obj/item/ego_weapon/stem/Initialize(mob/user)
	.=..()
	vine_cooldown = world.time

/obj/item/ego_weapon/stem/attack_self(mob/user) //spawn bitter flora
	. = ..()
	if(!CanUseEgo(user))
		return
	if(vine_cooldown <= world.time)
		user.visible_message("<span class='notice'>[user] stabs [src] into the ground.</span>", "<span class='nicegreen'>You stab your [src] into the ground.</span>")
		for(var/obj/structure/alien/weeds/F0442/F in range(0, get_turf(user)))
			if(F)
				playsound(src, 'sound/creatures/venus_trap_hurt.ogg', 10, FALSE, 5)
				qdel(F)
				return
		var/mob/living/carbon/human/L = user
		L.visible_message("<span class='notice'>Wilted stems grow from [src].</span>")
		new /obj/structure/alien/weeds/F0442(get_turf(user))
		L.adjust_nutrition(-10)
		vine_cooldown = world.time + vine_delay



