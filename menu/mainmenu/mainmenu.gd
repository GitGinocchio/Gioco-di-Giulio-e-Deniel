extends Control

@onready var background = $Background
@export var backgrounds = [
	preload("res://assets/background/blue.png"),
	preload("res://assets/background/brown.png"),
	preload("res://assets/background/gray.png"),
	preload("res://assets/background/green.png"),
	preload("res://assets/background/pink.png"),
	preload("res://assets/background/purple.png"),
	preload("res://assets/background/yellow.png")
]



func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://game.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://menu/settingsmenu/options_menu.tscn")


func _on_quit_pressed():
	get_tree().quit()
