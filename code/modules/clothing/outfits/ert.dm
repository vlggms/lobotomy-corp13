/datum/outfit/centcom/ert
	name = "ERT Common"

	mask = /obj/item/clothing/mask/gas/sechailer
	uniform = /obj/item/clothing/under/mercenary/tacticool
	shoes = /obj/item/clothing/shoes/combat/merc
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset/headset_cent/alt
	implants = list(/obj/item/implant/mindshield, /obj/item/organ/cyberimp/eyes/hud/security)

/datum/outfit/centcom/ert/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/radio/R = H.ears
	R.set_frequency(FREQ_CENTCOM)
	R.freqlock = TRUE

	var/obj/item/card/id/W = H.wear_id
	if(W)
		W.registered_name = H.real_name
		W.update_label()
	..()

/datum/outfit/centcom/ert/commander
	name = "ERT Commander"

	id = /obj/item/card/id/ert
	suit = /obj/item/clothing/suit/space/hardsuit/ert
	suit_store = /obj/item/gun/energy/e_gun
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	back = /obj/item/storage/backpack/ert
	belt = /obj/item/storage/belt/security/full
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/melee/baton/loaded=1)
	l_pocket = /obj/item/switchblade

/datum/outfit/centcom/ert/commander/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return
	var/obj/item/radio/R = H.ears
	R.keyslot = new /obj/item/encryptionkey/heads/manager
	R.recalculateChannels()

/datum/outfit/centcom/ert/commander/alert
	name = "ERT Commander - High Alert"

	mask = /obj/item/clothing/mask/gas/sechailer/swat
	glasses = /obj/item/clothing/glasses/thermal/eyepatch
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/melee/baton/loaded=1,\
		/obj/item/gun/energy/pulse/pistol/loyalpin=1)
	l_pocket = /obj/item/melee/transforming/energy/sword/saber

/datum/outfit/centcom/ert/security
	name = "ERT Security"

	id = /obj/item/card/id/ert/security
	suit = /obj/item/clothing/suit/space/hardsuit/ert/sec
	suit_store = /obj/item/gun/energy/e_gun/stun
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	gloves = /obj/item/clothing/gloves/tackler/combat/insulated
	back = /obj/item/storage/backpack/ert/security
	belt = /obj/item/storage/belt/security/full
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/storage/box/handcuffs=1,\
		/obj/item/melee/baton/loaded=1)

/datum/outfit/centcom/ert/security/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	var/obj/item/radio/R = H.ears
	R.keyslot = new /obj/item/encryptionkey/heads/manager
	R.recalculateChannels()

/datum/outfit/centcom/ert/security/alert
	name = "ERT Security - High Alert"

	mask = /obj/item/clothing/mask/gas/sechailer/swat
	belt = /obj/item/gun/energy/pulse/carbine/loyalpin
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/storage/box/handcuffs=1,\
		/obj/item/melee/baton/loaded=1,\
		/obj/item/storage/belt/security/full=1)


/datum/outfit/centcom/ert/medic
	name = "ERT Medic"

	id = /obj/item/card/id/ert/medical
	suit = /obj/item/clothing/suit/space/hardsuit/ert/med
	suit_store = /obj/item/gun/energy/e_gun
	glasses = /obj/item/clothing/glasses/hud/health
	back = /obj/item/storage/backpack/ert/medical
	belt = /obj/item/storage/belt/medical
	l_hand = /obj/item/storage/firstaid/regular
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/melee/baton/loaded=1,\
		/obj/item/reagent_containers/hypospray/combat=1,\
		/obj/item/gun/medbeam=1)

/datum/outfit/centcom/ert/medic/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	var/obj/item/radio/R = H.ears
	R.keyslot = new /obj/item/encryptionkey/heads/manager
	R.recalculateChannels()

/datum/outfit/centcom/ert/medic/alert
	name = "ERT Medic - High Alert"

	mask = /obj/item/clothing/mask/gas/sechailer/swat
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/melee/baton/loaded=1,\
		/obj/item/gun/energy/pulse/pistol/loyalpin=1,\
		/obj/item/reagent_containers/hypospray/combat/nanites=1,\
		/obj/item/gun/medbeam=1)

