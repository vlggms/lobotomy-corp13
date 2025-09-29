//Lobotomy Corporation
/obj/structure/lootcrate/l_corp
	name = "Lobotomy Corporation Gear Crate"
	desc = "A crate recieved from headquarters. Contains standard gear for lobotomy corporation employees. Open with a Crowbar."
	icon_state = "crate_lc"
	rarechance = 25
	veryrarechance = 10
	lootlist =	list(
		/obj/item/powered_gadget/detector_gadget/abnormality,
		/obj/item/powered_gadget/slowingtrapmk1,
		/obj/item/clerkbot_gadget,
		/obj/item/powered_gadget/handheld_taser,
		/obj/item/forcefield_projector,
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
	)

	//Injectors and rare extractors, quite desireable as they are quite expensive.
	veryrareloot =	list(
		/obj/item/trait_injector/agent_workchance_trait_injector,
		/obj/item/trait_injector/clerk_fear_immunity_injector,
		/obj/item/ego_gift_extractor,
	)

//K Corporation
/obj/structure/lootcrate/k_corp
	name = "K Corp Crate"
	desc = "A crate recieved from K-Corp. Open with a Crowbar."
	icon_state = "crate_kcorp"
	rarechance = 30
	veryrarechance = 10
	cosmeticchance = 5
	lootlist =	list(
		/obj/item/managerbullet,
		/obj/item/reagent_containers/hypospray/medipen/safety/kcorp
	)

	rareloot =	list(
		/obj/item/ego_weapon/city/kcorp,
		/obj/item/ego_weapon/shield/kcorp,
		/obj/item/ego_weapon/city/kcorp/axe,
		/obj/item/ego_weapon/ranged/pistol/kcorp,
		/obj/item/storage/box/kcorp_armor,
	)

	veryrareloot =	list(
		/obj/item/ego_weapon/city/kcorp/spear,
		/obj/item/ego_weapon/city/kcorp/dspear,
		/obj/item/ego_weapon/ranged/pistol/kcorp/smg,
		/obj/item/ego_weapon/ranged/pistol/kcorp/nade,
		/obj/item/clothing/suit/armor/ego_gear/city/kcorp_l3,
		/obj/item/toy/plush/bongy,
	)

	cosmeticloot = list(
		/obj/item/toy/plush/bongy,
		/obj/item/clothing/suit/armor/ego_gear/city/kcorp_sci,
	)
//N Corporation
/obj/structure/lootcrate/n_corp
	name = "N Corp Crate"
	desc = "A crate recieved from N-Corp. Open with a Crowbar."
	icon_state = "crate_ncorp"
	rarechance = 65 // 30% seals, 70% everything else
	veryrarechance = 5
	lootlist =	list(
		/obj/item/storage/box/ncorp_seals,
		/obj/item/storage/box/ncorp_seals/white,
		/obj/item/storage/box/ncorp_seals/black,
	)

	rareloot =	list(
		/obj/item/ego_weapon/city/ncorp_nail,
		/obj/item/ego_weapon/city/ncorp_nail/big,
		/obj/item/ego_weapon/city/ncorp_brassnail,
		/obj/item/ego_weapon/city/ncorp_brassnail/big,
		/obj/item/ego_weapon/city/ncorp_hammer,
		/obj/item/ego_weapon/city/ncorp_hammer/big,
		/obj/item/clothing/suit/armor/ego_gear/city/ncorp,
		/obj/item/clothing/suit/armor/ego_gear/city/ncorp/vet,
	)

	veryrareloot =	list(
		/obj/item/storage/box/ncorp_seals/pale,
		/obj/item/ego_weapon/city/ncorp_hammer/hand,
		/obj/item/ego_weapon/city/ncorp_hammer/grippy,
		/obj/item/ego_weapon/city/ncorp_nail/huge,
		/obj/item/ego_weapon/city/ncorp_nail/grip,
		/obj/item/ego_weapon/city/ncorp_brassnail/huge,
		/obj/item/ego_weapon/city/ncorp_brassnail/rose,
		/obj/item/clothing/suit/armor/ego_gear/city/grosshammmer,
		/obj/item/clothing/suit/armor/ego_gear/city/ncorpcommander,
	)

