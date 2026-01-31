class_name BuildingElement
extends Node

@export
var display_name_label: Label
@export
var count_label: Label
@export
var production_label: Label
@export
var cost_label: Label

signal buy_button_pressed(count: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_display_name(name: String) -> void:
	assert(display_name_label != null)
	display_name_label.text = name
func set_count(count: Big) -> void:
	count_label.text = count.toAA(true)
func set_cost(cost: Big) -> void:
	assert(cost_label != null)
	cost_label.text = cost.toAA(true)
func set_production(production: Big) -> void:
	assert(production_label != null)
	production_label.text = production.toAA(true)

func _handle_buy(count: int) -> void:
	buy_button_pressed.emit(count)
func handle_buy_1_click() -> void:
	_handle_buy(1)
func handle_buy_10_click() -> void:
	_handle_buy(10)
func handle_buy_100_click() -> void:
	_handle_buy(100)
