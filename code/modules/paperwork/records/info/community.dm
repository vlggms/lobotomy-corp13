/obj/structure/filingcabinet/chestdrawer/community//use this for maps with specific custom abnormalities
	name = "custom abnormality information cabinet"
	var/virgin = TRUE
	var/file_path = /obj/item/paper/fluff/info/zayin

/obj/structure/filingcabinet/chestdrawer/community/proc/fillCurrent()
	var/list/queue = subtypesof(file_path)
	for(var/sheet in queue)
		new sheet(src)


/obj/structure/filingcabinet/chestdrawer/community/interact(mob/user)
	if(virgin)
		fillCurrent()
		virgin = FALSE
	return ..()

/obj/structure/filingcabinet/chestdrawer/community/district4
	name = "district 4 abnormality information cabinet"
	file_path = /obj/item/paper/fluff/info/community/district4

/obj/structure/filingcabinet/chestdrawer/community/district4/fillCurrent()
	..()
	new /obj/item/paper/fluff/info/waw/thunder_bird(src)

//Dragon Skull
/obj/item/paper/fluff/info/community/district4/dragonskull
	name = "The Dragon Skull - F-09-04-15"//these use limbus company (branch) standards
	info = {"<h1><center>F-09-04-15</center></h1>	<br>
	Name : The Dragon Skull<br>
	Risk Class : ZAYIN	<br>
	- An ancient artifact that allows one to overcome their fears.	<br>
	- It causes one to forget their knowledge of the horrors experienced here.	<br>
	- While protected from the terror of other abnormalities, the mind is vulnerable to the dragon skull itself."}

//change formats once the abnos are ready
/obj/item/paper/fluff/info/community/district4/tsa_woods//HE
/*	abno_type = /mob/living/simple_animal/hostile/abnormality/tsa_woods
	abno_code = "T-04-04-11"
	abno_info = list(
		"When agent Emma began work while wielding a weapon, qliphoth counter lowered.",
		"When the work result was Bad, the Qliphoth Counter lowered.",
		"When Creek Transporation Agency escaped, it occupied a corridor of the facility.",
	)*/
	name = "Creek Transportation Agency - T-04-04-11"
	info = {"<h1><center>T-04-04-11</center></h1>	<br>
	Name : Creek Transportation Agency<br>
	Risk Class : HE	<br>
	- When agent Emma began work while wielding a weapon, qliphoth counter lowered.	<br>
	- When the work result was Bad, the Qliphoth Counter lowered.	<br>
	- When Creek Transporation Agency escaped, it occupied a corridor of the facility."}

/obj/item/paper/fluff/info/community/district4/farmhand//WAW
/*	abno_type = /mob/living/simple_animal/hostile/abnormality/farmhand
	abno_code = "O-05-04-12"
	abno_info = list(
		"Lobotomy Corporation's procedures for this abnormality have yet to be discovered.",
	)*/
	name = "Tools of the Family Farmhand - O-05-04-12"
	info = {"<h1><center>O-05-04-12</center></h1>	<br>
	Name : Tools of the Family Farmhand<br>
	Risk Class : WAW	<br>
	- Lobotomy Corporation's procedures for this abnormality have yet to be discovered."}

/obj/item/paper/fluff/info/community/district4/mcollough//WAW
/*	abno_type = /mob/living/simple_animal/hostile/abnormality/mcollough_spectrum
	abno_code = "O-03-04-17"
	abno_info = list(
		"Lobotomy Corporation's procedures for this abnormality have yet to be discovered.",
	)*/
	name = "Mcollough Spectrum Entity - O-03-04-17"
	info = {"<h1><center>O-03-04-17</center></h1>	<br>
	Name : Mcollough Spectrum Entity<br>
	Risk Class : WAW	<br>
	- Lobotomy Corporation's procedures for this abnormality have yet to be discovered."}

/obj/item/paper/fluff/info/community/district4/cabin_beast//ALEPH
/*	abno_type = /mob/living/simple_animal/hostile/abnormality/cabin_beast
	abno_code = "T-02-04-14"
	abno_info = list(
		"Lobotomy Corporation's procedures for this abnormality have yet to be discovered.",
	)*/
	name = "The Beast of the Faraway Cabin - T-02-04-14"
	info = {"<h1><center>T-02-04-14</center></h1>	<br>
	Name : The Beast of the Faraway Cabin<br>
	Risk Class : ALEPH	<br>
	- Lobotomy Corporation's procedures for this abnormality have yet to be discovered."}
