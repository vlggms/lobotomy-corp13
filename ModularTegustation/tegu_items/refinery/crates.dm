/obj/structure/lootcrate
	name = "Crate"
	desc = "A crate recieved from a company"
	icon = 'ModularTegustation/Teguicons/refiner.dmi'
	icon_state = "crate_lcb"
	anchored = FALSE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/lootlist =	list(
		/obj/item/toy/plush/blank,
		/obj/item/toy/plush/yisang,
		/obj/item/toy/plush/faust,
		/obj/item/toy/plush/don,
		/obj/item/toy/plush/ryoshu,
		/obj/item/toy/plush/meursault,
		/obj/item/toy/plush/honglu,
		/obj/item/toy/plush/heathcliff,
		/obj/item/toy/plush/ishmael,
		/obj/item/toy/plush/rodion,
		/obj/item/toy/plush/sinclair,
		/obj/item/toy/plush/outis,
		/obj/item/toy/plush/gregor,
		/obj/item/toy/plush/yuri)

	var/rareloot =	list(/obj/item/toy/plush/dante,)
	var/veryrareloot =	list()	//Only Kcorp uses these atm, because It's important that they have 3 tiers of weapons
	var/rarechance = 20
	var/veryrarechance


/obj/structure/lootcrate/attackby(obj/item/I, mob/living/user, params)
	..()
	var/loot
	if(I.tool_behaviour != TOOL_CROWBAR)
		return
	if(veryrarechance && prob(veryrarechance))
		loot = pick(veryrareloot)

	else if(prob(rarechance))
		loot = pick(rareloot)

	else
		loot = pick(lootlist)

	to_chat(user, "<span class='notice'>You open the crate!</span>")
	new loot(get_turf(src))
	qdel(src)

//Lobotomy Corporation
/obj/structure/lootcrate/l_corp
	name = "Lobotomy Corporation Gear Crate"
	desc = "A crate recieved from headquarters. Contains standard gear for lobotomy corporation employees. Open with a Crowbar."
	icon_state = "crate_lc"
	rarechance = 10
	lootlist =	list(
		/obj/item/powered_gadget/detector_gadget/abnormality,
		/obj/item/powered_gadget/slowingtrapmk1,
		/obj/item/powered_gadget/clerkbot_gadget,
		/obj/item/powered_gadget/handheld_taser,
		/obj/item/storage/box/minertracker,
		/obj/item/forcefield_projector,
		/obj/item/flashlight/seclite,
		/obj/item/storage/belt/ego,
		/obj/item/safety_kit,
		/obj/item/reagent_containers/hypospray/emais,
		/obj/item/clothing/glasses/meson,
		/obj/item/powered_gadget/vitals_projector,
		/obj/item/powered_gadget/enkephalin_injector,
		)

	//Stuff that LC stocks, but isn't made by LC. Like the R corp Ordeal finder and W-Corp hand tele.
	//Lore reasons tm
	rareloot =	list(
		/obj/item/powered_gadget/detector_gadget/ordeal,
		/obj/item/managerbullet,
		/obj/item/powered_gadget/teleporter,
		/obj/item/tool_extractor)



//Limbus Company
/obj/structure/lootcrate/limbus
	name = "Limbus Company Crate"
	desc = "A crate recieved from limbus company. Open with a Crowbar."
	icon_state = "crate_lcb"
	rarechance = 10
	lootlist =	list(
		/obj/item/ego_weapon/mini/hayong,
		/obj/item/ego_weapon/shield/walpurgisnacht,
		/obj/item/ego_weapon/lance/suenoimpossible,
		/obj/item/ego_weapon/shield/sangria,
		/obj/item/ego_weapon/mini/soleil,
		/obj/item/ego_weapon/taixuhuanjing,
		/obj/item/ego_weapon/revenge,
		/obj/item/ego_weapon/shield/hearse,
		/obj/item/ego_weapon/mini/hearse,
		/obj/item/ego_weapon/raskolot,
		/obj/item/ego_weapon/vogel,
		/obj/item/ego_weapon/nobody,
		/obj/item/ego_weapon/ungezifer,
		/obj/item/clothing/suit/armor/ego_gear/limbus/limbus_coat,
		/obj/item/clothing/suit/armor/ego_gear/limbus/limbus_coat_short,
		/obj/item/clothing/under/limbus/shirt,
		/obj/item/clothing/accessory/limbusvest,
		/obj/item/clothing/under/limbus/prison,
		/obj/item/clothing/neck/limbus_tie)

	rareloot =	list(/obj/item/clothing/suit/armor/ego_gear/limbus/durante,
		/obj/item/ego_weapon/lance/sangre,
		/obj/item/clothing/suit/armor/ego_gear/limbus/ego/minos,
		/obj/item/clothing/suit/armor/ego_gear/limbus/ego/cast,
		/obj/item/clothing/suit/armor/ego_gear/limbus/ego/branch)


