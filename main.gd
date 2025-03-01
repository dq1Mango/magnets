extends Node3D

@export var vector_scene: PackedScene
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
		field += particle.static_velocity.cross(distance.normalized()) / distance.length_squared()
		 
			
	return field
	
func initializeVector(position, field: Vector3, maxMagnet, minMagnet: int):

	var vector = vector_scene.instantiate()
	
	var magnitude = field.length()
	if magnitude < 0.0000001:
		return
				
	var colorPercent = ((magnitude - minMagnet ) / (maxMagnet - minMagnet)) ** (1.0/2.0)
	var color = colorMax * colorPercent + colorMin * (1 - colorPercent)
	#print(color)

	#i wanna do this:
	#vector.initialize(coords, field)
	#but am forced to do this:
	vector.position = Vector3(position)
	vector.rotation = orientVector.orientVector(field) #STILL USING EULER ROTATION
	var mesh = vector.get_child(0)
	var new_material = StandardMaterial3D.new()
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
	
	Input.MOUSE_MODE_CAPTURED
	
	#var ogVector = get_node("./badvector")
	#draw da field
	draw_field()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
