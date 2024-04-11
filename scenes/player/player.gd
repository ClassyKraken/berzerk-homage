extends CharacterBody3D

@onready var camera_mount = $CameraMount
@onready var ray_player = $RayPlayer
@onready var timer_button_press = $TimerButtonPress
@onready var muzzle = $CameraMount/Muzzle
@onready var inventory_manager = $InventoryManager


@export var PLAYER_SPEED = 5.0
@export var MOUSE_X_SENSITIVITY = 0.1
@export var MOUSE_Y_SENSITIVITY = 0.1
@export var mouse_invert = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var player_inventory: Array = []
var weapon_switch = 0
var current_weapon = null

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player_inventory = inventory_manager.get_children()
	for child in player_inventory:
		child.hide_weapon()
	#for weapon in inventory_manager:
		#weapon.visible = false
	print("weapons ", player_inventory)
	if player_inventory.is_empty():
		print("no weapons")
	else: 
		current_weapon = player_inventory[0]
		print("starting weapon ", current_weapon)
		print("starting type ", current_weapon.type)
		current_weapon.show_weapon()
	

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
		if current_weapon.type == 0 and target is Interactable:
			SignalBus.interaction_started.emit()
		elif current_weapon.type == 0 and target is Door:
			target.change_level()
		else:
			timer_button_press.start()


	if Input.is_action_just_released("interact"):
		SignalBus.weapon_swapping_end.emit()
		var click_length = timer_button_press.time_left
		timer_button_press.stop()
		if click_length >= 0.80:
			var muzzle = muzzle.global_transform
			#SignalBus.weapon_action.emit(muzzle)
			current_weapon.weapon_action(muzzle)
		if current_weapon.type == 0:
			SignalBus.interaction_stopped.emit()
			print("stop")
		else:
			pass


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
		
	if timer_button_press.time_left > 0 and timer_button_press.time_left < 0.80:
		SignalBus.weapon_swapping.emit()


func _on_timer_button_press_timeout():
	SignalBus.weapon_swapping_end.emit()
	var weapons_avail = player_inventory.size() - 1
	weapon_switch += 1
	if weapon_switch > weapons_avail:
		weapon_switch = 0
	switch_weapon(weapon_switch)


func switch_weapon(weapon_switch):
	var weapon_request = player_inventory[weapon_switch]
	if current_weapon == weapon_request:
		print("no weapon to switch to")
		return
	
	current_weapon.hide_weapon()
	print("hide ", current_weapon)
	current_weapon = weapon_request
	current_weapon.show_weapon()
	print("show ", current_weapon)
	
	print("switched to ", current_weapon)


func add_to_inventory(item):
	print("add to inv")
	
