extends Control

@onready var interaction_progress = $InteractionProgress
@onready var cross_hair = $CrossHair
@onready var timer_interaction: Timer = $InteractionTimer

var time_to_interact = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("interacting", interacting)
	SignalBus.connect("interaction_stopped", interaction_stopped)

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
