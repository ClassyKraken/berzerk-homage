extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("level_change", change_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func change_level(destination):
	print("change scene")
	get_tree().change_scene("res://levels/livingroom.tscn")
