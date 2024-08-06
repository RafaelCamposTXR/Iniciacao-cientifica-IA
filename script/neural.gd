extends Node

# Define a função de ativação ReLU
func relu(inputs: Array, weights: Array, bias: Array) -> Array:
    var x = summation(inputs, weights, bias)
    for i in range(len(x)):
        if x[i] <= 0:
            x[i] = 0
    return x

# Função para retornar a função de ativação pelo nome
func get_activation_function(name: String) -> Func:
    match name:
        "ReLU":
            return self.relu
        # Adicione outras funções de ativação aqui conforme necessário
        _:
            push_error("Função de ativação desconhecida: %s" % name)
            return null

# Define a função de somatório
func summation(inputs: Array, weights: Array, bias: Array) -> Array:
    var result = []
    for j in range(len(weights)):
        var summ = 0
        for i in range(len(inputs)):
            summ += inputs[i] * weights[j][i]
        result.append(summ + bias[j])
    return result

# Função para armazenar informações da rede neural
func store_neural_network_info(layers: Array, inputs: Array, hidden_outputs: Array, output: Array) -> Dictionary:
    var network_info = {
        "inputs": inputs,
        "layer_count": len(layers),
        "layers": [],
        "qtd_neuronios": []
    }
    
    for i in range(len(layers)):
        var layer = layers[i]
        var layer_info = {
            "layer_number": i + 1,
            "weights": layer['weights'],
            "biases": layer['biases'],
            "activation": layer['activation']
        }
        network_info["layers"].append(layer_info)
        network_info["qtd_neuronios"].append([i + 1, len(layer['weights'])])
    
    return network_info

# Função para salvar informações da rede neural em um arquivo JSON
func save_network_info_to_json(file_path: String, network_info: Dictionary) -> void:
    var file = File.new()
    if file.open(file_path, File.WRITE) == OK:
        file.store_string(to_json(network_info))
        file.close()
        print("Informações da rede salvas em %s" % file_path)
    else:
        print("Falha ao salvar informações da rede")

# Função para carregar informações da rede neural de um arquivo JSON
func load_network_info_from_json(file_path: String) -> Dictionary:
    var file = File.new()
    var data = {}
    if file.open(file_path, File.READ) == OK:
        data = parse_json(file.get_as_text())
        file.close()
        print("Informações da rede carregadas de %s" % file_path)
    else:
        print("Falha ao carregar informações da rede")
    return data

# Função para processar os inputs através da rede
func process_inputs_through_network(inputs: Array, network: Array) -> Array:
    var current_output = inputs
    for layer in network:
        var weights = layer['weights']
        var biases = layer['biases']
        var activation_function = get_activation_function(layer['activation'])
        if activation_function != null:
            current_output = activation_function(current_output, weights, biases)
    return current_output

# Simula a função _ready() no Godot
func _ready() -> void:
    # Carrega a rede neural do JSON
    var network_info = load_network_info_from_json("res://modelo_rede.json")
    if network_info == {}:
        return
    
    var network = network_info['layers']
    var inputs = network_info['inputs']
    
    # Processa os inputs através da rede
    var hidden_layer_outputs = []
    var current_output = inputs
    for i in range(len(network) - 1):
        current_output = process_inputs_through_network(current_output, [network[i]])
        hidden_layer_outputs.append(current_output)
    
    var output_layer_output = process_inputs_through_network(current_output, [network[-1]])
    
    # Captura e armazena informações da rede neural
    var updated_network_info = store_neural_network_info(network, inputs, hidden_layer_outputs, output_layer_output)
    
    # Salva informações da rede neural em um arquivo JSON
    save_network_info_to_json("res://informacoes_rede.json", updated_network_info)
