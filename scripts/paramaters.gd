extends Control

var main
var doMagnet = true
var doElectric = false #we keep tradk of these global variables in two scripts, code goat material

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main = get_parent().get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func goBack() -> void:
	visible = false
	
	get_parent().get_node("Base").visible = true

func toggleMagnet() -> void:
	doMagnet = not doMagnet
	
	$"Control/doMangetPad/Button".text = "doMagnet: " + str(doMagnet)
	
	main.toggleMagnetism()
	
func toggleElectric() -> void:
	doElectric = not doElectric
	
	$"Control/doElectricPad/Button".text = "doElectric: " + str(doElectric)
	
	main.toggleElectricity()
