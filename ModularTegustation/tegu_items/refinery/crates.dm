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
		/datum/status_effect/visualize_vitals,
		)

	//Stuff that LC stocks, but isn't made by LC. Like the R corp Ordeal finder and W-Corp hand tele. Also includes things like the
	//Lore reasons tm
	rareloot =	list(
		/obj/item/powered_gadget/detector_gadget/ordeal,
		/obj/item/managerbullet,
		/obj/item/powered_gadget/teleporter)



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
		/obj/item/managerbullet)

	rareloot =	list(
		/obj/item/ego_weapon/city/kcorp,
		/obj/item/ego_weapon/shield/kcorp,
		/obj/item/gun/ego_gun/pistol/kcorp)

	veryrareloot =	list(/obj/item/clothing/under/rank/k_corporation/intern,
		/obj/item/ego_weapon/city/kcorp/spear,
		/obj/item/ego_weapon/city/kcorp/dspear,
		/obj/item/gun/ego_gun/pistol/kcorp/smg,
		/obj/item/gun/ego_gun/pistol/kcorp/nade,
		/obj/item/clothing/suit/armor/ego_gear/city/kcorp,
		/obj/item/toy/plush/bongy
		)


//R Corporation
/obj/structure/lootcrate/r_corp
	name = "R Corp Crate"
	desc = "A crate recieved from R-Corp. Open with a Crowbar."
	icon_state = "crate_rcorp"
	lootlist =	list(
		/obj/item/clothing/under/suit/lobotomy/rabbit,
		/obj/item/powered_gadget/detector_gadget/ordeal,
		/obj/item/toy/plush/myo,
		/obj/item/toy/plush/rabbit,
		/obj/item/clothing/suit/space/hardsuit/rabbit,
		/obj/item/clothing/suit/space/hardsuit/rabbit/leader
		)

	rareloot =	list(
		/obj/item/ego_weapon/rabbit_blade)


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
		/obj/item/ego_weapon/city/ncorp_nail,
		/obj/item/ego_weapon/city/ncorp_hammer
		)

	rareloot =	list(
		/obj/item/ego_weapon/city/ncorp_mark/pale,
		/obj/item/ego_weapon/city/ncorp_nail/big,
		/obj/item/ego_weapon/city/ncorp_hammer/big
		)

	veryrareloot =	list(
		/obj/item/ego_weapon/city/ncorp_hammer/grippy,
		/obj/item/ego_weapon/city/ncorp_nail/grip,
		/obj/item/ego_weapon/city/ncorp_nail/huge,
		/obj/item/clothing/suit/armor/ego_gear/city/ncorpcommander)


//First set of city stuff. Cane, Streetlight, Wedge, Rats, Leaflet, The Udjat and Mirae Life Insurance
/obj/structure/lootcrate/workshopleaf
	name = "leaflet workshop crate"
	desc = "A crate recieved from the city workshop. Open with a Crowbar."
	icon_state = "crate_leaf"
	rarechance = 30
	veryrarechance = 5
	lootlist =	list(
		/obj/item/ego_weapon/city/rats,
		/obj/item/ego_weapon/city/rats/knife,
		/obj/item/ego_weapon/city/rats/scalpel,
		/obj/item/clothing/suit/armor/ego_gear/city/wedge,
		/obj/item/clothing/suit/armor/ego_gear/city/wedge/female,
		/obj/item/ego_weapon/city/zweihander/streetlight_baton,
		/obj/item/ego_weapon/city/streetlight_bat,
		/obj/item/ego_weapon/city/streetlight_greatsword
		)

	rareloot =	list(
		/obj/item/ego_weapon/city/wedge,
		/obj/item/clothing/suit/armor/ego_gear/city/wedgeleader,
		/obj/item/ego_weapon/city/cane/cane,
		/obj/item/ego_weapon/city/cane/claw,
		/obj/item/ego_weapon/city/cane/briefcase,
		/obj/item/ego_weapon/city/cane/fist,
		)

	veryrareloot =	list(
		/obj/item/clothing/suit/armor/ego_gear/city/mirae,
		/obj/item/clothing/suit/armor/ego_gear/city/udjat)

