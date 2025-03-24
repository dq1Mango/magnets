extends StaticBody3D

# Called when the node enters the scene tree for the first time.

@export var updatee: int = 0

func test() -> int:
	return updatee

func _ready() -> void:

	var shaftMesh = CylinderMesh.new()
	shaftMesh.top_radius = 0.1
	shaftMesh.bottom_radius = 0.1
	shaftMesh.height = 0.75
	
	var tipMesh = CylinderMesh.new()
	tipMesh.top_radius = 0
	tipMesh.bottom_radius = 0.2
	tipMesh.height = 0.25
	
	$shaft.mesh = shaftMesh
	$tip.mesh = tipMesh
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func scaleLength(length: float) -> void:
	
	$shaft.mesh.height = length - 0.25
	$shaft.position = Vector3(0, (length - 0.25) / 2.0, 0)
	$tip.position = Vector3(0, length - 0.125, 0)
	$filler.mesh.height = 2 * length
