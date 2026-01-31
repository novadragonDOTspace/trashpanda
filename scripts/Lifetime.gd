extends Node

@export
var lifetime: float = 5
var remaining_lifetime: float = 5

signal lifetime_ended()
@export
var auto_destroy_on_lifetime_end: bool = false
@export
var auto_destroy_target: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	remaining_lifetime = lifetime


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	remaining_lifetime -= delta
	if remaining_lifetime <= 0:
		remaining_lifetime = 0
		lifetime_ended.emit()
		if auto_destroy_on_lifetime_end:
			if auto_destroy_target != null:
				auto_destroy_target.queue_free()
			else:
				queue_free()
