extends Camera3D


@onready var camera_mount = $".."
@onready var gun_squirt = $GunSquirt
@onready var muzzle = $Muzzle

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	if event is InputEventMouseMotion:
		var mouse_invert = StatManager.mouse_invert
		var mouse_x_sensitivty = StatManager.mouse_x_sensitivity
		var mouse_y_sensitivty = StatManager.mouse_y_sensitivity
		camera_mount.rotation_degrees.y -= event.relative.x * mouse_x_sensitivty
		if mouse_invert == false:
			camera_mount.rotation_degrees.x -= event.relative.y * mouse_y_sensitivty
		else:
			camera_mount.rotation_degrees.x += event.relative.y * mouse_y_sensitivty
		camera_mount.rotation_degrees.x = clamp(camera_mount.rotation_degrees.x, -40, 40)
		camera_mount.rotation_degrees.y = clamp(camera_mount.rotation_degrees.y, -40, 40)
		
	if event.is_action_pressed("interact"):
		gun_squirt.weapon_action(muzzle.global_transform)
