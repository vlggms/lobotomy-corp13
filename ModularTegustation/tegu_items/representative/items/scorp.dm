//Scorp goodies
/obj/item/grenade/spawnergrenade/shrimp/hostile
	name = "Instant Shrimp Liquidation Force Grenade"
	desc = "A grenade used to call for a shrimp liquidation team to help terminate assets"
	spawner_type = /mob/living/simple_animal/hostile/shrimp_soldier
	deliveryamt = 10

/obj/item/trait_injector/repshrimp_injector
	name = "Shrimp Injector MK2"
	desc = "The injector contains a pink substance, is this really worth it? Usable by only clerks. Use in hand to activate. A small note on the injector states that this one has no chance of backfiring."
	icon_state = "oddity7_pink"
	error_message = "You aren't a clerk."
	success_message = "You feel pink? A catchy song about shrimp comes to mind."

/obj/item/trait_injector/shrimp_injector/Initialize()
	. = ..()

/obj/item/trait_injector/shrimp_injector/InjectTrait(mob/living/carbon/human/user)
	if(!faction_check(user.faction, list("shrimp")))
		user.faction |= "shrimp"
		..()
		return
