extends Interactable


# Called when the node enters the scene tree for the first time.
func _ready():
	print("secret ready") # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func interaction_complete() -> void:
	SignalBus.open_secret.emit()
	queue_free()
