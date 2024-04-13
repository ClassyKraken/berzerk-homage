extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("level_change", change_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func change_level(destination):
	print("change scene")
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if destination == "main_menu":
		get_tree().change_scene_to_file("res://levels/main_menu.tscn")
	if destination == "nuke_house":
		get_tree().change_scene_to_file("res://levels/nukehouse.tscn")
	if destination == "exit_menu":
		get_tree().change_scene_to_file("res://levels/exit_menu.tscn")
