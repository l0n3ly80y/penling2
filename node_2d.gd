extends Node2D

var test_script

func _ready():
	# Charger le script test.gd
	test_script = preload("res://test.gd")
	# Appeler la fonction hello() du script test.gd
	print(test_script.hello())