/datum/outfit/centcom/ert/engineer
	name = "ERT Engineer"

	id = /obj/item/card/id/ert/engineer
	suit = /obj/item/clothing/suit/space/hardsuit/ert/engi
	suit_store = /obj/item/gun/energy/e_gun
	glasses =  /obj/item/clothing/glasses/meson/engine
	back = /obj/item/storage/backpack/ert/engineer
	belt = /obj/item/storage/belt/utility/full
	l_pocket = /obj/item/rcd_ammo/large
	l_hand = /obj/item/storage/firstaid/regular
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/melee/baton/loaded=1,\
		/obj/item/construction/rcd/loaded=1)


/datum/outfit/centcom/ert/engineer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()

	if(visualsOnly)
		return

	var/obj/item/radio/R = H.ears
	R.keyslot = new /obj/item/encryptionkey/heads/manager
	R.recalculateChannels()

/datum/outfit/centcom/ert/engineer/alert
	name = "ERT Engineer - High Alert"

	mask = /obj/item/clothing/mask/gas/sechailer/swat
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/melee/baton/loaded=1,\
		/obj/item/gun/energy/pulse/pistol/loyalpin=1,\
		/obj/item/construction/rcd/combat=1)


/datum/outfit/centcom/centcom_official
	name = "CentCom Official"

	uniform = /obj/item/clothing/under/rank/k_corporation/officer/duty
	shoes = /obj/item/clothing/shoes/sneakers/black
	gloves = /obj/item/clothing/gloves/color/black
	ears = /obj/item/radio/headset/headset_cent
	glasses = /obj/item/clothing/glasses/sunglasses
	belt = /obj/item/gun/energy/e_gun
	l_pocket = /obj/item/pen
	back = /obj/item/storage/backpack/satchel
	r_pocket = /obj/item/pda/heads
	l_hand = /obj/item/clipboard
	id = /obj/item/card/id/centcom
	backpack_contents = list(/obj/item/stamp/centcom=1)

/datum/outfit/centcom/centcom_official/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/pda/heads/pda = H.r_store
	pda.owner = H.real_name
	pda.ownjob = "CentCom Official"
	pda.update_label()

	var/obj/item/card/id/W = H.wear_id
	W.access = get_centcom_access("CentCom Official")
	W.access += ACCESS_WEAPONS
	W.assignment = "CentCom Official"
	W.registered_name = H.real_name
	W.update_label()
	..()

/datum/outfit/centcom/ert/commander/inquisitor
	name = "Inquisition Commander"
	l_hand = /obj/item/nullrod/scythe/talking/chainsword
	suit = /obj/item/clothing/suit/space/hardsuit/ert/paranormal
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1)

/datum/outfit/centcom/ert/security/inquisitor
	name = "Inquisition Security"

	suit = /obj/item/clothing/suit/space/hardsuit/ert/paranormal/inquisitor
	suit_store = /obj/item/gun/energy/e_gun/stun

	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,
		/obj/item/storage/box/handcuffs=1,
		/obj/item/melee/baton/loaded=1,
		/obj/item/construction/rcd/loaded=1)

/datum/outfit/centcom/ert/medic/inquisitor
	name = "Inquisition Medic"

	suit = /obj/item/clothing/suit/space/hardsuit/ert/paranormal/inquisitor

	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,
		/obj/item/melee/baton/loaded=1,
		/obj/item/reagent_containers/hypospray/combat=1,
		/obj/item/reagent_containers/hypospray/combat/heresypurge=1,
		/obj/item/gun/medbeam=1)

/datum/outfit/centcom/ert/chaplain
	name = "ERT Chaplain"

	suit = /obj/item/clothing/suit/space/hardsuit/ert/paranormal/inquisitor // Chap role always gets this suit
	suit_store = /obj/item/gun/energy/e_gun
	id = /obj/item/card/id/ert/chaplain
	glasses = /obj/item/clothing/glasses/hud/health
	back = /obj/item/storage/backpack/cultpack
	belt = /obj/item/storage/belt/soulstone
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,
		/obj/item/nullrod=1,
		)

/datum/outfit/centcom/ert/chaplain/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	var/obj/item/radio/R = H.ears
	R.keyslot = new /obj/item/encryptionkey/heads/manager
	R.recalculateChannels()

/datum/outfit/centcom/ert/chaplain/inquisitor
	name = "Inquisition Chaplain"

	belt = /obj/item/storage/belt/soulstone/full/chappy
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,
		/obj/item/grenade/chem_grenade/holy=1,
		/obj/item/nullrod=1
		)

