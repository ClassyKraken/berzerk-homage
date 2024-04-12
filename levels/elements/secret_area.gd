extends Area3D

var stat_manger

# Called when the node enters the scene tree for the first time.
func _ready():
	stat_manger = get_node("/root/StatManager")
	stat_manger.starting_secrets += 1
	stat_manger.update_stats()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body is Player:
		SignalBus.secret_entered.emit()
		stat_manger.num_secrets -= 1
		stat_manger.update_stats()
		queue_free()
