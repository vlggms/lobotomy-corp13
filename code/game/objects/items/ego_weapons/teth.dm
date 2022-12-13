/obj/item/ego_weapon/training
	name = "training hammer"
	desc = "E.G.O intended for Manager Education"
	icon_state = "training"
	force = 22
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("smacks", "hammers", "beats")
	attack_verb_simple = list("smack", "hammer", "beat")

/obj/item/ego_weapon/fragment
	name = "fragments from somewhere"
	desc = "The spear often tries to lead the wielder into a long and endless realm of mind, \
	but they must try to not be swayed by it."
	special = "This weapon has a longer reach. \
			This weapon attacks slower than usual."
	icon_state = "fragment"
	force = 22
	reach = 2		//Has 2 Square Reach.
	attack_speed = 1.2
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'

/obj/item/ego_weapon/horn
	name = "horn"
	desc = "As the horn digs deep into the enemy's heart, it will turn blood red to show off the glamor that she couldn't in her life."
	icon_state = "horn"
	special = "This weapon deals more throwing damage."
	force = 22
	throwforce = 50		//You can only hold two so go nuts.
	throw_speed = 5
	throw_range = 7
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'

/obj/item/ego_weapon/lutemia
	name = "dear lutemia"
	desc = "Don't you want your cares to go away?"
	icon_state = "lutemia"
	force = 22
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("poke", "jab", "tear", "lacerate", "gore")
	hitsound = 'sound/weapons/ego/spear1.ogg'

/obj/item/ego_weapon/eyes
	name = "red eyes"
	desc = "It is likely able to hear, touch, smell, as well as see. And most importantly, taste."
	special = "Knocks certain enemies backwards. \
			This weapon hits slower than usual. "
	icon_state = "eyes"
	force = 35					//Still less DPS, replaces baseball bat
	attack_speed = 1.6
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("beats", "smacks")
	attack_verb_simple = list("beat", "smack")

/obj/item/ego_weapon/eyes/attack(mob/living/target, mob/living/user)
	if(!CanUseEgo(user))
		return
	. = ..()
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	if(!target.anchored)
		var/whack_speed = (prob(60) ? 1 : 4)
		target.throw_at(throw_target, rand(1, 2), whack_speed, user)

/obj/item/ego_weapon/eyeball
	name = "eyeball scooper"
	desc = "Mind if I take them?"
	icon_state = "eyeball1"
	force = 20
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("cuts", "smacks", "bashes")
	attack_verb_simple = list("cuts", "smacks", "bashes")
	attribute_requirements = list(
							FORTITUDE_ATTRIBUTE = 20		//It's 20 to keep clerks from using it
							)

/obj/item/ego_weapon/eyeball/attack(mob/living/target, mob/living/carbon/human/user)
	var/userfort = (get_attribute_level(user, FORTITUDE_ATTRIBUTE))
	var/fortitude_mod = 1 + userfort/100
	if(userfort>=60)
		icon_state = "eyeball2"
		force = 20 *(1+fortitude_mod)		//Scales with Fortitude

	if(userfort<60)
		icon_state = "eyeball1"				//Cool sprite gone

	if(ishuman(target))
		force*=1.3						//I've seen Catt one shot someone, This is also only a detriment lol
	..()
	force = initial(force)
	/*So here's how it works, If you got the stats for it, you also scale with fort. It's pretty unremarkable otherwise.
	Why? Because well Catt has been stated to work on WAWs, which means that she's at least level 3-4.
	Why is she still using Eyeball Scooper from a Zayin? Maybe it scales with fortitude?*/

/obj/item/ego_weapon/mini/wrist
	name = "wrist cutter"
	desc = "The flesh cleanly cut by a sharp tool creates a grotesque pattern with the bloodstains on the suit."
	special = "This weapon attacks very fast. Use this weapon in hand to dodgeroll."
	icon_state = "wrist"
	force = 7
	attack_speed = 0.3
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	hitsound = 'sound/weapons/bladeslice.ogg'
	var/dodgelanding

/obj/item/ego_weapon/mini/wrist/attack_self(mob/living/carbon/user)
	if(user.dir == 1)
		dodgelanding = locate(user.x, user.y + 5, user.z)
	if(user.dir == 2)
		dodgelanding = locate(user.x, user.y - 5, user.z)
	if(user.dir == 4)
		dodgelanding = locate(user.x + 5, user.y, user.z)
	if(user.dir == 8)
		dodgelanding = locate(user.x - 5, user.y, user.z)
	user.adjustStaminaLoss(20, TRUE, TRUE)
	user.throw_at(dodgelanding, 3, 2, spin = TRUE)