/datum/outfit/centcom/ert/janitor
	name = "ERT Janitor"

	id = /obj/item/card/id/ert/janitor
	suit = /obj/item/clothing/suit/space/hardsuit/ert/jani
	glasses = /obj/item/clothing/glasses/night
	back = /obj/item/storage/backpack/ert/janitor
	belt = /obj/item/storage/belt/janitor/full
	r_pocket = /obj/item/grenade/chem_grenade/cleaner
	l_pocket = /obj/item/grenade/chem_grenade/cleaner
	l_hand = /obj/item/storage/bag/trash/bluespace
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/storage/box/lights/mixed=1,\
		/obj/item/melee/baton/loaded=1,\
		/obj/item/mop/advanced=1,\
		/obj/item/reagent_containers/glass/bucket=1,\
		/obj/item/grenade/clusterbuster/cleaner=1)

/datum/outfit/centcom/ert/janitor/heavy
	name = "ERT Janitor - Heavy Duty"

	mask = /obj/item/clothing/mask/gas/sechailer/swat
	l_hand = /obj/item/reagent_containers/spray/chemsprayer/janitor
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/storage/box/lights/mixed=1,\
		/obj/item/melee/baton/loaded=1,\
		/obj/item/grenade/clusterbuster/cleaner=3)

/datum/outfit/centcom/ert/clown
	name = "ERT Clown"

	suit = /obj/item/clothing/suit/space/hardsuit/ert/clown
	mask = /obj/item/clothing/mask/gas/clown_hat
	id = /obj/item/card/id/ert/clown
	glasses = /obj/item/clothing/glasses/godeye
	back = /obj/item/storage/backpack/ert/clown
	belt = /obj/item/storage/belt/champion
	shoes = /obj/item/clothing/shoes/clown_shoes/combat
	r_pocket = /obj/item/bikehorn/golden
	l_pocket = /obj/item/food/grown/banana
	backpack_contents = list(/obj/item/storage/box/hug/survival=1,\
		/obj/item/melee/transforming/energy/sword/bananium=1,\
		/obj/item/shield/energy/bananium=1,\
		/obj/item/gun/ballistic/revolver/reverse=1)

/datum/outfit/centcom/ert/clown/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	..()
	if(visualsOnly)
		return
	ADD_TRAIT(H, TRAIT_NAIVE, INNATE_TRAIT)
	H.dna.add_mutation(CLOWNMUT)
	for(var/datum/mutation/human/clumsy/M in H.dna.mutations)
		M.mutadone_proof = TRUE

/datum/outfit/centcom/centcom_intern
	name = "CentCom Intern"
	var/jb_name = "CentCom Intern" // It is required for unarmed type.

	uniform = /obj/item/clothing/under/rank/k_corporation/intern
	shoes = /obj/item/clothing/shoes/sneakers/black
	gloves = /obj/item/clothing/gloves/color/black
	ears = /obj/item/radio/headset/headset_cent
	glasses = /obj/item/clothing/glasses/sunglasses
	belt = /obj/item/melee/classic_baton
	l_hand = /obj/item/gun/ballistic/rifle/boltaction/brand_new
	back = /obj/item/storage/backpack/satchel
	l_pocket = /obj/item/ammo_box/a762
	r_pocket = /obj/item/ammo_box/a762
	id = /obj/item/card/id/centcom
	backpack_contents = list(/obj/item/storage/box/survival = 1)

/datum/outfit/centcom/centcom_intern/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/card/id/W = H.wear_id
	W.access = get_centcom_access(name)
	W.access += ACCESS_WEAPONS
	W.assignment = jb_name
	W.registered_name = H.real_name
	W.update_label()

/datum/outfit/centcom/centcom_intern/unarmed
	name = "CentCom Intern (Unarmed)"
	belt = null
	l_hand = null
	l_pocket = null
	r_pocket = null

/datum/outfit/centcom/centcom_intern/leader
	name = "CentCom Head Intern"
	jb_name = "CentCom Head Intern"

	belt = /obj/item/melee/baton/loaded
	suit = /obj/item/clothing/suit/armor/vest
	suit_store = /obj/item/gun/ballistic/rifle/boltaction/brand_new
	l_hand = /obj/item/megaphone
	head = /obj/item/clothing/head/safety

