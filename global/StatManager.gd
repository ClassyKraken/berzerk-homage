extends Node

@export var mouse_x_sensitivity : float = 0.1
@export var mouse_y_sensitivity : float = 0.1
@export var mouse_invert : bool = false


var resolutions_list = [
"812 x 375 (19.5:9)",
"3840 x 1772 (19.5:9)",
"1920 x 1080 (16:9)",
"2560 x 1440 (16:9)",
"1440 x 900 (16:10)",
"2560 x 1600 (16:10)",
]

var stats_dict = {
	num_enemies : remaining_enemies,
	player_kills : kills,
}


var starting_enemies : int
var remaining_enemies
var num_enemies : int

var player_kills : int
var kills : int

var starting_secrets : int
var remaining_secrets : int
var num_secrets : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func save_stats():
	pass


func update_stats():
	print("starting secrets ", starting_secrets)
	remaining_secrets = starting_secrets + num_secrets
	print ("remaining secrets ", remaining_secrets)
	
	
	print("starting enemies ", starting_enemies)
	remaining_enemies = starting_enemies + num_enemies
	print("remaining enemies ", remaining_enemies)
	print("kills ", kills)


func update_options():
	pass
	