//K Corporation
/obj/structure/lootcrate/k_corp
	name = "K Corp Crate"
	desc = "A crate recieved from K-Corp. Open with a Crowbar."
	icon_state = "crate_kcorp"
	rarechance = 30
	veryrarechance = 5
	lootlist =	list(
		/obj/item/managerbullet,
		/obj/item/ksyringe)

	rareloot =	list(
		/obj/item/ego_weapon/city/kcorp,
		/obj/item/ego_weapon/shield/kcorp,
		/obj/item/ego_weapon/city/kcorp/axe,
		/obj/item/gun/ego_gun/pistol/kcorp,)

	veryrareloot =	list(/obj/item/clothing/under/rank/k_corporation/intern,
		/obj/item/ego_weapon/city/kcorp/spear,
		/obj/item/ego_weapon/city/kcorp/dspear,
		/obj/item/gun/ego_gun/pistol/kcorp/smg,
		/obj/item/gun/ego_gun/pistol/kcorp/nade,
		/obj/item/clothing/suit/armor/ego_gear/city/kcorp,
		/obj/item/toy/plush/bongy,
		)


//R Corporation
/obj/structure/lootcrate/r_corp
	name = "R Corp Crate"
	desc = "A crate recieved from R-Corp. Open with a Crowbar."
	icon_state = "crate_rcorp"
	veryrarechance = 5
	lootlist =	list(
		/obj/item/clothing/under/suit/lobotomy/rabbit,
		/obj/item/powered_gadget/detector_gadget/ordeal,
		/obj/item/toy/plush/myo,
		/obj/item/toy/plush/rabbit,
		/obj/item/clothing/suit/space/hardsuit/rabbit,
		/obj/item/clothing/suit/space/hardsuit/rabbit/leader,
		/obj/item/gun/energy/e_gun/rabbitdash,
		/obj/item/ego_weapon/city/rabbit_rush,
		/obj/item/clothing/under/suit/lobotomy/rcorp_command
		)

	rareloot =	list(
		/obj/item/ego_weapon/city/rabbit_blade,
		/obj/item/ego_weapon/city/reindeer,
		/obj/item/clothing/head/beret/tegu/rcorp,
		/obj/item/clothing/neck/cloak/rcorp)

	veryrareloot =	list(/obj/item/ego_weapon/city/rabbit_blade/command,
		/obj/item/ego_weapon/city/reindeer/captain,
	)

//S Corporation
/obj/structure/lootcrate/s_corp
	name = "S Corp Crate"
	desc = "A crate recieved from the mysterious S-Corp. Open with a Crowbar."
	icon_state = "crate_shrimp"
	lootlist =	list(
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_red,
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_white,
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_purple,
		/obj/item/gun/ego_gun/sodashotty,
		/obj/item/gun/ego_gun/sodarifle,
		/obj/item/gun/ego_gun/sodasmg,
		/obj/item/gun/ego_gun/shrimp/assault,
		)

	rareloot =	list(
		/obj/item/gun/ego_gun/shrimp/minigun,
		/mob/living/simple_animal/hostile/shrimp,
		/obj/item/grenade/spawnergrenade/shrimp)


