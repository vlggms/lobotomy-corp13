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
		/obj/item/ego_weapon/city/yun/fist,
		/obj/item/ego_weapon/city/zweihander/streetlight_baton,
		/obj/item/ego_weapon/city/streetlight_bat,
		/obj/item/ego_weapon/city/streetlight_greatsword,
		/obj/item/ego_weapon/city/leaflet/round,
		/obj/item/ego_weapon/city/leaflet/wide,
	)

	rareloot =	list(
		/obj/item/ego_weapon/city/charge/cane/cane,
		/obj/item/ego_weapon/city/charge/cane/claw,
		/obj/item/ego_weapon/city/charge/cane/briefcase,
		/obj/item/ego_weapon/city/charge/cane/fist,
		/obj/item/ego_weapon/city/leaflet/square,
	)

	veryrareloot =	list(
		/obj/item/clothing/suit/armor/ego_gear/city/mirae,
		/obj/item/ego_weapon/city/donghwan,
		/obj/item/ego_weapon/city/mirae,
		/obj/item/ego_weapon/city/mirae/page,
		/obj/item/clothing/suit/armor/ego_gear/city/udjat,
	)

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
		/obj/item/ego_weapon/mimicry/kali,
		/obj/item/ego_weapon/city/reverberation,
		/obj/item/ego_weapon/city/pt/slash,
	)

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
		/obj/item/clothing/suit/armor/ego_gear/city/fullstopleader,
	)

//Rosespanner Workshop. Mostly cheap to actually take advantage of the Gearsystem
/obj/structure/lootcrate/workshoprosespanner
	name = "rosespanner workshop crate"
	desc = "A crate recieved from the rosespanner workshop. Open with a Crowbar."
	icon_state = "crate_rosespanner"
	rarechance = 65	// 30% for gears, 70% everything else
	veryrarechance = 5
	lootlist =	list(
		/obj/item/storage/box/rosespanner,
		/obj/item/storage/box/rosespanner/white,
		/obj/item/storage/box/rosespanner/black,
	)

	rareloot =	list(
		/obj/item/ego_weapon/city/charge/rosespanner/hammer,
		/obj/item/ego_weapon/city/charge/rosespanner/spear,
		/obj/item/ego_weapon/city/charge/rosespanner/minihammer,
		/obj/item/clothing/suit/armor/ego_gear/city/rosespannerrep,
		/obj/item/clothing/suit/armor/ego_gear/city/rosespanner,
	)

	veryrareloot =	list(
		/obj/item/storage/box/rosespanner/pale,
	)
