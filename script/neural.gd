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
func store_neural_network_info(layers: Array, inputs: Array, hidden_outputs: Array, output: Array) -> Array:
    var network_info = []
    
    for i in range(len(layers)):
        var layer = layers[i]
        var layer_data = layer[1]  # Agora acessa os dados da camada
        var layer_info = ["camada%d" % (i + 1), 
                          ["pesos", layer_data[1], "biases", layer_data[3], "ativacao", layer_data[5]]]
        network_info.append(layer_info)
    
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
        # Acessa pesos, biases e função de ativação no novo formato
        var layer_data = layer[1]
        var weights = layer_data[1]  # Índice 1 agora se refere aos pesos
        var biases = layer_data[3]   # Índice 3 se refere aos biases
        var activation_function_name = layer_data[5]  # Índice 5 se refere à função de ativação
        
        var activation_function = get_activation_function(activation_function_name)
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
func validate_network_json(network_json: Array) -> bool:
    # Verifica se a rede possui camadas
    if network_json.size() == 0:
        push_error("A rede neural não contém camadas.")
        return false
    
    # Verifica cada camada
    for i in range(network_json.size()):
        var layer = network_json[i]
        if not layer is Array or layer.size() < 2:
            push_error("Formato de camada inválido na camada %d." % (i + 1))
            return false
        
        var layer_data = layer[1]
        # Verifica a estrutura da camada: pesos, biases, ativação
        if not (layer_data[1] is Array and all_elements_are_array_of_numbers(layer_data[1])):
            push_error("'pesos' na camada %d deve ser uma Array de Arrays de números." % (i + 1))
            return false
        
        if not (layer_data[3] is Array and all_elements_are_numbers(layer_data[3])):
            push_error("'biases' na camada %d deve ser uma Array de números." % (i + 1))
            return false
        
        if not layer_data[5] is String:
            push_error("'ativacao' na camada %d deve ser uma string." % (i + 1))
            return false
        
        if not is_activation_function_supported(layer_data[5]):
            push_error("Função de ativação '%s' na camada %d não é suportada." % [layer_data[5], (i + 1)])
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
