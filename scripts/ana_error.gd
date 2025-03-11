extends RichTextLabel

var timeLeft = 0
@export var displayTime = 2.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timeLeft > 0:
		modulate.a = timeLeft / displayTime
		timeLeft -= delta
	pass

func beUseful() -> void:
	print("i ran")
	timeLeft = displayTime
	
	
