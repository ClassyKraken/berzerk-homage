class_name Player
extends CharacterBody3D

@onready var camera_mount = $CameraMount
@onready var ray_player = $CameraMount/RayPlayer
@onready var timer_button_press = $TimerButtonPress
@onready var muzzle = $CameraMount/Muzzle
@onready var inventory_manager = $InventoryManager
@onready var ui_overlay = $UIOverlay

@onready var game_music = $Music
@onready var foot_step_audio = $FootStepAudio

@export var PLAYER_SPEED = 5.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var player_inventory: Array = []
var weapon_switch = 0
var current_weapon = null
var can_interact = false
var target

var cur_pos : Vector3
var old_pos : Vector3
var player_moving : bool


func _init():
	print("init player ", self)
	_enter_tree()


func _enter_tree():
	print("player enter tree ", self, " - ", get_tree())

func _ready():
	print("readying player ", self)
	old_pos = self.global_position
	cur_pos = self.global_position
	process_mode = Node.PROCESS_MODE_PAUSABLE
	SignalBus.connect("interaction_complete", interaction_complete)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	prep_music()
	player_inventory = inventory_manager.get_children()
	for child in player_inventory:
		child.hide_weapon()
	print("weapons ", player_inventory)
	if player_inventory.is_empty():
		print("no weapons")
	else: 
		current_weapon = player_inventory[0]
		print("starting weapon ", current_weapon)
		print("starting type ", current_weapon.type)
		current_weapon.show_weapon()
		SignalBus.player_ready.emit()
	#print("paused? ", get_tree().paused)
	print("player_ready")

func _input(event) -> void:
	if Input.is_action_just_pressed("exit"):
		open_menu()
	
	#Camera Movement
	if event is InputEventMouseMotion:
		var mouse_invert = StatManager.mouse_invert
		var mouse_x_sensitivty = StatManager.mouse_x_sensitivity
		var mouse_y_sensitivty = StatManager.mouse_y_sensitivity
		rotation_degrees.y -= event.relative.x * mouse_x_sensitivty
		if mouse_invert == false:
			camera_mount.rotation_degrees.x -= event.relative.y * mouse_y_sensitivty
		else:
			camera_mount.rotation_degrees.x += event.relative.y * mouse_x_sensitivty
		camera_mount.rotation_degrees.x = clamp(camera_mount.rotation_degrees.x, -40, 40)
	
	if Input.is_action_just_pressed("interact"):
		ray_player.force_raycast_update()
		target = ray_player.get_collider()
		print("target ", target)
		if current_weapon.type == 0 and target is Interactable:
			print("whoa")
			SignalBus.interacting.emit()
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

	cur_pos = self.global_position
	if cur_pos == old_pos:
		player_moving = false
		foot_step_audio.stop()
	else:
		player_moving = true
		if foot_step_audio.playing == false:
			foot_step_audio.play()
	old_pos = cur_pos

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


func interaction_complete() -> void:
	target.interaction_complete()


func open_menu():
	#SignalBus.level_change.emit("main_menu")
	ui_overlay.open_menu()


func prep_music():
	game_music.play()

func _on_audio_stream_player_finished():
	pass # Replace with function body.