//Includes Yun office, Molar, Hook Office, Full Stop, as well as color fixers
/obj/structure/lootcrate/workshopallas
	name = "allas workshop crate"
	desc = "A crate recieved from the city workshop. Open with a Crowbar."
	icon_state = "crate_allas"
	rarechance = 20
	lootlist =	list(
		/obj/item/ego_weapon/city/yun,
		/obj/item/ego_weapon/city/yun/shortsword,
		/obj/item/ego_weapon/city/yun/chainsaw,
		/obj/item/clothing/suit/armor/ego_gear/city/fullstop,
		/obj/item/clothing/suit/armor/ego_gear/city/fullstop/sniper,
		/obj/item/gun/ego_gun/city/fullstop/assault,
		/obj/item/gun/ego_gun/city/fullstop/sniper
		)

	rareloot =	list(
		/obj/item/clothing/suit/armor/ego_gear/city/fullstopleader,
		/obj/item/gun/ego_gun/city/fullstop/deagle,
		/obj/item/ego_weapon/city/molar,
		/obj/item/ego_weapon/city/molar/olga,
		)


//Zelkova Workshop is the last one, Includes Dawn office, Misc fixers, Gaze Office and Jeong's Office.
/obj/structure/lootcrate/workshopzelkova
	name = "zelkova workshop crate"
	desc = "A crate recieved from the city workshop. Open with a Crowbar."
	icon_state = "crate_zelkova"
	rarechance = 20
	lootlist =	list(
		/obj/item/ego_weapon/city/fixerblade,
		/obj/item/ego_weapon/city/jeong,
		/obj/item/ego_weapon/city/dawn/sword,
		/obj/item/ego_weapon/city/dawn/cello,
		/obj/item/clothing/suit/armor/ego_gear/city/dawn,
		/obj/item/clothing/suit/armor/ego_gear/city/dawn/vet,
		/obj/item/clothing/suit/armor/ego_gear/city/dawn/female
		)

	rareloot =	list(
		/obj/item/ego_weapon/city/jeong/large,
		/obj/item/ego_weapon/city/dawn/zwei,
		/obj/item/clothing/suit/armor/ego_gear/city/dawnleader,
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
		/obj/item/clothing/suit/armor/ego_gear/city/zwei,
		/obj/item/clothing/suit/armor/ego_gear/city/zweiriot,
		/obj/item/ego_weapon/city/zweibaton,)

	rareloot =	list(
		/obj/item/ego_weapon/city/zweihander/vet,
		/obj/item/clothing/suit/armor/ego_gear/city/zweivet,
		/obj/item/clothing/suit/armor/ego_gear/city/zweileader)

//Seven - Seven and its associates
/obj/structure/lootcrate/seven
	name = "Seven Association Crate"
	desc = "A crate recieved from seven association. Open with a Crowbar."
	icon_state = "crate_seven"
	rarechance = 30
	veryrarechance = 10
	lootlist =	list(
		/obj/item/ego_weapon/city/seven,
		/obj/item/clothing/suit/armor/ego_gear/city/seven,
		/obj/item/clothing/suit/armor/ego_gear/city/sevenrecon,
		/obj/item/binoculars,
		)

	rareloot =	list(
		/obj/item/ego_weapon/city/seven/vet,
		/obj/item/clothing/suit/armor/ego_gear/city/sevenvet,
		/obj/item/clothing/suit/armor/ego_gear/city/sevenvet/intel
		)

	veryrareloot =	list(
		/obj/item/clothing/suit/armor/ego_gear/city/sevendirector,
		/obj/item/ego_weapon/city/seven/director,
		/obj/item/ego_weapon/city/seven/cane)

//Syndicate Stuff, Very expensive, but all round pretty good
/obj/structure/lootcrate/syndicate
	name = "syndicate workshop crate"
	desc = "A crate recieved from the syndicate. Open with a Crowbar."
	icon_state = "crate_syndicate"
	rarechance = 30
	veryrarechance = 5
	lootlist =	list(
		/obj/item/ego_weapon/city/district23,
		/obj/item/ego_weapon/city/district23/pierre,
		/obj/item/clothing/suit/armor/ego_gear/city/blade_lineage
	)

	rareloot =	list(
		/obj/item/ego_weapon/city/index,
		/obj/item/ego_weapon/city/awl,
		/obj/item/ego_weapon/city/kurokumo,
		/obj/item/ego_weapon/city/bladelineage,
		/obj/item/clothing/suit/armor/ego_gear/city/blade_lineage_salsu,
		)

	veryrareloot =	list(
		/obj/item/ego_weapon/city/index/proxy,
		/obj/item/clothing/suit/armor/ego_gear/city/blade_lineage_admin,
		/obj/item/ego_weapon/city/index/yan)
