/datum/component/pricetag
	var/datum/bank_account/owner
	var/profit_ratio = 1

/datum/component/pricetag/Initialize(_owner,_profit_ratio)
	if(!isobj(parent))	//Has to account for both objects and sellable structures like crates.
		return COMPONENT_INCOMPATIBLE
	owner = _owner
	if(_profit_ratio)
		profit_ratio = _profit_ratio
	RegisterSignal(parent, list(COMSIG_ITEM_SOLD), PROC_REF(split_profit))
	RegisterSignal(parent, list(COMSIG_STRUCTURE_UNWRAPPED, COMSIG_ITEM_UNWRAPPED), PROC_REF(Unwrapped))
	RegisterSignal(parent, list(COMSIG_ITEM_SPLIT_PROFIT, COMSIG_ITEM_SPLIT_PROFIT_DRY), PROC_REF(return_ratio))

/datum/component/pricetag/proc/Unwrapped()
	SIGNAL_HANDLER

	qdel(src) //Once it leaves it's wrapped container, the object in question should lose it's pricetag component.

/datum/component/pricetag/proc/split_profit(item_value)
	SIGNAL_HANDLER

	var/price = item_value
	if(price)
		var/adjusted_value = price*(profit_ratio/100)
		owner.adjust_money(adjusted_value)
		owner.bank_card_talk("Sale recorded. [adjusted_value] ahn added to account.")
		return TRUE

/datum/component/pricetag/proc/return_ratio()
	return profit_ratio
