extends Node

@onready var panneauEndurance = %Endurance
@onready var main_character = %CharacterBody2D


func affiche_endurance() :
	panneauEndurance.text = "Endurance : " + str(main_character.endurance)
