/*
Work Damage Notation [Halve these numbers for pale, because seriously, 10 Pale kills real easily]
Very Low: <3 Damage
Low: 4-6
Moderate: 7-9
High: 10-12
Extreme: 12+

Resistance Notation
Absorbs: -X
Immune: 0
Ineffective: 0.1-0.4
Endured: 0.5-0.9
Normal: 1
Weak: 1.1-1.5
Fatal: 1.6-2

For Escape damage, I think I'll just honestly ball-park how fast it could reasonably kill someone.
*/
/obj/item/paper/fluff/info
	show_written_words = FALSE
	slot_flags = null	//No books on head, sorry


/obj/item/paper/fluff/info/attackby(obj/item/P, mob/living/user, params)
	ui_interact(user)	// only reading, sorry


/obj/item/paper/fluff/info/zayin
	icon_state = "zayin"

/obj/item/paper/fluff/info/teth
	icon_state = "teth"

/obj/item/paper/fluff/info/he
	icon_state = "he"

/obj/item/paper/fluff/info/waw
	icon_state = "waw"

/obj/item/paper/fluff/info/aleph
	icon_state = "aleph"
