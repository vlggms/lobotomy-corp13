//Moving turret
/obj/machinery/manned_turret/rcorp
	name = "rcorp portable manned turret"
	desc = "While the trigger is held down, this gun will redistribute recoil to allow its user to easily shift targets."
	icon_state = "protoemitter_+u"
	view_range = 1
	projectile_type = /obj/projectile/beam/laser/pale

/obj/machinery/manned_turret/rcorp/stationary
	name = "rcorp manned turret"
	icon_state = "protoemitter_+a"
	anchored = TRUE
	projectile_type = /obj/projectile/beam/laser/heavylaser/pale	//Nothing is immune nor absorbs pale
	rate_of_fire = 3
	number_of_shots = 10
	view_range = 6
