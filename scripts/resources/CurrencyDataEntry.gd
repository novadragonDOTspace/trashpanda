class_name CurrencyDataEntry
extends Resource

@export
var display_name: String
@export
var base_price: int
@export
var base_price_exponent: int

@export
var production: int
@export
var production_exponent: int

func _get_big_from_separate_values(value: int, exponent: int) -> Big:
	return Big.new(value).multiply(Big.new(10).power(exponent))

func get_big_cost() -> Big:
	return _get_big_from_separate_values(base_price, base_price_exponent)
func get_big_production() -> Big:
	return _get_big_from_separate_values(production, production_exponent)
