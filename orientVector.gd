extends Node

#should probably change this to use basis rotation
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