/obj/item/ego_weapon/regret
	name = "regret"
	desc = "Before swinging this weapon, expressing one’s condolences for the demise of the inmate who couldn't even have a funeral would be nice."
	special = "This weapon attacks extremely slowly."
	icon_state = "regret"
	force = 38				//Lots of damage, way less DPS
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_speed = 2 // Really Slow. This is the slowest teth we have, +0.4 to Eyes 1.6
	attack_verb_continuous = list("smashes", "bludgeons", "crushes")
	attack_verb_simple = list("smash", "bludgeon", "crush")

/obj/item/ego_weapon/mini/blossom
	name = "Blossoms"
	desc = "The flesh cleanly cut by a sharp tool creates a grotesque pattern with the bloodstains on the suit."
	special = "This weapon deals bonus throwing damage. \
			Upon throwing, this weapon returns to the user."
	icon_state = "blossoms"
	force = 17
	throwforce = 30
	throw_speed = 1
	throw_range = 7
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/ego_weapon/mini/blossom/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/caught = hit_atom.hitby(src, FALSE, FALSE, throwingdatum=throwingdatum)
	if(thrownby && !caught)
		addtimer(CALLBACK(src, /atom/movable.proc/throw_at, thrownby, throw_range+2, throw_speed, null, TRUE), 1)
	if(caught)
		return
	else
		return ..()

/obj/item/ego_weapon/cute
	name = "SO CUTE!!!"
	desc = "One may think, 'How can a weapon drawn from such a cute Abnormality be any good?' \
		However, the claws are actually quite durable and sharp."
	icon_state = "cute"
	force = 13
	attack_speed = 0.5
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	hitsound = 'sound/weapons/slashmiss.ogg'

/obj/item/ego_weapon/mini/trick
	name = "hat trick"
	desc = "Imagination is the only weapon in the war with reality."
	icon_state = "trick"
	special = "This weapon deals more throwing damage."
	force = 17
	throwforce = 25		//You can only hold 4 so go nuts.
	throw_speed = 5
	throw_range = 7
	damtype = BLACK_DAMAGE
	armortype = BLACK_DAMAGE
	attack_verb_continuous = list("jabs")
	attack_verb_simple = list("jabs")
	hitsound = 'sound/weapons/slashmiss.ogg'

/obj/item/ego_weapon/sorrow
	name = "sorrow"
	desc = "It all returns to nothing."
	special = "Use this weapon in hand to take damage and teleport to a random department. \
			This weapon hits slower than usual. "
	icon_state = "sorrow"
	force = 32					//Bad DPS, can teleport
	attack_speed = 1.5
	damtype = RED_DAMAGE
	armortype = RED_DAMAGE
	attack_verb_continuous = list("cleaves", "cuts")
	attack_verb_simple = list("cleave", "cut")
	var/inuse

/obj/item/ego_weapon/sorrow/attack_self(mob/living/user)
	if(inuse)
		return
	inuse = TRUE
	if(do_after(user, 50))	//Five seconds of not doing anything, then teleport.
		new /obj/effect/temp_visual/dir_setting/ninja/phase/out (get_turf(user))
		user.adjustBruteLoss(user.maxHealth*0.3)

		//teleporting half
		var/turf/T = pick(GLOB.department_centers)
		user.forceMove(T)
		new /obj/effect/temp_visual/dir_setting/ninja/phase (get_turf(user))
		playsound(src, 'sound/effects/contractorbatonhit.ogg', 100, FALSE, 9)
	inuse = FALSE

/obj/item/ego_weapon/sorority
	name = "sorority"
	desc = "Look to your sisters, and fight in sorority."
	special = "Use this weapon in hand to deal a small portion of damage to people around you and heal their sanity slightly."
	icon_state = "sorority"
	force = 17					//Also a support weapon
	damtype = WHITE_DAMAGE
	armortype = WHITE_DAMAGE
	attack_verb_continuous = list("zaps", "prods")
	attack_verb_simple = list("zap", "prod")
	var/inuse

/obj/item/ego_weapon/sorority/attack_self(mob/user)
	if(inuse)
		return
	inuse = TRUE
	if(do_after(user, 10))	//Just a second to heal people around you, but it also harms them
		playsound(src, 'sound/weapons/taser.ogg', 200, FALSE, 9)
		for(var/mob/living/carbon/human/L in range(2, get_turf(user)))
			L.adjustBruteLoss(L.maxHealth*0.1)
			L.adjustSanityLoss(10)
			new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(L), pick(GLOB.alldirs))
	inuse = FALSE


