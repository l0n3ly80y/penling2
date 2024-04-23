extends Node2D
@onready var character_body_2d = $"../CharacterBody2D"

@onready var animated_sprite_2d = $AnimatedSprite2D
var has_been_checked=false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (animated_sprite_2d.animation=="activation"):
		scale.x=1
		scale.y=1
		if animated_sprite_2d.frame==2 :
			animated_sprite_2d.animation="checked"


func _on_area_2d_body_entered(body):
	print("[checkpoint] le joueur rentre dans la zone du checkpoint")
	if (body.name == "CharacterBody2D") :
		if not has_been_checked:
			character_body_2d.set_spawn(position.x,position.y)#sets the new spawn position
			animated_sprite_2d.animation="activation"
			animated_sprite_2d.scale.x=3
			animated_sprite_2d.scale.y=3
			
	has_been_checked=true#so that it doesn't get this checkpoint again
		 # Replace with function body.
