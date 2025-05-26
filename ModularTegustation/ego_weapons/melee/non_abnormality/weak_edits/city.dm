//Copy of the baton
/obj/item/ego_weapon/city/zweibaton/protection
	name = "city protection baton"
	desc = "A riot club used by the local protection."
	special = "Attack a human to stun them after a period of time."
	icon_state = "protection_baton"
	inhand_icon_state = "protection_baton"
	force = 30
	attribute_requirements = list()



//Bad indexstuff
/obj/item/ego_weapon/city/fakeindex
	name = "index recruit sword"
	desc = "A sheathed sword used by index recruits."
	icon_state = "index"
	inhand_icon_state = "index"
	force = 20
	damtype = PALE_DAMAGE

	attack_verb_continuous = list("smacks", "hammers", "beats")
	attack_verb_simple = list("smack", "hammer", "beat")
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 60,
	)

//proxy randomizer
/obj/effect/spawner/lootdrop/proxy
	name = "proxy weapon spawner"
	lootdoubles = FALSE

	loot = list(
		/obj/item/ego_weapon/city/fakeindex/proxy = 1,
		/obj/item/ego_weapon/city/fakeindex/proxy/spear = 1,
		/obj/item/ego_weapon/city/fakeindex/proxy/knife = 1,
	)

/obj/item/ego_weapon/city/fakeindex/proxy
	name = "index longsword"
	desc = "A long sword used by index proxies."
	icon_state = "indexlongsword"
	inhand_icon_state = "indexlongsword"
	attack_verb_continuous = list("slices", "slashes", "stabs")
	attack_verb_simple = list("slice", "slash", "stab")
	hitsound = 'sound/weapons/bladeslice.ogg'
	force = 35
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 80,
		PRUDENCE_ATTRIBUTE = 80,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 80,
	)

//Just gonna set this to the big proxy weapon for requirement reasons
/obj/item/ego_weapon/city/fakeindex/proxy/spear
	name = "index spear"
	desc = "A spear used by index proxies."
	icon_state = "indexspear"
	inhand_icon_state = "indexspear"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left_64x64.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right_64x64.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	hitsound = 'sound/weapons/fixer/generic/nail1.ogg'
	attack_speed = 1.2
	reach = 2
	stuntime = 5

/obj/item/ego_weapon/city/fakeindex/proxy/knife
	name = "index dagger"
	desc = "A dagger used by index proxies."
	icon_state = "indexdagger"
	inhand_icon_state = "indexdagger"
	force = 20
	attack_speed = 0.5


//Fockin massive sword
/obj/item/ego_weapon/city/fakeindex/yan
	name = "index greatsword"
	desc = "A greatsword sword used by a specific index messenger."
	icon_state = "indexgreatsword"
	inhand_icon_state = "indexgreatsword"
	lefthand_file = 'ModularTegustation/Teguicons/lc13_left_64x64.dmi'
	righthand_file = 'ModularTegustation/Teguicons/lc13_right_64x64.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleaves", "cuts")
	hitsound = 'sound/weapons/fixer/generic/finisher1.ogg'
	force = 55
	attack_speed = 2
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 100,
		PRUDENCE_ATTRIBUTE = 100,
		TEMPERANCE_ATTRIBUTE = 100,
		JUSTICE_ATTRIBUTE = 100,
	)


//Blade Lineage
/obj/item/ego_weapon/city/bladelineage/city
	special = "Use this weapon in hand to immobilize yourself for 3 seconds and deal 3x damage on the next attack within 5 seconds. This empowered attack also deals 2% more damage per 1% of your missing HP, on top of the 3x damage."
	force = 30
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 60,
	)
	multiplier = 3

//Kurokumo
/obj/item/ego_weapon/city/kurokumo/weak
	force = 52
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 60,
	)

//Thumb
/obj/item/ego_weapon/ranged/city/thumb/weak
	force = 20
	projectile_damage_multiplier = 2.5 //25 damage per bullet
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 60,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 60,
	)

//Capo
/obj/item/ego_weapon/ranged/city/thumb/capo/weak
	force = 25
	projectile_damage_multiplier = 3.5 //35 damage per bullet
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 80,
		PRUDENCE_ATTRIBUTE = 80,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 80,
	)

//Sottocapo
/obj/item/ego_weapon/ranged/city/thumb/sottocapo/weak
	force = 10	//It's a pistol
	projectile_damage_multiplier = 1.1 //11 damage per bullet
	projectile_path = /obj/projectile/ego_bullet/tendamage // total 88 damage
	pellets = 8
	variance = 16
	reloadtime = 7 SECONDS // it is a bit stronger, but requires a bit longer reload time. (either hit with it or step back for downtime)
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 100,
		PRUDENCE_ATTRIBUTE = 100,
		TEMPERANCE_ATTRIBUTE = 100,
		JUSTICE_ATTRIBUTE = 100,
	)

//wepaons are kinda uninteresting
/obj/item/ego_weapon/city/thumbmelee/weak
	force = 35
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 80,
		PRUDENCE_ATTRIBUTE = 80,
		TEMPERANCE_ATTRIBUTE = 80,
		JUSTICE_ATTRIBUTE = 80,
	)

/obj/item/ego_weapon/city/thumbcane/weak
	force = 45
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 100,
		PRUDENCE_ATTRIBUTE = 100,
		TEMPERANCE_ATTRIBUTE = 100,
		JUSTICE_ATTRIBUTE = 100,
	)

/obj/item/clothing/suit/armor/ego_gear/city/ncorp/weak
	name = "nagel und hammer armor"
	desc = "Armor worn by Nagel Und Hammer."
	icon_state = "ncorp"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 20, BLACK_DAMAGE = 20, PALE_DAMAGE = 50)
	attribute_requirements = list()

/obj/item/clothing/suit/armor/ego_gear/city/kcorp_l1/weak
	attribute_requirements = list()


//People bitched a lot
/obj/item/ego_weapon/city/liu/fire/section5
	name = "liu combat gloves"
	icon_state = "liufist"
	desc = "A gauntlet used by Liu Sections 4,5 and 6. Requires martial arts training to make use of."
	force = 20
	attack_speed = 0.7
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 60,
		PRUDENCE_ATTRIBUTE = 40,
		TEMPERANCE_ATTRIBUTE = 40,
		JUSTICE_ATTRIBUTE = 40,
	)
	hitsound = 'sound/weapons/fixer/generic/fist1.ogg'


/obj/item/ego_weapon/city/liu/fire/section5/vet
	name = "liu veteran combat gloves"
	icon_state = "liufist_vet"
	force = 32
	attribute_requirements = list(
		FORTITUDE_ATTRIBUTE = 100,
		PRUDENCE_ATTRIBUTE = 80,
		TEMPERANCE_ATTRIBUTE = 60,
		JUSTICE_ATTRIBUTE = 80,
	)
