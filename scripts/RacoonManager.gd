extends Node

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
		racoon.current_total_distance = (racoon_target.global_position - racoon_start.global_position).length()
		racoon.remaining_distance = racoon.current_total_distance

func _update_racoon_position(racoon: Racoon) -> void:
	var percentage = 1 - racoon.remaining_distance / racoon.current_total_distance
	if racoon.returning:
		percentage = 1 - percentage
	var start = racoon_start.global_position
	var end = racoon_target.global_position
	var now = start * (1 - percentage) + end * percentage
	racoon.global_position = now

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	for racoon in racoons:
		racoon.remaining_distance -= delta * racoon.current_movement_speed
		if racoon.remaining_distance < 0:
			racoon.returning = !racoon.returning
			racoon.remaining_distance += (racoon_target.global_position - racoon_start.global_position).length()
		_update_racoon_position(racoon)
