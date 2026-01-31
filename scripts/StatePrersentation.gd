extends Node

@export
var game_state: GameState
@export
var debug_label: Label
@export
var entry_element_container: Node
@export
var currencies: CurrencyDataContainer
var entry_element_template = preload("res://scenes/UI/BuildingElement.tscn")
var entry_elements: Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(currencies.entries.size()):
		var entry = currencies.entries[i]
		var instance = entry_element_template.instantiate() as BuildingElement
		entry_element_container.add_child(instance)
		instance.set_display_name(entry.display_name)
		instance.buy_button_pressed.connect(func(count): _handle_buy_button_press(i, count))
func _handle_buy_button_press(building_index: int, count: int) -> void:
	game_state.buy_building(building_index, Big.new(count))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func handle_debug_text_update(text: String) -> void:
	if debug_label != null:
		debug_label.text = text
