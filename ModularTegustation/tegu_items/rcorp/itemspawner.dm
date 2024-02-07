//Split into weapons and not weapons.
/obj/effect/landmark/rcorpitemspawn
	name = "rcorp requisitions"
	desc = "It spawns an item. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"
	var/list/possible_items = list(
		/obj/item/grenade/smokebomb,
		/obj/item/ksyringe,
		/obj/item/reagent_containers/hypospray/medipen/salacid,
		/obj/item/reagent_containers/hypospray/medipen/mental,
		/obj/item/stack/sheet/mineral/sandbags/ten,
		/obj/item/flashlight/flare,
		/obj/item/kcrit,
	)
	var/list/possible_weapons = list(
		/obj/item/gun/energy/e_gun/rabbitdash,
		/obj/item/gun/energy/e_gun/rabbitdash/small,
		/obj/item/gun/energy/e_gun/rabbitdash/sniper,
		/obj/item/gun/energy/e_gun/rabbitdash/white,
		/obj/item/gun/energy/e_gun/rabbitdash/black,
		/obj/item/gun/energy/e_gun/rabbitdash/shotgun,
//		/obj/item/gun/energy/e_gun/rabbitdash/laser,
		/obj/item/gun/energy/e_gun/rabbitdash/pale,
		/obj/item/gun/energy/e_gun/rabbit/minigun,
		/obj/item/gun/energy/e_gun/rabbitdash/heavy,
	)


/obj/effect/landmark/rcorpitemspawn/Initialize()
	..()
	var/spawning = pick(possible_items)
	if(prob(30))
		spawning = pick(possible_weapons)
	new spawning(get_turf(src))
	var/timeradd = rand(1200, 1800)
	addtimer(CALLBACK(src, PROC_REF(spawnagain)), timeradd)

/obj/effect/landmark/rcorpitemspawn/proc/spawnagain()
	var/timeradd = rand(1200, 1800)
	addtimer(CALLBACK(src, PROC_REF(spawnagain)), timeradd)

	if(prob(50))	//50% to spawn
		return

	var/spawning = pick(possible_items)
	new spawning(get_turf(src))


//for the zombie mode
/obj/effect/landmark/zombiespawn
	name = "rcorp sweeperspawn"
	desc = "It spawns sweepers. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "tdome_admin"

/obj/effect/landmark/zombiespawn/Initialize()
	..()
	spawnzombie()

/obj/effect/landmark/zombiespawn/proc/spawnzombie()
	var/timeradd = rand(300, 1000)
	addtimer(CALLBACK(src, PROC_REF(spawnzombie)), timeradd)
	var/mob/living/simple_animal/hostile/sweeper/A = new(get_turf(src))


	var/obj/effect/proc_holder/spell/targeted/night_vision/bloodspell = new
	A.AddSpell(bloodspell)
	A.faction += "hostile"

//Randomize the rhino
/obj/effect/landmark/rhinospawner
	name = "rhino spawner"
	desc = "It spawns an item. Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"
	var/list/possible_mecha = list(
		/obj/vehicle/sealed/mecha/combat/rhino,
		/obj/vehicle/sealed/mecha/combat/rhinosupport,
		/obj/vehicle/sealed/mecha/combat/rhinoshotgun,
		/obj/vehicle/sealed/mecha/combat/rhinorifle,
	)

/obj/effect/landmark/rhinospawner/Initialize()
	..()
	var/spawning = pick(possible_mecha)
	if(prob(1))
		spawning = /obj/vehicle/sealed/mecha/combat/tank
	if(SSmaptype.jobtype)
		return
	new spawning(get_turf(src))


//Split into weapons and not weapons.
/obj/effect/landmark/wallspawner
	name = "wall spawner"
	desc = "It spawns a wall or not. Who knows? Notify a coder. Thanks!"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "x4"

/obj/effect/landmark/wallspawner/Initialize()
	..()
	if(!SSmaptype.jobtype)
		return
	new /turf/closed/wall/mineral/titanium/survival/pod(get_turf(src))
