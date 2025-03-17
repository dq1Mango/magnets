extends StaticBody3D

# Called when the node enters the scene tree for the first time.

func test():
	print("oh yeah")

func initialize(pos, field: Vector3) -> void:
	position = pos
	#rotation = orientVector(field)
	print("i initialized")
	

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
