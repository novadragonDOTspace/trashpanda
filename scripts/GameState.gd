class_name GameState
extends Node

@export
var currencies: CurrencyDataContainer

signal debug_text_changed(text: String)
signal cost_changed(index: int, new_cost: Big)
signal count_changed(index: int, new_count: Big)

var current_amount: Big = Big.new(150)
var current_production: Big = Big.new(0)

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

static func format_big_number(number: Big) -> String:
	return number.toAA(true)
func _trigger_cost_change(building_index: int) -> void:
	cost_changed.emit(building_index, calculate_next_costs(building_index, Big.new(1)))
func calculate_next_costs(building_index: int, count: Big) -> Big:
	return currencies.calculate_next_costs(building_index, get_building_count(building_index), count, Big.new(115))

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

func buy_building(building_index: int, count: Big) -> void:
	var cost = calculate_next_costs(building_index, count)
	if current_amount.isGreaterThanOrEqualTo(cost):
		current_amount = current_amount.minus(cost)
		increment_building_count(building_index, count)
		_recalc_production()
		debug_update_label()
		_trigger_cost_change(building_index)
		count_changed.emit(building_index, get_building_count(building_index))

func debug_add_max_dung_beetles():
	var count = current_amount.divide(currencies.get_cost(0))
	current_amount = current_amount.minus(currencies.get_cost(0).multiply(count))
	increment_building_count(0, count)
	_recalc_production()
	debug_update_label()


func debug_update_label():
	var next_dung_beetle_cost = calculate_next_costs(0, Big.new(1))
	debug_text_changed.emit("amount: %s\nproduction: %s\ndung beetles: %s\ndung beetle cost: %s" % \
		[
			format_big_number(current_amount),
			format_big_number(current_production),
			format_big_number(get_building_count(0)),
			format_big_number(next_dung_beetle_cost),
		])


func _recalc_production():
	current_production = Big.new(0)
	for i in range(runtime_currencies.size()):
		current_production = current_production.plus(get_building_count(i).multiply(currencies.get_production(i)))
