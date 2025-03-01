extends StaticBody3D

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

# Called when the node enters the scene tree for the first time.

func initialize(pos, field: Vector3) -> void:
	position = pos
	rotation = orientVector(field)
	print("i initialized")
	

func _ready() -> void:
	print('im ready')
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
