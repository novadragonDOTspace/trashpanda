class_name CurrencyDataContainer
extends Resource

@export
var entries: Array[CurrencyDataEntry]

func get_cost(index: int) -> Big:
	if index >= 0 && index < entries.size():
		return entries[index].get_big_cost()
	push_error("didn't find cost for index %i" % index)
	return Big.new(0)
	
func get_production(index: int) -> Big:
	if index >= 0 && index < entries.size():
		return entries[index].get_big_production()
	push_error("didn't find production for index %i" % index)
	return Big.new(0)
