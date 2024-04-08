extends Node3D

var children

# Called when the node enters the scene tree for the first time.
func _ready():
	children = self.get_children()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func explode():
	for child in children:
		child.emitting = true
