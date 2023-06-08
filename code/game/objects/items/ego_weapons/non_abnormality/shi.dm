//Shi has 2 different modes. Dash Attacks and Boundary of Death.
//Shi Assassin (Current one being used right now) uses Boundary of death.


//Boundary of death uses
//Grade 5
/obj/item/ego_weapon/city/shi_association
	name = "shi association sheathed blade"
	desc = "A blade that is standard among blade lineage."
	special = "Use this weapon in hand to immobilize yourself for 1 second, cut your HP by 10%, and deal 2x damage in pale."
	icon_state = "shi_association"
	force = 44
	attack_speed = 1.2
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/bladeslice.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 60,
							PRUDENCE_ATTRIBUTE = 60,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 60
							)
	var/ready = TRUE


/obj/item/ego_weapon/city/shi_association/attack_self(mob/living/carbon/human/user)
	..()
	if(!CanUseEgo(user))
		return

	if(!ready)
		return
	ready = FALSE
	user.Immobilize(17)
	to_chat(user, "<span class='userdanger'>Ready.</span>")
	force*=2
	damtype = PALE_DAMAGE
	armortype = damtype
	user.adjustBruteLoss(user.maxHealth*0.2)

	addtimer(CALLBACK(src, .proc/Return, user), 5 SECONDS)

/obj/item/ego_weapon/city/shi_association/attack(mob/living/target, mob/living/carbon/human/user)
	..()
	if(force != initial(force))
		to_chat(user, "<span class='userdanger'>Boundary of Death.</span>")
		new /obj/effect/temp_visual/BoD(get_turf(target))
		force = initial(force)
	damtype = RED_DAMAGE
	armortype = damtype

/obj/item/ego_weapon/city/shi_association/proc/Return(mob/living/carbon/human/user)
	force = initial(force)
	ready = TRUE
	to_chat(user, "<span class='notice'>Your blade is ready.</span>")
	damtype = RED_DAMAGE
	armortype = damtype

/obj/effect/temp_visual/BoD
	icon_state = "BoD"
	duration = 17 //in deciseconds
	randomdir = FALSE

