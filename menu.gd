extends Node3D
@onready var input_rede = $InputRede
var file = "nenhum arquivo aberto"

func _ready():
	pass

func _process(delta):
	pass


func _on_jogar_button_down():
	GlobalRede.file = abrir().get_as_text()
	if input_rede.retorna_texto() != null:
		get_tree().change_scene_to_file("res://MainLoop.tscn")

func _on_sair_button_down():
	get_tree().quit()
	
	
func abrir():
	file = FileAccess.open("D:\\_SetimoPeriodo\\testeGodot.txt", FileAccess.READ)
	var content = file.get_as_text()
	print(content)
	return file
	
	
# Exemplo de função para obter a função de ativação correta com base no nome





