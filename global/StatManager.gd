extends Node

@export var mouse_x_sensitivity : float = 0.1
@export var mouse_y_sensitivity : float = 0.1
@export var window_mode : bool = false
@export var mouse_invert : bool = false
@export var master_volume : float = 1
@export var music_volume : float = 1
@export var sfx_volume : float = 1

var audio_bus_index : int

#@onready var timer_game = $TimerGame

var timer_game_running : bool

var play_time : bool

var ui_need : bool

var mission_status = "complete"
var time_comp

var resolutions_list = [
"812 x 375 (19.5:9)",
"3840 x 1772 (19.5:9)",
"1920 x 1080 (16:9)",
"2560 x 1440 (16:9)",
"1440 x 900 (16:10)",
"2560 x 1600 (16:10)",
]

#var stats_dict = {
	#num_enemies : remaining_enemies,
	#player_kills : kills,
#}


var starting_enemies : int
var remaining_enemies : int = 0
var num_enemies : int
var final_enemies_start : int
var final_enemies : int

var total_kills : int
var player_kills : int
var kills : int
var final_kills : int

var total_secrets : int
var starting_secrets : int
var remaining_secrets : int
var num_secrets : int
var final_secrets_start : int
var final_secrets_found : int



var save_stat_path = "user://%s" % "bahstat.bin"
var save_opt_path = "user://%s" % "bahopt.bin"
#var save_path = "res://bahsave.bin"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_options()
	update_volume()
	windowed_mode()
	load_stats()


func windowed_mode():
	if window_mode == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif window_mode == false:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_stats():
	remaining_secrets = starting_secrets - num_secrets
	remaining_enemies = starting_enemies + num_enemies
	if play_time == true: 
		if remaining_enemies == 0:
			mission_status = "complete"
			end_mission()

func total_stats():
	total_secrets = total_secrets + num_secrets
	total_kills = total_kills + kills

func clear_starting():
	starting_enemies = 0
	remaining_enemies = 0
	starting_secrets = 0
	kills = 0
	num_secrets = 0

func clear_final():
	final_enemies = 0
	final_kills = 0
	final_secrets_start = 0
	final_secrets_found = 0

func update_options():
	update_volume()
	
func save_stats():
	var file = FileAccess.open(save_stat_path, FileAccess.WRITE)
	var save_data: Dictionary = {
		"Kills": total_kills,
		"Secrets": total_secrets,
	}
	var jstr = JSON.stringify(save_data)
	
	file.store_line(jstr)
	print("saved stats")


func load_stats():
	var file = FileAccess.open(save_stat_path, FileAccess.READ)
	if not file:
		return
	if file == null:
		return
	if FileAccess.file_exists(save_stat_path) == true:
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				total_kills = current_line["Kills"]
				total_secrets = current_line["Secrets"]
				print("loaded")


func clear_save():
	total_kills = 0
	total_secrets = 0
	save_stats()
	SignalBus.update_stat_display.emit()
	print("save cleared")


func no_more_time():
	end_mission()


func end_mission():
	final_enemies_start = starting_enemies
	final_enemies = remaining_enemies
	final_kills = kills
	final_secrets_found = num_secrets
	final_secrets_start = starting_secrets
	StatManager.play_time = false
	if remaining_enemies > 0:
		mission_status = "failed"
	if remaining_enemies <= 0:
		mission_status = "complete"
	SignalBus.level_change.emit("game_over")

func update_volume():
	AudioServer.set_bus_volume_db(0, linear_to_db(master_volume))
	AudioServer.set_bus_volume_db(1, linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(2, linear_to_db(sfx_volume))


func save_options():
	var file = FileAccess.open(save_opt_path, FileAccess.WRITE)
	var save_data: Dictionary = {
		"MasterVolume": master_volume,
		"MusicVolume": music_volume,
		"SFXVolume": sfx_volume,
		"Windowed": window_mode,
		"MouseInvert": mouse_invert,
		"MouseXSensitivity": mouse_x_sensitivity,
		"MouseYSensitivity": mouse_y_sensitivity
	}
	var jstr = JSON.stringify(save_data)
	
	file.store_line(jstr)
	print("saved opts")
	print("mav ", master_volume)
	print("muv ", music_volume)
	print("sfv ", sfx_volume)
	print("win ", window_mode)
	print("inv ", mouse_invert)
	print("xse ", mouse_x_sensitivity)
	print("yse ", mouse_y_sensitivity)


func load_options():
	var file = FileAccess.open(save_opt_path, FileAccess.READ)
	if not file:
		return
	if file == null:
		return
	if FileAccess.file_exists(save_opt_path) == true:
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				master_volume = current_line["MasterVolume"]
				music_volume = current_line["MusicVolume"]
				sfx_volume = current_line["SFXVolume"]
				window_mode = current_line["Windowed"]
				mouse_invert = current_line["MouseInvert"]
				mouse_x_sensitivity = current_line["MouseXSensitivity"]
				mouse_y_sensitivity = current_line["MouseYSensitivity"]
				
				print("loaded opts")
				
				print("mav ", master_volume)
				print("muv ", music_volume)
				print("sfv ", sfx_volume)
				print("win ", window_mode)
				print("inv ", mouse_invert)
				print("xse ", mouse_x_sensitivity)
				print("yse ", mouse_y_sensitivity)


func start_stats():
	starting_enemies = starting_enemies
	num_enemies = num_enemies
	print("starting stats\n",
	starting_enemies, " should be 40\n",
	num_enemies, " should be 0\n",
	kills, " should be 0\n"
	)
	
