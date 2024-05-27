extends Node3D
@onready var input_rede = $InputRede

func _ready():
	pass

func _process(delta):
	pass


func _on_jogar_button_down():
	if input_rede.retorna_texto() != null:
		get_tree().change_scene_to_file("res://MainLoop.tscn")
	

func _on_sair_button_down():
	get_tree().quit()
	
	
func abrir():
	var file = FileAccess.open("D:\\_SetimoPeriodo\\testeGodot.txt", FileAccess.READ)
	var content = file.get_as_text()
	print(content)
	return file



