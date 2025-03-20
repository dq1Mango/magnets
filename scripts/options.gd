extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var paramater_scene = load("res://paramaters.tscn")
	var params = paramater_scene.instantiate()
	params.visible = false
	add_child(params)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hideSelf() -> void:
	visible = false
	
	var camera = get_node("/root/simulation/view_point")
	camera.locked = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func switchToParams() -> void:
	$"./Base".visible = false
	$"./Paramaters".visible = true




func starRepo() -> void:
	OS.shell_open("https://github.com/dq1Mango/magnets")
