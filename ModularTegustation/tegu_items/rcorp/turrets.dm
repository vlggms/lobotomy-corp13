//Moving turret
/obj/machinery/manned_turret/rcorp
	name = "rcorp portable manned turret"
	desc = "While the trigger is held down, this gun will redistribute recoil to allow its user to easily shift targets."
	icon_state = "protoemitter_+u"
	view_range = 1
	projectile_type = /obj/projectile/beam/laser/red

/obj/machinery/manned_turret/rcorp/stationary
	name = "rcorp manned turret"
	icon_state = "protoemitter_+a"
	anchored = TRUE