//W Corporation
/obj/structure/lootcrate/w_corp
	name = "W Corp Crate"
	desc = "A crate recieved from W-Corp. Open with a Crowbar."
	icon_state = "crate_wcorp"
	lootlist =	list(
		/obj/item/ego_weapon/city/wcorp,
		/obj/item/clothing/head/wcorp,
		/obj/item/clothing/under/suit/lobotomy/wcorp,
		/obj/item/clothing/suit/armor/ego_gear/wcorp,
		/obj/item/powered_gadget/teleporter)

	rareloot =	list(/obj/item/ego_weapon/city/wcorp/fist,
		/obj/item/ego_weapon/city/wcorp/axe,
		/obj/item/ego_weapon/city/wcorp/spear,
		/obj/item/ego_weapon/city/wcorp/dagger,
		/obj/item/ego_weapon/city/wcorp/hammer,
		/obj/item/ego_weapon/city/wcorp/hatchet,
		)


//N Corporation
/obj/structure/lootcrate/n_corp
	name = "N Corp Crate"
	desc = "A crate recieved from N-Corp. Open with a Crowbar."
	icon_state = "crate_ncorp"
	veryrarechance = 5
	lootlist =	list(
		/obj/item/ego_weapon/city/ncorp_mark,
		/obj/item/ego_weapon/city/ncorp_mark/white,
		/obj/item/ego_weapon/city/ncorp_mark/black,
		)

	rareloot =	list(
		/obj/item/ego_weapon/city/ncorp_mark/pale,
		/obj/item/ego_weapon/city/ncorp_nail,
		/obj/item/ego_weapon/city/ncorp_hammer,
		/obj/item/ego_weapon/city/ncorp_nail/big,
		/obj/item/ego_weapon/city/ncorp_hammer/big,
		/obj/item/clothing/suit/armor/ego_gear/city/ncorp,
		/obj/item/clothing/suit/armor/ego_gear/city/ncorp/vet
		)

	veryrareloot =	list(
		/obj/item/ego_weapon/city/ncorp_hammer/grippy,
		/obj/item/ego_weapon/city/ncorp_nail/grip,
		/obj/item/ego_weapon/city/ncorp_nail/huge,
		/obj/item/clothing/suit/armor/ego_gear/city/ncorpcommander)


//First set of city stuff. Cane, Streetlight, Yun office, Leaflet, The Udjat and Mirae Life Insurance, as well as generic Grade 1 fixers.
/obj/structure/lootcrate/workshopleaf
	name = "leaflet workshop crate"
	desc = "A crate recieved from the city workshop. Open with a Crowbar."
	icon_state = "crate_leaf"
	rarechance = 30
	veryrarechance = 5
	lootlist =	list(
		/obj/item/ego_weapon/city/yun,
		/obj/item/ego_weapon/city/yun/shortsword,
		/obj/item/ego_weapon/city/yun/chainsaw,
		/obj/item/ego_weapon/city/zweihander/streetlight_baton,
		/obj/item/ego_weapon/city/streetlight_bat,
		/obj/item/ego_weapon/city/streetlight_greatsword,
		/obj/item/ego_weapon/city/leaflet/round,
		/obj/item/ego_weapon/city/leaflet/wide
		)

	rareloot =	list(
		/obj/item/ego_weapon/city/cane/cane,
		/obj/item/ego_weapon/city/cane/claw,
		/obj/item/ego_weapon/city/cane/briefcase,
		/obj/item/ego_weapon/city/cane/fist,
		/obj/item/ego_weapon/city/leaflet/square,
		)

	veryrareloot =	list(
		/obj/item/clothing/suit/armor/ego_gear/city/mirae,
		/obj/item/ego_weapon/city/donghwan,
		/obj/item/ego_weapon/city/mirae,
		/obj/item/ego_weapon/city/mirae/page,
		/obj/item/clothing/suit/armor/ego_gear/city/udjat,)

