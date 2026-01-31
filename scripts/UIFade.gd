extends Node

@export
var fadeCurve: Curve
@export
var fade_duration: float
@export
var target: CanvasItem

var remaining_fade_time

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	remaining_fade_time = fade_duration
	var color = target.modulate
	color.a = fadeCurve.sample_baked(0)
	target.modulate = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	remaining_fade_time -= delta
	if remaining_fade_time < 0:
		remaining_fade_time += fade_duration
	var color = target.modulate
	color.a = fadeCurve.sample_baked(1 - remaining_fade_time / fade_duration)
	target.modulate = color
