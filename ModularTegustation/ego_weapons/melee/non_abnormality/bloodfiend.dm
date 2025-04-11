/obj/item/ego_weapon/blood
	name = "blood weapon"
	desc = "You should not be seeing this!"
	icon_state = "barber"
	icon = 'ModularTegustation/Teguicons/blood_weapon_icon.dmi'
	lefthand_file = 'ModularTegustation/Teguicons/blood_weapon_64x64_worn_left.dmi'
	righthand_file = 'ModularTegustation/Teguicons/blood_weapon_64x64_worn_right.dmi'
	var/hardblood_mode = FALSE
	var/hardblood_threshold = 100

/obj/item/ego_weapon/blood/proc/activate_hardblood()
	hardblood_mode = TRUE

/obj/item/ego_weapon/blood/proc/deactivate_hardblood()
	hardblood_mode = FALSE

/obj/item/ego_weapon/blood/barber
	name = "blood-tinged scissorblades"
	desc = "So, how did you like the game? Mine's your favorite, isn't it?"
	special = "By using this weapon in hand, you are able to open and close your scissorblades. While they are open, this weapon will have a 5x5 AoE. \
		When you consume 200+ hardblood with your outfit, this weapon enters a 'Hardblood' state. \
		While this weapon is in its hardblood state, it will deal 20 more damage, and the AoE deals even more damage. \
		This weapon executes foes with 20% or less HP, generating bloodfeast for the outfit. Doesn't work on powerful foes."
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	icon_state = "barber"
	force = 50
	damtype = RED_DAMAGE
	hardblood_threshold = 200
	attack_verb_continuous = list("cuts", "slices")
	attack_verb_simple = list("cut", "slice")
	hitsound = 'sound/weapons/ego/barber1.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 80,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 100
							)
	var/open_scissor = TRUE
	var/aoe_range = 2
	var/open_cooldown
	var/open_cooldown_time = 4 SECONDS
	var/execute_threshold = 0.2
	var/execute_limit = 1500
	var/bloodfeast_increase = 40
	//Voiceline Stuff
	var/vc_on = FALSE

	var/kill_cooldown
	var/kill_cooldown_time = 10 SECONDS

/obj/item/ego_weapon/blood/barber/attack_self(mob/living/carbon/human/user)
	..()
	if(!CanUseEgo(user))
		return
	if(open_cooldown > world.time)
		to_chat(user, "<span class='warning'>Your scissors are still recharging!")
		return
	if(!open_scissor)
		open_scissor = TRUE
		to_chat(user, "<span class='nicegreen'>You open the blades!")
		playsound(src, 'sound/weapons/ego/barber2.ogg', 50, FALSE, 9)
	else
		open_scissor = FALSE
		open_cooldown = world.time + open_cooldown_time
		to_chat(user, "<span class='nicegreen'>You close the blades!")
	update_icon_state()

/obj/item/ego_weapon/blood/barber/attack(mob/living/target, mob/living/carbon/human/user)
	..()
	if(vc_on && prob(25))
		if(prob(75))
			playsound(src, 'sound/weapons/ego/barber_vc_attack1.ogg', 50, FALSE, 9)
		else
			playsound(src, 'sound/weapons/ego/barber_vc_attack2.ogg', 50, FALSE, 9)

	if(open_scissor)
		for(var/mob/living/L in view(aoe_range, get_turf(target)))
			var/aoe_damage = force
			if(!hardblood_mode)
				aoe_damage = force * 0.75
			var/userjust = (get_attribute_level(user, JUSTICE_ATTRIBUTE))
			var/justicemod = 1 + userjust/100
			aoe_damage*=justicemod
			if(L == user)
				continue
			L.deal_damage(aoe_damage, damtype)
			new /obj/effect/temp_visual/small_smoke/halfsecond(get_turf(L))

	if(ishostile(target))
		if((target.health < target.maxHealth * execute_threshold) && (target.maxHealth < execute_limit))
			target.gib()
			if(ishuman(user))
				var/mob/living/carbon/human/wielder = user
				var/obj/item/clothing/suit/armor/ego_gear/city/masquerade_cloak/S = wielder.get_item_by_slot(ITEM_SLOT_OCLOTHING)
				S.bloodfeast += bloodfeast_increase
				to_chat(user, "<span class='nicegreen'>You increase your outfit's bloodfeast!")
				if(vc_on && !(kill_cooldown > world.time))
					kill_cooldown = world.time + kill_cooldown_time
					playsound(src, 'sound/weapons/ego/barber_vc_kill.ogg', 50, FALSE, 9)

