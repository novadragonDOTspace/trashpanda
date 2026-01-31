class_name GameState
extends Node

static var SUFFIXES = [
	"k",
	"Mio",
	"Bio",
	"Trio",
	"Quad",
	"Quint",
	"Sext",
	"Sept",
	"Oct",
	"Non",
	"Dec",
	"Undec",
	"Duodec",
]

@export var debug_label: Label

var current_amount: BigCat.BigNumber = BigCat.BigNumber.from_int(150)
var current_production: BigCat.BigNumber = BigCat.BigNumber.ZERO
var dung_beetle_count: BigCat.BigNumber = BigCat.BigNumber.ZERO
var debug_dung_beetle_cost = BigCat.BigNumber.from_int(100)
var debug_dung_beetle_production: BigCat.BigNumber = BigCat.BigNumber.from_int(10)


static func times_percent_power(value: BigCat.BigNumber, percent: BigCat.BigNumber, exponent) -> BigCat.BigNumber:
	var precision = BigCat.BigNumber.from_int(1000000)
	var hundred = BigCat.BigNumber.from_int(100)
	var result = value.multiply(precision)
	for i in BigNumberRange.new(BigCat.BigNumber.ZERO, exponent):
		result = result.multiply(percent).divide(hundred)
	return result.divide(precision)


static func calculate_next_costs(base_cost: BigCat.BigNumber, skipped: BigCat.BigNumber, count: BigCat.BigNumber, increment_percent: BigCat.BigNumber) -> BigCat.BigNumber:
	if count.is_less_than_or_equal_to(BigCat.BigNumber.ZERO):
		return BigCat.BigNumber.ZERO
	var cost = base_cost
	var hundred = BigCat.BigNumber.from_int(100)
	cost = times_percent_power(cost, increment_percent, skipped)
	#for i in BigNumberRange.new(BigCat.BigNumber.ZERO,skipped):
	#cost = cost.multiply(increment_percent).divide(hundred)
	var result = BigCat.BigNumber.ZERO
	for i in BigNumberRange.new(BigCat.BigNumber.ZERO, count):
		result = result.add(cost)
		cost = cost.multiply(increment_percent).divide(hundred)
	return result


static func format_big_number(number: BigCat.BigNumber) -> String:
	var thousand = BigCat.BigNumber.from_int(1000)
	if number.is_less_than(thousand) or true:
		return number.to_string()
	var original = number
	var suffixIndex = 0
	var threshold = BigCat.BigNumber.from_int(1000000)
	while number.is_greater_than_or_equal_to(threshold):
		number = number.divide(thousand)
		suffixIndex += 1
	if suffixIndex < len(SUFFIXES):
		var as_string = number.divide(BigCat.BigNumber.from_int(10)).to_string()
		var length = len(as_string)
		return as_string.substr(0, length - 2) + "." + as_string.substr(length - 2, length) + " " + SUFFIXES[suffixIndex]
	return original.to_string()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_recalc_production()
	debug_update_label()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func debug_advance_seonds(seconds: int):
	current_amount = current_amount.add(current_production.multiply_int(seconds))
	debug_update_label()


func debug_add_dung_beetles(count: BigCat.BigNumber):
	var cost = calculate_next_costs(debug_dung_beetle_cost, dung_beetle_count, count, BigCat.BigNumber.from_int(115))
	if current_amount.is_greater_than_or_equal_to(cost):
		current_amount = current_amount.subtract(cost)
		dung_beetle_count = dung_beetle_count.add(count)
		_recalc_production()
		debug_update_label()


func debug_add_1_dung_beetle():
	debug_add_dung_beetles(BigCat.BigNumber.ONE)


func debug_add_max_dung_beetles():
	var count = current_amount.divide(debug_dung_beetle_cost)
	current_amount = current_amount.subtract(debug_dung_beetle_cost.multiply(count))
	dung_beetle_count = dung_beetle_count.add(count)
	_recalc_production()
	debug_update_label()


func debug_update_label():
	if debug_label != null:
		var next_dung_beetle_cost = BigCat.BigNumber.from_int(-1)
		#var next_dung_beetle_cost = calculate_next_costs(debug_dung_beetle_cost, dung_beetle_count, BigCat.BigNumber.ONE, BigCat.BigNumber.from_int(115))
		debug_label.text = "amount: %s\nproduction: %s\ndung beetles: %s\ndung beetle cost: %s" % [format_big_number(current_amount), format_big_number(current_production), format_big_number(dung_beetle_count), format_big_number(next_dung_beetle_cost)]


func _recalc_production():
	# TODO(rw): implement
	current_production = dung_beetle_count.multiply(debug_dung_beetle_production)
