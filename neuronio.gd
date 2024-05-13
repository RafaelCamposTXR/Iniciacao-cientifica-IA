extends RigidBody3D


var NovaTB = preload("res://PopUp.tscn")
var instanciasHover = []
var qtdHOVER = 0
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


func _on_mouse_entered():
		instanciarHover(Vector2(-1,0))


func _on_mouse_exited():
	instanciasHover[qtdHOVER-1].queue_free()
