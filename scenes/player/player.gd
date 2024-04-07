extends CharacterBody3D

@onready var camera_mount = $CameraMount
@onready var camera_player = $Node3D/Camera3D
@onready var ray_player = $RayPlayer
@onready var weapon_manager = $WeaponManager
@onready var timer_button_press = $TimerButtonPress
@onready var muzzle = $CameraMount/Muzzle

@export var PLAYER_SPEED = 5.0
@export var MOUSE_X_SENSITIVITY = 0.1
@export var MOUSE_Y_SENSITIVITY = 0.1
@export var mouse_invert = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var weapons: Array = []
var weapon_switch = 0
var current_weapon = null

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _input(event) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()
	
	#Camera Movement
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * MOUSE_X_SENSITIVITY
		if mouse_invert == false:
			camera_mount.rotation_degrees.x -= event.relative.y * MOUSE_Y_SENSITIVITY
		else:
			camera_mount.rotation_degrees.x += event.relative.y * MOUSE_Y_SENSITIVITY
		camera_mount.rotation_degrees.x = clamp(camera_mount.rotation_degrees.x, -40, 40)
	
	if Input.is_action_just_pressed("interact"):
		ray_player.force_raycast_update()
		var target = ray_player.get_collider()
		if current_weapon is Hand and target is Interactable:
			SignalBus.interaction_started.emit()
		else:
			timer_button_press.start()
	
	if Input.is_action_just_released("interact"):
		timer_button_press.stop()
		if current_weapon is Hand:
			#hand.play("idle")
			return
		else:
			var muzzle = muzzle.global_transform
			print("muzzle ", muzzle)
			SignalBus.fire_weapon.emit(muzzle)
		


func _process(delta) -> void:
	pass


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	#Movement
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * PLAYER_SPEED
		velocity.z = direction.z * PLAYER_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, PLAYER_SPEED)
		velocity.z = move_toward(velocity.z, 0, PLAYER_SPEED)

	move_and_slide()


func _on_timer_button_press_timeout():
	var weapons_avail = weapons.size() - 1
	weapon_switch += 1
	if weapon_switch > weapons_avail:
		weapon_switch = 0
	switch_weapon(weapon_switch)


func switch_weapon(weapon_switch):
	var weapon_request = weapons[weapon_switch]
	if current_weapon == weapon_request:
		print("no weapon to switch to")
		return
	
	current_weapon.hide()
	print("hide ", current_weapon)
	current_weapon = weapon_request
	current_weapon.show()
	print("show ", current_weapon)
	
	print("switched to ", current_weapon)


func add_to_inventory():
	print("add to inv")
	#inventory.add_child(GUN_NERF.instantiate())
	#weapons = inventory.get_children()
