extends Control

@onready var mission_status = $VBoxContainer/HBoxContainer/Control/VBoxContainer/MissionStatus
@onready var time_stat = $VBoxContainer/HBoxContainer/Control/VBoxContainer/GridContainer/TimeStat
@onready var enemies_stat = $VBoxContainer/HBoxContainer/Control/VBoxContainer/GridContainer/EnemiesStat
@onready var kills_stat = $VBoxContainer/HBoxContainer/Control/VBoxContainer/GridContainer/KillsStat
@onready var secrets_stat = $VBoxContainer/HBoxContainer/Control/VBoxContainer/GridContainer/SecretsStat
@onready var l_kills_stat = $VBoxContainer/HBoxContainer/Control/VBoxContainer/GridContainer2/LKillsStat
@onready var l_secrets_stat = $VBoxContainer/HBoxContainer/Control/VBoxContainer/GridContainer2/LSecretsStat


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	update_go_screen()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_go_screen():
	update_mission_status()
	var sec_stat_found = StatManager.final_secrets_found
	var sec_stat_start = StatManager.final_secrets_start

	time_stat.text = str(StatManager.time_comp)
	enemies_stat.text = str(StatManager.final_enemies)
	kills_stat.text = str(StatManager.final_kills)
	secrets_stat.text = str(sec_stat_found, " / ", sec_stat_start)
	
	l_kills_stat.text = str(StatManager.total_kills)
	l_secrets_stat.text = str(StatManager.total_secrets)

func update_mission_status():
	if StatManager.mission_status == "complete":
		mission_status.text = "Mission Complete"
	if StatManager.mission_status == "failed":
		mission_status.text = "Game Over"
		


func _on_main_menu_pressed():
	SignalBus.level_change.emit("main_menu")


func _on_play_again_pressed():
	SignalBus.level_change.emit("nuke_house")


func _on_quit_pressed():
	StatManager.save_stats()
	get_tree().quit()
