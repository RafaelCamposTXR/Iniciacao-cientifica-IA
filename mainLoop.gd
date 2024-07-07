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
	CriarLinha(Vector3(-2,2,0), Vector3(2,4,0))
	
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
	var diff = pos1 - pos0
	print(diff)
	var rx = atan2(diff.y, diff.z)
	var ry = atan2(diff.z, diff.x)
	var rz = atan2(diff.y, diff.x)
	
	var novaLinha = NovaLinha.instantiate()
	add_child(novaLinha)
	
	
	var ponto_medio = (pos0 + pos1) / 2.0
	novaLinha.position = ponto_medio
	novaLinha.rotate_x(rx)
	novaLinha.rotate_y(ry)
	novaLinha.rotate_z(2*rz)
	
	
	#novaLinha.look_at(diff, Vector3.UP)
	#novaLinha.look_at_from_position ( ponto_medio, pos1,-Vector3.UP )
	var comprimento = diff.length()
	novaLinha.scale = Vector3(1, comprimento/10, 1)
###


func _on_sair_button_down():
	get_tree().change_scene_to_file("res://MenuPrincipal.tscn")






