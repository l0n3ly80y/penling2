extends Area2D

@onready var game_manager = %GameManager
@onready var animated_sprite_2d = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
#Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (animated_sprite_2d.animation=="disappearing"):
		if (animated_sprite_2d.frame==5):
			queue_free()


func _on_body_entered(body):
	if (body.name == "CharacterBody2D") :
		game_manager.add_point()
		animated_sprite_2d.play("disappearing")
