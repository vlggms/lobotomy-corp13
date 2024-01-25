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
		/obj/item/tool_extractor,
	)

	//Injectors, quite desireable as they are quite expensive.
	veryrareloot =	list(
		/obj/item/trait_injector/agent_workchance_trait_injector,
		/obj/item/trait_injector/clerk_fear_immunity_injector,
		/obj/item/trait_injector/officer_upgrade_injector,
	)

//K Corporation
/obj/structure/lootcrate/k_corp
	name = "K Corp Crate"
	desc = "A crate recieved from K-Corp. Open with a Crowbar."
	icon_state = "crate_kcorp"
	rarechance = 30
	veryrarechance = 5
	lootlist =	list(
		/obj/item/managerbullet,
		/obj/item/ksyringe,
	)

	rareloot =	list(
		/obj/item/ego_weapon/city/kcorp,
		/obj/item/ego_weapon/shield/kcorp,
		/obj/item/ego_weapon/city/kcorp/axe,
		/obj/item/gun/ego_gun/pistol/kcorp,
		/obj/item/storage/box/kcorp_armor,
	)

	veryrareloot =	list(
		/obj/item/clothing/suit/armor/ego_gear/city/kcorp_sci,
		/obj/item/ego_weapon/city/kcorp/spear,
		/obj/item/ego_weapon/city/kcorp/dspear,
		/obj/item/gun/ego_gun/pistol/kcorp/smg,
		/obj/item/gun/ego_gun/pistol/kcorp/nade,
		/obj/item/clothing/suit/armor/ego_gear/city/kcorp_l3,
		/obj/item/toy/plush/bongy,
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
	lootlist =	list(
		/obj/item/clothing/under/suit/lobotomy/rabbit,
		/obj/item/powered_gadget/detector_gadget/ordeal,
		/obj/item/toy/plush/myo,
		/obj/item/toy/plush/rabbit,
		/obj/item/clothing/suit/space/hardsuit/rabbit,
		/obj/item/clothing/suit/space/hardsuit/rabbit/leader,
		/obj/item/gun/energy/e_gun/rabbitdash,
		/obj/item/ego_weapon/city/rabbit_rush,
		/obj/item/clothing/under/suit/lobotomy/rcorp_command,
	)

	rareloot =	list(
		/obj/item/ego_weapon/city/rabbit_blade,
		/obj/item/ego_weapon/city/reindeer,
		/obj/item/clothing/head/beret/tegu/rcorp,
		/obj/item/clothing/neck/cloak/rcorp,
	)

	veryrareloot =	list(
		/obj/item/ego_weapon/city/rabbit_blade/command,
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
		/obj/item/grenade/spawnergrenade/shrimp,
	)


//W Corporation
/obj/structure/lootcrate/w_corp
	name = "W Corp Crate"
	desc = "A crate recieved from W-Corp. Open with a Crowbar."
	icon_state = "crate_wcorp"
	lootlist =	list(
		/obj/item/ego_weapon/city/charge/wcorp,
		/obj/item/clothing/head/ego_hat/wcorp,
		/obj/item/clothing/under/suit/lobotomy/wcorp,
		/obj/item/clothing/suit/armor/ego_gear/wcorp,
		/obj/item/powered_gadget/teleporter,
	)

	rareloot =	list(
		/obj/item/ego_weapon/city/charge/wcorp/fist,
		/obj/item/ego_weapon/city/charge/wcorp/axe,
		/obj/item/ego_weapon/city/charge/wcorp/spear,
		/obj/item/ego_weapon/city/charge/wcorp/dagger,
		/obj/item/ego_weapon/city/charge/wcorp/hammer,
		/obj/item/ego_weapon/city/charge/wcorp/hatchet,
		/obj/item/ego_weapon/city/charge/wcorp/shield,
		/obj/item/ego_weapon/city/charge/wcorp/shield/spear,
		/obj/item/ego_weapon/city/charge/wcorp/shield/club,
		/obj/item/ego_weapon/city/charge/wcorp/shield/axe,
	)
