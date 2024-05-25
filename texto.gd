extends TextEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	caret_blink = true
	placeholder_text = "Insira o caminho do \narquivo"
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

func _on_acessar_button_down():
	abrir(retorna_texto())
