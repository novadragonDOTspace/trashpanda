extends Node

@export
var game_state: GameState
@export
var amount_label: Label
@export
var production_label: Label

var amount_popup_template = preload("res://scenes/UI/AmountPopup.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func handle_cost_update(index: int, new_cost: Big) -> void:
	pass
func handle_building_count_update(index: int, new_count: Big) -> void:
	pass

func handle_production_change(amount: Big) -> void:
	production_label.text = amount.toAA(true)
func handle_amount_change(amount: Big) -> void:
	amount_label.text = amount.toAA(true)

func handle_amount_visualization(amount: Big) -> void:
	var instance = amount_popup_template.instantiate() as AmountPopup
	self.add_child(instance)
	instance.set_amount(amount)
	instance.global_position = Vector2(360, 360)
