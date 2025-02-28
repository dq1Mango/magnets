extends StaticBody3D

func _orientVector(vector) -> Vector3:
	
	var originalVector = Vector3(0, 1, 0)
	var rotate = Vector3(0, 0, 0)
	
	rotate.x = originalVector.signed_angle_to(vector, Vector3(1, 0, 0))
	originalVector = originalVector.rotated(Vector3(1, 0, 0), rotate.x)
	
	rotate.y = originalVector.signed_angle_to(vector, Vector3(0, 1, 0))
	originalVector = originalVector.rotated(Vector3(0, 1, 0), rotate.y,)
	rotate.z = originalVector.signed_angle_to(vector, Vector3(0, 0, 1))
	originalVector = originalVector.rotated(Vector3(0, 0, 1), rotate.z)
	print(originalVector)
	print(rotate)
	return rotate
	'''const inintialRotation = Vector3(0, 1, 0)
	#var rotations = 
	var yz = Vector3(vector)
	var xy = Vector3(vector)
	
	xy.z = 0
	yz.x = 0
	
	var angleX = inintialRotation.signed_angle_to(yz, Vector3(1,0,0))
	var lookingGlass = Vector3(0,0,1)
	if angleX < 0:
		lookingGlass *= -1
		print("glass: ", lookingGlass)
	var angleY = xy.signed_angle_to(vector, Vector3(0, -1, 0))
	
	#var angleX = inintialRotation.angle_to(xy)
	#var angleZ = xy.angle_to(vector)
	
	print(angleX," ", angleY)
	return Vector3(angleX, angleY, 0)'''

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hi")
	const veloVector = Vector3(0, 1, 0)
	
	var particle = get_node("/root/main/particle")
	
	var pos = particle.position
	print("pos:", pos)
	var velo = get_node("/root/main/velo")
	
	#velo.position = pos
	
	var field = veloVector.cross(-1 * pos)
	print('field: ', field)

	#var bx = vy * pz - py * vz
	#var by = -1 * (vx * pz - vz * px)
	#var bz = (vx * py - vy * px)
	
	#var angleX = Vector3.angle_to(field)
	#var xy = (bx ** 2 + by ** 2) ** (1/2)
	
	#print("anglex: ", bx)
	#print("angelz: ", bz)
	#vector.rotation.x = angleX
	#vector.rotation.y = angleZ
	rotation = _orientVector(field)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
