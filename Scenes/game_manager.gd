extends Node

@onready var points_label = %PointsLabel

var points = 0

func add_point() :
	"""
	Ajoute un point au joueur et modifie le texte du label
	"""
	points += 1
	print(points)
	points_label.text = "Points : " + str(points)
