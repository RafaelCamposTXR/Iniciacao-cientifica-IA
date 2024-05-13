extends RichTextLabel
var InputRede

# Called when the node enters the scene tree for the first time.
func _ready():
	InputRede = get_parent().get_node("InputRede")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_gerar_capsula_button_down():
	clear()
	add_text(InputRede.retorna_texto())
	InputRede.clear()
