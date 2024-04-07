extends GunNerf

const NERF_DART = preload("res://scenes/weapons/nerf_dart.tscn")
const PLAYER = preload("res://scenes/player/player.tscn")

@onready var muzzle = $Muzzle
@onready var gun_nerf2 = $CanvasLayer/GunNerf

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("fire_weapon", fire_weapon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fire_weapon():
	gun_nerf2.play("shoot")
	var new_dart = NERF_DART.instantiate()
	add_child(new_dart)
	new_dart.global_transform = muzzle.global_transform
	print("shoot")
