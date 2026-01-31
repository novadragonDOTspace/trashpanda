class_name RacoonUIButton
extends Control

signal strength_increase_pressed()
signal speed_increase_pressed()
signal count_increase_pressed()

@export
var racoon_count_label: Label
@export
var add_racoon_cost_label: Label

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

func set_racoon_count(racoon_count: Big) -> void:
	racoon_count_label.text = racoon_count.toAA(true)
func set_racoon_cost(cost: Big) -> void:
	add_racoon_cost_label.text = cost.toAA(true)
