//LC13 ATV's
/obj/vehicle/ridden/atv_lobotomy
	name = "architecture kart"
	desc = "A department-colored go-kart."
	icon_state = "atv"
	max_integrity = 150
	armor = list(MELEE = 50, BULLET = 25, LASER = 20, ENERGY = 0, BOMB = 50, BIO = 0, RAD = 0, FIRE = 60, ACID = 60)
	key_type = /obj/item/key/atv
	integrity_failure = 0.5
	var/static/mutable_appearance/atvcover

/obj/vehicle/ridden/atv_lobotomy/Initialize()
	. = ..()
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/atv/lobotomy)

/obj/vehicle/ridden/atv_lobotomy/post_buckle_mob(mob/living/M)
	add_overlay(atvcover)
	return ..()

/obj/vehicle/ridden/atv_lobotomy/post_unbuckle_mob(mob/living/M)
	if(!has_buckled_mobs())
		cut_overlay(atvcover)
	return ..()

/obj/vehicle/ridden/atv_lobotomy/control
	name = "control kart"
	icon_state = "atv_control"

/obj/vehicle/ridden/atv_lobotomy/information
	name = "information kart"
	icon_state = "atv_info"

/obj/vehicle/ridden/atv_lobotomy/training
	name = "training kart"
	icon_state = "atv_training"

/obj/vehicle/ridden/atv_lobotomy/safety
	name = "safety kart"
	icon_state = "atv_safety"

/obj/vehicle/ridden/atv_lobotomy/command
	name = "central command kart"
	icon_state = "atv_command"

/obj/vehicle/ridden/atv_lobotomy/discipline
	name = "disciplinary kart"
	icon_state = "atv_discipline"

/obj/vehicle/ridden/atv_lobotomy/welfare
	name = "welfare kart"
	icon_state = "atv_welfare"

/obj/vehicle/ridden/atv_lobotomy/extraction
	name = "extraction kart"
	icon_state = "atv_extraction"

/obj/vehicle/ridden/atv_lobotomy/records
	name = "records kart"
	icon_state = "atv_records"