//Includes Molar, Hook Office, Misc fixers, Gaze Office and Jeong's Office, as well as color fixers
/obj/structure/lootcrate/workshopallas
	name = "allas workshop crate"
	desc = "A crate recieved from the city workshop. Open with a Crowbar."
	icon_state = "crate_allas"
	rarechance = 20
	veryrarechance = 1
	lootlist =	list(
		/obj/item/ego_weapon/city/fixerblade,
		/obj/item/ego_weapon/city/fixergreatsword,
		/obj/item/ego_weapon/city/fixerhammer,
		/obj/item/clothing/suit/armor/ego_gear/city/misc,
		/obj/item/clothing/suit/armor/ego_gear/city/misc/second,
		/obj/item/ego_weapon/city/yun/fist,
		/obj/item/ego_weapon/city/jeong,

		)

	rareloot =	list(
		/obj/item/ego_weapon/city/jeong/large,
		/obj/item/ego_weapon/city/molar,
		/obj/item/ego_weapon/city/molar/olga,
		)

	veryrareloot =	list(
		/obj/item/clothing/suit/armor/ego_gear/city/blue_reverb,
		/obj/item/ego_weapon/black_silence_gloves,
		/obj/item/ego_weapon/city/vermillion,
		/obj/item/ego_weapon/mimicry/kali)


//Zelkova Workshop is the last one, Includes Dawn office, Wedge Office and Fullstop.
//Basically this is the low-level Fixers on Ecorp
/obj/structure/lootcrate/workshopzelkova
	name = "zelkova workshop crate"
	desc = "A crate recieved from the city workshop. Open with a Crowbar."
	icon_state = "crate_zelkova"
	veryrarechance = 20	//20% chance for rare stuff
	rarechance = 50	//40% chance for weapons, rest is on armor.
	lootlist =	list(
		/obj/item/ego_weapon/city/dawn/sword,
		/obj/item/ego_weapon/city/dawn/cello,
		/obj/item/ego_weapon/city/wedge,
		/obj/item/gun/ego_gun/city/fullstop/assault,
		/obj/item/gun/ego_gun/city/fullstop/sniper,
		/obj/item/gun/ego_gun/city/fullstop/pistol,
		)

	rareloot =	list(
		/obj/item/clothing/suit/armor/ego_gear/city/fullstop,
		/obj/item/clothing/suit/armor/ego_gear/city/fullstop/sniper,
		/obj/item/clothing/suit/armor/ego_gear/city/wedge,
		/obj/item/clothing/suit/armor/ego_gear/city/wedge/female,
		/obj/item/clothing/suit/armor/ego_gear/city/dawn,
		/obj/item/clothing/suit/armor/ego_gear/city/dawn/vet,
		/obj/item/clothing/suit/armor/ego_gear/city/dawn/female,
		)

	veryrareloot =	list(
		/obj/item/ego_weapon/city/dawn/zwei,
		/obj/item/gun/ego_gun/city/fullstop/deagle,
		/obj/item/clothing/suit/armor/ego_gear/city/dawnleader,
		/obj/item/clothing/suit/armor/ego_gear/city/wedgeleader,
		/obj/item/clothing/suit/armor/ego_gear/city/fullstopleader,)

//Rosespanner Workshop. Mostly cheap to actually take advantage of the Gearsystem
/obj/structure/lootcrate/workshoprosespanner
	name = "rosespanner workshop crate"
	desc = "A crate recieved from the rosespanner workshop. Open with a Crowbar."
	icon_state = "crate_rosespanner"
	lootlist =	list(
		/obj/item/rosespanner_gear,
		/obj/item/rosespanner_gear/white,
		/obj/item/rosespanner_gear/black,
	)

	rareloot =	list(
		/obj/item/ego_weapon/city/rosespanner/hammer,
		/obj/item/ego_weapon/city/rosespanner/spear,
		/obj/item/ego_weapon/city/rosespanner/minihammer,
		/obj/item/clothing/suit/armor/ego_gear/city/rosespannerrep,
		/obj/item/clothing/suit/armor/ego_gear/city/rosespanner,
		/obj/item/rosespanner_gear/pale
		)

