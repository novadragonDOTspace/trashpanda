class_name TrashSourceDataEntry
extends Resource

@export
var display_name: String
@export
var base_price_mantissa: int
@export
var base_price_exponent: int

@export
var production_mantissa: int
@export
var production_exponent: int

@export
var trash_collection_delay_base_mantissa: int
@export
var trash_collection_delay_base_exponent: int
@export
var trash_delivery_delay_base_mantissa: int
@export
var trash_delivery_delay_base_exponent: int

func _get_big_from_separate_values(mantissa: int, exponent: int) -> Big:
	return Big.new(mantissa).multiply(Big.new(10).power(exponent))

func get_cost() -> Big:
	return _get_big_from_separate_values(base_price_mantissa, base_price_exponent)
func get_production() -> Big:
	return _get_big_from_separate_values(production_mantissa, production_exponent)
func get_trash_collection_delay_base() -> Big:
	return _get_big_from_separate_values(trash_collection_delay_base_mantissa, trash_collection_delay_base_exponent)
func get_trash_delivery_delay_base() -> Big:
	return _get_big_from_separate_values(trash_delivery_delay_base_mantissa, trash_delivery_delay_base_exponent)
