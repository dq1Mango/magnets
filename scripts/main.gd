extends Node3D

@export var vector_scene: PackedScene
@export var particle_scene: PackedScene
@export var particles: Array[RigidBody3D]
@export var colorMax: Color
@export var colorMin: Color

var vectors: Dictionary = {}
var field_radius = 5 #its not rly a radius but shhhhhh

var orientVector = preload("res://orientVector.gd").new()

var magneticField = {}
var minMagnet = 1
var maxMagnet = 0
var oldCameraPosition = Vector3.ZERO
#i dont think ive seen so many global variables before

func calc_magnet(coords: Vector3):

	var field = Vector3.ZERO
	for particle in particles:
		var distance = coords - particle.position
		if distance == Vector3.ZERO:
			return Vector3.ZERO
		field += particle.static_velocity.cross(distance.normalized()) / distance.length_squared()
		 
	return field
	
func formatVector(vector: StaticBody3D, field: Vector3) -> void:
	var colorPercent = ((field.length() - minMagnet ) / (maxMagnet - minMagnet)) ** (1.0/2.0)
	var color = colorMax * colorPercent + colorMin * (1 - colorPercent)
	color.a = colorPercent * 5
	vector.get_child(0).material_override.albedo_color = color
	vector.rotation = orientVector.orientVector(field) #STILL USING EULER ROTATION

func initializeVector(pos, field: Vector3) -> StaticBody3D:
	 
	var vector = vector_scene.instantiate()
	
	var magnitude = field.length()
	if magnitude < 0.0000001:
		return

	#i wanna do this:
	#vector.initialize(coords, field)
	#but am forced to do this:
	vector.position = Vector3(pos)
	#print("position: ", pos)	
	var mesh = vector.get_child(0)
	var new_material = StandardMaterial3D.new()
	new_material.blend_mode = StandardMaterial3D.BLEND_MODE_ADD
	new_material.transparency = StandardMaterial3D.TRANSPARENCY_ALPHA
	new_material.cull_mode = StandardMaterial3D.CULL_DISABLED
	mesh.get_child(0).material_override = new_material
	mesh.get_child(1).material_override = new_material
	
	formatVector(mesh, field)
	
	add_child(vector)
	
	return mesh
	
func draw_field(pos) -> void:
	print("drawing field here: ", pos)
	var start_time = Time.get_ticks_msec()  # Get time in milliseconds

	for i in range(-field_radius + pos.x, field_radius + pos.x):
		var x = str(i)
		if x not in vectors:
			vectors[x] = {}
		for j in range(-field_radius + pos.y, field_radius + pos.y):
			var y = str(j)
			if y not in vectors[x]:
				vectors[x][y] = {}
			for k in range(-field_radius + pos.z, field_radius + pos.z):
				var z = str(k)
				#print(x, y, z)
				if z not in vectors[x][y]:
					var test = initializeVector(Vector3(i, j, k), magneticField[x][y][z])
					vectors[x][y][z] = test
				
				if vectors[x][y][z] == null: #this is stupid
					var test = initializeVector(Vector3(i, j, k), magneticField[x][y][z])
					vectors[x][y][z] = test
					
				else:
					#print(vectors[x][y][z])
					formatVector(vectors[x][y][z], magneticField[x][y][z])
	
	var elapsed_time = Time.get_ticks_msec() - start_time
	print("Function took ", elapsed_time, " ms")

func calcField(xStart, xStop, yStart, yStop, zStart, zStop: int, updateExtema: bool):
	
	var start_time = Time.get_ticks_msec()  # Get time in milliseconds

	for i in range(xStart, xStop):
		var x = str(i)
		magneticField[x] = {}
		for j in range(yStart, yStop):
			var y = str(j)
			magneticField[x][y] = {}
			for k in range(zStart, zStop):
				var field = calc_magnet(Vector3(i, j, k)) 
				
				if updateExtema:
					var magnitude = field.length()
					if magnitude < minMagnet:
						minMagnet = magnitude
					elif magnitude > maxMagnet:
						maxMagnet = magnitude
					
				magneticField[x][y][str(k)] = field
		
	var elapsed_time = Time.get_ticks_msec() - start_time
	print("calculating field took ", elapsed_time, " ms")
	
func calcNewField(pos) -> void:
	magneticField = {} #TODO: make faster by using packed arrray
	#var magneticField: PackedVector3Array = [[[]]] #gotta test this "optimization"
	
	minMagnet = 1
	maxMagnet = 0
	
	calcField(pos.x - field_radius, pos.x + field_radius, pos.y - field_radius, pos.y + field_radius, pos.z - field_radius, pos.z + field_radius, true)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var ui_scene = load("res://options.tscn") 
	var ui = ui_scene.instantiate()
	ui.visible = false
	add_child(ui)
	
	#	get_tree().quit()
	
	#var ogVector = get_node("./badvector")
	var cameraPos = round($view_point.position)
	calcNewField(cameraPos)
	draw_field(cameraPos)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var current_position = round($view_point.position)
	if current_position != oldCameraPosition:
		var diff = current_position - oldCameraPosition
		print(diff)
		# this is not ugly at all
		#calcField(diff.x * field_radius + oldCameraPosition.x, diff.x * field_radius + current_position.x, current_position.y - field_radius, current_position.y + field_radius, current_position.z - field_radius, current_position.z + field_radius, false)
		#calcField(current_position.x - field_radius, current_position.x + field_radius, diff.y * field_radius + oldCameraPosition.y, diff.y * field_radius + current_position.y, current_position.z - field_radius, current_position.z + field_radius, false)
		#calcField(current_position.x - field_radius, current_position.x + field_radius, current_position.y - field_radius, current_position.y + field_radius, diff.z * field_radius + oldCameraPosition.z, diff.z * field_radius + current_position.z, false)
		calcField(current_position.x - field_radius, current_position.x + field_radius, current_position.y - field_radius, current_position.y + field_radius, current_position.z - field_radius, current_position.z + field_radius, false)

		draw_field(current_position)
		
		oldCameraPosition = current_position
	
	pass

func clearVectors() -> void:
	print("started with:", get_child_count())
	for child in get_children():
		if child.get_child_count() < 1:
			continue
		if child.get_child(0) is StaticBody3D:
			remove_child(child)
			child.free()

	return 
	
func vectorFromAngles(angles: Vector3) -> Vector3:
	var originalVector = Vector3(0, 0, -1)
	
	originalVector = originalVector.rotated(Vector3.RIGHT, angles.x)
	originalVector = originalVector.rotated(Vector3.UP, angles.y)
	
	return originalVector


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
	var particle = particleScene.get_child(0)
	
	particle.position = currentPosition
	particle.static_velocity = vectorFromAngles(camera.rotation)

	particles.append(particle)
	add_child(particleScene)
	calcNewField(currentPosition)
	pass # Replace with function body.
	
func restart() -> void:
	
	particles = []
	
	clearVectors()
	
func _unhandled_key_input(event: InputEvent) -> void:
	#spawn particle
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_N:
			newParticle()
		
		if event.keycode == KEY_R:
			restart()
