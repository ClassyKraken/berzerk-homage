class_name Interactable
extends StaticBody3D

@export var timer_interaction = 2.0

@onready var mesh_interactable = $CollisionShape3D/MeshInstance3D
const test = preload("res://resources/sprites/2DSprite_Chest_Open.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("interaction_started", interaction_started)
	SignalBus.connect("interaction_stopped", interaction_stopped)
	SignalBus.connect("interaction_complete", interaction_complete)


func interaction_started():
	print("Hi it's me ", self)
	SignalBus.interacting.emit()


func interaction_stopped():
	print("Bye it's me ", self)


func interaction_complete():
	mesh_interactable.get_surface_override_material(0).albedo_texture = test
	SignalBus.add_gun_nerf.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
