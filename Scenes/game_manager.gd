extends Node

@onready var points_label = %PointsLabel

var points = 0
var current_scene = null

func add_point() :
	points += 1
	print(points)
	points_label.text = "Points : " + str(points)
