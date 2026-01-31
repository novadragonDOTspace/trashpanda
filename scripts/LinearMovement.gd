extends Node

@export
var movement_direction: Vector2 = Vector2(0, -1)
@export
var movement_speed: float = 10
@export
var target_node: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target = target_node if target_node != null else self as Control
	if target != null:
		target.global_position += movement_direction * movement_speed * delta
