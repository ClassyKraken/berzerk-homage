extends Node


var stats_dict = {
	num_enemies : remaining_enemies,
	player_kills : kills,
}


var starting_enemies : int
var remaining_enemies
var num_enemies : int

var player_kills : int
var kills : int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func save_stats():
	pass


func update_stats():
	print("starting enemies ", starting_enemies)
	remaining_enemies = starting_enemies + num_enemies
	print("num enemies ", num_enemies)
	print("remaining enemies ", remaining_enemies)
	print("kills ", kills)
