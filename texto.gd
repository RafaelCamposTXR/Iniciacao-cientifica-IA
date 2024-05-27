extends TextEdit

@onready var dialogo_file = $"../DialogoFile"
signal arquivo_aberto(arquivo)

# Called when the node enters the scene tree for the first time.
func _ready():
	caret_blink = true
	placeholder_text = "  Insira o caminho do arquivo"
	scroll_smooth = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func retorna_texto():
	return get_line(get_last_full_visible_line_wrap_index())

func _on_gerar_capsula_button_down():
	print(retorna_texto())
	
func abrir(caminho):
	var file = FileAccess.open(caminho, FileAccess.READ)
	var content = file.get_as_text()
	print(content)
	arquivo_aberto.emit(file)
	return file

func _on_acessar_button_down():
	var mensagem = retorna_texto()
	if mensagem[0] == '"':
		mensagem = mensagem.left(mensagem.length() - 1)
		mensagem = mensagem.right(mensagem.length() - 1)
	abrir(mensagem)


func _on_colar_button_down():
	paste()


func _on_limpar_button_down():
	clear()


func _on_navegar_button_down():
	dialogo_file.title = "Selecione um Arquivo"
	dialogo_file.visible = true


func _on_dialogo_file_file_selected(path):
	insert_text_at_caret(path)
