class_name GunNerf
extends Node



# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("fire_weapon", fire_weapon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fire_weapon():
	pass
	
	
	
	
