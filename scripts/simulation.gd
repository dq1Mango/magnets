extends Node3D

@export var vector_scene: PackedScene
@export var particle_scene: PackedScene
@export var particles: Array[RigidBody3D]
@export var permeability: float

var orientVector = preload("res://orientVector.gd").new()

var paused = true
var doMagnetism = true
var doElectricity = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _unhandled_key_input(event: InputEvent) -> void:

	#spawn particle
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_N:
			print("spawning particle")
			newParticle()
		elif  event.keycode == KEY_P:
			print("playing/pausing")
			paused = not paused
			
			#elegant freezing and unfreezing with boolean logic
			for particle in particles:
				particle.freeze = paused
				
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if paused:
		return
	
	#calculate fields
	var magnetField: PackedVector3Array = []
	for particle in particles:
		magnetField.append(calcMagnet(particle.position))
	
	var electricField: PackedVector3Array = []
	for particle in particles:
		electricField.append(calcElectric(particle.position))
		
	var i = 0
	for particle in particles:
		
		var magnetForce = particle.charge * particle.linear_velocity.cross(magnetField[i])
		particle.get_child(2).rotation = orientVector.orientVector(magnetForce)
		
		var electricForce = particle.charge * electricField[i]
		
		var netForce = (1.0 / particle.mass) * (magnetForce + electricForce)
		
		print(netForce)
		
		particle.linear_velocity += netForce * delta
		
		i += 1
	

func newParticle() -> void:

	var camera = $"./view_point"
	var currentPosition = round(camera.position) #need to change this is we ever wanna change field densithy
	for particle in particles:
		if particle.position == currentPosition:
			var message = $"./Control/anaError"
			message.beUseful()
			#showExists()
			return
	
	var particleScene = particle_scene.instantiate()
	print("scene: ", particleScene)
	var particle = particleScene.get_child(0)
	
	particle.position = currentPosition
	particle.static_velocity = vectorFromAngles(camera.rotation)
	particle.mass = 1
	
	
	if paused:
		particle.freeze = true
	else:
		particle.freeze = false

	particles.append(particle)
	
	#give it a force vector as well
	var vector = vector_scene.instantiate()
	var new_material = StandardMaterial3D.new()
	
	new_material.albedo_color = Color(255, 0, 0)
	
	vector.get_child(0).material_override = new_material
	vector.get_child(1).material_override = new_material
	
	particle.add_child(vector)
	
	add_child(particleScene)

func calcMagnet(coords: Vector3):

	if not doMagnetism:
		return Vector3.ZERO
	
	var field = Vector3.ZERO
	for particle in particles:
		var distance = coords - particle.position
		if distance == Vector3.ZERO:
			continue
			
		field += particle.static_velocity.cross(distance.normalized()) / distance.length_squared()
		 
	return field * permeability
	
func calcElectric(coords: Vector3) -> Vector3:
	
	if not doElectricity:
		return Vector3.ZERO
	#great function ik
	return Vector3.ZERO
	
#this function totally isnt resused in the main scene lol
func vectorFromAngles(angles: Vector3) -> Vector3:
	var originalVector = Vector3(0, 0, -1)
	
	originalVector = originalVector.rotated(Vector3.RIGHT, angles.x)
	originalVector = originalVector.rotated(Vector3.UP, angles.y)
	
	return originalVector
	
