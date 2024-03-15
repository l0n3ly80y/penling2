extends Node


func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://Scenes/level1.tscn")


func _on_level_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/level2.tscn")


func _process(_delta) :
	if Input.is_action_just_pressed("jump") :
		get_tree().change_scene_to_file("res://Scenes/level1.tscn")
	if Input.is_action_just_pressed("crouch") :
		get_tree().change_scene_to_file("res://Scenes/level2.tscn")
	pass
