/obj/item/ego_weapon/template/scythe
	name = "scythe template"
	desc = "An unfinished scythe template"
	special = "This weapon has a short combo."
	icon_state = "scythetemplate"
	force = 20
	attack_speed = 0.9
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("slashes", "slices", "rips", "cuts")
	attack_verb_simple = list("slash", "slice", "rip", "cut")
	hitsound = 'sound/weapons/ego/da_capo1.ogg'
	finishedicon = list("finishedscythe")
	finishedname = list("scythe", "reaper", "sickle")
	finisheddesc = "A finished scythe, ready for use."


	var/combo = 0
	var/combo_time
	var/combo_wait = 14
	//I need to use Capo instead of something else for one reason: These change their speed.

/obj/item/ego_weapon/template/scythe/attack(mob/living/M, mob/living/user)
	if(!CanUseEgo(user))
		return
	if(world.time > combo_time)
		combo = 0
	combo_time = world.time + combo_wait
	switch(combo)
		if(1)
			hitsound = 'sound/weapons/ego/da_capo2.ogg'
		if(2)
			hitsound = 'sound/weapons/ego/da_capo3.ogg'
			force *= 1.5
			combo = -1
		else
			hitsound = 'sound/weapons/ego/da_capo1.ogg'
	..()
	combo += 1
	force = initial(force)
