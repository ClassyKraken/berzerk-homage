extends Node

const ENEMY = preload("res://scenes/enemies/enemey.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var spawns = self.get_children()
	for child in spawns:
		var new_enemy = ENEMY.instantiate()
		self.add_child(new_enemy)
		new_enemy.global_transform = child.global_transform
		child.queue_free()
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
