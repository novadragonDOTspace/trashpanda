class_name GameState
extends Node

@export
var currencies: CurrencyDataContainer

signal amount_changed(amount: Big)
signal production_changed(amount: Big)
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
	count_changed.emit(index, get_building_count(index))
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
	amount_changed.emit(current_amount)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	advance_seonds(Big.new(delta))

func debug_advance_seonds(seconds: int):
	current_amount = current_amount.plus(current_production.multiply(seconds))
	amount_changed.emit(current_amount)
func advance_seonds(seconds: Big):
	current_amount = current_amount.plus(current_production.multiply(seconds))
	amount_changed.emit(current_amount)

func buy_building(building_index: int, count: Big) -> void:
	var cost = calculate_next_costs(building_index, count)
	if current_amount.isGreaterThanOrEqualTo(cost):
		current_amount = current_amount.minus(cost)
		amount_changed.emit(current_amount)
		increment_building_count(building_index, count)
		_recalc_production()
		_trigger_cost_change(building_index)

func debug_add_max_dung_beetles():
	var count = current_amount.divide(currencies.get_cost(0))
	current_amount = current_amount.minus(currencies.get_cost(0).multiply(count))
	increment_building_count(0, count)
	_recalc_production()


func _recalc_production():
	current_production = Big.new(0)
	for i in range(runtime_currencies.size()):
		current_production = current_production.plus(get_building_count(i).multiply(currencies.get_production(i)))
	production_changed.emit(current_production)
