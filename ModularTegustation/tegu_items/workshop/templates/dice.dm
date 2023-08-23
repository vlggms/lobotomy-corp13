/obj/item/ego_weapon/template/dice
	name = "dice template"
	desc = "The weapon of someone who can swing their weight around like a truck"
	special = "This deals a random damage amount between 10% of max damage and max damage."
	icon_state = "dicetemplate"
	force = 40
	throwforce = 20
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	finishedicon = list("finisheddice")
	finishedname = list("dice")
	finisheddesc = "A finished dice, ready for use."
	var/realforce	//Holds onto force

/obj/item/ego_weapon/template/dice/attack(mob/living/target, mob/living/user)
	realforce = force
	force = rand(realforce*0.10, realforce)
	..()
	force = realforce
