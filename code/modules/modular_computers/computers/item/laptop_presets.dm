/obj/item/modular_computer/laptop/preset/Initialize()
	. = ..()
	install_component(new /obj/item/computer_hardware/processor_unit/small)
	install_component(new /obj/item/computer_hardware/battery(src, /obj/item/stock_parts/cell/computer))
	install_component(new /obj/item/computer_hardware/hard_drive)
	install_component(new /obj/item/computer_hardware/network_card)
	install_programs()


/obj/item/modular_computer/laptop/preset/proc/install_programs()
	return

/obj/item/modular_computer/laptop/preset/fixer
	name = "Fixer Laptop"
	desc = "A portable laptop computer often used by Fixers to view the Bounty Board Service (BBS)."


/obj/item/modular_computer/laptop/preset/fixer/install_programs()
	var/obj/item/computer_hardware/hard_drive/hard_drive = all_components[MC_HDD]
	hard_drive.store_file(new/datum/computer_file/program/chatclient())
	hard_drive.store_file(new/datum/computer_file/program/bounty_board())


/obj/item/modular_computer/laptop/preset/civilian
	desc = "A low-end laptop often used for personal recreation."


/obj/item/modular_computer/laptop/preset/civilian/install_programs()
	var/obj/item/computer_hardware/hard_drive/hard_drive = all_components[MC_HDD]
	hard_drive.store_file(new/datum/computer_file/program/chatclient())
