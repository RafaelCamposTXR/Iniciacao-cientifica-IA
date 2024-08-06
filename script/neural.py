import json

# Define a função de ativação ReLU
def ReLU(inputs, weights, bias):
    x = summation(inputs, weights, bias)
    for i in range(len(x)):
        if x[i] <= 0:
            x[i] = 0
    return x

# Função para retornar a função de ativação pelo nome
def get_activation_function(name):
    if name == "ReLU":
        return ReLU
    # Adicione outras funções de ativação aqui conforme necessário
    raise ValueError(f"Função de ativação desconhecida: {name}")

# Define a função de somatório
def summation(inputs, weights, bias):
    result = []
    for j in range(len(weights)):
        summ = 0
        for i in range(len(inputs)):
            summ += inputs[i] * weights[j][i]
        result.append(summ + bias[j])
    return result

# Função para armazenar informações da rede neural
def store_neural_network_info(layers, inputs, hidden_outputs, output):
    network_info = {
        "inputs": inputs,
        "hidden_layer_count": len(layers) - 1,
        "hidden_layers": [],
        "output_layer": {
            "weights": layers[-1]['weights'],
            "biases": layers[-1]['biases']
        }
    }
    
    for i in range(len(layers) - 1):
        layer_info = {
            "weights": layers[i]['weights'],
            "biases": layers[i]['biases']
        }
        network_info["hidden_layers"].append(layer_info)
    
    return network_info

# Função para salvar informações da rede neural em um arquivo JSON
def save_network_info_to_json(file_path, network_info):
    with open(file_path, 'w') as file:
        json.dump(network_info, file)
        print("Informações da rede salvas em", file_path)

# Função para carregar informações da rede neural de um arquivo JSON
def load_network_info_from_json(file_path):
    try:
        with open(file_path, 'r') as file:
            data = json.load(file)
            print("Informações da rede carregadas de", file_path)
            return data
    except FileNotFoundError:
        print("Falha ao carregar informações da rede")
        return None

# Função para processar os inputs através da rede
def process_inputs_through_network(inputs, network):
    current_output = inputs
    for layer in network:
        weights = layer['weights']
        biases = layer['biases']
        activation_function = get_activation_function(layer['activation'])
        current_output = activation_function(current_output, weights, biases)
    return current_output

# Simula a função _ready() no Godot
def _ready(network_info):
    # Carrega a rede neural do JSON
    network = network_info['layers']
    inputs = network_info['inputs']
    
    # Processa os inputs através da rede
    hidden_layer_outputs = []
    current_output = inputs
    for layer in network[:-1]:
        current_output = process_inputs_through_network(current_output, [layer])
        hidden_layer_outputs.append(current_output)
    
    output_layer_output = process_inputs_through_network(current_output, [network[-1]])
    
    # Captura e armazena informações da rede neural
    network_info = store_neural_network_info(network, inputs, hidden_layer_outputs, output_layer_output)
    
    # Salva informações da rede neural em um arquivo JSON
    save_network_info_to_json("informacoes_rede.json", network_info)

# Carrega as informações da rede de um arquivo JSON
network_info = load_network_info_from_json("modelo_rede.json")

# Chama _ready() para simular a inicialização no Godot
if network_info:
    _ready(network_info)
