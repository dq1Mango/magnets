extends Node3D

@export var vector_scene: PackedScene
@export var particle_scene: PackedScene
@export var particles: Array[RigidBody3D]
@export var fieldStart: Vector3 #wish there was a better way to do this
@export var fieldEnd: Vector3
@export var colorMax: Color
@export var colorMin: Color

var center = (fieldStart + fieldEnd) / 2
var dimensions = fieldEnd - fieldStart

var orientVector = preload("res://orientVector.gd").new()
	
func calc_magnet(coords: Vector3):

	var field = Vector3.ZERO
	for particle in particles:
		var distance = coords - particle.position
		if distance == Vector3.ZERO:
			return Vector3.ZERO
		field += particle.static_velocity.cross(distance.normalized()) / distance.length_squared()
		 
	return field
	
func initializeVector(pos, field: Vector3, maxMagnet, minMagnet: int):
	 
	var vector = vector_scene.instantiate()
	
	var magnitude = field.length()
	if magnitude < 0.0000001:
		return
				
	var colorPercent = ((magnitude - minMagnet ) / (maxMagnet - minMagnet)) ** (1.0/2.0)
	var color = colorMax * colorPercent + colorMin * (1 - colorPercent)
	color.a = colorPercent * 5
	#if color.a > 200:
		
	#	print(color.a)
	#print(color)
	#print(color)

	#i wanna do this:
	#vector.initialize(coords, field)
	#but am forced to do this:
	vector.position = Vector3(pos)
	#print("position: ", pos)
	vector.rotation = orientVector.orientVector(field) #STILL USING EULER ROTATION
	
	var mesh = vector.get_child(0)
	var new_material = StandardMaterial3D.new()
	new_material.blend_mode = StandardMaterial3D.BLEND_MODE_ADD
	new_material.transparency = StandardMaterial3D.TRANSPARENCY_ALPHA
	new_material.cull_mode = StandardMaterial3D.CULL_DISABLED
	new_material.albedo_color = color
	mesh.get_child(0).material_override = new_material
	mesh.get_child(1).material_override = new_material
	
	add_child(vector)
	
func draw_field() -> void:
	
	var minMagnet = 1
	var maxMagnet = 0
	
	#intitialize empty array of the field
	var magneticField = {} #TODO: make faster by using packed arrray
 	#var magnitudeMagneticField = [[[]]] #gotta test this "optimization"
		
	for i in range(fieldStart.x, fieldEnd.x):
		var x = str(i)
		magneticField[x] = {}
		for j in range(fieldStart.y, fieldEnd.y):
			var y = str(j)
			magneticField[x][y] = {}
			for k in range(fieldStart.z, fieldEnd.z):
				var field = calc_magnet(Vector3(i, j, k))
				
				var magnitude = field.length()
				if magnitude < minMagnet:
					minMagnet = magnitude
				elif magnitude > maxMagnet:
					maxMagnet = magnitude
					
				magneticField[x][y][str(k)] = field


	for i in range(fieldStart.x, fieldEnd.x):
		var x = str(i)
		for j in range(fieldStart.y, fieldEnd.y):
			var y = str(j)
			for k in range(fieldStart.z, fieldEnd.z):
				initializeVector(Vector3(i, j, k), magneticField[x][y][str(k)], maxMagnet, minMagnet)
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dimensions = fieldEnd - fieldStart
	center = (fieldStart + fieldEnd) / 2
	if dimensions.x <= 0 or dimensions.y <= 0 or dimensions.z <= 0:
		print("ERROR: invalid field dimensions")
		get_tree().quit()
	
	#var ogVector = get_node("./badvector")
	#draw da field
	draw_field()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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
	clearVectors()
	draw_field()
	pass # Replace with function body.
	
