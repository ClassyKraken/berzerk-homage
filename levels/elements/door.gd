class_name Door
extends CSGBox3D

@export var destination : String


func change_level():
	SignalBus.level_change.emit(destination)
	print("destination ", destination)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