//R Corporation
/obj/structure/lootcrate/r_corp
	name = "R Corp Crate"
	desc = "A crate recieved from R-Corp. Open with a Crowbar."
	icon_state = "crate_rcorp"
	veryrarechance = 5
	cosmeticchance = 33
	lootlist =	list(
		/obj/item/clothing/suit/space/hardsuit/rabbit,
		/obj/item/clothing/suit/space/hardsuit/rabbit/leader,
		/obj/item/gun/energy/e_gun/rabbitdash,
		/obj/item/ego_weapon/city/rabbit_rush,
	)

	rareloot =	list(
		/obj/item/ego_weapon/city/rabbit_blade,
		/obj/item/ego_weapon/city/reindeer,
		/obj/item/gun/energy/e_gun/rabbitdash/sniper,
		/obj/item/gun/energy/e_gun/rabbitdash/laser,
		/obj/item/gun/energy/e_gun/rabbitdash/heavy,
		/obj/item/gun/energy/e_gun/rabbitdash/small,
		/obj/item/gun/energy/e_gun/rabbitdash/shotgun,
	)

	veryrareloot =	list(
		/obj/item/ego_weapon/city/rabbit_blade/command,
		/obj/item/ego_weapon/city/reindeer/captain,
		/obj/item/gun/energy/e_gun/rabbit/minigun,
		/obj/item/gun/energy/e_gun/rabbit/nopin,
	)

	cosmeticloot = list(
		/obj/item/clothing/under/suit/lobotomy/rabbit,
		/obj/item/toy/plush/myo,
		/obj/item/toy/plush/rabbit,
		/obj/item/clothing/under/suit/lobotomy/rcorp_command,
		/obj/item/clothing/head/beret/tegu/rcorp,
		/obj/item/clothing/neck/cloak/rcorp,
		/obj/item/powered_gadget/detector_gadget/ordeal,
	)

//S Corporation
/obj/structure/lootcrate/s_corp
	name = "S Corp Crate"
	desc = "A crate recieved from the mysterious S-Corp. Open with a Crowbar."
	icon_state = "crate_shrimp"
	veryrarechance = 5
	cosmeticchance = 5
	lootlist =	list(
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_red,
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_white,
		/obj/item/reagent_containers/food/drinks/soda_cans/wellcheers_purple,
		/obj/item/ego_weapon/ranged/sodashotty,
		/obj/item/ego_weapon/ranged/sodarifle,
		/obj/item/ego_weapon/ranged/sodasmg,
		/obj/item/ego_weapon/ranged/shrimp/assault,
	)

	rareloot =	list(
		/obj/item/ego_weapon/ranged/shrimp/minigun,
		/obj/item/grenade/spawnergrenade/shrimp,
		/obj/item/trait_injector/shrimp_injector,
	)

	veryrareloot = list(
		/obj/item/grenade/spawnergrenade/shrimp/super,
		/obj/item/grenade/spawnergrenade/shrimp/hostile,
		/obj/item/reagent_containers/pill/shrimptoxin,
		/obj/item/fishing_rod/wellcheers,
	)

	cosmeticloot = list(
		/mob/living/simple_animal/hostile/shrimp,
	)

//W Corporation
/obj/structure/lootcrate/w_corp
	name = "W Corp Crate"
	desc = "A crate recieved from W-Corp. Open with a Crowbar."
	icon_state = "crate_wcorp"
	rarechance = 30
	veryrarechance = 15
	cosmeticchance = 25
	lootlist =	list(
		/obj/item/ego_weapon/city/wcorp,
		/obj/item/clothing/suit/armor/ego_gear/city/wcorp,
	)

	rareloot =	list(
		/obj/item/ego_weapon/city/wcorp/fist,
		/obj/item/ego_weapon/city/wcorp/axe,
		/obj/item/ego_weapon/city/wcorp/spear,
		/obj/item/ego_weapon/city/wcorp/dagger,
		/obj/item/ego_weapon/city/wcorp/hammer,
		/obj/item/ego_weapon/city/wcorp/hatchet,
	)

	veryrareloot = list(
		/obj/item/ego_weapon/city/wcorp/shield,
		/obj/item/ego_weapon/city/wcorp/shield/spear,
		/obj/item/ego_weapon/city/wcorp/shield/club,
		/obj/item/ego_weapon/city/wcorp/shield/axe,
	)

	cosmeticloot = list(
		/obj/item/clothing/head/ego_hat/wcorp,
		/obj/item/clothing/under/suit/lobotomy/wcorp,
		/obj/item/powered_gadget/teleporter,
	)
