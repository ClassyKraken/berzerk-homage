extends Node3D

@onready var menu_light = $DirectionalLight3D

var light_rotation_deg = 45
var rotation_time = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	light_swing()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rotation_time += delta * 0.4


func light_swing() -> void:
	pass

