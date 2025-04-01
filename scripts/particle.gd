extends RigidBody3D

@export var static_velocity: Vector3
@export var OGposition: Vector3
@export var charge: int

#i dont know why this errors but works if someone could please fix it that would be skibi-di
var orientVector = preload("res://orientVector.gd").new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	$velo.rotation = orientVector.orientVector(static_velocity)
	$collision.rotation = orientVector.orientVector(static_velocity)
	linear_velocity = static_velocity
	OGposition = position

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$velo.rotation = orientVector.orientVector(linear_velocity)
	$collision.rotation = orientVector.orientVector(linear_velocity)
	pass
