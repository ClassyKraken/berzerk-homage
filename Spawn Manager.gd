extends Node

var no_spawned : int
var spawns : Array
@export var amount_to_spawn = 40

const ENEMY = preload("res://scenes/enemies/enemey.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	spawns = self.find_children("EnemySpawner*", "", false, false)
	spawn_enemies()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn_enemies() -> void:
	for children in spawns:
		if no_spawned < amount_to_spawn:
			randomize()
			var random_spawn = spawns[randi() % spawns.size()]
			var new_enemy = ENEMY.instantiate()
			self.add_child(new_enemy)
			new_enemy.global_transform = random_spawn.global_transform
			no_spawned += 1
			self.remove_child(random_spawn)
			random_spawn.queue_free()
			spawns = self.find_children("EnemySpawner*", "", false, false)
		elif spawns.size() > 0 and no_spawned == amount_to_spawn:
			remove_spawns()
		

func remove_spawns() -> void:
	var to_remove = self.find_children("EnemySpawner*", "", false, false)
	for children in to_remove:
		self.remove_child(children)
		children.queue_free()
		to_remove = self.find_children("EnemySpawner*", "", false, false)
