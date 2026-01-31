extends Node

@export
var game_state: GameState
@export
var amount_label: Label
@export
var production_label: Label
@export
var entry_element_container: Node
@export
var currencies: CurrencyDataContainer
var entry_element_template = preload("res://scenes/UI/BuildingElement.tscn")
var entry_elements: Array[BuildingElement] = []

var amount_popup_template = preload("res://scenes/UI/AmountPopup.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(currencies.entries.size()):
		var entry = currencies.entries[i]
		var instance = entry_element_template.instantiate() as BuildingElement
		entry_element_container.add_child(instance)
		instance.set_display_name(entry.display_name)
		instance.set_cost(entry.get_big_cost())
		instance.set_production(entry.get_big_production())
		instance.buy_button_pressed.connect(func(count): _handle_buy_button_press(i, count))
		entry_elements.append(instance)
func _handle_buy_button_press(building_index: int, count: int) -> void:
	game_state.buy_building(building_index, Big.new(count))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func handle_cost_update(index: int, new_cost: Big) -> void:
	if index >= 0 and index < entry_elements.size():
		entry_elements[index].set_cost(new_cost)
func handle_building_count_update(index: int, new_count: Big) -> void:
	if index >= 0 and index < entry_elements.size():
		entry_elements[index].set_count(new_count)

func handle_production_change(amount: Big) -> void:
	production_label.text = amount.toAA(true)
func handle_amount_change(amount: Big) -> void:
	amount_label.text = amount.toAA(true)

func handle_amount_visualization(amount: Big) -> void:
	var instance = amount_popup_template.instantiate() as AmountPopup
	self.add_child(instance)
	instance.set_amount(amount)
	instance.global_position = Vector2(360, 360)