/datum/outfit/centcom/centcom_intern/leader/unarmed // i'll be nice and let the leader keep their baton and vest
	name = "CentCom Head Intern (Unarmed)"
	suit_store = null
	l_pocket = null
	r_pocket = null

/datum/outfit/centcom/ert/janitor/party
	name = "ERP Cleaning Service"

	uniform = /obj/item/clothing/under/misc/overalls
	mask = /obj/item/clothing/mask/bandana/blue
	suit = /obj/item/clothing/suit/apron
	suit_store = null
	glasses = /obj/item/clothing/glasses/meson
	belt = /obj/item/storage/belt/janitor/full
	r_pocket = /obj/item/grenade/chem_grenade/cleaner
	l_pocket = /obj/item/grenade/chem_grenade/cleaner
	l_hand = /obj/item/storage/bag/trash
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/storage/box/lights/mixed=1,\
		/obj/item/mop/advanced=1,\
		/obj/item/reagent_containers/glass/bucket=1)

/datum/outfit/centcom/ert/security/party
	name = "ERP Bouncer"

	uniform = /obj/item/clothing/under/misc/bouncer
	suit = /obj/item/clothing/suit/armor/vest
	suit_store = null
	belt = /obj/item/melee/classic_baton/telescopic
	l_pocket = /obj/item/assembly/flash
	r_pocket = /obj/item/storage/wallet
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/clothing/head/helmet/police=1,\
		/obj/item/storage/box/handcuffs=1)


/datum/outfit/centcom/ert/engineer/party
	name = "ERP Constructor"

	uniform = /obj/item/clothing/under/rank/engineering/engineer/hazard
	mask = /obj/item/clothing/mask/gas/atmos
	head = /obj/item/clothing/head/hardhat/weldhat
	suit = /obj/item/clothing/suit/hazardvest
	suit_store = null
	l_hand = /obj/item/areaeditor/blueprints
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/stack/sheet/metal/fifty=1,\
		/obj/item/stack/sheet/glass/fifty=1,\
		/obj/item/stack/sheet/plasteel/twenty=1,\
		/obj/item/etherealballdeployer=1,\
		/obj/item/stack/light_w=30,\
		/obj/item/construction/rcd/loaded=1)

/datum/outfit/centcom/ert/clown/party
	name = "ERP Comedian"

	uniform = /obj/item/clothing/under/rank/civilian/clown
	head = /obj/item/clothing/head/chameleon
	suit = /obj/item/clothing/suit/chameleon
	suit_store = null
	glasses = /obj/item/clothing/glasses/chameleon
	backpack_contents = list(/obj/item/storage/box/hug/survival=1,\
		/obj/item/shield/energy/bananium=1,\
		/obj/item/instrument/piano_synth=1)

/datum/outfit/centcom/ert/commander/party
	name = "ERP Coordinator"

	uniform = /obj/item/clothing/under/misc/coordinator
	head = /obj/item/clothing/head/coordinator
	suit = /obj/item/clothing/suit/coordinator
	suit_store = null
	belt = /obj/item/storage/belt/sabre
	l_hand = /obj/item/toy/balloon
	l_pocket = /obj/item/kitchen/knife
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1,\
		/obj/item/storage/box/fireworks=3,\
		/obj/item/food/cake/birthday=1)

/datum/outfit/job/raven/ert
	name = "R-Corp Scout Raven"
	jobtype = /datum/job/raven

	ears = /obj/item/radio/headset/headset_cent/alt
	glasses = /obj/item/clothing/glasses/night
	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/color/black
	implants = list(/obj/item/organ/cyberimp/eyes/hud/security)
	head = /obj/item/clothing/head/rabbit_helmet/raven/grunt
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/raven
	belt = /obj/item/ego_weapon/city/rabbit_blade/raven
	r_pocket = /obj/item/pinpointer/nuke/rcorp
	backpack_contents = list(
		/obj/item/grenade/smokebomb = 1)

/datum/outfit/job/raven/ert/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/implant/sanity_death/L = new/obj/item/implant/sanity_death(H)
	L.implant(H, null, 1)
	H.faction |= "rabbit"
	..()

/datum/outfit/centcom/ert/commander/rabbit
	name = "Rabbit Team Leader"

	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	head = /obj/item/clothing/head/rabbit_helmet
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit
	suit_store = /obj/item/gun/energy/e_gun/rabbit
	glasses = /obj/item/clothing/glasses/hud/health/night
	belt = /obj/item/ego_weapon/city/rabbit_blade
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1)
	r_pocket = /obj/item/melee/classic_baton/telescopic

