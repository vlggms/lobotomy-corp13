//These are just toys and reward items, they don't necessarily have to be E.G.O.
/obj/item/onyx_hook
	name = "onyx hook"
	desc = "An E.G.O gift left by an unknown abnormality. It looks like something you've seen in a dream."
	icon = 'ModularTegustation/Teguicons/teguitems.dmi'
	icon_state = "onyx_hook"

/obj/item/onyx_hook/examine_more()
	. = list((span_notice("On closer examination, [src] appears to be an agate fishook.")))

/obj/item/onyx_hook/attack_self(mob/user)
	to_chat(user,span_notice("You USE the onyx hook."))
	if(do_after(user, 120, src))
		var/turf/T = get_turf(pick(SSjob.latejoin_trackers))
		playsound(user, 'sound/effects/magic.ogg', 60)
		flash_color(user, flash_color="#87CEEB", flash_time=12)
		user.forceMove(T)
		to_chat(user,span_notice("You've returned to safety!"))

/*//Re-introduce and map this when the formatting is unfucked
/obj/item/book/manual/wiki/enkephalin_rush
	name = "Site Recovery Manual"
	icon_state ="barbook"
	author = "Dr. Heavenly, Lobotomy Corporation"
	title = "Site Recovery Operations & Procedures"
	page_link = "Guide_to_Enkephalin_Rush"
*/
