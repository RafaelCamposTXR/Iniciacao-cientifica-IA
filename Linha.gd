extends Node3D

@onready var desenho_linha = $Area3D/MeshInstance3D
@onready var info_neuronio = $InfoNeuronio




# Called when the node enters the scene tree for the first time.
func _ready():
	info_neuronio.visible = false
	pass

func desenhar_linha(point_a: Vector3, point_b: Vector3):
	if point_a.is_equal_approx(point_b):
		return
	if desenho_linha.mesh is ImmediateMesh:
		desenho_linha.mesh.surface_begin(Mesh.PRIMITIVE_LINES) 
		desenho_linha.mesh.surface_set_color(Color.RED)
		desenho_linha.mesh.surface_add_vertex(point_a)
		desenho_linha.mesh.surface_add_vertex(point_b)
		desenho_linha.mesh.surface_end()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func EscolheCor(cor):
	var mat = desenho_linha.mesh.material
	if cor == 0:  ## linha em estado padrão
		mat.albedo_color = Color(0.7, 0.8, 0.9, 1)
		desenho_linha.mesh.surface_set_material(0, mat.duplicate())
	elif cor == 1: ## linha Selecionada
		mat.albedo_color = Color(100, 255, 0, 0.2)
		desenho_linha.mesh.surface_set_material(0, mat.duplicate())


func _on_area_3d_mouse_entered():
	info_neuronio.visible = true
	EscolheCor(1)


func _on_area_3d_mouse_exited():
	info_neuronio.visible = false
	EscolheCor(0)
