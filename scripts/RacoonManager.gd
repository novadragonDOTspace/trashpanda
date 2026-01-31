class_name RacoonManager
extends Node

@export
var trash_sources: TrashSourceDataContainer
@export
var game_state: GameState
var racoon_template = preload("res://scenes/Presentation/Racoon.tscn")
@export
var racoon_start: Node2D
@export
var racoon_targets: Array[Node2D]
@export
var racoon_container: Node
var racoons: Array[Racoon] = []
var speed_upgrade_counts: Array[int] = []
var strength_upgrade_counts: Array[int] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_add_racoon(0)
func _add_racoon(target_index: int) -> void:
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
func get_next_racoon_cost(trash_index: int) -> Big:
	var count = count_racoons_per_trash(trash_index)
	return trash_sources.calculate_next_costs(trash_index, count, Big.new(1), Big.new(115))
func buy_racoon(target_index: int) -> void:
	var cost = get_next_racoon_cost(target_index)
	if cost.isLessThanOrEqualTo(game_state.current_amount):
		game_state.deduce_amount(cost)
		_add_racoon(target_index)
func count_racoons_per_trash(trash_index: int) -> Big:
	var result = Big.new(0);
	for racoon in racoons:
		if racoon.trash_source_index == trash_index:
			result = result.plus(1)
	return result

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
	var percentage = 1 - racoon.remaining_distance / racoon.current_total_distance
	if racoon.returning:
		percentage = 1 - percentage
	var start = racoon_start.global_position
	var end = racoon.current_target.global_position
	var now = start * (1 - percentage) + end * percentage
	racoon.global_position = now

func _get_racoon_target_wait_duration(racoon: Racoon) -> Big:
	if racoon.trash_source_index >= 0 && racoon.trash_source_index < trash_sources.entries.size():
		return trash_sources.entries[racoon.trash_source_index].get_trash_collection_delay_base()
	return Big.new(0)
func _get_racoon_deliver_wait_duration(racoon: Racoon) -> Big:
	if racoon.trash_source_index >= 0 && racoon.trash_source_index < trash_sources.entries.size():
		return trash_sources.entries[racoon.trash_source_index].get_trash_delivery_delay_base()
	return Big.new(0)

func _calculate_collected_tash(racoon: Racoon) -> Big:
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
						racoon.carried_trash = _calculate_collected_tash(racoon)
					racoon.returning = !racoon.returning
					racoon.remaining_distance += (racoon.current_target.global_position - racoon_start.global_position).length()
					racoon.flip_sprites()

		_update_racoon_position(racoon)
