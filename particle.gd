extends RigidBody3D

@export var static_velocity: Vector3

var orientVector = preload("res://orientVector.gd").new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation = orientVector.orientVector(static_velocity)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
