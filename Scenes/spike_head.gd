extends Node2D

@onready var main_body = $main_body
@onready var detect_zone_y = $detect_zone_y
@onready var detect_zone_x = $detect_zone_x
@onready var player = $"../CharacterBody2D"
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ground_check = $ground_check

var y_entered = false
var x_entered = false
var is_activated = false
var has_collided = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_activated and not has_collided :
		if y_entered == true :
			if player.position.y >= position.y :
				position.y += 500*delta
			else :
				position.y -= 500*delta
		if x_entered == true :
			if player.position.x >= position.x :
				position.x -= 500*delta
			else :
				position.x -= 500*delta


func _on_main_body_body_entered(body):
	if (body.name == "CharacterBody2D") :
		player.start_death()

func _on_detect_zone_y_body_entered(body):
	if not is_activated :
		if (body.name == "CharacterBody2D") :
			y_entered = true
			x_entered = false
			is_activated = true

func _on_detect_zone_x_body_entered(body):
	if not is_activated :
		if (body.name == "CharacterBody2D") :
			x_entered = true
			y_entered = false
			is_activated = true

func _on_ground_check_body_entered(body):
	if (body.name != "CharacterBody2D") :
		has_collided = true
		x_entered = false
		y_entered = false
		#animated_sprite_2d.play("blink")
		#if animated_sprite_2d.animation == "blink" and animated_sprite_2d.frame == 3 :
		position = Vector2(1836,1197)
		has_collided = false
