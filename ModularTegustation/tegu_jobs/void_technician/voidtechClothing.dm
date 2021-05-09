//Jumpsuit
/obj/item/clothing/under/rank/engineering/void
	desc = "It's a grey jumpsuit worn by those that love the void."
	name = "void technician's jumpsuit"
	worn_icon = 'ModularTegustation/Teguicons/kirie_stuff/voidtech.dmi'
	icon_state = "voidtech"
	icon = 'ModularTegustation/Teguicons/kirie_stuff/voidtech_icon.dmi'
	inhand_icon_state = "void_suit"
	lefthand_file = 'ModularTegustation/Teguicons/teguclothing_hold_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/teguclothing_hold_right.dmi'
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 30, ACID = 10)
	resistance_flags = NONE

//Voidtech hardsuit
/obj/item/clothing/head/helmet/space/hardsuit/voidtech
	name = "voidtech hardsuit helmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Trades all protection for speed."
	worn_icon = 'ModularTegustation/Teguicons/kirie_stuff/voidtech.dmi'
	icon_state = "hardsuit0-voidtech"
	icon = 'ModularTegustation/Teguicons/kirie_stuff/voidtech_icon.dmi'
	inhand_icon_state = "void_hardsuit"
	lefthand_file = 'ModularTegustation/Teguicons/teguclothing_hold_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/teguclothing_hold_right.dmi'
	armor = list(MELEE = 20, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 15, BIO = 100, RAD = 15, FIRE = 60, ACID = 30, WOUND = 5)
	hardsuit_type = "voidtech"

/obj/item/clothing/suit/space/hardsuit/voidtech
	name = "voidtech hardsuit"
	desc = "A special suit that protects against hazardous, low pressure environments. Trades all protection for speed."
	worn_icon = 'ModularTegustation/Teguicons/kirie_stuff/voidtech.dmi'
	icon_state = "hardsuit-voidtech"
	icon = 'ModularTegustation/Teguicons/kirie_stuff/voidtech_icon.dmi'
	inhand_icon_state = "void_hardsuit"
	lefthand_file = 'ModularTegustation/Teguicons/teguclothing_hold_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/teguclothing_hold_right.dmi'
	armor = list(MELEE = 20, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 15, BIO = 100, RAD = 15, FIRE = 60, ACID = 30, WOUND = 5)
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/voidtech
	cell = /obj/item/stock_parts/cell/hyper
	slowdown = 0.25

/obj/item/clothing/head/helmet/space/hardsuit/voidtech/marine
	name = "space marine hardsuit helmet"
	desc = "A standard-issued helmet of Nanotrasen space marine's hardsuit. While technically it lacks armor, most enemies \
	will disperse just at the sight of it"
	icon_state = "hardsuit0-spacemarine"
	hardsuit_type = "spacemarine"
	light_color = COLOR_SOFT_RED // Fear me mortals.

/obj/item/clothing/suit/space/hardsuit/voidtech/marine
	name = "space marine hardsuit"
	desc = "A modified Void Technician's hardsuit, given to the most successful explorers that managed to earn the rank of \
	a Space Marine."
	icon_state = "hardsuit-spacemarine"
	helmettype = /obj/item/clothing/head/helmet/space/hardsuit/voidtech/marine

//Special Subspace Headset
/obj/item/radio/headset/subspace/void
	name = "voidtech's subspace headset"
	desc = "A headset made with special tech in mind to explore deep space. A rarity around these parts"
	icon_state = "subspace_headset"
	worn_icon = 'ModularTegustation/Teguicons/kirie_stuff/voidtech.dmi'
	icon = 'ModularTegustation/Teguicons/kirie_stuff/voidtech_icon.dmi'
	keyslot = new /obj/item/encryptionkey/headset_void
	subspace_transmission = FALSE

//Encryption key
/obj/item/encryptionkey/headset_void
	name = "void technicians radio encryption key"
	icon_state = "eng_cypherkey"
	channels = list(RADIO_CHANNEL_SCIENCE = 1, RADIO_CHANNEL_ENGINEERING = 1)
