extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	StatManager.starting_secrets += 1
	StatManager.update_stats()
	print("secret area ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body is Player:
		SignalBus.secret_entered.emit()
		StatManager.num_secrets += 1
		StatManager.update_stats()
		queue_free()
