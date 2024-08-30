extends Node3D



## Instanciamento de Neurônio ##
var NovaCapsula = preload("res://Neuronio.tscn")
var NovaLinha = preload("res://Linha.tscn")
var NeuronioEntradaNovo = preload("res://NeuronioEntrada.tscn")
var instanciasCapsula = []
var qtdCAP = 0

var inputs = [5.5, 2.5, 4.0, 1.3]  # Entradas da rede neural
var network_info = {}  # Variável para armazenar informações da rede neural
#####


##Posicionamento de neurônios
var x = 0
var y = 2
#####


func _ready():
	
	var rede_neural = [
	[
		{"pesos": [0.5, -0.2], "bias": 0.1},
		{"pesos": [0.3, 0.8], "bias": -0.4}
	],
	[
		{"pesos": [0.7, 0.6], "bias": 0.2},
		{"pesos": [-0.5, 0.9], "bias": 0.0}
	]
	]

	var entradas_iniciais = [1.0, -1.0]

	print("rede gerada = ", calcular_ativacoes(rede_neural, entradas_iniciais))
	print(ReLU([0,1,1],[[3,2,2],[4,5,5],[5,3,3]],[5,4,3]))
	
	var hidden_layer_output = ann0[0][2].call(inputs, ann0[0][0], ann0[0][1])
	var output_layer_output = ann0[1][2].call(hidden_layer_output, ann0[1][0], ann0[1][1])
	
	# Captura e armazena as informações da rede neural
	network_info = store_neural_network_info(ann0, inputs, [hidden_layer_output], output_layer_output)
	
	# Salva as informações da rede neural em um arquivo JSON
	save_network_info_to_json("res://informacoes_rede.json", network_info)


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

func calcular_ativacoes(rede_neural: Array, entradas_iniciais: Array) -> Array:
	var ativacoes = []
	var entradas = entradas_iniciais

	for camada in rede_neural:
		var ativacoes_camada = []
		for i in range(len(camada["biases"])):
			var z = somatorio_ponderado(entradas, camada["weights"][i], camada["biases"][i])
			
			# Obtendo a função de ativação específica do neurônio
			var func_ativacao = get_funcao_ativacao(camada["activation"])
			
			# Calculando a ativação usando a função especificada
			var a = func_ativacao(z)
			ativacoes_camada.append(a)
		
		ativacoes.append(ativacoes_camada)
		entradas = ativacoes_camada  # Saídas da camada são entradas da próxima camada
	
	return ativacoes

# Função auxiliar para obter a função de ativação correta
func get_funcao_ativacao(nome_funcao: String) -> Callable:
	match nome_funcao:
		"ReLU":
			return ReLU
#		"sigmoid":
#			return funcao_sigmoid
#		"tanh":
#			return funcao_tanh
		_:
			return funcao_default  # Função padrão caso o nome não corresponda a nenhuma função

func funcao_default(z: float) -> float:
	print("Função de ativação desconhecida usada, retornando valor original.")
	return z


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


# Definir a função de ativação ReLU
func ReLU(x):
	if x <=0:
		return 0
	else: 
		return x

var ann0 = [
	[ # Camada oculta
		[ # Pesos
			[ 3.67544247e-01,  3.99710701e-01,  5.62482995e-01,  1.21584223e+00],
			[ 7.33857775e-01,  1.63110209e+00, -1.62498659e+00, -1.09241287e+00],
			[-4.90230015e-01,  2.77883485e-01,  5.40120978e-01,  3.42985490e-01],
		],
		[ # Biases
			-0.19923328, 2.29299105, -0.3737735,
		],
		ReLU,  # Função de ativação ReLU
	],
	[ # Camada de saída
		[ # Pesos
			[-1.44311522e+00, 1.60677038e+00, 4.31788186e-01],
			[-3.02050927e-01, 3.20649974e-01, -5.42225471e-02],
		],
		[ # Biases
			0.16481194, 1.43615104,
		],
		ReLU,  # Função de ativação ReLU
	],
]


#Função para armazenar as informações da rede neural
func store_neural_network_info(layers, inputs, hidden_outputs, output):
	var network_info = {
		"inputs": inputs,  # Armazena as entradas da rede
		"hidden_layer_count": layers.size() - 1,  # Conta o número de camadas ocultas
		"hidden_layers": [],  # Lista vazia para armazenar informações das camadas ocultas
		"output_layer": {
			"weights": layers[-1][0],  # Pesos da camada de saída
			"biases": layers[-1][1],   # Biases da camada de saída
			"activation_function": layers[-1][2].get_method() # Função de ativação da camada de saída
		},
		"output": output
	}

	#Itera sobre as camadas ocultas para armazenar seus pesos, biases e funções de ativação
	for i in range(layers.size() - 1):
		var layer_info = {
			"weights": layers[i][0],
			"biases": layers[i][1],
			"activation_function": layers[i][2].get_method()
		}
		network_info["hidden_layers"].append(layer_info)

	return network_info

# Função para salvar as informações da rede neural em um arquivo JSON
func save_network_info_to_json(file_path, network_info):
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(network_info))  # Converte network_info para JSON e salva no arquivo
		file.close()
		print("Informações da rede salvas em ", file_path)
	else:
		print("Falha ao salvar informações da rede")

# Função para carregar as informações da rede neural de um arquivo JSON
func load_network_info_from_json(file_path):
	var network_info
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var data = file.get_as_text()  # Lê o conteúdo do arquivo
		var result = JSON.parse_string(data)
		if result.error == OK:
			network_info = result.result  # Converte o JSON de volta para um dicionário em GDScript
			print("Informações da rede carregadas de ", file_path)
		else:
			print("Falha ao analisar o JSON: ", result.error_string)
		file.close()
	else:
		print("Falha ao carregar informações da rede")
	return network_info

func somatorio_ponderado(entradas: Array, pesos: Array, bias: float) -> float:
	var soma: float = 0.0
	for i in range(len(entradas)):
		soma += entradas[i] * pesos[i]
	return soma + bias

func funcao_de_ativacao(z: float) -> float:
	return 1.0 / (1.0 + exp(-z))


