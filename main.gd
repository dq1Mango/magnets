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
	
	#print(originalVector)
	#print(rotate)
	
	return rotate
	
func draw_field(coords: Vector3) -> void:
	const veloVector = Vector3(0, 1, 0)
	
	var particle = get_node("/root/main/particle")
	
	var pos = particle.position
	var distance = pos - coords
	#print("pos:", pos)
	#var velo = get_node("/root/main/velo")
	
	#velo.position = pos
	
	var field = veloVector.cross(-1 * pos)
	
	var vector = vector_scene.instantiate()
	vector.position = coords
	vector.rotation = orientVector(field)
	add_child(vector)
	#vector.initialize(coords, field)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var ogVector = get_node("./badvector")
	for i in range(0, 5):
		for j in range(0, 5):
			for k in range(0, 5):
				draw_field(Vector3(i, j, k))
				#ogVector.position = Vector3(i, j, k)
				#var newVector = ogVector.duplicate(7)
				pass
				
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
