/obj/item/workshop_mod
	name = "workshop mod"
	desc = "A workshop mod template. You should never see this!"
	icon = 'ModularTegustation/Teguicons/workshop.dmi'
	var/forcemod = 1
	var/damagemod = 1
	var/attackspeedmod = 1
	var/throwforcemod = 1
	var/aoemod = 0
	var/modname = "basic"
	var/weaponcolor = "FFFFFFF"
	var/damagetype = RED_DAMAGE
	var/specialmod
	var/overlay

/* Effects that proc on the installation of the mod.
	Remember to override this for subtypes.*/
/obj/item/workshop_mod/proc/InstallationEffect(obj/item/ego_weapon/template/T)
	return

//Effects that proc on the activation of the mod.
/obj/item/workshop_mod/proc/ActivateEffect(obj/item/ego_weapon/template/T, special_count = 0, mob/living/target, mob/living/carbon/human/user)
	return
