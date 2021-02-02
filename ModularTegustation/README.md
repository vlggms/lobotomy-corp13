                --=[PLEASE KEEP YOUR CODE AS MODULAR AS POSSIBLE]=--
Keep edits in the TegustationModular folder as MUCH AS POSSIBLE.
==> If not possible, please put a '// Tegustation [PR name] edit: (reason for edit)' so we can find it when required. <==



//Note to help against merge conflicts://
Situation: WHEN ADDING TO A LIST (lockers, etc)

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
                      /obj/item/tegu_item1,   // TEGU
                      /obj/item/tegu_item2,   // TEGU
                      /obj/item/tg_item3)



List of things to be done:
- Maintain or remove SalChems (I only left it in so it doesnt mess with Mediborgs, but I do want them gone)
- Change Tegu-only Medical code (I'd like unhusking to be moved from Tend Wound surgery -> Its own surgery)
- Remove Tegu-only borg things (Dont do this yet, there will likely have a vote on the Discord on whether these changes should happen!)
- Balance or remove T5 parts
- Maintain or remove medal boxes (CMO's medalbox, not sure about the others)
- Import the new Halloween costumes
- Fix bodycams (Are they broken?)
- Find out what the hell TerraGov comms are (Remove if useless)
- Fix Haunted dice (Curator only traitor item, it's supposed to ask ghosts a question, but it doesnt let ghosts actually answer it)
