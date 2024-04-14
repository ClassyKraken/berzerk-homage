extends Node

var no_spawned : int
var spawns : Array
@export var amount_to_spawn = 40
@onready var player_spawn = $PlayerSpawn
@onready var enemy_spawns = $EnemySpawns
@onready var dead_enemies = $DeadEnemies
@onready var live_enemies = $LiveEnemies

const DEAD_ENEMEY = preload("res://scenes/enemies/dead_enemey.tscn")
const PLAYER = preload("res://scenes/player/player.tscn")
var ENEMY = preload("res://scenes/enemies/enemey.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	print("spawn tree ", get_tree())
	SignalBus.connect("idied", handle_dead)
	spawns = enemy_spawns.find_children("EnemySpawner*", "", false, false)
	print("spawns ", spawns.size())
	spawn_enemies()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func spawn_enemies() -> void:
	print("spawning enemies")
	ENEMY = preload("res://scenes/enemies/enemey.tscn")
	for children in spawns:
		print("starting enemies ", StatManager.starting_enemies)
		print("remaining enemies ", StatManager.remaining_enemies)
		print("size ", spawns.size())
		if spawns.size() > 0 and no_spawned == amount_to_spawn:
			remove_spawns()
			StatManager.play_time = true
		elif no_spawned < amount_to_spawn:
			StatManager.play_time = false
			randomize()
			var random_spawn = spawns[randi() % spawns.size()]
			var new_enemy = ENEMY.instantiate()
			live_enemies.add_child(new_enemy)
			new_enemy.global_transform = random_spawn.global_transform
			no_spawned += 1
			enemy_spawns.remove_child(random_spawn)
			random_spawn.queue_free()
			spawns = enemy_spawns.find_children("EnemySpawner*", "", false, false)
		elif spawns.size() == 0 and no_spawned == amount_to_spawn:
			StatManager.starting_enemies = no_spawned
			StatManager.num_enemies = 0
			StatManager.start_stats()
			return
	print("enemy spawn complete ", no_spawned)
		

func remove_spawns() -> void:
	print("removing spawns")
	var to_remove = enemy_spawns.find_children("EnemySpawner*", "", false, false)
	print("start to remove ", to_remove.size())
	for children in to_remove:
		enemy_spawns.remove_child(children)
		children.queue_free()
		spawns = enemy_spawns.find_children("EnemySpawner*", "", false, false)


func handle_dead(dead_spot):
	var dead_location = dead_spot
	var destroyed = DEAD_ENEMEY.instantiate()
	dead_enemies.add_child(destroyed)
	destroyed.global_transform = dead_location
	



func spawn_player():
	#var player = PLAYER.instantiate()
	#get_tree().current_scene.add_child(player)
	#player.global_transform = player_spawn.global_transform
	pass
