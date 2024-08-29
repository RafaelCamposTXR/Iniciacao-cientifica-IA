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
        "layer_count": len(layers),
        "layers": [],
        "num_neurons": []
    }
    
    for i, layer in enumerate(layers):
        layer_info = {
            "layer_number": i + 1,
            "weights": layer['weights'],
            "biases": layer['biases'],
            "activation": layer['activation']
        }
        network_info["layers"].append(layer_info)
        network_info["num_neurons"].append([i + 1, len(layer['weights'])])
    
    return network_info

# Função para salvar informações da rede neural em um arquivo JSON
def save_network_info_to_json(file_path, network_info):
    with open(file_path, 'w') as file:
        json.dump(network_info, file, indent=4)
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

# Valida o json de entrada da rede neural
def validate_network_json(network_json):
    required_keys = ["inputs", "layers"]
    
    # Verifica se todas as chaves obrigatórias estão presentes
    for key in required_keys:
        if key not in network_json:
            raise ValueError(f"Chave obrigatória '{key}' ausente no JSON.")

    # Verifica se 'inputs' é uma lista de números
    if not isinstance(network_json['inputs'], list) or not all(isinstance(x, (int, float)) for x in network_json['inputs']):
        raise ValueError("A chave 'inputs' deve ser uma lista de números.")

    # Verifica se 'layers' é uma lista de camadas
    if not isinstance(network_json['layers'], list) or len(network_json['layers']) == 0:
        raise ValueError("A chave 'layers' deve ser uma lista de camadas.")

    # Verifica cada camada na lista 'layers'
    for idx, layer in enumerate(network_json['layers']):
        if not isinstance(layer, dict):
            raise ValueError(f"A camada {idx + 1} não é um objeto válido.")
        
        # Verifica se as chaves obrigatórias estão presentes em cada camada
        layer_required_keys = ["weights", "biases", "activation"]
        for key in layer_required_keys:
            if key not in layer:
                raise ValueError(f"Chave obrigatória '{key}' ausente na camada {idx + 1}.")
        
        # Verifica se 'weights' é uma lista de listas de números
        if not isinstance(layer['weights'], list) or not all(isinstance(w, list) for w in layer['weights']):
            raise ValueError(f"'weights' na camada {idx + 1} deve ser uma lista de listas de números.")
        for weight in layer['weights']:
            if not all(isinstance(x, (int, float)) for x in weight):
                raise ValueError(f"Cada lista em 'weights' na camada {idx + 1} deve conter apenas números.")
        
        # Verifica se 'biases' é uma lista de números
        if not isinstance(layer['biases'], list) or not all(isinstance(x, (int, float)) for x in layer['biases']):
            raise ValueError(f"'biases' na camada {idx + 1} deve ser uma lista de números.")
        
        # Verifica se 'activation' é uma string
        if not isinstance(layer['activation'], str):
            raise ValueError(f"'activation' na camada {idx + 1} deve ser uma string.")
        
        # Verifica se a função de ativação é suportada
        try:
            get_activation_function(layer['activation'])
        except ValueError:
            raise ValueError(f"Função de ativação '{layer['activation']}' na camada {idx + 1} não é suportada.")

    print("JSON de entrada válido.")
    return True

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
