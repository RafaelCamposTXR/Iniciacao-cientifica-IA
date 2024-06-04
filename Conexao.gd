extends Node
@onready var desenho_linha = $Area3D/MeshInstance3D




# Called when the node enters the scene tree for the first time.
func _ready():
	desenhar_linha(Vector3(1,1,10), Vector3(1,1,30))

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


func _on_static_body_3d_mouse_entered():
	desenho_linha.mesh.clear_surfaces()
