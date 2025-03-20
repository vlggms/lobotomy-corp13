/obj/item/ego_weapon/city/DRabbitbat//it's just a HE W.corp baton that deals red
	name = "Dead Rabbits Bat"
	desc = "A nasty-looking bat covered with nails."
	special = "This weapon has a combo system with a stun finisher."
	icon = 'ModularTegustation/Teguicons/DeadRabbitBatIcons.dmi'
	icon_state = "RabbitBat"
	lefthand_file = 'ModularTegustation/Teguicons/DeadRabbitBatsL.dmi'
	righthand_file = 'ModularTegustation/Teguicons/DeadRabbitBatsR.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 25
	damtype = RED_DAMAGE
	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80
							)
	var/combo = 0
	/// Maximum world.time after which combo is reset
	var/combo_time
	/// Wait time between attacks for combo to reset
	var/combo_wait = 20
	var/waltz_partner

/obj/item/ego_weapon/city/DRabbitbat/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time)
		combo = 0
	if(!waltz_partner || waltz_partner != M)
		waltz_partner = M
		combo = 0
	combo_time = world.time + combo_wait
	switch(combo)
		if(1)
			hitsound = 'sound/weapons/ego/mace1.ogg'
		if(2)
			hitsound = 'sound/weapons/ego/strong_gauntlet.ogg'
			force *= 1.5
			combo = -1
			M.Knockdown(20, ignore_canstun = FALSE)
		else
			hitsound = 'sound/weapons/ego/mace1.ogg'
	..()
	combo += 1
	force = initial(force)

/obj/item/ego_weapon/city/DRabbitbat/get_clamped_volume()
	return 40

/obj/item/ego_weapon/city/DRabbitBossBat//it's just a HE W.corp baton that deals red
	name = "Dead Rabbit Boss Bat"
	desc = "A nasty-looking bat covered with nails."
	special = "This weapon has a combo system with a stun finisher."
	icon = 'ModularTegustation/Teguicons/DeadRabbitBatIcons.dmi'
	icon_state = "RabbitBossBat"
	lefthand_file = 'ModularTegustation/Teguicons/DeadRabbitBatsL.dmi'
	righthand_file = 'ModularTegustation/Teguicons/DeadRabbitBatsR.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	force = 50
	damtype = BLACK_DAMAGE
	attack_verb_continuous = list("bashes", "crushes")
	attack_verb_simple = list("bash", "crush")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100
							)


	var/combo = 0
	/// Maximum world.time after which combo is reset
	var/combo_time
	/// Wait time between attacks for combo to reset
	var/combo_wait = 40
	var/waltz_partner

/obj/item/ego_weapon/city/DRabbitBossBat/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time)
		combo = 0
	if(!waltz_partner || waltz_partner != M)
		waltz_partner = M
		combo = 0
	combo_time = world.time + combo_wait
	switch(combo)
		if(1)
			hitsound = 'sound/weapons/ego/mace1.ogg'
		if(2)
			hitsound = 'sound/weapons/ego/strong_gauntlet.ogg'
			force *= 1.5
			combo = -1
			M.Knockdown(40)
			var/obj/item/held = M.get_active_held_item()
			M.dropItemToGround(held)
		else
			hitsound = 'sound/weapons/ego/mace1.ogg'
	..()
	combo += 1
	force = initial(force)

/obj/item/ego_weapon/city/DRabbitBossBat/get_clamped_volume()
	return 40
