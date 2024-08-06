extends Node

# Função de ativação ReLU
func ReLU(inputs, weights, bias):
    var x = summation(inputs, weights, bias)
    for i in range(x.size()):
        if x[i] <= 0:
            x[i] = 0
    return x

# Função para retornar a função de ativação pelo nome
func get_activation_function(name):
    if name == "ReLU":
        return ReLU
    # Adicione outras funções de ativação aqui conforme necessário
    return null

# Função de somatório
func summation(inputs, weights, bias):
    var result = []
    for j in range(weights.size()):
        var summ = 0
        for i in range(inputs.size()):
            summ += inputs[i] * weights[j][i]
        result.append(summ + bias[j])
    return result

# Função para armazenar informações da rede neural
func store_neural_network_info(layers, inputs, hidden_outputs, output):
    var network_info = {
        "inputs": inputs,
        "hidden_layer_count": layers.size() - 1,
        "hidden_layers": [],
        "output_layer": {
            "weights": layers[layers.size() - 1]["weights"],
            "biases": layers[layers.size() - 1]["biases"]
        }
    }
    
    for i in range(layers.size() - 1):
        var layer_info = {
            "weights": layers[i]["weights"],
            "biases": layers[i]["biases"]
        }
        network_info["hidden_layers"].append(layer_info)
    
    return network_info

# Função para salvar informações da rede neural em um arquivo JSON
func save_network_info_to_json(file_path, network_info):
    var file = File.new()
    if file.open(file_path, File.WRITE) == OK:
        file.store_string(to_json(network_info))
        file.close()
        print("Informações da rede salvas em " + file_path)

# Função para carregar informações da rede neural de um arquivo JSON
func load_network_info_from_json(file_path):
    var file = File.new()
    if file.file_exists(file_path):
        file.open(file_path, File.READ)
        var data = parse_json(file.get_as_text())
        file.close()
        print("Informações da rede carregadas de " + file_path)
        return data
    else:
        print("Falha ao carregar informações da rede")
        return null

# Função para processar os inputs através da rede
func process_inputs_through_network(inputs, network):
    var current_output = inputs
    for layer in network:
        var weights = layer["weights"]
        var biases = layer["biases"]
        var activation_function = get_activation_function(layer["activation"])
        current_output = activation_function(current_output, weights, biases)
    return current_output

# Função para simular a inicialização no Godot
func _ready():
    # Carrega as informações da rede de um arquivo JSON
    var network_info = load_network_info_from_json("res://modelo_rede.json")
    if network_info:
        var network = network_info["layers"]
        var inputs = network_info["inputs"]
        
        # Processa os inputs através da rede
        var hidden_layer_outputs = []
        var current_output = inputs
        for layer in network.slice(0, network.size() - 1):
            current_output = process_inputs_through_network(current_output, [layer])
            hidden_layer_outputs.append(current_output)
        
        var output_layer_output = process_inputs_through_network(current_output, [network[network.size() - 1]])
        
        # Captura e armazena informações da rede neural
        var network_info = store_neural_network_info(network, inputs, hidden_layer_outputs, output_layer_output)
        
        # Salva informações da rede neural em um arquivo JSON
        save_network_info_to_json("res://informacoes_rede.json", network_info)
