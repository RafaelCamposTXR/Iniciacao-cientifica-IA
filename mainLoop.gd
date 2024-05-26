extends Node3D


## Instanciamento de Neurônio ##
var NovaCapsula = preload("res://Neuronio.tscn")
var instanciasCapsula = []
var qtdCAP = 0
#####


##Posicionamento de neurônios
var x = 0
var y = 2
#####


func _ready():
	##Neuronios de Teste
	CriarCapsula(0,1,5.6)
	CriarCapsula(2,0,10.3)
	CriarCapsula(4,1,5)
	###


func _process(delta):
	pass
	

func instanciarCapsula(pos):
	instanciasCapsula.append(NovaCapsula.instantiate())
	add_child(instanciasCapsula[qtdCAP])
	instanciasCapsula[qtdCAP].position = pos
	pos.x += 1
	qtdCAP += 1
	return instanciasCapsula[qtdCAP-1]
	
	
func CriarCapsula(pos, ativado, bias):
	var N = instanciarCapsula(Vector3(pos,y,0))
	N.EscolheCor(ativado)
	N.bias = bias


func _on_button_0_button_down():
	get_tree().change_scene_to_file("res://MenuPrincipal.tscn")


func _on_button_1_button_down():
	instanciarCapsula(Vector3(x,y,0))
	x += 2


func _on_remover_capsula_button_down():
	if qtdCAP > 0:
		instanciasCapsula[qtdCAP-1].queue_free()
		instanciasCapsula.remove_at(qtdCAP-1)
		qtdCAP -= 1
	else:
		pass