/datum/outfit/centcom/ert/commander/rabbit/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/implant/sanity_death/L = new/obj/item/implant/sanity_death(H)
	L.implant(H, null, 1)
	H.faction |= "rabbit"
	..()

/datum/outfit/centcom/ert/security/rabbit
	name = "Rabbit Team"

	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	head = /obj/item/clothing/head/rabbit_helmet/grunt
	suit = /obj/item/clothing/suit/armor/ego_gear/rabbit/grunts
	suit_store = /obj/item/gun/energy/e_gun/rabbit
	glasses = /obj/item/clothing/glasses/hud/health/night
	belt = /obj/item/ego_weapon/city/rabbit_blade
	r_pocket = /obj/item/melee/classic_baton/telescopic
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1)

/datum/outfit/centcom/ert/security/rabbit/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/implant/sanity_death/L = new/obj/item/implant/sanity_death(H)
	L.implant(H, null, 1)
	H.faction |= "rabbit"
	..()

/datum/outfit/centcom/ert/commander/rhino
	name = "Rhino Team Leader"

	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	suit = null
	suit_store = null
	glasses = /obj/item/clothing/glasses/hud/health/night
	back = /obj/item/storage/backpack/ert/engineer
	belt = /obj/item/storage/belt/utility/full
	l_pocket = null
	r_pocket = null
	backpack_contents = list(/obj/item/storage/box/survival/engineer=1)

/datum/outfit/centcom/ert/commander/rhino/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/implant/sanity_death/L = new/obj/item/implant/sanity_death(H)
	L.implant(H, null, 1)
	H.faction |= "rabbit"
	..()

/datum/outfit/centcom/ert/security/rhino
	name = "Rhino Team"

	uniform = /obj/item/clothing/under/suit/lobotomy/rabbit
	suit = null
	suit_store = null
	glasses = /obj/item/clothing/glasses/hud/health/night
	back = /obj/item/storage/backpack/ert/engineer
	belt = /obj/item/storage/belt/utility/full
	l_pocket = null
	r_pocket = null
	backpack_contents = list(
		/obj/item/storage/box/survival/engineer=1,
		/obj/item/clothing/glasses/welding=1
		)

/datum/outfit/centcom/ert/security/rhino/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(visualsOnly)
		return

	var/obj/item/implant/sanity_death/L = new/obj/item/implant/sanity_death(H)
	L.implant(H, null, 1)
	H.faction |= "rabbit"
	..()

/datum/outfit/zwei_shield
	name = "Zwei Shield"

	id = /obj/item/card/id/ert/zwei_shield
	uniform = /obj/item/clothing/under/rank/civilian/curator/zwei_shield
	suit = /obj/item/clothing/suit/armor/ego_gear/city/zwei/noreq
	shoes = /obj/item/clothing/shoes/combat/merc
	gloves = /obj/item/clothing/gloves/combat
	ears = /obj/item/radio/headset/headset_cent/alt
	l_hand = /obj/item/ego_weapon/city/zweihander/noreq
	r_hand = /obj/item/clothing/accessory/lawyers_badge/fixer
	l_pocket = /obj/item/reagent_containers/hypospray/medipen/salacid
	r_pocket = /obj/item/reagent_containers/hypospray/medipen/mental
	implants = list(/obj/item/implant/mindshield, /obj/item/organ/cyberimp/eyes/hud/security)

/datum/outfit/zwei_shield/veteran
	name = "Zwei Veteran Shield"

	suit = /obj/item/clothing/suit/armor/ego_gear/city/zweivet/noreq
	id = /obj/item/card/id/ert/zwei_shield/veteran
	head = /obj/item/clothing/head/beret/sec/zwei
	glasses = /obj/item/clothing/glasses/sunglasses
	l_hand = /obj/item/ego_weapon/city/zweihander/vet/noreq


/datum/outfit/zwei_shield/captain
	name = "Zwei Shield Captain"
	suit = /obj/item/clothing/suit/armor/ego_gear/city/zweileader/noreq
	id = /obj/item/card/id/ert/zwei_shield/captain
	head = /obj/item/clothing/head/zwei
	glasses = /obj/item/clothing/glasses/hud/health/sunglasses
	l_hand = /obj/item/ego_weapon/city/zweihander/vet/noreq
