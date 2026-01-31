extends Camera2D

@export
var velocity_decay: float = 10

var was_mouse_down: bool = false
var mouse_position_start: Vector2
var previous_mouse_position: Vector2
var velocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var is_mouse_down = Input.is_mouse_button_pressed(1)
	if is_mouse_down != was_mouse_down:
		was_mouse_down = is_mouse_down
		if is_mouse_down:
			velocity = Vector2(0, 0)
			mouse_position_start = get_global_mouse_position()
			previous_mouse_position = get_global_mouse_position()
		else:
			var current_mouse_position = get_global_mouse_position()
			var mouse_delta = current_mouse_position - mouse_position_start
			velocity = - (mouse_delta)
			velocity.y = 0
	elif is_mouse_down:
		var current_mouse_position = get_global_mouse_position()
		var mouse_delta = current_mouse_position - mouse_position_start
		mouse_delta.y = 0
		global_position -= mouse_delta
		_normalize_position()
		previous_mouse_position = get_global_mouse_position()
	else:
		global_position += velocity
		_normalize_position()
		var decay_step = velocity_decay * delta
		var length = velocity.length()
		var new_length = length - decay_step
		if new_length <= 0:
			velocity = Vector2(0, 0)
		else:
			velocity = velocity * new_length / length
func _normalize_position():
	if limit_enabled:
		var position = global_position
		if position.x < limit_left:
			position.x = limit_left
		if position.x > limit_right:
			position.x = limit_right
		if position.y < limit_top:
			position.y = limit_top
		if position.y > limit_bottom:
			position.y = limit_bottom
		global_position = position
