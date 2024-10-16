//Even when I die, my soul and dreams live on in this Subsystem. - Kitsunemitsu

SUBSYSTEM_DEF(fishing)
	name = "Fishing"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_DEFAULT
	var/moonphase = 1	//Four phases, Waning, New, Waxing, and Full
	var/stopnext		//Do we want to stop the planets until the moon is next full?

	//Sadly, For now each of these are in a separate variable. TODO: deshit this

	//1 Means it's in Alignment.
	var/Mercury = 1
	var/Venus = 1
	var/Mars = 1
	var/Jupiter = 1
	var/Saturn = 1
	var/Uranus = 1
	var/Neptune = 1


/datum/controller/subsystem/fishing/Initialize()
	..()
	if(!(SSmaptype.maptype in SSmaptype.citymaps))
		moonphase = 3	//3 should be average
		return	//Don't start if it's not a city map.

	//First set a moon phase
	moonphase = rand(1, 4)

	//then set planet alignments
	//Each planet takes one more cycle to align
	//The buffs only take into effect if it is in alignment, and you are devoted to the god
	Mercury = rand(1,2)		//God is Lir. Buffs the minimum and maximum size of fish.
	Venus = rand(1,3)		//God is Tefnut. Small chance to fish up a tamed enemy.
	Mars = rand(1,4)		//God is Arnapkapfaaluk. Buffs the damage of fishing based weapons.
	Jupiter = rand(1,5)		//God is Susanoo. Heals everyone around you, as well as AOE feeds people
	Saturn = rand(1,6)		//God is Kukulkan. Buffs aquarium stuff, not only will you heal to full SP on examining fish aquariums, if your aligned god is the same, You feed the fish for significantly longer
	Uranus = rand(1,7)		//God is Abena Mansa. Fishing gives you a wallet with ahn in it.
	Neptune = rand(1,8)		//God is Glaucus. Gives massive buffs to all things fishing related when aligned.

	addtimer(CALLBACK(src, PROC_REF(Moveplanets)), 7 MINUTES)

/datum/controller/subsystem/fishing/proc/Moveplanets()
	addtimer(CALLBACK(src, PROC_REF(Moveplanets)), 7 MINUTES)
	moonphase+=1		//Moon Phases will affect the power of Moon-based mods.
	if(moonphase == 5)	//there's only 4
		moonphase = 1

	if(stopnext && moonphase != 4)
		for(var/mob/M in GLOB.player_list)
			to_chat(M, span_userdanger("The planets begin to move again."))
		return

	Mercury+=1
	if(Mercury == 3)
		Mercury = 1

	Venus+=1
	if(Venus == 4)
		Venus = 1

	Mars+=1
	if(Mars == 5)
		Mars = 1

	Jupiter+=1
	if(Jupiter == 6)
		Jupiter = 1

	Saturn+=1
	if(Saturn == 7)
		Saturn = 1

	Uranus+=1
	if(Uranus == 8)
		Uranus = 1

	Neptune+=1
	if(Neptune == 9)
		Neptune = 1
