/obj/item/ego_weapon/mining//Only works for ER mining
	toolspeed = 0.8//total mining time = fortitude mod * toolspeed. Lower is faster.
	tool_behaviour = TOOL_MINING
	usesound = 'sound/effects/picaxe1.ogg'

/obj/item/ego_weapon/mining/examine(mob/user)
	. = ..()
	. += span_notice("This weapon can be used to mine at a [(100/toolspeed)]% efficiency.")
