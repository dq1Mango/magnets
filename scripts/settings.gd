extends Control

var main
var scalar = 1.0 / 500.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_node("/root/main")
	
	var bindings_scene = load("res://bindings.tscn")
	var bindings = bindings_scene.instantiate()
	bindings.visible = false
	add_child(bindings)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setFov(fov: float) -> void:
	var camera = get_node("/root/main/view_point/Camera3D")
	camera.fov = fov
	$container/fov_pad/Label.text = "FOV: " + str(int(fov))
	
func setSensitivity(sens: float):
	var camera = get_node("/root/main/view_point")
	camera.sensitivity = sens * scalar
	$container/sensitivity_pad/Label.text = "Sensitivity: " + str(int(sens)) + "%"

func setRadius(radius: float):
	main.field_radius = int(radius)
	$container/radius_pad/Label.text = "Field \"Radius\"" + str(int(radius))

func switchToBindings():
	$bindings.visible = true
	$container.visible = false

func goBack() -> void:
	visible = false
	
	get_parent().get_node("Base").visible = true
