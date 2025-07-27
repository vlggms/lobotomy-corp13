/datum/unit_test/abno_code/Run()
	var/list/codes = list()
	var/list/bad = list()
	for(var/i in subtypesof(/obj/item/paper/fluff/info))
		var/obj/item/paper/fluff/info/abno = i
		var/code = initial(abno.abno_code)
		if(code in codes)
			bad += "[i]"
			bad += "[codes[code]]"
			continue
		if(code)
			codes[code] = i
	if(!bad.len)
		return			//passed!
	Fail("The following information documents have duplicate codes.:\n[bad.Join(" ")]")
