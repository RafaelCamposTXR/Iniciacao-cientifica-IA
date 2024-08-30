extends Node

# Define a função de ativação ReLU
func relu(inputs: Array, weights: Array, bias: Array) -> Array:
    var x = summation(inputs, weights, bias)
    for i in range(len(x)):
        if x[i] <= 0:
            x[i] = 0
    return x


func _ready():
  pass
  
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
        "num_neurons": []
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
        network_info["num_neurons"].append([i + 1, len(layer['weights'])])
    
    return network_info

# Função para salvar informações da rede neural em um arquivo JSON
func save_network_info_to_json(file_path: String, network_info: Dictionary) -> void:
    var file = File.new()  
    if file.open(file_path, File.WRITE) == OK:
        file.store_string(JSON.stringify(network_info))
        # to_json ==> JSON.stringify(json_string)
        
        file.close()
        print("Informações da rede salvas em %s" % file_path)
    else:
        print("Falha ao salvar informações da rede")

# Função para carregar informações da rede neural de um arquivo JSON
func load_network_info_from_json(file_path: String) -> Dictionary:
    var file = File.new()
    var data = {}
    if file.open(file_path, File.READ) == OK:
        var JsonData = file.get_as_text()
        var json = JSON.new()
        var error = json.parse(JsonData)
        if error == OK:
	        var data_received = json.data
	        if typeof(data_received) == TYPE_ARRAY:
		        print(data_received) # Prints array
	        else:
		        print("Unexpected data")
        #parse_json ==> JSON.stringify(json_string) converte de string para json
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

# Função auxiliar para verificar se todos os elementos de uma Array são números
func all_elements_are_numbers(array: Array) -> bool:
    for element in array:
        if typeof(element) not in [TYPE_INT, TYPE_REAL]:
            return false
    return true

# Função auxiliar para verificar se todos os elementos de uma Array são Arrays de números
func all_elements_are_array_of_numbers(array: Array) -> bool:
    for subarray in array:
        if not subarray is Array or not all_elements_are_numbers(subarray):
          return false
    return true

# Função para verificar se a função de ativação é suportada
func is_activation_function_supported(name: String) -> bool:
    return name == "ReLU" 

# Função para validar o JSON da rede neural
func validate_network_json(network_json: Dictionary) -> bool:
    var required_keys = ["inputs", "layers"]

    # Verifica se todas as chaves obrigatórias estão presentes
    for key in required_keys:
        if not network_json.has(key):
            push_error("Chave obrigatória '%s' ausente no JSON." % key)
            return false

    # Verifica se 'inputs' é uma Array de números
    if not network_json["inputs"] is Array or not all_elements_are_numbers(network_json["inputs"]):
        push_error("A chave 'inputs' deve ser uma Array de números.")
        return false

    # Verifica se 'layers' é uma Array de camadas
    if not network_json["layers"] is Array or network_json["layers"].size() == 0:
        push_error("A chave 'layers' deve ser uma Array de camadas.")
        return false

    # Verifica cada camada na lista 'layers'
    for i in range(network_json["layers"].size()):
        var layer = network_json["layers"][i]
        if not layer is Dictionary:
            push_error("A camada %d não é um objeto válido." % (i + 1))
            return false
        
        # Verifica se as chaves obrigatórias estão presentes em cada camada
        var layer_required_keys = ["weights", "biases", "activation"]
        for key in layer_required_keys:
            if not layer.has(key):
                push_error("Chave obrigatória '%s' ausente na camada %d." % [key, (i + 1)])
                return false
        
        # Verifica se 'weights' é uma Array de Arrays de números
        if not layer["weights"] is Array or not all_elements_are_array_of_numbers(layer["weights"]):
            push_error("'weights' na camada %d deve ser uma Array de Arrays de números." % (i + 1))
            return false
        
        # Verifica se 'biases' é uma Array de números
        if not layer["biases"] is Array or not all_elements_are_numbers(layer["biases"]):
            push_error("'biases' na camada %d deve ser uma Array de números." % (i + 1))
            return false
        
        # Verifica se 'activation' é uma string
        if not layer["activation"] is String:
            push_error("'activation' na camada %d deve ser uma string." % (i + 1))
            return false
        
        # Verifica se a função de ativação é suportada
        if not is_activation_function_supported(layer["activation"]):
            push_error("Função de ativação '%s' na camada %d não é suportada." % [layer["activation"], (i + 1)])
            return false

    print("JSON de entrada válido.")
    return true

# Simula a função _ready() no Godot
func _ready() -> void:
    # Carrega a rede neural do JSON
    var network_info = load_network_info_from_json("res://modelo_rede.json")
    if network_info == {}:
        return
    
    # Valida o JSON antes de processar
    if not validate_network_json(network_info):
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
