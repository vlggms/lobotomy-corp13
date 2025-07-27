// All damn guns in rifle.dm are bolt-action...
/obj/item/gun/ballistic/rifle_auto
	name = "Semi-automatic Rifle"
	desc = "Some kind of semi-automatic rifle. You get the feeling you shouldn't have this."
	icon_state = "moistnugget"
	w_class = WEIGHT_CLASS_BULKY
	inhand_icon_state = "moistnugget"
	worn_icon_state = "moistnugget"
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction
	bolt_wording = "bolt"
	semi_auto = TRUE
	internal_magazine = TRUE
	fire_sound = 'sound/weapons/gun/rifle/shot.ogg'
	fire_sound_volume = 90
	vary_fire_sound = FALSE
	rack_sound = 'sound/weapons/gun/rifle/bolt_out.ogg'
	bolt_drop_sound = 'sound/weapons/gun/rifle/bolt_in.ogg'
	tac_reloads = FALSE

/obj/item/gun/ballistic/rifle_auto/atelier
	name = "'Atelier Logic' rifle"
	desc = "A semi-automatic rifle produced by Atelier Logic workshop."
	color = "#555555" // I am too lazy to make new sprites
	fire_sound = 'sound/weapons/gun/rifle/shot_atelier.ogg'
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction/atelier
	fire_delay = 6
