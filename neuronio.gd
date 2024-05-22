extends RigidBody3D


var NovaTB = preload("res://PopUp.tscn")
var instanciasHover = []
var qtdHOVER = 0
var neuronio
var material
var capsula
var default_color = null
var other_color = Color.PINK
var sucesso = 0


func _ready():
	capsula = get_parent().get_node("CAPSULAINSTANCIA/Neuronio")
	make_unique()
	if sucesso == 1:
		EscolheCor(1)
		sucesso = 0
	elif sucesso == 0:
		EscolheCor(0)
		sucesso = 1


func make_unique():
	material = capsula.mesh.material.duplicate()
	default_color = material.albedo_color
	capsula.set("material/0", material)


func _process(delta):
	pass
	
	
func instanciarHover(pos):
	instanciasHover.append( NovaTB.instantiate())
	add_child(instanciasHover[qtdHOVER])
	qtdHOVER += 1


func _on_mouse_entered():
		instanciarHover(Vector2(-1,0))
		neuronio = get_parent().get_node("CAPSULAINSTANCIA/Neuronio")
		neuronio.mesh.material.albedo_color = Color(255 , 0, 0, 1)


func _on_mouse_exited():
	instanciasHover[qtdHOVER-1].queue_free()
	
func EscolheCor(cor):
	if cor == 0:
		capsula.set("material/0", Color(255,0,0,1))
	else:
		capsula.set("material/0", Color(0,255,0,1))
