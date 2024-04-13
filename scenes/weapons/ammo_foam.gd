extends Area3D

const KILL_TIME = 2
var timer = 0
var speed = 50

@export var damage = 1

@onready var ray_cast_3d = $RayCast3D


func _physics_process(delta):
	var forward_direction = global_transform.basis.z.normalized()
	global_translate(-forward_direction * speed * delta)
	
	if ray_cast_3d.is_colliding():
		var target = ray_cast_3d.get_collider()
		_on_body_entered(target)
	
	timer += delta
	if timer >= KILL_TIME:
		queue_free()



func _on_body_entered(body):
	queue_free()
	if body.has_method("handle_hit"):
		body.handle_hit()
