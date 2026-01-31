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

var current_amount: Big = Big.new(150)
var current_production: Big = Big.new(0)
var dung_beetle_count: Big = Big.new(0)
var debug_dung_beetle_cost = Big.new(100)
var debug_dung_beetle_production: Big = Big.new(10)


static func times_percent_power(value: Big, percent: Big, exponent) -> Big:
	var precision = Big.new(1000000)
	var hundred = Big.new(100)
	var result = value.multiply(precision)
	for i in BigRange.new(Big.new(0), exponent):
		result = result.multiply(percent).divide(hundred)
	return result.divide(precision)


static func calculate_next_costs(
		base_cost: Big,
		skipped: Big,
		count: Big,
		increment_percent: Big
) -> Big:
	if count.isLessThanOrEqualTo(Big.new(0)):
		return Big.new(0)
	var cost = base_cost
	var hundred = Big.new(100)
	cost = times_percent_power(cost, increment_percent, skipped)
	#for i in BigRange.new(Big.new(0),skipped):
	#cost = cost.multiply(increment_percent).divide(hundred)
	var result = Big.new(0)
	for i in BigRange.new(Big.new(0), count):
		result = result.plus(cost)
		cost = cost.multiply(increment_percent).divide(hundred)
	return result

static func format_big_number(number: Big) -> String:
	return number.toAA(true)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_recalc_production()
	debug_update_label()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func debug_advance_seonds(seconds: int):
	current_amount = current_amount.plus(current_production.multiply(seconds))
	debug_update_label()


func debug_add_dung_beetles(count: Big):
	var cost = calculate_next_costs(debug_dung_beetle_cost, dung_beetle_count, count, Big.new(115))
	if current_amount.isGreaterThanOrEqualTo(cost):
		current_amount = current_amount.minus(cost)
		dung_beetle_count = dung_beetle_count.plus(count)
		_recalc_production()
		debug_update_label()


func debug_add_1_dung_beetle():
	debug_add_dung_beetles(Big.new(1))


func debug_add_max_dung_beetles():
	var count = current_amount.divide(debug_dung_beetle_cost)
	current_amount = current_amount.minus(debug_dung_beetle_cost.multiply(count))
	dung_beetle_count = dung_beetle_count.plus(count)
	_recalc_production()
	debug_update_label()


func debug_update_label():
	if debug_label != null:
		var next_dung_beetle_cost = calculate_next_costs(debug_dung_beetle_cost, dung_beetle_count, Big.new(1), Big.new(115))
		debug_label.text = "amount: %s\nproduction: %s\ndung beetles: %s\ndung beetle cost: %s" % \
		[
			format_big_number(current_amount),
			format_big_number(current_production),
			format_big_number(dung_beetle_count),
			format_big_number(next_dung_beetle_cost),
		]


func _recalc_production():
	# TODO(rw): implement
	current_production = dung_beetle_count.multiply(debug_dung_beetle_production)
