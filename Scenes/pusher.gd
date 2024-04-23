extends Node2D
@onready var character_body_2d = $"../CharacterBody2D"
@onready var animated_sprite_2d = $AnimatedSprite2D

var push=false
# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite_2d.play("activated")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if push:
		character_body_2d.push_player('y',-4500*delta,-1000)


func _on_area_2d_body_entered(body):
	if (body.name == "CharacterBody2D") :
		push=true


func _on_area_2d_body_exited(body):
	if (body.name == "CharacterBody2D") :
		push=false
