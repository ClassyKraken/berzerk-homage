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

