extends Node3D

#const PLAYER = preload("res://scenes/player/player.tscn")
#
#@onready var player_spawn = $PlayerSpawn

# Called when the node enters the scene tree for the first time.
func _ready():
	#var player = PLAYER.instantiate()
	#self.add_child(player)
	#player.global_transform = player_spawn.global_transform
	#print("get tree ", get_tree().current_scene)
	print("nuke house get tree ", get_tree())
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
