extends Area2D

@onready var game_manager = %GameManager
@export var target_level : PackedScene

var spawnIndex = 0

func _on_body_entered(body):
	if (body.name == "CharacterBody2D") :
		get_tree().change_scene_to_packed(target_level)
