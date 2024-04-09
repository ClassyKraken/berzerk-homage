class_name Enemy
extends StaticBody3D

@export var resource = Resource

@onready var mesh_enemy = $CollisionShape3D/MeshInstance3D
@onready var effects_explosion = $EffectsExplosion

@export var base_texture : Texture
@export var destroyed_texture : Texture

# Called when the node enters the scene tree for the first time.
func _ready():
	print("resource ", resource.name)
	base_texture = resource.base_texture
	destroyed_texture = resource.destroyed_texture
	mesh_enemy.get_surface_override_material(0).albedo_texture = base_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func handle_hit():
	effects_explosion.explode()
	mesh_enemy.get_surface_override_material(0).albedo_texture = destroyed_texture
