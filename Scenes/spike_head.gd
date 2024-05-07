extends Node2D

@onready var main_body = $main_body
@onready var detect_zone_y = $detect_zone_y
@onready var detect_zone_x = $detect_zone_x
@onready var player = $"../CharacterBody2D"

var y_entered = false
var x_entered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if player.position.x
	if y_entered == true :
		position.y += 500*delta
	if x_entered == true :
		position.x -= 500*delta

func _on_main_body_body_entered(body):
	if (body.name == "CharacterBody2D") :
		player.start_death()


func _on_detect_zone_y_body_entered(body):
	if (body.name == "CharacterBody2D") :
		y_entered = true
		x_entered = false



func _on_detect_zone_x_body_entered(body):
	if (body.name == "CharacterBody2D") :
		x_entered = true
		y_entered = false
