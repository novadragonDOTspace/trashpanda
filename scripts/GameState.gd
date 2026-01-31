class_name GameState
extends Node

@export
var debug_label: Label
@export
var currencies: CurrencyDataContainer

var current_amount: Big = Big.new(150)
var current_production: Big = Big.new(0)
# var dung_beetle_count: Big = Big.new(0)
# var debug_dung_beetle_cost = Big.new(100)
# var debug_dung_beetle_production: Big = Big.new(10)

var runtime_currencies: Array[RuntimeCurrencyEntry] = []

class RuntimeCurrencyEntry:
	var count: Big = Big.new(0)

func get_building_count(index: int) -> Big:
	if index >= 0 && index < runtime_currencies.size():
		return runtime_currencies[index].count
	return Big.new(0)

func set_building_count(index: int, count: Big) -> void:
	while index >= runtime_currencies.size():
		runtime_currencies.append(RuntimeCurrencyEntry.new())
	runtime_currencies[index].count = count
func increment_building_count(index: int, count: Big) -> void:
	var existing = get_building_count(index)
	set_building_count(index, existing.plus(count))

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
	var cost = calculate_next_costs(currencies.get_cost(0), get_building_count(0), count, Big.new(115))
	if current_amount.isGreaterThanOrEqualTo(cost):
		current_amount = current_amount.minus(cost)
		increment_building_count(0, count)
		_recalc_production()
		debug_update_label()


func debug_add_1_dung_beetle():
	debug_add_dung_beetles(Big.new(1))


func debug_add_max_dung_beetles():
	var count = current_amount.divide(currencies.get_cost(0))
	current_amount = current_amount.minus(currencies.get_cost(0).multiply(count))
	increment_building_count(0, count)
	_recalc_production()
	debug_update_label()


func debug_update_label():
	if debug_label != null:
		var next_dung_beetle_cost = calculate_next_costs(currencies.get_cost(0), get_building_count(0), Big.new(1), Big.new(115))
		debug_label.text = "amount: %s\nproduction: %s\ndung beetles: %s\ndung beetle cost: %s" % \
		[
			format_big_number(current_amount),
			format_big_number(current_production),
			format_big_number(get_building_count(0)),
			format_big_number(next_dung_beetle_cost),
		]


func _recalc_production():
	current_production = get_building_count(0).multiply(currencies.get_production(0))
