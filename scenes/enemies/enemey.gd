class_name Enemy
extends RigidBody3D

var stat_manager 

@export var resource = Resource

const DEAD_ENEMEY = preload("res://scenes/enemies/dead_enemey.tscn")

@onready var collider_enemy = $CollisionShape3D
@onready var mesh_enemy = $MeshInstance3D

@export var base_texture : Texture
@export var destroyed_texture : Texture

# Called when the node enters the scene tree for the first time.
func _ready():
	print("preparing enemy ", get_tree())
	StatManager.starting_enemies += 1
	StatManager.update_stats()
	base_texture = resource.base_texture
	destroyed_texture = resource.destroyed_texture
	mesh_enemy.get_surface_override_material(0).albedo_texture = base_texture
	print("enemy get tree ", get_tree())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func handle_hit():
	SignalBus.idied.emit(self.global_transform)
	self.queue_free()
