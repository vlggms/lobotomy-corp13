//Moving turret
/obj/machinery/manned_turret/rcorp
	name = "rcorp portable manned turret"
	desc = "While the trigger is held down, this gun will redistribute recoil to allow its user to easily shift targets."
	icon_state = "protoemitter_+u"
	view_range = 1
	projectile_type = /obj/projectile/beam/laser/pale

/obj/machinery/manned_turret/rcorp/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	if(user.mind)
		if(user.mind.has_antag_datum(/datum/antagonist/wizard/arbiter/rcorp))
			to_chat(user, "<span class='notice'>You wouldn't stoop so low as to use the weapons of those below you.</span>") //You are an arbiter not a heavy weapons guy
			return FALSE
	 ..()

/obj/machinery/manned_turret/rcorp/stationary
	name = "rcorp manned turret"
	icon_state = "protoemitter_+a"
	anchored = TRUE
	projectile_type = /obj/projectile/beam/laser/heavylaser/pale	//Nothing is immune nor absorbs pale
	rate_of_fire = 3
	number_of_shots = 10
	view_range = 6


/obj/machinery/manned_turret/rcorp/rook
	name = "rcorp rook turret"
	desc = "While the trigger is held down, this gun will redistribute recoil to allow its user to easily shift targets. Use a screwdriver on it to anchor and unanchor."
	icon_state = "protoemitter_+p"
	anchored = FALSE
	projectile_type = /obj/projectile/beam/laser/heavylaser/pale	//Nothing is immune nor absorbs pale
	rate_of_fire = 2
	number_of_shots = 6
	view_range = 3

/obj/machinery/manned_turret/rcorp/rook/attackby(obj/item/I, mob/user, params)
	..()
	if(I.tool_behaviour == TOOL_SCREWDRIVER && !anchored)
		anchored = TRUE
		to_chat(user, span_notice("You anchor your turret."))
		return
	if(I.tool_behaviour == TOOL_SCREWDRIVER && anchored)
		anchored = FALSE
		to_chat(user, span_notice("You unanchor your turret."))
		return


/obj/machinery/manned_turret/rcorp/red
	name = "rcorp red turret"
	desc = "This turret lays down suppressive fire unlike the others, it fires continuously with no cooldown."
	icon_state = "protoemitter"
	anchored = FALSE
	projectile_type = /obj/projectile/beam/laser/red	//red, but you can fire it continuously
	rate_of_fire = 2
	number_of_shots = 1
	view_range = 1
	cooldown_duration = 2
	overheatsound = null

/obj/machinery/manned_turret/rcorp/white
	name = "rcorp white turret"
	desc = "This turret fires white IFF bullets excellent for pushing."
	icon_state = "protoemitter+w"
	anchored = FALSE
	projectile_type = /obj/projectile/beam/laser/iff/white	//white, but you can fire it continuously
	view_range = 1
	cooldown_duration = 7 SECONDS

/obj/machinery/manned_turret/rcorp/black
	name = "rcorp black turret"
	desc = "This turret fires black bullets."
	icon_state = "protoemitter+b"
	anchored = FALSE
	projectile_type = /obj/projectile/beam/laser/black	//white, but you can fire it continuously
	view_range = 1
	cooldown_duration = 7 SECONDS
