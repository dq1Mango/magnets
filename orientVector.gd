
extends Node

#should probably change this to use basis rotation
func orientVector(vector) -> Vector3:
	#print("field: ", vector)
	var originalVector = Vector3(0, 1, 0)
	var rotate = Vector3(0, 0, 0)
	
	var firstStep = vector
	if abs(firstStep.z) < abs(firstStep.x):
		firstStep.z = firstStep.x
	firstStep.x = 0
	
	rotate.x = originalVector.signed_angle_to(firstStep, Vector3(1, 0, 0))
	originalVector = originalVector.rotated(Vector3(1, 0, 0), rotate.x)
	
	var secondStep = vector
	secondStep.y = 0
	rotate.y = Vector3(0, 0, originalVector.z).signed_angle_to(secondStep, Vector3(0, 1, 0))
	originalVector = originalVector.rotated(Vector3(0, 1, 0), rotate.y,)
	
	return rotate