/obj/item/ego_weapon/blood/barber/update_icon_state()
	icon_state = inhand_icon_state = "[initial(icon_state)]" + "[open_scissor ? "" : "_closed"]" + "[hardblood_mode ? "_buffed" : ""]"

/obj/item/ego_weapon/blood/barber/activate_hardblood()
	. = ..()
	force += 20
	if(vc_on)
		playsound(src, 'sound/weapons/ego/barber_vc_hardblood.ogg', 50, FALSE, 9)
	update_icon_state()

/obj/item/ego_weapon/blood/barber/deactivate_hardblood()
	. = ..()
	force -= 20
	if(vc_on)
		playsound(src, 'sound/weapons/ego/barber_vc_heh.ogg', 50, FALSE, 9)
	update_icon_state()

/obj/item/ego_weapon/blood/cassetti
	name = "hardblood glaive"
	desc = "I Am... The Prince... of the Parade...!"
	special = "When killing or attacking a dead mob, convert them into a bloodbag and heal 10% of your HP. \
		When you consume 200+ hardblood with your outfit, this weapon enters a 'Hardblood' state. \
		While this weapon is in it's hardblood state, when you throw this weapon, you will teleport to it and pick it up."
	icon_state = "cassetti"
	force = 130
	reach = 2
	stuntime = 5
	attack_speed = 3
	throwforce = 60
	throw_speed = 5
	throw_range = 7
	damtype = RED_DAMAGE
	hardblood_threshold = 200
	attack_verb_continuous = list("pierces", "slices")
	attack_verb_simple = list("pierce", "slice")
	hitsound = 'sound/weapons/fixer/generic/spear3.ogg'
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 100,
							PRUDENCE_ATTRIBUTE = 100,
							TEMPERANCE_ATTRIBUTE = 80,
							JUSTICE_ATTRIBUTE = 80
							)

/obj/item/ego_weapon/blood/cassetti/attack(mob/living/target, mob/living/carbon/human/user)
	if(!CanUseEgo(user))
		return
	..()
	if((target.stat == DEAD) && !(target.status_flags & GODMODE) && ishostile(target))
		var/mob/living/simple_animal/hostile/humanoid/blood/bag/blood = new(get_turf(target))
		target.gib()
		user.adjustBruteLoss(-user.maxHealth * 0.1)	//Heal 10% HP
		blood.faction = user.faction

/obj/item/ego_weapon/blood/cassetti/on_thrown(mob/living/carbon/user, atom/target)//No, clerks cannot hilariously kill themselves with this
	if(!CanUseEgo(user))
		return
	return ..()

/obj/item/ego_weapon/blood/cassetti/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(!ismob(hit_atom) || !hardblood_mode)
		return
	if(thrownby && !.)
		new /obj/effect/temp_visual/dir_setting/cult/phase/out (get_turf(thrownby))
		thrownby.forceMove(get_turf(src))
		new /obj/effect/temp_visual/dir_setting/cult/phase (get_turf(thrownby))
		playsound(src, 'sound/magic/exit_blood.ogg', 100, FALSE, 4)
		src.attack_hand(thrownby)
		if(thrownby.get_active_held_item() == src) //if our attack_hand() picks up the item...
			visible_message(span_warning("[thrownby] teleports to [src]!"))
