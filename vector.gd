extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hi")
	const vx = 1
	const vy = 0
	const vz = 0
	
	var particle = get_node("/root/main/particle")
	
	var pos = particle.position
	
	var px = pos[0]
	var py = pos[1]
	var pz = pos[2]
	
	var bx = vy * pz - py * vz
	var by = -1 * (vx * pz - vz * px)
	var bz = (vx * py - vy * px)
	
	var xy = (bx ** 2 + by ** 2) ** (1/2)
	var angleZ = tan(bz / xy)
	var angleX = tan(bx / by)
	
	var vector = get_node("/root/main/vector")
	print(particle.rotation)
	vector.rotation[0] = angleX
	vector.rotation[2] = angleZ
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