//Hana - ALL Associations, Hana gear at a 10%
/obj/structure/lootcrate/hana
	name = "Hana Association Crate"
	desc = "A crate recieved from the hana association. Contains a variety of Association gear. Open with a Crowbar."
	icon_state = "crate_hana"
	rarechance = 30
	veryrarechance = 10
	lootlist =	list(
		/obj/item/clothing/suit/armor/ego_gear/city/zweijunior,
		/obj/item/ego_weapon/city/zweihander,
		/obj/item/ego_weapon/city/zweihander/knife,
		/obj/item/clothing/suit/armor/ego_gear/city/zwei,
		/obj/item/clothing/suit/armor/ego_gear/city/zweiriot,
		/obj/item/ego_weapon/city/zweibaton,
		/obj/item/ego_weapon/city/shi_assassin,
		/obj/item/ego_weapon/city/shi_knife,
		/obj/item/clothing/suit/armor/ego_gear/city/shi,
		/obj/item/clothing/suit/armor/ego_gear/city/shilimbus,
		/obj/item/ego_weapon/city/seven,
		/obj/item/ego_weapon/city/seven_fencing,
		/obj/item/ego_weapon/city/liu/fire,
		/obj/item/clothing/suit/armor/ego_gear/city/seven,
		/obj/item/clothing/suit/armor/ego_gear/city/sevenrecon,
		/obj/item/clothing/suit/armor/ego_gear/city/liu,
		/obj/item/clothing/suit/armor/ego_gear/city/liu/section5,
		/obj/item/ego_weapon/city/liu/fist,
		)

	rareloot =	list(
		/obj/item/ego_weapon/city/zweihander/vet,
		/obj/item/clothing/suit/armor/ego_gear/city/zweivet,
		/obj/item/ego_weapon/city/shi_assassin/sakura,
		/obj/item/ego_weapon/city/shi_assassin/serpent,
		/obj/item/ego_weapon/city/shi_assassin/vet,
		/obj/item/ego_weapon/city/shi_assassin/director,
		/obj/item/clothing/suit/armor/ego_gear/city/shi/vet,
		/obj/item/clothing/suit/armor/ego_gear/city/shilimbus/vet,
		/obj/item/ego_weapon/city/seven/vet,
		/obj/item/ego_weapon/city/seven_fencing/vet,
		/obj/item/clothing/suit/armor/ego_gear/city/sevenvet,
		/obj/item/clothing/suit/armor/ego_gear/city/sevenvet/intel,
		/obj/item/ego_weapon/city/liu/fire/fist,
		/obj/item/ego_weapon/city/liu/fire/spear,
		/obj/item/clothing/suit/armor/ego_gear/city/liuvet,
		/obj/item/clothing/suit/armor/ego_gear/city/liuvet/section2,
		/obj/item/clothing/suit/armor/ego_gear/city/liuvet/section5,
		/obj/item/ego_weapon/city/liu/fist/vet,
		)

	veryrareloot =	list(
		/obj/item/ego_weapon/city/hana,
		/obj/item/clothing/suit/armor/ego_gear/city/hana,
		/obj/item/clothing/suit/armor/ego_gear/city/hanacombat,
		/obj/item/clothing/suit/armor/ego_gear/city/hanacombat/paperwork,
		/obj/item/clothing/suit/armor/ego_gear/city/hanadirector,
	)

//Zwei - Zwei Association
/obj/structure/lootcrate/zwei
	name = "Zwei Association Crate"
	desc = "A crate recieved from the zwei association. Open with a Crowbar."
	icon_state = "crate_zwei"
	rarechance = 30
	lootlist =	list(
		/obj/item/clothing/suit/armor/ego_gear/city/zweijunior,
		/obj/item/ego_weapon/city/zweihander,
		/obj/item/ego_weapon/city/zweihander/knife,
		/obj/item/clothing/suit/armor/ego_gear/city/zwei,
		/obj/item/clothing/suit/armor/ego_gear/city/zweiriot,
		/obj/item/ego_weapon/city/zweibaton,)

	rareloot =	list(
		/obj/item/ego_weapon/city/zweihander/vet,
		/obj/item/clothing/suit/armor/ego_gear/city/zweivet,
		/obj/item/clothing/suit/armor/ego_gear/city/zweileader)

