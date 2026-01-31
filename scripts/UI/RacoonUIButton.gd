class_name RacoonUIButton
extends Control

signal strength_increase_pressed()
signal speed_increase_pressed()
signal count_increase_pressed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _handle_strength_increase_press():
	strength_increase_pressed.emit()
func _handle_speed_increase_press():
	speed_increase_pressed.emit()
func _handle_count_increase_press():
	count_increase_pressed.emit()
