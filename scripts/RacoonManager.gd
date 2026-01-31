extends Node

@export
var game_state: GameState
var racoon_template = preload("res://scenes/Presentation/Racoon.tscn")
@export
var racoon_start: Node2D
@export
var racoon_target: Node2D
@export
var racoon_container: Node
var racoons: Array[Racoon] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var racoon = racoon_template.instantiate() as Racoon;
	if racoon != null:
		racoon_container.add_child(racoon)
		racoons.append(racoon)
		racoon.global_position = racoon_start.global_position
		racoon.current_target = racoon_target
		racoon.current_total_distance = (racoon.current_target.global_position - racoon_start.global_position).length()
		racoon.remaining_distance = racoon.current_total_distance

func _update_racoon_position(racoon: Racoon) -> void:
	var percentage = 1 - racoon.remaining_distance / racoon.current_total_distance
	if racoon.returning:
		percentage = 1 - percentage
	var start = racoon_start.global_position
	var end = racoon.current_target.global_position
	var now = start * (1 - percentage) + end * percentage
	racoon.global_position = now

func _get_racoon_target_wait_duration(racoon: Racoon) -> float:
	# TODO replace with correct wait time
	return 5
func _get_racoon_deliver_wait_duration(racoon: Racoon) -> float:
	# TODO replace with correct wait time
	return 1

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
					if racoon.returning:
						racoon.remaining_wait_duration = _get_racoon_deliver_wait_duration(racoon)
					else:
						racoon.remaining_wait_duration = _get_racoon_target_wait_duration(racoon)
					remaining_delta -= step_size / racoon.current_movement_speed
			else:
				if remaining_delta < racoon.remaining_wait_duration:
					racoon.remaining_wait_duration -= remaining_delta
					remaining_delta = 0
				else:
					remaining_delta -= racoon.remaining_wait_duration
					racoon.remaining_wait_duration = 0
					racoon.is_waiting = false
					if racoon.returning:
						# TODO(rw): handle successful return
						game_state.add_amount(Big.new(1))
						pass
					racoon.returning = !racoon.returning
					racoon.remaining_distance += (racoon.current_target.global_position - racoon_start.global_position).length()
		_update_racoon_position(racoon)