//Tres - Tres Association (Not really accessible)
/obj/structure/lootcrate/tres
	name = "Tres Association Crate"
	desc = "A crate recieved from the tres association. Open with a Crowbar."
	icon_state = "crate_tres"
	rarechance = 40
	veryrarechance = 10
	lootlist =	list(/obj/item/tresmetal)

	rareloot =	list(
	/obj/item/workshop_mod/regular/red,
	/obj/item/workshop_mod/regular/white,
	/obj/item/workshop_mod/regular/black,
	/obj/item/workshop_mod/fast/red,
	/obj/item/workshop_mod/fast/white,
	/obj/item/workshop_mod/fast/black,
	/obj/item/workshop_mod/slow/red,
	/obj/item/workshop_mod/slow/white,
	/obj/item/workshop_mod/slow/black,
	/obj/item/workshop_mod/throwforce/red,
	/obj/item/workshop_mod/throwforce/white,
	/obj/item/workshop_mod/throwforce/black,
		)

	veryrareloot =	list(
	/obj/item/workshop_mod/regular/pale,
	/obj/item/workshop_mod/fast/pale,
	/obj/item/workshop_mod/slow/pale,
	/obj/item/workshop_mod/throwforce/pale,
	/obj/item/workshop_mod/healing/red,
	/obj/item/workshop_mod/healing/white,
	/obj/item/workshop_mod/healing/black,
	/obj/item/workshop_mod/healing/pale,
	/obj/item/workshop_mod/sapping/red,
	/obj/item/workshop_mod/sapping/white,
	/obj/item/workshop_mod/sapping/black,
	/obj/item/workshop_mod/sapping/pale,
	)


//Shi - Shi Association
/obj/structure/lootcrate/shi
	name = "Shi Association Crate"
	desc = "A crate recieved from the shi association. Open with a Crowbar."
	icon_state = "crate_shi"
	lootlist =	list(
		/obj/item/ego_weapon/city/shi_assassin,
		/obj/item/ego_weapon/city/shi_knife,
		/obj/item/clothing/suit/armor/ego_gear/city/shi,
		/obj/item/clothing/suit/armor/ego_gear/city/shilimbus,

		)

	rareloot =	list(
		/obj/item/ego_weapon/city/shi_assassin/yokai,
		/obj/item/ego_weapon/city/shi_assassin/sakura,
		/obj/item/ego_weapon/city/shi_assassin/serpent,
		/obj/item/ego_weapon/city/shi_assassin/vet,
		/obj/item/ego_weapon/city/shi_assassin/director,
		/obj/item/clothing/suit/armor/ego_gear/city/shi/vet,
		/obj/item/clothing/suit/armor/ego_gear/city/shi/director,
		/obj/item/clothing/suit/armor/ego_gear/city/shilimbus/vet,
		/obj/item/clothing/suit/armor/ego_gear/city/shilimbus/director,
		)

//Liu - Liu Association
/obj/structure/lootcrate/liu
	name = "Liu Association Crate"
	desc = "A crate recieved from the liu association. Open with a Crowbar."
	icon_state = "crate_liu"
	lootlist =	list(
		/obj/item/clothing/suit/armor/ego_gear/city/liu,
		/obj/item/clothing/suit/armor/ego_gear/city/liu/section5,
		/obj/item/ego_weapon/city/liu/fire,
		/obj/item/ego_weapon/city/liu/fist,
		)

	rareloot =	list(
		/obj/item/ego_weapon/city/liu/fist/vet,
		/obj/item/ego_weapon/city/liu/fire/fist,
		/obj/item/ego_weapon/city/liu/fire/spear,
		/obj/item/ego_weapon/city/liu/fire/sword,
		/obj/item/clothing/suit/armor/ego_gear/city/liuvet,
		/obj/item/clothing/suit/armor/ego_gear/city/liuvet/section2,
		/obj/item/clothing/suit/armor/ego_gear/city/liuvet/section5,
		/obj/item/clothing/suit/armor/ego_gear/city/liuleader,
		/obj/item/clothing/suit/armor/ego_gear/city/liuleader/section5,
		)



