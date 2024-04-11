class_name Interactable
extends StaticBody3D

@export var timer_interaction = 2.0

@onready var gun_squirt = $InventoryManager/GunSquirt

@onready var interactable_mesh = $CollisionShape3D/MeshInstance3D



const CHEST_OPEN = preload("res://resources/sprites/2DSprite_Chest_Open.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("interaction_started", interaction_started)
	SignalBus.connect("interaction_stopped", interaction_stopped)
	SignalBus.connect("interaction_complete", interaction_complete)


func interaction_started():
	SignalBus.interacting.emit()


func interaction_stopped():
	pass


func interaction_complete():
	interactable_mesh.get_surface_override_material(0).albedo_texture = CHEST_OPEN
	var item = gun_squirt
	SignalBus.add_to_inventory.emit(item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
