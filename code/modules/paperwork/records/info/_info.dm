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
	var/no_archive = FALSE //will not show up in Lobotomy Corp Archive Computer if true


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

/obj/item/paper/fluff/info/zayin/archive_guide
	name = "Archive Guide"
	info = {"<h1><center>Archive Guide</center></h1>	<br>
	Welcome to Lobotomy Corps Digital Archive! <br>
	In order to effeciently navigate the archives please learn what the classification code of a abnormality actually means.<br>
	The first letter in a abnormalities classification code is their series or class.<br>
	F is for abnormalities that take on the traits of fictional stories or urban legends.<br>
	T is for abnormalities that formed from traumatic experiences or embody a certain phobia.<br>
	O is for abnormalities that do not take on the traits of traumas or fairy tales. <br>
	D is for abnormalities that were labeled as non essential for our overall goal. <br>
	-<br>
	The second letter of the classification code is their physical form, this is easier to find if you have seen the abnormality.<br>
	01 is humanoids, <br>
	02 is animals, <br>
	03 is otherworldy creatures, <br>
	04 is inanimate objects, <br>
	05 is mechanical or inorganic creatures,<br>
	06 is abstract or an amalgamation of entities, <br>
	07 is enities who are usable items while inert but can transform {currently used for O-O7-103}, <br>
	08 is currently unused,<br>
	09 is devices that require interaction to express their effects.<br>
	- <br>
	The final numbers in the code are unique to each abnormality.<br>
	Lobotomy Corp hopes you can meet their expectations.<br>"}
