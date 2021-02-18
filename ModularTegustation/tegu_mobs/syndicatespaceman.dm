/mob/living/simple_animal/hostile/syndicate/melee/sword/space/oldcode
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	icon_state = "oldcode_syndicate_csaber"
	icon_living = "oldcode_syndicate_csaber"
	name = "Syndicate Spaceman"
	desc = "Death to IS-Nanotrasen."
	maxHealth = 170
	health = 170
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	armour_penetration = 20
	light_color = LIGHT_COLOR_BLUE
	minbodytemp = 0
	speed = 1
	var/obj/effect/light_emitter/blue_energy_sword/
	projectile_deflect_chance = 10
	
/mob/living/simple_animal/hostile/syndicate/ranged/space/oldcode
	icon_state = "oldcode_syndicate_gun"
	icon_living = "oldcode_syndicate_gun"
	name = "Syndicate Spaceman"
	desc = "Death to IS-Nanotrasen."
	icon = 'ModularTegustation/Teguicons/tegumobs.dmi'
	maxHealth = 170
	health = 170
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	speed = 1
	
/obj/effect/light_emitter/blue_energy_sword/ 
	set_luminosity = 2
	set_cap = 2.5
	light_color = LIGHT_COLOR_BLUE
	
