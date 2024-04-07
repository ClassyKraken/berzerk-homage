extends Node3D

const NERF_DART = preload("res://scenes/weapons/nerf_dart.tscn")

@onready var weapon_sprite = $CanvasLayer/Control/WeaponSprite
@onready var gun_rays = $GunRays

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("fire_weapon", fire_weapon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func fire_weapon(muzzle):
	weapon_sprite.play("shoot")
	var new_dart = NERF_DART.instantiate()
	gun_rays.add_child(new_dart)
	new_dart.global_transform = muzzle
