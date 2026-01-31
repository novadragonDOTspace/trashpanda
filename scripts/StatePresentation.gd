extends Node

@export
var trash_source_data: TrashSourceDataContainer
@export
var game_state: GameState
@export
var racoon_manager: RacoonManager
@export
var amount_label: Label
@export
var container: Node
var element_template = preload("res://scenes/UI/CoonUIButton.tscn")
var elements: Array[RacoonUIButton] = []

var amount_popup_template = preload("res://scenes/UI/AmountPopup.tscn")
@export
var amount_popup_container: Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(trash_source_data.entries.size()):
		var instance = element_template.instantiate() as RacoonUIButton
		(container if container != null else self ).add_child(instance)
		instance.strength_increase_pressed.connect(func(): racoon_manager.increment_strength_upgrade_count(i))
		instance.speed_increase_pressed.connect(func(): racoon_manager.increment_speed_upgrade_count(i))
		instance.count_increase_pressed.connect(func(): racoon_manager.buy_racoon(i))
		elements.append(instance)
	handle_amount_change(game_state.current_amount)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func handle_count_change(trash_index: int, racoon_count: Big) -> void:
	if trash_index >= 0 and trash_index < elements.size():
		elements[trash_index].set_racoon_count(racoon_count)
func handle_cost_update(index: int, new_cost: Big) -> void:
	pass
func handle_building_count_update(index: int, new_count: Big) -> void:
	pass

func handle_amount_change(amount: Big) -> void:
	amount_label.text = amount.toAA(true)

func handle_amount_visualization(amount: Big) -> void:
	var instance = amount_popup_template.instantiate() as AmountPopup
	(amount_popup_container if amount_popup_container != null else self ).add_child(instance)
	instance.set_amount(amount)
