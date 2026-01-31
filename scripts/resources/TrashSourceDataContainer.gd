class_name TrashSourceDataContainer
extends Resource

@export
var entries: Array[TrashSourceDataEntry]

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

func _times_percent_power(value: Big, percent: Big, exponent) -> Big:
	var precision = Big.new(1000000)
	var hundred = Big.new(100)
	var result = value.multiply(precision)
	for i in BigRange.new(Big.new(0), exponent):
		result = result.multiply(percent).divide(hundred)
	return result.divide(precision)
func calculate_next_costs(
	building_index: int,
	skipped: Big,
	count: Big,
	increment_percent: Big
) -> Big:
	var base_cost = get_cost(building_index)
	if count.isLessThanOrEqualTo(Big.new(0)):
		return Big.new(0)
	var cost = base_cost
	var hundred = Big.new(100)
	cost = _times_percent_power(cost, increment_percent, skipped)
	#for i in BigRange.new(Big.new(0),skipped):
	#cost = cost.multiply(increment_percent).divide(hundred)
	var result = Big.new(0)
	for i in BigRange.new(Big.new(0), count):
		result = result.plus(cost)
		cost = cost.multiply(increment_percent).divide(hundred)
	return result
