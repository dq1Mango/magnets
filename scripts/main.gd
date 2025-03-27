extends Node3D

@export var vector_scene: PackedScene
@export var particle_scene: PackedScene
@export var particles: Array[RigidBody3D]
@export var colorMax: Color
@export var colorMin: Color

var buildMode = false #from fortnite apparently
var mass = 1
var charge = 1
var velo_scalar = 1
var place_distance = 2
@export var whereToGetThem: Array[PackedScene] = []
var thingToSpawns = []
var spawnIndex = 0
var skin

var vectors: Dictionary = {}
var update = 0
var field_radius = 5 #its not rly a radius but shhhhhh

var orientVector = preload("res://orientVector.gd").new()

var magneticField = {}
var minMagnet = 1
var maxMagnet = 0
var oldCameraPosition = Vector3.ZERO

var doElectricity = false
var doMagnetism = false
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
	vector.updatee = update

func initializeVector(pos, field: Vector3) -> StaticBody3D:
	 
	var magnitude = field.length()
	if magnitude < 0.0000001:
		return

	var vector = vector_scene.instantiate()
	
	#i wanna do this:
	#vector.initialize(coords, field)
	#but am forced to do this:
	vector.position = Vector3(pos)
	#var mesh = vector.get_child(0)
	var new_material = StandardMaterial3D.new()
	new_material.blend_mode = StandardMaterial3D.BLEND_MODE_ADD
	new_material.transparency = StandardMaterial3D.TRANSPARENCY_ALPHA
	new_material.cull_mode = StandardMaterial3D.CULL_DISABLED
	vector.get_child(0).material_override = new_material
	vector.get_child(1).material_override = new_material
	
	formatVector(vector, field)
	add_child(vector)
	
	return vector
	
func draw_field(pos) -> void:
	if not doMagnetism:
		return
	
	var start_time = Time.get_ticks_msec()  # Get time in milliseconds
	for i in range(-field_radius + pos.x, field_radius + pos.x):
		#if Time.get_ticks_msec() - start_time > 10:
		#	await get_tree().process_frame
		var x = str(i)
		if x not in vectors:
			vectors[x] = {}
		for j in range(-field_radius + pos.y, field_radius + pos.y):
			var y = str(j)
			if y not in vectors[x]:
				vectors[x][y] = {}
			for k in range(-field_radius + pos.z, field_radius + pos.z):
				var z = str(k)
				#print(Vector3(i, j, k))
				if z not in vectors[x][y]:
					var test = initializeVector(Vector3(i, j, k), magneticField[x][y][z])
					vectors[x][y][z] = test
				
				if vectors[x][y][z] == null: #this is stupid
					var test = initializeVector(Vector3(i, j, k), magneticField[x][y][z])
					vectors[x][y][z] = test
					
				else:
					if vectors[x][y][z].updatee == update:
						continue
					formatVector(vectors[x][y][z], magneticField[x][y][z])
	
	#var elapsed_time = Time.get_ticks_msec() - start_time
	#print("Function took ", elapsed_time, " ms")

func calcField(xStart, xStop, yStart, yStop, zStart, zStop: int, updateExtema: bool):
	if not doMagnetism:
		return
	#print("started calcing field")
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
		
	#print("finished it")
	#var elapsed_time = Time.get_ticks_msec() - start_time
	#print("calculating field took ", elapsed_time, " ms")
	
func calcNewField(pos) -> void:
	if doMagnetism:
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
	var camera = $view_point
	var cameraPos = round(camera.position)
	calcNewField(cameraPos)
	draw_field(cameraPos)
	
	var particle_preview_scene = load("res://better_particle.tscn") 
	var particlePreveiw = particle_preview_scene.instantiate()
	particlePreveiw.visible = false
	thingToSpawns.append(particlePreveiw)
	add_child(particlePreveiw)
	
	skin = load("res://skins/particle.tres")
	#particlePreveiw.position = Vector3(0, 0, -place_distance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var camera = $view_point
	var current_position = round(camera.position)
	if current_position != oldCameraPosition:
		var diff = current_position - oldCameraPosition
		# this is not ugly at all
		#calcField(diff.x * field_radius + oldCameraPosition.x, diff.x * field_radius + current_position.x, current_position.y - field_radius, current_position.y + field_radius, current_position.z - field_radius, current_position.z + field_radius, false)
		#calcField(current_position.x - field_radius, current_position.x + field_radius, diff.y * field_radius + oldCameraPosition.y, diff.y * field_radius + current_position.y, current_position.z - field_radius, current_position.z + field_radius, false)
		#calcField(current_position.x - field_radius, current_position.x + field_radius, current_position.y - field_radius, current_position.y + field_radius, diff.z * field_radius + oldCameraPosition.z, diff.z * field_radius + current_position.z, false)
		 # Get time in milliseconds
		
		if doMagnetism:
			calcField(current_position.x - field_radius, current_position.x + field_radius, current_position.y - field_radius, current_position.y + field_radius, current_position.z - field_radius, current_position.z + field_radius, false)
			#var start_time = Time.get_ticks_msec() 
			draw_field(current_position)
			#var elapsed_time = Time.get_ticks_msec() - start_time
			#print("drawing field took ", elapsed_time, " ms")
		
		oldCameraPosition = current_position
	
	if buildMode:
		var thing = thingToSpawns[spawnIndex]
		thing.position = round(camera.position + vectorFromAngles(camera.rotation) * place_distance)
	pass

func clearVectors() -> void:
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
	#var currentPosition = round(camera.position) #need to change this is we ever wanna change field densithy
	var currentPosition = thingToSpawns[spawnIndex].position
	for particle in particles:
		if particle.position == currentPosition:
			var message = $"./Control/anaError"
			message.beUseful()
			#showExists()
			return
	
	#var particleScene = particle_scene.instantiate()
	var particleScene = whereToGetThem[spawnIndex].instantiate()
	var particle = particleScene.get_child(0)
	
	particle.charge = charge
	particle.position = currentPosition
	particle.static_velocity = vectorFromAngles(camera.rotation)
	particle.get_child(0).get_child(0).material = skin

	particles.append(particle)
	update += 1
	add_child(particleScene)
	calcNewField(camera.position)
	draw_field(camera.position)
	pass # Replace with function body.
	
func restart() -> void:
	
	particles = []
	
	clearVectors()
	
func handleBuild():
	var thing = thingToSpawns[spawnIndex]
	
	if buildMode:
		newParticle()
	
	else:
		print("made it visible")
	
	buildMode = not buildMode
	
	thing.visible = buildMode
	
func changeSkin(newSkin: StandardMaterial3D) -> void:
	
	skin = newSkin
	
	for particle in particles:
		particle.get_child(0).get_child(0).material = newSkin
	
func _unhandled_key_input(event: InputEvent) -> void:
	#spawn particle
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_N:
			handleBuild()
		
		if event.keycode == KEY_R:
			restart()
