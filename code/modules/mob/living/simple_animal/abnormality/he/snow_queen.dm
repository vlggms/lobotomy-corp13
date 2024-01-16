//Just some map-related things and comments for the develeoper

//portrait = "snow_queen"

/obj/effect/landmark/snowqueen_teleport
	name = "snow queen teleport"
	icon_state = "x2"

/obj/effect/landmark/snowqueen_spawn
	name = "snow queen spawn"
	icon_state = "x"

/obj/effect/landmark/snowqueen_playerspawn
	name = "snow queen player spawn"
	icon_state = "observer_start"

/obj/effect/landmark/snowqueen_victimspawn
	name = "snow queen victim spawn"
	icon_state = "observer_start"

//The sword holder
/obj/structure/frozensword
	name = "frozen sword"
	desc = "A sword, partially frozen. It beckons you to try and pull it out."
	icon = 'icons/obj/structures.dmi'
	icon_state = "icechunk"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/obj/item/ego_weapon/THESWORD //UPDATE ME!!!
	var/empty = FALSE

/obj/structure/frozensword/Initialize()
	. = ..()
	THESWORD = new
	update_icon()

/obj/structure/frozensword/attack_hand(mob/user) //Add code to open the gate when its drawn
	. = ..()
	if(THESWORD)
		user.put_in_hands(THESWORD)
		to_chat(user, span_notice("You pull out [THESWORD]!."))
		src.add_fingerprint(user)
		empty = TRUE
		update_icon()
		return

/obj/structure/frozensword/attack_paw(mob/living/user)
	return attack_hand(user)

/obj/structure/frozensword/update_overlays()
	. = ..()
	if(!empty)
		. += "sword"

/obj/structure/frozensword/proc/Refresh()
	if(!QDELETED(THESWORD))
		qdel(THESWORD)
	THESWORD = new
	empty = FALSE
	update_icon()
	return

/*
This is a code snippet that should be used when the player exits or dies to refresh the boss areana
Change /obj/item/ego_weapon to the path of the special snow queen sword
You may also simply be able to call refresh when snow queen dies.

	//To delete the sword. You can call this when snow queen dies by adding the player as a variable or any similar approach
	for(var/obj/item/ego_weapon/THESWORDPATH/THESWORD in PLAYERS_EXITING_ARENA.GetAllContents())
		qdel(THESWORD)

	//To reset the structure, you can call this when snow queen dies.
	var/linked_structure = locate(/obj/structure/frozensword) in world.contents
	linked_structure.Refresh()


Airlock stuff
Find /obj/machinery/door/airlock/snowqueen in the airlock_types.dm file
To prevent players from leaving without the sword, make sure to update the path of the sword in the code.


Footnotes

It is probably a good idea to stick the sword to the player's hand, lest they get trapped behind the gate after throwing it through or something.
 */
