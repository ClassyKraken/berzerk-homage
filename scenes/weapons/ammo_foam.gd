extends Area3D

const KILL_TIME = 2
var timer = 0
var speed = 50
@export var damage = 1

func _physics_process(delta):
	var forward_direction = global_transform.basis.z.normalized()
	global_translate(-forward_direction * speed * delta)
	
	timer += delta
	if timer >= KILL_TIME:
		queue_free()


func _on_body_entered(body):
	queue_free()
	if body.is_in_group("Enemy"):
		body.handle_hit()
