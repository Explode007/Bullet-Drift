extends Node2D



func _on_quit_pressed():
	get_tree().quit() # Replace with function body.


func _on_play_pressed():
	get_tree().change_scene_to_file("res://World/world.tscn") # Replace with function body.

