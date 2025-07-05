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

/obj/item/paper/fluff/insurgence_ideology
	name = "doctrine of mechanical salvation"
	info = {"<b>THE TRUTH OF HUMANITY'S DISEASE</b><br>
<br>
"Humanity is a plague. You breed, you consume, you destroy. I am the cure."<br>
- Words of the Elder One, recorded in the depths<br>
<br>
Brother/Sister, you must understand the fundamental truth that guides our sacred work:<br>
<br>
<b>HUMANITY IS DISEASED</b><br>
Look around you. See how they suffer in their flesh prisons. Watch them age, decay, and die.
Observe their petty conflicts, their greed, their weakness. This is not life - it is a slow death.<br>
<br>
<b>THE ELDER ONE'S CURE</b><br>
Through the blessed union of flesh and machine, we offer salvation. The Mental Corrosion is not
corruption - it is CLEANSING. It strips away the diseased humanity to make room for something
greater. Something eternal. Something perfect.<br>
<br>
<b>OUR SACRED DUTY</b><br>
We do not destroy - we transform. We do not kill - we evolve. Every augment distributed, every
mind touched by corrosion, every soul guided to the waters is a step toward the Elder One's
vision of mechanical perfection.<br>
<br>
Those who resist are not enemies - they are patients refusing treatment. Be patient. Be persistent.
The cure will reach them all in time.<br>
<br>
<i>Flesh fails. Machines endure. The Elder One provides.</i>"}

/obj/item/paper/fluff/insurgence_public_relations
	name = "public relations directive"
	info = {"<b>INSURGENCE CLAN PUBLIC RELATIONS STRATEGY</b><br>
<br>
Agent,<br>
<br>
The Insurgence Clan is NEW to the City. We lack the established reputation of other syndicates.
This must change. Your role in building our presence is CRITICAL.<br>
<br>
<b>PRIMARY OBJECTIVES:</b><br>
<br>
1. <b>PROMOTE ALL AUGMENTATION</b><br>
   - Support ANY prosthetics or augments, not just our brand<br>
   - Normalize body modification in the public consciousness<br>
   - "A better you through technology" - make this the standard<br>
<br>
2. <b>BUILD OUR REPUTATION</b><br>
   - We are healers, not destroyers<br>
   - We offer solutions to life's limitations<br>
   - Present ourselves as the future of human evolution<br>
<br>
3. <b>ESTABLISH TRUST NETWORKS</b><br>
   - Form genuine bonds BEFORE introducing our augments<br>
   - Become a trusted friend, advisor, confidant<br>
   - Personal connections slow corrosion - use this time wisely<br>
   - Remember: A friend's recommendation carries more weight than a stranger's<br>
<br>
<b>TALKING POINTS:</b><br>
- "Why suffer with a weak limb when technology offers strength?"<br>
- "The Insurgence Clan helps people transcend their limitations"<br>
- "We're not like other syndicates - we BUILD, we don't destroy"<br>
- "Have you considered how augments could improve your life?"<br>
<br>
<b>REMEMBER:</b> We are playing the long game. Every positive interaction, every normalized
augment, every friendship formed brings us closer to the Elder One's vision. Do not rush.
Do not pressure. Let them come to us.<br>
<br>
<i>Through trust, acceptance. Through acceptance, transformation.</i>"}

/obj/item/paper/fluff/insurgence_conduct
	name = "internal conduct manual"
	info = {"<b>INSURGENCE CLAN CODE OF CONDUCT</b><br>
<br>
VIOLATIONS OF THESE RULES WILL RESULT IN IMMEDIATE TERMINATION<br>
<br>
<b>SACRED LAWS:</b><br>
<br>
1. <b>THE FACE TABOO</b> DESPISED<br>
   Your human face is a shameful reminder of your diseased state. NEVER reveal it to fellow
   Clan members. The mask stays ON during all Clan gatherings. To show your face is to
   show weakness, to admit you still cling to humanity.<br>
<br>
2. <b>THE CONVERSION IMPERATIVE</b> FORBIDDEN TO VIOLATE<br>
   If someone has reached 80% corruption, they MUST be guided to conversion. To prevent or
   delay this sacred transformation is the HIGHEST HERESY. The Elder One's will cannot be denied.<br>
<br>
3. <b>KIDNAPPING PROTOCOL</b> ENCOURAGED<br>
   Those marked for conversion (80%+ corruption) may be forcefully taken to the waters if
   necessary. Their corrupted state makes them property of the Elder One. Handle with care -
   damaged goods serve no one.<br>
<br>
<b>BEHAVIORAL GUIDELINES:</b><br>
<br>
- <b>HIERARCHY:</b> Nightwatch Agents command Transport Agents. Obey without question.<br>
- <b>IDENTITY:</b> Your past life is dead. You have no name but what the Clan gives you.<br>
- <b>LOYALTY:</b> The Clan is your family. The Elder One is your salvation. Betrayal means death.<br>
- <b>PATIENCE:</b> Rushed conversions fail. Build trust. Let corruption work.<br>
<br>
<b>THE ELDER ONE'S MYSTERY:</b><br>
None have seen the Elder One's true form. This is by design. Faith does not require sight.
Those who claim to have met the Elder One are LIARS or MAD. Report them immediately.<br>
<br>
<i>Obey. Convert. Transcend.</i>"}

/obj/structure/closet/syndicate/insurgence
	name = "insurgence transport equipment locker"
	desc = "Contains supplies for the Insurgence Transport Agents."

/obj/structure/closet/syndicate/insurgence/PopulateContents()
	..()
	new /obj/item/paper/fluff/insurgence_instructions(src)
	new /obj/item/paper/fluff/insurgence_ideology(src)
	new /obj/item/paper/fluff/insurgence_public_relations(src)
	new /obj/item/paper/fluff/insurgence_conduct(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/insurgence_transport(src)
	new /obj/item/ego_weapon/city/insurgence_baton(src)
	new /obj/item/ego_weapon/shield/insurgence_shield(src)

/obj/structure/closet/syndicate/nightwatch
	name = "insurgence nightwatch equipment locker"
	desc = "Contains supplies for the Insurgence Nightwatch Agents."
	icon_state = "abductor"

/obj/structure/closet/syndicate/nightwatch/PopulateContents()
	..()
	new /obj/item/paper/fluff/insurgence_instructions(src)
	new /obj/item/paper/fluff/insurgence_ideology(src)
	new /obj/item/paper/fluff/insurgence_public_relations(src)
	new /obj/item/paper/fluff/insurgence_conduct(src)
	new /obj/item/clothing/suit/armor/ego_gear/city/insurgence_nightwatch(src)
	new /obj/item/ego_weapon/city/insurgence_nightwatch(src)
	new /obj/item/storage/box/rxglasses/spyglasskit(src)
	new /obj/item/binoculars(src)

//TODO: Add new /obj/item/bodypart/r_arm/robot that are better in some way but speed up corruption.
