extends Control

@onready var interaction_progress = $CanvasLayer/InteractionProgress
@onready var cross_hair = $CanvasLayer/CrossHair
@onready var timer_interaction: Timer = $InteractionTimer
@onready var ui_animation_player = $CanvasLayer/UIAnimationPlayer
@onready var notifications = $CanvasLayer/HBoxContainer/Notifications
@onready var notification_timer = $CanvasLayer/HBoxContainer/Notifications/NotificationTimer
@onready var menu_window = $CanvasLayer/MenuWindow
@onready var options_menu = $CanvasLayer/OptionsMenu
@onready var mouse_invert_button = $CanvasLayer/OptionsMenu/VBoxContainer/HBoxContainer2/MouseInvertButton
@onready var x_sens = $CanvasLayer/OptionsMenu/VBoxContainer/XSens
@onready var y_sens = $CanvasLayer/OptionsMenu/VBoxContainer/YSens
@onready var action_input = $CanvasLayer/OptionsMenu/VBoxContainer/HBoxContainer3/ActionInput
@onready var windowed_button = $CanvasLayer/OptionsMenu/VBoxContainer/HBoxContainer3/WindowedButton
@onready var resolution_option = $CanvasLayer/OptionsMenu/VBoxContainer/ResolutionOption

var pending_invert : bool
var pending_x_sens : float
var pending_y_sens : float

var time_to_interact = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	menu_window.hide()
	options_menu.hide()
	SignalBus.connect("interacting", interacting)
	SignalBus.connect("interaction_stopped", interaction_stopped)
	SignalBus.connect("weapon_swapping", weapon_swapping)
	SignalBus.connect("weapon_swapping_end", weapon_swapping_end)
	SignalBus.connect("open_secret", open_secret)
	SignalBus.connect("secret_entered", secret_entered)
	SignalBus.connect("options_menu", open_options_menu)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer_interaction.get_time_left() > 0:
		var time_percent: int = -(1 - timer_interaction.get_time_left() / timer_interaction.get_wait_time() * 100)
		interaction_progress.value = time_percent


func interacting():
	#timer_interaction.paused = false
	timer_interaction.start(time_to_interact)
	interaction_progress.value = timer_interaction.time_left
	interaction_progress.visible = true


func interaction_stopped():
	#timer_interaction.paused = true
	timer_interaction.stop()
	interaction_progress.visible = false


func _on_timer_timeout():
	SignalBus.interaction_complete.emit()


func weapon_swapping():
	ui_animation_player.show()
	ui_animation_player.play("default")


func weapon_swapping_end():
	ui_animation_player.hide()
	ui_animation_player.stop()


func open_secret() -> void:
	notification_timer.start()
	notifications.set_text("A door has opened somewhere!")


func _on_notification_timer_timeout():
	notifications.set_text("")


func secret_entered() -> void:
	notification_timer.start()
	notifications.set_text("Achievement Unlocked!\nNo Toilets in Nuke House")


func open_menu() -> void:
	menu_window.popup_centered()
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED


func _on_button_main_menu_pressed():
	get_tree().paused = false
	SignalBus.level_change.emit("main_menu")


func _on_button_cancel_pressed():
	commence_game()


func _on_button_quit_pressed():
	get_tree().quit()


func open_options_menu():
	options_menu.popup_centered()
	for resolution in StatManager.resolutions_list:
			resolution_option.add_item(resolution)
	mouse_invert_button.button_pressed = StatManager.mouse_invert
	x_sens.value = StatManager.mouse_x_sensitivity
	y_sens.value = StatManager.mouse_y_sensitivity
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED


func _on_button_options_pressed():
	menu_window.hide()
	open_options_menu()


func _on_check_button_pressed():
	pending_invert = mouse_invert_button.button_pressed


func _on_x_sens_drag_ended(value_changed):
	pending_x_sens = x_sens.value


func _on_y_sens_drag_ended(value_changed):
	pending_y_sens = y_sens.value


func _on_options_ok_pressed():
	StatManager.mouse_invert = pending_invert
	StatManager.mouse_x_sensitivity = clamp(pending_x_sens, 0.1, 0.9)
	StatManager.mouse_y_sensitivity = clamp(pending_y_sens, 0.1, 0.9)
	commence_game()




func _on_windowed_button_pressed():
	if windowed_button.button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		open_options_menu()
	elif windowed_button.button_pressed == false:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		open_options_menu()
		


func _on_resolution_option_item_selected(index):
	print("reso ", index)


func _on_menu_window_close_requested():
	commence_game()
	
func commence_game():
	menu_window.hide()
	options_menu.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	print("commence x sens ", StatManager.mouse_x_sensitivity)
	print("commence y sens ", StatManager.mouse_y_sensitivity)


func _on_options_menu_close_requested():
	commence_game()
