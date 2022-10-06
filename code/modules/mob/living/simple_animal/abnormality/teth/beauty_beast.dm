/mob/living/simple_animal/hostile/abnormality/beauty
	name = "Beauty and the Beast"
	desc = "A quadruped monster covered in brown fur. The amount of the eyes it has is impossible to count."
	icon = 'ModularTegustation/Teguicons/48x48.dmi'
	icon_state = "beauty"
	icon_living = "beauty"
	icon_dead = "beauty_dead"

	pixel_x = -8
	base_pixel_x = -8

	maxHealth = 650
	health = 650
	del_on_death = FALSE
	threat_level = TETH_LEVEL
	damage_coeff = list(BRUTE = 1, RED_DAMAGE = 2, WHITE_DAMAGE = 0.5, BLACK_DAMAGE = 1.5, PALE_DAMAGE = 2)
	work_chances = list(
		ABNORMALITY_WORK_INSTINCT = list(40, 20, -20, -20, -20),
		ABNORMALITY_WORK_INSIGHT = list(50, 50, 40, 30, 30),
		ABNORMALITY_WORK_ATTACHMENT = list(30, 15, -50, -50, -50),
		ABNORMALITY_WORK_REPRESSION = 65
		)
	work_damage_amount = 5
	work_damage_type = WHITE_DAMAGE
	faction = list("hostile")
	attack_verb_continuous = "gores"
	attack_verb_simple = "gore"
	melee_damage_lower = 10
	melee_damage_upper = 20
	melee_damage_type = RED_DAMAGE

	ego_list = list(
		/datum/ego_datum/weapon/horn,
		/datum/ego_datum/armor/horn
		)
	gift_type =  /datum/ego_gifts/horn
	pinkable = TRUE
	var/injured = FALSE
	var/self_hurt_cooldown = 5 SECONDS
	var/self_hurt_timer = 0
	var/mob/living/last_attacker = null

//it needs to use PostSpawn or we can't get the datum of beauty
/mob/living/simple_animal/hostile/abnormality/beauty/PostSpawn()
	var/cursed = RememberVar("curse")
	if(!cursed)
		return
	for(var/mob/dead/observer/O in GLOB.player_list) //we grab the last person that died to beauty and yeet them in there
		if(O.ckey == cursed)
			O.mind.transfer_to(src)
			src.ckey = cursed
			to_chat(src, "<span class='userdanger'>You begin to have hundreds of eyes burst from your mouth, while a pair of horns expel from your eye sockets, adorning themselves with flowers. Now the Beast, you forever search for someone to lift your curse.</span>")
			to_chat(src, "<span class='notice'>(If you wish to leave this body you can simply ghost with the ooc tab > ghost, there is no consequence for doing so.)</span>")
			TransferVar("curse", null) //we reset the cursed just in case
			return

/mob/living/simple_animal/hostile/abnormality/beauty/death(gibbed)
	density = FALSE
	animate(src, alpha = 0, time = 10 SECONDS)
	QDEL_IN(src, 10 SECONDS)
	..()

/mob/living/simple_animal/hostile/abnormality/beauty/work_complete(mob/living/carbon/human/user, work_type, pe)
	..()
	if(work_type == ABNORMALITY_WORK_REPRESSION)
		if(!injured)
			injured = TRUE
			icon_state = "beauty_injured"

		else if (!(GODMODE in user.status_flags))//If you already did repression, die.
			TransferVar("curse", user.ckey)
			user.gib()
			death()

	else
		injured = FALSE
		icon_state = icon_living
	return

/mob/living/simple_animal/hostile/abnormality/beauty/Life()
	. = ..()
	if(status_flags & GODMODE)
		return
	if(self_hurt_timer < world.time)
		self_hurt_timer = self_hurt_cooldown + world.time
		last_attacker = null
		adjustBruteLoss(maxHealth*0.1)

/mob/living/simple_animal/hostile/abnormality/beauty/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	last_attacker = user

/mob/living/simple_animal/hostile/abnormality/beauty/bullet_act(obj/projectile/P)
	. = ..()
	last_attacker = P.firer

/mob/living/simple_animal/hostile/abnormality/beauty/death(gibbed)
	if(!isnull(last_attacker) && ishuman(last_attacker))
		var/mob/living/simple_animal/hostile/abnormality/beauty/new_beauty = new /mob/living/simple_animal/hostile/abnormality/beauty(get_turf(last_attacker))
		new_beauty.faction += "pink_midnight"
		last_attacker.gib()
		last_attacker = null
	. = ..()

