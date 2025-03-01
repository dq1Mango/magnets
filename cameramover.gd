extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var sensitivity: float = 0.2

var rotation_input: Vector3 = Vector3.ZERO

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var yaw = -event.relative.x * sensitivity
		var pitch = -event.relative.y * sensitivity

		rotation_input += Vector3(pitch, yaw, 0)
		rotation_input.x = clamp(rotation_input.x, -90, 90)

		var new_basis = Basis()
		new_basis = new_basis.rotated(Vector3.RIGHT, deg_to_rad(rotation_input.x))
		new_basis = new_basis.rotated(Vector3.UP, deg_to_rad(rotation_input.y))
		new_basis = new_basis.rotated(Vector3.FORWARD, deg_to_rad(rotation_input.z))

		basis = new_basis
	
	
func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_select"):
		direction.y += 1
	if Input.is_action_pressed("shift"):
		direction.y -= 1
	if Input.is_action_pressed("move_backward"):
		# Notice how we are working with the vector's x and z axes.
		# In 3D, the XZ plane is the ground plane.
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# Setting the basis property will affect the rotation of the node.
		direction = self.basis * direction
	
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
		velocity.z = direction.z * SPEED
	
	else:
		velocity = Vector3(0, 0, 0)
	move_and_slide()
