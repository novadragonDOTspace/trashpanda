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
@export var hats: Array[CompressedTexture2D]
@onready var hat_sprite: Sprite2D = $Hat

var level: int = 1

var speed: int
var strength: int
var amount: int
var speed_factor: float
var strength_factor: float

var _original_scale_value: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if trash_source_index > 0:
		hat_sprite.texture = hats[trash_source_index - 1]
	_original_scale_value = scale
	set_scale_factor(1)
	play("walk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func flip_sprites() -> void:
	flip_h = !flip_h
	hat_sprite.flip_h = !hat_sprite.flip_h

func set_scale_factor(scale_factor: float) -> void:
	scale = _original_scale_value * scale_factor
