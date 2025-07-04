// Insurgence Clan Items

/obj/item/paper/fluff/insurgence_instructions
	name = "operational directive"
	info = {"<b>INSURGENCE CLAN OPERATIONAL DIRECTIVE</b><br>
<br>
Brother/Sister,<br>
<br>
You have been chosen to serve the Elder One's will. Your mission is sacred:<br>
<br>
<b>INITIAL PHASE (0-10 minutes):</b><br>
- The Augment Fabricator requires calibration. Use this time to establish connections.<br>
- Build trust. Make friends. Learn who is vulnerable.<br>
- You will be alerted when the fabricator is ready.<br>
<br>
<b>OPERATIONAL PHASE:</b><br>
1. <b>DISTRIBUTE</b> - Use our Augment Fabricator to create modified augments at reduced costs.<br>
2. <b>ISOLATE</b> - Separate targets from groups. Mental Corrosion accelerates in isolation.<br>
3. <b>MONITOR</b> - Track corrosion levels using our monitoring console. 60% is the threshold.<br>
4. <b>GUIDE</b> - When ready, lead them to the Great Lake. They must enter willingly if possible.<br>
<br>
Remember: We are not murderers. We are shepherds guiding lost souls to enlightenment.<br>
The water cleanses. The machine perfects. The Elder One awaits.<br>
<br>
<i>For the Order of the Elder One...</i>"}

/obj/structure/closet/syndicate/insurgence
	name = "insurgence transport equipment locker"
	desc = "Contains supplies for the Insurgence Transport Agents."

/obj/structure/closet/syndicate/insurgence/PopulateContents()
	..()
	new /obj/item/paper/fluff/insurgence_instructions(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/insurgence_transport(src)
	new /obj/item/ego_weapon/city/insurgence_baton(src)
	new /obj/item/ego_weapon/shield/insurgence_shield(src)

/obj/structure/closet/syndicate/insurgence/nightwatch
	name = "insurgence nightwatch equipment locker"
	desc = "Contains supplies for the Insurgence Nightwatch Agents."
	icon_state = "abductor"

/obj/structure/closet/syndicate/insurgence/PopulateContents()
	..()
	new /obj/item/paper/fluff/insurgence_instructions(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/insurgence_nightwatch(src)
	new /obj/item/ego_weapon/city/insurgence_nightwatch(src)
	new /obj/item/storage/box/rxglasses/spyglasskit(src)
	new /obj/item/binoculars(src)
