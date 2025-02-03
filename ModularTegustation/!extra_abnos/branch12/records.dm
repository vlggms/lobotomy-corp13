//All the records for this gamemodes goes into one filing cabinet
/obj/structure/filingcabinet/branch12
	name = "abnormality information cabinet"
	icon_state = "chestdrawer"
	var/virgin = TRUE

/obj/structure/filingcabinet/branch12/proc/fillCurrent()
	var/list/queue = subtypesof(/obj/item/paper/fluff/info/branch12)
	for(var/sheet in queue)
		new sheet(src)

/obj/structure/filingcabinet/branch12/interact(mob/user)
	if(virgin)
		fillCurrent()
		virgin = FALSE
	return ..()

//	-------------ZAYIN-------------
// Full Wave M'aider
/obj/item/paper/fluff/info/branch12/wave
	abno_type = /mob/living/simple_animal/hostile/abnormality/wave
	abno_code = "O-06-12-102"
	abno_info = list(
		"It was noticed upon a good work result on attachment that a soothing song could be heard in other containment units, relaxing the other abnormalities for the rest of the shift.",
		"The relaxed abnormalities seemed more prone to testing, producing more E on average.",
		"Despite being beneficial to E production, an employee should not try to do attachment work twice in a day. Doing so will result in <Redacted> being heard across the facility, slowly doing white damage to all employees.",
		"The <Redacted> can be stopped once a employee gets a good work result on O-06-12-102",
	)


//	-------------TETH-------------
// Remnant of the Forest
/obj/item/paper/fluff/info/branch12/rock
	abno_type = /mob/living/simple_animal/hostile/abnormality/rock
	abno_code = "O-04-12-120"
	abno_info = list(
		"<Experiment> The employee Johnson began work on O-04-12-120, and O-04-12-120 produced 1 E then promptly disappeared.",
		"Upon further examination O-04-12-120 was found in one of the corridors in the department its containment room was in.",
		"O-04-12-120 showed no signs of anomalous effects when escaped. Employee Johnson then carried O-04-12-120 back to its unit.",
		"O-04-120 has only caused 17 employee deaths to date, three of which were due to blunt force trauma as a result of being launched by breaching abnormalities. The others were a result of an unapproved bet between employees to feed O-04-12-120 to O-01-15.",
		"Please for the love of <REDACTED> do not do that again, that poor rock has had enough abuse as it is.",
		"<Experiment 3> Following the events of <Redacted>, It has been observed that abnormalities originating from the black forest demonstrate high levels of aversion to O-04-12-120. Please keep this in mind as a last-resort failsafe should an emergency involving O-02-63 occurs in the main branch."
	)


//	-------------HE-------------
// The Show Goes On
/obj/item/paper/fluff/info/branch12/show_goes_on
	abno_type = /mob/living/simple_animal/hostile/abnormality/show_goes_on
	abno_code = "T-04-12-93"
	abno_info = list(
		"When the work result was not perfect the employee continued working until it was perfect or nearly so.",
		"When the employee was performing the stage prevented damage, death, and interference from external sources.",
		"When the work result was good the employee was healed slightly.",
		"Every time the employee didn’t perform correctly the negative energy damage increased.",
		"When an employee dies in T-04-93 and they haven’t performed perfectly, the dead body will continue producing E until it they completed their work.",
	)

