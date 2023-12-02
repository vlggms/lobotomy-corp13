//Ting Tang, stuffs kinda jobber, no reqs anyways so big day for clerks. White resist to pair up with weapons.
/obj/item/clothing/suit/armor/ego_gear/city/ting_tang
	flags_inv = HIDEJUMPSUIT|HIDEGLOVES
	name = "red ting tang shirt"
	desc = "A hawaiin shirt that comes with tattos, somehow. They supposedly bring good luck."
	icon_state = "tingtang_bean"
	armor = list(RED_DAMAGE = 10, WHITE_DAMAGE = 30, BLACK_DAMAGE = -10, PALE_DAMAGE = -10)

/obj/item/clothing/suit/armor/ego_gear/city/ting_tang/puffer
	name = "blue ting tang shirt"
	icon_state = "tingtang_bean"

/obj/item/clothing/suit/armor/ego_gear/city/ting_tang/rustic
	name = "yellow ting tang shirt"
	icon_state = "tingtang_bean"

/obj/item/clothing/suit/armor/ego_gear/city/ting_tang/boss
	name = "green ting tang shirt"
	desc = "A hawaiin shirt worn by the boss of the Ting Tang Gang. The tattos on this one feel luckier."
	icon_state = "tingtang_boss"
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 40, BLACK_DAMAGE = 20, PALE_DAMAGE = 10)
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

//Mariachis, balanced red and white resists. two non-req armors, 2 moderately strong ones.
/obj/item/clothing/suit/armor/ego_gear/city/mariachi
	name = "los mariachis poncho"
	desc = "A poncho worn by members of the Los Mariachis. This one's blue."
	icon_state = "mariachis_alegre"
	armor = list(RED_DAMAGE = 20, WHITE_DAMAGE = 20, BLACK_DAMAGE = -10, PALE_DAMAGE = -10)

/obj/item/clothing/suit/armor/ego_gear/city/mariachi/vivaz
	desc = "A poncho worn by members of the Los Mariachis. This one's brown."
	icon_state = "mariachis_vivaz"

/obj/item/clothing/suit/armor/ego_gear/city/mariachi/aida
	name = "los mariachis armor"
	desc = "The outfit of the Los Mariachis leader. Its well woven for sure."
	icon_state = "aida"
	armor = list(RED_DAMAGE = 30, WHITE_DAMAGE = 30, BLACK_DAMAGE = 10, PALE_DAMAGE = 20)
	hat = /obj/item/clothing/head/ego_hat/aida_hat
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 60,
							JUSTICE_ATTRIBUTE = 60
							)

/obj/item/clothing/head/ego_hat/aida_hat
	name = "los mariachis sombrero"
	desc = "A sombrero worn by the Los Mariachis leader. It makes you want to dance."
	icon_state = "aida"

/obj/item/clothing/suit/armor/ego_gear/city/mariachi/aida/boss
	name = "los mariachis armor"
	desc = "The outfit of the Los Mariachis leader. No one has seen this and lived."
	icon_state = "aida_boss"
	armor = list(RED_DAMAGE = 40, WHITE_DAMAGE = 40, BLACK_DAMAGE = 20, PALE_DAMAGE = 30)
	hat = /obj/item/clothing/head/ego_hat/helmet/aida_hat_boss
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/clothing/head/ego_hat/helmet/aida_hat_boss
	name = "los mariachis sombrero"
	desc = "A sombrero worn by the Los Mariachis leader. This one has a glowing mask of a skull."
	icon_state = "aida_boss"
