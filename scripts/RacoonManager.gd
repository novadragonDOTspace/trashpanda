class_name RacoonManager
extends Node

@export
var trash_sources: TrashSourceDataContainer
@export
var upgrade_data: RacoonUpgradeDataContainer
@export
var game_state: GameState
var racoon_template = preload("res://scenes/Presentation/Racoon.tscn")
@export
var racoon_start: Node2D
@export
var delivery_point: Node2D
@export
var racoon_targets: Array[Node2D]
@export
var collection_points: Array[Node2D]
@export
var racoon_container: Node
var racoons: Array[Racoon] = []
var speed_upgrade_counts: Array[int] = []
var strength_upgrade_counts: Array[int] = []
var max_level: int = 1

signal racoon_count_changed(trash_index: int, count: Big)
signal racoon_price_changed(trash_index: int, price: Big)
signal strength_level_changed(trash_index: int, level: Big, price: Big)
signal speed_level_changed(trash_index: int, level: Big, price: Big)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_add_racoon(0, 1)
	var zero = Big.new(0)
	for i in range(trash_sources.entries.size()):
		racoon_price_changed.emit(i, get_next_racoon_cost_by_count(i, zero))
		strength_level_changed.emit(i, Big.new(i + 3), Big.new(i + 10))
		speed_level_changed.emit(i, Big.new(i + 5), Big.new(i + 8))
	_recount_all_racoons()
func _add_racoon(target_index: int, level: int) -> void:
	if target_index >= 0 and target_index < racoon_targets.size() and target_index < trash_sources.entries.size():
		var racoon = racoon_template.instantiate() as Racoon;
		if racoon != null:
			racoon_container.add_child(racoon)
			racoons.append(racoon)
			racoon.trash_source_index = target_index
			racoon.global_position = racoon_start.global_position
			racoon.current_target = racoon_targets[target_index]
			racoon.current_total_distance = (racoon.current_target.global_position - racoon_start.global_position).length()
			racoon.remaining_distance = racoon.current_total_distance
			racoon.level = level
			_apply_racoon_level(racoon)
func _remove_racoon(racoon: Racoon) -> void:
	var index = racoons.find(racoon)
	if index >= 0:
		racoons.remove_at(index)
		racoon.queue_free()
func _remove_racoons(trash_index: int, level: int, count: int) -> void:
	var filtered_racoons = racoons.filter(func(racoon): return racoon.trash_source_index == trash_index and racoon.level == level)
	if filtered_racoons.size() > count:
		filtered_racoons.resize(count)
	for racoon in filtered_racoons:
		_remove_racoon(racoon)
func _apply_racoon_level(racoon: Racoon) -> void:
	var level = racoon.level
	var scale_factor = 1.0
	var strength_factor = 1.0
	var speed_factor = 1.0
	for i in range(level - 1):
		var entry = upgrade_data.entries[i]
		scale_factor *= entry.scale_factor
		strength_factor *= entry.strength_factor * entry.combine_count
		speed_factor *= entry.speed_factor
	racoon.speed_factor = speed_factor
	racoon.strength_factor = strength_factor
	racoon.set_scale_factor(scale_factor)
func _recount_all_racoons() -> void:
	var counts: Array[Big] = []
	var count_multipliers: Array[Big] = [Big.new(1)]
	for racoon in racoons:
		var index = racoon.trash_source_index
		var level = racoon.level
		var level_index = level - 1
		while index >= counts.size():
			counts.append(Big.new(0))
		while level_index >= count_multipliers.size():
			var new_level = count_multipliers.size()
			var multiplier = count_multipliers[new_level - 1].multiply(upgrade_data.entries[new_level - 1].combine_count if new_level - 1 < upgrade_data.entries.size() else 1)
			count_multipliers.append(multiplier)
		counts[index] = counts[index].plus(count_multipliers[level_index])
	for i in range(counts.size()):
		var count = counts[i]
		racoon_count_changed.emit(i, count)
		racoon_price_changed.emit(i, get_next_racoon_cost_by_count(i, count))

func _get_collection_position(trash_index: int) -> Vector2:
	if trash_index >= 0:
		if trash_index < collection_points.size():
			return collection_points[trash_index].global_position
		elif trash_index < racoon_targets.size():
			return racoon_targets[trash_index].global_position
	return Vector2(0, 0)

func get_next_racoon_cost(trash_index: int) -> Big:
	# TODO(rw): count_racoons_per_trash doesn't consider the combine_count and underreports the count
	var count = count_racoons_per_trash(trash_index)
	return trash_sources.calculate_next_costs(trash_index, count, Big.new(1), Big.new(115))
func get_next_racoon_cost_by_count(trash_index: int, count: Big) -> Big:
	return trash_sources.calculate_next_costs(trash_index, count, Big.new(1), Big.new(115))
func buy_racoon(target_index: int) -> void:
	var cost = get_next_racoon_cost(target_index)
	cost = Big.new(0)
	if cost.isLessThanOrEqualTo(game_state.current_amount):
		game_state.deduce_amount(cost)
		_add_racoon(target_index, 1)
		check_and_upgrade_racoons(target_index)
