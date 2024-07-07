extends Node 

var inputs = [5.5, 2.5, 4.0, 1.3]  # Entradas da rede neural
var network_info = {}  # Variável para armazenar informações da rede neural

# Definir a função de ativação ReLU
func ReLU(inputs, weights, bias):
    var x = summation(inputs, weights, bias)
    for i in range(x.size()):
        if x[i] <= 0:
            x[i] = 0
    return x

# Definir a função de somatório
func summation(inputs, weights, bias):
    var result = []
    for j in range(weights.size()):
        var sum = 0
        for i in range(inputs.size()):
            sum += inputs[i] * weights[j][i]
        result.append(sum + bias[j])
    return result

# Definir as camadas da rede neural
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

# Função para armazenar as informações da rede neural
func store_neural_network_info(layers, inputs, hidden_outputs, output):
    var network_info = {
        "inputs": inputs,  # Armazena as entradas da rede
        "hidden_layer_count": layers.size() - 1,  # Conta o número de camadas ocultas
        "hidden_layers": [],  # Lista vazia para armazenar informações das camadas ocultas
        "output_layer": {
            "weights": layers[-1][0],  # Pesos da camada de saída
            "biases": layers[-1][1],   # Biases da camada de saída
            "activation_function": layers[-1][2].to_string()  # Função de ativação da camada de saída
        },
        "output": output
    }
    
    # Itera sobre as camadas ocultas para armazenar seus pesos, biases e funções de ativação
    for i in range(layers.size() - 1):
        var layer_info = {
            "weights": layers[i][0],
            "biases": layers[i][1],
            "activation_function": layers[i][2].to_string()
        }
        network_info["hidden_layers"].append(layer_info)
    
    return network_info

# Função para salvar as informações da rede neural em um arquivo JSON
func save_network_info_to_json(file_path):
    var file = File.new()
    if file.open(file_path, File.WRITE) == OK:
        file.store_string(JSON.print(network_info))  # Converte network_info para JSON e salva no arquivo
        file.close()
        print("Informações da rede salvas em ", file_path)
    else:
        print("Falha ao salvar informações da rede")

# Função para carregar as informações da rede neural de um arquivo JSON
func load_network_info_from_json(file_path):
    var file = File.new()
    if file.open(file_path, File.READ) == OK:
        var data = file.get_as_text()  # Lê o conteúdo do arquivo
        network_info = JSON.parse(data).result  # Converte o JSON de volta para um dicionário em GDScript
        file.close()
        print("Informações da rede carregadas de ", file_path)
    else:
        print("Falha ao carregar informações da rede")

func _ready():
    # Processa os inputs através da rede neural
    var hidden_layer_output = ann0[0][2](inputs, ann0[0][0], ann0[0][1])
    var output_layer_output = ann0[1][2](hidden_layer_output, ann0[1][0], ann0[1][1])
    
    # Captura e armazena as informações da rede neural
    network_info = store_neural_network_info(ann0, inputs, [hidden_layer_output], output_layer_output)
    
    # Salva as informações da rede neural em um arquivo JSON
    save_network_info_to_json("res://informacoes_rede.json")

func get_network_info():
    return network_info
