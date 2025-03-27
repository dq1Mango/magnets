extends Control

var main

@export var skins: Array[StandardMaterial3D] 
@export var skinNames: Array[String]
var skindex = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if len(skins) != len(skinNames):
		print("skins and their names do not match!!! ")
		print("continuing anyway...")
	
	main = get_parent().get_parent()

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func cycleSkins() -> void:
	print("cycling skins")
	skindex = (skindex + 1) % len(skins)
	main.changeSkin(skins[skindex])
	$container/skin_pad/skin_cycle.text = "Particle Skin: " + skinNames[skindex]

func goBack() -> void:
	visible = false
	
	get_parent().get_node("Base").visible = true
