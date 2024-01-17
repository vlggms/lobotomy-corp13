//Announcement tablet
/obj/item/announcementmaker
	name = "r-corp announcement tablet"
	icon = 'icons/obj/modular_tablet.dmi'
	icon_state = "rcorp"
	var/box_title = "R-Corp Announcement"
	var/announcement_message

/obj/item/announcementmaker/attack_self(mob/living/user)
	..()
	var/input = stripped_input(user,"What do you want announce?", ,"[box_title]")
	announcement_message = "Announcement from: [user.name]"
	minor_announce("[input]" , "[announcement_message]")

/obj/item/announcementmaker/captain
	name = "captain announcement tablet"
	icon_state = "lcorp"
	box_title = "Captain Announcement"

/obj/item/announcementmaker/warp
	name = "warp lieutenant announcement tablet"
	icon_state = "wcorp"
	box_title = "L2-LT Announcement"
