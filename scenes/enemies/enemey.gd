class_name Enemy
extends StaticBody3D

const DESTROYED = preload("res://resources/sprites/robot_A_0_6_des.png")

@onready var mesh_enemy = $CollisionShape3D/MeshInstance3D
@onready var effects_explosion = $EffectsExplosion

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func handle_hit():
	effects_explosion.explode()
	mesh_enemy.get_surface_override_material(0).albedo_texture = DESTROYED
