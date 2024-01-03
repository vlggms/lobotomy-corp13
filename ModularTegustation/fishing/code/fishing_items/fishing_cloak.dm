/obj/item/clothing/neck/cloak/skill_reward/fishing
	name = "legendary fisher cloak"
	desc = "Worn by someone who has mastered the art of fishing and gained the attention of S corp."
	icon = 'ModularTegustation/fishing/icons/clothes_items.dmi'
	worn_icon = 'ModularTegustation/fishing/icons/clothes_worn.dmi'
	icon_state = "fishing_cloak"
	associated_skill_path = /datum/skill/fishing

/obj/item/clothing/neck/cloak/skill_reward/playing/check_wearable(mob/user)
	return user.client?.get_exp_living(TRUE) >= PLAYTIME_VETERAN
