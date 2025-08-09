/proc/count_set_bits_decimal(a)
	. = 0
	var/b = a // is proc parameters pointers? who knows
	while(b)
		b &= (b-1)
		.++
