extends Area2D

@onready var game_manager = %GameManager
@onready var character_body_2d = $"../SceneObjects/CharacterBody2D"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_body_entered(body):
	if (body.name == "CharacterBody2D") :
		character_body_2d.start_death()
