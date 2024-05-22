extends Node2D

@onready var main_body = $main_body
@onready var detect_zone_y = $detect_zone_y
@onready var detect_zone_x = $detect_zone_x
@onready var ground_check = $ground_check
@onready var player = $"../CharacterBody2D"
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var starting_pos = position

var y_entered = false
var x_entered = false
var is_activated = false
var has_collided = false
var speed = 0
var relative_pos = -1
var augmented_speed = 0

func augmenter_vitesse(speed) :
	return 10/(1+exp(-speed+10))


func _process(delta):
	if is_activated and not has_collided :
		speed += 7*delta
		augmented_speed = augmenter_vitesse(speed)*delta*110
		if y_entered == true :
			if relative_pos == 0 :
				position.y += augmented_speed
			elif relative_pos == 1 :
				position.y -= augmented_speed
		if x_entered == true :
			if relative_pos == 2 :
				position.x += augmented_speed
			elif relative_pos == 3 :
				position.x -= augmented_speed
		if position == starting_pos :
			is_activated = false
			relative_pos = -1
	elif has_collided :
		if position == starting_pos :
			speed = 0
			has_collided = false
			x_entered = false
			y_entered = false
		else :
			position = position.move_toward(starting_pos, 250*delta)


func _on_main_body_body_entered(body):
	if (body.name == "CharacterBody2D") :
		has_collided = true
		is_activated = false
		player.start_death()

func _on_detect_zone_y_body_entered(body):
	if not is_activated :
		if (body.name == "CharacterBody2D") :
			y_entered = true
			x_entered = false
			is_activated = true
			if player.position.y >= position.y :
				relative_pos = 0
			else :
				relative_pos = 1

func _on_detect_zone_x_body_entered(body):
	if not is_activated :
		if (body.name == "CharacterBody2D") :
			x_entered = true
			y_entered = false
			is_activated = true
			if player.position.x >= position.x :
				relative_pos = 2
			else :
				relative_pos = 3

func _on_ground_check_body_entered(body):
	if (body.name != "CharacterBody2D") :
		is_activated = false
		speed = 0
		has_collided = true
		x_entered = false
		y_entered = false
