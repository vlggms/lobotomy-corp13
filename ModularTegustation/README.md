	[PLEASE KEEP YOUR CODE AS MODULAR AS POSSIBLE]

Keep edits in the TegustationModular folder WHENEVER POSSIBLE. This is to prevent merge conflicts when we update with /TG/.

	// Notes to help against merge conflicts \\

////////////////////////////////////////////////////////////////////////////////////////////////////////////

Situation: WHEN ADDING ONTO TG CODE

Practice: Add a note saying '// Tegustation [PR name] edit: (reason for edit)' (Dont forget to write at the bottom of this README the name and what the PR is)

Reason: So we can find all code used for a specific PR when needed to rework/maintain/read/remove it.

Example: 

	load_mentors()

-turns into-

	load_mentors() // Tegustation Mentorhelp edit: Load the mentors!

////////////////////////////////////////////////////////////////////////////////////////////////////////////

Situation: WHEN ADDING SOMETHING ON TOP OF TEGU-ONLY CODE ON TG FILES THAT ALREADY HAS A NOTE

Practice: Add a note saying it is also used in your PR as well

Reason: We can easily search up both PRs in case we need to go back to maintain/read/remove a specific part of it

Example:

	// Tegustation Deputy edit: Adds huds

-turns into-

	// Tegustation Deputy edit: + // Tegustation Brig Doc edit: Adds huds

////////////////////////////////////////////////////////////////////////////////////////////////////////////

Situation: WHEN ADDING AN ITEM TO A VENDING MACHINE/LOCKER

Practice: Initialize the Vending Machine/Locker in a separate Tegu file, adding it onto there.

Reason: It adds it to the locker/vending machine without the need to touch the TG file itself

Example:

	/obj/structure/closet/secure_closet/chief_medical/PopulateContents()

		..()
	
		new /obj/item/clothing/neck/cloak/cmo(src)
	
		new /obj/item/insert_tegu_item_here
	
		new /obj/item/clothing/suit/bio_suit/cmo(src)

-turns into-

	/obj/structure/closet/secure_closet/chief_medical/PopulateContents()

		..()
	
		new /obj/item/clothing/neck/cloak/cmo(src)

>On a separate file in ModularTegustation called 'vendor_container_init.dm'

	/obj/structure/closet/secure_closet/chief_medical/Initialize()

  	  new /obj/item/insert_tegu_item_here
	
  	  . = ..()

===> IF THIS IS NOT POSSIBLE DUE TO /TG/ ALREADY USING THE POPULATECONTENTS PROC, USE THE EXAMPLE BELOW <===

Practice: Don't add it to the very end of the list. Add it second to last whenever possible.

Reason: Next time TG adds to the list, they'll add to the bottom. This results in a conflict, because they're changing the last line of the list, which you've altered.
By putting it just above that, their additions to the list will not conflict with yours.

Example:

	var/list/whatever = list(/obj/item/tg_item1,

     	                 /obj/item/tg_item2,
					  
     	                 /obj/item/tg_item3)

-turns into-

	var/list/whatever = list(/obj/item/tg_item1,

         	             /obj/item/tg_item2,
					  
           	           /obj/item/tegu_item1, // Tegustation Clothing edit: Adding the clothing to vending machines
					  
          	            /obj/item/tegu_item2, // Tegustation Clothing edit: adding the clothing to vending machines
					  
          	            /obj/item/tg_item3)

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////

Situation: WHEN REPLACING TG CODE (How something should act, starting gear, ect)

Practice: Comment out the TG code, then have your code under it, with the '// Tegustation edit' note'

Reason: If TG goes back to edit it, it will edit the commented out code, rather than your own
This way, it won't conflict with what we've changed.

Example:

	/datum/outfit/job/cmo

		id = /obj/item/card/id/silver
	
		belt = /obj/item/pda/heads/cmo

-turns into-

	/datum/outfit/job/cmo
		id = /obj/item/card/id/silver
	
	//	belt = /obj/item/pda/heads/cmo

		belt = /obj/item/storage/belt/medical/surgeryfilled // Tegustation CMO updates edit: Gives them a filled surgery belt

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////

List of things to be done:

- Change Tegu-only Medical code (I'd like unhusking to be moved || Tend Wound surgery unhusks -> Unhusk Surgery)
- 
- Remove/Update Tegu-only borg things (Dont do this yet, there will likely have a vote on the Discord on whether these changes should happen!)
- 
- Balance or remove T5 parts
- 
- Fix bodycams (If these are really broken)
- 
- Fix Haunted dice (Curator only traitor item, it's supposed to ask ghosts a question, but it doesnt let ghosts actually answer it)

Codewords to search PRs by:

// Tegustation Deputy - Deputies

// Tegustation Beefmen - Beefmen

// Tegustation Infiltration - Infiltrators

// Tegustation TerraGov - TerraGov events + encryption keys

// Tegustation Mentorhelp - Mentors/Mentorhelp

// Tegustation Security Updates - Security gear updates

// Tegustation Detective Kit - Improved detective gear

// Tegustation Sith - Curator/Chaplain sith kit

// Tegustation digitigrade - Lizard digitigrade support

// Tegustation Mediborg Improvements - Mediborg improvements

// Tegustation Bodycameras - Security bodycameras

// Tegustation Secborg - Secborg changes

// Tegustation Husking - Tend wound unhusking (Set to be removed, read the text above for more!)

// Tegustation Languages - Language books

// Tegustation T5 parts - T5 parts

// Tegustation Clothing - Vending machine clothes

// Tegustation Xenobiology Black Crossbreeds - Transformative(Black) slime crossbreed extracts

// Tegustation Heads of Staff - Heads of staff eguns + CMO surgerybelt

// Tegustation Space Exploration - Stuff for space explorers/miners edits.

// Tegustation Prosthetic limbs - Prosthetic limbs

