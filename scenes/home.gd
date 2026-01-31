extends Node2D


@export var home_sprites: Array[CompressedTexture2D]
@export var home_level: int = 0

func _ready() -> void:
	change_texture()


func change_texture():
	$Icon.texture = home_sprites[home_level]
