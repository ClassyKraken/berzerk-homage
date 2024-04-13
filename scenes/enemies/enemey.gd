class_name Enemy
extends RigidBody3D

var stat_manager 

@export var resource = Resource

const DEAD_ENEMEY = preload("res://scenes/enemies/dead_enemey.tscn")

@onready var collider_enemy = $CollisionShape3D
@onready var mesh_enemy = $MeshInstance3D
@onready var audio_stream_player_3d = $AudioStreamPlayer3D

@export var base_texture : Texture
@export var destroyed_texture : Texture

# Called when the node enters the scene tree for the first time.
func _ready():
	stat_manager = get_node("/root/StatManager")
	stat_manager.starting_enemies += 1
	base_texture = resource.base_texture
	destroyed_texture = resource.destroyed_texture
	mesh_enemy.get_surface_override_material(0).albedo_texture = base_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func handle_hit():
	stat_manager.kills += 1
	stat_manager.num_enemies -= 1
	stat_manager.update_stats()
	var destroyed = DEAD_ENEMEY.instantiate()
	get_tree().root.add_child(destroyed)
	destroyed.global_transform = self.global_transform
	audio_stream_player_3d.play()
	queue_free()
