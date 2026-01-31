class_name Racoon
extends AnimatedSprite2D

var trash_source_index: int = 0
var current_total_distance: float = 100
var remaining_distance: float = 0
var returning: bool = false
var current_movement_speed = 100
var is_waiting: bool = false
var remaining_wait_duration: Big = Big.new(0)
var current_target: Node2D
var carried_trash: Big = Big.new(0)

var speed: int
var strength: int
var amount: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("walk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
