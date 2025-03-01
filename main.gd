extends Node3D

@export var vector_scene: PackedScene

func orientVector(vector) -> Vector3:
	
	var originalVector = Vector3(0, 1, 0)
	var rotate = Vector3(0, 0, 0)
	
	rotate.x = originalVector.signed_angle_to(vector, Vector3(1, 0, 0))
	originalVector = originalVector.rotated(Vector3(1, 0, 0), rotate.x)
	rotate.y = originalVector.signed_angle_to(vector, Vector3(0, 1, 0))
	originalVector = originalVector.rotated(Vector3(0, 1, 0), rotate.y,)
	rotate.z = originalVector.signed_angle_to(vector, Vector3(0, 0, 1))
	originalVector = originalVector.rotated(Vector3(0, 0, 1), rotate.z)
	
	return rotate
	
func draw_field(coords: Vector3) -> void:
	const veloVector = Vector3(0, 1, 0)
	
	var particle = get_node("/root/main/particle")
	
	var pos = particle.position
	var distance = pos - coords
	#var velo = get_node("/root/main/velo")
	
	#velo.position = pos
	
	var field = veloVector.cross(-1 * distance)

	var vector = vector_scene.instantiate()
	
	#i wanna do this:
	#vector.initialize(coords, field)
	
	#but am forced to do this:
	vector.position = coords
	vector.rotation = orientVector(field)
	
	
	add_child(vector)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Input.MOUSE_MODE_CAPTURED
	
	#var ogVector = get_node("./badvector")
	for i in range(-10, 10):
		for j in range(0, 5):
			for k in range(-10, 10):
				draw_field(Vector3(i, j, k))
				pass
				
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
