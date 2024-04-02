extends Node

@onready var points_label = %PointsLabel
@onready var health_label = %HealthLabel

var points = 0
var health = 100

func add_point() :
	points += 1
	print(points)
	points_label.text = "Points : " + str(points)

func remove_health(amount) :
	health -= amount
	health_label.text = "Health : " + str(health)