//Seven - Seven and its associates
/obj/structure/lootcrate/seven
	name = "Seven Association Crate"
	desc = "A crate recieved from seven association. Open with a Crowbar."
	icon_state = "crate_seven"
	rarechance = 30
	veryrarechance = 10
	lootlist =	list(
		/obj/item/ego_weapon/city/seven,
		/obj/item/ego_weapon/city/seven_fencing,
		/obj/item/clothing/suit/armor/ego_gear/city/seven,
		/obj/item/clothing/suit/armor/ego_gear/city/sevenrecon,
		/obj/item/binoculars,
		)

	rareloot =	list(
		/obj/item/ego_weapon/city/seven/vet,
		/obj/item/ego_weapon/city/seven_fencing/vet,
		/obj/item/clothing/suit/armor/ego_gear/city/sevenvet,
		/obj/item/clothing/suit/armor/ego_gear/city/sevenvet/intel,
		)

	veryrareloot =	list(
		/obj/item/clothing/suit/armor/ego_gear/city/sevendirector,
		/obj/item/ego_weapon/city/seven/director,
		/obj/item/ego_weapon/city/seven/cane,
		/obj/item/ego_weapon/city/seven_fencing/dagger)

//Syndicate Stuff, Very expensive, but all round pretty good. Mostly finger-related stuff
/obj/structure/lootcrate/syndicate
	name = "syndicate workshop crate"
	desc = "A crate recieved from the syndicate. Open with a Crowbar."
	icon_state = "crate_syndicate"
	rarechance = 30
	veryrarechance = 5
	lootlist =	list(
		/obj/item/ego_weapon/city/mariachi,
		/obj/item/ego_weapon/city/mariachi/dual,
		/obj/item/clothing/suit/armor/ego_gear/city/blade_lineage,
		/obj/item/gun/ego_gun/city/thumb,
	)

	rareloot =	list(
		/obj/item/ego_weapon/city/index,
		/obj/item/ego_weapon/city/awl,
		/obj/item/ego_weapon/city/kurokumo,
		/obj/item/ego_weapon/city/bladelineage,
		/obj/item/clothing/suit/armor/ego_gear/city/blade_lineage_salsu,
		/obj/item/gun/ego_gun/city/thumb/capo,
		/obj/item/ego_weapon/city/thumbmelee,
		)

	veryrareloot =	list(
		/obj/item/clothing/suit/armor/ego_gear/city/blade_lineage_admin,
		/obj/item/ego_weapon/city/index/proxy,
		/obj/item/ego_weapon/city/index/proxy/spear,
		/obj/item/ego_weapon/city/index/yan,
		/obj/item/gun/ego_gun/city/thumb/sottocapo,
		/obj/item/ego_weapon/city/thumbcane,
		)


//Backstreets stuff, mostly cheap and also quite good. Mostly non-fingers related villain stuff.
/obj/structure/lootcrate/backstreets
	name = "backstreet workshop crate"
	desc = "A crate recieved from the backstreet workshop. Open with a Crowbar."
	icon_state = "crate_backstreets"
	rarechance = 30
	veryrarechance = 10
	lootlist =	list(
		/obj/item/ego_weapon/city/rats,
		/obj/item/ego_weapon/city/rats/knife,
		/obj/item/ego_weapon/city/rats/scalpel,
		/obj/item/ego_weapon/city/rats/brick,
		/obj/item/ego_weapon/city/rats/pipe,
		/obj/item/ego_weapon/city/axegang,
	)

	rareloot =	list(
		/obj/item/ego_weapon/city/sweeper,
		/obj/item/ego_weapon/city/axegang/leader,
		/obj/item/ego_weapon/city/district23,
		/obj/item/ego_weapon/city/district23/pierre,)

	veryrareloot =	list(
		/obj/item/ego_weapon/city/sweeper/hooksword,
		/obj/item/ego_weapon/city/sweeper/sickle,
		/obj/item/ego_weapon/city/sweeper/claw,
		)


