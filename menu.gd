extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_button_down():
	get_tree().quit()


func _on_text_edit_focus_entered():
	get_tree().quit()
	pass


func _on_jogar_button_down():
	get_tree().change_scene_to_file("res://MainLoop.tscn")
	

func _on_sair_button_down():
	get_tree().quit()
	
