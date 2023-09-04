//Shi has 2 different modes. Dash Attacks and Boundary of Death.
//Shi Assassin (Current one being used right now) uses Boundary of death.

/obj/item/ego_weapon/city/shi_knife
	name = "shi association knife"
	desc = "A blade that is used by Shi Section 2 assassins to go out with honour."
	special = "Attack yourself with this weapon to instantly kill yourself."
	icon_state = "shi_dagger"
	force = 44
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
	var/force_update = 44

/obj/item/ego_weapon/city/shi_knife/attack(mob/living/target, mob/living/carbon/human/user)
	force = force_update
	if(!CanUseEgo(user))
		return
	if(target == user)
		user.death()
		for(var/mob/M in GLOB.player_list)
			to_chat(M, "<span class='userdanger'>[uppertext(user.real_name)] has gone out with honor. 灰から灰へ</span>")
		new /obj/effect/temp_visual/BoD(get_turf(target))
	..()

//Boundary of death users
//Grade 5
/obj/item/ego_weapon/city/shi_assassin
	name = "shi association sheathed blade"
	desc = "A blade that is used by Shi Section 2."
	special = "Use this weapon in hand to immobilize yourself for 1 second, cut your HP by 25%, and deal 2x damage in pale."
	icon_state = "shiassassin"
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
	var/multiplier = 2


/obj/item/ego_weapon/city/shi_assassin/attack_self(mob/living/carbon/human/user)
	..()
	if(!CanUseEgo(user))
		return

	if(!ready)
		return
	ready = FALSE
	user.Immobilize(17)
	to_chat(user, "<span class='userdanger'>Draw.</span>")
	force*=multiplier
	damtype = PALE_DAMAGE
	armortype = damtype
	user.adjustBruteLoss(user.maxHealth*0.25)

	addtimer(CALLBACK(src, .proc/Return, user), 5 SECONDS)

/obj/item/ego_weapon/city/shi_assassin/attack(mob/living/target, mob/living/carbon/human/user)
	..()
	if(force != initial(force))
		to_chat(user, "<span class='userdanger'>Boundary of Death.</span>")
		new /obj/effect/temp_visual/BoD(get_turf(target))
		force = initial(force)
	damtype = initial(damtype)
	armortype = damtype

/obj/item/ego_weapon/city/shi_assassin/proc/Return(mob/living/carbon/human/user)
	force = initial(force)
	ready = TRUE
	to_chat(user, "<span class='notice'>Your blade is ready.</span>")
	damtype = initial(damtype)
	armortype = damtype

/obj/effect/temp_visual/BoD
	icon_state = "BoD"
	duration = 17 //in deciseconds
	randomdir = FALSE

//Grade 4
/obj/item/ego_weapon/city/shi_assassin/vet
	name = "shi association veteran sheathed blade"
	desc = "A blade that is used by Shi Section 2 veterans. It's extremely sharp."
	icon_state = "shiassassin_vet"
	force = 52
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 60
							)

//Grade 3
/obj/item/ego_weapon/city/shi_assassin/director
	name = "shi association director sheathed blade"
	desc = "A blade that is used by Shi Section 2 directors. It's extremely sharp."
	icon_state = "shiassassin_director"
	force = 65
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 80,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 100,
							JUSTICE_ATTRIBUTE = 80
							)

//Specialist Shi Blades (I had the sprites.)
/obj/item/ego_weapon/city/shi_assassin/sakura
	name = "shi association sakura blade"
	desc = "A unique specialized assassin blade that is used by Shi Section 2. Created for highly armored targets, this one deals white damage"
	icon_state = "shi_sakura"
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE

/obj/item/ego_weapon/city/shi_assassin/serpent
	name = "shi association seperant blade"
	desc = "A unique specialized assassin blade that is used by Shi Section 2. Created for highly armored targets, this one deals black damage"
	icon_state = "shi_serpent"
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE

/obj/item/ego_weapon/city/shi_assassin/yokai
	name = "shi association yokai blade"
	desc = "A unique specialized assassin blade that is used by Shi Section 2. Created for highly armored targets, this one deals pale damage"
	force = 20
	icon_state = "shi_yokai"
	damtype = PALE_DAMAGE
	armortype = PALE_DAMAGE
	multiplier = 4