func count_racoons_per_trash(trash_index: int) -> Big:
	# TODO(rw): this doesn't consider the combine_count and underreports the count
	var result = Big.new(0);
	for racoon in racoons:
		if racoon.trash_source_index == trash_index:
			result = result.plus(1)
	return result
func check_and_upgrade_racoons(trash_index: int) -> void:
	var filtered_racoons = racoons.filter(func(racoon): return racoon.trash_source_index == trash_index)
	for level in range(1, min(max_level + 1, upgrade_data.entries.size() + 1)):
		var racoons_on_level = filtered_racoons.filter(func(racoon): return racoon.level == level)
		var combine_count = upgrade_data.entries[level - 1].combine_count
		var new_count = racoons_on_level.size() / upgrade_data.entries[level - 1].combine_count
		if new_count > 0:
			_remove_racoons(trash_index, level, new_count * combine_count)
			for i in range(new_count):
				_add_racoon(trash_index, level + 1)
			filtered_racoons = racoons.filter(func(racoon): return racoon.trash_source_index == trash_index)
			max_level = max(max_level, level + 1)
	_recount_all_racoons()
func _safe_get_from_array(index: int, array: Array[int], fallback: int = 0) -> int:
	if index >= 0 and index < array.size():
		return array[index]
	return fallback
func _safe_set_in_array(index: int, array: Array[int], value: int, default: int = 0) -> void:
	if index >= 0:
		while index >= array.size():
			array.append(default)
		array[index] = value
func _safe_increment_in_array(index: int, array: Array[int], increment: int, default: int = 0) -> void:
	_safe_set_in_array(index, array, _safe_get_from_array(index, array) + increment, default)
func get_speed_upgrade_count(trash_index: int) -> int:
	return _safe_get_from_array(trash_index, speed_upgrade_counts)
func increment_speed_upgrade_count(trash_index: int, increment: int = 1) -> void:
	_safe_increment_in_array(trash_index, speed_upgrade_counts, increment)
func get_strength_upgrade_count(trash_index: int) -> int:
	return _safe_get_from_array(trash_index, speed_upgrade_counts)
func increment_strength_upgrade_count(trash_index: int, increment: int = 1) -> void:
	_safe_increment_in_array(trash_index, speed_upgrade_counts, increment)

func _update_racoon_position(racoon: Racoon) -> void:
	var new_position: Vector2 = Vector2(0, 0)
	if racoon.is_waiting:
		if !racoon.returning:
			new_position = _get_collection_position(racoon.trash_source_index)
		else:
			new_position = delivery_point.global_position
	else:
		var percentage = 1 - racoon.remaining_distance / racoon.current_total_distance
		if racoon.returning:
			percentage = 1 - percentage
		var start = racoon_start.global_position
		var end = racoon.current_target.global_position
		new_position = start * (1 - percentage) + end * percentage
	racoon.global_position = new_position

func _get_racoon_target_wait_duration(racoon: Racoon) -> Big:
	if racoon.trash_source_index >= 0 && racoon.trash_source_index < trash_sources.entries.size():
		return trash_sources.entries[racoon.trash_source_index].get_trash_collection_delay_base()
	return Big.new(0)
func _get_racoon_deliver_wait_duration(racoon: Racoon) -> Big:
	if racoon.trash_source_index >= 0 && racoon.trash_source_index < trash_sources.entries.size():
		return trash_sources.entries[racoon.trash_source_index].get_trash_delivery_delay_base()
	return Big.new(0)

func _calculate_collected_trash(racoon: Racoon) -> Big:
	return Big.new(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for racoon in racoons:
		var remaining_delta = delta
		while remaining_delta > 0:
			if !racoon.is_waiting:
				var step_size = remaining_delta * racoon.current_movement_speed
				if step_size < racoon.remaining_distance:
					racoon.remaining_distance -= step_size
					remaining_delta = 0
				else:
					racoon.remaining_distance = 0
					racoon.is_waiting = true
					racoon.remaining_wait_duration = _get_racoon_deliver_wait_duration(racoon) if racoon.returning else _get_racoon_target_wait_duration(racoon)
					remaining_delta -= step_size / racoon.current_movement_speed
				
					racoon.play("trash_digging")
				
			else:
				if remaining_delta < racoon.remaining_wait_duration.toFloat():
					racoon.remaining_wait_duration = racoon.remaining_wait_duration.minus(remaining_delta)
					remaining_delta = 0
				else:
					remaining_delta -= racoon.remaining_wait_duration.toFloat()
					racoon.remaining_wait_duration = Big.new(0)
					racoon.is_waiting = false
					if racoon.returning:
						game_state.add_amount_with_popup(racoon.carried_trash)
						racoon.play("walk")
						racoon.carried_trash = Big.new(0)
					else:
						racoon.play("trashwalk")
						racoon.carried_trash = _calculate_collected_trash(racoon)
					racoon.returning = !racoon.returning
					racoon.remaining_distance += (racoon.current_target.global_position - racoon_start.global_position).length()
					racoon.flip_sprites()

		_update_racoon_position(racoon)
