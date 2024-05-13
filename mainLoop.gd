extends Node3D


var NovaTB = preload("res://PopUp.tscn")
var NovaCapsula = preload("res://Neuronio.tscn")
var instanciasHover = []
var instanciasCapsula = []
var qtdHOVER = 0
var qtdCAP = 0
var x = -10
var y = 2
# Called when the node enters the scene tree for the first time.

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func instanciarHover(pos):
	instanciasHover.append( NovaTB.instantiate())
	add_child(instanciasHover[qtdHOVER])
	qtdHOVER += 1
	
func instanciarCapsula(pos):
	instanciasCapsula.append(NovaCapsula.instantiate())
	instanciasCapsula[qtdCAP].position = pos
	add_child(instanciasCapsula[qtdCAP])
	qtdCAP += 1

func _on_button_0_button_down():
	get_tree().quit()


func _on_rigid_body_3d_mouse_entered():
	instanciarHover(Vector2(-1,0))


func _on_rigid_body_3d_mouse_exited():
	instanciasHover[qtdHOVER-1].queue_free()

func _on_button_1_button_down():
	instanciarCapsula(Vector3(x,y,0))
	x += 2
	#y += 1

func _on_capsula_mouse_entered():
	instanciarHover(Vector2(-1,0))


func _on_remover_capsula_button_down():
	if qtdCAP > 0:
		instanciasCapsula[qtdCAP-1].queue_free()
		instanciasCapsula.remove_at(qtdCAP-1)
		qtdCAP -= 1
	else:
		pass


func _on_capsulainstancia_mouse_entered():
	instanciarHover(Vector2(-1,0))


func _on_capsulainstancia_mouse_exited():
	instanciasHover[qtdHOVER-1].queue_free()



