extends Node2D
@onready var character_body_2d = $"../CharacterBody2D"
@onready var animated_sprite_2d = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animated_sprite_2d.animation=="activated":
		if animated_sprite_2d.frame==2:
			animated_sprite_2d.play("off")	
func _on_triggerbox_body_entered(body):
	character_body_2d.jump_player(-1700) # Replace with function body.
	animated_sprite_2d.play('activated')
