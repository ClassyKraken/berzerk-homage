extends Control

@onready var interaction_progress = $CanvasLayer/InteractionProgress
@onready var cross_hair = $CanvasLayer/CrossHair
@onready var timer_interaction: Timer = $InteractionTimer
@onready var ui_animation_player = $CanvasLayer/UIAnimationPlayer
@onready var notifications = $VBoxContainer/HBoxContainer2/Notifications
@onready var notification_timer = $VBoxContainer/HBoxContainer2/Notifications/NotificationTimer
@onready var menu_window = $CanvasLayer/MenuWindow
@onready var options_menu = $CanvasLayer/OptionsMenu
@onready var mouse_invert_button = $CanvasLayer/OptionsMenu/VBoxContainer/HBoxContainer2/MouseInvertButton
@onready var x_sens = $CanvasLayer/OptionsMenu/VBoxContainer/XSens
@onready var y_sens = $CanvasLayer/OptionsMenu/VBoxContainer/YSens
@onready var windowed_button = $CanvasLayer/OptionsMenu/VBoxContainer/HBoxContainer3/WindowedButton
@onready var resolution_option = $CanvasLayer/OptionsMenu/VBoxContainer/ResolutionOption
@onready var target_label = $VBoxContainer/StatLine/TargetLabel
@onready var time_label = $VBoxContainer/StatLine/TimeLabel
@onready var stat_line = $VBoxContainer/StatLine
@onready var ma_volume = $CanvasLayer/OptionsMenu/VBoxContainer/MaVolume
@onready var mu_volume = $CanvasLayer/OptionsMenu/VBoxContainer/MuVolume
@onready var sfx_volume = $CanvasLayer/OptionsMenu/VBoxContainer/SFXVolume

@onready var timer_game = $TimerGame

@onready var yesno = $CanvasLayer/OptionsMenu/VBoxContainer/Button/SaveYesNo

@onready var tlabel = $VBoxContainer/StatLine/Label

@export var time_limit = 60

var pending_invert : bool
var pending_x_sens : float
var pending_y_sens : float
var pending_ma_volume : float
var pending_mu_volume : float
var pending_sfx_volume : float

var time_to_interact = 2.0

var timer_game_running : bool = StatManager.timer_game_running

var stat_line_enabled : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	print("readying player ui")
	process_mode = Node.PROCESS_MODE_ALWAYS
	menu_window.hide()
	options_menu.hide()
	yesno.hide()
	SignalBus.connect("interacting", interacting)
	SignalBus.connect("interaction_stopped", interaction_stopped)
	SignalBus.connect("weapon_swapping", weapon_swapping)
	SignalBus.connect("weapon_swapping_end", weapon_swapping_end)
	SignalBus.connect("open_secret", open_secret)
	SignalBus.connect("secret_entered", secret_entered)
	SignalBus.connect("options_menu", open_options_menu)
	SignalBus.connect("player_ready", player_ready)
	SignalBus.connect("prep_ui", prep_ui)
	SignalBus.connect("bye_ui", bye_ui)
	#commence_game()
	print("player ui complete")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer_interaction.get_time_left() > 0:
		var time_percent: int = -(1 - timer_interaction.get_time_left() / timer_interaction.get_wait_time() * 100)
		interaction_progress.value = time_percent

	var stat_line_check = StatManager.ui_need

	if stat_line_check == true:
		stat_line.visible = true
		target_label.text = (str(StatManager.starting_enemies) + " / " + str(StatManager.remaining_enemies))
		if timer_game.get_time_left() > 0:
			var time_display = "%d:%02d" % [floor(timer_game.time_left / 60), int(timer_game.time_left) % 60]
			time_label.text = time_display
			
			var time_remaining = (time_limit - timer_game.time_left)
			StatManager.time_comp = "%d:%02d" % [floor(time_remaining / 60), int(time_remaining) % 60]
			
	elif stat_line_check == false:
		stat_line.visible = false


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
	timer_game.paused = true
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
	windowed_button.set_pressed_no_signal(StatManager.window_mode)
	mouse_invert_button.button_pressed = StatManager.mouse_invert
	ma_volume.value = StatManager.master_volume
	mu_volume.value = StatManager.music_volume
	sfx_volume.value = StatManager.sfx_volume
	x_sens.value = StatManager.mouse_x_sensitivity
	y_sens.value = StatManager.mouse_y_sensitivity
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED


func _on_button_options_pressed():
	menu_window.hide()
	open_options_menu()


func _on_check_button_pressed():
	pending_invert = mouse_invert_button.button_pressed
	StatManager.mouse_invert = pending_invert


func _on_x_sens_drag_ended(value_changed):
	if value_changed:
		pending_x_sens = x_sens.value
		StatManager.mouse_x_sensitivity = clamp(pending_x_sens, 0.1, 0.9)


func _on_y_sens_drag_ended(value_changed):
	if value_changed:
		pending_y_sens = y_sens.value
		StatManager.mouse_y_sensitivity = clamp(pending_y_sens, 0.1, 0.9)
		


func _on_options_ok_pressed():
	StatManager.update_volume()
	StatManager.save_options()
	commence_game()




func _on_windowed_button_pressed():
	if windowed_button.button_pressed == true:
		StatManager.window_mode = true
		StatManager.windowed_mode()
	elif windowed_button.button_pressed == false:
		StatManager.window_mode = false
		StatManager.windowed_mode()
	print("it's a me")


func _on_resolution_option_item_selected(index):
	print("reso ", index)


func _on_menu_window_close_requested():
	commence_game()
	
func commence_game():
	menu_window.hide()
	options_menu.hide()
	yesno.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	timer_game.paused = false


func _on_options_menu_close_requested():
	commence_game()


func player_ready():
	timer_game.wait_time = time_limit
	timer_game.start()


func _on_button_pressed():
	#confirmation_dialog.label_text = "Are you sure you want to clear saved stats?"
	yesno.show()


func _on_save_yes_pressed():
	StatManager.clear_save()
	yesno.hide()
	print("clear it")


func _on_save_no_pressed():
	print("don't clear")
	yesno.hide()
	self.hide()


func prep_ui():
	pass


func bye_ui():
	stat_line_enabled = false


func _on_timer_game_timeout():
	StatManager.no_more_time()


func _on_button_end_pressed():
	commence_game()
	StatManager.end_mission()


	
	
	
func _on_ma_volume_drag_ended(value_changed):
	if value_changed:
		pending_ma_volume = ma_volume.value
		StatManager.master_volume = clamp(pending_ma_volume, 0.0, 1.0)


func _on_mu_volume_drag_ended(value_changed):
	if value_changed:
		pending_mu_volume = mu_volume.value
		StatManager.music_volume = clamp(pending_mu_volume, 0.0, 1.0)


func _on_sfx_volume_drag_ended(value_changed):
	if value_changed:
		pending_sfx_volume = sfx_volume.value
		StatManager.sfx_volume = clamp(pending_sfx_volume, 0.0, 1.0)

