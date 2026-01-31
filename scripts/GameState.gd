class_name GameState
extends Node

@export
var trash_sources: TrashSourceDataContainer

signal amount_changed(amount: Big)
signal cost_changed(index: int, new_cost: Big)
signal count_changed(index: int, new_count: Big)

signal visualize_new_trash(amount: Big)

var current_amount: Big = Big.new(150)

var latest_unlocked_racoon: int = 1

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

func _trigger_cost_change(building_index: int) -> void:
	cost_changed.emit(building_index, calculate_next_costs(building_index, Big.new(1)))
func calculate_next_costs(building_index: int, count: Big) -> Big:
	return trash_sources.calculate_next_costs(building_index, get_building_count(building_index), count, Big.new(115))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	amount_changed.emit(current_amount)

func add_amount_with_popup(amount: Big) -> void:
	current_amount = current_amount.plus(amount)
	amount_changed.emit(current_amount)
	visualize_new_trash.emit(amount)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func buy_building(building_index: int, count: Big) -> void:
	var cost = calculate_next_costs(building_index, count)
	if current_amount.isGreaterThanOrEqualTo(cost):
		current_amount = current_amount.minus(cost)
		amount_changed.emit(current_amount)
		increment_building_count(building_index, count)
		_trigger_cost_change(building_index)
