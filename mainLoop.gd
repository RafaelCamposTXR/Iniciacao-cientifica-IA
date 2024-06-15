extends Node3D


## Instanciamento de Neurônio ##
var NovaCapsula = preload("res://Neuronio.tscn")
var NovaLinha = preload("res://Linha.tscn")
var NeuronioEntradaNovo = preload("res://NeuronioEntrada.tscn")
var instanciasCapsula = []
var qtdCAP = 0
#####


##Posicionamento de neurônios
var x = 0
var y = 2
#####


func _ready():
	CriarLinha(Vector3(1,1,1), Vector3(3,3,3))
	CriarLinha(Vector3(1,1,1), Vector3(1,1,1))
	
	##Neuronio De Entrada de Teste
	CriarNeuronioEntrada(-2,2,0,0,7)
	CriarNeuronioEntrada(-2,0,0,0,7)
	CriarNeuronioEntrada(-2,2,-2,0,7)
	CriarNeuronioEntrada(-2,0,-2,0,7)
	CriarNeuronioEntrada(-2,2,-4,0,7)
	CriarNeuronioEntrada(-2,0,-4,0,7)
	####
	
	##Neuronios de Teste
	CriarNeuronio(2,4,0,1,5.6)
	CriarNeuronio(0,2,0,1,5.6)
	CriarNeuronio(2,2,0,0,10.3)
	CriarNeuronio(4,2,0,1,5)
	
	CriarNeuronio(0,0,0,0,5.6)
	CriarNeuronio(2,0,0,0,10.3)
	CriarNeuronio(4,0,0,1,5)
	
	CriarNeuronio(2,4,-4,1,5.6)
	CriarNeuronio(0,2,-4,1,5.6)
	CriarNeuronio(2,2,-4,0,10.3)
	CriarNeuronio(4,2,-4,1,5)
	
	CriarNeuronio(0,0,-4,0,5.6)
	CriarNeuronio(2,0,-4,0,10.3)
	CriarNeuronio(4,0,-4,1,5)
	
	CriarNeuronio(2,4,-2,1,5.6)
	CriarNeuronio(0,2,-2,1,5.6)
	CriarNeuronio(2,2,-2,0,10.3)
	CriarNeuronio(4,2,-2,1,5)
	
	CriarNeuronio(0,0,-2,0,5.6)
	CriarNeuronio(2,0,-2,0,10.3)
	CriarNeuronio(4,0,-2,1,5)
	####


func _process(delta):
	pass
	

## Criação de Neurônio ##
func CriarNeuronio(posx, posy, posz, ativado, bias):
	instanciasCapsula.append(NovaCapsula.instantiate())
	add_child(instanciasCapsula[qtdCAP])
	instanciasCapsula[qtdCAP].position = Vector3(posx,posy,posz)
	instanciasCapsula[qtdCAP].EscolheCor(ativado)
	instanciasCapsula[qtdCAP].bias = bias
	qtdCAP += 1
	return instanciasCapsula[qtdCAP-1]
	
func CriarNeuronioEntrada(posx, posy, posz, ativado, valor):
	var NeuronioEntrada = NeuronioEntradaNovo.instantiate()
	add_child(NeuronioEntrada)
	NeuronioEntrada.position = Vector3(posx,posy,posz)
	NeuronioEntrada.EscolheCor(ativado)
####

#Criação de conexão
func CriarLinha(pos0, pos1):
	var novaLinha = NovaLinha.instantiate()
	add_child(novaLinha)
	novaLinha.position.x = (pos1.x + pos0.x) / 2
	novaLinha.position.y = (pos1.y + pos0.y) / 2
	novaLinha.position.z = (pos1.z + pos0.z) / 2
	novaLinha.rotate_x(3.14)
	
###


func _on_sair_button_down():
	get_tree().change_scene_to_file("res://MenuPrincipal.tscn")






