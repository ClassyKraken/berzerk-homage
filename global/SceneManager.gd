extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("level_change", change_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func change_level(destination):
	StatManager.total_stats()
	StatManager.save_stats()
	StatManager.clear_starting()
	print("change scene ", destination)
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if destination == "main_menu":
		#get_tree().unload_current_scene()
		#SignalBus.bye_ui.emit()
		StatManager.ui_need = false
		get_tree().change_scene_to_file("res://levels/main_menu.tscn")
	if destination == "nuke_house":
		#get_tree().unload_current_scene()
		#SignalBus.prep_ui.emit()
		StatManager.ui_need = true
		StatManager.clear_final()
		get_tree().change_scene_to_file("res://levels/nukehouse.tscn")
		print("scene manager get tree ", get_tree())
	if destination == "exit_menu":
		get_tree().quit()
	if destination == "game_over":
		get_tree().change_scene_to_file("res://levels/game_over.tscn")
