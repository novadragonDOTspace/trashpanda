class_name AmountPopup
extends Control

@export
var label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_amount(amount: Big) -> void:
	label.text = ("+" if amount.isGreaterThan(Big.new(0)) else "") + amount.toAA(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
